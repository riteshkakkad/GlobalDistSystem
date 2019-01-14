<%@ WebHandler Language="C#" Class="UpdateEmptyLegs" %>

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
public class UpdateEmptyLegs : IHttpHandler
{

    public void ProcessRequest(HttpContext context)
    {

        if (context.Request.Params.Get("addemptyleg") != null || context.Request.Params.Get("editemptyleg") != null)
        {
            Airfield source = AirfieldBO.AirfieldFromAutoComplete(context.Request.Params.Get("source"));
            Airfield destination = AirfieldBO.AirfieldFromAutoComplete(context.Request.Params.Get("destination"));
            try
            {
                if (source != null && destination != null)
                {
                    EmptyLeg el = null;
                    if (context.Request.Params.Get("addemptyleg") != null)
                    {
                        el = new EmptyLeg();
                        el.PostedOn = DateTime.Now;
                    }
                    else
                    {
                        el = BookRequestDAO.FindEmptyLegByID(Int64.Parse(context.Request.Params.Get("eid")));
                        el.Status = Int32.Parse(context.Request.Params.Get("status"));
                    }
                    el.ActualPrice = Double.Parse(context.Request.Params.Get("actualprice"));
                    el.OfferPrice = Double.Parse(context.Request.Params.Get("offerprice"));
                    el.Source = source;
                    el.Destination = destination;
                    el.DepartureFromDate = DateTime.Parse(context.Request.Params.Get("datefrom") + " " + context.Request.Params.Get("timefrom"));
                    el.DepartureToDate = DateTime.Parse(context.Request.Params.Get("dateto") + " " + context.Request.Params.Get("timeto"));
                    el.Aircraft = OperatorDAO.FindAircraftByID(Int64.Parse(context.Request.Params.Get("aircraftlist")));
                    el.Currency = AdminDAO.GetCurrencyByID(context.Request.Params.Get("currency"));
                    BookRequestDAO.MakePersistent(el);
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
        if (context.Request.Params.Get("removeemptyleg") != null)
        {
            EmptyLeg el = BookRequestDAO.FindEmptyLegByID(Int64.Parse(context.Request.Params.Get("eid")));
            el.Status = 2;
            BookRequestDAO.MakePersistent(el);
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