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

public partial class Login : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (Request.Params.Get("ReturnUrl") != null)
        {
            if (Request.Params.Get("ReturnUrl").Contains("/Operators/"))
            {
                Response.Redirect("Operators/Login.aspx?ReturnUrl=" + Request.Params.Get("ReturnUrl"));
            }
            if (Request.Params.Get("ReturnUrl").Contains("/Admin/"))
            {
                Response.Redirect("Admin/Login.aspx?ReturnUrl=" + Request.Params.Get("ReturnUrl"));
            }
            if (Request.Params.Get("ReturnUrl").Contains("/Agent/"))
            {
                Response.Redirect("Agent/Login.aspx?ReturnUrl=" + Request.Params.Get("ReturnUrl"));
            }
            if (Request.Params.Get("ReturnUrl").Contains("/Customer/"))
            {
                Response.Redirect("Customer/Login.aspx?ReturnUrl=" + Request.Params.Get("ReturnUrl"));
            }
        }
    }
}
