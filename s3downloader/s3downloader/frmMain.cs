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
using Amazon.S3;
using Amazon.S3.Model;
using Newtonsoft.Json;

namespace s3downloader
{
    public partial class frmMain : Form
    {
        AmazonS3Client S3Client;
        BackgroundWorker regionLoadWorker;
        BackgroundWorker bucketLoadWorker;
        S3Bucket currentBucket;

        public frmMain()
        {
            InitializeComponent();
            var selidx = 0;

            foreach (var endpoint in Amazon.RegionEndpoint.EnumerableAllRegions)
            {
                var idx = cmbRegions.Items.Add(endpoint);
                if (endpoint == Amazon.RegionEndpoint.USWest2)
                    selidx = idx;
            }

            cmbRegions.SelectedIndex = selidx;

            //cmbRegions.Text = "[USWest2] US West (Oregon)";
        }

        private void btnParse_Click(object sender, EventArgs e)
        {
            var frm = new frmFileParse();
            frm.ShowDialog();
        }

        private Amazon.RegionEndpoint GetSelectedRegion()
        {
            return (Amazon.RegionEndpoint)cmbRegions.SelectedItem;
        }

        private void btnLoad_Click(object sender, EventArgs e)
        {
            tvwBuckets.Enabled = false;
            toolStripStatusLabel1.Text = "Loading...";
            tvwBuckets.Nodes.Clear();

            regionLoadWorker = new BackgroundWorker();
            regionLoadWorker.WorkerReportsProgress = true;
            regionLoadWorker.WorkerSupportsCancellation = true;
            regionLoadWorker.RunWorkerCompleted += RegionLoadWorker_RunWorkerCompleted;
            regionLoadWorker.ProgressChanged += RegionLoadWorker_ProgressChanged;
            regionLoadWorker.DoWork += RegionLoadWorker_DoWork;
            regionLoadWorker.RunWorkerAsync(GetSelectedRegion());
        }

        private void RegionLoadWorker_DoWork(object sender, DoWorkEventArgs e)
        {
            try
            {
                var region = (Amazon.RegionEndpoint)e.Argument;
                LoadBuckets(region);
            }
            catch (Exception ex)
            {
            }
        }
        private void RegionLoadWorker_ProgressChanged(object sender, ProgressChangedEventArgs e)
        {
            var node = tvwBuckets.Nodes.Add(((S3Bucket)e.UserState).BucketName);
            node.Tag = (S3Bucket)e.UserState;
            node.Nodes.Add("Loading...");
        } 

        private void RegionLoadWorker_RunWorkerCompleted(object sender, RunWorkerCompletedEventArgs e)
        {
            toolStripStatusLabel1.Text = "Ready...";
            tvwBuckets.Enabled = true;
        }

        private void LoadBuckets(Amazon.RegionEndpoint region)
        {
            S3Client = new AmazonS3Client(region);

            var response = S3Client.ListBuckets();

            foreach (var bucket in response.Buckets)
            {
                regionLoadWorker.ReportProgress(1, bucket);
            }
        }
        private void LoadFiles(S3Bucket bucket)
        {
            currentBucket = bucket;
            var request = new ListObjectsRequest();
            request.BucketName = bucket.BucketName;
            var response = S3Client.ListObjects(request);

            // get the objects at the TOP LEVEL, i.e. not inside any folders
            var filesOnly = response.S3Objects.Where(o => !o.Key.Contains(@"/"));

            // get the folders at the TOP LEVEL only
            var folders = response.S3Objects.Except(filesOnly)
                                  .Where(o => o.Key.Last() == '/' &&
                                              o.Key.IndexOf(@"/") == o.Key.LastIndexOf(@"/"));

            foreach (var s3object in folders)
            {
                bucketLoadWorker.ReportProgress(1, s3object);
            }
            foreach (var s3object in filesOnly)
            {
                bucketLoadWorker.ReportProgress(2, s3object);
            }
        }

        private void LoadFiles(string path)
        {
            // OK, from here we need to find the owning bucket, so work up stream until we find it
            // OK, we are at the top, this has the bucket so point to it
            var request = new ListObjectsRequest();
            request.BucketName = currentBucket.BucketName;
            request.Prefix = path;
            var response = S3Client.ListObjects(request);

            // get the objects at the TOP LEVEL, i.e. not inside any folders
            var filesOnly = response.S3Objects.Where(o => !o.Key.Contains(@"/"));

            // get the folders at the current level only
            var folders = response.S3Objects.Except(filesOnly).Where(o => o.Key != path);

            foreach (var s3object in folders)
            {
                bucketLoadWorker.ReportProgress(1, s3object);
            }
            foreach (var s3object in filesOnly)
            {
                bucketLoadWorker.ReportProgress(2, s3object);
            }
        }

        private void frmMain_Load(object sender, EventArgs e)
        {

        }

        private void tvwBuckets_AfterSelect(object sender, TreeViewEventArgs e)
        {

        }

        private void bucketLoadWorker_DoWork(object sender, DoWorkEventArgs e)
        {
            if (e.Argument is S3Bucket)
            {
                e.Result = e.Argument;

                var bucket = (S3Bucket)e.Argument;
                LoadFiles(bucket);
            }
            else
            {
                LoadFiles((string)e.Argument);
            }
        }

        private void bucketLoadWorker_ProgressChanged(object sender, ProgressChangedEventArgs e)
        {
            if(e.ProgressPercentage == 2)
            {
                lstFiles.Items.Add(((S3Object)e.UserState).Key);
            }
            else
            {
                // OK, so this is a folder.  For the name in the node we want to remove everything except the name
                // Then we want to put the full path (key) in the tag
                var data = ((S3Object)e.UserState).Key;

                var node = tvwBuckets.SelectedNode.Nodes.Add(new DirectoryInfo(data).Name);
                node.Tag = ((S3Object)e.UserState).Key;
                node.Nodes.Add("Loading...");
            }
        }

        private void bucketLoadWorker_RunWorkerCompleted(object sender, RunWorkerCompletedEventArgs e)
        {
            toolStripStatusLabel1.Text = "Ready...";
        }

        private void tvwBuckets_BeforeExpand(object sender, TreeViewCancelEventArgs e)
        {
            toolStripStatusLabel1.Text = "Loading...";
            tvwBuckets.SelectedNode.Nodes.Clear();
            lstFiles.Items.Clear();
            bucketLoadWorker = new BackgroundWorker();
            bucketLoadWorker.WorkerReportsProgress = true;
            bucketLoadWorker.WorkerSupportsCancellation = true;
            bucketLoadWorker.RunWorkerCompleted += bucketLoadWorker_RunWorkerCompleted;
            bucketLoadWorker.ProgressChanged += bucketLoadWorker_ProgressChanged;
            bucketLoadWorker.DoWork += bucketLoadWorker_DoWork;
            bucketLoadWorker.RunWorkerAsync(e.Node.Tag);
        }
    }
}
