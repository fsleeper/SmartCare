using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Diagnostics;
using System.Drawing;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using Newtonsoft.Json.Linq;
using Amazon.S3;
using Amazon.S3.Model;
using Amazon.Runtime;

namespace s3downloader
{
    public partial class frmFileParse : Form
    {
        AmazonS3Client S3Client;

        const string SongPalID = "3fc1ee35-a08a-49ef-8adf-b150010441e4";
        const string SBSID = "c465c49e-4f13-49e9-af8d-1eabfb4087dc";

        int numSongPalFiles = 0;
        int numSBSFiles = 0;
        int getProduct;
        int getHome;
        int getCategories;
        int getSolutions;

        enum SourceType
        {
            SongPal,
            SBS
        }

        public frmFileParse()
        {
            InitializeComponent();
        }

        private void btnParse_Click(object sender, EventArgs e)
        {
            this.Text = "RUNNING";
            backgroundWorker1.RunWorkerAsync();
        }

        private void backgroundWorker1_DoWork(object sender, DoWorkEventArgs e)
        {
            var directories = new[] { SongPalID, SBSID };

            numSongPalFiles = 0;
            numSBSFiles = 0;
            getProduct = 0;
            getHome = 0;
            getCategories = 0;
            getSolutions = 0;

            foreach (var directory in directories)
            {
                var sourceType = (directory == SBSID) ? SourceType.SBS : SourceType.SongPal;

                var songpalRecords = new List<string>();
                var sbsRecords = new List<string>();

                var directoryPath = String.Format(@"C:\Downloads\logs-concierge-prod\{0}", directory);

                if (!Directory.Exists(directoryPath))
                    continue;

                // \\Mac\Home\Downloads\server-analytics-data
                foreach (var file in Directory.EnumerateFiles(directoryPath))
                {
                    var data = File.ReadAllText(file);
                    var createDate = File.GetCreationTime(file);
                    dynamic json = JsonConvert.DeserializeObject(data);
                    json.createDate = createDate.ToString();

                    if (sourceType == SourceType.SongPal)
                    {
                        songpalRecords.Add(json.ToString());

                        numSongPalFiles++;

                        if (json.productSet == null)
                            getProduct++;
                        else
                            getHome++;
                    }
                    else
                    {
                        sbsRecords.Add(json.ToString());

                        numSBSFiles++;

                        if (json.pagination == null)
                            getCategories++;
                        else
                            getSolutions++;
                    }

                    
                    var errors = CheckSchema(json);
                    if (errors.Count > 0)
                        Debug.WriteLine("FAIL");
                    else
                        Debug.WriteLine("Success");
                    
                    backgroundWorker1.ReportProgress(1);
                }
                var path1 = @"\\Mac\Home\Downloads\songpalfile2.json"; // path to file
                using (var fs = File.Create(path1))
                {
                    foreach (var record in songpalRecords)
                    {
                        byte[] info = new UTF8Encoding(true).GetBytes(record + "\n");
                        fs.Write(info, 0, info.Length);
                    }
                }

                var path = @"\\Mac\Home\Downloads\sbsfile2.json"; // path to file
                using (var fs = File.Create(path))
                {
                    foreach (var record in sbsRecords)
                    {
                        byte[] info = new UTF8Encoding(true).GetBytes(record + "\n");
                        fs.Write(info, 0, info.Length);
                    }
                }

            }
        }
        
