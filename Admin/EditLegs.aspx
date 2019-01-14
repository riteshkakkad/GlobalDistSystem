<%@ Page Language="C#" AutoEventWireup="true" CodeFile="EditLegs.aspx.cs" Inherits="Admin_EditLegs" %>

<%@ Import Namespace="Entities" %>
<%@ Import Namespace="DataAccessLayer" %>
<%@ Import Namespace="BusinessLayer" %>
<%@ Import Namespace="System.Collections" %>
<%@ Import Namespace="System.Collections.Generic" %>
<%@ Import Namespace="Iesi.Collections" %>
<%@ Import Namespace="NHibernate" %>
<% 
    BookRequest b = BookRequestDAO.FindBookRequestByID(Int64.Parse(Request.Params.Get("bookid"))); %>
<% String triptype = b.TripType.ToLower();
   String triptypeprop = b.TripType.Trim(); %>
<form action="#" id="editlegform">
    <input type='hidden' name="bookid" value="<%= b.BookID %>" />
    <table class="bluetable" style="margin: 10px">
        <tr>
            <th style="width: 150px;">
                Trip Type
            </th>
            <td style="padding-left: 20px;">
                <input type="hidden" name="nooflegs" id="nooflegs" value="<%= b.Legs.Count %>" />
                <input id="oneway" name="TripType" value="OneWay" <%=(triptype=="oneway")? "checked":"" %>
                    type="radio" /><label for="oneway">One Way</label>
                <input id="roundtrip" name="TripType" value="RoundTrip" type="radio" <%=(triptype=="roundtrip")? "checked":"" %> /><label
                    for="roundtrip">Round Trip</label>
                <input id="multileg" name="TripType" value="MultiLeg" <%=(triptype=="multileg")? "checked":"" %>
                    type="radio" /><label for="multileg">Multi Leg</label>
            </td>
        </tr>
    </table>
    <div id="charterlegs">
        <% Boolean lastleg = false;
           foreach (Leg l in b.Legs)
           {
               if (l.Equals(b.GetEndingLeg()))
                   lastleg = true; 
        %>
        <div class="leg">
            <table class="bluetable" style="margin-top: 10px">
                <tr>
                    <th colspan="2">
                        <div class="leghead">
                            Leg
                            <%=l.Sequence %>
                        </div>
                    </th>
                </tr>
                <tr>
                    <td>
                        <div class="boldtext">
                            From
                        </div>
                        <div>
                            <input type="text" autocomplete="off" class="ac_input fromplace" name="fromleg<%=l.Sequence %>"
                                value="<%= l.Source.GetAirfieldString()%>" <%= (lastleg && triptype=="roundtrip")?"readonly":"" %> />
                            <div class="options" style="display: none">
                            </div>
                        </div>
                    </td>
                    <td>
                        <div class="boldtext">
                            To
                        </div>
                        <div>
                            <input type="text" autocomplete="off" class="ac_input toplace" name="toleg<%=l.Sequence %>"
                                value="<%= l.Destination.GetAirfieldString()%>" <%= (lastleg && triptype=="roundtrip")?"readonly":"" %> />
                            <div class="options" style="display: none">
                                <div style='background: #f8f8f8; padding: 3px; font-weight: bold; border: 1px solid #c0c0c0;
                                    border-collapse: collapse; color: #e7710b'>
                                    Search Results</div>
                            </div>
                        </div>
                    </td>
                </tr>
                <tr>
                    <td>
                        <div class="boldtext">
                            Date
                        </div>
                        <div class="datepickdiv">
                            <input type="text" name="dateleg<%=l.Sequence %>" onfocus="this.blur()" class="date-picker required"
                                value="<%= l.Date.ToShortDateString()%>" />
                            <div class="clear">
                            </div>
                        </div>
                    </td>
                    <td>
                        <div class="boldtext">
                            Time
                        </div>
                        <div class="timepickdiv">
                            <input type="text" id="timeleg<%=l.Sequence %>" name="timeleg<%=l.Sequence %>" id="timeleg<%=l.Sequence %>"
                                class="timepicker" value="<%= l.Date.ToString("hh:mm tt")%>" />
                        </div>
                    </td>
                </tr>
            </table>
        </div>
        <% }
           int nooflegs = b.Legs.Count;
        %>
    </div>
    <div style="margin: 0px; padding-left: 10px; padding-top: 10px">
        <a href="#" class="addleg small-link" style="margin-right: 10px">Add Leg</a> <a href="#"
            class="removeleg small-link" style="margin-right: 10px">Remove Leg</a>
    </div>
    <div class="divrow">
        <input type="button" name="quotebtn" id="quotebtn" class="submitbtn buttons" style="margin-right: 20px;
            width: 150px;" value="Save Request" />
        <span class="status" style="padding-left:20px;"></span>    
    </div>
