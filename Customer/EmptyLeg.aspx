<%@ Page Language="C#" MasterPageFile="~/CharterTemplate.master" AutoEventWireup="true"
    CodeFile="EmptyLeg.aspx.cs" Inherits="Customer_EmptyLeg" Title="Untitled Page" %>

<%@ Import Namespace="Entities" %>
<%@ Import Namespace="DataAccessLayer" %>
<%@ Import Namespace="BusinessLayer" %>
<%@ Import Namespace="System.Collections" %>
<%@ Import Namespace="System.Collections.Generic" %>
<%@ Import Namespace="System.Text" %>
<%@ Import Namespace="System.IO" %>
<%@ Import Namespace="Iesi.Collections" %>
<%@ Import Namespace="Helper" %>
<%@ Import Namespace="System.Xml" %>
<asp:Content ID="Content1" ContentPlaceHolderID="scriptholder" runat="Server">

    <script type="text/javascript">
$(document).ready(function(){

 $("#savebidform").submit(function(){
   $("div.error").remove();
   var amt=$("#savebidform input[name=bidamount]");
   if($.trim(amt.val())=="" || isNaN(amt.val()))
   {
    $("<div class='error'>* Invalid field</div>").insertAfter(amt);
    return false;
   }
 
 });
 
 $("a.withdraw").click(function(){
 
 if(!confirm("Are you sure?"))
  return false;
 
 });

});

    </script>

