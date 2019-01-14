<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/Admin/AdminMaster.master"
    CodeFile="AddAirfields.aspx.cs" Inherits="AddAirfields" %>

<%@ Import Namespace="Entities" %>
<%@ Import Namespace="DataAccessLayer" %>
<%@ Import Namespace="BusinessLayer" %>
<%@ Import Namespace="System.Collections" %>
<%@ Import Namespace="System.Collections.Generic" %>
<%@ Import Namespace="Iesi.Collections" %>
<%@ Import Namespace="NHibernate" %>
<asp:Content runat="server" ContentPlaceHolderID="scriptholder">


<script type="text/javascript">
var saveairfieldbyforce=false;
$(document).ready(function(){

$("input[name=addairfieldbtn]").click(function(){
   
  
    var valid=true;
    $("input.required,input.number").removeClass("error");
    $("div.errortext").remove();
    $("input.required:enabled").each(function(i){
    
     if($(this).val()=="")
      {
       valid=false;
       if($(this).parents("td:eq(0)").find("div.errortext").size()==0)
         $(this).parents("td:eq(0)").append($("<div class='errortext'>* Required.</div>"));
       
       $(this).addClass('error');
      }
    
    });
    $("input.number").each(function(){
    
     if($(this).val()!="" && isNaN($(this).val()))
      {
        
         valid=false;
          if($(this).parents("td:eq(0)").find("div.errortext:contains('Number')").size()==0)
                $(this).parents("td:eq(0)").append($("<div class='errortext'>* Number Required.</div>"));
         
         $(this).addClass('error');
       }
    
    });
    
    if(!valid)
     return false;
    else
    {
     
     $.ajax({
            'url': 'UpdateAirfields.ashx',
            'data': $("#airfieldform").serialize()+"&saveairfieldbyforce="+saveairfieldbyforce,
            'dataType': 'json',
            'type': 'POST',
            'beforeSend':function(){
            
              $("#Status").html("<img src='../images/loadingAnimation.gif' />");
             
            },
            'success': function(data) {
            
                $('table.returnairfield').remove();
               
             var headerrow="<tr><th>ICAO<br />CODE</th><th>IATA<br />CODE</th><th>Airfield Name</th><th>City</th><th>State</th><th>Country</th><th>Longitude</th><th>Lattitude</th><th>Runway</th><th>Altitude</th><th>Alternative names</th></tr>";
                var resp="";
               $("#Status").html(data['text']);
               if(data['similar'])
               {
                $("#Status").append("Want to save current airfield? <a href='#' class='saveforce'>click here</a>");
                 $(".saveforce").click(function(){
                 saveairfieldbyforce=true;
                 $("input[name=addairfieldbtn]").click();
                 return false;
                 });
                 $.each(data['similarairfields'],function(li,l){
                 
                 
                 resp+="<tr><td>"+l.ICAOCODE+"</td>";
                resp+="<td>"+l.IATACode+"</td>";
                 resp+="<td>"+l.AirfieldName+"</td>";
                  resp+="<td>"+l.City+"</td>";
                   resp+="<td>"+l.State+"</td>";
                    resp+="<td>"+l.Country+"</td>";
                     resp+="<td>"+l.LongitudeDegrees+"<sup>o</sup> "+l.LongitudeMinutes+"<sup>'</sup> "+l.EW +"</td>";
                      resp+="<td>"+l.LattitudeDegrees+"<sup>o</sup> "+l.LattitudeMinutes+"<sup>'</sup> "+l.NS +"</td>";
                       resp+="<td>"+l.Runway+"</td>";
                        resp+="<td>"+l.Altitude+"</td>";
                        resp+="<td>"+l.AlternativeNames+"</td></tr>";
                 
                 });
                 
                 
                 
               }
               else
               {
               saveairfieldbyforce=false;
               
               
               resp+="<tr><td>"+data['airfield'].ICAOCODE+"</td>";
                resp+="<td>"+data['airfield'].IATACode+"</td>";
                 resp+="<td>"+data['airfield'].AirfieldName+"</td>";
                  resp+="<td>"+data['airfield'].City+"</td>";
                   resp+="<td>"+data['airfield'].State+"</td>";
                    resp+="<td>"+data['airfield'].Country+"</td>";
                     resp+="<td>"+data['airfield'].LongitudeDegrees+"<sup>o</sup> "+data['airfield'].LongitudeMinutes+"<sup>'</sup> "+data['airfield'].EW +"</td>";
                      resp+="<td>"+data['airfield'].LattitudeDegrees+"<sup>o</sup> "+data['airfield'].LattitudeMinutes+"<sup>'</sup> "+data['airfield'].NS +"</td>";
                       resp+="<td>"+data['airfield'].Runway+"</td>";
                        resp+="<td>"+data['airfield'].Altitude+"</td>";
                        resp+="<td>"+data['airfield'].AlternativeNames+"</td></tr>";
               
               
               
                
               }
               $("<table class='returnairfield bluetable' style='margin-top:20px;margin-left:auto;margin-right:auto;width:700px'></table>").append(headerrow).append(resp).insertAfter($("#airfieldform"));
            }
            });
            return false;
    } 
    

});
$("input[name=autoassign]").click(function(){

 if($(this).val()=="unavail" || $(this).val()=="heliport")
  {
    $("input[name=icaocode]").attr("disabled",true);
  }
  else
  {
   $("input[name=icaocode]").removeAttr("disabled");
  }
});
});

