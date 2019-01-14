<%@ Page Language="C#" MasterPageFile="~/Operators/OperatorMaster.master" AutoEventWireup="true"
    CodeFile="EmptyLegEdit.aspx.cs" Inherits="Operators_EmptyLegEdit" Title="Untitled Page" %>

<%@ Import Namespace="Entities" %>
<%@ Import Namespace="DataAccessLayer" %>
<%@ Import Namespace="BusinessLayer" %>
<%@ Import Namespace="System.Collections" %>
<%@ Import Namespace="System.Collections.Generic" %>
<%@ Import Namespace="Iesi.Collections" %>
<%@ Import Namespace="NHibernate" %>
<asp:Content ID="Content1" ContentPlaceHolderID="scriptholder" runat="Server">
    <style type="text/css">
a.dp-choose-date {
	float: left;
	width: 16px;
	height: 16px;
	padding: 0;
	margin: 5px 3px 0;
	display: block;
	text-indent: -2000px;
	overflow: hidden;
	background: url(../images/calendar.png) no-repeat; 
	}
a.dp-choose-date.dp-disabled {
	background-position: 0 -20px;
	cursor: default;
}
/* makes the input field shorter once the date picker code
 * has run (to allow space for the calendar icon
 */
input.dp-applied {
	
	float: left;
}
.alternatefields
        {
         width:300px;
         margin-left:5px;
         
        }
.options
        {
         overflow:auto;
         height:100px;
         width:320px;
         border:1px solid #c0c0c0;
         padding:0px;
         margin-top:10px;
         
        }
        .options td
        {
         border-bottom-style:none;
         border-right-style:none;
         padding:0px;
        }
input.readonly {background-color: white;}
</style>

    <script type="text/javascript">
$(document).ready(function(){
 Date.format = 'mm/dd/yyyy';

$(".timepicker").timepicker();
$('.date-picker').datePicker()
	$('#datefrom').bind(
		'dpClosed',
		function(e, selectedDates)
		{
			var d = selectedDates[0];
			if (d) {
				d = new Date(d);
				$('#dateto').dpSetStartDate(d.asString());
			}
		}
	);
	$('#dateto').bind(
		'dpClosed',
		function(e, selectedDates)
		{
			var d = selectedDates[0];
			if (d) {
				d = new Date(d);
				$('#datefrom').dpSetEndDate(d.asString());
			}
		}
	);
	$(".ac_input").autocomplete("../ReturnAirfields.ashx", {
        minChars: 3,
        width: 260,
        selectFirst: true
             
     });
     
     $("#addemptylegform").submit(function(){
           $("input[name=source],input[name=destination]").siblings("div.options").empty();
           var serverparam="";
            if($("input[name=eid]").val()=="")
              serverparam="addemptyleg";
             else
               serverparam="editemptyleg";
            
           if(validate())
           { 
            if(comparetime())
            {
             $.ajax({
            'url': 'UpdateEmptyLegs.ashx',
            'data': $("#addemptylegform").serialize()+"&"+serverparam+"=1",
            'dataType': 'json',
            'type': 'POST',
            'beforeSend':function(){
            
              $("#Status").html("<img src='../images/loadingAnimation.gif' />");
              
            },
            'success': function(data) {
                              
               //console.log(data);
               if(data["saved"])
               {
                $("#Status").html("Saved");
                $("div.options").hide();
                if(serverparam=="addemptyleg")
                    $("input[type=text]").val("");
               }
               else
               {
                    if(data["error"])
                    {
                        $("#Status").html("Check your inputs.");
                    }
                    else if(data["airfielderror"])
                    {
                     $("#Status").html("Airfields not found.");
                     
                    }
                    else
                    {
                        $("#Status").html("Please select airfields.");
                        var temp="";
                        if(data["sourcelist"].length > 0)
                        {                  
                            $.each(data["sourcelist"],function(li,l){
                              temp+="<div style='margin-bottom:5px;width:inherit'><table style='width:inherit' class='noborder'><tr><td><input type='radio' name='radiosource' value='"+GetAirfieldString(l)+"' /></td><td><label>"+GetAirfieldString(l)+"</label></td></tr></table></div>";
                             });
                            $("<div style='background: #f8f8f8; padding: 3px; font-weight: bold; border-bottom: 1px solid #c0c0c0;border-collapse: collapse; color: #e7710b'>Search Results</div>").appendTo($("input[name=source]").siblings("div.options").show());
                            $("<div class='alternatefields'></div>").html(temp).appendTo($("input[name=source]").siblings("div.options").show());
                        }
                        
                        temp="";
                        if(data["destinationlist"].length > 0)
                        {                  
                            $.each(data["destinationlist"],function(li,l){
                                 temp+="<div style='margin-bottom:5px;width:inherit'><table style='width:inherit' class='noborder'><tr><td><input type='radio' name='radiodestination' value='"+GetAirfieldString(l)+"' /></td><td><label>"+GetAirfieldString(l)+"</label></td></tr></table></div>";
                            });
                            $("<div style='background: #f8f8f8; padding: 3px; font-weight: bold; border-bottom: 1px solid #c0c0c0;border-collapse: collapse; color: #e7710b'>Search Results</div>").appendTo($("input[name=destination]").siblings("div.options").show());
                            $("<div class='alternatefields'></div>").html(temp).appendTo($("input[name=destination]").siblings("div.options").show());
                        }
                        
                        
                        $("div.alternatefields").find("input[type=radio]").click(function(){
                            var id= $(this).attr('name').replace("radio","");
                            $("input[name="+id+"]").val($(this).val());
                            
                         });
                    }
                }
            
              }
            });
             
            }
            else
            {
              alert("Check Time"); 
              
            } 
           }   
            return false;
     
     });
     

});
var GetAirfieldString=function(a)
        {
            var resp = "";
           
            if (a.AirfieldName != null && a.AirfieldName != "")
                resp += jQuery.trim(a.AirfieldName) + ", ";
            if (a.City != null && a.City != "")
                resp += jQuery.trim(a.City) + ", ";
            if (a.State != null && a.State != "")
                resp += jQuery.trim(a.State) + ", ";
            if (a.Country != null && a.Country != "")
                resp += jQuery.trim(a.Country);

            resp += " (" + a.ICAOCODE + ")";

            return resp;
        }
