using System;
using System.Data;
using System.Configuration;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using Entities;
using DataAccessLayer;
using Iesi.Collections;
using System.Collections;
using NHibernate;
using System.Collections.Generic;
using Helper;
using System.Net.Mail;
using System.Net;
using System.IO;
using System.Text;
using PresentationLayer;
using System.Security.Cryptography;
using ASPPDFLib;
using System.Xml;
using System.Collections.Specialized;


namespace BusinessLayer
{
    public class OperatorBO
    {

        public OperatorBO()
        {

        }
        public static String GeneratePassword()
        {
            return RandomPassword.Generate(8);
        }
        public static void OperatorResolve(BookRequest b)
        {
            if (AdminBO.GetCountry().SendRequestToOperator)
            {

                HybridSet olist = OperatorBO.GetOperatorsForRequest(b);
                foreach (Operator o in olist)
                {
                    OperatorRequest or = new OperatorRequest();
                    or.Operator = o;
                    or.Request = b;
                    or.TimeOfRequest = DateTime.Now;
                    BookRequestDAO.MakePersistent(or);

                }
            }
        }

        public static Operator GetLoggedinOperator()
        {
            try
            {
                if (HttpContext.Current.User.IsInRole("Operators"))
                {
                    Operator op = OperatorDAO.FindOperatorByID(Int64.Parse(HttpContext.Current.User.Identity.Name));
                    return op;
                }
                else
                {
                    return null;
                }
            }
            catch (Exception ex)
            {
                return null;
            }
        }

        public static HybridSet GetOperatorsForRequest(BookRequest b, NameValueCollection settings)
        {
            NameValueCollection pars = new NameValueCollection();
            HybridSet filterlist = new HybridSet();
            HybridSet filteredaircraftlist = new HybridSet();
            pars.Add("status", "confirm");
            IList<Operator> oplist = OperatorDAO.GetOperators(pars);
            HybridSet aircraftlist = new HybridSet();
            foreach (Operator op in oplist)
            {
                aircraftlist.AddAll(op.Aircrafts);
            }

            String regionmatch = settings.Get("regionmatch");
            switch (regionmatch)
            {
                case "allinoperatedcountries":
                    {
                        ListSet countries = b.GetLegCountries();
                        foreach (Operator op in oplist)
                        {
                            if (op.OperatorCountries.ContainsAll(countries))
                            {
                                filteredaircraftlist.AddAll(op.Aircrafts);
                            }
                        }
                        break;
                    }
                case "startingoperatedcountries":
                    {
                        String country = b.GetStartingLeg().Source.Country.Trim();
                        foreach (Operator op in oplist)
                        {
                            if (op.OperatorCountries.Contains(country))
                            {

                                filteredaircraftlist.AddAll(op.Aircrafts);
                            }
                        }
                        break;
                    }
                case "aircraftpresentinstartlocation":
                    {
                        String location = b.GetStartingLeg().Source.City;

                        if (location != null && location.Trim() != "")
                        {
                            foreach (Airplane a in aircraftlist)
                            {
                                if (a.AircraftLocation.Trim().ToLower().Equals(location.ToLower()))
                                {
                                    filteredaircraftlist.Add(a);

                                }

                            }
                        }
                        else
                        {
                            location = b.GetStartingLeg().Source.AirfieldName;
                            foreach (String s in location.Split(" ".ToCharArray()))
                            {
                                if (s.Trim() != "")
                                {
                                    foreach (Airplane a in aircraftlist)
                                    {
                                        if (a.AircraftLocation.Trim().ToLower().Equals(s.ToLower()))
                                        {

                                            filteredaircraftlist.Add(a);
                                        }
                                    }
                                }
                            }

                        }
                        break;
                    }
                default:
                    {
                        foreach (Operator op in oplist)
                        {

                            filteredaircraftlist.AddAll(op.Aircrafts);
                        }
                        break;
                    }
            }
            String aircraftcategorymatch = settings.Get("aircraftcategorymatch");
            HybridSet categoryfilteredlist = new HybridSet(filteredaircraftlist);
            switch (aircraftcategorymatch)
            {
                case "exactmatch":
                    {
                        foreach (Airplane a in filteredaircraftlist)
                        {
                            if (!a.AircraftType.Equals(b.PlaneType))
                            {
                                categoryfilteredlist.Remove(a);

                            }

                        }

                        break;
                    }
                case "parentmatch":
                    {
                        foreach (Airplane a in filteredaircraftlist)
                        {
                            if (!a.AircraftType.ParentCategory.Equals(b.PlaneType.ParentCategory))
                            {
                                categoryfilteredlist.Remove(a);
                            }
                        }
                        break;

                    }
                default:
                    {
                        break;
                    }
            }
            foreach (Airplane a in categoryfilteredlist)
            {
                filterlist.Add(a.Vendor);
            }
            return filterlist;
        }
        public static HybridSet GetOperatorsForRequest(BookRequest b)
        {
            XmlDocument doc = new XmlDocument();
            doc.Load(HttpContext.Current.Server.MapPath("~/RequestResolveSettings.xml"));

            NameValueCollection pars = new NameValueCollection();
            foreach (XmlNode x in doc.SelectSingleNode("/requestresolve/regionmatch").ChildNodes)
            {
                if (x.HasChildNodes)
                {
                    if (x.InnerText.Trim() == "true")
                    {
                        pars.Add("regionmatch", x.Name.Trim());
                        break;
                    }
                }
            }
            foreach (XmlNode x in doc.SelectSingleNode("/requestresolve/aircraftcategorymatch").ChildNodes)
            {
                if (x.HasChildNodes)
                {
                    if (x.InnerText.Trim() == "true")
                    {
                        pars.Add("aircraftcategorymatch", x.Name.Trim());
                        break;
                    }
                }
            }

            return GetOperatorsForRequest(b, pars);


        }


    }
}
