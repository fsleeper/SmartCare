namespace CheckDomoExtract.JSONFormat
{
    public class DynamoDBWrapper
    {
        public RootObject Context;
        public TokenObject Token;
        public TimeStampObject Timestamp;
        public string name { get; set; }
        public string version { get; set; }
    }
}