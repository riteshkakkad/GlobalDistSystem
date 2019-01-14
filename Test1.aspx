<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/CharterTemplate.master"
    CodeFile="Test1.aspx.cs" Inherits="Test1" Title="Untitled Page" %>

<%@ Import Namespace="Entities" %>
<%@ Import Namespace="DataAccessLayer" %>
<%@ Import Namespace="BusinessLayer" %>
<%@ Import Namespace="System.Collections" %>
<%@ Import Namespace="System.Collections.Generic" %>
<%@ Import Namespace="Iesi.Collections" %>
<%@ Import Namespace="NHibernate" %>
<%@ Import Namespace="System.Xml" %>
<%@ Import Namespace="Helper" %>
<asp:Content runat="server" ContentPlaceHolderID="scriptholder">

    <script src="http://maps.google.com/maps?file=api&amp;v=2&amp;key=jhkjhk" type="text/javascript"></script>

    <script type="text/javascript">
 var BTB_GM_MAP;
 var geocoder = new GClientGeocoder();
 var latlngbounds = new GLatLngBounds();
$(document).ready(function(){
$("a.loadmap").click(function(){
     
     $("#searchlist").remove();
     $("#othersearchresults").remove();
     $("#mapsearch input[name=searchtext]").val("");
     
     var url=$(this).attr("href");
     var queryString = url.replace(/^[^\?]+\??/,'');
	 var params = tb_parseQuery( queryString );
     tb_show("google map",url,null);
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
                    resp+="<td><a href='#' onclick='return false;' class='small-link' style='color:#e7710b'>Select</a></td>";
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

function loadGoogleMap(lat, lon, zoom, html, params){

    if(GBrowserIsCompatible()){

			  //get all the points we need to mark
			  var points = new Array();
			  var i = 0;
			  
			  for(var item in params){
					if(item.substring(0,3) == 'lat'){
							var point = {};
							//get the numberof marker
							var itemNumber = 0;
							if(item.length > 3){
							  itemNumber = parseInt(item.substring(3));
								point.lat = params["lat"+itemNumber];
								point.lng = params["lng"+itemNumber];
								point.text = params["markerText"+itemNumber];								
							}else{
								point.lat = params["lat"];
								point.lng = params["lng"];
								point.text = params["markerText"];
							}				
														
							points[i] = point;
							i++;
					}
			  }


        BTB_GM_MAP = new GMap2(document.getElementById("googleMap"));
		BTB_GM_MAP.enableScrollWheelZoom();
        BTB_GM_MAP.addControl(new GSmallMapControl());
        var point = new GLatLng(lat, lon);
        BTB_GM_MAP.setCenter(point, 0);
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
        tempheliportstr=tempheliportstr.replace(","," ");
        marker.openInfoWindowHtml(winhtml+ '<br>' +
          '<b>Country code:</b> ' + place.AddressDetails.Country.CountryNameCode+"<div><a href='#'>Select</a></div>");
        BTB_GM_MAP.setCenter(point,13);  
        
      }
    }

    function showLocation() {      
      var address = $("input[name=searchtext]").val();
      geocoder.getLocations(address, addAddressToMap);
    }
   
    
function addCoordinatesToMap(a){
 
  var lat= GetLattitudeDecimal(a);
  var lon=GetLongitudeDecimal(a);
  var point = new GLatLng(lat,lon);
  var icon0 = new GIcon();
 
  icon0.image = "images/airfieldsymbol.gif";
  icon0.iconSize = new GSize(40,38);
  icon0.iconAnchor = new GPoint(0, 0);
  icon0.infoWindowAnchor = new GPoint(40, 38);

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
    <a href="#TB_googleMap?height=400&width=750&lat=37.784792&lng=-122.40911&zoom=11"
        class="loadmap">google map modal</a>
    <div style="display: none" id="mapsearchcontent">
        <div style="margin-bottom: 20px; float: left; margin-left: 15px; margin-top: 20px;">
            <form id="mapsearch">
                <table class='bluetable' style="width: 350px">
                    <tr>
                        <td>
                            <div>
                               <span class='boldtext'>Search : </span> <input type="text" name="searchtext" style="width: 250px;margin-left:15px;" /></div>
                            <input type="submit" value="Search" name="searchbtn" class="buttons" style="margin-top: 15px;" />
                            <span id="status" style="margin-top: 10px"></span>
                        </td>
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
</asp:Content>