</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="contentholder" runat="Server">
    <% EmptyLeg el = BookRequestDAO.FindEmptyLegByID(Int64.Parse(Request.Params.Get("eid")));
       Customer logged = CustomerBO.GetLoggedInCustomer();
    %>
    <div style="margin-bottom: 10px; padding: 10px; border: 1px solid #c0c0c0; font-size: 13px;
        background: white">
        <div style="font-weight: bold; color: #707070">
            <%= el.Source.GetAirfieldString() + " - " + el.Destination.GetAirfieldString() %>
        </div>
        <div style="margin-bottom: 5px;" class="small-link">
            <%= "Posted on " + el.PostedOn.ToString("F", System.Globalization.CultureInfo.CreateSpecificCulture("en-US"))%>
        </div>
    </div>
    <div style="padding: 10px; border: 1px solid #c0c0c0; font-size: 14px; background: white">
        <div style="float: left; margin-right: 20px">
            <div>
                <table class="bluetable" style="width: 400px; font-size: 11px">
                    <tr>
                        <th>
                            Aircraft Name
                        </th>
                        <td>
                            <%= el.Aircraft.AircraftName + " (" + el.Aircraft.AircraftLocation + ")"%>
                            <div style="margin-top: 5px; font-size: 9px;">
                                operated by
                                <%= el.Aircraft.Vendor.OperatorShortName%>
                            </div>
                            <%             
                                AircraftPhoto dp = el.Aircraft.GetDisplayPic();
                                if (dp != null)
                                {
                            %>
                            <a href="../aircraftphotos/<%= dp.PhotoID %>.jpeg" title="<%= dp.Caption %>" class="thickbox"
                                rel="aircraftpics<%= el.ID %>">Photos </a>
                            <% 
                                }
                            %>
                            <div style="display: none">
                                <%
                                    foreach (AircraftPhoto ap in el.Aircraft.PhotoList)
                                    {
                                        if (!ap.Equals(dp))
                                        {
                                %>
                                <a href="../aircraftphotos/<%= ap.PhotoID %>.jpeg" title="<%= ap.Caption %>" class="thickbox"
                                    rel="aircraftpics<%= el.ID %>">Click</a>
                                <%
                                    }
                                } %>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <th>
                            Capacity
                        </th>
                        <td>
                            <%= el.Aircraft.PassengerCapacity%>
                        </td>
                    </tr>
                    <tr>
                        <th>
                            Aircraft Type
                        </th>
                        <td>
                            <%= el.Aircraft.AircraftType.PlaneTypeName%>
                        </td>
                    </tr>
                    <tr>
                        <th>
                            Operator Offered Price
                        </th>
                        <td>
                            <% String actual = String.Format("{0:n}", el.ActualPrice);%>
                            <% String offer = String.Format("{0:n}", el.OfferPrice);%>
                            <div style="text-decoration: line-through; color: #707070; margin-bottom: 5px;">
                                <%= el.Currency.ID + " " + actual.Remove(actual.LastIndexOf(".")) %>
                            </div>
                            <div style="color: #C00000; font-weight: bold">
                                <%= el.Currency.ID + " " + offer.Remove(offer.LastIndexOf(".")) %>
                            </div>
                        </td>
                    </tr>
                </table>
            </div>
            <div style="margin-top: 15px;width: 320px;margin-left:30px">
                <img src="<%= BookRequestBO.gmapstring(el) %>" style="border: 1px solid #e7710b" />
            </div>
        </div>
        <div style="float: left; margin-top: 10px; text-align: center; width: 400px">
            <% if (el.AcceptedOffer != null && !el.AcceptedOffer.IsAgent && el.AcceptedOffer.Customer.Equals(logged))
               {
            %>
           <div style="margin-bottom: 15px;border:1px solid #c00000;padding:10px;font-weight:bold">
                Operator Offer Accepted By you. <a href="emptyleg.aspx?eid=<%= el.ID %>&withdrawaccepted=1" style="margin-left: 20px;" class="small-link withdraw">Withdraw</a></div>
            <%
                }
                else
                { %>
            <div style="margin-bottom: 30px;">
            <br />
                <a href="EmptyLeg.aspx?eid=<%= el.ID %>&acceptoffer=1" class="redlinkbutton" style="padding-left: 20px;
                    padding-right: 20px;">Accept Offer</a>
            </div>
            
            <div style="margin-bottom: 30px; text-align: center; font-size: 16px; text-align: center">
                Or</div>
            <div id="Error" runat="server" style="margin-bottom: 10px; text-align: center; font-size: 11px;
                color: #e7710b; text-align: center">
            </div>
            <div>
                <% Double max = 0;

                   foreach (EmptyLegOffer elo in BookRequestDAO.GetEmptyLegBids(el))
                   {
                       if (elo.BidAmount > max)
                           max = elo.BidAmount;

                   }
                %>
                <form id="savebidform" action="EmptyLeg.aspx">
                    <input type="hidden" name="eid" value="<%= el.ID %>" />
                    <table class="bluetable" style="font-size: 11px; width: 350px; margin-left: auto;
                        margin-right: auto">
                        <tr>
                            <th colspan="2" style="font-size: 12px; background: #f8f8f8; font-weight: bold; color: #e7710b">
                                Place Bid</th>
                        </tr>
                        <tr>
                            <th>
                                Current Highest Bid
                            </th>
                            <td>
                                <% if (max > 0)
                                   {
                                       String temp = String.Format("{0:n}", max);
                                       Response.Write(el.Currency.ID + " " + temp.Remove(temp.LastIndexOf(".")));
                                   }
                                   else
                                   {
                                %>
                                No Bids
                                <%   
                                    } %>
                            </td>
                        </tr>
                        <tr>
                            <th>
                                Your Previous Bids
                            </th>
                            <td>
                                <% IList<EmptyLegOffer> elolist = BookRequestDAO.GetEmptyLegBids(el, logged);

                                   if (elolist.Count > 0)
                                   {
                                       foreach (EmptyLegOffer elo in elolist)
                                       {
                                           if (!elo.Equals(elo.EmptyLeg.AcceptedOffer))
                                           {
                                               String temp = String.Format("{0:n}", elo.BidAmount);
                                %>
                                <%= elo.Currency.ID + " " + temp.Remove(temp.LastIndexOf("."))%>
                                <a href="emptyleg.aspx?eid=<%= el.ID %>&eloid=<%= elo.ID %>&withdrawbid=1" style="margin-left:15px;" class="small-link withdraw">Withdraw</a>
                                <br /><br />
                                <%}
                              }
                          }
                          else
                          {
                                %>
                                No bids
                                <%
                                    }
                                %>
                            </td>
                        </tr>
                        <tr>
                            <th>
                                Bid Amount (<%= el.Currency.ID %>)
                            </th>
                            <td>
                                <input type="text" name="bidamount" />
                            </td>
                        </tr>
                        <tr>
                            <td colspan="2">
                                <input type="submit" name="savebidbtn" style="width: 150px" value="Save Bid" class="buttons" />
                            </td>
                        </tr>
                    </table>
                </form>
            </div>
            <%} %>
        </div>
    <div class="clear">
    </div>
    </div>
</asp:Content>
