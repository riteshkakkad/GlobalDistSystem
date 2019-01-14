<%@ Page Language="C#" MasterPageFile="~/Admin/AdminMaster.master" AutoEventWireup="true"
    CodeFile="Agents.aspx.cs" Inherits="Admin_Agents" Title="Untitled Page" %>

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
addcountrynames();

$.editable.addInputType('countries', {
    element : function(settings, original) {
        var input = $('select[name=country]').clone();
        input.find("option[value=all]").remove();
        $(this).append(input);
        return(input);
    }
});
$('.editcountries').editable("UpdateAgents.ashx", {
         indicator : '<img src="../css/indicator.gif">',
         tooltip   : 'Double click to edit...',
         event     : "dblclick",
         submit    : "OK",
         submitdata : function(value, settings) {
          var i=$(this).parents("tr:eq(0)").children("td").index(this);
          var head=jQuery.trim($("#agentlist th:eq("+i+") span").text());
          return {aid: jQuery.trim($(this).parents("tr:eq(0)").find("td input[type=hidden]").val()),property:head,updateagent:'1'};
      
         },
         type:'countries',
         style   : 'display: inline',
         callback:function(){
         
         addcountrynames($(this).parents("tr:eq(0)")) ;
         
         }
     });
$('.edit').editable("UpdateAgents.ashx", {
         indicator : '<img src="../css/indicator.gif">',
         tooltip   : 'Double click to edit...',
         event     : "dblclick",
         submit    : "OK",
         submitdata : function(value, settings) {
          var head=jQuery.trim($(this).parents("tr:eq(0)").find("th span").text());
          return {aid: jQuery.trim($(this).parents("tr.agentrow:eq(0)").find("td input[type=hidden]").val()),property:head,updateagent:'1'};
      
         },
         style   : 'display: inline',
         onsubmit:function(settings, original){
          if($(this).parents("td").hasClass("required"))
          {
             if($(this).find("input[type=text]").val()=="")
             {
              alert("Field Required.");
               original.editing = false;
              $(original).html(original.revert);
              return false;
             }   
          }
         if($(this).parents("td").hasClass("email"))
          {
             var temp=true;
             if($(this).find("input[type=text]").val()=="")
                temp=false;
              
            if(!echeck($(this).find("input[type=text]").val()) && temp)
            {
              alert("Invalid Email.");
              original.editing = false;
              $(original).html(original.revert);
              return false;
             }   
          }
               
         }
     });
     $('.edittext').editable("UpdateAgents.ashx", {
         indicator : '<img src="../css/indicator.gif">',
         tooltip   : 'Double click to edit...',
         type:'autogrow',
         event     : "dblclick",
         submit    : "OK",
         submitdata : function(value, settings) {
          var head=jQuery.trim($(this).parents("tr:eq(0)").find("th span").text());
          return {aid: jQuery.trim($(this).parents("tr.agentrow:eq(0)").find("td input[type=hidden]").val()),property:head,updateagent:'1'};
      
         },
         style   : 'display: inline',
         autogrow : {
           lineHeight : 16,
           minHeight  : 32
        }
     });
  
 $('.editselect').editable("UpdateAgents.ashx", {
         indicator : '<img src="../css/indicator.gif">',
         tooltip   : 'Double click to edit...',
         event     : "dblclick",
         submit    : "OK",
         type:'select',
         data:"{'1':'Confirm','0':'Pending'}",
         submitdata : function(value, settings) {
          var i=$(this).parents("tr:eq(0)").children("td").index(this);
          var head=jQuery.trim($("#agentlist th:eq("+i+") span").text());
          return {aid: jQuery.trim($(this).parents("tr:eq(0)").find("td input[type=hidden]").val()),property:head,updateagent:'1'};
         },
         callback:function(){
           
           if($(this).text()=="1")
           {
            $(this).text("Confirm");
           }else if($(this).text()=="0")
           {
            $(this).text("Pending");
           }
           location.reload();
         
         }
         ,
         style   : 'display: inline'
     });

$(".removeagent").click(function(){

if(!confirm("Are you sure?"))
  return false;

});
     
});
var addcountrynames=function(row){

var countryhead=$("#agentlist th:contains('Country')");

var i=$("#agentlist tr:eq(0) th").index(countryhead);
if(row)
{
  var temp=row.find("td.editcountries");
var cid= jQuery.trim(temp.text());
if(cid!="")
 temp.text($("select[name=country] option[value="+cid+"]").text());
 
}else
{

$("#agentlist td.editcountries").each(function(index){

var cid= jQuery.trim($(this).text());
if(cid!="")
 $(this).text($("select[name=country] option[value="+cid+"]").text());
 
});
}


}
    </script>

