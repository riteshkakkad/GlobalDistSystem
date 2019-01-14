<%@ Page Language="C#" MasterPageFile="~/Operators/OperatorMaster.master" AutoEventWireup="true"
    CodeFile="FixedPriceCharters.aspx.cs" Inherits="Operators_FixedPriceCharters"
    Title="Untitled Page" %>

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
        margin-top: 20px">
        <tr>
            <td>
                <form action="FixedPriceCharters.aspx" style="text-align: center">
                    <span>Source</span>
                    <input type="text" name="source" value="<%= pars.Get("source") %>" />
                    <span>Destination</span>
                    <input type="text" name="destination" value="<%= pars.Get("destination") %>" />
                    <input type="submit" name="chartersearchbtn" value="search" />
                </form>
            </td>
        </tr>
    </table>
    <%
        IList<FixedPriceCharter> efulllist = BookRequestDAO.GetFixedPriceCharters(Request.QueryString);
        IList<FixedPriceCharter> elist = BookRequestDAO.GetFixedPriceCharters(Request.QueryString, pageid, 10);

    %>
    <br />
    <span class="brown" style="margin-left: 50px">Pages: </span><span id="pages">
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
    <br />
    <% 
        if (efulllist.Count > 0)
        {

            foreach (FixedPriceCharter el in elist)
            {
    %>
    <table class="bookrequest" style="border: 1px solid #C0C0C0; background: white; margin: 5px;
        width: 800px; margin-left: auto; margin-right: auto">
        <tr>
            <td colspan="2" style="padding: 10px; color: #e7710b; font-size: 14px; font-weight: bold">
                <%= el.Source.GetAirfieldString() + " - " + el.Destination.GetAirfieldString()%>
            </td>
        </tr>
        <tr>
            <td style="padding: 10px">
                <% 
            
                    AircraftPhoto dp = el.Aircraft.GetDisplayPic();
                    if (dp != null)
                    {
                %>
                <a href="../aircraftphotos/<%= dp.PhotoID %>.jpeg" title="<%= dp.Caption %>" class="thickbox"
                    rel="aircraftpics<%= el.ID %>" style="text-align: center">
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
            </td>
            <td style="padding: 10px">
                <table class="bluetable">
                    <tr>
                        <th style="width: 100px">
                            Aircraft
                        </th>
                        <td style="width: 250px">
                            <%= el.Aircraft.AircraftName + "(" + el.Aircraft.AircraftLocation + ") "%>
                        </td>
                        <th style="width: 80px">
                            Quote
                        </th>
                        <td style="width: 150px">
                            <%= el.Currency.ID + " " + el.Quote %>
                        </td>
                    </tr>
                    <tr>
                        <th>
                            Quote Expires On
                        </th>
                        <td>
                            <%= el.ExpiresOn.ToString("MM/dd/yyyy hh:mm tt")%>
                        </td>
                        <th>
                            Posted On
                        </th>
                        <td>
                            <%= el.PostedOn.ToString("MM/dd/yyyy hh:mm tt")%>
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
        <tr>
            <td style="text-align: right" colspan="2">
                <a href="FixedPriceCharterEdit.aspx?fid=<%= el.ID %>" style="margin-right: 20px">Edit</a><a
                    href="updatefixedpricecharters.ashx?removefixedpricecharter=1&fid=<%= el.ID %>"
                    style="margin-right: 20px" class="small-link removeemptyleg">Remove</a>
            </td>
        </tr>
    </table>
    <%
        }
    }
    else
    {%>
    <table style="border: 1px solid #C0C0C0; background: white; margin-left: auto; margin-right: auto;
        margin-top: 50px; width: 800px">
        <tr>
            <td style="text-align: center">
                No Fixed Price Charters Found.
            </td>
        </tr>
    </table>
    <%
        }
    %>
</asp:Content>
