<%@ Page Language="C#" MasterPageFile="~/CharterTemplate.master" AutoEventWireup="true"
    CodeFile="FixedPriceCharters.aspx.cs" Inherits="FixedPriceCharters" Title="Untitled Page" %>

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
<%@ Import Namespace="System.Collections.Specialized" %>
<asp:Content ID="Content1" ContentPlaceHolderID="scriptholder" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="contentholder" runat="Server">
    <% NameValueCollection pars = Request.QueryString; %>
    <table class="bluetable" style="width: 800px; margin-left: auto; margin-right: auto;
        margin-top: 10px; margin-bottom: 10px">
        <tr>
            <td style="text-align: center">
                <form action="FixedPriceCharters.aspx">
                    <span style="color: #e7710b; margin-right: 15px">Search Fixed Price Charters</span>
                    <span>Source</span>
                    <input type="text" name="source" value="<%= pars.Get("source") %>" style="margin-right: 15px;" />
                    <span>Destination</span>
                    <input type="text" name="destination" value="<%= pars.Get("destination") %>" style="margin-right: 15px;" />
                    <input type="submit" name="chartersearchbtn" value="Search" class="buttons" style="width: 100px;" />
                </form>
            </td>
        </tr>
    </table>
    <% 
        Int32 pageid = 1;
        if (Request.Params.Get("pageid") != null)
        {
            pageid = Int32.Parse(Request.Params.Get("pageid"));
        }
        IList<FixedPriceCharter> efulllist = BookRequestDAO.GetFixedPriceCharters(Request.QueryString);
        IList<FixedPriceCharter> elist = BookRequestDAO.GetFixedPriceCharters(Request.QueryString, pageid, 10);
    %>
    <div style="margin-top: 10px; width: 800px; margin-left: auto; margin-right: auto">
        <span class="brown">Pages: </span><span id="pages">
            <%
                Int32 noofpages = (Int32)Math.Ceiling(efulllist.Count / 10.0);

                for (int i = 1; i <= noofpages; i++)
                {
                    if (i != pageid)
                    {
            %>
            <a href="<%= AdminBO.GetPagingURL(Request.QueryString,"FixedPriceCharters.aspx", i) %>"
                style="margin-right: 5px">
                <%= i %>
            </a>
            <%
                }
                else
                {
            %>
            <span style="margin-right: 5px">
                <%=i %>
            </span>
            <%
                }
            }
           
            %>
        </span>
    </div>
    <% 
        if (efulllist.Count > 0)
        {
            foreach (FixedPriceCharter el in elist)
            {
           
    %>
    <table class="bluetable" style="width: 750px; margin-left: auto; margin-right: auto;
        margin-top: 20px">
        <tr>
            <th>
                <div style="float: left">
                    <img src="images/bullet-airnetz.gif" style="margin-right: 10px" alt="->" />
                </div>
                <div style="float: left; width: 500px">
                    <span>
                        <%= el.Source.GetAirfieldString() + " - " + el.Destination.GetAirfieldString()%>
                    </span>
                </div>
                <div style="float: right; margin-top: 5px;">
                    <a href="BookRequestPage.aspx?nooflegs=2&TripType=RoundTrip&aircrafttype=<%= el.Aircraft.AircraftType.PlaneTypeID  %>&fromleg1=<%= el.Source.GetAirfieldString() %>&toleg1=<%= el.Destination.GetAirfieldString() %>&fixedpricecharter=<%=el.ID %>"
                        style="color: #c00000; font-size: 12px; font-weight: bold; text-decoration: none">
                        Accept Quote</a>
                </div>
            </th>
        </tr>
        <tr>
            <td>
                <div style="float: left">
                    <% 
            
                        AircraftPhoto dp = el.Aircraft.GetDisplayPic();
                        if (dp != null)
                        {
                    %>
                    <a href="aircraftphotos/<%= dp.PhotoID %>.jpeg" title="<%= dp.Caption %>" class="thickbox"
                        rel="aircraftpics<%= el.ID %>" style="text-align: center">
                        <img src="GetThumbnailAircraftImage.ashx?pid=<%= dp.PhotoID %>" alt="No pic" style="border-style: none" />
                        <div style="text-align: center; text-decoration: underline; font-size: 10px; color: #707070">
                            Photos</div>
                    </a>
                    <%
                        }
                        else
                        {
                    %>
                    <img src="images/NotAvailable.jpeg" alt="No pic" />
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
                <div style="float: left; margin-left: 15px; margin-top: 5px">
                    <table class="bluetable" style="width: 600px; font-size: 11px">
                        <tr>
                            <th style="background-color: #EEEEEE">
                                Aircraft Name
                            </th>
                            <th style="background-color: #EEEEEE">
                                Capacity
                            </th>
                            <th style="background-color: #EEEEEE">
                                Aircraft Type
                            </th>
                            <th style="background-color: #EEEEEE">
                                Quote
                            </th>
                        </tr>
                        <tr>
                            <td>
                                <%= el.Aircraft.AircraftName + " (" + el.Aircraft.AircraftLocation + ")"%>
                                <div style="margin-top: 5px; font-size: 9px;">
                                    operated by
                                    <%= el.Aircraft.Vendor.OperatorShortName%>
                                </div>
                            </td>
                            <td>
                                <%= el.Aircraft.PassengerCapacity%>
                            </td>
                            <td>
                                <%= el.Aircraft.AircraftType.PlaneTypeName %>
                            </td>
                            <td>
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
                    </table>
                    <div class="small-link" style="padding-top: 5px; text-align: right">
                        <%= "Posted on " + el.PostedOn.ToString("F", System.Globalization.CultureInfo.CreateSpecificCulture("en-US"))%>
                        <a href="FixedPriceCharterDetails.aspx?fid=<%= el.ID %>&width=800" style="margin-left: 20px;
                            text-decoration: underline" class="thickbox" title="Fixed Price Charter Details">Details</a>
                    </div>
                </div>
                <div class="clear">
                </div>
            </td>
        </tr>
    </table>
    <%
        }
    }
    else
    {
    %>
    <table style="border: 1px solid #C0C0C0; background: white; margin: 20px 5px 5px 5px;
        width: 850px">
        <tr>
            <td style="text-align: center">
                No Empty Legs found.
            </td>
        </tr>
    </table>
    <%
        }
    
    %>
</asp:Content>
