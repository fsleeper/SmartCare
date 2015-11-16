using System;
using System.Data;
using System.Data.Odbc;
using System.Data.SqlClient;
using System.Windows.Forms;

namespace ConvertExceltoCSV
{
    public partial class frmMain : Form
    {
        public frmMain()
        {
            InitializeComponent();
        }

        private void btnSelectFile_Click(object sender, EventArgs e)
        {
            saveFileDialog1.FileName = txtExportFile.Text;
            if(saveFileDialog1.ShowDialog() == DialogResult.OK)
            {
                txtExportFile.Text = saveFileDialog1.FileName;
            }
        }

        private void btnGO_Click(object sender, EventArgs e)
        {
            
            var conn = new RototypeIntl.Database.OleDbConnector("Dsn = callcenter");
            conn.OpenConnection();

            var dt = new DataTable();
            conn.Read("SELECT * FROM `Sheet1$_xlnm#_FilterDatabase`", out dt);

        }
    }
}
