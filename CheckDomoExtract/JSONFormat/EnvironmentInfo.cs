using System;

namespace CheckDomoExtract.JSONFormat
{
    public class EnvironmentInfo
    {
        private string _s1;
        private string _s2;
        private string _s3;
        private string _s4;
        private string _s5;
        private string _s6;
        public string country
        {
            get { return _s1; }
            set { _s1 = value; if (value != null && maxLengthCountry < value.Length) maxLengthCountry = value.Length; }
        }
        public string language
        {
            get { return _s2; }
            set { _s2 = value; if (value != null && maxLengthLanguage < value.Length) maxLengthLanguage = value.Length; }
        }
        public string modelName
        {
            get { return _s3; }
            set { _s3 = value; if (value != null && maxLengthName < value.Length) maxLengthName = value.Length; }
        }
        public string os_version
        {
            get { return _s4; }
            set { _s4 = value; if (value != null && maxLengthVersion < value.Length) maxLengthVersion = value.Length; }
        }
        public int? timeZoneOffset { get; set; }
        public string region
        {
            get { return _s5; }
            set { _s5 = value; if (value != null && maxLengthRegion < value.Length) maxLengthRegion = value.Length; }
        }
        public string device_id
        {
            get { return _s6; }
            set { _s6 = value; if (value != null && maxLengthDevice < value.Length) maxLengthDevice = value.Length; }
        }
        public static int maxLengthCountry = 0;
        public static int maxLengthLanguage = 0;
        public static int maxLengthName = 0;
        public static int maxLengthVersion = 0;
        public static int maxLengthRegion = 0;
        public static int maxLengthDevice = 0;

        public static string TableLine(string preface)
        {
            return String.Format("{0}country VARCHAR({1})\n", preface, maxLengthCountry) +
                   String.Format("{0}language VARCHAR({1})\n", preface, maxLengthLanguage) +
                   String.Format("{0}modelName VARCHAR({1})\n", preface, maxLengthName) +
                   String.Format("{0}os_version VARCHAR({1})\n", preface, maxLengthVersion) +
                   String.Format("{0}timeZoneOffset bigint\n", preface) +
                   String.Format("{0}region VARCHAR({1})\n", preface, maxLengthRegion) +
                   String.Format("{0}device_id VARCHAR({1})\n", preface, maxLengthDevice);

        }
    }
}