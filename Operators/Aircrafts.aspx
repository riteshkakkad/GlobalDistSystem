<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Aircrafts.aspx.cs" MasterPageFile="~/Operators/OperatorMaster.master"
    Inherits="Aircrafts" %>

<%@ Import Namespace="Entities" %>
<%@ Import Namespace="DataAccessLayer" %>
<%@ Import Namespace="BusinessLayer" %>
<%@ Import Namespace="System.Collections" %>
<%@ Import Namespace="System.Collections.Generic" %>
<%@ Import Namespace="System.Collections.Specialized" %>
<%@ Import Namespace="Iesi.Collections" %>
<%@ Import Namespace="NHibernate" %>
<asp:Content runat="server" ContentPlaceHolderID="scriptholder">
<style type="text/css">
    .errorelem
    {
        border:1px solid #e7710b;
    }
    .errortext
    {
    color:#e7710b;
    }
</style>


    <script type="text/javascript">
    $(document).ready(function(){
    $.editable.addInputType('planetypes', {
    element : function(settings, original) {
        var input = $('select[name=aircrafttype]').clone();
        $(this).append(input);
        return(input);
     }
    });
    $.editable.addInputType('currency', {
    element : function(settings, original) {
      
        var input = $('select[name=currency]').clone();
           
        $(this).append(input);
        return(input);
     }
    });
    addeditablehandlers();
    addalternaterowcolors();
   
         $("#addaircraftform").submit(function(){
         
            if(validate())
            {
            $.ajax({
            'url': 'UpdateAircrafts.ashx',
            'data': $("#addaircraftform").serialize()+"&aircraftadd=1",
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
               resp+="<tr class='aircraft'>";
               resp+=" <td style='display: none'><input type='hidden' name='aid' value='"+data['aircraft'].AircraftId+"' /></td>";
               resp+="<td class='edit required'>"+data['aircraft'].AircraftName+"</td>";
               resp+="<td class='edit required'>"+data['aircraft'].AircraftLocation+"</td>";
               resp+="<td class='editplane'>"+data['aircraft'].AircraftType.PlaneTypeName+"("+data['aircraft'].AircraftType.Capacity+" PAX)"+"</td>";
               resp+="<td class='edit number required'>"+data['aircraft'].PassengerCapacity+"</td>";
               resp+="<td><div class='editcurr'>"+ data['aircraft'].Currency.FullName+"("+data['aircraft'].Currency.ID+")" +"</div><div class='price number'>"+ data['aircraft'].PricePerHour+"</div></td>";
               resp+="<td>";
               resp+="<div style='margin-bottom:10px;font-size:12px;'>";
               resp+="<a href='Photos.aspx?aid="+data['aircraft'].AircraftId+"&keepThis=true&TB_iframe=true&height=500&width=400' class='thickbox' style='color:#707070'>Add/Show Photos</a></div>";
               resp+="<a href='#' class='aircraftremove small-link'>Remove Aircraft</a></td></tr>";
              $("#aircraftlist").append(resp);
              tb_init("#aircraftlist tr:last-child a.thickbox");
            
                   addeditablehandlers();
                   addalternaterowcolors(); 
                   $("#addaircraftform").find("input[type=text]").val("");        
          
            
            }
            });
             return false;
            }
            else
            {
             return false;
            }
       
       
       });
        
    });
