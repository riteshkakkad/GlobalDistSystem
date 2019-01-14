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

public partial class AgentRegister : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        CharterTemplate mp = (CharterTemplate)Page.Master;
        mp.selectedtab = "agent";
        Status.Visible = false;
        foreach (Country c in OperatorDAO.GetCountries())
        {
            country.Items.Add(new ListItem(c.FullName, c.CountryID));
        }
        if (Session["agentregistrationdone"] == "1")
        {
            Status.Visible = true;
            Status.InnerHtml = "Thank You.The registration details have been sent to the Airnetz Administration.You will receive an email shortly depending upon approval.";
            Status.Attributes.Add("class", "boldtext");
            Session["agentregistrationdone"] = null;
        }
        if (IsPostBack)
        {
            try
            {
                Session["operatorregistrationdone"] = null;
                if (AgentDAO.GetAgentByEmail(Email.Value) != null)
                    throw new NHibernate.HibernateException();
                Agent a = new Agent();
                a.Name = AgentName.Value;
                a.Domain = Session["Country"].ToString();
                a.Email = Email.Value;
                a.Email1 = AlternateEmail.Value;
                a.ContactNo = ContactNo.Value;
                a.ContactNo1 = AlternateContactNo.Value;
                a.Country = country.Value;
                a.BillingAddress = BillingAddress.Value;
                a.Agency = AgencyName.Value;
                a.AgentFax = Fax.Value;
                a.Password = Password.Value;
                a.CalculateAgentCode();
                a.Status = 0;
                AgentDAO.MakePersistent(a);
                Session["agentregistrationdone"] = "1";
                EmailBO em = new EmailBO("AgentRegistrationThanks", Session["Country"].ToString());
                em.SendEmailToAgent(a);
                Response.Redirect("AgentRegister.aspx", false);
            }
            catch (NHibernate.HibernateException hx)
            {
                Status.Visible = true;
                Status.Style.Add("color", "red");
                Status.InnerHtml = "Email already taken.";
                Status.Attributes.Add("class", "error");
            }
            catch (Exception ex)
            {
                Status.Visible = true;
                Status.Attributes.Add("class", "error");
                Status.InnerHtml = "Some unexpected problem occured.Please try again.";
            }
        }
    }
}
