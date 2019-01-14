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

public partial class Operators_ShowEmptyLegBids : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (Request.Params.Get("acceptoffer") != null)
        {
            EmptyLegOffer elo = BookRequestDAO.FindEmptyLegOfferByID(Int64.Parse(Request.Params.Get("eloid")));
            elo.EmptyLeg.AcceptedOffer = elo;
            BookRequestDAO.MakePersistent(elo.EmptyLeg);
            EmailBO em = new EmailBO("EmptyLegAcceptedOfferNotificationToCustomer", Session["Country"].ToString());
            if (elo.IsAgent)
                em.SendEmailToAgent(elo.Agent);
            else
                em.SendEmailToCustomer(elo.Customer);

            Response.Redirect("ShowEmptyLegs.aspx");
        }
    }
}
