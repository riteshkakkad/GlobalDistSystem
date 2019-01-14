<%@ Page Language="C#" MasterPageFile="~/Operators/OperatorMaster.master" AutoEventWireup="true"
    CodeFile="ShowEmptyLegs.aspx.cs" Inherits="Operators_ShowEmptyLegs" Title="Untitled Page" %>

<%@ Import Namespace="Entities" %>
<%@ Import Namespace="DataAccessLayer" %>
<%@ Import Namespace="BusinessLayer" %>
<%@ Import Namespace="System.Collections" %>
<%@ Import Namespace="System.Collections.Generic" %>
<%@ Import Namespace="System.Collections.Specialized" %>
<%@ Import Namespace="Iesi.Collections" %>
<%@ Import Namespace="NHibernate" %>
<asp:Content ID="Content1" ContentPlaceHolderID="scriptholder" runat="Server">

    <script type="text/javascript">
$(document).ready(function(){

  $("a.removeemptyleg").click(function(){
  
  if(!confirm("Are you sure? "))
   return false;
  
  });

});

    </script>

</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="contentholder" runat="Server">
    <%  NameValueCollection pars = Request.QueryString;
        Int32 pageid = 1;
        if (Request.Params.Get("pageid") != null)
        {
            pageid = Int32.Parse(Request.Params.Get("pageid"));
        }
        
    %>
    <table class="bluetable" style="width: 700px; margin-left: auto; margin-right: auto;
        margin-top: 20px;">
        <tr>
            <td>
                <form action="ShowEmptyLegs.aspx" style="text-align: center">
                    <span>Source</span>
                    <input type="text" name="source" value="<%= pars.Get("source") %>" style="margin-right: 15px;" />
                    <span>Destination</span>
                    <input type="text" name="destination" value="<%= pars.Get("destination") %>" style="margin-right: 15px;" />
                    <input type="submit" name="legsearchbtn" value="search" />
                </form>
            </td>
        </tr>
    </table>
    <%
        IList<EmptyLeg> efulllist = BookRequestDAO.GetEmptyLegs(Request.QueryString);
        IList<EmptyLeg> elist = BookRequestDAO.GetEmptyLegs(Request.QueryString, pageid, 10);

    %>
    <br />
    <span class="brown" style="margin-left: 20px">Pages: </span><span id="pages">
        <%
            Int32 noofpages = (Int32)Math.Ceiling(efulllist.Count / 10.0);

            for (int i = 1; i <= noofpages; i++)
            {
                if (i != pageid)
                {
        %>
        <a href="<%= AdminBO.GetPagingURL(Request.QueryString,"ShowEmptyLegs.aspx", i) %>"
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
    <br />
    <% 
        if (efulllist.Count > 0)
        {

            foreach (EmptyLeg el in elist)
            {
    %>
    <table class="bookrequest" style="border: 1px solid #C0C0C0; background: white; margin: 10px auto 10px auto;
        width: 800px">
        <tr>
            <td colspan="2" style="padding: 10px; color: #e7710b; font-size: 12px; font-weight: bold">
                <%= el.Source.GetAirfieldString() + " - " + el.Destination.GetAirfieldString()%>
            </td>
        </tr>
        <tr>
            <td style="padding: 10px;">
                <table class="bluetable">
                    <tr>
                        <th style="width: 100px">
                            Aircraft
                        </th>
                        <td style="width: 400px">
                            <%= el.Aircraft.AircraftName + "(" + el.Aircraft.AircraftLocation + ") "%>
                        </td>
                        <th style="width: 100px">
                            Actual Price
                        </th>
                        <td style="width: 150px">
                            <%= el.Currency.ID + " " + el.ActualPrice%>
                        </td>
                    </tr>
                    <tr>
                        <th>
                            Departure Time Range
                        </th>
                        <td>
                            <%= el.DepartureFromDate.ToString("MM/dd/yyyy hh:mm tt")%>
                            To
                            <%= el.DepartureToDate.ToString("MM/dd/yyyy hh:mm tt")%>
                        </td>
                        <th style="width: 100px">
                            Offer Price
                        </th>
                        <td style="width: 150px">
                            <%= el.Currency.ID + " " + el.OfferPrice%>
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
        <tr>
            <td style="text-align: right">
                <% if (el.AcceptedOffer != null)
               { %>
                <span style="margin-right: 400px; font-size: 12px; color: #e7701b">Offer Accepted</span>
                <%} %>
                <a href="showemptylegbids.aspx?eid=<%= el.ID %>&height=250&width=500" style="margin-right: 20px"
                    title="Show Bids" class="thickbox">Show Bids</a><a href="EmptyLegEdit.aspx?eid=<%= el.ID %>"
                        style="margin-right: 20px">Edit</a><a href="updateemptylegs.ashx?removeemptyleg=1&eid=<%= el.ID %>"
                            style="margin-right: 20px" class="small-link removeemptyleg">Remove</a>
            </td>
        </tr>
    </table>
    <%
        }
    }
    else
    {%>
    <table style="border: 1px solid #C0C0C0; background: white; margin: 30px 5px 5px 5px;
        width: 700px">
        <tr>
            <td style="text-align: center">
                No Legs found.
            </td>
        </tr>
    </table>
    <%
        }
    %>
</asp:Content>