var comparetime= function(){

if(($("input.datefrom").val() == $("input.dateto").val()) && $("input.datefrom").val() != "")
{
 var date1= new Date($("input[name=datefrom]").val() +" " + $("input[name=timefrom]").val());
 var date2=new Date($("input[name=dateto]").val() +" " + $("input[name=timeto]").val());
 if((date2-date1) < 0)
   return false;
 else
   return true;  
}
else
{
 return true;
}

}
var validate=function(){
 
    var valid=true;
    $(".required,.number").removeClass("error");
    $("div.errortext").remove();
    $(".required").each(function(i){
    
     if($(this).val()=="")
      {
       valid=false;
       if($(this).parents("td:eq(0)").find("div.errortext").size()==0)
         $(this).parents("td:eq(0)").append($("<div class='errortext'>* Required.</div>"));
       
       $(this).addClass('error');
      }
    
    });
    $(".number").each(function(){
    
     if($(this).val()!="" && isNaN($(this).val()))
      {
        
         valid=false;
          if($(this).parents("td:eq(0)").find("div.errortext:contains('Number')").size()==0)
                $(this).parents("td:eq(0)").append($("<div class='errortext'>* Number Required.</div>"));
         
         $(this).addClass('error');
       }
    
    });
       
   return valid;
 
 }
    </script>

