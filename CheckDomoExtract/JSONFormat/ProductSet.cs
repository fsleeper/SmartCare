using System.Collections.Generic;

namespace CheckDomoExtract.JSONFormat
{
    public class ProductSet
    {
        public List<Product> products { get; set; }

        public static string TableLine(string preface)
        {
            return Product.TableLine(preface + "_product");
        }

    }
}