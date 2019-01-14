<%@ WebHandler Language="C#" Class="ChangeCountry" %>

using System;
using System.Web;
using System.Web.SessionState;
using BusinessLayer;

public class ChangeCountry : IHttpHandler, IRequiresSessionState
{

    public void ProcessRequest(HttpContext context)
    {
        String country = context.Request.Params.Get("c");
        HttpCookie newcookie = new HttpCookie("airnetz-country-setup", country);
        newcookie.Domain = "airnetzcharter.com";
        newcookie.Expires = DateTime.Now.AddDays(2);
        context.Response.Cookies.Add(newcookie);
        context.Response.Redirect(AdminBO.GetRedirectionUrlWithParams(context.Request.UrlReferrer, country));
      
    }

    public bool IsReusable
    {
        get
        {
            return false;
        }
    }

}