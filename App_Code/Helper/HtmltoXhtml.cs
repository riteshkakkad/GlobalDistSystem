using System;
using System.Data;
using System.Configuration;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using TidyNet;
using System.IO;
using System.Text;
namespace Helper
{
    public class HtmltoXhtml
    {
        public HtmltoXhtml()
        {
            
        }
        public static string Convert(string inputstr)
        {
            if (inputstr.Trim() == "")
                return "";

            Tidy t = new Tidy();
            t.Options.DocType = DocType.Strict;
            t.Options.Xhtml = true;
            MemoryStream input = new MemoryStream(UTF8Encoding.Default.GetBytes(inputstr));

            MemoryStream output= new MemoryStream();
            t.Parse(input,output,new TidyMessageCollection());
           
            byte[] outputContent = new Byte[output.Length];
            output.Position = 0;
            outputContent= output.ToArray();
            UTF8Encoding ut = new UTF8Encoding();
            String temp= ut.GetString(outputContent);
            return temp.Substring(temp.LastIndexOf("<body>")).Replace("<body>", "").Replace("</body>", "").Replace("</html>", "");


        }
    }
}