</form>

<script type="text/javascript">
 var triptype="<%= triptypeprop %>";
 var nooflegs="<%= nooflegs %>";
 var adddatepickhandler=function(context)
 {
     if(context)
     {
     
     }
     else
     {
      context="#editlegform";
     }
     $(context).find('.date-picker').datePicker({displayClose:true});
	 $(context).find(".timepicker").timepicker();
 }
var addhandlers=function(){
     
   
	  $(".ac_input").autocomplete("../ReturnAirfields.ashx", {
        minChars: 3,
        width: 260,
        selectFirst: true
             
     });
     $(".toplace.ac_input").result(function(event, data, formatted){
       
       if($(this).parents("div.leg:eq(0)").next())
          $(this).parents("div.leg:eq(0)").next("div.leg:eq(0)").find("input.fromplace").attr({'value':data[0]});
       
     });
     $(".fromplace.ac_input").result(function(event, data, formatted){
      var cvalue=$("input[@name=TripType]:checked").val();
      if(cvalue=="RoundTrip")
      {
       if($(this).parents("div.leg:eq(0)").next())
          $(this).parents("div.leg:eq(0)").next("div.leg:eq(0)").find("input.toplace").attr({'value':data[0]});
       }
     });
     $("div.alternatefields,div.selectedfield").find("input[type=radio]").click(function(){
     
       var id= $(this).attr('name').replace("radio","");
       $("input[@name="+id+"]").val($(this).val());
        $("input[@name="+id+"]").blur();
        
     
     });
     $(".toplace").blur(function(){
        if($(this).parents("div.leg:eq(0)").next())
         $(this).parents("div.leg:eq(0)").next("div.leg:eq(0)").find("input.fromplace").val($(this).val());
     
     });
    $(".fromplace").blur(function(){
      var cvalue=$("input[@name=TripType]:checked").val();
      if(cvalue=="RoundTrip")
      {
        if($(this).parents("div.leg:eq(0)").next())
         $(this).parents("div.leg:eq(0)").next("div.leg:eq(0)").find("input.toplace").val($(this).val());
      }
     });

}
 var checkaddremovelinks= function()
    { 
     var cvalue=$("input[@name=TripType]:checked").val();
     if(cvalue=="OneWay" ||cvalue=="RoundTrip")
     {
      $(".removeleg").hide();
      $(".addleg").hide();
     }
     else if(cvalue=="MultiLeg")
     {
      if(nooflegs==2)
      {
      $(".removeleg").hide();
      $(".addleg").show();
      }else
      {
       $(".removeleg").show();
      $(".addleg").show();
      }
     }
     
    }
var validate=function(){
    $(".error").remove();
    var valid=true;
    $('.fromplace,.toplace').each(function(index){
      if($(this).val()=="")
      {
       $("<div class='error'></div>").text("* Field Required.").insertAfter($(this));
       valid=false;
       }
      else if($(this).val().length<3)
      {
         $("<div class='error'></div>").text("* Atleast 3 Characters.").insertAfter($(this));
         valid=false;
      }
      
    
    });
    $('.date-picker').each(function(index){
      if($(this).val()=="")
      {
       $("<div class='error'></div>").text("* Field Required.").insertAfter($(this).siblings(".clear"));
       valid=false;
       }
    });
    return valid;
    }
