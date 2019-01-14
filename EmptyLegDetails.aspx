<%@ Page Language="C#" AutoEventWireup="true" CodeFile="EmptyLegDetails.aspx.cs"
    Inherits="EmptyLegDetails" %>

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
<% EmptyLeg el = BookRequestDAO.FindEmptyLegByID(Int64.Parse(Request.Params.Get("eid"))); %>
<div style="margin-bottom: 10px; padding: 10px;border:1px solid #c0c0c0;font-size:14px;">
    <div style="font-weight:bold;color:#707070">
        <%= el.Source.GetAirfieldString() + " - " + el.Destination.GetAirfieldString() %>
    </div>
    <div style="margin-bottom: 5px;" class="small-link">
        <%= "Posted on " + el.PostedOn.ToString("F", System.Globalization.CultureInfo.CreateSpecificCulture("en-US"))%>
    </div>
</div>
<div style="padding: 10px;border:1px solid #c0c0c0;font-size:14px;">
    <div style="float: left; margin-right: 20px;">
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
    <div style="float: left">
        <img src="<%= BookRequestBO.gmapstring(el) %>" style="border: 1px solid #e7710b" />
    </div>
    <div class="clear">
    </div>
</div>
