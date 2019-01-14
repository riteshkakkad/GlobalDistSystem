using System;
using System.Data;
using System.Configuration;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Collections;
using System.Collections.Specialized;
using Helper;
using System.Net.Mail;
using System.Net;
using System.IO;
using System.Text;

namespace PresentationLayer
{
    public class QuoteDisplay
    {
        public QuoteDisplay()
        {

        }
        public static String GetDetailedQuote(NameValueCollection par)
        {
            String queryString = "test=0";
            foreach (String key in par.Keys)
            {
                queryString += "&" + key + "=" + par.Get(key);
            }

            String inputFile = "http://www.airnetzcharter.com/ViewDetailedQuote.aspx?" + queryString;


            HttpWebRequest web = (HttpWebRequest)HttpWebRequest.Create(inputFile);

            WebResponse webResponse = web.GetResponse();
            Stream stream = webResponse.GetResponseStream();

            StreamReader oReader = new StreamReader(stream, Encoding.ASCII);

            String resp = oReader.ReadToEnd();

            oReader.Close();
            webResponse.Close();
            resp = resp.Remove(resp.IndexOf("<div id=\"FormDiv\">"));
            return resp;
        }

    }
}