</script>
</asp:Content>
<asp:Content ContentPlaceHolderID="contentholder" runat="server">
<form id="airfieldform">
    <table class="bluetable" style="width:500px;margin-left:auto;margin-right:auto">
        <tr>
        <th colspan="2" style="color:#e7710b;">
        Add Airfield
        </th>
        </tr>
        <tr>
            <th>
                ICAO CODE</th>
            <td>
                <input type="text" name="icaocode" class="required" />
                <div>
                <input type="radio" name="autoassign" value="avail" checked />ICAO Available<br />
                <input type="radio" name="autoassign" value="unavail" />ICAO Unavailable<br />
                <input type="radio" name="autoassign" value="heliport" />Heliport
                </div>
                
            </td>
        </tr>
        <tr>
            <th>
                IATA CODE</th>
            <td>
                <input type="text" name="iatacode" />
            </td>
        </tr>
        <tr>
            <th>
                Airfield Name</th>
            <td>
                <input type="text" name="airfieldname" class="required" />
            </td>
        </tr>
        <tr>
            <th>
                City</th>
            <td>
                <input type="text" name="city" />
            </td>
        </tr>
        <tr>
            <th>
                State</th>
            <td>
                <input type="text" name="state" />
            </td>
        </tr>
        <tr>
            <th>
                Country</th>
            <td>
                <select name="country">
                    <%  foreach (Country c in OperatorDAO.GetCountries())
                        {
                    %>
                    <option value="<%= c.CountryID %>">
                        <%= c.FullName%>
                    </option>
                    <%
               
                        } %>
                </select>
            </td>
        </tr>
        <tr>
            <th>
                Lattitude</th>
            <td>
                <input type="text" name="lattitudedegrees" style="width:40px" class="required number" /><sup>o</sup><input type="text" name="lattitudemins" style="width:40px" class="required number" /><sup>'</sup><select
                    name="lattitudens" style="width:40px"><option>N</option>
                    <option>S</option>
                </select>
            </td>
        </tr>
        <tr>
            <th>
                Longitude</th>
            <td>
                <input type="text" style="width:40px" name="longitudedegrees" class="required number" /><sup>o</sup><input type="text" name="longitudemins" style="width:40px" class="required number" /><sup>'</sup><select
                    name="longitudeew" style="width:40px"><option>E</option>
                    <option>W</option>
                </select>
            </td>
        </tr>
        <tr>
            <th>
                Runway</th>
            <td>
                <input type="text" name="runway" class="number" />
            </td>
        </tr>
        <tr>
            <th>
                Altitude</th>
            <td>
                <input type="text" name="altitude" class="number" />
            </td>
        </tr>
        <tr>
            <th>
                Alternative names<br />
                (comma seperated)</th>
            <td>
                <input type="text" name="alternatenames" />
                <input type="hidden" name="addairfieldsubmit" />
            </td>
        </tr>
        <tr>
            <td colspan="2">
                <input type="submit" name="addairfieldbtn" class="buttons" value="Add" />
                <div id="Status"></div>
            </td>
        </tr>
    </table>
    </form>
  
</asp:Content>
