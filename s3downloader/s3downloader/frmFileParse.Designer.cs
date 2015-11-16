namespace s3downloader
{
    partial class frmFileParse
    {
        /// <summary>
        /// Required designer variable.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        /// Clean up any resources being used.
        /// </summary>
        /// <param name="disposing">true if managed resources should be disposed; otherwise, false.</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Windows Form Designer generated code

        /// <summary>
        /// Required method for Designer support - do not modify
        /// the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent()
        {
            this.btnParse = new System.Windows.Forms.Button();
            this.label1 = new System.Windows.Forms.Label();
            this.label2 = new System.Windows.Forms.Label();
            this.lblSBSFiles = new System.Windows.Forms.Label();
            this.lblSongPalFiles = new System.Windows.Forms.Label();
            this.backgroundWorker1 = new System.ComponentModel.BackgroundWorker();
            this.lblgetProduct = new System.Windows.Forms.Label();
            this.label4 = new System.Windows.Forms.Label();
            this.label5 = new System.Windows.Forms.Label();
            this.lblgetHome = new System.Windows.Forms.Label();
            this.label3 = new System.Windows.Forms.Label();
            this.lblgetSolutions = new System.Windows.Forms.Label();
            this.label7 = new System.Windows.Forms.Label();
            this.lblgetCategories = new System.Windows.Forms.Label();
            this.btnSBS = new System.Windows.Forms.Button();
            this.btnSongPal = new System.Windows.Forms.Button();
            this.lblSBSCount = new System.Windows.Forms.Label();
            this.lblSongPalCount = new System.Windows.Forms.Label();
            this.SuspendLayout();
            // 
            // btnParse
            // 
            this.btnParse.Location = new System.Drawing.Point(32, 35);
            this.btnParse.Name = "btnParse";
            this.btnParse.Size = new System.Drawing.Size(96, 43);
            this.btnParse.TabIndex = 0;
            this.btnParse.Text = "Parse";
            this.btnParse.UseVisualStyleBackColor = true;
            this.btnParse.Click += new System.EventHandler(this.btnParse_Click);
            // 
            // label1
            // 
            this.label1.AutoSize = true;
            this.label1.Location = new System.Drawing.Point(32, 113);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(95, 26);
            this.label1.TabIndex = 1;
            this.label1.Text = "SongPal";
            // 
            // label2
            // 
            this.label2.AutoSize = true;
            this.label2.Location = new System.Drawing.Point(413, 113);
            this.label2.Name = "label2";
            this.label2.Size = new System.Drawing.Size(57, 26);
            this.label2.TabIndex = 2;
            this.label2.Text = "SBS";
            // 
            // lblSBSFiles
            // 
            this.lblSBSFiles.AutoSize = true;
            this.lblSBSFiles.Location = new System.Drawing.Point(414, 149);
            this.lblSBSFiles.Name = "lblSBSFiles";
            this.lblSBSFiles.Size = new System.Drawing.Size(24, 26);
            this.lblSBSFiles.TabIndex = 4;
            this.lblSBSFiles.Text = "0";
            // 
            // lblSongPalFiles
            // 
            this.lblSongPalFiles.AutoSize = true;
            this.lblSongPalFiles.Location = new System.Drawing.Point(33, 149);
            this.lblSongPalFiles.Name = "lblSongPalFiles";
            this.lblSongPalFiles.Size = new System.Drawing.Size(24, 26);
            this.lblSongPalFiles.TabIndex = 3;
            this.lblSongPalFiles.Text = "0";
            // 
            // backgroundWorker1
            // 
            this.backgroundWorker1.WorkerReportsProgress = true;
            this.backgroundWorker1.WorkerSupportsCancellation = true;
            this.backgroundWorker1.DoWork += new System.ComponentModel.DoWorkEventHandler(this.backgroundWorker1_DoWork);
            this.backgroundWorker1.ProgressChanged += new System.ComponentModel.ProgressChangedEventHandler(this.backgroundWorker1_ProgressChanged);
            this.backgroundWorker1.RunWorkerCompleted += new System.ComponentModel.RunWorkerCompletedEventHandler(this.backgroundWorker1_RunWorkerCompleted);
            // 
            // lblgetProduct
            // 
            this.lblgetProduct.AutoSize = true;
            this.lblgetProduct.Location = new System.Drawing.Point(170, 187);
            this.lblgetProduct.Name = "lblgetProduct";
            this.lblgetProduct.Size = new System.Drawing.Size(24, 26);
            this.lblgetProduct.TabIndex = 5;
            this.lblgetProduct.Text = "0";
            // 
            // label4
            // 
            this.label4.AutoSize = true;
            this.label4.Location = new System.Drawing.Point(33, 187);
            this.label4.Name = "label4";
            this.label4.Size = new System.Drawing.Size(117, 26);
            this.label4.TabIndex = 6;
            this.label4.Text = "getProduct";
            // 
            // label5
            // 
            this.label5.AutoSize = true;
            this.label5.Location = new System.Drawing.Point(33, 228);
            this.label5.Name = "label5";
            this.label5.Size = new System.Drawing.Size(101, 26);
            this.label5.TabIndex = 8;
            this.label5.Text = "getHome";
            // 
            // lblgetHome
            // 
            this.lblgetHome.AutoSize = true;
            this.lblgetHome.Location = new System.Drawing.Point(170, 228);
            this.lblgetHome.Name = "lblgetHome";
            this.lblgetHome.Size = new System.Drawing.Size(24, 26);
            this.lblgetHome.TabIndex = 7;
            this.lblgetHome.Text = "0";
            // 
            // label3
            // 
            this.label3.AutoSize = true;
            this.label3.Location = new System.Drawing.Point(413, 228);
            this.label3.Name = "label3";
            this.label3.Size = new System.Drawing.Size(132, 26);
            this.label3.TabIndex = 12;
            this.label3.Text = "getSolutions";
            // 
            // lblgetSolutions
            // 
            this.lblgetSolutions.AutoSize = true;
            this.lblgetSolutions.Location = new System.Drawing.Point(566, 228);
            this.lblgetSolutions.Name = "lblgetSolutions";
            this.lblgetSolutions.Size = new System.Drawing.Size(24, 26);
            this.lblgetSolutions.TabIndex = 11;
            this.lblgetSolutions.Text = "0";
            // 
            // label7
            // 
            this.label7.AutoSize = true;
            this.label7.Location = new System.Drawing.Point(413, 187);
            this.label7.Name = "label7";
            this.label7.Size = new System.Drawing.Size(147, 26);
            this.label7.TabIndex = 10;
            this.label7.Text = "getCategories";
            // 
            // lblgetCategories
            // 
            this.lblgetCategories.AutoSize = true;
            this.lblgetCategories.Location = new System.Drawing.Point(566, 187);
            this.lblgetCategories.Name = "lblgetCategories";
            this.lblgetCategories.Size = new System.Drawing.Size(24, 26);
            this.lblgetCategories.TabIndex = 9;
            this.lblgetCategories.Text = "0";
            // 
            // btnSBS
            // 
            this.btnSBS.Location = new System.Drawing.Point(37, 317);
            this.btnSBS.Name = "btnSBS";
            this.btnSBS.Size = new System.Drawing.Size(257, 43);
            this.btnSBS.TabIndex = 13;
            this.btnSBS.Text = "Get FileInfo List SBS";
            this.btnSBS.UseVisualStyleBackColor = true;
            this.btnSBS.Click += new System.EventHandler(this.btnSBS_Click);
            // 
            // btnSongPal
            // 
            this.btnSongPal.Location = new System.Drawing.Point(300, 317);
            this.btnSongPal.Name = "btnSongPal";
            this.btnSongPal.Size = new System.Drawing.Size(299, 43);
            this.btnSongPal.TabIndex = 14;
            this.btnSongPal.Text = "Get FileInfo List SongPal";
            this.btnSongPal.UseVisualStyleBackColor = true;
            this.btnSongPal.Click += new System.EventHandler(this.btnSongPal_Click);
            // 
            // lblSBSCount
            // 
            this.lblSBSCount.AutoSize = true;
            this.lblSBSCount.Location = new System.Drawing.Point(38, 367);
            this.lblSBSCount.Name = "lblSBSCount";
            this.lblSBSCount.Size = new System.Drawing.Size(24, 26);
            this.lblSBSCount.TabIndex = 15;
            this.lblSBSCount.Text = "0";
            // 
            // lblSongPalCount
            // 
            this.lblSongPalCount.AutoSize = true;
            this.lblSongPalCount.Location = new System.Drawing.Point(295, 367);
            this.lblSongPalCount.Name = "lblSongPalCount";
            this.lblSongPalCount.Size = new System.Drawing.Size(24, 26);
            this.lblSongPalCount.TabIndex = 16;
            this.lblSongPalCount.Text = "0";
            // 
            // frmFileParse
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(12F, 25F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(1105, 704);
            this.Controls.Add(this.lblSongPalCount);
            this.Controls.Add(this.lblSBSCount);
            this.Controls.Add(this.btnSongPal);
            this.Controls.Add(this.btnSBS);
            this.Controls.Add(this.label3);
            this.Controls.Add(this.lblgetSolutions);
            this.Controls.Add(this.label7);
            this.Controls.Add(this.lblgetCategories);
            this.Controls.Add(this.label5);
            this.Controls.Add(this.lblgetHome);
            this.Controls.Add(this.label4);
            this.Controls.Add(this.lblgetProduct);
            this.Controls.Add(this.lblSBSFiles);
            this.Controls.Add(this.lblSongPalFiles);
            this.Controls.Add(this.label2);
            this.Controls.Add(this.label1);
            this.Controls.Add(this.btnParse);
            this.Name = "frmFileParse";
            this.Text = "frmFileParse";
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.Button btnParse;
        private System.Windows.Forms.Label label1;
        private System.Windows.Forms.Label label2;
        private System.Windows.Forms.Label lblSBSFiles;
        private System.Windows.Forms.Label lblSongPalFiles;
        private System.ComponentModel.BackgroundWorker backgroundWorker1;
        private System.Windows.Forms.Label lblgetProduct;
        private System.Windows.Forms.Label label4;
        private System.Windows.Forms.Label label5;
        private System.Windows.Forms.Label lblgetHome;
        private System.Windows.Forms.Label label3;
        private System.Windows.Forms.Label lblgetSolutions;
        private System.Windows.Forms.Label label7;
        private System.Windows.Forms.Label lblgetCategories;
        private System.Windows.Forms.Button btnSBS;
        private System.Windows.Forms.Button btnSongPal;
        private System.Windows.Forms.Label lblSBSCount;
        private System.Windows.Forms.Label lblSongPalCount;
    }
}