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
using Entities;
using DataAccessLayer;
using System.Xml;
using System.Text;
using System.IO;
using Helper;

public partial class Settings : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        AdminMaster m = (AdminMaster)Page.Master;
        m.selectedtab = "settings";
        if (Request.Params.Get("settingsbtn") != null)
        {
            XmlDocument doc = new XmlDocument();
            doc.Load(Server.MapPath("~/RequestResolveSettings.xml"));
            String selectregionmatch = Request.Params.Get("regionmatch");
            foreach (XmlNode x in doc.SelectSingleNode("/requestresolve/regionmatch").ChildNodes)
            {
                if (x.HasChildNodes)
                {
                    if (x.Name == selectregionmatch)
                    {
                        x.InnerText = "true";
                    }
                    else
                    {
                        x.InnerText = "false";
                    }
                }
            }
            String selectaircraftcategorymatch = Request.Params.Get("aircraftcategorymatch");
            foreach (XmlNode x in doc.SelectSingleNode("/requestresolve/aircraftcategorymatch").ChildNodes)
            {
                if (x.HasChildNodes)
                {
                    if (x.Name == selectaircraftcategorymatch)
                    {
                        x.InnerText = "true";
                    }
                    else
                    {
                        x.InnerText = "false";
                    }
                }
            }
            doc.Save(Server.MapPath("~/RequestResolveSettings.xml"));
            Response.Redirect("Settings.aspx");
        }
        if (Request.Params.Get("defaultsettingsbtn") != null)
        {
            XmlDocument doc = new XmlDocument();
            doc.Load(Server.MapPath("~/Admin/DefaultRequestResolveSettings.xml"));
            doc.Save(Server.MapPath("~/RequestResolveSettings.xml"));
            Response.Redirect("Settings.aspx");

        }

    }

}
