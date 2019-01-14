<%@ WebHandler Language="C#" Class="OperatorResolve" %>

using System;
using System.Web;
using Entities;
using DataAccessLayer;
using Newtonsoft.Json;
using BusinessLayer;
using Iesi.Collections;
using System.Collections.Specialized;
using System.Collections.Generic;

public class OperatorResolve : IHttpHandler
{

    public void ProcessRequest(HttpContext context)
    {
        if (context.Request.Params.Get("getoperators") != null)
        {
            NameValueCollection pars = new NameValueCollection();
            pars.Add("aircraftcategorymatch", context.Request.Params.Get("aircraftcategorymatch"));
            pars.Add("regionmatch", context.Request.Params.Get("regionmatch"));
            BookRequest b = BookRequestDAO.FindBookRequestByID(Int64.Parse(context.Request.Params.Get("bookid")));
            HybridSet olist = OperatorBO.GetOperatorsForRequest(b, pars);
            context.Response.Write(JavaScriptConvert.SerializeObject(olist));
        }
        if (context.Request.Params.Get("getoperatorrequests") != null)
        {

            BookRequest b = BookRequestDAO.FindBookRequestByID(Int64.Parse(context.Request.Params.Get("bookid")));
            IList<Operator> olist = OperatorDAO.GetOperatorRequests(b);
            context.Response.Write(JavaScriptConvert.SerializeObject(olist));
        }
        if (context.Request.Params.Get("getoperatorbids") != null)
        {
            BookRequest b = BookRequestDAO.FindBookRequestByID(Int64.Parse(context.Request.Params.Get("bookid")));
            IList<OperatorBid> bidlist = BookRequestDAO.GetBidsForRequest(b);
            context.Response.Write(JavaScriptConvert.SerializeObject(bidlist));
        }
        if (context.Request.Params.Get("sendbidtocustomer") != null)
        {
            OperatorBid ob = BookRequestDAO.GetOperatorBidByID(Int64.Parse(context.Request.Params.Get("bidid")));
            ob.Status = 1;
            ob.TimeOfBid = DateTime.Now;
            BookRequestDAO.SaveBid(ob);
            EmailBO em = new EmailBO("NewBidCustomer", ob.Request.Domain.CountryID.ToString());
            if (ob.Request.IsAgent)
            {
                em.SendEmailToAgent(ob.Request.Agent,ob.Request);
            }
            else
            {
                em.SendEmailToCustomer(CustomerDAO.CheckCustomerByEmail(ob.Request.ContactDetails.Email), ob.Request);
            }
            EmailBO emop = new EmailBO("NewBidOperator", "US");
            IList<Operator> oplist = BookRequestDAO.GetRequestedOperators(ob.Request);
            ISet opset = AdminBO.GetOperatorSetFromList(oplist);
            opset.Remove(ob.Operator);
            emop.SendEmailToOperators(opset,ob.Request);

            context.Response.Write("saved");
        }
        if (context.Request.Params.Get("removebid") != null)
        {
            OperatorBid ob = BookRequestDAO.GetOperatorBidByID(Int64.Parse(context.Request.Params.Get("bidid")));
            if (ob.Equals(ob.Request.AcceptedBid))
            {
                ob.Request.AcceptedBid = null;
                BookRequestDAO.MakePersistent(ob.Request);
            }
            if (ob.Status == 1)
            {
                EmailBO em = new EmailBO("WithdrawBidNotification", ob.Request.Domain.CountryID.ToString());
                if (ob.Request.IsAgent)
                {
                    em.SendEmailToAgent(ob.Request.Agent,ob.Request);
                }
                else
                {
                    em.SendEmailToCustomer(CustomerDAO.CheckCustomerByEmail(ob.Request.ContactDetails.Email),ob.Request);
                }
            }
            ob.Status = 2;
            BookRequestDAO.SaveBid(ob);
            context.Response.Write("saved");

        }
        if (context.Request.Params.Get("sendrequest") != null)
        {
            BookRequest b = BookRequestDAO.FindBookRequestByID(Int64.Parse(context.Request.Params.Get("bookid")));
            IList<Operator> olist = BookRequestDAO.GetRequestedOperators(b);
           
            foreach (String oid in context.Request.Params.Get("selectedops").Split(",".ToCharArray()))
            {
                Operator o = OperatorDAO.FindOperatorByID(Int64.Parse(oid));
                OperatorRequest or = null;
                if (olist.Contains(o))
                {
                    or = BookRequestDAO.GetOperatorRequestByOperator(o, b);
                    or.TimeOfRequest = DateTime.Now;
                }
                else
                {
                    or = new OperatorRequest();
                    or.Operator = o;
                    or.Request = b;
                    or.TimeOfRequest = DateTime.Now;
                }

                BookRequestDAO.MakePersistent(or);
                EmailBO em = new EmailBO("RequestNotificationOperator", "US");
                em.SendEmailToOperator(or.Operator,b);

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