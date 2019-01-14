<%@ Page Language="C#" MasterPageFile="~/Admin/AdminMaster.master" AutoEventWireup="true"
    CodeFile="Customers.aspx.cs" Inherits="Admin_Customers" Title="Untitled Page" %>

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
        input.css({'display':'inline'});
        input.find("option[value=all]").remove();
        $(this).append(input);
        return(input);
    }
});
$('.editcountries').editable("UpdateCustomers.ashx", {
         indicator : '<img src="../css/indicator.gif">',
         tooltip   : 'Double click to edit...',
         event     : "dblclick",
         submit    : "OK",
         submitdata : function(value, settings) {
          var i=$(this).parents("tr:eq(0)").children("td").index(this);
          var head=jQuery.trim($("#customerlist th:eq("+i+") span").text());
          return {cid: jQuery.trim($(this).parents("tr:eq(0)").find("td input[type=hidden]").val()),property:head,updatecustomer:'1'};
      
         },
         type:'countries',
         style   : 'display: inline',
         callback:function(){
         
         addcountrynames($(this).parents("tr:eq(0)")) ;
         
         }
     });
$('.edit').editable("UpdateCustomers.ashx", {
         indicator : '<img src="../css/indicator.gif">',
         tooltip   : 'Double click to edit...',
         event     : "dblclick",
         submit    : "OK",
         submitdata : function(value, settings) {
          var head=jQuery.trim($(this).parents("tr:eq(0)").find("th span").text());
          return {cid: jQuery.trim($(this).parents("tr.customerrow:eq(0)").find("td input[type=hidden]").val()),property:head,updatecustomer:'1'};
      
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
     $('.edittext').editable("UpdateCustomers.ashx", {
         indicator : '<img src="../css/indicator.gif">',
         tooltip   : 'Double click to edit...',
         type:'autogrow',
         event     : "dblclick",
         submit    : "OK",
         submitdata : function(value, settings) {
          var head=jQuery.trim($(this).parents("tr:eq(0)").find("th span").text());
          return {cid: jQuery.trim($(this).parents("tr.customerrow:eq(0)").find("td input[type=hidden]").val()),property:head,updatecustomer:'1'};
      
         },
         style   : 'display: inline',
         autogrow : {
           lineHeight : 16,
           minHeight  : 32
        }
     });
  
 $('.editselect').editable("UpdateCustomers.ashx", {
         indicator : '<img src="../css/indicator.gif">',
         tooltip   : 'Double click to edit...',
         event     : "dblclick",
         submit    : "OK",
         type:'select',
         data:"{'1':'Confirm','0':'Pending'}",
         submitdata : function(value, settings) {
          var i=$(this).parents("tr:eq(0)").children("td").index(this);
          var head=jQuery.trim($("#customerlist th:eq("+i+") span").text());
          return {cid: jQuery.trim($(this).parents("tr:eq(0)").find("td input[type=hidden]").val()),property:head,updatecustomer:'1'};
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

$(".removecustomer").click(function(){

if(!confirm("Are you sure?"))
  return false;

});
     
});
var addcountrynames=function(row){

var countryhead=$("#customerlist th:contains('Country')");

var i=$("#customerlist tr:eq(0) th").index(countryhead);
if(row)
{
  var temp=row.find("td.editcountries");
var cid= jQuery.trim(temp.text());
if(cid!="")
 temp.text($("select[name=country] option[value="+cid+"]").text());
 
}else
{

$("#customerlist td.editcountries").each(function(index){

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
        IList<Customer> cfulllist = CustomerDAO.GetCustomers(Request.QueryString);
        IList<Customer> clist = CustomerDAO.GetCustomers(pageid, 15, Request.QueryString);
    %>
    <select name="country" style="display: none">
        <%  foreach (Country c in OperatorDAO.GetCountries())
            {
                String cid = c.CountryID;
        %>
        <option value="<%= cid %>">
            <%= c.FullName%>
        </option>
        <%
               
            } %>
    </select>
    <table class="bluetable" style="margin-top: 20px; width: 800px; margin-left: auto;
        margin-right: auto">
        <tr>
            <th style="text-align: center">
                <form id="agentsearchform" action="Customers.aspx">
                    <span>Email</span><input type="text" name="email" value="<%= pars["email"] %>" style="margin-right: 20px" />
                    <span>Name</span><input type="text" name="name" value="<%= pars["name"] %>" style="margin-right: 20px" />
                    <span>Status: </span>
                    <select name="status" style="margin-right: 20px">
                        <option value="confirm" <%= (pars["status"]=="confirm")?"selected":"" %>>Confirm</option>
                        <option value="pending" <%= (pars["status"]=="pending")?"selected":"" %>>Pending</option>
                    </select>
                    <input type="submit" name="customersearchbtn" class="buttons" value="search" />
                </form>
            </th>
        </tr>
    </table>
    <br />
    <span class="brown">Pages: </span><span id="pages">
        <%
            Int32 noofpages = (Int32)Math.Ceiling(cfulllist.Count / 15.0);

            for (int i = 1; i <= noofpages; i++)
            {
                if (i != pageid)
                {
        %>
        <a href="<%= AdminBO.GetPagingURL(Request.QueryString,"Customers.aspx", i) %>" style="margin-right: 5px">
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
        margin-top: 20px" id="customerlist">
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
            if (cfulllist.Count > 0)
            {


                foreach (Customer c in clist)
                {
        %>
        <tr class="customerrow">
            <td style="display: none">
                <input type="hidden" value="<%= c.CustomerID %>" name="cid" /></td>
            <td>
                <table class="noborder">
                   
                    <tr>
                        <th>
                            <span style="display: none">Email</span> Email</th>
                        <td class="edit required email">
                            <%= c.Email %>
                        </td>
                    </tr>
                    <tr>
                        <th>
                            <span style="display: none">Email1</span> Alternate Email</th>
                        <td class="edit email">
                            <%= c.Email1 %>
                        </td>
                    </tr>
                    <tr>
                        <th>
                            <span style="display: none">Name</span> Name</th>
                        <td class="edit required">
                            <%= c.Name %>
                        </td>
                    </tr>
                    <tr>
                        <th>
                            <span style="display: none">CompanyName</span> Company Name</th>
                        <td class="edit">
                            <%= c.CompanyName %>
                        </td>
                    </tr>
                    <tr>
                        <th>
                            <span style="display: none">Address</span> Address</th>
                        <td class="edittext">
                            <%= c.Address %>
                        </td>
                    </tr>
                    <tr>
                        <th>
                            <span style="display: none">ContactNo</span> Contact No</th>
                        <td class="edit required">
                            <%= c.ContactNo %>
                        </td>
                    </tr>
                    <tr>
                        <th>
                            <span style="display: none">ContactNo1</span> Alternate Contact No</th>
                        <td class="edit">
                            <%= c.ContactNo1 %>
                        </td>
                    </tr>
                </table>
            </td>
            <td class="editcountries">
                <%= c.Country %>
            </td>
            <td class="editselect">
                <%= (c.Status == 0) ? "Pending" : "Confirm" %>
            </td>
            <td>
                <div style="margin-bottom: 10px;">
                    <a href="showbookrequests.aspx?email=<%= c.Email %>" target="_blank">Show Requests</a></div>
                <div>
                    <a href="updatecustomers.ashx?removecustomer=1&cid=<%= c.CustomerID %>" class="small-link removecustomer">
                        Remove Customer</a></div>
            </td>
        </tr>
        <%
            }
        }
        else
        {
        %>
        <tr>
            <th colspan="12" style="text-align: center">
                No Customers Found</th>
        </tr>
        <%
            }
            
            
        %>
    </table>
</asp:Content>
