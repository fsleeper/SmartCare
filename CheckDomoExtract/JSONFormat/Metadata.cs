using System;

namespace CheckDomoExtract.JSONFormat
{
    public class Metadata
    {
        public string connected { get; set; }
        public static string TableLine(string preface)
        {
            return String.Format("{0}connected varchar(5)\n", preface);
        }
    }
}