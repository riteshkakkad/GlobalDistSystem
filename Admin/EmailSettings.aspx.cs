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

public partial class Admin_EmailSettings : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        AdminMaster m = (AdminMaster)Page.Master;
        m.bodyclass = "yui-skin-sam";

        if (Request.Params.Get("emailon") != null)
        {
            if (Request.Params.Get("emailon") == "1")
            {
                foreach (EmailSetting es in AdminDAO.GetEmailSettings())
                {
                    es.Send = true;
                    AdminDAO.MakePersistent(es);
                }

            }
            else if (Request.Params.Get("emailon") == "0")
            {
                foreach (EmailSetting es in AdminDAO.GetEmailSettings())
                {
                    es.Send = false;
                    AdminDAO.MakePersistent(es);
                }
            }
            Response.Redirect("EmailSettings.aspx");

        }
    }
}