</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="contentholder" runat="Server">
    <% 
        EmptyLeg el = null;
        Operator op = OperatorBO.GetLoggedinOperator();
        if (Request.Params.Get("eid") != null)
        {
            el = BookRequestDAO.FindEmptyLegByID(Int64.Parse(Request.Params.Get("eid")));

        }        
    
    %>
    <form id="addemptylegform">
        <table class="bluetable" style="width: 700px; margin-left: auto; margin-right: auto">
            <tr>
                <th colspan="2" style="color: #e7710b;">
                    Empty Leg
                </th>
            </tr>
            <tr>
                <th>
                    Aircraft
                </th>
                <td>
                    <input name="eid" type="hidden" value="<%= Request.Params.Get("eid")%>" />
                    <select name="aircraftlist">
                        <%
                            Boolean temp = false;
                            foreach (Airplane a in op.Aircrafts)
                            {
                                if (el != null)
                                {
                                    temp = el.Aircraft.Equals(a);
                                }
                        %>
                        <option value="<%= a.AircraftId %>" <%= (temp) ? "selected" :"" %>>
                            <%= a.AircraftName +"("+a.AircraftLocation+")" %>
                        </option>
                        <%
                            }  %>
                    </select>
                </td>
            </tr>
            <tr>
                <th>
                    Source
                </th>
                <td>
                    <input type="text" autocomplete="off" style="width: 240px" name="source" class="ac_input required"
                        value="<%= (el!=null)? el.Source.GetAirfieldString():""  %>" />
                    <div class="options" style="display: none">
                    </div>
                </td>
            </tr>
            <tr>
                <th>
                    Destination
                </th>
                <td>
                    <input type="text" autocomplete="off" style="width: 240px" name="destination" class="ac_input required"
                        value="<%= (el!=null)? el.Destination.GetAirfieldString():""  %>" />
                    <div class="options" style="display: none">
                    </div>
                </td>
            </tr>
            <tr>
                <th>
                    Departure Time Range
                </th>
                <td>
                    <div style="margin-bottom: 10px">
                        <div style="float: left; margin-right: 15px;">
                            <input type="text" id="datefrom" name="datefrom" onfocus="this.blur()" class="date-picker required"
                                value="<%= (el!=null)? el.DepartureFromDate.ToString("MM/dd/yyyy") :""  %>" />
                        </div>
                        <div style="float: left">
                            <input type="text" id="timefrom" name="timefrom" class="timepicker" value="<%= (el!=null)? el.DepartureFromDate.ToString("hh:mm tt") :""  %>" />
                        </div>
                        <div class="clear">
                        </div>
                    </div>
                    <div style="margin-bottom: 10px;" class="boldtext">
                        To
                    </div>
                    <div>
                        <div style="float: left; margin-right: 15px;">
                            <input type="text" id="dateto" name="dateto" onfocus="this.blur()" class="date-picker required"
                                value="<%= (el!=null)? el.DepartureToDate.ToString("MM/dd/yyyy") :""  %>" />
                        </div>
                        <div style="float: left">
                            <input type="text" id="timeto" name="timeto" class="timepicker" value="<%= (el!=null)? el.DepartureToDate.ToString("hh:mm tt") :""  %>" />
                        </div>
                        <div class="clear">
                        </div>
                    </div>
                </td>
            </tr>
            <tr>
                <th>
                    Currency
                </th>
                <td>
                    <select name="currency">
                        <%  
                            temp = false;
                            foreach (Currency c in AdminDAO.GetCurrencies())
                            {
                                if (el != null)
                                    temp = el.Currency.Equals(c);
                        %>
                        <option value="<%= c.ID %>" <%= (temp)?"selected":"" %>>
                            <%= c.FullName +"("+ c.ID+")"%>
                        </option>
                        <%
               
                            } %>
                    </select>
                </td>
            </tr>
            <tr>
                <th>
                    Actual Price
                </th>
                <td>
                    <input name="actualprice" type="text" class="required number" value="<%= (el!=null)? el.ActualPrice.ToString():""  %>" />
                </td>
            </tr>
            <tr>
                <th>
                    Offer Price
                </th>
                <td>
                    <input name="offerprice" type="text" class="required" class="required number" value="<%= (el!=null)? el.OfferPrice.ToString() :""  %>" />
                </td>
            </tr>
            <tr>
                <th colspan="2">
                    <input type="submit" name="addemptylegbtn" class="buttons" value="Save" />
                    <span id="Status" style="padding-left: 20px"></span>
                    <div style="margin-top: 20px">
                        <a href="ShowEmptyLegs.aspx">Show Empty Legs</a></div>
                </th>
            </tr>
        </table>
    </form>
</asp:Content>
