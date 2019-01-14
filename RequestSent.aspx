<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/CharterTemplate.master"
    CodeFile="RequestSent.aspx.cs" Inherits="RequestSent" %>

<%@ Import Namespace="Entities" %>
<%@ Import Namespace="DataAccessLayer" %>
<%@ Import Namespace="BusinessLayer" %>
<asp:Content ContentPlaceHolderID="scriptholder" runat="server">


</asp:Content>
<asp:Content ContentPlaceHolderID="contentholder" runat="server">
    <%
        if (Session["bid"] == null)
        {
            Response.Redirect("QuickQuote.aspx");
        }

        BookRequest b = BookRequestDAO.FindBookRequestByID((long)Session["bid"]);
    %>
    <fieldset>
        <legend>Booking Details</legend>
        <p class="bigheading" style="font-size: 11px; margin-bottom: 30px; text-align: center;font-weight:normal">
            Thank you for sending the charter request to <span>
                <%= (b.IsAgent)?b.Agent.Agency:"Airnetz Charter Inc." %>
            </span>You will soon receive quotes from different operators through email.
        </p>
        <div style="float: left; width: 500px">
            <table class="bluetable" style="margin-left:10px">
             <%if (b.FixedPriceCharter!=null)
                      {
                          FixedPriceCharter el = b.FixedPriceCharter;
                          

                    %>
                    <tr>
                        <th>
                            Aircraft Details
                        </th>
                        <td>
                            <%= el.Aircraft.AircraftName + " (" + el.Aircraft.AircraftLocation + ")"%>
                            <div style="margin-top: 5px; font-size: 9px; margin-bottom: 5px;">
                                Capacity :
                                <%= el.Aircraft.PassengerCapacity %>
                            </div>
                            <div style="margin-top: 5px; font-size: 9px; margin-bottom: 5px;">
                                operated by
                                <%= el.Aircraft.Vendor.OperatorShortName%>
                            </div>
                            <div>
                                <%             
                                    AircraftPhoto dp = el.Aircraft.GetDisplayPic();
                                    if (dp != null)
                                    {
                                %>
                                <a href="aircraftphotos/<%= dp.PhotoID %>.jpeg" title="<%= dp.Caption %>" class="thickbox"
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
                                    <a href="aircraftphotos/<%= ap.PhotoID %>.jpeg" title="<%= ap.Caption %>" class="thickbox"
                                        rel="aircraftpics<%= el.ID %>">Click</a>
                                    <%
                                        }
                                    } %>
                                </div>
                            </div>
                            
                        </td>
                    </tr>
                    <tr>
                        <th style="width: 200px">
                            Quote Details
                        </th>
                        <td style="width: 200px">
                            <% String actual = String.Format("{0:n}", el.Quote);%>
                            <div>
                                <div style="color: #e7710b; font-weight: bold">
                                    <%= el.Currency.ID + " " + actual.Remove(actual.LastIndexOf(".")) %>
                                </div>
                            </div>
                            <div style="margin-top: 10px">
                                <%= "Quote Expires on " + el.ExpiresOn.ToString("MM/dd/yyyy")%>
                            </div>
                        </td>
                    </tr>
                    <%} %>
                <tr>
                    <th style="width: 200px">
                        Plane Type
                    </th>
                    <td style="width: 200px">
                        <%= b.PlaneType.PlaneTypeName %>
                    </td>
                </tr>
                <tr>
                    <th>
                        Trip Type
                    </th>
                    <td>
                        <%= b.TripType %>
                    </td>
                </tr>
            </table>
            <%foreach (Leg l in b.Legs)
              {%>
            <div class="leg">
                <table class="bluetable">
                    <tr>
                        <th colspan="2">
                            <div class="leghead">
                                Leg
                                <%= l.Sequence%>
                            </div>
                        </th>
                    </tr>
                    <tr>
                        <td style="width: 200px">
                            <div class="boldtext">
                                From
                            </div>
                            <div>
                                <%= l.Source.GetAirfieldString()  %>
                            </div>
                        </td>
                        <td style="width: 200px">
                            <div class="boldtext">
                                To
                            </div>
                            <div>
                                <%= l.Destination.GetAirfieldString() %>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <div class="boldtext">
                                Date
                            </div>
                            <div>
                                <%= l.Date.ToShortDateString() %>
                            </div>
                        </td>
                        <td>
                            <div class="boldtext">
                                Time
                            </div>
                            <div>
                                <%= l.Date.ToShortTimeString() %>
                            </div>
                        </td>
                    </tr>
                </table>
            </div>
            <%} %>
            <table class="bluetable" style="margin-left:10px">
                <tr>
                    <th style="width:200px">
                        Your Budget (<%= b.Domain.Currency.ShortName %>)
                    </th>
                    <td style="width: 200px">
                        <%  String temp = String.Format("{0:n}", (Int32)b.Budget); %>
                        <%= temp.Remove(temp.LastIndexOf(".")) %>
                    </td>
                </tr>
                <tr>
                    <th>
                        No. of Passengers
                    </th>
                    <td>
                        <%= b.PAX %>
                    </td>
                </tr>
                <tr>
                    <th>
                        Name
                    </th>
                    <td>
                        <%= b.ContactDetails.Name %>
                    </td>
                </tr>
                <tr>
                    <th>
                        Email
                    </th>
                    <td>
                        <%= b.ContactDetails.Email %>
                    </td>
                </tr>
                <tr>
                    <th>
                        Phone No.
                    </th>
                    <td>
                        <%= b.ContactDetails.Phone %>
                    </td>
                </tr>
                <tr>
                    <th>
                        Other Details(Optional)
                    </th>
                    <td>
                        <%= (b.ContactDetails.Description == "") ? "Not specified" : b.ContactDetails.Description%>
                    </td>
                </tr>
            </table>
        </div>
        <div style="float: left">
            <img src="<%= BookRequestBO.gmapstring(b) %>" style='border: 1px solid #e7710b' /></div>
        <div class="clear">
        </div>
    </fieldset>
</asp:Content>
