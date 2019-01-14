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
using System.Xml;
using Entities;
using DataAccessLayer;

public partial class CharterTemplate : System.Web.UI.MasterPage
{
    private String _selectedtab;
    private String _pricingdisclaimer;
    private String _copyright;

    public String selectedtab
    {
        get { return _selectedtab; }
        set { _selectedtab = value; }
    }
    public String pricingdisclaimer
    {
        get { return _pricingdisclaimer; }
        set { _pricingdisclaimer = value; }
    }
    public String copyright
    {
        get { return _copyright; }
        set { _copyright = value; }
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        Country c = AdminDAO.GetCountryByID(Session["Country"].ToString());
        copyright = c.CopyRight;
        pricingdisclaimer = c.PricingDisclaimer;
        
        if (selectedtab == "home")
            home.Attributes.Add("class","selected");
        if (selectedtab == "agent")
            agents.Attributes.Add("class", "selected");
        if (selectedtab == "operator")
            operators.Attributes.Add("class", "selected");
    }
}
