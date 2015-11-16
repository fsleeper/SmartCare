using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using System.Web.UI;
using System.Web.Script.Serialization;
using System.IO.Compression;

namespace JsonSpec
{
    public partial class frmMain : Form
    {
        private List<string> _manifestFiles;

        public frmMain()
        {
            InitializeComponent();
        }

        private void btnSelectDirectory_Click(object sender, EventArgs e)
        {
            folderBrowserDialog1.SelectedPath = txtDirectory.Text;

            if (folderBrowserDialog1.ShowDialog() == DialogResult.OK)
                txtDirectory.Text = folderBrowserDialog1.SelectedPath;
        }

        private void btnCancel_Click(object sender, EventArgs e)
        {
            this.Close();
        }

        private void btnGenerate_Click(object sender, EventArgs e)
        {
            _manifestFiles = new List<string>();

            if(lstDirectories.Items.Count < 1)
            {
                MessageBox.Show("First select at least a sub-directory containing the files");
                return;
            }
            if(String.IsNullOrWhiteSpace(txtSaveLocation.Text.Trim()))
            {
                MessageBox.Show("First select a save location");
                return;
            }

            var output = new StringBuilder();
            var bucket = "smartcarerequests";

            var recCount = -1;
            var fileCount = 0;

            foreach(var directory in lstDirectories.Items)
            {

                // Get the length of the parent directory path to remove 
                var directoryInfo = new DirectoryInfo(directory.ToString());
                
                var startIndex = directoryInfo.Parent.FullName.Length + 1;

                var iterator = System.IO.Directory.EnumerateFiles(directory.ToString(), "*.gz", System.IO.SearchOption.AllDirectories);
                var enumerator = iterator.GetEnumerator();
                while (enumerator.MoveNext())
                {
                    recCount++;

                    if (recCount > 250)
                    {
                        recCount = 0;
                        output.Remove(output.Length - 3, 1);
                        output.Append("  ]\r\n}");
                        writeFile(output, ++fileCount);
                    }

                    if (recCount == 0)
                    {
                        output = new StringBuilder();
                        output.Append("{\r\n  \"entries\": [\r\n");
                    }

                    var fullFilename = enumerator.Current;
                    var filename = fullFilename.Substring(startIndex);
                    output.AppendFormat("    {{\"url\":\"s3://{0}/{1}\"}},\r\n", bucket, filename.Replace("\\","/"));

                    CheckJSON(fullFilename);
                }

            }

            if (recCount > 0)
            {
                output.Remove(output.Length - 3, 1);
                output.Append("  ]\r\n}");
                writeFile(output, ++fileCount);
            }


            output = new StringBuilder();
            foreach(var manifestfile in _manifestFiles)
            {
                output.Append("copy rawmobilemetrics\r\n");
                output.AppendFormat("from 's3://smartcarerequests/{0}'\r\n", manifestfile);
                output.Append("credentials 'aws_access_key_id=AKIAINGWZ3T5JEFEN7GQ;aws_secret_access_key=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'\r\n");
                output.Append("manifest\r\n");
                output.Append("json 's3://smartcarerequests/mobilemetricspaths.json'\r\n");
                output.Append("GZIP;\r\n");
                output.Append("\r\n");
                //output.Append("select count(*) from rawmobilemetrics;\r\n");
            }

            txtSQLText.Text = output.ToString();
        }

        private void CheckJSON(string filename)
        {
            var jsonstringcompressed = File.ReadAllBytes(filename);
            var decompressed = Decompress(jsonstringcompressed);
            var jsondata = Encoding.Default.GetString(decompressed);
            var serializer = new JavaScriptSerializer();

            var stringSeparators = new string[] { "\n" };
            var jsonlines = jsondata.Split(stringSeparators, StringSplitOptions.None);
            foreach (var jsonline in jsonlines)
            {
                var json = serializer.Deserialize<object>(jsonline);
            }
        }
        static byte[] Decompress(byte[] gzip)
        {
            // Create a GZIP stream with decompression mode.
            // ... Then create a buffer and write into while reading from the GZIP stream.
            using (var stream = new GZipStream(new MemoryStream(gzip), CompressionMode.Decompress))
            {
                const int size = 4096;
                var buffer = new byte[size];
                using (var memory = new MemoryStream())
                {
                    var count = 0;
                    do
                    {
                        count = stream.Read(buffer, 0, size);
                        if (count > 0)
                        {
                            memory.Write(buffer, 0, count);
                        }
                    }
                    while (count > 0);
                    return memory.ToArray();
                }
            }
        }
        private void writeFile(StringBuilder output, int fileCount)
        {
            var di = new DirectoryInfo(txtSaveLocation.Text);
            var filename = String.Format("loadmanifest{0}.json", fileCount);
            var fullname = String.Format(@"{0}\{1}", di.FullName, filename);
            _manifestFiles.Add(filename);

            var utf8WithoutBom = new UTF8Encoding(false);

            using (StreamWriter sw = new StreamWriter(File.Open(fullname, FileMode.Create), utf8WithoutBom))
            {
                sw.WriteLine(output.ToString());
            }
        }

        private void btnAdd_Click(object sender, EventArgs e)
        {
            var data = txtDirectory.Text.Trim();
            if(!String.IsNullOrWhiteSpace(data))
            {
                lstDirectories.Items.Add(txtDirectory.Text);
            }
        }

        private void lstDirectories_SelectedIndexChanged(object sender, EventArgs e)
        {
            txtDirectory.Text = lstDirectories.Items[lstDirectories.SelectedIndex].ToString();
            lstDirectories.Items.RemoveAt(lstDirectories.SelectedIndex);
        }

        private void btnSaveLocation_Click(object sender, EventArgs e)
        {
            folderBrowserDialog1.SelectedPath = txtSaveLocation.Text;

            if (folderBrowserDialog1.ShowDialog() == DialogResult.OK)
                txtSaveLocation.Text = folderBrowserDialog1.SelectedPath;
        }
    }
}
