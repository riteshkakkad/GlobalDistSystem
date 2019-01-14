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
            Operator op = OperatorBO.GetLoggedinOperator();
            try
            {
                op.CompanyName = context.Request.Params.Get("OperatorName");
                op.Address = context.Request.Params.Get("Address");
                op.ContactNo = context.Request.Params.Get("ContactNo");
                op.ContactNo1 = context.Request.Params.Get("AlternateContactNo");
                op.Email1 = context.Request.Params.Get("AlternateEmail");
                op.NSOPRegNo = context.Request.Params.Get("NSOPRegNo");
                op.Country = context.Request.Params.Get("country");
                op.OperatorCountries.Clear();
                foreach (String s in context.Request.Params.Get("countries").Split(",".ToCharArray()))
                {
                    op.OperatorCountries.Add(s);
                }

                OperatorDAO.MakePersistent(op);
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
            Operator op = OperatorBO.GetLoggedinOperator();
            if (op.Password == context.Request.Params.Get("oldpassword"))
            {
                op.Password = context.Request.Params.Get("newpassword");
                OperatorDAO.MakePersistent(op);
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