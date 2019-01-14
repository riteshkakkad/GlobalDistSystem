<%@ WebHandler Language="C#" Class="UpdateSettings" %>

using System;
using System.Web;
using Entities;
using DataAccessLayer;
using System.Collections;
using Newtonsoft.Json;
using BusinessLayer;
using System.Collections.Generic;
using Helper;
using Iesi.Collections;
using System.Xml;
using System.IO;
using TidyNet;
using System.Collections.Specialized;

public class UpdateSettings : IHttpHandler
{

    public void ProcessRequest(HttpContext context)
    {

        if (context.Request.Params.Get("loadcustomers") != null)
        {
            String resp = "";
            foreach (Customer c in CustomerDAO.GetCustomers(new NameValueCollection()))
            {
                resp += c.Email.Trim() + ", ";
            }
            foreach (Agent a in AgentDAO.GetAgents(new NameValueCollection()))
            {
                resp += a.Email.Trim() + ", ";
            }
            if (resp != "")
               resp= resp.Remove(resp.LastIndexOf(","));

            context.Response.Write("{'emaillist':'" + resp + "'}");
        }
        if (context.Request.Params.Get("broadcastemptylegs") != null)
        {
            EmptyLeg el = BookRequestDAO.FindEmptyLegByID(Int64.Parse(context.Request.Params.Get("eid")));
            String emptyleg = el.Source.GetAirfieldString() + " - " + el.Destination.GetAirfieldString() + " departing between " + el.DepartureFromDate.ToString() + " and " + el.DepartureToDate.ToString() + "<br>";
            String content = context.Request.Params.Get("email").Replace("{{EmptyLeg}}", emptyleg);
            EmailBO em = new EmailBO(context.Request.Params.Get("subject"), content, "US");
            ArrayList temp = new ArrayList();
            String elist = context.Request.Params.Get("tolist").Replace("\n", "");
            foreach (String e in elist.Split(",".ToCharArray()))
            {
                if (e.Trim() != "")
                {
                    temp.Add(e.Trim());
                }
            }
            em.SendEmailToList(temp);
            context.Response.Write("{'sent':'1'}");

        }
        if (context.Request.Params.Get("getemailcontent") != null)
        {
            String settingid = context.Request.Params.Get("settingid");
            EmailSetting es = AdminDAO.GetEmailSettingByID(settingid);
            String content = (es.EmailContent != null) ? es.EmailContent.Replace("\n", "").Replace("\r", "").Trim() : "";
            String subject = es.Subject;
            String resp = "{";
            resp += "'email':'" + content + "','subject':'" + subject + "','status':'" + ((es.Send) ? "1" : "0") + "'}";
            context.Response.Write(resp);

        }
        if (context.Request.Params.Get("getcontactnos") != null)
        {
            String country = context.Request.Params.Get("country");
            Country c = AdminDAO.GetCountryByID(country);
            context.Response.Write(c.ContactNos);
        }
        if (context.Request.Params.Get("setadminemails") != null)
        {
            String adminemails = context.Request.Params.Get("adminemails").Trim();
            Default.adminemails = adminemails;
            Default.SaveDefaults();
            context.Response.Write("saved");
        }
        if (context.Request.Params.Get("setcontactnos") != null)
        {
            String country = context.Request.Params.Get("country");
            string contactnos = context.Request.Params.Get("contactnos");
            Country c = AdminDAO.GetCountryByID(country);
            c.ContactNos = contactnos;
            AdminDAO.MakePersistent(c);
            context.Response.Write("saved");
        }
        if (context.Request.Params.Get("setemailcontent") != null)
        {
            String settingid = context.Request.Params.Get("emailsetting");
            EmailSetting es = AdminDAO.GetEmailSettingByID(settingid);
            es.EmailContent = context.Request.Params.Get("email");
            es.Subject = context.Request.Params.Get("subject");
            if (context.Request.Params.Get("status") == "1")
                es.Send = true;
            else
                es.Send = false;
            AdminDAO.MakePersistent(es);
            context.Response.Write("saved");
        }
        if (context.Request.Params.Get("getsignaturecontent") != null)
        {
            String country = context.Request.Params.Get("country");
            if (country == "default")
            {
                String temp = Default.signature;
                context.Response.Write(Default.signature);
            }
            else
            {
                Country c = AdminDAO.GetCountryByID(country);
                context.Response.Write(c.Signature);
            }

        }
        if (context.Request.Params.Get("updatesignaturecontent") != null)
        {
            String country = context.Request.Params.Get("country");
            string signature = context.Request.Params.Get("signature");
            if (country == "default")
            {
                Default.signature = signature;
                Default.SaveDefaults();
                context.Response.Write("saved");
            }
            else
            {
                Country c = AdminDAO.GetCountryByID(country);
                context.Response.Write(c.Signature);
                c.Signature = signature;
                AdminDAO.MakePersistent(c);

                context.Response.Write("saved");
            }

        }
        if (context.Request.Params.Get("getmarginmodesettings") != null)
        {
            String country = context.Request.Params.Get("country");
            if (country == "default")
            {
                String resp = "{";
                resp += "'margin':'" + Default.margin + "','sendrequesttooperator':'" + (Default.sendrequesttooperator ? "t" : "") + "','sendbidtocustomer':'" + (Default.sendbidtocustomer ? "t" : "") + "'}";
                context.Response.Write(resp);
            }
            else
            {
                Country c = AdminDAO.GetCountryByID(country);
                String resp = "{";
                resp += "'margin':'" + c.Margin + "','sendrequesttooperator':'" + (c.SendRequestToOperator ? "t" : "") + "','sendbidtocustomer':'" + (c.SendBidToCustomer ? "t" : "") + "'}";
                context.Response.Write(resp);

            }
        }
        if (context.Request.Params.Get("getcontentsettings") != null)
        {
            String country = context.Request.Params.Get("country");
            if (country == "default")
            {
                String resp = "{";
                resp += "'copyright':'" + Default.copyright.Trim() + "','pricingdisclaimer':'" + Default.pricingdisclaimer.Trim() + "'}";
                context.Response.Write(resp);
            }
            else
            {
                Country c = AdminDAO.GetCountryByID(country);
                String copyright = (c.CopyRight == null) ? "" : c.CopyRight;
                String pricingdisclaimer = (c.PricingDisclaimer == null) ? "" : c.PricingDisclaimer;
                String resp = "{";
                resp += "'copyright':'" + copyright.Trim() + "','pricingdisclaimer':'" + pricingdisclaimer.Trim() + "'}";
                context.Response.Write(resp);

            }

        }
        if (context.Request.Params.Get("updatemarginmodesettings") != null)
        {
            String country = context.Request.Params.Get("country");
            Double margin = Double.Parse(context.Request.Params.Get("margin"));
            Boolean sendrequesttooperator, sendbidtocustomer;
            if (context.Request.Params.Get("sendrequesttooperator") == "on")
            {
                sendrequesttooperator = true;
            }
            else
            {
                sendrequesttooperator = false;
            }
            if (context.Request.Params.Get("sendbidtocustomer") == "on")
            {
                sendbidtocustomer = true;
            }
            else
            {
                sendbidtocustomer = false;
            }

            if (country == "default")
            {
                Default.margin = margin;
                Default.sendrequesttooperator = sendrequesttooperator;
                Default.sendbidtocustomer = sendbidtocustomer;
                Default.SaveDefaults();
                context.Response.Write("saved");

            }
            else
            {
                Country c = AdminDAO.GetCountryByID(country);
                c.SendBidToCustomer = sendbidtocustomer;
                c.SendRequestToOperator = sendrequesttooperator;
                c.Margin = margin;
                AdminDAO.MakePersistent(c);
                context.Response.Write("saved");
            }
        }
        if (context.Request.Params.Get("updatecontentsettings") != null)
        {
            String country = context.Request.Params.Get("country");
            string copyright = context.Request.Params.Get("copyright");
            string pricingdisclaimer = context.Request.Params.Get("pricingdisclaimer");
            if (country == "default")
            {
                Default.copyright = copyright.Trim();
                Default.pricingdisclaimer = pricingdisclaimer.Trim();
                Default.SaveDefaults();
                context.Response.Write("saved");

            }
            else
            {
                Country c = AdminDAO.GetCountryByID(country);
                c.CopyRight = copyright;
                c.PricingDisclaimer = pricingdisclaimer;
                AdminDAO.MakePersistent(c);
                context.Response.Write("saved");
            }



        }

        if (context.Request.Params.Get("changepassword") != null)
        {
            Admin a = AdminBO.GetAdmin();
            if (a.AdminPassword == context.Request.Params.Get("oldpassword"))
            {
                a.AdminPassword = context.Request.Params.Get("newpassword");
                AdminDAO.MakePersistent(a);
                String resp = "{";
                resp += "'text':'Password Saved.'}";
                context.Response.Write(resp);
            }
            else
            {
                String resp = "{";
                resp += "'error':'1','text':'Wrong old password.'}";
                context.Response.Write(resp);
            }
        }
    }

    public bool IsReusable
    {
        get
        {
            return false;
        }
    }

}