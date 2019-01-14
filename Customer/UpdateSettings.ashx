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
using System.Collections.Specialized;

public class UpdateSettings : IHttpHandler
{

    public void ProcessRequest(HttpContext context)
    {
        if (context.Request.Params.Get("editprofile") != null)
        {
            Customer c = CustomerBO.GetLoggedInCustomer();
            Boolean change = false;
            try
            {
                if (context.Request.Params.Get("Name") != c.Name || context.Request.Params.Get("CompanyName") != c.CompanyName || context.Request.Params.Get("Email") != c.Email)
                {
                    change = true;
                }

                c.Name = context.Request.Params.Get("Name");
                c.CompanyName = context.Request.Params.Get("CompanyName");
                c.Address = context.Request.Params.Get("Address");
                c.ContactNo = context.Request.Params.Get("ContactNo");
                c.ContactNo1 = context.Request.Params.Get("AlternateContactNo");
                c.Email1 = context.Request.Params.Get("AlternateEmail");
                c.Country = context.Request.Params.Get("country");
                CustomerDAO.MakePersistent(c);
                if (change)
                    UpdateRequests(c);
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
            Customer c = CustomerBO.GetLoggedInCustomer();
            if (c.Password == context.Request.Params.Get("oldpassword"))
            {
                c.Password = context.Request.Params.Get("newpassword");
                CustomerDAO.MakePersistent(c);
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
    public void UpdateRequests(Customer c)
    {
        IList<BookRequest> blist = BookRequestDAO.GetBookRequests(new NameValueCollection());
        foreach (BookRequest b in blist)
        {
            b.ContactDetails.Email = c.Email;
            b.ContactDetails.Phone = c.ContactNo;
            b.ContactDetails.Name = c.Name;
            BookRequestDAO.MakePersistent(b);
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