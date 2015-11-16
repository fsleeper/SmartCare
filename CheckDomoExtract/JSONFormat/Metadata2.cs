using System;

namespace CheckDomoExtract.JSONFormat
{
    public class Metadata2
    {
        private string _s1;
        public string DeviceSetupScenario
        {
            get { return _s1; }
            set { _s1 = value; if (value != null && maxLength < value.Length) maxLength = value.Length; }
        }

        public static int maxLength = 0;
        public static string TableLine(string preface)
        {
            return String.Format("{0}DeviceSetupScenario VARCHAR({1})\n", preface, maxLength);
        }
    }
}