</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="contentholder" runat="Server">
    <% 
        Int32 pageid = 1;
        if (Request.Params.Get("pageid") != null)
        {
            pageid = Int32.Parse(Request.Params.Get("pageid"));
        }
        NameValueCollection pars = Request.QueryString;
        IList<Agent> afulllist = AgentDAO.GetAgents(Request.QueryString);
        IList<Agent> alist = AgentDAO.GetAgents(pageid, 15, Request.QueryString);
    %>
    <form id="agentsearchform" action="Agents.aspx">
        <table class="bluetable" style="width: 950px">
            <tr>
                <th>
                    <span>Email</span><br />
                    <input type="text" name="email" value="<%= pars["email"] %>" />
                </th>
                <th>
                    <span>Agency</span><br />
                    <input type="text" name="agencyname" value="<%= pars["agencyname"] %>" />
                </th>
                <th>
                    <span>Country</span><br />
                    <select name="country">
                        <option value="all" <%= (pars["country"]!=null)?"":"selected" %>>All</option>
                        <%  foreach (Country c in OperatorDAO.GetCountries())
                            {
                                String cid = c.CountryID;
                        %>
                        <option value="<%= cid %>" <%= (pars["country"]==cid)?"selected" :"" %>>
                            <%= c.FullName%>
                        </option>
                        <%
               
                            } %>
                    </select>
                </th>
                <th>
                    <span>Status: </span>
                    <br />
                    <select name="status">
                        <option value="confirm" <%= (pars["status"]=="confirm")?"selected":"" %>>Confirm</option>
                        <option value="pending" <%= (pars["status"]=="pending")?"selected":"" %>>Pending</option>
                    </select>
                </th>
                <th>
                    <input type="submit" name="agentsearchbtn" class="buttons" value="search" /></th>
            </tr>
        </table>
    </form>
    <br />
    <span class="brown">Pages: </span><span id="pages">
        <%
            Int32 noofpages = (Int32)Math.Ceiling(afulllist.Count / 15.0);

            for (int i = 1; i <= noofpages; i++)
            {
                if (i != pageid)
                {
        %>
        <a href="<%= AdminBO.GetPagingURL(Request.QueryString,"Agents.aspx", i) %>" style="margin-right: 5px">
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
    <table class="bluetable" style="width: 950px; margin-left: auto; margin-right: auto;
        margin-top: 20px" id="agentlist">
        <tr>
            <th style="display: none">
            </th>
            <th>
                Personal Details</th>
            <th>
                <span style="display: none">Country</span>Country</th>
            <th>
                <span style="display: none">Status</span>Status</th>
            <th>
            </th>
        </tr>
        <%
            if (afulllist.Count > 0)
            {


                foreach (Agent a in alist)
                {
        %>
        <tr class="agentrow">
            <td style="display: none">
                <input type="hidden" value="<%= a.AgentID %>" name="aid" /></td>
            <td>
                <table class="noborder">
                   
                    <tr>
                        <th>
                            Email<span style="display: none">Email</span></th>
                        <td class="edit required email">
                            <%= a.Email %>
                        </td>
                    </tr>
                    <tr>
                        <th>
                            <span style="display: none">Email1</span> Alternate Email</th>
                        <td class="edit email">
                            <%= a.Email1 %>
                        </td>
                    </tr>
                    <tr>
                        <th>
                            <span style="display: none">Name</span> Agent Name</th>
                        <td class="edit required">
                            <%= a.Name %>
                        </td>
                    </tr>
                    <tr>
                        <th>
                            <span style="display: none">Agency</span> Agency Name</th>
                        <td class="edit required">
                            <%= a.Agency %>
                        </td>
                    </tr>
                    <tr>
                        <th>
                            <span style="display: none">BillingAddress</span> Address</th>
                        <td class="edittext required">
                            <%= a.BillingAddress %>
                        </td>
                    </tr>
                    <tr>
                        <th>
                            <span style="display: none">ContactNo</span> Contact No</th>
                        <td class="edit required">
                            <%= a.ContactNo %>
                        </td>
                    </tr>
                    <tr>
                        <th>
                            <span style="display: none">ContactNo1</span> Alternate Contact No</th>
                        <td class="edit">
                            <%= a.ContactNo1 %>
                        </td>
                    </tr>
                    <tr>
                        <th>
                            <span style="display: none">AgentFax</span> Fax</th>
                        <td class="edit">
                            <%= a.AgentFax %>
                        </td>
                    </tr>
                </table>
            </td>
            <td class="editcountries">
                <%= a.Country%>
            </td>
            <td class="editselect">
                <%= (a.Status == 0) ? "Pending" : "Confirm"%>
            </td>
            <td>
                <div style="margin-bottom: 10px;">
                    <a href="showbookrequests.aspx?agentid=<%= a.AgentID %>">Show Requests</a></div>
                <div style="margin-bottom: 10px;">
                    <a href="AgentSettings.aspx?aid=<%= a.AgentID %>&keepThis=true&TB_iframe=true&height=400&width=700"
                        title="Agent Settings" class="thickbox">Agent Link</a>
                </div>
                <div>
                    <a href="updateagents.ashx?removeagent=1&aid=<%= a.AgentID %>" class="small-link removeagent">
                        Remove Agent</a></div>
            </td>
        </tr>
        <%
            }
        }
        else
        {
        %>
        <tr>
            <th colspan="5" style="text-align: center">
                No Agents Found</th>
        </tr>
        <%
            }
            
            
        %>
    </table>
</asp:Content>
