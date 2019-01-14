<%@ Page Language="C#" AutoEventWireup="true" CodeFile="ShowEmptyLegBids.aspx.cs"
    Inherits="Operators_ShowEmptyLegBids" %>

<%@ Import Namespace="Entities" %>
<%@ Import Namespace="DataAccessLayer" %>
<%@ Import Namespace="BusinessLayer" %>
<%@ Import Namespace="System.Collections" %>
<%@ Import Namespace="System.Collections.Generic" %>
<%@ Import Namespace="System.Collections.Specialized" %>
<%@ Import Namespace="Iesi.Collections" %>
<%@ Import Namespace="NHibernate" %>
<div style="margin-top: 20px;">
</div>
<% EmptyLeg el = BookRequestDAO.FindEmptyLegByID(Int64.Parse(Request.Params.Get("eid")));
%>
<% if (el.AcceptedOffer != null)
   { %>
<table class="bluetable" style="width: 450px; margin-bottom: 15px;">
    <tr>
        <th colspan="3" style="color: #e7701b">
            Accepted Offer
        </th>
    </tr>
    <tr>
        <td>
            Name :<br />
            <%= (el.AcceptedOffer.IsAgent) ? el.AcceptedOffer.Agent.Name : el.AcceptedOffer.Customer.Name%>
        </td>
        <td>
            Bid Amount :<br />
            <% String actual = String.Format("{0:n}", el.AcceptedOffer.BidAmount);%>
            <%= el.AcceptedOffer.Currency.ID + " " + actual.Remove(actual.LastIndexOf("."))%>
        </td>
        <td>
            Posted On<br />
            <%= el.AcceptedOffer.TimeOfOffer.ToString("F", System.Globalization.CultureInfo.CreateSpecificCulture("en-US"))%>
        </td>
    </tr>
</table>
<%} %>
<%
    IList<EmptyLegOffer> elolist = BookRequestDAO.GetEmptyLegBids(el);
    elolist.Remove(el.AcceptedOffer);
    if (elolist.Count > 0)
    {
%>
<table class="bluetable" style="width: 450px">
    <tr>
        <th colspan="4" style="color: #e7701b">
            All Bids</th>
    </tr>
    <tr>
        <th>
            Name</th>
        <th>
            Amount</th>
        <th>
            Posted On</th>
        <th>
            Accept</th>
    </tr>
    <%
       
        foreach (EmptyLegOffer elo in elolist)
        {
            
    %>
    <tr>
        <td>
            <%= (elo.IsAgent) ? elo.Agent.Name : elo.Customer.Name %>
        </td>
        <td>
            <% String actual = String.Format("{0:n}", elo.BidAmount);%>
            <%= elo.Currency.ID + " " + actual.Remove(actual.LastIndexOf("."))%>
        </td>
        <td>
            <%= elo.TimeOfOffer.ToString("F", System.Globalization.CultureInfo.CreateSpecificCulture("en-US"))%>
        </td>
        <td>
            <a href="showemptylegbids.aspx?eloid=<%= elo.ID %>&acceptoffer=1" class="small-link accept"
                style="color: #e7701b">Accept</a></td>
    </tr>
    <%
        
        
    }
    %>
</table>
<%
    }
    else
    {
%>
<div style="width: 450px; margin-left: auto; margin-right: auto; margin-top: 50px;
    border: 1px solid #c0c0c0; padding: 10px; text-align: center; color: #e7701b">
    No Bids Yet.</div>
<%
    }
%>

<script type="text/ecmascript">
$("a.accept").click(function(){

if(!confirm("Are You Sure?"))
    return false;

});
</script>