<%@ Page Language="C#" AutoEventWireup="true" CodeFile="ShowBids.aspx.cs" Inherits="Operators_ShowBids" %>

<%@ Import Namespace="Entities" %>
<%@ Import Namespace="DataAccessLayer" %>
<%@ Import Namespace="BusinessLayer" %>
<%@ Import Namespace="System.Collections" %>
<%@ Import Namespace="System.Collections.Generic" %>
<%@ Import Namespace="System.Collections.Specialized" %>
<%@ Import Namespace="Iesi.Collections" %>
<%@ Import Namespace="NHibernate" %>

    <% if (Request.Params.Get("bidid") != null)
       {
           OperatorBid ob = BookRequestDAO.GetOperatorBidByID(Int64.Parse(Request.Params.Get("bidid")));   
    %>
    <table class="bluetable" style="margin-top: 20px;">
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
                <%= ob.Currency.FullName%>
            </td>
        </tr>
        <tr>
            <th>
                Bid Amount
            </th>
            <td>
                <%= ob.BidAmount%>
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
    <%
        }
        else
        {
    %>
    <table class="bluetable" style="margin-top: 20px;">
        <tr>
            <th>
                Operator
            </th>
            <th>
                Aircraft
            </th>
            <th>
                Currency
            </th>
            <th>
                Bid Amount
            </th>
            <th>
                Additional Details
            </th>
            <th>
                Quoted on</th>
        </tr>
        <%
            BookRequest b = BookRequestDAO.FindBookRequestByID(Int64.Parse(Request.Params.Get("bookid")));
            foreach (OperatorBid ob in BookRequestDAO.GetBidsForRequest(b))
            { 
        %>
        <tr>
            <td>
                <%= ob.Operator.CompanyName %>
            </td>
            <td>
                <%= ob.Aircraft.AircraftName + " (" + ob.Aircraft.AircraftLocation + ")"%>
            </td>
            <td>
                <%= ob.Currency.FullName%>
            </td>
            <td>
                <%= ob.BidAmount%>
            </td>
            <td>
                <%= (ob.AdditionalDetails == "") ? "Not Specified" : ob.AdditionalDetails%>
            </td>
            <td>
                <%= ob.TimeOfBid.ToShortDateString() %>
            </td>
        </tr>
        <%
          
            }
        %>
    </table>
    <%
        } %>

