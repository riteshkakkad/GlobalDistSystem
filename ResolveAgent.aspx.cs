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
using BusinessLayer;

public partial class ResolveAgent : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        Agent a = AgentBO.CheckAgentCode(Request.Params.Get("Agent"));
        if (a != null)
        {
            Session.Add("AgentID", a.AgentID);
            Session.Timeout = 60;
            Response.Redirect("QuickQuote.aspx");
        }
        else
        {
            Response.Write("Authentication failed.");
        }

    }
}
