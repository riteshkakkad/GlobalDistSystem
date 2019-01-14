<%@ WebHandler Language="C#" Class="UpdateCurrencies" %>

using System;
using System.Web;
using Entities;
using DataAccessLayer;
using Newtonsoft.Json;

public class UpdateCurrencies : IHttpHandler
{

    public void ProcessRequest(HttpContext context)
    {
        context.Response.ContentType = "text/plain";
        if (context.Request.Params.Get("currencyadd") != null)
        {
            String id = context.Request.Params.Get("currencyid");
            Currency c = AdminDAO.CheckCurrencyByID(id);
            if (c != null)
            {
                String resp = "";
                resp += "{'error':'1','text':'Currency ID already present.',";
                resp += "'currency':" + JavaScriptConvert.SerializeObject(c) + "}";
                context.Response.Write(resp);

            }
            else
            {
                c = new Currency();
                c.ID = id;
                c.FullName = context.Request.Params.Get("fullname");
                c.ShortName = context.Request.Params.Get("shortname");
                c.Rate = Double.Parse(context.Request.Params.Get("rate"));
                c.TimeOfRate = DateTime.Now;
                AdminDAO.AddCurrency(c);
                String resp = "";
                resp += "{'success':'1','text':'Saved.',";
                resp += "'currency':" + JavaScriptConvert.SerializeObject(c) + "}";
                context.Response.Write(resp);
            }
        }
        if (context.Request.Params.Get("removecurrency") != null)
        {
            Currency c = AdminDAO.GetCurrencyByID(context.Request.Params.Get("cid"));
            NHibernateHelper.GetCurrentSession().Delete(c);
            context.Response.Redirect(context.Request.UrlReferrer.OriginalString);
        }
        if (context.Request.Params.Get("updatecurrency") != null)
        {
            Currency c = AdminDAO.GetCurrencyByID(context.Request.Params.Get("cid"));
            String property = context.Request.Params.Get("property");
            String value = context.Request.Params.Get("value");

            switch (property)
            {
                case "Full Name": c.FullName = value; break;
                case "Short Name": c.ShortName = value; break;
                case "Rate": c.Rate = Double.Parse(value); c.TimeOfRate = DateTime.Now; break;
                default: break;
            }
            context.Response.Write(value);

        }
        if (context.Request.Params.Get("getcountrycurrency") != null)
        {
            String resp = "";
            if (context.Request.Params.Get("cid") != "select")
            {
                Country c = AdminDAO.GetCountryByID(context.Request.Params.Get("cid"));

                if (c.Currency != null)
                    resp = c.Currency.FullName + "(" + c.Currency.ID + ")";

            }
            else
            {
                resp += "select country";
            }
            context.Response.Write("{'currency':'" + resp + "'}");

        }
        if (context.Request.Params.Get("countrycurrencyupdate") != null)
        {
            String resp = "";
            if (context.Request.Params.Get("cid") != "select")
            {
                Country c = AdminDAO.GetCountryByID(context.Request.Params.Get("cid"));
               
                if (context.Request.Params.Get("value") != "null")
                {
                    Currency cr = AdminDAO.GetCurrencyByID(context.Request.Params.Get("value"));
                    c.Currency = cr;
                    resp = cr.FullName + "(" + cr.ID + ")";
                }
                else
                {
                    c.Currency = null;
                    resp = "Not specified";
                }
                AdminDAO.MakePersistent(c);
            }
            else
            {
                resp = "Select country"; 
            }
            context.Response.Write(resp);
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