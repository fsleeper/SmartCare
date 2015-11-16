using System;

namespace CheckDomoExtract.JSONFormat
{
    public class AppInfo
    {
        private string _s1;
        private string _s2;
        private string _s3;

        public string build_platform
        {
            get { return _s1; }
            set { _s1 = value; if (value != null && maxLengthPlatform < value.Length) maxLengthPlatform = value.Length; }
        }
        public string name
        {
            get { return _s2; }
            set { _s2 = value; if (value != null && maxLengthName < value.Length) maxLengthName = value.Length; }
        }
        public string version
        {
            get { return _s3; }
            set { _s3 = value; if (value != null && maxLengthVersion < value.Length) maxLengthVersion = value.Length; }
        }
        public Metadata2 metadata { get; set; }

        public static int maxLengthPlatform = 0;
        public static int maxLengthName = 0;
        public static int maxLengthVersion = 0;
        public static string TableLine(string preface)
        {
            return String.Format("{0}build_platform VARCHAR({1})\n", preface, maxLengthPlatform) +
                   String.Format("{0}name VARCHAR({1})\n", preface, maxLengthName) +
                   String.Format("{0}version VARCHAR({1})\n", preface, maxLengthVersion) +
                   Metadata2.TableLine(String.Format("{0}metadata_", preface));

        }
    }
}