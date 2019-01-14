<%@ WebHandler Language="C#" Class="ReturnAirfields" %>

using System;
using System.Web;
using DataAccessLayer;
using Entities;
using System.Collections;
using System.Collections.Generic;
using Iesi.Collections;
using System.Web.SessionState;

public class ReturnAirfields : IHttpHandler,IRequiresSessionState
{

    public void ProcessRequest(HttpContext context)
    {
        context.Response.ContentType = "text/plain";
        String atext = context.Request.Params.Get("q");
        String resp = "";
        IList<Airfield> alistbyname = AirfieldDAO.FindByAirfieldName(atext, "Start");
       
        
        if (alistbyname.Count > 0)
        {
            foreach (Airfield a in alistbyname)
            {
                resp += a.GetAirfieldString() + "|" + a.ICAOCODE + "\n";
            }
        }
        
        Airfield abyicao = AirfieldDAO.FindAirfieldByICAO(atext);
        if(abyicao!=null)
            resp += abyicao.GetAirfieldString() + "|" + abyicao.ICAOCODE + "\n";

        Airfield abyiata = AirfieldDAO.FindAirfieldByIATA(atext);
        if (abyiata != null)
            resp += abyiata.GetAirfieldString() + "|" + abyiata.ICAOCODE + "\n";


        if (resp == "")
        {
            IList<Airfield> alistbyaltname = AirfieldDAO.FindAirfieldByAlternativeNames(atext);
            foreach (Airfield a in alistbyaltname)
            {
                resp += a.GetAirfieldString() + "|" + a.ICAOCODE + "\n";
            }
        }
        if (resp == "")
        {
            IList<Airfield> alistbycity = AirfieldDAO.FindAirfieldByCity(atext,"");
            foreach (Airfield a in alistbycity)
            {
                resp += a.GetAirfieldString() + "|" + a.ICAOCODE + "\n";
            }
        }
        
        context.Response.Write(resp);
    }

    public bool IsReusable
    {
        get
        {
            return false;
        }
    }

}