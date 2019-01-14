<%@ WebHandler Language="C#" Class="UpdateOperators" %>

using System;
using System.Web;
using Entities;
using DataAccessLayer;
using System.Collections;
using Newtonsoft.Json;
using BusinessLayer;
using System.Collections.Generic;
using Helper;
public class UpdateOperators : IHttpHandler
{

    public void ProcessRequest(HttpContext context)
    {
        
        if (context.Request.Params.Get("sendgeneratepass") != null)
        {
            Operator o = OperatorDAO.FindOperatorByID(Int64.Parse(context.Request.Params.Get("opid")));
            o.Password = OperatorBO.GeneratePassword();
            OperatorDAO.MakePersistent(o);
            EmailBO em = new EmailBO("OperatorForgotPassword", "US");
            em.SendEmailToOperator(o);
            context.Response.Write("saved");
        }
        if (context.Request.Params.Get("operatoradd") != null)
        {
            context.Response.ContentType = "application/json";

            Operator check = OperatorDAO.GetOperatorByLoginEmail(context.Request.Params.Get("Email"));
            if (check != null)
            {
                String resp = "";
                resp += "{'error':'1','text':'Login email already present.',";
                resp += "'operator':" + JavaScriptConvert.SerializeObject(check) + "}";
                context.Response.Write(resp);
            }
            else
            {
                Operator o = new Operator();
                if (context.Request.Params.Get("generatepass") == "on")
                    o.Password = OperatorBO.GeneratePassword();

                o.Email = context.Request.Params.Get("Email");
                o.CompanyName = context.Request.Params.Get("operatorname");
                o.ContactNo = context.Request.Params.Get("contactno");
                o.ContactNo1 = context.Request.Params.Get("alternatecontactno");
                o.Email1 = context.Request.Params.Get("alternateemail");
                o.NSOPRegNo = context.Request.Params.Get("nsopregno");
                o.OperatorShortName = context.Request.Params.Get("operatorshortname");
                o.Address = context.Request.Params.Get("address");
                o.Country = context.Request.Params.Get("country");
                o.Status = 1;
                foreach (String s in context.Request.Params.Get("countries").Split(",".ToCharArray()))
                {
                    o.OperatorCountries.Add(s);
                }
                OperatorDAO.MakePersistent(o);

                String resp = "";
                resp += "{'success':'1','text':'Operator Saved.',";
                resp += "'operator':" + JavaScriptConvert.SerializeObject(o) + "}";
                context.Response.Write(resp);


            }
        }
        if (context.Request.Params.Get("updateoperator") != null)
        {
            Operator o = OperatorDAO.FindOperatorByID(Int64.Parse(context.Request.Params.Get("opid")));
            Int32 tempstatus = 1;
            String property = context.Request.Params.Get("property");
            if(property=="Email")
            {
                Operator check = OperatorDAO.GetOperatorByLoginEmail(context.Request.Params.Get("value"));
                if (check == null)
                    o.Email = context.Request.Params.Get("value");
            }
            else if (property == "Status")
            {
                tempstatus = o.Status;
                o.Status = Int32.Parse(context.Request.Params.Get("value"));
                         
            }
            else
            {
                o.GetType().GetProperty(property).SetValue(o, context.Request.Params.Get("value"), null);
            }
            
            OperatorDAO.MakePersistent(o);
            if (tempstatus == 0 && o.Status == 1)
            {
                EmailBO em = new EmailBO("OperatorRegistrationApproval", "US");
                em.SendEmailToOperator(o);
            }
            context.Response.Write(o.GetType().GetProperty(property).GetValue(o, null));


        }
        if (context.Request.Params.Get("opcountriessave") != null)
        {
            Operator o = OperatorDAO.FindOperatorByID(Int64.Parse(context.Request.Params.Get("opid")));
            o.OperatorCountries.Clear();
            foreach (String s in context.Request.Params.Get("operatorcountries").Split(",".ToCharArray()))
            {
                o.OperatorCountries.Add(s);
            }
            OperatorDAO.MakePersistent(o);


            String resp = "";
            foreach (String s in o.OperatorCountries)
            {
                resp += s + ",";

            }
            if (resp != "")
                resp.Remove(resp.LastIndexOf(","));

            context.Response.Write("{'saved':'Saved.','clist':'" + resp + "'}");

        }
        if (context.Request.Params.Get("operatorremove") != null)
        {
            Operator o = OperatorDAO.FindOperatorByID(Int64.Parse(context.Request.Params.Get("opid")));
           
            foreach (OperatorRequest or in BookRequestDAO.GetOperatorRequests(o))
            {
                or.Status = 2;
                BookRequestDAO.MakePersistent(or);
            }
            foreach (Airplane a in o.Aircrafts)
            {
                a.Status = 2;
                OperatorDAO.MakePersistent(a);
            }
            foreach (OperatorBid ob in BookRequestDAO.GetBidsOfOperator(o))
            {
                ob.Status = 2;
                BookRequestDAO.SaveBid(ob);
            }
            o.Status = 2;
            OperatorDAO.MakePersistent(o);
           
            context.Response.Redirect(context.Request.UrlReferrer.OriginalString);
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