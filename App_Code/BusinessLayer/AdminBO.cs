using System;
using System.Data;
using System.Configuration;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using Iesi.Collections;
using Entities;
using System.Collections;
using NHibernate;
using System.Collections.Generic;
using Exceptions;
using DataAccessLayer;
using Helper;
using System.Net.Mail;
using System.Collections.Specialized;

namespace BusinessLayer
{
    public class AdminBO
    {
       
        public AdminBO()
        {

        }
        public static String GetCountryToRedirect(String ipaddress)
        {

            Int64 ipno = Int64.Parse(IPAddressToNumber(ipaddress).ToString());
            String c = AdminDAO.GetCountryForIpNumber(ipno);
            if (c != null)
            {
                Country temp = AdminDAO.GetCountryByID(c);
                IList<Country> fclist = AdminDAO.GetFranchiseCountries();
                if (fclist.Contains(temp))
                    return temp.CountryID;
                else
                {
                    foreach (Country cr in fclist)
                    {
                        if (cr.Continent.Equals(temp.Continent))
                        {
                            return cr.CountryID;
                        }
                    }
                    return "US";
                }

            }
            else
            {
                return "US";
            }
        }
        public static double IPAddressToNumber(string IPaddress)
        {
            int i;
            string[] arrDec;
            double num = 0;
            if (IPaddress == "")
            {
                return 0;
            }
            else
            {
                arrDec = IPaddress.Split('.');
                for (i = arrDec.Length - 1; i >= 0; i--)
                {
                    num += ((int.Parse(arrDec[i]) % 256) * Math.Pow(256, (3 - i)));
                }
                return num;
            }
        }
        public static Admin GetAdmin()
        {
            Admin a = AdminDAO.GetAdminByID(HttpContext.Current.User.Identity.Name);
            return a;
        }
        
        

        public static Country GetCountry()
        {
            String country = HttpContext.Current.Session["Country"].ToString();
            return OperatorDAO.GetCountry(country);
        }
        public static String Serialize(NameValueCollection nvc)
        {
            String temp = "";
            for (int i = 0; i < nvc.Count; i++)
            {
                temp += nvc.GetKey(i);
                temp += "=";
                temp += nvc.Get(i);
                temp += "&";
            }
            if (temp != "")
            {
                temp = temp.Remove(temp.LastIndexOf("&"));
            }
            return temp;
        }
        public static String GetPagingURL(NameValueCollection pars, String pagename, Int32 pageid)
        {
            NameValueCollection nvc = new NameValueCollection(pars);
            if (nvc.Get("pageid") != null)
            {
                nvc["pageid"] = pageid.ToString();
            }
            else
            {
                nvc.Add("pageid", pageid.ToString());
            }
            return pagename + "?" + Serialize(nvc);
        }
        public static String GetRedirectionUrlWithParams(Uri url, String country)
        {
            IList<Country> countries = AdminDAO.GetFranchiseCountries();
            String domain = "www";
            switch (country)
            {
                case "US": domain = "www"; break;
                case "GB": domain = "eu"; break;
                default:
                    domain = "www";
                    foreach (Country c in countries)
                    {
                        if (c.Continent.Equals(AdminDAO.GetCountryByID(country).Continent))
                            domain = c.CountryID.ToLower();
                    }
                    break;
            }
            String newurl = "";
            newurl += "http://" + domain + ".airnetzcharter.com";
            newurl += url.PathAndQuery;
            return newurl;

        }
        public static ISet GetOperatorSetFromList(IList<Operator> temp)
        {
            HashedSet hs= new HashedSet();
            foreach (Operator o in temp)
            {
                hs.Add(o);
            }
            return hs;
        }
    }
}
