<%@ WebHandler Language="C#" Class="UpdateBookRequests" %>

using System;
using System.Web;
using Entities;
using DataAccessLayer;
using BusinessLayer;
using System.Collections.Generic;
using Iesi.Collections;
public class UpdateBookRequests : IHttpHandler
{

    public void ProcessRequest(HttpContext context)
    {
        Agent a = AgentBO.GetLoggedInAgent();
        context.Response.ContentType = "text/plain";
        String value = context.Request.Params.Get("value");
        if (context.Request.Params.Get("updaterequest") != null)
        {
            BookRequest b = BookRequestDAO.FindBookRequestByID(Int64.Parse(context.Request.Params.Get("bid")));
            Boolean change = false;
            
            if (b.Agent.Equals(a))
            {
                switch (context.Request.Params.Get("property"))
                {
                    case "Email": b.ContactDetails.Email = value; break;
                    case "Name": b.ContactDetails.Name = value; break;
                    case "NoOfPassengers": b.PAX = Int32.Parse(value); change = true; break;
                    case "Budget": b.Budget = Double.Parse(value); b.FinalBudget = BookRequestBO.GetFinalBudget(b.Budget, b.Domain); change = true; break;
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
            }
            BookRequestDAO.MakePersistent(b);
            IList<Operator> oplist = BookRequestDAO.GetRequestedOperators(b);
            if (change)
            {
                EmailBO em = new EmailBO("BookRequestEdited", "US");
                em.SendEmailToOperators(AdminBO.GetOperatorSetFromList(oplist),b);
            }
            context.Response.Write(value);


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