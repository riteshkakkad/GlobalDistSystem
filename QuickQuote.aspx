<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/CharterTemplate.master"
    CodeFile="QuickQuote.aspx.cs" Inherits="QuickQuote" %>

<%@ Import Namespace="Entities" %>
<%@ Import Namespace="DataAccessLayer" %>
<%@ Import Namespace="System.Collections" %>
<%@ Import Namespace="System.Collections.Generic" %>
<%@ Import Namespace="Iesi.Collections" %>
<%@ Import Namespace="NHibernate" %>
<%@ Import Namespace="System.Xml" %>
<asp:Content ContentPlaceHolderID="scriptholder" runat="server">
    <style type="text/css">
        .ac_input
        {
        width:220px;
        padding:2px 5px;
        font-size:11px;
        font-family:verdana;
        }
        select
        {
          padding:2px 5px;
          font-size:11px;
          
        }
        select option
        { 
         padding:0px 5px;
        }
        .thumbimages
        {
         border: 1px solid #707070;
         cursor:pointer;
         
        }
        
        .selectedfield,.alternatefields
        {
         width:210px;
         margin-left:5px;
         
        }
        
        .selectedfield
        {
         margin:10px 0px 5px 5px;
        }
       
        .cell
        {
         width:150px;
         
        }
        .divrow
        {
         padding:0px 10px 10px 10px;
         margin-top:15px;
         
        }
        .divrow label
        {
         padding-left:5px;
         
        }
        .quoteerror
        {
         font-size:14px;
         color:#e7710b;
         font-weight:bold;
        }
        .quoteproper
        {
         font-size:16px;
         font-weight:bold;
         color:#707070;
        }
        .options
        {
         overflow:auto;
         height:150px;
         width:230px;
         border:1px solid #c0c0c0;
         padding:0px;
         margin-top:10px;
         
        }
        .options td
        {
         border-bottom-style:none ;
         border-right-style:none;
         padding:0px;
        }
        .fainttext
        {
         color:#c0c0c0;
         font-size:10px;
        }
  </style>

    <script type="text/javascript">
    var nooflegs=1;
    var triptype="OneWay";
     //var BTB_GM_MAP;
     var mapinput;
 //var geocoder = new GClientGeocoder();
 //var latlngbounds = new GLatLngBounds();
    $(document).ready(function(){
     checkaddremovelinks();
     addeventhandlers();
     $("input.ac_input").blank('start typing city, icao, iata');
     $("#aircrafttype").change();   
     
     $(".addleg").click(function(){
      $(".error").remove();
      nooflegs++;
      $("#nooflegs").attr({'value':nooflegs});
      var newleg=$("#charterlegs div.leg:last-child").clone();
      newleg.find("input.fromplace,input.toplace").val("");
      newleg.find("input.fromplace,input.toplace").css("color","#707070");
      newleg.find("div.options").hide();
      newleg.find("div.selectedfield").remove();
      newleg.find("div.alternatefields").remove();
      $("#charterlegs").append(newleg);
      newleg.find("div.leghead").html("Leg "+nooflegs);
      newleg.find("input.fromplace").attr({'name':'fromleg'+nooflegs});
      newleg.find("input.toplace").attr({'name':'toleg'+nooflegs});
      newleg.find("input.toplace,input.fromplace").blank('start typing city, icao, iata');
      if(!$(newleg).prev().find("input.toplace").blank())
            $(newleg).prev().find("input.toplace").blur();
      addeventhandlers();
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
    
    $("input[type=radio]").click(function(){
    
    
    switch($(this).attr('value'))
    {
     case "OneWay" : nooflegs=1;
                     triptype="OneWay";
                     $("#nooflegs").attr({'value':1});
                     $("#charterlegs div.leg:not(:first)").remove();
                     checkaddremovelinks();
                     break;
     case "RoundTrip" : nooflegs=2;
                        triptype="RoundTrip";
                        $("#nooflegs").attr({'value':2});
                        $("#charterlegs div.leg:not(:first)").remove();
                        checkaddremovelinks();
                        break;
     case "MultiLeg" :  if(triptype!="MultiLeg"){
                        nooflegs=1;
                        $(".addleg").click();
                        checkaddremovelinks();
                        }
                        triptype="MultiLeg";
                        break;
     default :$("#nooflegs").attr({'value':1});break;
    }
    
    
    });
    
    $(".submitbtn").click(function(){
    if(!validate())
      return false;
    
    var clickedbtn=$(this);
    
    var querystring=$("#legform").serialize();
    
    
    if($("input[@name=TripType]:checked").val()=="RoundTrip")
    {
      querystring+="&fromleg2="+escape($("input[name=toleg1]").val())+"&toleg2="+escape($("input[name=fromleg1]").val());
    }
     
     $.ajax({
            'url': 'FindQuickQuote.ashx',
            'data': querystring,
            'dataType': 'json',
            'type': 'POST',
            'beforeSend':function(){
            
              $("#quickquote").html("<img src='images/loadingAnimation.gif' />");
              
            },
            'success': function(data) {
               var scrollbool=true;
              
               $("input[name^=fromleg],input[name^=toleg]").siblings("div.options").empty();
               $("div.options").hide();
               if(data['error'])
                {
                 $("#quickquote").html(data['error']).removeClass('quoteproper').addClass('quoteerror');
                 
                 return;
                }
               var rnooflegs=data['nooflegs'];
              
               if(data['afromleg1'].length>0)
                   {
                    
                    var alternatefromfields="";
                   
                 
                    $.each(data['afromleg1'],function(li,l){
                    
                      alternatefromfields+="<div style='margin-bottom:5px;'><table><tr><td><input type='radio' name='radiofromleg1' value='"+l+"' /></td><td><label>"+l+"</label></td></tr></table></div>";
                    
                    
                    });
                    $("<div style='background: #f8f8f8; padding: 3px; font-weight: bold; border-bottom: 1px solid #c0c0c0;border-collapse: collapse; color: #e7710b'>Search Results</div>").appendTo($("input[@name=fromleg1]").siblings("div.options").show());
                    $("<div class='selectedfield'><table><tr><td><input type='radio' name='radiofromleg1' value='"+data['fromleg1']+"' checked /></td><td><label>"+data['fromleg1']+"</label></td></tr></table></div>").appendTo($("input[@name=fromleg1]").siblings("div.options").show());
                 
                    $("<div class='alternatefields'></div>").html(alternatefromfields).appendTo($("input[@name=fromleg1]").siblings("div.options").show());
                    
                      addeventhandlers();
                   }
               for(i=1;i<=rnooflegs;i++)
               {
                 $("input[@name=fromleg"+i+"]").val(data['fromleg'+i]);
                 
                 $("input[@name=toleg"+i+"]").val(data['toleg'+i]);
                                 
                   
                   if(data['atoleg'+i].length>0)
                   {
                     var alternatetofields="";
                    $.each(data['atoleg'+i],function(li,l){
                    
                     alternatetofields+="<div style='margin-bottom:5px;'><table><tr><td><input type='radio' name='radiotoleg"+i+"' value='"+l+"' /></td><td><label>"+l+"</label></td></tr></table></div>";
                    
                    });
                    $("<div style='background: #f8f8f8; padding: 3px; font-weight: bold; border-bottom: 1px solid #c0c0c0;border-collapse: collapse; color: #e7710b'>Search Results</div>").appendTo($("input[@name=toleg"+i+"]").siblings("div.options").show());
                    $("<div class='selectedfield'><table><tr><td><input type='radio' name='radiotoleg"+i+"' value='"+data['toleg'+i]+"' checked /></td><td><label>"+data['toleg'+i]+"</label></td></tr></table></div>").appendTo($("input[@name=toleg"+i+"]").siblings("div.options").show());
                 
                    $("<div class='alternatefields'></div>").html(alternatetofields).appendTo($("input[@name=toleg"+i+"]").siblings("div.options").show());
                      addeventhandlers();
                   }
                 
               }
               if($(".alternatefields").children().size()>0)
               {
                 scrollbool=false;
                 scrollTo($(".options:eq(0)").parents("td:eq(0)"));
               }
                if(clickedbtn.attr('id')=="requestcharter")
                {
                 var alternate=true;
                 
              
                 if($(".alternatefields").children().size()>0)
                 {
                  $("#quickquote").html("Please select airfields from options given and request again.").removeClass('quoteproper').addClass('quoteerror');
                 }
                 else
                 {
                  $("#legform").submit();
                 }
                 
                 scrollTo("#outerquick");
                 return;
                } 
               
               $("#quickquote").html("<span style='font-size:11px;font-weight:normal;margin-right:50px;margin-left:30px'>"+$("select[name=aircrafttype] option:selected").text()+"</span>"+data['currency']+" "+data['quote']+"  <a href='ViewDetailedQuote.aspx?"+querystring+"&height=500&width=500' class='thickbox small-link' title='Detailed Quote' style='font-weight:normal;margin-left:20px;'>View Detailed Quote</a>").removeClass('quoteerror').addClass('quoteproper');
            
               var alternatequotes="<div style='margin-top:15px;font-size:11px;font-weight:normal;'>";
               alternatequotes+="<table class='bluetable' style='width:500px;'>";
               alternatequotes+="<tr><th style='color:#e7710b;text-align:center' colspan=3>Alternate quotes with different plane types</th></tr>"
               alternatequotes+="<tr><th style='text-align:center'>Plane Type</th><th style='text-align:center'>Quick Quote</th><th style='text-align:center'>Detailed Quote</th></tr>";
               $.each(data['alternatequotes'],function(li,l){
               
               if(l.aquote)
               {
               alternatequotes+="<tr>";
               var tempstr=querystring;
               tempstr= tempstr.replace(/aircrafttype=[A-Z]+&/,"aircrafttype="+l.planetypeid+"&");
               alternatequotes+="<td>"+$("#aircrafttype").find("option[value="+l.planetypeid+"]").text()+"</td>";
               alternatequotes+="<td>"+data['currency']+" "+l.aquote+"</td>";
                alternatequotes+="<td><a href='ViewDetailedQuote.aspx?"+tempstr+"&height=500&width=500' title='Detailed Quote' class='small-link thickbox'>View</a></td>";
               alternatequotes+="</tr>";
               }
               
               });
               alternatequotes+="</table>";
               alternatequotes+="</div>";
               $("#quickquote").html($("#quickquote").html()+alternatequotes);
               tb_init("a.thickbox");
               if(scrollbool)
                  scrollTo("#outerquick");
            } 
        });
     
     return false;
    
    
    });
    

 $("#mapsearch").submit(function(){
     
    $("#searchlist").remove();
    $("#othersearchresults").remove();
    
     BTB_GM_MAP.clearOverlays();
     
    $.ajax({
            'url': 'GetAirfields.ashx',
            'data': 'text='+$("#mapsearch input[name=searchtext]").val(),
            'dataType': 'json',
            'type': 'POST',
            'beforeSend':function(){
                    
              $("#status").html("<img src='images/loadingAnimation.gif' />");
              
            },
            'success': function(data) {
             
              $("#status").html("");
               if(data)
               {
                if(data.length>0)
                {
                  var resp="<table id='searchlist' class='bluetable' style='margin-top:15px;font-family:verdana;font-size:11px;width:350px'>";
                  resp+="<tr><th>Airfield</th><th>Show</th><th>Select</th></tr>";
                  $.each(data,function(li,l){
                  
                    resp+="<tr>";
                   
                    resp+="<td>"+ GetAirfieldString(l)+"</td>";
                    var lat= GetLattitudeDecimal(l);
                    var lon= GetLongitudeDecimal(l);
                    resp+="<td><a href='#' onclick='ZoomOnAirfield("+lat+","+lon+");return false;' class='small-link' style='color:#e7710b'>Show</a></td>";
                    resp+="<td><a href='#' onclick=\"updateinputsfrommaps('"+mapinput+"','"+GetAirfieldString(l)+"');return false;\" class='small-link' style='color:#e7710b'>Select</a></td>";
                    resp+="</tr>";
                    addCoordinatesToMap(l);
                  
                  });
                  resp+="</table>";
                  resp+="<div style='margin:10px;' id='othersearchresults'><a href='#' onclick='$(\"#searchlist\").remove();showLocation();return false;'>Other than search results ?</a></div>";
                  BTB_GM_MAP.setCenter(latlngbounds.getCenter(), BTB_GM_MAP.getBoundsZoomLevel(latlngbounds));
                  latlngbounds = new GLatLngBounds();
                  $(resp).insertAfter($("#mapsearch"));
                  
                }
                else
                {
                 showLocation(); 
                }
               }
               
             }
            
            });
    return false;

});

    
    });
    
    var addeventhandlers= function()
    {
     
     
     $("a.loadmap").unbind("click").click(function(){
     $("#searchlist").remove();
     $("#othersearchresults").remove();
     $("#mapsearch input[name=searchtext]").val("");
     mapinput= $(this).parents("td:eq(0)").find("input.ac_input").attr('name');
    
     var url=$(this).attr("href");
     var queryString = url.replace(/^[^\?]+\??/,'');
	 var params = tb_parseQuery( queryString );
     tb_show("Select From Map",url,null);
     var mapDiv =  $("<div style='float:left;margin-top:20px;' id='outermapdiv'><div id='googleMap'></div></div>");
     $('#TB_ajaxContent').append(mapDiv);
	 $('#TB_ajaxContent').append($("#mapsearchcontent").children());
	 
	 $('#TB_ajaxContent').css({overflow:"auto"});
		
	 $('#googleMap').css({width:350,height:350});
	 $('#TB_window').unload(function(){
	   $("#outermapdiv").remove();
	   $("#mapsearchcontent").append($("#TB_ajaxContent").children()); 
	    BTB_GM_MAP=null;	   
	   GUnload();
     });
  	  
	 loadGoogleMap(params["lat"], params["lng"], params["zoom"], params["markerText"], params);
	 
     return false;


});
     $(".ac_input").autocomplete("ReturnAirfields.ashx", {
        minChars: 3,
        width: 260,
        selectFirst: true             
     });
       $("#aircrafttype").change(function(){
        $(".thumbimages").hide();
        $("#thumb"+$(this).val()).show();
     
     });
    
     $(".toplace.ac_input").result(function(event, data, formatted){
       
       if($(this).parents("div.leg:eq(0)").next())
       {
          $(this).parents("div.leg:eq(0)").next("div.leg:eq(0)").find("input.fromplace").val(data[0]);
          $(this).parents("div.leg:eq(0)").next("div.leg:eq(0)").find("input.fromplace").blur();
       }
       
     });
     $("div.alternatefields,div.selectedfield").find("input[type=radio]").click(function(){
     
       var id= $(this).attr('name').replace("radio","");
       $("input[@name="+id+"]").val($(this).val());
        $("input[@name="+id+"]").blur();
        
     
     });
     
     $(".toplace").blur(function(){
        
        if(!$(this).blank())
        {
           $(this).parents("div.leg:eq(0)").next("div.leg:eq(0)").find("input.fromplace").val($(this).val());
           $(this).parents("div.leg:eq(0)").next("div.leg:eq(0)").find("input.fromplace").blur();
        }   
        
     });
    }
    var validate=function(){
    $(".error").remove();
    var valid=true;
    $('.fromplace,.toplace').each(function(index){
      if($(this).blank())
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
    return valid;
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
   function loadGoogleMap(lat, lon, zoom, html, params){

    if(GBrowserIsCompatible()){

	
        BTB_GM_MAP = new GMap2(document.getElementById("googleMap"));
		BTB_GM_MAP.enableScrollWheelZoom();
        BTB_GM_MAP.addControl(new GSmallMapControl());
        var point = new GLatLng(37.4419, -122.1419);
        BTB_GM_MAP.setCenter(point, 6);
        BTB_GM_MAP.clearOverlays();
        
   }
}


function GetLattitudeDecimal(a)
        {
            var thislatdegrees = (a.NS == 'S' ? -1 : 1) * (a.LattitudeDegrees + a.LattitudeMinutes / 60.0);
            return thislatdegrees;
        }
function GetLongitudeDecimal(a)
        {
            var thislongdegrees = (a.EW == 'W' ? -1 : 1) * (a.LongitudeDegrees + a.LongitudeMinutes / 60.0);
            return thislongdegrees;
        } 
function addAddressToMap(response) {
      BTB_GM_MAP.clearOverlays();
      if (!response || response.Status.code != 200) {
        alert("Sorry, we were unable to geocode that address");
      } else {
        place = response.Placemark[0];
        point = new GLatLng(place.Point.coordinates[1],
                            place.Point.coordinates[0]);
        marker = new GMarker(point);
        BTB_GM_MAP.addOverlay(marker);
        
        var winhtml="";
        if(place.AddressDetails.Country.AdministrativeArea)
        {
          if(place.AddressDetails.Country.AdministrativeArea.SubAdministrativeArea)
          {
           if(place.AddressDetails.Country.AdministrativeArea.SubAdministrativeArea.Locality)
           {
            if(place.AddressDetails.Country.AdministrativeArea.SubAdministrativeArea.Locality.DependentLocality)
             {
               winhtml+=place.AddressDetails.Country.AdministrativeArea.SubAdministrativeArea.Locality.DependentLocality.DependentLocalityName+" ";
             }
             winhtml+=place.AddressDetails.Country.AdministrativeArea.SubAdministrativeArea.Locality.LocalityName+", ";
           }
          }
          else if(place.AddressDetails.Country.AdministrativeArea.Locality)
          {
            if(place.AddressDetails.Country.AdministrativeArea.Locality.DependentLocality)
            {
               winhtml+=place.AddressDetails.Country.AdministrativeArea.Locality.DependentLocality.DependentLocalityName+" ";
            }
            winhtml+=place.AddressDetails.Country.AdministrativeArea.Locality.LocalityName+", ";
          }
           winhtml+=place.AddressDetails.Country.AdministrativeArea.AdministrativeAreaName+", ";
                 
        }
        var tempheliportstr=winhtml;
        winhtml+= place.AddressDetails.Country.CountryName;
        tempheliportstr=tempheliportstr.replace(",","");
        tempheliportstr+=place.AddressDetails.Country.CountryNameCode;
        marker.openInfoWindowHtml(winhtml+ '<br>' +
          '<b>Country code:</b> ' + place.AddressDetails.Country.CountryNameCode+"<div><a href='#' onclick=\"updateinputsfrommaps('"+mapinput+"','"+tempheliportstr+"',true,"+place.Point.coordinates[1]+","+place.Point.coordinates[0]+");return false;\">Select</a></div>");
        BTB_GM_MAP.setCenter(point,13);
       
        var resp="<table id='searchlist' class='bluetable' style='margin-top:15px;font-family:verdana;font-size:11px;width:350px'>";
        resp+="<tr><th>Place</th><th>Show</th><th>Select</th></tr>";
        resp+="<tr>";
        resp+="<td>"+ tempheliportstr +"</td>";
        resp+="<td><a href='#' onclick='ZoomOnAirfield("+place.Point.coordinates[1]+","+place.Point.coordinates[0]+");return false;' class='small-link' style='color:#e7710b'>Show</a></td>";
        resp+="<td><a href='#' onclick=\"updateinputsfrommaps('"+mapinput+"','"+tempheliportstr+"',true,"+place.Point.coordinates[1]+","+place.Point.coordinates[0]+");return false;\" class='small-link' style='color:#e7710b'>Select</a></td>";
        resp+="</tr>";
        resp+="</table>";
        $(resp).insertAfter($("#mapsearch"));
        $("#othersearchresults").remove();
          
        
      }
    }

    function showLocation() {      
      var address = $("input[name=searchtext]").val();
      geocoder.getLocations(address, addAddressToMap);
    }
   var updateinputsfrommaps=function(input,content,newair,lat,lon)
   {
     var temp="";
     if(newair)
        temp=" (Lat:"+lat+",Long:"+lon+")";
     $("input[name="+input+"]").val(content + temp);
     //$("input[name="+input+"]").css({"color":"#707070","font-size":"11px","font-family":"Verdana"});
     
     $('#TB_closeWindowButton').click();
     //if($("input[name="+input+"]").hasClass("toplace"))
        $("input[name="+input+"]").blur();
     
   }
    
function addCoordinatesToMap(a){
 
  var lat= GetLattitudeDecimal(a);
  var lon=GetLongitudeDecimal(a);
  var point = new GLatLng(lat,lon);
  var icon0 = new GIcon();
  if(a.ICAOCODE.match("^T-T")=="T-T" || a.ICAOCODE.match("^A-A")=="A-A")
  {    
  icon0.image = "images/heliportsymbol.gif";
  icon0.iconSize = new GSize(70,50);
  icon0.iconAnchor = new GPoint(0, 0);
  icon0.infoWindowAnchor = new GPoint(70,50);
  }
  else
  {
    icon0.image = "images/airfieldsymbol.gif";
    icon0.iconSize = new GSize(40,38);
    icon0.iconAnchor = new GPoint(0, 0);
    icon0.infoWindowAnchor = new GPoint(40, 38);
  }


  var marker = new GMarker(point,icon0);

  BTB_GM_MAP.addOverlay(marker);
    latlngbounds.extend(point);
 

  marker.value=a;

  GEvent.addListener(marker,"click",function(){
   
   var resp="";
   resp+=a.AirfieldName+", ";
   resp+=(a.City!="" && a.City!=null)?(a.City+", "):"";
   resp+=(a.State!="" && a.State!=null)?(a.State+", "):"";
   var country=$("select[name=countries]").children("option[value="+jQuery.trim(a.Country)+"]").text();
   resp+="<br />"+country;
   this.openInfoWindowHtml(resp);
   
  });
  
}
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
  var ZoomOnAirfield=function(lat,lon)
  {
      var latlngbounds = new GLatLngBounds();
      var point = new GLatLng(lat,lon);
      latlngbounds.extend(point);
      BTB_GM_MAP.setCenter(latlngbounds.getCenter(), 13); 
        
  }     
    </script>

</asp:Content>
<asp:Content runat="server" ContentPlaceHolderID="contentholder">
    <fieldset style="float: left; width: 520px;">
        <legend>Quick Quote</legend>
        <form id="legform" action="BookRequestPage.aspx" method="get">
            <table class="bluetable" style="margin-left: 10px; margin-bottom: 15px; margin-top: 15px">
                <tr>
                    <th style="width: 150px;">
                        Trip Type
                    </th>
                    <td style="padding-left: 20px;">
                        <input type="hidden" name="nooflegs" id="nooflegs" value="1" />
                        <input id="oneway" name="TripType" value="OneWay" checked="checked" type="radio" /><label
                            for="oneway">One Way</label>
                        <input id="roundtrip" name="TripType" value="RoundTrip" type="radio" /><label for="roundtrip">Round
                            Trip</label>
                        <input id="multileg" name="TripType" value="MultiLeg" type="radio" /><label for="multileg">Multi
                            Leg</label>
                    </td>
                </tr>
                <tr>
                    <th>
                        Plane type
                    </th>
                    <td>
                        <table class="noborder">
                            <tr>
                                <td valign="top" style="padding-right: 15px;">
                                    <select id="aircrafttype" name="aircrafttype" style="width: 200px;">
                                        <% String country = HttpContext.Current.Session["Country"].ToString();
                                           foreach (AirplaneType a in OperatorDAO.GetPlaneTypesForSession())
                                           {
                                        %>
                                        <option value="<%= a.PlaneTypeID %>">
                                            <%= a.PlaneTypeName %>
                                            (<%= a.Capacity %>
                                            PAX)</option>
                                        <%
                                            }
                    
                                        %>
                                    </select>
                                </td>
                                <td>
                                    <% foreach (AirplaneType a in OperatorDAO.GetPlaneTypesForSession())
                                       {
                                       
                                    %>
                                    <a href="images/<%= a.PlaneTypeID %>.jpeg" title="<%= a.PlaneTypeName %>" class="thickbox">
                                        <img src="getthumbnailaircraftimage.ashx?typeid=<%= a.PlaneTypeID %>&typephotothumb=1"
                                            id="thumb<%= a.PlaneTypeID %>" style="display: none" class="thumbimages" /></a>
                                    <%
                                        } %>
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
            </table>
            <div id="charterlegs">
                <div class="leg">
                    <table class="bluetable" style="margin-top: 10px">
                        <tr>
                            <th colspan="2">
                                <div class="leghead">
                                    Leg 1
                                </div>
                            </th>
                        </tr>
                        <tr>
                            <td>
                                <div class="boldtext">
                                    <div style="float: left">
                                        From</div>
                                    <div style="float: right">
                                        <a href="#TB_googleMap?height=400&width=750" class="small-link loadmap" style="margin-left: 5px;
                                            font-size: 9px; font-weight: normal" tabindex="-1">Load From Map</a></div>
                                    <div class="clear">
                                    </div>
                                </div>
                                <div>
                                    <input type="text" autocomplete="off" class="ac_input fromplace" name="fromleg1" />
                                    <div class="options" style="display: none">
                                    </div>
                                </div>
                            </td>
                            <td>
                                <div class="boldtext">
                                    <div style="float: left">
                                        To</div>
                                    <div style="float: right">
                                        <a href="#TB_googleMap?height=400&width=750" class="small-link loadmap" style="margin-left: 5px;
                                            font-size: 9px; font-weight: normal" tabindex="-1">Load From Map</a></div>
                                    <div class="clear">
                                    </div>
                                </div>
                                <div>
                                    <input type="text" autocomplete="off" class="ac_input toplace" name="toleg1" />
                                    <div class="options" style="display: none">
                                        <div style='background: #f8f8f8; padding: 3px; font-weight: bold; border: 1px solid #c0c0c0;
                                            border-collapse: collapse; color: #e7710b'>
                                            Search Results</div>
                                    </div>
                                </div>
                            </td>
                        </tr>
                    </table>
                </div>
            </div>
            <div style="margin: 0px; padding-left: 10px; padding-top: 10px">
                <a href="#" class="addleg small-link" style="margin-right: 10px">Add Leg</a> <a href="#"
                    class="removeleg small-link" style="margin-right: 10px">Remove Leg</a>
            </div>
            <div class="divrow">
                <input type="button" name="quotebtn" id="quotebtn" class="submitbtn buttons" style="margin-right: 20px;
                    width: 150px;" value="Quick Quote" />
                <input type="button" name="requestcharter" style="width: 150px;" class="submitbtn buttons"
                    id="requestcharter" value="Request Charter" />
            </div>
            <div id="outerquick" style="border: solid 1px #cccccc; text-align: center; margin-top: 15px;
                background: white">
                <div id="quickquote" class="divrow quoteproper">
                    See Quote Here
                </div>
                <div style="margin-top: 10px; padding: 10px; font-size: 10px;">
                    <%= ((CharterTemplate)Page.Master).pricingdisclaimer.Trim() %>
                </div>
            </div>
        </form>
        <div id="modalWindow" style="display: none;">
        </div>
    </fieldset>
    <div style="float: left; width: 290px">
        <fieldset>
            <legend>How It Works</legend>
            <div class="airnetz-lists">
                <ul>
                    <li>Get a quick quote</li>
                    <li>Fill up date, timing and personal details </li>
                    <li>Specify <span style="color: #e7710b">Budget <sup style="font-size: 10px; color: #000000;
                        font-style: italic">New</sup></span> and send charter request</li>
                    <li>Receive quotes from different operators</li>
                    <li>Select operator and get ready for executive flying</li>
                </ul>
            </div>
        </fieldset>
        <!-- <fieldset>
            <legend>Pool Flight</legend>
            <div>
                Flight pool or Jet pool offers sharing a charter plane with other business executives
                for fares as good as a business class ticket.
                <div style="margin-top: 5px;">
                    <a class="small-link" href="http://flightpool.com">Click here to pool a flight</a></div>
            </div>
        </fieldset> -->
    </div>
    <div class="clear">
    </div>
    <div style="display: none" id="mapsearchcontent">
        <div style="margin-bottom: 20px; float: left; margin-left: 15px; margin-top: 20px;">
            <form id="mapsearch">
                <table class='bluetable' style="width: 350px">
                    <tr>
                        <td>
                            <div>
                                <span class='boldtext'>Search : </span>
                                <input type="text" name="searchtext" style="width: 220px; margin-left: 15px; padding: 2px 5px;" /></div>
                        </td>
                    </tr>
                    <tr>
                        <th>
                            <input type="submit" value="Search" name="searchbtn" class="buttons" />
                            <span id="status" style="margin-left: 20px"></span>
                        </th>
                    </tr>
                </table>
            </form>
        </div>
        <div class="clear">
        </div>
    </div>
    <select name="countries" style="display: none">
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

    <script src="http://maps.google.com/maps?file=api&amp;v=2&amp;key=ABQIAAAAgl32QoKG04P1ZBxYDdc1YxT9aaJEI2oRHrowRn4qpFJKIjABURRW3mkNQMqsNbL-SdLh7ZEILTSnhQ"
        type="text/javascript"></script>

    <script type="text/javascript">
         var BTB_GM_MAP;
  
 var geocoder = new GClientGeocoder();
 var latlngbounds = new GLatLngBounds();
    </script>

</asp:Content>