var addalternaterowcolors=function()
{
 if($("#aircraftlist tr.aircraft").size()>0)
 {
  $("#aircraftlist tr.noaircrafts").remove();
 }
 else
 {
  $("#aircraftlist").append("<tr class='noaircrafts'><td align=center colspan=7>No Aircrafts</td></tr>");
 }


}   
var addeditablehandlers=function(){



 $(".aircraftremove").click(function(){
        var id=$(this).parents("tr:eq(0)").find("td:eq(0) input[type=hidden]").val();
        var row=$(this).parents("tr:eq(0)");
        if(confirm("Are you sure?"))
        {
         $.ajax({
            'url': 'UpdateAircrafts.ashx',
            'data': "aid="+id+"&aircraftremove=1",
            'dataType': 'json',
            'type': 'POST',
            'success': function(data) {
            
                if(data['success'])
                {
                  row.remove();
                  addalternaterowcolors();
                  alert(data['text']);
                }
                
                
            }
            });
        }
        
        return false;
    
    
    });
$('.editcurr').editable("UpdateAircrafts.ashx", {
         indicator : '<img src="../css/indicator.gif">',
         tooltip   : 'Double click to edit...',
         event     : "dblclick",
         submit    : "OK",
         type:"currency",
         submitdata : function(value, settings) {
         
          return {aid: jQuery.trim($(this).parents("tr:eq(0)").find("td input[type=hidden]").val()),property:"Currency",aircraftupdate:'1'};
      
         },
         style   : 'display: inline'
     });
     $('.price').editable("UpdateAircrafts.ashx", {
         indicator : '<img src="../css/indicator.gif">',
         tooltip   : 'Double click to edit...',
         event     : "dblclick",
         submit    : "OK",
         submitdata : function(value, settings) {
         
          return {aid: jQuery.trim($(this).parents("tr:eq(0)").find("td input[type=hidden]").val()),property:"Price",aircraftupdate:'1'};
      
         },
         style   : 'display: inline',
         onsubmit:function(settings, original){
         
          if($(this).parents("div").hasClass("number"))
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
$('.editplane').editable("UpdateAircrafts.ashx", {
         indicator : '<img src="../css/indicator.gif">',
         tooltip   : 'Double click to edit...',
         event     : "dblclick",
         submit    : "OK",
         type:"planetypes",
         submitdata : function(value, settings) {
          var i=$(this).parents("tr:eq(0)").find("td").index(this);
          var head=jQuery.trim($("#aircraftlist th:eq("+i+") span").text());
          return {aid: jQuery.trim($(this).parents("tr:eq(0)").find("td input[type=hidden]").val()),property:head,aircraftupdate:'1'};
      
         },
         style   : 'display: inline'
     });

$('.edit').editable("UpdateAircrafts.ashx", {
         indicator : '<img src="../css/indicator.gif">',
         tooltip   : 'Double click to edit...',
         event     : "dblclick",
         submit    : "OK",
         submitdata : function(value, settings) {
          var i=$(this).parents("tr:eq(0)").find("td").index(this);
          var head=jQuery.trim($("#aircraftlist th:eq("+i+") span").text());
          return {aid: jQuery.trim($(this).parents("tr:eq(0)").find("td input[type=hidden]").val()),property:head,aircraftupdate:'1'};
      
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


}    
var validate=function(){
 
 var valid=true;
    $("#addaircraftform .required,#addaircraftform .number").removeClass("error");
    $("div.errortext").remove();
    $("#addaircraftform .required").each(function(i){
     
     
     if($(this).val()=="")
      {
       valid=false;
       if($(this).parents("td:eq(0)").find("div.errortext").size()==0)
         $(this).parents("td:eq(0)").append($("<div class='errortext'>* Required.</div>"));
       
       $(this).addClass('errorelem');
      }
    
    });
   
    $("#addaircraftform .number").each(function(){
    
     if($(this).val()!="" && isNaN($(this).val()))
      {
        
         valid=false;
          if($(this).parents("td:eq(0)").find("div.errortext:contains('Number')").size()==0)
                $(this).parents("td:eq(0)").append($("<div class='errortext'>* Number Required.</div>"));
         
         $(this).addClass('errorelem');
       }
    
    });
   
    
   return valid;
 

 
 
 }       
    </script>

</asp:Content>
<asp:Content runat="server" ContentPlaceHolderID="contentholder">
    <% Operator op = OperatorBO.GetLoggedinOperator();%>
    <table cellpadding="10" id="aircraftlist" class="bluetable" style="text-align:center;width: 850px; margin-left: auto;margin-right: auto">
        <tr>
            <th style="display: none">
            </th>
            <th>
                Aircraft Name <span style="display: none">AircraftName</span>
            </th>
            <th>
                Aircraft Location <span style="display: none">AircraftLocation</span>
            </th>
            <th>
                Aircraft Type <span style="display: none">AircraftType</span>
            </th>
            <th style="width: 80px;">
                Passenger Capacity <span style="display: none">PassengerCapacity</span>
            </th>
            <th>
                Price Per Hour
            </th>
            <th>
            </th>
        </tr>
        <% foreach (Airplane a in op.Aircrafts)
           {
        %>
        <tr class="aircraft">
            <td style="display: none">
                <input type="hidden" name="aid" value="<%= a.AircraftId %>" /></td>
            <td class="edit required">
                <%= a.AircraftName %>
            </td>
            <td class="edit required">
                <%= a.AircraftLocation %>
            </td>
            <td class="editplane">
                <%= a.AircraftType.PlaneTypeName + "(" + a.AircraftType.Capacity + " PAX)"%>
            </td>
            <td class="edit number required">
                <%=a.PassengerCapacity %>
            </td>
            <td class="editcurrency">
                <div class="editcurr">
                    <%= a.Currency.FullName+"("+a.Currency.ID+")" %>
                </div>
                <div class="price number">
                    <%= a.PricePerHour %>
                </div>
            </td>
            <td>
            <div style="margin-bottom:10px;font-size:12px;"><a href="Photos.aspx?aid=<%= a.AircraftId %>&keepThis=true&TB_iframe=true&height=500&width=400" class="thickbox" style="color:#707070">Add/Show Photos</a></div>
                <a href="#" class="aircraftremove small-link">Remove Aircraft</a></td>
        </tr>
        <%
            } %>
    </table>
    <form id="addaircraftform">
        <table cellpadding="10" class="bluetable" id="addaircraftformtable" style="margin-left: auto;
            margin-right: auto; margin-top: 20px">
            <tr>
            <th colspan="2" style="color:#e7710b">
              Add Aircraft
            </th>
            </tr>
            <tr>
                <th>
                    Aircraft Name
                </th>
                <td>
                    <input name="AircraftName" type="text" class="required" />
                </td>
            </tr>
            <tr>
                <th>
                    Passenger Capacity
                </th>
                <td>
                    <input name="Capacity" type="text" class="number required" />
                </td>
            </tr>
            <tr>
                <th>
                    Aircraft Type
                </th>
                <td>
                    <select name="aircrafttype">
                        <% 
                            foreach (AirplaneType a in OperatorDAO.GetAirplaneTypes())
                            {
                             
                        %>
                        <option value="<%= a.PlaneTypeID %>">
                            <%= a.PlaneTypeName +"("+a.Capacity+" PAX)" %>
                        </option>
                        <%
                            }
                    
                        %>
                    </select>
                </td>
            </tr>
            <tr>
                <th>
                    Aircraft Location
                </th>
                <td>
                    <input name="AircraftLocation" type="text" class="required" />
                </td>
            </tr>
            <tr>
                <th>
                    Price per hour
                </th>
                <td>
                    <select name="currency">
                        <%  foreach (Currency c in AdminDAO.GetCurrencies())
                            {
                               
                        %>
                        <option value="<%= c.ID %>">
                            <%= c.FullName +"("+ c.ID+")"%>
                        </option>
                        <%
               
                            } %>
                    </select>
                    <br />
                    <br />
                    <input name="PricePerHour" type="text" class="number" />
                </td>
            </tr>
            <tr>
                <th colspan="2">
                    <input type="submit" name="addaircraft" value="Add" class="buttons" style="width: 100px" />
                    <div id="Status" style="display: inline; margin-left: 30px">
                    </div>
                </th>
            </tr>
        </table>
    </form>
</asp:Content>
