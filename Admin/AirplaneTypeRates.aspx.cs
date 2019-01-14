using System;
using System.Data;
using System.Configuration;
using System.Collections;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using BusinessLayer;
using System.Collections.Generic;
using System.Collections.Specialized;
using Entities;
using DataAccessLayer;
public partial class AirplaneTypeRates : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        AdminMaster m = (AdminMaster)Page.Master;
        m.selectedtab = "rates";
        if (Request.Params.Get("searchratebtn") != null)
        {
            NameValueCollection nvc = new NameValueCollection();
            String tempkey = null;
            String tempval = null;
            Boolean flag = true;
            for (int i = 0; i < Request.QueryString.Count; i++)
            {

                tempkey = Request.QueryString.GetKey(i);
                tempval = Request.QueryString.Get(i);

                if (tempkey != "searchratebtn")
                {

                    if (tempval != "all")
                    {
                        flag = true;
                    }
                    else
                    {
                        flag = false;
                    }
                }
                else
                {
                    flag = false;
                }

                if (flag)
                {
                    nvc.Add(tempkey, tempval);
                }



            }
           

            if (AdminBO.Serialize(nvc) != "")
            {
                Response.Redirect("AirplaneTypeRates.aspx?" + AdminBO.Serialize(nvc));
            }
            else
            {
                Response.Redirect("AirplaneTypeRates.aspx");
            }
        }
        if (Request.Params.Get("addairplanetype") != null)
        {
            AirplaneType at= OperatorDAO.FindAircraftTypeByID(Request.Params.Get("aircrafttype_add"));
            Country c = AdminDAO.GetCountryByID(Request.Params.Get("country_add"));

            if (OperatorDAO.GetRateForCountryAndAirplaneType(at, c).Count > 0)
            {
                Session["alreadypresent"] = "1";
            }
            else
            {
                AirplaneTypeRate atr = new AirplaneTypeRate();
                atr.Country = c;
                atr.PlaneType = at;
                atr.HourlyRate = Double.Parse(Request.Params.Get("hourlyrate"));
                atr.NightHalt = Double.Parse(Request.Params.Get("nighthalt"));
                atr.WaitingCharge = Double.Parse(Request.Params.Get("waitingcharge"));
                atr.WatchHour = Double.Parse(Request.Params.Get("watchhour"));
                atr.FuelPositioning = Double.Parse(Request.Params.Get("fuelpositioning")); ;
                atr.Crew = Double.Parse(Request.Params.Get("crew"));
                at.AirplaneTypeRates.Add(atr);
                OperatorDAO.SaveAirplaneType(at);
            }
            Response.Redirect(Request.UrlReferrer.OriginalString);
        }
        if (Request.Params.Get("removerate") != null)
        {
            AirplaneTypeRate atr = OperatorDAO.GetAirplaneTypeRateByID(Int64.Parse(Request.Params.Get("rid")));
            NHibernateHelper.GetCurrentSession().Delete(atr);
            Response.Redirect(Request.UrlReferrer.OriginalString);
        }
    }
}
