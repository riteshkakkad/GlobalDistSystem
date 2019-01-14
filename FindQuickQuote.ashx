<%@ WebHandler Language="C#" Class="FindQuickQuote" %>

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


public class FindQuickQuote : IHttpHandler, IRequiresSessionState
{

    public void ProcessRequest(HttpContext context)
    {
        if (context.Request.Params.Get("emaildetailedquote") != null)
        {
            String content = context.Request.Params.Get("emailcontent");
            String emailid = context.Request.Params.Get("emailid");
            EmailBO em = new EmailBO("DetailedQuote", context.Session["Country"].ToString());
            em.SendDetailedQuoteToCustomer(emailid, content);
            context.Response.Write("saved");
        }
        else
        {

            context.Response.ContentType = "application/json";
            String airfieldstring = null;
            try
            {


                Int32 noflegs = Int32.Parse(context.Request.Params.Get("nooflegs"));
                BookRequest b = new BookRequest();
                AirplaneType apt = OperatorDAO.FindAircraftTypeByID(context.Request.Params.Get("aircrafttype"));
                b.PlaneType = apt;

                b.TripType = context.Request.Params.Get("TripType").Trim();

                String alternatefields = "";
                String selectedfields = "";
                for (int i = 1; i <= noflegs; i++)
                {
                    Leg l = new Leg();
                    airfieldstring += context.Request.Params.Get("fromleg" + i) + "-" + context.Request.Params.Get("toleg" + i) + ",";
                    l.Sequence = i;
                                            
                    ListSet fromairfields = AirfieldBO.GetAirfields(context.Request.Params.Get("fromleg" + i));
                    ListSet toairfields = AirfieldBO.GetAirfields(context.Request.Params.Get("toleg" + i));
                    alternatefields += "'afromleg" + i + "':[";
                    if (!b.PlaneType.IsHelicopter())
                    {
                        fromairfields = AirfieldBO.RemoveHeliports(fromairfields);
                        toairfields = AirfieldBO.RemoveHeliports(toairfields);
                    }

                    foreach (Airfield a in fromairfields)
                    {

                        if (l.Source == null)
                        {
                            l.Source = a;
                            String tempastring = "";
                            if (a.ICAOCODE.StartsWith("T-T"))
                            {
                                tempastring = context.Request.Params.Get("fromleg" + i);
                            }
                            else
                            {
                                tempastring = l.Source.GetAirfieldString().Replace("'", "");
                            }
                                
                            selectedfields += "'fromleg" + i + "':'" + tempastring + "',";
                        }
                        else
                        {
                            alternatefields += "'" + a.GetAirfieldString().Replace("'", "") + "',";
                        }


                    }
                    if (alternatefields.EndsWith(","))
                        alternatefields = alternatefields.Remove(alternatefields.LastIndexOf(","));

                    alternatefields += "],";
                    alternatefields += "'atoleg" + i + "':[";
                    foreach (Airfield a in toairfields)
                    {

                        if (l.Destination == null)
                        {
                            l.Destination = a;
                            String tempastring = "";
                            if (a.ICAOCODE.StartsWith("T-T"))
                            {
                                tempastring = context.Request.Params.Get("toleg" + i);
                            }
                            else
                            {
                                tempastring = l.Destination.GetAirfieldString().Replace("'", "");
                            }

                          selectedfields += "'toleg" + i + "':'" + tempastring + "',";
                        }
                        else
                        {
                            alternatefields += "'" + a.GetAirfieldString().Replace("'", "") + "',";
                        }


                    }
                    if (alternatefields.EndsWith(","))
                        alternatefields = alternatefields.Remove(alternatefields.LastIndexOf(","));

                    alternatefields += "],";
                    b.AddLeg(l);
                }

                if (!BookRequestBO.CheckHeliportSupport(b))
                    throw new HeliportException();

                String formattedquote = String.Format("{0:n}", (Int32)BookRequestBO.GetQuickQuote(b));

                String alternatequotes = "[";
                IList<AirplaneType> templist=OperatorDAO.GetPlaneTypesForSession();
                templist.Remove(apt);
                foreach (AirplaneType at in templist)
                {

                    b.PlaneType = at;
                    String tempquote = String.Format("{0:n}", (Int32)BookRequestBO.GetQuickQuote(b));
                    tempquote= tempquote.Remove(tempquote.LastIndexOf("."));
                    alternatequotes += "{'aquote':'" + tempquote + "','planetypeid':'" + at.PlaneTypeID + "'},";
                }
                alternatequotes += "{}]";
                String res = "";
                res += "{" + alternatefields + selectedfields + "'quote':'" + formattedquote.Remove(formattedquote.LastIndexOf(".")) + "','nooflegs':" + b.Legs.Count + ",'currency':'" + AdminBO.GetCountry().Currency.ShortName + "','alternatequotes':"+alternatequotes+"}";

                context.Response.Write(res);

            }
            catch (HeliportException hx)
            {
                context.Response.Write("{'error':'One of the field is a heliport.Only midsize helicopters or large helicopters are supported.'}");
            }
            catch (Exception ex)
            {
                //AdminBO.ErrorMailSender(ex.ToString() + airfieldstring, ex.TargetSite.Name);
                context.Response.Write("{'error':'Airfields not found. Use Autocomplete feature.'}");
                //Response.Write("<span style='font-size:12px;padding-left:20px'>Airfields not found. Use Autocomplete feature.</span>");
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