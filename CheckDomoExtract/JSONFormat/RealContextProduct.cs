using System;

namespace CheckDomoExtract.JSONFormat
{
    public class RealContextProduct : BaseContext
    {
        private string _s1;
        private string _s2;
        public Product2 Product { get; set; }
        public string Key
        {
            get { return _s1; }
            set { _s1 = value; if (value != null && maxLengthKey < value.Length) maxLengthKey = value.Length; }
        }
        public string CreateDate
        {
            get { return _s2; }
            set { _s2 = value; if (value != null && maxLengthDate < value.Length) maxLengthDate = value.Length; }
        }

        public static int maxLengthKey = 0;
        public static int maxLengthDate = 0;

        public static string TableLine(string preface)
        {
            return BaseContext.TableLine(preface) +
                   Product2.TableLine("productSet_") +
                   String.Format("{0}Key VARCHAR({1})\n", preface, maxLengthKey) +
                   String.Format("{0}CreateDate VARCHAR({1})\n", preface, maxLengthDate);
        }
    }
}