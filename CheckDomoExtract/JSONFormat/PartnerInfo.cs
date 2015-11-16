using System;

namespace CheckDomoExtract.JSONFormat
{
    public class PartnerInfo
    {
        private string _s1;
        public string partnerId
        {
            get { return _s1; }
            set { _s1 = value; if (value != null && maxLength < value.Length) maxLength = value.Length; }
        }

        public static int maxLength = 0;

        public static string TableLine(string preface)
        {
            return String.Format("{0}partnerId VARCHAR({1})\n", preface, maxLength);
        }
    }
}