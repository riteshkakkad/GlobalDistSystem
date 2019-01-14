<%@ Page Language="C#" MasterPageFile="~/Admin/AdminMaster.master" AutoEventWireup="true"
    CodeFile="AirplaneTypeRates.aspx.cs" Inherits="AirplaneTypeRates" Title="Untitled Page" %>

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

$('.edit').editable("UpdateAirplanetypes.ashx", {
         indicator : '<img src="../css/indicator.gif">',
         tooltip   : 'Double click to edit...',
         event     : "dblclick",
         submit    : "OK",
         submitdata : function(value, settings) {
          var i=$(this).parents("tr:eq(0)").find("td").index(this);
          var head=jQuery.trim($("#ratelist th:eq("+i+")").text());
          return {rateid: jQuery.trim($(this).parents("tr:eq(0)").find("td input[type=hidden]").val()),property:head,updateairplanetyperates:'1'};
      
         },
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
          },
         style   : 'display: inline',
         
     });


$(".remove").click(function(){

if(!confirm("Are your sure?"))
 return false;
});

$("#addairplanetyperateform").submit(function(){
var valid =true;
 $('.errortext').remove();
  $('.error').removeClass('error');
$("input.number").each(function(i){

if(($(this).val()=="") || isNaN($(this).val()))
{  valid=false;
$("<div class='errortext'>* Number Required.</div>").insertAfter($(this).addClass('error'));
}

});

if(!valid)
 return false;


});

});
    </script>

</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="contentholder" runat="Server">
    <% NameValueCollection pars = Request.QueryString;
 
    %>
    <table class="bluetable" style="width: 900px; margin-left: auto; margin-right: auto;
        margin-top: 20px">
        <tr>
            <th style="text-align: center">
                <form action="AirplaneTypeRates.aspx">
                    <span>Select Country </span>
                    <select name="country">
                        <option value="all" <%= (pars["country"]!=null)?"":"selected" %>>All</option>
                        <%  foreach (Country c in OperatorDAO.GetCountriesWithCurrency())
                            {
                                String cid = c.CountryID;
                        %>
                        <option value="<%= cid %>" <%= (pars["country"]==cid)?"selected" :"" %>>
                            <%= c.FullName%>
                        </option>
                        <%
               
                            } %>
                    </select>
                    <span>Select PlaneType</span>
                    <select name="aircrafttype">
                        <option value="all" <%= (pars["aircrafttype"]!=null)?"":"selected" %>>All</option>
                        <% 
                            foreach (AirplaneType a in OperatorDAO.GetAirplaneTypes())
                            {
                                String atypeid = a.PlaneTypeID;   
                        %>
                        <option value="<%= a.PlaneTypeID %>" <%= (pars["aircrafttype"]==atypeid)?"selected" :"" %>>
                            <%= a.PlaneTypeName %>
                            (<%= a.Capacity %>
                            PAX)</option>
                        <%
                            }
                    
                        %>
                    </select>
                    <input type="submit" class="buttons" value="search" name="searchratebtn" />
                </form>
            </th>
        </tr>
    </table>
    <table class="bluetable" id="ratelist" style="width: 900px; margin-left: auto; margin-right: auto;
        margin-top: 20px">
        <tr>
            <th>
                Plane Type Name
            </th>
            <th>
                HourlyRate</th>
            <th>
                WaitingCharge</th>
            <th>
                FuelPositioning</th>
            <th>
                NightHalt</th>
            <th>
                Crew</th>
            <th>
                WatchHour</th>
            <th>
                Country</th>
            <th>
            </th>
        </tr>
        <% foreach (AirplaneTypeRate atr in OperatorDAO.GetAllRates(Request.QueryString))
           {
        %>
        <tr>
            <td>
                <input type="hidden" name="rateid" value="<%= atr.RateID %>" />
                <%= atr.PlaneType.PlaneTypeName %>
                (<%= "Rates in " + atr.Country.Currency.ID %>
                )
            </td>
            <td class="edit required number">
                <%= atr.HourlyRate %>
            </td>
            <td class="edit required number">
                <%= atr.WaitingCharge %>
            </td>
            <td class="edit required number">
                <%= atr.FuelPositioning %>
            </td>
            <td class="edit required number">
                <%= atr.NightHalt %>
            </td>
            <td class="edit required number">
                <%= atr.Crew %>
            </td>
            <td class="edit required number">
                <%= atr.WatchHour %>
            </td>
            <td>
                <%= atr.Country.FullName %>
            </td>
            <td>
                <a href="airplanetyperates.aspx?removerate=1&rid=<%= atr.RateID %>" class="remove small-link">Remove</a></td>
        </tr>
        <%
            } %>
    </table>
    <form action="AirplaneTypeRates.aspx" id="addairplanetyperateform">
        <table class="bluetable" style="width: 600px; margin-left: auto; margin-right: auto;
            margin-top: 20px">
            <tr>
                <th>
                    Plane Type
                </th>
                <td>
                    <select name="aircrafttype_add">
                        <% 
                            foreach (AirplaneType a in OperatorDAO.GetAirplaneTypes())
                            {
                                String atypeid = a.PlaneTypeID;   
                        %>
                        <option value="<%= a.PlaneTypeID %>" <%= (pars["aircrafttype"]==atypeid)?"selected" :"" %>>
                            <%= a.PlaneTypeName %>
                            (<%= a.Capacity %>
                            PAX)</option>
                        <%
                            }
                    
                        %>
                    </select>
                </td>
            </tr>
            <tr>
                <th>
                    HourlyRate</th>
                <td>
                    <input type="text" name="hourlyrate" class="number" />
                </td>
            </tr>
            <tr>
                <th>
                    WaitingCharge</th>
                <td>
                    <input type="text" name="waitingcharge" class="number" />
                </td>
            </tr>
            <tr>
                <th>
                    FuelPositioning</th>
                <td>
                    <input type="text" name="fuelpositioning" class="number" />
                </td>
            </tr>
            <tr>
                <th>
                    NightHalt</th>
                <td>
                    <input type="text" name="nighthalt" class="number" />
                </td>
            </tr>
            <tr>
                <th>
                    Crew</th>
                <td>
                    <input type="text" name="crew" class="number" />
                </td>
            </tr>
            <tr>
                <th>
                    WatchHour</th>
                <td>
                    <input type="text" name="watchhour" class="number" />
                </td>
            </tr>
            <tr>
                <th>
                    Country</th>
                <td>
                    <select name="country_add">
                        <%  foreach (Country c in OperatorDAO.GetCountriesWithCurrency())
                            {
                                String cid = c.CountryID;
                        %>
                        <option value="<%= cid %>" <%= (pars["country"]==cid)?"selected" :"" %>>
                            <%= c.FullName%>
                            (<%= c.Currency.ID %>)</option>
                        <%
               
                            } %>
                    </select>
                </td>
            </tr>
            <tr>
                <td colspan="2">
                    <input type="submit" class="buttons" name="addairplanetype" value="Add" />
                </td>
            </tr>
        </table>
    </form>
    <div>
        <% if (Session["alreadypresent"] != null)
           {
        %>
        Already Present.
        <%
            Session["alreadypresent"] = null;
        } %>
    </div>
</asp:Content>
