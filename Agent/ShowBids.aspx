<%@ Page Language="C#" MasterPageFile="~/CharterTemplate.master" AutoEventWireup="true"
    CodeFile="ShowBids.aspx.cs" Inherits="Agent_ShowBids" Title="Untitled Page" %>

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


</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="contentholder" runat="Server">
    <% Agent a = AgentBO.GetLoggedInAgent();
       NameValueCollection pars = new NameValueCollection(Request.QueryString);
       Boolean temp = false;
    %>
    <table class="bluetable" style="width: 800px; margin-left: auto; margin-right: auto;
        margin-top: 10px; margin-bottom: 10px">
        <tr>
            <td style="text-align: center">
                <form action="ShowBids.aspx">
                    <span>Select Request: </span>
                    <select name="bookrequest">
                        <option value="all">All</option>
                        <%
                            NameValueCollection par = new NameValueCollection();
                           
                            IList<BookRequest> blist = BookRequestDAO.GetBookRequests(par);
                            if (blist.Count > 0)
                            {

                                foreach (BookRequest b in blist)
                                {
                                    temp = (pars.Get("bookrequest") == b.BookID.ToString()) ? true : false;
                        %>
                        <option value="<%= b.BookID %>" <%= (temp)?"selected":"" %>>
                            <%= b.GetLegCodeString()+" from "+b.ContactDetails.Name %>
                        </option>
                        <%
                            }
                        }
                        else
                        {
                        %>
                        <option value="">No Requests</option>
                        <%  
                            }
                        %>
                    </select>
                    <span style="margin-left: 15px;">Sort By: </span>
                    <select name="sortby">
                        <%  temp = (pars.Get("sortby") == "time") ? true : false; %>
                        <option value="time" <%= (temp)?"selected":"" %>>Latest Bids</option>
                        <%  temp = (pars.Get("sortby") == "amount") ? true : false; %>
                        <option value="amount" <%= (temp)?"selected":"" %>>Lowest Bid Amount</option>
                    </select>
                    <input type="submit" name="bidsearchbtn" style="margin-left: 15px;" class="buttons"
                        value="search" />
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

        pars.Add("agentid", a.AgentID.ToString());
        IList<OperatorBid> bdfulllist = BookRequestDAO.GetAllBids(pars);
        IList<OperatorBid> bdlist = BookRequestDAO.GetAllBids(pars, pageid, 10);
    %>
    <div style="margin-top: 10px; width: 800px; margin-left: auto; margin-right: auto">
        <span class="brown">Pages: </span><span id="pages">
            <%
                Int32 noofpages = (Int32)Math.Ceiling(bdfulllist.Count / 10.0);

                for (int i = 1; i <= noofpages; i++)
                {
                    if (i != pageid)
                    {
            %>
            <a href="<%= AdminBO.GetPagingURL(Request.QueryString,"ShowBids.aspx", i) %>" style="margin-right: 5px">
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
        if (bdfulllist.Count > 0)
        {
            foreach (OperatorBid ob in bdlist)
            {
           
    %>
    <table class="bluetable" style="width: 750px; margin-left: auto; margin-right: auto;
        margin-top: 20px">
         <% Boolean accepted=false;
           if (ob.Equals(ob.Request.AcceptedBid))
               accepted = true; %>
        <tr>
            <th>
                <div style="float: left">
                    <img src="../images/bullet-airnetz.gif" style="margin-right: 10px" alt="->" />
                </div>
                <div style="float: left; width: 500px">
                    <span>
                        <%= ob.Request.GetLegString()%>
                    </span><a href="../GetRequestDetails.aspx?bookid=<%= ob.Request.BookID %>&keepThis=true&TB_iframe=true&width=850"
                        class="small-link thickbox" style="font-weight: normal; margin-left: 5px;">Request
                        Details</a>
                </div>
                <div style="float: right; color: #C00000">
                <% String tempstr= String.Format("{0:n}", ob.FinalBidAmount);%>
                    <%= ob.Currency.ID + " " + tempstr.Remove(tempstr.LastIndexOf("."))%>
                </div>
            </th>
        </tr>
        <tr>
       
            <td>
                <div style="float: left">
                    <% 
            
                        AircraftPhoto dp = ob.Aircraft.GetDisplayPic();
                        if (dp != null)
                        {
                    %>
                    <a href="../aircraftphotos/<%= dp.PhotoID %>.jpeg" title="<%= dp.Caption %>" class="thickbox"
                        rel="aircraftpics<%= ob.BidID %>" style="text-align: center">
                        <img src="../GetThumbnailAircraftImage.ashx?pid=<%= dp.PhotoID %>" alt="No pic" style="border-style: none" />
                        <div style="text-align: center; text-decoration: underline; font-size: 10px; color: #707070">
                            Photos</div>
                    </a>
                    <%
                        }
                        else
                        {
                    %>
                    <img src="../images/NotAvailable.jpeg" alt="No pic" />
                    <%
                        }
                    %>
                    <div style="display: none">
                        <%
                            foreach (AircraftPhoto ap in ob.Aircraft.PhotoList)
                            {
                                if (!ap.Equals(dp))
                                {
                        %>
                        <a href="../aircraftphotos/<%= ap.PhotoID %>.jpeg" title="<%= ap.Caption %>" class="thickbox"
                            rel="aircraftpics<%= ob.BidID %>">Click</a>
                        <%
                            }
                        } %>
                    </div>
                </div>
                <div style="float: left; margin-left: 15px; margin-top: 5px">
                    <table class="bluetable" style="width: 600px; font-size: 11px">
                        <tr>
                            <th>
                                Aircraft Name
                            </th>
                            <th>
                                Capacity
                            </th>
                            <th>
                                Aircraft Type
                            </th>
                            <th>
                                Additional Details
                            </th>
                        </tr>
                        <tr>
                            <td>
                                <%= ob.Aircraft.AircraftName + " (" + ob.Aircraft.AircraftLocation + ")"%>
                                <div style="margin-top: 5px; font-size: 9px;">
                                    operated by
                                    <%= ob.Aircraft.Vendor.OperatorShortName%>
                                </div>
                            </td>
                            <td>
                                <%= ob.Aircraft.PassengerCapacity%>
                            </td>
                            <td>
                                <%= ob.Aircraft.AircraftType.PlaneTypeName%>
                            </td>
                            <td>
                                <%= (ob.AdditionalDetails.Trim() != "") ? ob.AdditionalDetails.Trim() : "Not Specified"%>
                            </td>
                        </tr>
                    </table>
                    <table class="noborder" style="width: 600px">
                        <tr>
                            <td class="small-link">
                                <%= "Quoted on " + ob.TimeOfBid.ToString("F", System.Globalization.CultureInfo.CreateSpecificCulture("en-US"))%>
                            </td>
                            <td style="text-align: right;">
                            <% if (accepted)
                               {
                                  %>
                                    <span style="color:#e7710b;font-size:14px;font-weight:bold;border:1px solid #e7710b;padding:5px">Quote Accepted</span>
                                   <% 
                               }
                               else
                               {
                                   %>
                                    <a href="AcceptQuote.aspx?bidid=<%=ob.BidID %>&height=300&width=400" title="Accept Bid" class="redlinkbutton thickbox">Accept Quote</a>
                                   <% 
                               }%>
                                                              
                                </td>
                        </tr>
                    </table>
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
                No Bids found.
            </td>
        </tr>
    </table>
    <%
        }
    
    %>
    <div id="acceptquote" style="display:none">
     
    </div>
</asp:Content>
