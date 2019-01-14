<%@ WebHandler Language="C#" Class="UpdateAirfields" %>

using System;
using System.Web;
using Entities;
using DataAccessLayer;
using System.Collections;
using Newtonsoft.Json;
using BusinessLayer;
using System.Collections.Generic;
public class UpdateAirfields : IHttpHandler
{

    public void ProcessRequest(HttpContext context)
    {
        context.Response.ContentType = "text/plain";
        if (context.Request.Params.Get("addairfieldsubmit") != null)
        {
            context.Response.ContentType = "application/json";
            Airfield check = AirfieldDAO.FindAirfieldByICAO(context.Request.Params.Get("icaocode"));
            if (check != null)
            {
                String resp = "";
                resp += "{'error':'1','text':'Airfield ICAOCODE already present.',";
                resp += "'airfield':" + JavaScriptConvert.SerializeObject(check) + "}";
                context.Response.Write(resp);
            }
            else
            {
                IList<Airfield> salist = AirfieldDAO.FindSimilarAirfieldsByName(context.Request.Params.Get("airfieldname"), context.Request.Params.Get("country"));
                if (salist.Count > 0 && context.Request.Params.Get("saveairfieldbyforce")=="false")
                {
                    String resp = "";
                    resp += "{'similar':'1','text':'Similar Airfield Found.','similarairfields':[";
                    foreach(Airfield a in salist)
                    {
                       resp += JavaScriptConvert.SerializeObject(a) + ","; 
                    }
                    resp=resp.Remove(resp.LastIndexOf(","));
                    resp += "]}";
                    context.Response.Write(resp); 
                }
                else
                {

                    String icaocode = null;
                    if (context.Request.Params.Get("autoassign") == "heliport")
                    {
                        icaocode = "A-A" + AirfieldBO.GetAutoassignedNumberForHeliports().ToString();
                    }
                    else if (context.Request.Params.Get("autoassign") == "unavail")
                    {
                        icaocode = "B-B" + AirfieldBO.GetAutoassignedNumberForAirfields().ToString();
                    }
                    else
                    {
                        icaocode = context.Request.Params.Get("icaocode");
                    }



                    Airfield a = new Airfield();
                    a.ICAOCODE = icaocode;
                    a.IATACode = context.Request.Params.Get("iatacode");
                    a.AirfieldName = context.Request.Params.Get("airfieldname");
                    a.City = context.Request.Params.Get("city");
                    a.State = context.Request.Params.Get("state");
                    a.Country = context.Request.Params.Get("country");
                    a.AlternativeNames = context.Request.Params.Get("alternativenames");
                    a.LongitudeDegrees = Int32.Parse(context.Request.Params.Get("longitudedegrees"));
                    a.LongitudeMinutes = Int32.Parse(context.Request.Params.Get("longitudemins"));
                    a.LattitudeDegrees = Int32.Parse(context.Request.Params.Get("lattitudedegrees"));
                    a.LattitudeMinutes = Int32.Parse(context.Request.Params.Get("lattitudemins"));
                    a.Runway = (context.Request.Params.Get("runway") != "") ? Int32.Parse(context.Request.Params.Get("runway")) : 0;
                    a.Altitude = (context.Request.Params.Get("altitude") != "") ? Int32.Parse(context.Request.Params.Get("altitude")) : 0;
                    a.EW = Char.Parse(context.Request.Params.Get("longitudeew"));
                    a.NS = Char.Parse(context.Request.Params.Get("lattitudens"));

                    AirfieldDAO.AddAirfield(a);
                    String resp = "";
                    resp += "{'text':'Airfield Saved',";
                    resp += "'airfield':" + JavaScriptConvert.SerializeObject(a) + "}";
                    context.Response.Write(resp);
                }
            }
        }
        else if (context.Request.Params.Get("removeairfield")!=null)
        {
            Airfield a = AirfieldDAO.FindAirfieldByICAO(context.Request.Params.Get("aid"));
            NHibernateHelper.GetCurrentSession().Delete(a);
            context.Response.Redirect(context.Request.UrlReferrer.OriginalString);
        }
        else
        {


            Airfield a = AirfieldDAO.FindAirfieldByICAO(context.Request.Params.Get("aid"));
            if (a != null)
            {
                String value = context.Request.Params.Get("value");
                String property = context.Request.Params.Get("property");
                switch (property)
                {
                    case "city": a.City = value; break;
                    case "state": a.State = value; break;
                    case "airfieldname": a.AirfieldName = value; break;
                    case "iatacode": a.IATACode = value; break;
                    case "longdegrees": a.LongitudeDegrees = Int32.Parse(value); break;
                    case "longmins": a.LongitudeMinutes = Int32.Parse(value); break;
                    case "longew": a.EW = Char.Parse(value); break;
                    case "latdegrees": a.LattitudeDegrees = Int32.Parse(value); break;
                    case "latmins": a.LattitudeMinutes = Int32.Parse(value); break;
                    case "latew": a.NS = Char.Parse(value); break;
                    case "countries": a.Country = value; break;  
                    case "alternatenames":

                        ArrayList received = new ArrayList(value.Split(",".ToCharArray()));
                        received.Remove("");
                        value = "";
                        if (received.Count > 0)
                        {
                            foreach (String s in received)
                            {
                                if (s.Trim() != "")
                                    value += s + ", ";
                            }
                            if (value != "")
                                value = value.Remove(value.LastIndexOf(","));
                        }

                        a.AlternativeNames = value;

                        break;
                    default: break;
                }
                AirfieldDAO.MakePersistent(a);

                context.Response.Write(value);
            }
            else
            {
                context.Response.Write("error");
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