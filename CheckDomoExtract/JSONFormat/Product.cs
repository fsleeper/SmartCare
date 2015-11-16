using System;

namespace CheckDomoExtract.JSONFormat
{
    public class Product
    {
        private string _s1;
        private string _s2;
        private string _s3;
        public Metadata metadata { get; set; }
        public string modelName
        {
            get { return _s1; }
            set { _s1 = value; if (value != null && maxLengthModelName < value.Length) maxLengthModelName = value.Length; }
        }
        public string name
        {
            get { return _s2; }
            set { _s2 = value; if (value != null && maxLengthName < value.Length) maxLengthName = value.Length; }
        }
        public string id
        {
            get { return _s3; }
            set { _s3 = value; if (value != null && maxLengthId < value.Length) maxLengthId = value.Length; }
        }
        public static int maxLengthModelName = 0;
        public static int maxLengthName = 0;
        public static int maxLengthId = 0;
        public static string TableLine(string preface)
        {
            return String.Format("{0}modelName VARCHAR({1})\n", preface, maxLengthModelName) +
                   String.Format("{0}name VARCHAR({1})\n", preface, maxLengthName) +
                   String.Format("{0}id VARCHAR({1})\n", preface, maxLengthId) +
                   Metadata.TableLine(String.Format("{0}metadata_", preface));
        }
    }
}