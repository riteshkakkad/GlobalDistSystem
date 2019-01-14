using System;
using System.Data;
using System.Configuration;
using System.Collections;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using DataAccessLayer;
using Entities;
using BusinessLayer;

using Iesi.Collections;

using NHibernate;
using Exceptions;
using System.Collections.Generic;
using System.Collections.Specialized;

public partial class AddBookRequest : System.Web.UI.Page
{
    public delegate void OperatorResolver(BookRequest b);

    protected void Page_Load(object sender, EventArgs e)
    {
        try
        {
            Int32 nooflegs = Int32.Parse(Request.Params.Get("nooflegs"));
            BookRequest b = new BookRequest();
            Customer check = CustomerBO.GetLoggedInCustomer();
            Agent agentcheck = AgentBO.GetLoggedInAgent();

            b.IsAgent = false;
            Contact c = new Contact();
            if (check != null)
            {
                c.Name = check.Name;
                c.Email = check.Email;
                c.Phone = check.ContactNo;
            }
            else
            {
                c.Name = Request.Params.Get("Name");
                c.Email = Request.Params.Get("Email");
                c.Phone = Request.Params.Get("ContactNo");


                if (agentcheck != null)
                {
                    b.IsAgent = true;
                    b.Agent = agentcheck;
                }
                else if (Session["AgentID"] != null)
                {
                    b.IsAgent = true;
                    Agent a = AgentDAO.FindAgentByID((long)Session["AgentID"]);
                    b.Agent = a;
                }
                else
                {
                    Customer custemail = CustomerDAO.CheckCustomerByEmail(Request.Params.Get("Email"));
                    if (custemail == null)
                    {
                        Customer cust = new Customer();
                        cust.Email = Request.Params.Get("Email"); ;
                        cust.ContactNo = Request.Params.Get("ContactNo");
                        cust.Name = Request.Params.Get("Name");
                        cust.Password = CustomerBO.GeneratePassword();
                        cust.Status = 1;
                        CustomerDAO.MakePersistent(cust);
                        check = cust;
                        EmailBO em = new EmailBO("NewCustomer", Session["Country"].ToString());
                        em.SendEmailToCustomer(check);

                    }
                    else
                    {
                        check = custemail;
                    }

                }
            }
            if (Request.Params.Get("fixedpricecharter") != null)
            {
                FixedPriceCharter el = BookRequestDAO.FindFixedPriceCharterByID(Int64.Parse(Request.Params.Get("fixedpricecharter")));
                b.FixedPriceCharter = el;
            }
            c.Description = Request.Params.Get("OtherDetails");
            b.PAX = Int32.Parse(Request.Params.Get("PAX"));
            b.Budget = Double.Parse(Request.Params.Get("budget"));
            b.FinalBudget = BookRequestBO.GetFinalBudget(b.Budget, AdminBO.GetCountry());
            b.ContactDetails = c;
            b.TimeofCreation = DateTime.Now;
            b.TripType = Request.Params.Get("TripType");
            AirplaneType apt = OperatorDAO.FindAircraftTypeByID(Request.Params.Get("aircrafttype"));
            b.PlaneType = apt;
            b.Status = 0;
            b.Domain = AdminDAO.GetCountryByID(Session["Country"].ToString());
            for (int i = 1; i <= nooflegs; i++)
            {
                Leg l = new Leg();
                l.Sequence = i;
                ListSet fromairfields = AirfieldBO.GetAirfields(Request.Params.Get("fromleg" + i));
                ListSet toairfields = AirfieldBO.GetAirfields(Request.Params.Get("toleg" + i));

                foreach (Airfield a in fromairfields)
                {
                    if (l.Source == null)
                        l.Source = a;

                }
                if (l.Source.IsTemporary())
                    l.Source = AirfieldBO.SaveAirfield(l.Source);
                foreach (Airfield a in toairfields)
                {
                    if (l.Destination == null)
                        l.Destination = a;

                }
                if (l.Destination.IsTemporary())
                    l.Destination = AirfieldBO.SaveAirfield(l.Destination);
                l.Date = DateTime.Parse(Request.Params.Get("dateleg" + i) + " " + Request.Params.Get("timeleg" + i));
                b.AddLeg(l);
            }

            b = BookRequestBO.AcceptBookRequest(b);
            if (b.FixedPriceCharter == null)
            {
                OperatorResolver opr = new OperatorResolver(OperatorBO.OperatorResolve);
                opr.BeginInvoke(b, null, null);
            }
            else
            {
                EmailBO em = new EmailBO("FixedPriceCharterNotificationToOperator", Session["Country"].ToString());
                em.SendEmailToOperator(b.FixedPriceCharter.Aircraft.Vendor);
            }
            if (b.IsAgent)
            {
                EmailBO em = new EmailBO("AgentThanksRequest", Session["Country"].ToString());
                em.SendEmailToAgent(b.Agent);
            }
            else
            {
                EmailBO em = new EmailBO("CustomerThanksRequest", Session["Country"].ToString());
                em.SendEmailToCustomer(check);
            }
            Session.Add("bid", b.BookID);

        }
        catch (AifieldNotFoundException ax)
        {
            Response.Redirect(Request.UrlReferrer.OriginalString + "?" + Serialize(Request.QueryString));
        }
        catch (Exception ex)
        {
            Response.Redirect("QuickQuote.aspx");
        }
        Response.Redirect("RequestSent.aspx");
    }

    protected String Serialize(NameValueCollection nvc)
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

}
