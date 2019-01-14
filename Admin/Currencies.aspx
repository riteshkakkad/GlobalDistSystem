<%@ Page Language="C#" MasterPageFile="~/Admin/AdminMaster.master" AutoEventWireup="true"
    CodeFile="Currencies.aspx.cs" Inherits="Currencies" Title="Untitled Page" %>

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
     addhandler();
        $("#addcurrencyform").submit(function(){
        var valid=true;
        $("#addcurrencyform .required").each(function(i){
     
     
     if($(this).val()=="")
      {
       valid=false;
       if($(this).parents("td:eq(0)").find("div.errortext").size()==0)
         $(this).parents("td:eq(0)").append($("<div class='errortext'>* Required.</div>"));
       
       $(this).addClass('error');
      }
    
    });
   
    $("#addcurrencyform .number").each(function(){
    
     if($(this).val()!="" && isNaN($(this).val()))
      {
        
         valid=false;
          if($(this).parents("td:eq(0)").find("div.errortext:contains('Number')").size()==0)
                $(this).parents("td:eq(0)").append($("<div class='errortext'>* Number Required.</div>"));
         
         $(this).addClass('error');
       }
    
    });
   
    if($("input[name=currencyid]").val().length!=3)
    {
     valid=false;
     if($("input[name=currencyid]").parents("td:eq(0)").find("div.errortext:contains('Number')").size()==0)
                $("input[name=currencyid]").parents("td:eq(0)").append($("<div class='errortext'>* ID size should be 3.</div>"));
         
     $("input[name=currencyid]").addClass('error');
    }
    
        if(valid)
        {
           $.ajax({
            'url': 'UpdateCurrencies.ashx',
            'data': $("#addcurrencyform").serialize()+"&currencyadd=1",
            'dataType': 'json',
            'type': 'POST',
            'beforeSend':function(){
            
              $("#Status").html("<img src='../images/loadingAnimation.gif' />");
             
            },
            'success': function(data) {
                $("#Status").html(data['text']);
               if(data['error'])
                 return;
                 
                 
                var resp="";
                resp+="<tr>";
                resp+="<td>"+data['currency'].ID+"</td>";
                resp+="<td class='edit'>"+data['currency'].FullName+"</td>";
                resp+="<td class='edit'>"+data['currency'].ShortName+"</td>";
                resp+="<td class='edit'>"+data['currency'].Rate+"</td>";
                 
                resp+="<td><a href='UpdateCurrencies.ashx?cid="+ data['currency'].ID+"&removecurrency=1' class='removecurrency small-link'>Remove</a></td>";
                resp+="</tr>";  
                
                $("#currencylist").append(resp);
               $('select[name=currencies]').append("<option value='"+data['currency'].ID+"'>"+ data['currency'].FullName + "(" + data['currency'].ID + ")"+"</option>");
                addhandler();
                 
               }
               
              }); 
        }
        
        return false;
        
        
        });
    
    });
var addhandler=function(){
    $.editable.addInputType('currencies', {
    element : function(settings, original) {
        var input = $('select[name=currencies]').clone();
        input.css({'display':'inline'});
        $(this).append(input);
        return(input);
    }
   });
    
    $(".removecurrency").click(function(){
    
        if(confirm("Are you sure?"))
        {   if(confirm("Are you very sure?"))
             return true;
            else
             return false; 
        }
        else
            return false;  
    
   });
    $('.editcurrency').editable("UpdateCurrencies.ashx", {
         indicator : '<img src="../css/indicator.gif">',
         tooltip   : 'Double click to edit...',
         event     : "dblclick",
         submit    : "OK",
         type:"currencies",
         submitdata : function(value, settings) {
           var country=$("select[name=country]").val();
           return {cid:country,'countrycurrencyupdate':'1'};
           
         },
         style   : 'display: inline'
     });
    $('.edit').editable("UpdateCurrencies.ashx", {
         indicator : '<img src="../css/indicator.gif">',
         tooltip   : 'Double click to edit...',
         event     : "dblclick",
         submit    : "OK",
         submitdata : function(value, settings) {
          var i=$(this).parents("tr:eq(0)").find("td").index(this);
          var head=jQuery.trim($("#currencylist th:eq("+i+")").text());
          return {cid: jQuery.trim($(this).parents("tr:eq(0)").find("td:first-child").text()),property:head,updatecurrency:'1'};
      
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
         if($(this).parents("td").hasClass("number"))
          {
            if(isNaN($(this).find("input[type=text]").val()))
             {
                alert("Number Required.");
               original.editing = false;
              $(original).html(original.revert);
              return false;
             }
          }
               
         }
     });
    $("select[name=country]").change(function(){
     $.ajax({
            'url': 'UpdateCurrencies.ashx',
            'data': "cid="+$(this).val()+"&getcountrycurrency=1",
            'dataType': 'json',
            'type': 'POST',
            'beforeSend':function(){
            
              $("#countrycurrency").html("<img src='../images/loadingAnimation.gif' />");
             
            },
            'success': function(data) {
               
                $("#countrycurrency").html(data['currency']);
                addhandler();
               
               }
            });
    
      
    
    
    });
    }
    </script>

