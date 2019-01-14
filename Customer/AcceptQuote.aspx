<%@ Page Language="C#" Async="true" AutoEventWireup="true" CodeFile="AcceptQuote.aspx.cs" Inherits="Customer_AcceptQuote" %>
<%@ Import Namespace="Entities" %>
<%@ Import Namespace="DataAccessLayer" %>
<%@ Import Namespace="BusinessLayer" %>
<%@ Import Namespace="System.Collections" %>
<%@ Import Namespace="System.Collections.Generic" %>
<%@ Import Namespace="System.Collections.Specialized" %>
<%@ Import Namespace="Iesi.Collections" %>
<%@ Import Namespace="NHibernate" %>
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>Untitled Page</title>
</head>
<body>
    <% OperatorBid ob = BookRequestDAO.GetOperatorBidByID(Int64.Parse(Request.Params.Get("bidid")));   %>
    <table class="bluetable" style="margin-top: 20px; width: 400px; margin-left: auto;
        margin-right: auto">
        <tr>
            <th>
                Quoted on
            </th>
            <td>
                <%= ob.TimeOfBid.ToString("F", System.Globalization.CultureInfo.CreateSpecificCulture("en-US")) %>
            </td>
        </tr>
        <tr>
            <th>
                Aircraft
            </th>
            <td>
                <%= ob.Aircraft.AircraftName + " (" + ob.Aircraft.AircraftLocation + ")"%>
            </td>
        </tr>
        <tr>
            <th>
                Currency
            </th>
            <td>
                <%= ob.Currency.FullName %>
            </td>
        </tr>
        <tr>
            <th>
                Bid Amount
            </th>
            <td>
                <%= ob.FinalBidAmount %>
            </td>
        </tr>
        <tr>
            <th>
                Additional Details
            </th>
            <td>
                <%= (ob.AdditionalDetails == "") ? "Not Specified" : ob.AdditionalDetails%>
            </td>
        </tr>
    </table>
    <div style="width: 150px; text-align: center; margin-left: auto; margin-right: auto;
        margin-top: 20px">
        <a href="AcceptQuote.aspx?bidid=<%= ob.BidID %>&acceptquote=1" style="font-size: 12px;
            color: White;height:30px" class="redlinkbutton">Accept Quote</a></div>
</body>
</html>

