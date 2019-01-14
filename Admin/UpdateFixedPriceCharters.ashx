<%@ WebHandler Language="C#" Class="UpdateFixedPriceCharters" %>

using System;
using System.Web;
using Entities;
using DataAccessLayer;
using BusinessLayer;
using Iesi.Collections;
using System.Collections;
using System.Collections.Generic;
using Helper;
using Exceptions;
using Newtonsoft.Json;

public class UpdateFixedPriceCharters : IHttpHandler
{

    public void ProcessRequest(HttpContext context)
    {
        if (context.Request.Params.Get("addfixedpricecharter") != null || context.Request.Params.Get("editfixedpricecharter") != null)
        {
            Airfield source = AirfieldBO.AirfieldFromAutoComplete(context.Request.Params.Get("source"));
            Airfield destination = AirfieldBO.AirfieldFromAutoComplete(context.Request.Params.Get("destination"));
            try
            {
                if (source != null && destination != null)
                {
                    FixedPriceCharter fp = null;
                    if (context.Request.Params.Get("addfixedpricecharter") != null)
                    {
                        fp = new FixedPriceCharter();
                        fp.PostedOn = DateTime.Now;
                    }
                    else
                    {
                        fp = BookRequestDAO.FindFixedPriceCharterByID(Int64.Parse(context.Request.Params.Get("fid")));
                        fp.Status = Int32.Parse(context.Request.Params.Get("status"));
                    }

                    fp.Quote = Double.Parse(context.Request.Params.Get("quote"));
                    fp.Source = source;
                    fp.Destination = destination;

                    fp.ExpiresOn = DateTime.Parse(context.Request.Params.Get("expiredate"));
                    fp.Aircraft = OperatorDAO.FindAircraftByID(Int64.Parse(context.Request.Params.Get("aircraftlist")));
                    fp.Currency = AdminDAO.GetCurrencyByID(context.Request.Params.Get("currency"));
                    BookRequestDAO.MakePersistent(fp);
                    context.Response.Write("{'saved':'Saved.'}");

                }
                else
                {
                    ListSet sourcelist = AirfieldBO.GetAirfields(context.Request.Params.Get("source"));
                    ListSet destinationlist = AirfieldBO.GetAirfields(context.Request.Params.Get("destination"));
                    String resp = "{";
                    if (sourcelist.Count > 0 && destinationlist.Count > 0)
                    {
                        if (source != null)
                            sourcelist.Remove(source);
                        if (destination != null)
                            destinationlist.Remove(destination);

                        resp += "\"sourcelist\":" + JavaScriptConvert.SerializeObject(sourcelist) + ",\"destinationlist\":" + JavaScriptConvert.SerializeObject(destinationlist) + "";

                    }
                    else
                    {
                        resp += "'airfielderror':'1'";
                    }
                    resp += "}";
                    context.Response.Write(resp);
                }
            }
            catch (Exception ex)
            {
                context.Response.Write("{'error':'1'}");
            }
        }
        if (context.Request.Params.Get("removefixedpricecharter") != null)
        {
            FixedPriceCharter fp = BookRequestDAO.FindFixedPriceCharterByID(Int64.Parse(context.Request.Params.Get("fid")));
            fp.Status = 2;
            BookRequestDAO.MakePersistent(fp);
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