addhandlers();
adddatepickhandler();
checkaddremovelinks();
   $(".addleg").click(function(){
      $(".error").remove();
      nooflegs++;
      $("#nooflegs").attr({'value':nooflegs});
      var newleg=$("#charterlegs div.leg:last-child").clone();
      newleg.find("input.fromplace,input.toplace").attr({'value':''});
      newleg.find("div.datepickdiv,div.timepickdiv").html("");
      newleg.find("div.options").hide();
      newleg.find("div.selectedfield").remove();
      newleg.find("div.alternatefields").remove();
      $("#charterlegs").append(newleg);
      newleg.find("div.leghead").html("Leg "+nooflegs);
      newleg.find("input.fromplace").attr({'name':'fromleg'+nooflegs});
      newleg.find("input.fromplace").attr({'value':$(newleg).prev().find("input.toplace").val()});
      newleg.find("input.toplace").attr({'name':'toleg'+nooflegs});
      newleg.find("div.datepickdiv").html("<input type='text' class='date-picker required' name='dateleg"+nooflegs+"' onfocus='this.blur()' /><div class='clear'></div>");
      newleg.find("div.timepickdiv").html("<input type='text' class='timepicker' id='timeleg"+nooflegs+"' name='timeleg"+nooflegs+"' />");
      
      addhandlers();
      adddatepickhandler(newleg)
      checkaddremovelinks();
      return false;
     });
    $(".removeleg").click(function(){
        nooflegs--;
        $("#nooflegs").attr({'value':nooflegs});
        $("#charterlegs div.leg:last-child").remove();
        checkaddremovelinks();
        return false;
    });
    
    $("#editlegform input[type=radio]").click(function(){    

    switch($(this).val())
    {
     case "OneWay" : nooflegs=1;
                     triptype="OneWay";
                     $("#nooflegs").attr({'value':1});
                     $("#charterlegs div.leg:not(:first)").remove();
                     checkaddremovelinks();
                     break;
     case "RoundTrip" :if(triptype!="RoundTrip"){
                            nooflegs=1;
                            $("#nooflegs").attr({'value':1});
                            $("#charterlegs div.leg:not(:first)").remove();
                            $(".addleg").click();
                            $("#charterlegs div.leg:last-child").find("input.fromplace,input.toplace").attr("readonly",true);
                            var firstleg= $("#charterlegs div.leg:first-child");
                            $("#charterlegs div.leg:last-child").find("input.fromplace").val(firstleg.find("input.toplace").val()); 
                            $("#charterlegs div.leg:last-child").find("input.toplace").val(firstleg.find("input.fromplace").val());                          
                            
                        }
                        triptype="RoundTrip";
                        checkaddremovelinks();
                        break;
     case "MultiLeg" :  if(triptype!="MultiLeg"){
                        if(nooflegs!=2)
                        {
                        nooflegs=1;
                        $("#nooflegs").attr({'value':1});
                        $(".addleg").click();
                        }
                        else
                        {
                         $("#charterlegs div.leg:last-child").find("input.fromplace,input.toplace").removeAttr("readonly");
                        }
                        checkaddremovelinks();
                        }
                        triptype="MultiLeg";
                        break;
     default :$("#nooflegs").attr({'value':1});break;
    }
    
    
    });
  
   $(".submitbtn").click(function(){
   
     if(validate())
     {
      //alert("hi");
       $.ajax({
            'url': 'UpdateBookRequests.ashx',
            'data':$("#editlegform").serialize()+"&updaterequestlegs=1",
            'dataType': 'json',
            'type': 'POST',
            'beforeSend':function(){
            
              $("#editlegform .status").html("<img src='../images/loadingAnimation.gif' />");
              
            },
            'success': function(data) {
             
               var scrollbool=true;
               $("input[name^=fromleg],input[name^=toleg]").siblings("div.options").empty();
               $("div.options").hide();
               if(data['error'])
               {
                $("#editlegform .status").html(data['error']);
                return;
               }
               if(data['selecterror'])
               {
                $("#editlegform .status").html(data['selecterror']);
                var rnooflegs=data['nooflegs'];
              
                if(data['afromleg1'].length>0)
                {                    
                    var alternatefromfields="";
                    $.each(data['afromleg1'],function(li,l){
                   
                        alternatefromfields+="<div style='margin-bottom:5px;width:inherit' ><table style='width:inherit' class='noborder'><tr><td><input type='radio' name='radiofromleg1' value='"+GetAirfieldString(l)+"' /></td><td><label>"+GetAirfieldString(l)+"</label></td></tr></table></div>";
                           
                    });
                    $("<div style='background: #f8f8f8; padding: 3px; font-weight: bold; border-bottom: 1px solid #c0c0c0;border-collapse: collapse; color: #e7710b'>Search Results</div>").appendTo($("input[@name=fromleg1]").siblings("div.options").show());
                    $("<div class='selectedfield'><table style='width:inherit' class='noborder'><tr><td><input type='radio' name='radiofromleg1' value='"+GetAirfieldString(data['fromleg1'])+"' checked /></td><td><label>"+GetAirfieldString(data['fromleg1'])+"</label></td></tr></table></div>").appendTo($("input[@name=fromleg1]").siblings("div.options").show());
                    $("<div class='alternatefields'></div>").html(alternatefromfields).appendTo($("input[@name=fromleg1]").siblings("div.options").show());
                    
                      addhandlers();
                   }
               for(i=1;i<=rnooflegs;i++)
               {
                 $("input[@name=fromleg"+i+"]").val(GetAirfieldString(data['fromleg'+i]));
                 
                 $("input[@name=toleg"+i+"]").val(GetAirfieldString(data['toleg'+i]));
                                 
                   
                   if(data['atoleg'+i].length>0)
                   {
                     var alternatetofields="";
                    $.each(data['atoleg'+i],function(li,l){
                    
                     alternatetofields+="<div style='margin-bottom:5px;width:inherit'><table style='width:inherit' class='noborder'><tr><td><input type='radio' name='radiotoleg"+i+"' value='"+GetAirfieldString(l)+"' /></td><td><label>"+GetAirfieldString(l)+"</label></td></tr></table></div>";
                    
                    });
                    $("<div style='background: #f8f8f8; padding: 3px; font-weight: bold; border-bottom: 1px solid #c0c0c0;border-collapse: collapse; color: #e7710b'>Search Results</div>").appendTo($("input[@name=toleg"+i+"]").siblings("div.options").show());
                    $("<div class='selectedfield'><table class='noborder' style='width:inherit'><tr><td><input type='radio' name='radiotoleg"+i+"' value='"+GetAirfieldString(data['toleg'+i])+"' checked /></td><td><label>"+GetAirfieldString(data['toleg'+i])+"</label></td></tr></table></div>").appendTo($("input[@name=toleg"+i+"]").siblings("div.options").show());
                    $("<div class='alternatefields'></div>").html(alternatetofields).appendTo($("input[@name=toleg"+i+"]").siblings("div.options").show());
                      addhandlers();
                   }
                 
               }
               var cvalue=$("input[@name=TripType]:checked").val();
               if(cvalue=="RoundTrip")
               {
                $("input[@name=toleg2]").siblings("div.options").hide();
               }
               if($(".alternatefields").children().size()>0)
               {
                 scrollbool=false;
                 scrollToThickbox($(".options:eq(0)").parents("td:eq(0)"));
               }
               
            }
            else
            {
             $("#editlegform .status").html(data['text']);
             setTimeout("location.reload()",1000)
            }
            
            }
            
            });
      
     }
   
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
</script>

