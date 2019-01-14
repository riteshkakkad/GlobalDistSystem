<%@ WebHandler Language="C#" Class="GetAirfields" %>

using System;
using System.Web;
using DataAccessLayer;
using Entities;
using BusinessLayer;

using Iesi.Collections;

using NHibernate;
using System.Collections.Generic;
using Exceptions;
using System.Web.SessionState;
using Newtonsoft.Json;

public class GetAirfields : IHttpHandler,IRequiresSessionState {
    
    public void ProcessRequest (HttpContext context) {

        String text = context.Request.Params.Get("text");
        ListSet aset = new ListSet();
        aset.AddAll(SearchAifields(text));
        if (aset.Count == 0)
        {
            String[] keywords = text.Split(", ".ToCharArray());
            foreach (String s in keywords)
            {
                if (s.Length >= 3)
                {
                    aset.AddAll(SearchAifields(s));
                }
            }
        }
        context.Response.Write(JavaScriptConvert.SerializeObject(aset));

       
    }
    public ListSet SearchAifields(String text)
    {
        
        ListSet aset = new ListSet();
        IList<Airfield> alistbyname = AirfieldDAO.FindByAirfieldName(text, "Start");
        if (alistbyname.Count > 0)
        {
            foreach (Airfield a in alistbyname)
            {
                aset.Add(a);
            }
        }
        Airfield abyicao = AirfieldDAO.FindAirfieldByICAO(text);
        if (abyicao != null)
            aset.Add(abyicao);
        Airfield abyiata = AirfieldDAO.FindAirfieldByIATA(text);
        if (abyiata != null)
            aset.Add(abyiata);

        IList<Airfield> alistbycity = AirfieldDAO.FindAirfieldByCity(text, "");
        if (alistbycity.Count > 0)
        {
            foreach (Airfield a in alistbycity)
            {
                aset.Add(a);
            }
        }
        if (aset.Count == 0)
        {
            IList<Airfield> alistbystate = AirfieldDAO.FindAirfieldByState(text, "");
            if (alistbystate.Count > 0)
            {
                foreach (Airfield a in alistbystate)
                {
                    aset.Add(a);
                }
            }
        }
        return aset;
    }
 
    public bool IsReusable {
        get {
            return false;
        }
    }

}