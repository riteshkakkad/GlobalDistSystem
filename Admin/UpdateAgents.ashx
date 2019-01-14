<%@ WebHandler Language="C#" Class="UpdateAgents" %>

using System;
using System.Web;
using Entities;
using DataAccessLayer;
using System.Collections;
using Newtonsoft.Json;
using BusinessLayer;
using System.Collections.Generic;
using Helper;
using System.Collections.Specialized;

public class UpdateAgents : IHttpHandler
{

    public void ProcessRequest(HttpContext context)
    {
        if (context.Request.Params.Get("removeagent") != null)
        {
            Agent a = AgentDAO.FindAgentByID(Int64.Parse(context.Request.Params.Get("aid")));
            a.Status = 2;
            AgentDAO.MakePersistent(a);
            NameValueCollection temp=new NameValueCollection();
            temp.Add("agentid",a.AgentID.ToString());
            foreach (BookRequest b in BookRequestDAO.GetBookRequests(temp))
            {
                b.Status = 2;               
                BookRequestDAO.MakePersistent(b);
            }
            
            context.Response.Redirect(context.Request.UrlReferrer.OriginalString);
        }
        if (context.Request.Params.Get("updateagent") != null)
        {
            Int32 tempstatus = 1;
            Agent a = AgentDAO.FindAgentByID(Int64.Parse(context.Request.Params.Get("aid")));
            String property = context.Request.Params.Get("property");
            if (property == "Email")
            {
                Agent check = AgentDAO.GetAgentByEmail(context.Request.Params.Get("value"));
                if (check == null)
                    a.Email = context.Request.Params.Get("value");
            }
            else if (property == "Status")
            {
                tempstatus = a.Status;
                a.Status = Int32.Parse(context.Request.Params.Get("value"));

            }
            else
            {
                a.GetType().GetProperty(property).SetValue(a, context.Request.Params.Get("value"), null);
            }
            AgentDAO.MakePersistent(a);
            if (tempstatus == 0 && a.Status == 1)
            {
                EmailBO em = new EmailBO("AgentRegistrationApproval", "US");
                em.SendEmailToAgent(a);
            }
            context.Response.Write(a.GetType().GetProperty(property).GetValue(a, null));


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