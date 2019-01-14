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
public class UpdateSettings : IHttpHandler
{

    public void ProcessRequest(HttpContext context)
    {
        
        
        if (context.Request.Params.Get("editprofile") != null)
        {
            Agent a = AgentBO.GetLoggedInAgent();
            try
            {
                a.Name = context.Request.Params.Get("AgentName");
                a.Agency = context.Request.Params.Get("AgencyName");
                a.BillingAddress = context.Request.Params.Get("Address");
                a.ContactNo = context.Request.Params.Get("ContactNo");
                a.ContactNo1 = context.Request.Params.Get("AlternateContactNo");
                a.Email1 = context.Request.Params.Get("AlternateEmail");
                a.AgentFax = context.Request.Params.Get("Fax");
                a.Country = context.Request.Params.Get("country");
                AgentDAO.MakePersistent(a);
                String resp = "";
                resp += "{'success':'1','text':'Saved'}";
                context.Response.Write(resp);

            }
            catch (Exception ex)
            {
                String resp = "";
                resp += "{'error':'1','text':'Some unexpected problem occured.'}";
                context.Response.Write(resp);
            }
        }
        if (context.Request.Params.Get("changepassword") != null)
        {
            Agent a = AgentBO.GetLoggedInAgent();
            if (a.Password == context.Request.Params.Get("oldpassword"))
            {
                a.Password = context.Request.Params.Get("newpassword");
                AgentDAO.MakePersistent(a);
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