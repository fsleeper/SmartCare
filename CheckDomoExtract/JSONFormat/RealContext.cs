namespace CheckDomoExtract.JSONFormat
{
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