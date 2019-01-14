<%@ WebHandler Language="C#" Class="UpdateCustomers" %>

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
public class UpdateCustomers : IHttpHandler {
    
    public void ProcessRequest (HttpContext context) {

        if (context.Request.Params.Get("removecustomer") != null)
        {
            Customer c = CustomerDAO.FindCustomerByID(Int64.Parse(context.Request.Params.Get("cid")));
            c.Status = 2;
            CustomerDAO.MakePersistent(c);
            NameValueCollection temp = new NameValueCollection();
            temp.Add("email", c.Email.Trim());
            foreach (BookRequest b in BookRequestDAO.GetBookRequests(temp))
            {
                b.Status = 2;
                BookRequestDAO.MakePersistent(b);
            }
            context.Response.Redirect(context.Request.UrlReferrer.OriginalString);
        }
        if (context.Request.Params.Get("updatecustomer") != null)
        {            
            Customer c = CustomerDAO.FindCustomerByID(Int64.Parse(context.Request.Params.Get("cid")));
            String property = context.Request.Params.Get("property");
            if (property == "Email")
            {
                Customer check = CustomerDAO.CheckCustomerByEmail(context.Request.Params.Get("value"));
                if (check == null)
                    c.Email = context.Request.Params.Get("value");
            }
            else if (property == "Status")
            {
                
                c.Status = Int32.Parse(context.Request.Params.Get("value"));
            }
            else
            {
                c.GetType().GetProperty(property).SetValue(c, context.Request.Params.Get("value"), null);
            }
            CustomerDAO.MakePersistent(c);
            
            context.Response.Write(c.GetType().GetProperty(property).GetValue(c, null));


        }
    }
 
    public bool IsReusable {
        get {
            return false;
        }
    }

}