        private List<string> CheckSchema(dynamic json)
        {
            var data = (JObject)json;
            var errors = new List<string>();

            var values = data.Values();
            foreach(var value in values)
            {
                switch (value.Path)
                {
                    case "createDate": break;
                    case "cameraInfo":
                        {
                            var subValues = value.Values();
                            foreach (var subValue in subValues)
                            {
                                switch (subValue.Path)
                                {
                                    case "cameraInfo.cameraCategory": break;
                                    case "cameraInfo.firmwareVersion": break;
                                    case "cameraInfo.lensFirmwareVersion": break;
                                    case "cameraInfo.lensModel": break;
                                    case "cameraInfo.modelName": break;
                                    case "cameraInfo.platformVersion": break;
                                    case "cameraInfo.pmcaInfo": break;
                                    case "cameraInfo.settingInfo": break;
                                    case "cameraInfo.shootingMode": break;
                                    default:
                                        errors.Add(String.Format("Found unknown key of {0}", subValue.Path));
                                        break;
                                }
                            }
                            break;
                        }

                    case "productInfo":
                        {
                            var subValues = value.Values();
                            foreach (var subValue in subValues)
                            {
                                switch (subValue.Path)
                                {
                                    case "productInfo.modelName": break;
                                    case "productInfo.model": break;
                                    default:
                                        errors.Add(String.Format("Found unknown key of {0}", subValue.Path));
                                        break;
                                }
                            }
                            break;
                        }
                    case "partnerInfo":
                        {
                            var subValues = value.Values();
                            foreach (var subValue in subValues)
                            {
                                switch (subValue.Path)
                                {
                                    case "partnerInfo.partnerId": break;
                                    default:
                                        errors.Add(String.Format("Found unknown key of {0}", subValue.Path));
                                        break;
                                }
                            }
                            break;
                        }
                    case "appInfo":
                        {
                            var subValues = value.Values();
                            foreach (var subValue in subValues)
                            {
                                switch (subValue.Path)
                                {
                                    case "appInfo.name": break;
                                    case "appInfo.version": break;
                                    case "appInfo.build_platform": break;
                                    case "appInfo.metadata":
                                        {
                                            var sub2Values = subValue.Values();
                                            foreach (var sub2Value in sub2Values)
                                            {
                                                switch (sub2Value.Path)
                                                {
                                                    case "appInfo.metadata.DeviceSetupScenario": break;
                                                    default:
                                                        errors.Add(String.Format("Found unknown key of {0}", sub2Value.Path));
                                                        break;
                                                }
                                            }
                                        }
                                        break;
                                    default:
                                        errors.Add(String.Format("Found unknown key of {0}", subValue.Path));
                                        break;
                                }
                            }
                        }
                        break;
                    case "environmentInfo":
                        {
                            var subValues = value.Values();
                            foreach (var subValue in subValues)
                            {
                                switch (subValue.Path)
                                {
                                    case "environmentInfo.country": break;
                                    case "environmentInfo.language": break;
                                    case "environmentInfo.modelName": break;
                                    case "environmentInfo.os_version": break;
                                    case "environmentInfo.timeZoneOffset": break;
                                    case "environmentInfo.region": break;
                                    case "environmentInfo.device_id": break;
                                    default:
                                        errors.Add(String.Format("Found unknown key of {0}", subValue.Path));
                                        break;
                                }
                            }
                        }
                        break;
                    case "pagination":
                        {
                            var subValues = value.Values();
                            foreach (var subValue in subValues)
                            {
                                switch (subValue.Path)
                                {
                                    case "pagination.category_id": break;
                                    case "pagination.count": break;
                                    case "pagination.filter": break;
                                    case "pagination.start": break;
                                    default:
                                        errors.Add(String.Format("Found unknown key of {0}", subValue.Path));
                                        break;
                                }
                            }
                        }

                        break;
                    case "productSet":
                        {
                            var subValues = value.Values();
                            foreach (var subValue in subValues)
                            {
                                switch (subValue.Path)
                                {
                                    case "productSet.products":
                                        var productsArray = subValue.AsEnumerable();
                                        foreach(var product in productsArray)
                                        {
                                            var sub2Values = product.Values();
                                            foreach (var sub2Value in sub2Values)
                                            {
                                                if (sub2Value.Path.EndsWith(".modelName"))
                                                    continue;
                                                if (sub2Value.Path.EndsWith(".metadata"))
                                                {
                                                    var sub3Values = sub2Value.Values();
                                                    foreach (var sub3Value in sub3Values)
                                                    {
                                                        if (sub3Value.Path.EndsWith(".connected"))
                                                            continue;
                                                        errors.Add(String.Format("Found unknown key of {0}", sub2Value.Path));
                                                    }
                                                }
                                                else
                                                    errors.Add(String.Format("Found unknown key of {0}", sub2Value.Path));
                                            }
                                        }
                                        break;
                                    default:
                                        errors.Add(String.Format("Found unknown key of {0}", subValue.Path));
                                        break;
                                }
                            }
                        }
                        break;
                    default:
                        errors.Add(String.Format("Found unknown key of {0}", value.Path));
                        break;
                }
            }

            return errors;
        }

        private void backgroundWorker1_ProgressChanged(object sender, ProgressChangedEventArgs e)
        {
            lblSBSFiles.Text = numSBSFiles.ToString();
            lblSongPalFiles.Text = numSongPalFiles.ToString();
            lblgetProduct.Text = getProduct.ToString();
            lblgetSolutions.Text = getSolutions.ToString();
            lblgetHome.Text = getHome.ToString();
            lblgetCategories.Text = getCategories.ToString();
        }

        private void backgroundWorker1_RunWorkerCompleted(object sender, RunWorkerCompletedEventArgs e)
        {
            this.Text = "DONE";            
        }

        private void btnSongPal_Click(object sender, EventArgs e)
        {
            DownloadFolder(SongPalID, lblSongPalCount);
        }

        private void WriteToFile(List<string> names, string folder)
        {
            var path = String.Format(@"C:\temp\file-{0}.txt", folder);

            if (!File.Exists(path))
            {
                // Create a file to write to.
                using (StreamWriter sw = File.CreateText(path))
                {
                }
            }

            // This text is always added, making the file longer over time
            // if it is not deleted.
            using (StreamWriter sw = File.AppendText(path))
            {
                foreach(var line in names)
                {
                    sw.WriteLine(line);
                }
            }
        }

        private void DownloadFolder(string folder, Label label)
        {
            var region = Amazon.RegionEndpoint.USEast1;
            var credentials = new BasicAWSCredentials("AKIAI6FLMSLBSLE4YBKQ", "l3sIAyIAvSqsg+uWbwmnD8MgHoaDeDHs2tOyVbYT");

            S3Client = new AmazonS3Client(credentials, region);

            var count = 0;
            label.Text = count.ToString();
            var request = new ListObjectsRequest
            {
                BucketName = "logs-concierge-prod",
                Prefix = folder,
                MaxKeys = 1000
            };


            var response = S3Client.ListObjects(request);

            while (response.S3Objects.Count > 0)
            {
                count += response.S3Objects.Count;
                label.Text = count.ToString();
                response = S3Client.ListObjects(request);

                var lines = new List<string>();
                var startPoint = "";

                foreach (var item in response.S3Objects)
                {
                    lines.Add(String.Format("{0}\t{1}\t{2}", item.Key, item.Size, item.LastModified));
                    startPoint = item.Key;
                }

                request.Marker = startPoint;
                WriteToFile(lines, folder);
            }

            label.Text = count.ToString();
        }

        private void btnSBS_Click(object sender, EventArgs e)
        {
            DownloadFolder(SBSID, lblSBSCount);
        }
    }
}