</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="contentholder" runat="Server">
    <% IList<Currency> clist = AdminDAO.GetCurrencies(); %>
    <table class="bluetable" id="currencylist" style="width:500px;margin-left:auto;margin-right:auto;margin-top:20px">
        <tr>
            <th>
                Currency ID
            </th>
            <th>
                Full Name
            </th>
            <th>
                Short Name</th>
            <th>
                Rate</th>
            <th>
            </th>
        </tr>
        <% foreach (Currency c in clist)
           {
        %>
        <tr>
            <td>
                <%= c.ID %>
            </td>
            <td class="edit required">
                <%= c.FullName %>
            </td>
            <td class="edit required">
                <%= c.ShortName %>
            </td>
            <td class="edit number required">
                <%= c.Rate %>
            </td>
            <td>
                <a href="UpdateCurrencies.ashx?cid=<%= c.ID %>&removecurrency=1" class="removecurrency small-link">
                    Remove</a>
            </td>
        </tr>
        <%
            } %>
    </table>
    <select name="currencies" style="display:none">
        <option value="null">Not specified</option>
        <% foreach (Currency c in AdminDAO.GetCurrencies())
           {
        %>
        <option value="<%= c.ID %>">
            <%= c.FullName + "(" + c.ID + ")" %>
        </option>
        <%
           
            } %>
    </select>
    <form id="addcurrencyform">
        <table class="bluetable" style="width:400px;margin-left:auto;margin-right:auto;margin-top:20px">
            <tr>
                <th>
                    Currency ID
                </th>
                <td>
                    <input type="text" name="currencyid" class="required" />
                </td>
            </tr>
            <tr>
                <th>
                    Full Name
                </th>
                <td>
                    <input type="text" name="fullname" class="required" />
                </td>
            </tr>
            <tr>
                <th>
                    Short Name
                </th>
                <td>
                    <input type="text" name="shortname" class="required" />
                </td>
            </tr>
            <tr>
                <th>
                    Rate
                </th>
                <td>
                    <input type="text" name="rate" class="required number" />
                </td>
            </tr>
            <tr>
                <td colspan="2">
                    <input type="submit" class="buttons" value="add" />
                    <div id="Status">
                    </div>
                </td>
            </tr>
        </table>
    </form>
    <table class="bluetable" style="width:400px;margin-left:auto;margin-right:auto;margin-top:20px">
        <tr>
            <th>
                Country</th>
            <th>
                Currency</th>
        </tr>
        <tr>
            <td>
                <select name="country">
                    <option value="select" selected>select country</option>
                    <%  foreach (Country c in OperatorDAO.GetCountries())
                        {
                            String cid = c.CountryID;
                    %>
                    <option cont="<%= c.Continent %>" value="<%= cid %>">
                        <%= c.FullName%>
                    </option>
                    <%
               
                        } %>
                </select>
            </td>
            <td id="countrycurrency" class="editcurrency">
            </td>
        </tr>
    </table>
</asp:Content>
