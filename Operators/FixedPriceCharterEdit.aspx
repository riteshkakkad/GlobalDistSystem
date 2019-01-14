<%@ Page Language="C#" MasterPageFile="~/Operators/OperatorMaster.master" AutoEventWireup="true" CodeFile="FixedPriceCharterEdit.aspx.cs" Inherits="Operators_FixedPriceCharterEdit" Title="Untitled Page" %>
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
	
	
	$(".ac_input").autocomplete("../ReturnAirfields.ashx", {
        minChars: 3,
        width: 260,
        selectFirst: true
             
     });
     
     $("#addfixedpricecharterform").submit(function(){
           $("input[name=source],input[name=destination]").siblings("div.options").empty();
           var serverparam="";
            if($("input[name=fid]").val()=="")
              serverparam="addfixedpricecharter";
             else
               serverparam="editfixedpricecharter";
            
           if(validate())
           { 
            
             $.ajax({
            'url': 'UpdateFixedPriceCharters.ashx',
            'data': $("#addfixedpricecharterform").serialize()+"&"+serverparam+"=1",
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
                if(serverparam=="addfixedpricecharter")
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
        FixedPriceCharter fp = null;
        Operator op = OperatorBO.GetLoggedinOperator();
        if (Request.Params.Get("fid") != null)
        {
            fp = BookRequestDAO.FindFixedPriceCharterByID(Int64.Parse(Request.Params.Get("fid")));
           
        }
        
    
    %>
    <form id="addfixedpricecharterform">
        <table class="bluetable" style="width: 700px; margin-left: auto; margin-right: auto;
            margin-top: 50px">
            <tr>
                <th colspan="2" style="color: #e7710b;">
                    Fixed Price Charter
                </th>
            </tr>
            
            <tr>
                <th>
                    Aircraft
                </th>
                <td>
                <input name="fid" type="hidden" value="<%= Request.Params.Get("fid")%>" />
                    <select name="aircraftlist">
                        <%
                            Boolean temp = false;
                            foreach (Airplane a in op.Aircrafts)
                            {
                                if (fp != null)
                                {
                                    temp = fp.Aircraft.Equals(a);
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
                        value="<%= (fp!=null)? fp.Source.GetAirfieldString():""  %>" />
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
                        value="<%= (fp!=null)? fp.Destination.GetAirfieldString():""  %>" />
                    <div class="options" style="display: none">
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
                                if (fp != null)
                                    temp = fp.Currency.Equals(c);
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
                    Quote
                </th>
                <td>
                    <input name="quote" type="text" class="required number" value="<%= (fp!=null)? fp.Quote.ToString():""  %>" />
                </td>
            </tr>
            <tr>
                <th>
                    Quote Expires On
                </th>
                <td>
                    <div style="margin-bottom: 10px">
                        <input type="text" id="expiredate" name="expiredate" onfocus="this.blur()" class="date-picker required"
                            value="<%= (fp!=null)? fp.ExpiresOn.ToString("MM/dd/yyyy") :""  %>" />
                        <div class="clear">
                        </div>
                    </div>
                </td>
            </tr>
          
            <tr>
                <th colspan="2">
                    <input type="submit" name="addfixedpricecharterbtn" class="buttons" value="Save" />
                    <span id="Status" style="padding-left: 20px"></span>
                    <div style="margin-top: 20px">
                        <a href="FixedPriceCharters.aspx">Show Fixed Price Charters</a></div>
                </th>
            </tr>
        </table>
    </form>
</asp:Content>

