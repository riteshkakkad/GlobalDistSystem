<%@ Page Language="C#" Async="true" AutoEventWireup="true" CodeFile="AgentSettings.aspx.cs" Inherits="Admin_AgentSettings" %>

<%@ Import Namespace="Entities" %>
<%@ Import Namespace="DataAccessLayer" %>
<%@ Import Namespace="BusinessLayer" %>
<%@ Import Namespace="System.Collections" %>
<%@ Import Namespace="System.Collections.Generic" %>
<%@ Import Namespace="System.Collections.Specialized" %>
<%@ Import Namespace="Iesi.Collections" %>
<%@ Import Namespace="NHibernate" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Untitled Page</title>
    <style type="text/css">
    body
    {
     font-size:11px;
     font-family:verdana;
    }
.bluetable
{
 border: 1px solid #c0c0c0;
 border-spacing: 0px; 
 border-collapse: collapse;
}
.bluetable th
{
 background:#f8f8f8;
 padding:10px;
 color: #707070; 
 border-bottom:1px solid #c0c0c0;
 border-right:1px solid #c0c0c0;

} 
.bluetable td
{
 background:white;
 padding:10px;
 border-bottom:1px solid #c0c0c0;
 border-right:1px solid #c0c0c0;
 vertical-align:top;

}    

    
    </style>
</head>
<body>
    <% if (Session["done"] != null)
   { %>
    <div style="border: 1px solid #c0c0c0;text-align:center">
        Operation Successful.
    </div>
    <%
        Session["done"] = null;
    
   } %>
    <% Agent a = AgentDAO.FindAgentByID(Int64.Parse(Request.Params.Get("aid"))); %>
    <table class="bluetable" style="margin-top: 20px;">
        <tr>
            <th>
                Agent Link
            </th>
            <td>
                http://www.airnetzcharter.com/ResolveAgent.aspx?Agent=<%= a.AgentCode %><br />
                <a href="<%= ResolveUrl("~/ResolveAgent.aspx?Agent="+a.AgentCode) %>" target="_blank">Go</a>
            </td>
        </tr>
        <tr>
            <th>
                Generate Code
            </th>
            <td>
                <a href="agentsettings.aspx?generatecode=1&aid=<%= Request.Params.Get("aid") %>">
                    Generate Code</a>
            </td>
        </tr>
        <tr>
            <th>
                Generate Password
            </th>
            <td>
                <a href="agentsettings.aspx?generatepassword=1&aid=<%= Request.Params.Get("aid") %>">
                    Generate</a>
            </td>
        </tr>
        <tr>
            <th>
                Send Password and Link to Agent
            </th>
            <td>
                <a href="agentsettings.aspx?emaillink=1&aid=<%= Request.Params.Get("aid") %>">Send</a>
            </td>
        </tr>
    </table>
</body>
</html>
