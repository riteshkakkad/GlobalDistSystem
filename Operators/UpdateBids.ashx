<%@ WebHandler Language="C#" Class="UpdateBids" %>

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
public class UpdateBids : IHttpHandler
{

    public void ProcessRequest(HttpContext context)
    {

        Operator logop = OperatorBO.GetLoggedinOperator();
        if (context.Request.Params.Get("addbid") != null)
        {
            BookRequest b = BookRequestDAO.FindBookRequestByID(Int64.Parse(context.Request.Params.Get("bookid")));

            Operator recop = OperatorDAO.FindOperatorByID(Int64.Parse(context.Request.Params.Get("opid")));
            Airplane a = OperatorDAO.FindAircraftByID(Int64.Parse(context.Request.Params.Get("aircraftlist")));
            Currency c = AdminDAO.GetCurrencyByID(context.Request.Params.Get("currency"));
            Double bidamt = Double.Parse(context.Request.Params.Get("bidamount"));
            String additionaldetails = context.Request.Params.Get("additionaldetails");

            if (logop.Equals(recop))
            {

                OperatorBid ob = new OperatorBid();
                ob.Currency = c;
                ob.BidAmount = bidamt;
                ob.Aircraft = a;
                ob.Operator = logop;
                ob.TimeOfBid = DateTime.Now;
                ob.Request = b;
                ob.AdditionalDetails = additionaldetails;
                ob.FinalBidAmount = BookRequestBO.GetFinalBid(ob.BidAmount, b.Domain);
                if (b.Domain.SendBidToCustomer)
                    ob.Status = 1;
                else
                    ob.Status = 0;
                BookRequestDAO.SaveBid(ob);
                if (ob.Status == 1)
                {
                    EmailBO em = new EmailBO("NewBidCustomer", ob.Request.Domain.CountryID.ToString());
                    if (ob.Request.IsAgent)
                    {
                        em.SendEmailToAgent(ob.Request.Agent, ob.Request);
                    }
                    else
                    {
                        em.SendEmailToCustomer(CustomerDAO.CheckCustomerByEmail(ob.Request.ContactDetails.Email));
                    }
                    EmailBO emop = new EmailBO("NewBidOperator", "US");
                    IList<Operator> oplist = BookRequestDAO.GetRequestedOperators(ob.Request);
                    ISet opset = AdminBO.GetOperatorSetFromList(oplist);
                    opset.Remove(logop);
                    emop.SendEmailToOperators(opset, ob.Request);
                }
                else
                {
                    EmailBO emop = new EmailBO("NewBidCustomer", "US");
                    emop.SendEmailToAdmin(ob.Request);
                }
                context.Response.Write(GetBidJson(b, logop));
            }
        }
        if (context.Request.Params.Get("updatebid") != null)
        {
            OperatorBid ob = BookRequestDAO.GetOperatorBidByID(Int64.Parse(context.Request.Params.Get("bidid")));
            Airplane a = OperatorDAO.FindAircraftByID(Int64.Parse(context.Request.Params.Get("aircraftlist")));
            Currency c = AdminDAO.GetCurrencyByID(context.Request.Params.Get("currency"));
            Double bidamt = Double.Parse(context.Request.Params.Get("bidamount"));
            String additionaldetails = context.Request.Params.Get("additionaldetails");
            if (ob.Operator.Equals(logop))
            {
                ob.Currency = c;
                ob.BidAmount = bidamt;
                ob.FinalBidAmount = BookRequestBO.GetFinalBid(ob.BidAmount, ob.Request.Domain);
                ob.Aircraft = a;
                ob.TimeOfBid = DateTime.Now;
                ob.AdditionalDetails = additionaldetails;
                BookRequestDAO.SaveBid(ob);
                if (ob.Status == 1)
                {
                    EmailBO em = new EmailBO("BidUpdateCustomer", ob.Request.Domain.CountryID.ToString());
                    if (ob.Request.IsAgent)
                    {
                        em.SendEmailToAgent(ob.Request.Agent,ob.Request);
                    }
                    else
                    {
                        em.SendEmailToCustomer(CustomerDAO.CheckCustomerByEmail(ob.Request.ContactDetails.Email),ob.Request);
                    }
                    EmailBO emop = new EmailBO("BidUpdateOperator", "US");
                    IList<Operator> oplist = BookRequestDAO.GetRequestedOperators(ob.Request);
                    ISet opset = AdminBO.GetOperatorSetFromList(oplist);
                    opset.Remove(ob.Operator);
                    emop.SendEmailToOperators(opset, ob.Request);
                }
                else
                {
                    EmailBO emop = new EmailBO("BidUpdateCustomer", "US");
                    emop.SendEmailToAdmin(ob.Request);
                }
                context.Response.Write(GetBidJson(ob.Request, logop));
            }
        }
        if (context.Request.Params.Get("removebid") != null)
        {
            OperatorBid ob = BookRequestDAO.GetOperatorBidByID(Int64.Parse(context.Request.Params.Get("bidid")));
            if (ob.Operator.Equals(logop))
            {

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
                context.Response.Write(GetBidJson(ob.Request, logop));
            }

        }


    }
    public String GetBidJson(BookRequest b, Operator op)
    {
        String resp = "";
        IList<OperatorBid> bidlist = BookRequestDAO.GetBidsForRequest(b);
        ListSet opbids = new ListSet();
        OperatorBid minbid = null;
        Currency targetcurr = AdminDAO.GetCurrencyByID("USD");
        Double minval = double.PositiveInfinity;
        foreach (OperatorBid ob in bidlist)
        {
            if (ob.Operator.Equals(op))
                opbids.Add(ob);

            Double temp = ob.Currency.ConvertTo(ob.BidAmount, targetcurr);
            if (temp < minval)
            {
                minval = temp;
                minbid = ob;
            }

        }
        String minbidjson = (minbid == null) ? "" : ",\"MinBid\":" + JavaScriptConvert.SerializeObject(minbid);
        resp += "{\"TotalBids\":" + bidlist.Count + ",\"OperatorBids\":" + JavaScriptConvert.SerializeObject(opbids) + minbidjson + "}";
        return resp;

    }
    public bool IsReusable
    {
        get
        {
            return false;
        }
    }

}