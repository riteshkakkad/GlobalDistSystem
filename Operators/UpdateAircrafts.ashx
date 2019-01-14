<%@ WebHandler Language="C#" Class="UpdateAircrafts" %>

using System;
using System.Web;
using Entities;
using DataAccessLayer;
using System.Collections;
using Newtonsoft.Json;
using BusinessLayer;
using System.Collections.Generic;
using Helper;

public class UpdateAircrafts : IHttpHandler
{
    public void ProcessRequest(HttpContext context)
    {

        if (context.Request.Params.Get("aircraftadd") != null)
        {
            context.Response.ContentType = "application/json";
            try
            {
                Airplane a = new Airplane();
                a.AircraftName = context.Request.Params.Get("AircraftName");
                a.PassengerCapacity = Int32.Parse(context.Request.Params.Get("Capacity"));
                a.PricePerHour = Double.Parse((context.Request.Params.Get("PricePerHour") == "") ? "0" : context.Request.Params.Get("PricePerHour"));
                a.AircraftLocation = context.Request.Params.Get("AircraftLocation");
                a.AircraftType = OperatorDAO.FindAircraftTypeByID(context.Request.Params.Get("aircrafttype"));
                a.Vendor = OperatorBO.GetLoggedinOperator();
                a.Currency = AdminDAO.GetCurrencyByID(context.Request.Params.Get("currency"));
                OperatorDAO.MakePersistent(a);
                String resp = "";
                resp += "{'success':'1','text':'Saved.',";
                resp += "'aircraft':" + JavaScriptConvert.SerializeObject(a) + "}";
                context.Response.Write(resp);
            }
            catch (Exception ex)
            {
                String resp = "";
                resp += "{'error':'1','text':'Some Problem.'}";
                context.Response.Write(resp);
            }

        }
        if (context.Request.Params.Get("aircraftremove") != null)
        {
            Airplane a = OperatorDAO.FindAircraftByID(Int64.Parse(context.Request.Params.Get("aid")));
            Operator op= OperatorBO.GetLoggedinOperator();
            if (op.Aircrafts.Contains(a))
            {

                a.Status = 2;
                OperatorDAO.MakePersistent(a);
            }
            String resp = "";
            resp += "{'success':'1','text':'Removed.'}";
            context.Response.Write(resp);
        }
        if (context.Request.Params.Get("aircraftupdate") != null)
        {
            Operator op= OperatorBO.GetLoggedinOperator();
            Airplane a = OperatorDAO.FindAircraftByID(Int64.Parse(context.Request.Params.Get("aid")));
            if (op.Aircrafts.Contains(a))
            {
                String property = context.Request.Params.Get("property");
                String value = context.Request.Params.Get("value");
                switch (property)
                {
                    case "AircraftName": a.AircraftName = value; break;
                    case "AircraftLocation": a.AircraftLocation = value; break;
                    case "PassengerCapacity": a.PassengerCapacity = Int32.Parse(value); break;
                    case "AircraftType": a.AircraftType = OperatorDAO.FindAircraftTypeByID(value); value = a.AircraftType.PlaneTypeName+"("+a.AircraftType.Capacity+" PAX)"; break;
                    case "Currency": a.Currency = AdminDAO.GetCurrencyByID(value); value = a.Currency.FullName + "(" + a.Currency.ID + ")"; break;
                    case "Price": a.PricePerHour = Double.Parse((value == "") ? "0" : value); break;
                    default: break;
                }

                OperatorDAO.MakePersistent(a);
                context.Response.Write(value);
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