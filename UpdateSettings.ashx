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
using System.Web.SessionState;
public class UpdateSettings : IHttpHandler,IRequiresSessionState {
    
    public void ProcessRequest (HttpContext context) {
        if (context.Request.Params.Get("agentforgotpassword") != null)
        {
            String email = context.Request.Params.Get("email");
            Agent a = AgentDAO.GetAgentByEmail(email);
            EmailBO em = new EmailBO("AgentForgotPassword", a.Domain);
            em.SendEmailToAgent(a);
            context.Response.Write("sent");
        }
        if (context.Request.Params.Get("customerforgotpassword") != null)
        {
            String email = context.Request.Params.Get("email");
            Customer c = CustomerDAO.CheckCustomerByEmail(email);
            EmailBO em = new EmailBO("CustomerForgotPassword", "US");
            em.SendEmailToCustomer(c);
            context.Response.Write("sent");
        }
        if (context.Request.Params.Get("operatorforgotpassword") != null)
        {
            String email = context.Request.Params.Get("email");
            Operator o = OperatorDAO.GetOperatorByEmail(email);
            EmailBO em = new EmailBO("OperatorForgotPassword", "US");
            em.SendEmailToOperator(o);
            context.Response.Write("sent");
        }
    }
 
    public bool IsReusable {
        get {
            return false;
        }
    }

}