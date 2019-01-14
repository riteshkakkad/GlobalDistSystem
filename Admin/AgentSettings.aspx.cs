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

public partial class Admin_AgentSettings : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        Agent a = AgentDAO.FindAgentByID(Int64.Parse(Request.Params.Get("aid")));
        if (Request.Params.Get("generatepassword") != null)
        {
            a.Password = AgentBO.GeneratePassword();
            AgentDAO.MakePersistent(a);
            Session["done"] = "1";
        }
        if (Request.Params.Get("generatecode") != null)
        {
            a.CalculateAgentCode();
            AgentDAO.MakePersistent(a);
            Session["done"] = "1";
        }
        if (Request.Params.Get("emaillink") != null)
        {
            Session["done"] = "1";
            EmailBO em = new EmailBO("AgentPersonalDetails", a.Domain);
            em.SendEmailToAgent(a);
        }
    }
}
