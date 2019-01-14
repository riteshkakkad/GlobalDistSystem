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
using Helper;
using BusinessLayer;
using Iesi.Collections;
public partial class Agent_EmptyLeg : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        Agent a = AgentBO.GetLoggedInAgent();
        if (Request.Params.Get("withdrawbid") != null)
        {
            EmptyLegOffer elo = BookRequestDAO.FindEmptyLegOfferByID(Int64.Parse(Request.Params.Get("eloid")));
            if (elo.Agent.Equals(a))
            {
                elo.Status = 2;
                BookRequestDAO.MakePersistent(elo);
                EmailBO em = new EmailBO("EmptyLegOfferWithdrawNotificationToOperator", Session["Country"].ToString());
                em.SendEmailToOperator(elo.EmptyLeg.Aircraft.Vendor);
                Response.Redirect("EmptyLeg.aspx?eid=" + elo.EmptyLeg.ID);
            }
        }
        if (Request.Params.Get("withdrawaccepted") != null)
        {
            EmptyLeg el = BookRequestDAO.FindEmptyLegByID(Int64.Parse(Request.Params.Get("eid")));
            if (el.AcceptedOffer.Agent.Equals(a))
            {
                el.AcceptedOffer.Status = 2;
                BookRequestDAO.MakePersistent(el.AcceptedOffer);
                el.AcceptedOffer = null;
                BookRequestDAO.MakePersistent(el);
                EmailBO em = new EmailBO("EmptyLegAcceptedWithdrawNotificationToOperator", Session["Country"].ToString());
                em.SendEmailToOperator(el.Aircraft.Vendor);
                Response.Redirect("EmptyLeg.aspx?eid=" + el.ID);
            }
        }
        if (Request.Params.Get("acceptoffer") != null)
        {
            EmptyLeg el = BookRequestDAO.FindEmptyLegByID(Int64.Parse(Request.Params.Get("eid")));
            if (el.AcceptedOffer == null)
            {
                EmptyLegOffer elo = new EmptyLegOffer();
                elo.EmptyLeg = el;
                elo.Currency = el.Currency;
                elo.Status = 1;
                elo.TimeOfOffer = DateTime.Now;
                el.AcceptedOffer = elo;
                elo.IsAgent = true;
                elo.Customer = null;
                elo.BidAmount = el.OfferPrice;
                elo.Agent = a;
                BookRequestDAO.MakePersistent(elo);
                BookRequestDAO.MakePersistent(el);
                EmailBO em = new EmailBO("EmptyLegAcceptedOfferNotificationToOperator", Session["Country"].ToString());
                em.SendEmailToOperator(el.Aircraft.Vendor);
                Response.Redirect("EmptyLeg.aspx?eid=" + el.ID);
            }
            else
            {
                Error.InnerHtml = "* Sorry this empty leg offer have already been accepted.";
            }

        }
        else if (Request.Params.Get("savebidbtn") != null)
        {
            EmptyLeg el = BookRequestDAO.FindEmptyLegByID(Int64.Parse(Request.Params.Get("eid")));
            if (el.OfferPrice <= Double.Parse(Request.Params.Get("bidamount")))
            {
                Error.InnerHtml = "* Bid amount should be less than operator offered price.";
            }
            else if (el.AcceptedOffer != null)
            {
                Error.InnerHtml = "* Sorry this empty leg offer have already been accepted.";
            }
            else
            {
                EmptyLegOffer elo = new EmptyLegOffer();
                elo.EmptyLeg = el;
                elo.Currency = el.Currency;
                elo.Status = 1;
                elo.TimeOfOffer = DateTime.Now;
                elo.IsAgent = true;
                elo.Customer = null;
                elo.BidAmount = Double.Parse(Request.Params.Get("bidamount"));
                elo.Agent = a;
                BookRequestDAO.MakePersistent(elo);
                EmailBO em = new EmailBO("EmptyLegOfferNotificationToOperator", Session["Country"].ToString());
                em.SendEmailToOperator(el.Aircraft.Vendor);
                em = new EmailBO("EmptyLegOfferThanksToCustomer", Session["Country"].ToString());
                if (elo.IsAgent)
                    em.SendEmailToAgent(elo.Agent);
               
                ListSet othercust = new ListSet();
                
                foreach (EmptyLegOffer eloc in BookRequestDAO.GetEmptyLegBids(el))
                {
                    if (eloc.IsAgent)
                        othercust.Add(eloc.Agent.Email.Trim());
                    else
                        othercust.Add(eloc.Customer.Email.Trim());
                }
                if (elo.IsAgent)
                    othercust.Remove(elo.Agent.Email.Trim());
                else
                    othercust.Remove(elo.Customer.Email.Trim());

                ArrayList tempemail = new ArrayList(othercust);
                if (tempemail.Count > 0)
                {
                    em = new EmailBO("EmptyLegOfferNotificationToOtherCustomers", Session["Country"].ToString());
                    em.SendEmailToList(tempemail);
                }


                Response.Redirect("EmptyLeg.aspx?eid=" + el.ID);
            }
        }
    }
}
