namespace CheckDomoExtract.JSONFormat
{
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
}