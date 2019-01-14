<%@ Page Language="C#" AutoEventWireup="true" CodeFile="GetRequestDetails.aspx.cs"
    Inherits="Agent_GetRequestDetails" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
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
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Untitled Page</title>
    <link href="css/layout.css" media="all"
        rel="Stylesheet" type="text/css" />
</head>
<body>
    <%BookRequest b = BookRequestDAO.FindBookRequestByID(Int64.Parse(Request.Params.Get("bookid"))); %>
    <table class="bookrequest" style="border: 1px solid #C0C0C0;font-size:11px;font-family:Verdana; background: white; margin: 5px;
        width: 850px;margin-top:15px;">
        <tr>
            <td colspan="2" style="padding: 5px; color: #e7710b; font-size: 14px; font-weight: bold">
                <%= b.GetLegString()%>
                <input type="hidden" class="bookid" value="<%= b.BookID %>" />
            </td>
        </tr>
        <tr>
            <td style="padding: 5px; vertical-align: top; padding-right: 20px">
                <table class="bluetable" style="width: 300px">
                    <tr>
                        <th>
                            Plane Type
                        </th>
                        <td>
                            <%= b.PlaneType.PlaneTypeName + "(" + b.PlaneType.Capacity + " PAX)"%>
                        </td>
                    </tr>
                    <tr>
                        <th>
                            Trip Type
                        </th>
                        <td>
                            <%= b.TripType%>
                        </td>
                    </tr>
                    <tr>
                        <th>
                            Budget (<%= b.Domain.Currency.ShortName%>)
                        </th>
                        <td>
                            <%= b.FinalBudget%>
                        </td>
                    </tr>
                    <tr>
                        <th>
                            No of Passengers
                        </th>
                        <td>
                            <%= b.PAX%>
                        </td>
                    </tr>
                    <tr>
                        <th>
                            Name
                        </th>
                        <td>
                            <%= b.ContactDetails.Name%>
                        </td>
                    </tr>
                    <tr>
                        <th>
                            Email
                        </th>
                        <td>
                            <%= b.ContactDetails.Email%>
                        </td>
                    </tr>
                    <tr>
                        <th>
                            Phone No
                        </th>
                        <td>
                            <%= b.ContactDetails.Phone%>
                        </td>
                    </tr>
                    <tr>
                        <th>
                            Other Details
                        </th>
                        <td>
                            <%= b.ContactDetails.Description%>
                        </td>
                    </tr>
                    <tr>
                        <th style="color: #e7710b">
                            Request Status
                        </th>
                        <td>
                            <%= (b.Status == 0) ? "Active" : "Closed"%>
                        </td>
                    </tr>
                </table>
            </td>
            <td style="padding: 5px; vertical-align: top;">
                <%foreach (Leg l in b.Legs)
                  {%>
                <div class="leg">
                    <table class="bluetable" style="width: 450px">
                        <tr>
                            <th colspan="2">
                                <div class="leghead">
                                    Leg
                                    <%=  l.Sequence%>
                                </div>
                            </th>
                        </tr>
                        <tr>
                            <td>
                                <div class="boldtext">
                                    From</div>
                                <div>
                                    <%= l.Source.GetAirfieldString()%>
                                </div>
                            </td>
                            <td>
                                <div class="boldtext">
                                    To
                                </div>
                                <div>
                                    <%= l.Destination.GetAirfieldString()%>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <div class="boldtext">
                                    Date</div>
                                <div>
                                    <%= l.Date.ToShortDateString()%>
                                </div>
                            </td>
                            <td>
                                <div class="boldtext">
                                    Time</div>
                                <div>
                                    <%= l.Date.ToString("hh:mm tt")%>
                                </div>
                            </td>
                        </tr>
                    </table>
                </div>
                <%} %>
            </td>
        </tr>
    </table>
</body>
</html>
