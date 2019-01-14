<%@ WebHandler Language="C#" Class="UpdateBookRequests" %>

using System;
using System.Web;
using Entities;
using DataAccessLayer;
using BusinessLayer;
using Iesi.Collections;
using System.Collections;
using System.Collections.Generic;
using Helper;
using Exceptions;
using Newtonsoft.Json;

public class UpdateBookRequests : IHttpHandler
{

    public void ProcessRequest(HttpContext context)
    {
        context.Response.ContentType = "text/plain";
        String value = context.Request.Params.Get("value");
        if (context.Request.Params.Get("makenormal") != null)
        {
            BookRequest b = BookRequestDAO.FindBookRequestByID(Int64.Parse(context.Request.Params.Get("bookid")));
            b.FixedPriceCharter = null;
            BookRequestDAO.MakePersistent(b);
            context.Response.Redirect(context.Request.UrlReferrer.OriginalString);
            
        }
        if (context.Request.Params.Get("addbid") != null)
        {
            BookRequest b = BookRequestDAO.FindBookRequestByID(Int64.Parse(context.Request.Params.Get("bookid")));
            Airplane a = OperatorDAO.FindAircraftByID(Int64.Parse(context.Request.Params.Get("aircraftlist")));
            Currency c = AdminDAO.GetCurrencyByID(context.Request.Params.Get("currency"));
            Double bidamt = Double.Parse(context.Request.Params.Get("bidamount"));

            String additionaldetails = context.Request.Params.Get("additionaldetails");

            OperatorBid ob = new OperatorBid();
            ob.Currency = c;
            ob.BidAmount = bidamt;
            ob.Aircraft = a;
            ob.Operator = a.Vendor;
            ob.TimeOfBid = DateTime.Now;
            ob.Request = b;
            ob.AdditionalDetails = additionaldetails;
            ob.FinalBidAmount = BookRequestBO.GetFinalBid(ob.BidAmount, ob.Request.Domain);
            ob.Status = 0;
            BookRequestDAO.SaveBid(ob);



        }
        if (context.Request.Params.Get("updatebid") != null)
        {
            OperatorBid ob = BookRequestDAO.GetOperatorBidByID(Int64.Parse(context.Request.Params.Get("bidid")));
            Airplane a = OperatorDAO.FindAircraftByID(Int64.Parse(context.Request.Params.Get("aircraftlist")));
            Currency c = AdminDAO.GetCurrencyByID(context.Request.Params.Get("currency"));
            Double bidamt = Double.Parse(context.Request.Params.Get("bidamount"));
            Double finalbidamt = Double.Parse(context.Request.Params.Get("finalbidamount"));
            String additionaldetails = context.Request.Params.Get("additionaldetails");
            ob.Currency = c;
            ob.BidAmount = bidamt;
            ob.FinalBidAmount = finalbidamt;
            ob.Aircraft = a;
            ob.TimeOfBid = DateTime.Now;
            ob.AdditionalDetails = additionaldetails;
            BookRequestDAO.SaveBid(ob);
            if (ob.Status == 1)
            {
                EmailBO em = new EmailBO("BidUpdateCustomer", ob.Request.Domain.CountryID.ToString());
                if (ob.Request.IsAgent)
                {
                    em.SendEmailToAgent(ob.Request.Agent, ob.Request);
                }
                else
                {
                    em.SendEmailToCustomer(CustomerDAO.CheckCustomerByEmail(ob.Request.ContactDetails.Email), ob.Request);
                }
                EmailBO emop = new EmailBO("BidUpdateOperator", "US");
                IList<Operator> oplist = BookRequestDAO.GetRequestedOperators(ob.Request);
                ISet opset = AdminBO.GetOperatorSetFromList(oplist);
                opset.Remove(ob.Operator);
                emop.SendEmailToOperators(opset, ob.Request);
            }

            context.Response.Write("saved");

        }
        if (context.Request.Params.Get("updaterequest") != null)
        {
            BookRequest b = BookRequestDAO.FindBookRequestByID(Int64.Parse(context.Request.Params.Get("bid")));
            Boolean change = false;
            switch (context.Request.Params.Get("property"))
            {
                case "Email": b.ContactDetails.Email = value; break;
                case "Name": b.ContactDetails.Name = value; break;
                case "NoOfPassengers": b.PAX = Int32.Parse(value); change = true; break;
                case "Budget": b.Budget = Double.Parse(value); break;
                case "FinalBudget": b.FinalBudget = Double.Parse(value); change = true; break;
                case "Status": b.Status = Int16.Parse(value); value = (b.Status == 0) ? "Active" : "Closed"; change = true; break;
                case "PhoneNo": b.ContactDetails.Phone = value; break;
                case "OtherDetails": b.ContactDetails.Description = value; break;
                case "PlaneType": b.PlaneType = OperatorDAO.FindAircraftTypeByID(value); value = b.PlaneType.PlaneTypeName + "(" + b.PlaneType.Capacity + " PAX)"; change = true; break;
                case "Date": Int32 legno = Int32.Parse(context.Request.Params.Get("leg"));
                    foreach (Leg l in b.Legs)
                    {
                        if (l.Sequence == legno)
                        {
                            String val = value + " " + l.Date.ToShortTimeString();
                            l.Date = DateTime.Parse(val);
                        }
                    }
                    change = true;
                    break;
                case "Time": legno = Int32.Parse(context.Request.Params.Get("leg"));
                    foreach (Leg l in b.Legs)
                    {
                        if (l.Sequence == legno)
                        {
                            l.Date = DateTime.Parse(l.Date.ToShortDateString() + " " + value);
                        }
                    }
                    change = true;
                    break;

                default: break;
            }
            BookRequestDAO.MakePersistent(b);
            IList<Operator> oplist = BookRequestDAO.GetRequestedOperators(b);

            if (change)
            {
                EmailBO em = new EmailBO("BookRequestEdited", "US");
                em.SendEmailToOperators(AdminBO.GetOperatorSetFromList(oplist), b);
            }
            context.Response.Write(value);

        }
        if (context.Request.Params.Get("updaterequestlegs") != null)
        {
            BookRequest b = BookRequestDAO.FindBookRequestByID(Int64.Parse(context.Request.Params.Get("bookid")));
            BookRequest tempb = BookRequestDAO.FindBookRequestByID(Int64.Parse(context.Request.Params.Get("bookid")));
            Int32 noflegs = Int32.Parse(context.Request.Params.Get("nooflegs"));
            String TripType = context.Request.Params.Get("TripType");
            try
            {
                String alternatefields = "";
                String selectedfields = "";
                Boolean error = false;
                ListSet legset = new ListSet();
               
                for (int i = 1; i <= noflegs; i++)
                {
                    ListSet fromairfields = AirfieldBO.GetAirfields(context.Request.Params.Get("fromleg" + i));
                    ListSet toairfields = AirfieldBO.GetAirfields(context.Request.Params.Get("toleg" + i));
                    if (!b.PlaneType.IsHelicopter())
                    {
                        fromairfields = AirfieldBO.RemoveHeliports(fromairfields);
                        toairfields = AirfieldBO.RemoveHeliports(toairfields);
                    }
                    Airfield selectedto = null;
                    Airfield selectedfrom=null;
                    foreach (Airfield a in fromairfields)
                    {
                        selectedfields += "\"fromleg" + i + "\":" + JavaScriptConvert.SerializeObject(a) + ",";
                        ListSet tempset = new ListSet(fromairfields);
                        tempset.Remove(a);
                        selectedfrom=a;
                        alternatefields += "\"afromleg" + i + "\":" + JavaScriptConvert.SerializeObject(tempset) + ",";
                        break;
                    }
                    foreach (Airfield a in toairfields)
                    {
                        selectedfields += "\"toleg" + i + "\":" + JavaScriptConvert.SerializeObject(a) + ",";
                        ListSet tempset = new ListSet(toairfields);
                        tempset.Remove(a);
                        selectedto=a;
                        alternatefields += "\"atoleg" + i + "\":" + JavaScriptConvert.SerializeObject(tempset) + ",";
                        break;
                    }
                    
                    if (fromairfields.Count > 1 || toairfields.Count > 1)
                        error = true;

                    if (selectedto != null && selectedto != null)
                    {
                        Leg l = new Leg();
                        l.Source = selectedfrom;
                        l.Destination = selectedto;
                        l.Date = DateTime.Parse(context.Request.Params.Get("dateleg" + i) + " " + context.Request.Params.Get("timeleg" + i));
                        l.Sequence = i;
                        legset.Add(l);
                    }
                    else
                    {
                        throw new Exception();
                    }
                                                           
                }
                 
                String resp = "{";
                if (error)
                {
                    resp += "\"selecterror\":\"please select airfields\",";
                }
                else
                {
                    IEnumerator il = legset.GetEnumerator();
                    ListSet removeleg = new ListSet();
                    Boolean lesslegs = true;
                    foreach (Leg l in b.Legs)
                    {
                        if (il.MoveNext())
                        {
                            Leg temp = (Leg)il.Current;
                            l.Destination = temp.Destination;
                            l.Source = temp.Source;
                            l.Date = temp.Date;
                            l.Sequence = temp.Sequence;
                            l.Request = b;
                        }
                        else
                        {
                            removeleg.Add(l);
                            NHibernateHelper.GetCurrentSession().Delete(l);
                            lesslegs = false; 
                        }
                                               
                    }
                    if (lesslegs)
                    {
                        while (il.MoveNext())
                        {
                            Leg newleg = new Leg();
                            Leg templeg = (Leg)il.Current;
                            newleg.Destination = templeg.Destination;
                            newleg.Source = templeg.Source;
                            newleg.Date = templeg.Date;
                            newleg.Sequence = templeg.Sequence;
                            newleg.Request = b;
                            b.Legs.Add(newleg);
                        }
                    }
                    b.Legs.RemoveAll(removeleg);
                    b.TripType = TripType;
                    BookRequestDAO.MakePersistent(b);
                    if (!b.Equals(tempb))
                    {
                        IList<Operator> oplist = BookRequestDAO.GetRequestedOperators(b);
                        EmailBO em = new EmailBO("BookRequestEdited", "US");
                        em.SendEmailToOperators(AdminBO.GetOperatorSetFromList(oplist), b);
                    }       
                    resp += "\"text\":\"Saved\",";
                }
                resp += "\"nooflegs\":" + noflegs + "," + selectedfields + ((alternatefields != "") ? alternatefields.Remove(alternatefields.LastIndexOf(",")) : "");
                resp += "}";
                context.Response.Write(resp);

            }
            catch (HeliportException hx)
            {
                context.Response.Write("{'error':'One of the field is a heliport.Only midsize helicopters or large helicopters are supported.'}");
            }
            catch (Exception ex)
            {
                context.Response.Write("{'error':'Airfields not found. Use Autocomplete feature.'}");

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