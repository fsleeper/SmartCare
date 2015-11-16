using System;

namespace CheckDomoExtract.JSONFormat
{
    public class Product2
    {
        private string _s1;
        private string _s2;
        public string ProductName
        {
            get { return _s1; }
            set { _s1 = value; if (value != null && maxLengthName < value.Length) maxLengthName = value.Length; }
        }
        public string ProductNameNormalized
        {
            get { return _s2; }
            set { _s2 = value; if (value != null && maxLengthNormalized < value.Length) maxLengthNormalized = value.Length; }
        }
        public static string TableLine(string preface)
        {
            return String.Format("{0}ProductName VARCHAR({1})\n", preface, maxLengthName) +
                   String.Format("{0}ProductNameNormalized VARCHAR({1})\n", preface, maxLengthNormalized);
        }
        public static int maxLengthName = 0;
        public static int maxLengthNormalized = 0;
    }
}