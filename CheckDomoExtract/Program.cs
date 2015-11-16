using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;

namespace CheckDomoExtract
{
    class Program
    {
        static void Main(string[] args)
        {
            var utf8WithoutBom = new UTF8Encoding(false);

            var lineno = 0;

            using (var songpalStream = new StreamWriter(File.Create(@"Y:\Downloads\songpal\songpalproduct.json"), utf8WithoutBom))
            using (var sbsStream = new StreamWriter(File.Create(@"Y:\Downloads\songpal\songpalbutsbs.json"), utf8WithoutBom))
            {
                foreach (var file in Directory.GetFiles(@"Y:\Downloads\songpal"))
                {

                    if (file.EndsWith("_SUCCESS"))
                        continue;
                    if (file.EndsWith("manifest"))
                        continue;
                    if (file.EndsWith("swp"))
                        continue;
                    if (file.EndsWith("json"))
                        continue;
                    foreach (var line in File.ReadLines(file))
                    {
                        Console.WriteLine(++lineno);
                        try
                        {
                            JsonSerializerSettings settings = new JsonSerializerSettings();
                            settings.MissingMemberHandling = MissingMemberHandling.Error;

                            try
                            {
                                var goodObj = JsonConvert.DeserializeObject<ContextObject>(line, settings);
                                var realObj = JsonConvert.DeserializeObject<RealContext>(goodObj.Context.s, settings);
                                if (realObj.partnerInfo.partnerId == "test_api_health")
                                    continue;
                                if (realObj.partnerInfo.partnerId != "3fc1ee35-a08a-49ef-8adf-b150010441e4" && realObj.partnerInfo.partnerId != "c465c49e-4f13-49e9-af8d-1eabfb4087dc")
                                    continue;

                                realObj.dynamoContainer = new DynamoContainer { name = goodObj.name, timestamp = goodObj.Timestamp.n, token = goodObj.Token.s, version = goodObj.version };

                                var data = JsonConvert.SerializeObject(realObj);

                                if (realObj.partnerInfo.partnerId == "3fc1ee35-a08a-49ef-8adf-b150010441e4")
                                    songpalStream.WriteLine(data);
                                else
                                    sbsStream.WriteLine(data);
                            }
                            catch (Exception ex)
                            {
                                var realObj = JsonConvert.DeserializeObject<RealContextProduct>(line, settings);
                                if (realObj.partnerInfo.partnerId == "test_api_health")
                                    continue;
                                if (realObj.partnerInfo.partnerId != "3fc1ee35-a08a-49ef-8adf-b150010441e4" && realObj.partnerInfo.partnerId != "c465c49e-4f13-49e9-af8d-1eabfb4087dc")
                                    continue;

                                var data = JsonConvert.SerializeObject(realObj);

                                if (realObj.partnerInfo.partnerId == "3fc1ee35-a08a-49ef-8adf-b150010441e4")
                                    songpalStream.WriteLine(data);
                                else
                                    sbsStream.WriteLine(data);
                            }
                        }
                        catch (Exception ex)
                        {
                            Console.WriteLine(ex.GetType().Name + ": " + ex.Message);
                        }
                    }
                }
            }

            Console.WriteLine("===================================================");
            Console.WriteLine("songpal");
            Console.WriteLine("===================================================");
            Console.WriteLine(RealContext.TableLine(""));
            Console.WriteLine("===================================================");
            Console.WriteLine("songpalproduct");
            Console.WriteLine("===================================================");
            Console.WriteLine(RealContextProduct.TableLine(""));
            Console.ReadKey();
        }
    }

    public class TokenObject
    {
        public string s { get; set; }
    }

    public class TimeStampObject
    {
        public long n { get; set; }
    }

    public class RootObject
    {
        public string s { get; set; }
    }

    public class ContextObject
    {
        public RootObject Context;
        public TokenObject Token;
        public TimeStampObject Timestamp;
        public string name { get; set; }
        public string version { get; set; }
    }


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

    public class Metadata
    {
        public string connected { get; set; }
        public static string TableLine(string preface)
        {
            return String.Format("{0}connected varchar(5)\n", preface);
        }
    }

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

    public class ProductSet
    {
        public List<Product> products { get; set; }

        public static string TableLine(string preface)
        {
            return Product.TableLine(preface + "_product");
        }

    }

    public class DynamoContainer
    {
        private string _s1;
        private string _s2;
        private string _s3;
        public string name
        {
            get { return _s1; }
            set { _s1 = value; if (value != null && maxLengthName < value.Length) maxLengthName = value.Length; }
        }
        public string version
        {
            get { return _s2; }
            set { _s2 = value; if (value != null && maxLengthVersion < value.Length) maxLengthVersion = value.Length; }
        }
        public string token
        {
            get { return _s3; }
            set { _s3 = value; if (value != null && maxLengthToken < value.Length) maxLengthToken = value.Length; }
        }
        public long timestamp { get; set; }

        public static int maxLengthName = 0;
        public static int maxLengthVersion = 0;
        public static int maxLengthToken = 0;
        public static string TableLine(string preface)
        {
            return String.Format("{0}name VARCHAR({1})\n", preface, maxLengthName) +
                    String.Format("{0}version VARCHAR({1})\n", preface, maxLengthVersion) +
                    String.Format("{0}token VARCHAR({1})\n", preface, maxLengthToken) +
                    String.Format("{0}timestamp bigint\n", preface);
        }
    }

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

    public class BaseContext
    {
        public PartnerInfo partnerInfo { get; set; }
        public AppInfo appInfo { get; set; }
        public EnvironmentInfo environmentInfo { get; set; }
        public static string TableLine(string preface)
        {
            return PartnerInfo.TableLine("partnerInfo_") +
                   AppInfo.TableLine("appInfo_") +
                   EnvironmentInfo.TableLine("environmentInfo_");
        }

    }
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

    public class RealContext : BaseContext
    {
        public DynamoContainer dynamoContainer{ get; set; }
        public ProductSet productSet { get; set; }
        public static string TableLine(string preface)
        {
            return  DynamoContainer.TableLine("dynamoContainer_") + 
                    BaseContext.TableLine(preface) +
                    ProductSet.TableLine("productSet_");
        }
    }
}
