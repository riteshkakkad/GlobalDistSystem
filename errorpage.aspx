<%@ Page Language="C#" AutoEventWireup="true" CodeFile="errorpage.aspx.cs" Inherits="errorpage"
    Title="Untitled Page" %>

<%@ Import Namespace="Entities" %>
<%@ Import Namespace="DataAccessLayer" %>
<%@ Import Namespace="BusinessLayer" %>
<%@ Import Namespace="System.Collections" %>
<%@ Import Namespace="System.Collections.Generic" %>
<%@ Import Namespace="Iesi.Collections" %>
<%@ Import Namespace="NHibernate" %>
<%@ Import Namespace="System.Xml" %>
<%@ Import Namespace="Helper" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" 
"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>Book helicopters, turbo props, private jets online - Airnetz Global Distribution
        System GDS</title>
    <link href="<%= ResolveUrl("~/css/layout.css")%>" media="all" rel="Stylesheet" type="text/css" />

    <script type="text/javascript" src="<%= ResolveUrl("~/scripts/global.js")%>">
    </script>

</head>
<body>
    <% Customer cust = CustomerBO.GetLoggedInCustomer();
       Agent check = AgentBO.GetLoggedInAgent();
    %>
    <div id="fullsection">
        <div id="topsection" style="margin-bottom: 15px;">
            <div class="airnetz-charter-logo" style="float: left; margin-right: 20px;">
            </div>
            <div style="float: left">
                <div>
                    <div class="airnetz-keywords" style="float: left;">
                        <h1 class="heading" style="margin-top: 10px; margin-bottom: 0px">
                            Helicopter Charter | Turbo Prop Charter | Private Jet Charter</h1>
                        <div class="heading-italic" style="padding-top: 15px">
                            "First Global Distribution System For Private Jet Industry."
                        </div>
                    </div>
                    <div style="float: left;">
                        <div class="tabs22">
                            <ul>
                                <li><a href="~/quickquote.aspx" title="Home" id="home" runat="server"><span>Home</span></a></li>
                                <li><a href="~/Operators/Login.aspx" title="Operators" id="operators" runat="server">
                                    <span>Operators</span></a></li>
                                <li><a href="~/Agent/Login.aspx" title="Agents" id="agents" runat="server"><span>Agents</span></a></li>
                            </ul>
                        </div>
                        <div class="clear">
                        </div>
                        <div style="margin-top: 10px; text-align: center;">
                         
                        </div>
                    </div>
                    <div class="clear">
                    </div>
                </div>
                <div style="margin-top: 5px; margin-left: 10px" class="airnetz-contactno">
                    <table>
                        <tbody>
                            <tr>
                                <th align="left" style="padding-right: 0px; vertical-align: top">
                                    <img src="<%=ResolveUrl("~/images/Phone.gif")%>" alt="" style="margin-right: 5px;" /></th>
                                <th style="padding-right: 20px; vertical-align: top">
                                    TELE-BOOKING :</th>
                                <th align="left" valign="top" style="padding-right: 10px; vertical-align: top;">
                                    USA :
                                </th>
                                <td style="padding-right: 25px; vertical-align: top">
                                    <% foreach (String s in AdminDAO.GetCountryByID("US").ContactNos.Trim().Split(",".ToCharArray()))
                                       {
                                    %>
                                    <div>
                                        <%= s.Trim() %>
                                    </div>
                                    <%
                                        }
                                    %>
                                </td>
                                <th align="left" style="padding-right: 10px; vertical-align: top;">
                                    INDIA :
                                </th>
                                <td style="padding-right: 25px; vertical-align: top">
                                    <% foreach (String s in AdminDAO.GetCountryByID("IN").ContactNos.Trim().Split(",".ToCharArray()))
                                       {
                                    %>
                                    <div>
                                        <%= s.Trim() %>
                                    </div>
                                    <%
                                        }
                                    %>
                                </td>
                                <th align="left" style="vertical-align: top; padding-right: 10px;">
                                    UK :
                                </th>
                                <td style="vertical-align: top">
                                    <% foreach (String s in AdminDAO.GetCountryByID("GB").ContactNos.Trim().Split(",".ToCharArray()))
                                       {
                                    %>
                                    <div>
                                        <%= s.Trim() %>
                                    </div>
                                    <%
                                        }
                                    %>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                 
                </div>
            </div>
            <div class="clear">
            </div>
        </div>
        <div id="contentsection">
            <div class="rnd_container">
                <b class="rnd_top"><b class="rnd_b1"></b><b class="rnd_b2"></b><b class="rnd_b3"></b>
                    <b class="rnd_b4"></b></b>
                <div class="rnd_content" id="content">
                    <div style="width: 600px; text-align: center; margin-left: auto; margin-right: auto;
                        border: solid 1px #e7710b; color: #e7710b; margin-top: 100px; padding: 15px;
                        background: white">
                        Oops, we have encountered an unexpected problem. Our engineers are working to fix
                        it. Sorry for your inconvenience. Please try again later.</div>
                </div>
                <b class="rnd_bottom"><b class="rnd_b4" style="background: #FFFFFF"></b><b class="rnd_b3"
                    style="background: #FFFFFF"></b><b class="rnd_b2" style="background: #FFFFFF"></b>
                    <b class="rnd_b1"></b></b>
            </div>
        </div>
        <div id="footer">
            <div>
                <a href="http://www.airnetz.com/airnetz/book_can_pol.html">Booking &amp; Cancellation
                    Policy</a> <a href="http://www.airnetz.com/airnetz/paymentops.html">Payment Option</a>
                <a href="http://www.airnetz.com/airnetz/news.html">Media Coverage</a> <a href="http://www.airnetz.com/airnetz/research.html">
                    Research</a> <a href="http://www.airnetz.com/airnetz/contacts.asp">Contact us</a>
                <a href="http://www.airnetz.com/airnetz/terms.html">Terms &amp; Conditions</a>
            </div>
            <div style="margin-top: 5px;">
            </div>
        </div>
    </div>
</body>
</html>
