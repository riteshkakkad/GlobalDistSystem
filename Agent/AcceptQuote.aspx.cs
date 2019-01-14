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

public partial class Agent_AcceptQuote : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (Request.Params.Get("acceptquote") != null)
        {
            OperatorBid ob = BookRequestDAO.GetOperatorBidByID(Int64.Parse(Request.Params.Get("bidid")));
            ob.Request.AcceptedBid = ob;
            BookRequestDAO.MakePersistent(ob.Request);
            EmailBO em = new EmailBO("AcceptBidNotification", ob.Request.Domain.CountryID.ToString());
            em.SendEmailToAdmin(ob.Request);
            Response.Redirect(Request.UrlReferrer.OriginalString);

        }
    }
}
