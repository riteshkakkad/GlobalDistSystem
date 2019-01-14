<%@ WebHandler Language="C#" Class="UpdateAirplanetypes" %>

using System;
using System.Web;
using Entities;
using DataAccessLayer;
using Newtonsoft.Json;

public class UpdateAirplanetypes : IHttpHandler
{

    public void ProcessRequest(HttpContext context)
    {

        if (context.Request.Params.Get("formaddairplanetypebtn") != null)
        {
            context.Response.ContentType = "application/json";
            AirplaneType check = OperatorDAO.FindAircraftTypeByID(context.Request.Params.Get("planetypeid"));
            if (check != null)
            {
                String resp = "";
                resp += "{'error':'1','text':'Airplane type already present.'}";
                context.Response.Write(resp);
            }
            else
            {
                AirplaneType a = new AirplaneType();
                a.PlaneTypeID = context.Request.Params.Get("planetypeid");
                a.PlaneTypeName = context.Request.Params.Get("planetypename");
                a.InitialDistance = Int32.Parse(context.Request.Params.Get("initialdistance"));
                a.MiddleDistance = Int32.Parse(context.Request.Params.Get("middledistance"));
                a.InitialSpeed = Int32.Parse(context.Request.Params.Get("initialspeed"));
                a.MiddleSpeed = Int32.Parse(context.Request.Params.Get("middlespeed"));
                a.MaximumSpeed = Int32.Parse(context.Request.Params.Get("maximumspeed"));
                a.Capacity = context.Request.Params.Get("capacity");
                a.ParentCategory = context.Request.Params.Get("parentcategory");

                a = OperatorDAO.AddAirplaneType(a);
                String resp = "";
                resp += "{'text':'Airplane type saved',";
                resp += "'airplanetype':" + JavaScriptConvert.SerializeObject(a) + "}";
                context.Response.Write(resp);
            }
        }
        if (context.Request.Params.Get("removetype") != null)
        {
            try
            {
                AirplaneType a = OperatorDAO.FindAircraftTypeByID(context.Request.Params.Get("atypeid"));
                OperatorDAO.RemoveAirplaneType(a);
                String resp = "";
                resp += "{'success':'1','text':'Airplane type removed.'}";
                context.Response.Write(resp);
            }
            catch (Exception ex)
            {
                String resp = "";
                resp += "{'error':'1','text':'" + ex.ToString() + "'}";
                context.Response.Write(resp);

            }

        }
        if (context.Request.Params.Get("updateairplanetype") != null)
        {
            AirplaneType a = OperatorDAO.FindAircraftTypeByID(context.Request.Params.Get("atypeid"));
            if (a != null)
            {
                String value = context.Request.Params.Get("value");
                String property = context.Request.Params.Get("property");
                switch (property)
                {
                    case "Plane Type Name": a.PlaneTypeName = value; break;
                    case "Initial Distance": a.InitialDistance = Int32.Parse(value); break;
                    case "Middle Distance": a.MiddleDistance = Int32.Parse(value); break;
                    case "Initial Speed": a.InitialSpeed = Int32.Parse(value); break;
                    case "Middle Speed": a.MiddleSpeed = Int32.Parse(value); break;
                    case "Maximum Speed": a.MaximumSpeed = Int32.Parse(value); break;
                    case "Capacity": a.Capacity = value; break;
                    case "Parent Category": a.ParentCategory = value; break;

                    default: break;
                }
                OperatorDAO.SaveAirplaneType(a);

                context.Response.Write(value);
            }
            else
            {
                context.Response.Write("error");
            }

        }
        if (context.Request.Params.Get("updateairplanetyperates") != null)
        {
            AirplaneTypeRate a = OperatorDAO.GetAirplaneTypeRateByID(Int64.Parse(context.Request.Params.Get("rateid")));
            String property = context.Request.Params.Get("property");
            a.GetType().GetProperty(property).SetValue(a, Double.Parse(context.Request.Params.Get("value")), null);
            OperatorDAO.SavePlanetypeRate(a);
            context.Response.Write(a.GetType().GetProperty(property).GetValue(a, null));


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