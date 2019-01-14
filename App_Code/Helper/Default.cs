using System;
using System.Data;
using System.Configuration;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using System.Xml;
using TidyNet;
using Helper;

namespace Entities
{
    public class Default
    {

        private static String _signature;
        private static String _pricingdisclaimer;
        private static String _copyright;
        private static Boolean _sendrequesttooperator;
        private static Boolean _sendbidtocustomer;
        private static Double _margin;
        private static String _adminemails;
        private static XmlDocument _xmldoc;
        private static String _emailcss;

        public static String emailcss
        {
            get { return _emailcss; }
            set { _emailcss = value; }
        }
        public static Double margin
        {
            get { return _margin; }
            set { _margin = value; }
        }
        public static Boolean sendrequesttooperator
        {
            get { return _sendrequesttooperator; }
            set { _sendrequesttooperator = value; }
        }
        public static Boolean sendbidtocustomer
        {
            get { return _sendbidtocustomer; }
            set { _sendbidtocustomer = value; }
        }
        public static String signature
        {
            get { return _signature; }
            set { _signature = value; }
        }
        public static String adminemails
        {
            get { return _adminemails; }
            set { _adminemails = value; }
        }
        public static String pricingdisclaimer
        {
            get { return _pricingdisclaimer; }
            set { _pricingdisclaimer = value; }
        }
        public static String copyright
        {
            get { return _copyright; }
            set { _copyright = value; }
        }
        public Default()
        {


        }
        static Default()
        {
            _xmldoc = new XmlDocument();
            _xmldoc.Load(HttpContext.Current.Server.MapPath("~/ContentSettings.xml"));
            pricingdisclaimer = _xmldoc.SelectSingleNode("/main/defaults/pricingdisclaimer").InnerXml.Trim();
            copyright = _xmldoc.SelectSingleNode("/main/defaults/copyright").InnerXml.Trim();
            signature = _xmldoc.SelectSingleNode("/main/defaults/signature").InnerXml.Trim();
            sendbidtocustomer = Boolean.Parse(_xmldoc.SelectSingleNode("/main/defaults/sendbidtocustomer").InnerXml.Trim());
            sendrequesttooperator = Boolean.Parse(_xmldoc.SelectSingleNode("/main/defaults/sendrequesttooperator").InnerXml.Trim());
            margin = Double.Parse(_xmldoc.SelectSingleNode("/main/defaults/margin").InnerXml.Trim());
            adminemails = _xmldoc.SelectSingleNode("/main/defaults/adminemails").InnerXml.Trim();
            emailcss = _xmldoc.SelectSingleNode("/main/defaults/emailcss").InnerXml.Trim();
        }
        public static void SaveDefaults()
        {
            _xmldoc.SelectSingleNode("/main/defaults/pricingdisclaimer").InnerXml = pricingdisclaimer;
            _xmldoc.SelectSingleNode("/main/defaults/copyright").InnerXml = copyright;
            _xmldoc.SelectSingleNode("/main/defaults/adminemails").InnerXml = adminemails;
            _xmldoc.SelectSingleNode("/main/defaults/signature").InnerXml = HtmltoXhtml.Convert(signature);
            _xmldoc.SelectSingleNode("/main/defaults/sendbidtocustomer").InnerXml = sendbidtocustomer.ToString();
            _xmldoc.SelectSingleNode("/main/defaults/sendrequesttooperator").InnerXml = sendrequesttooperator.ToString();
            _xmldoc.SelectSingleNode("/main/defaults/margin").InnerXml = margin.ToString();
            _xmldoc.SelectSingleNode("/main/defaults/emailcss").InnerXml = emailcss.ToString();
            _xmldoc.Save(HttpContext.Current.Server.MapPath("~/ContentSettings.xml"));
        }
    }
}
