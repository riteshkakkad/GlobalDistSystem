<%@ Page Language="C#" AutoEventWireup="true" CodeFile="ViewDetailedQuote.aspx.cs"
    Inherits="ViewDetailedQuote" %>

<%@ Import Namespace="Entities" %>
<%@ Import Namespace="DataAccessLayer" %>
<%@ Import Namespace="System.Collections" %>
<%@ Import Namespace="System.Collections.Generic" %>
<%@ Import Namespace="BusinessLayer" %>
<%@ Import Namespace="NHibernate" %>
<%@ Import Namespace="Iesi.Collections" %>
<style type="text/css">
input
{
 padding:2px 5px;
}
</style>
<table class="bluetable" style="margin-bottom: 10px">
    <tr>
        <td style="width: 440px;">
            <form id="sendquoteform">
                <span style="color: #e7710b">Email this quote:</span>
                <input type="text" name="email" style="margin-left: 10px; width: 150px" />
                <input type="button" class="buttons" name="sendquotebtn" value="Send" style="margin-left: 10px;
                    width: 100px" />
                <span class="status"></span>
            </form>
        </td>
    </tr>
</table>
<%
        
    Int32 noflegs = Int32.Parse(Request.Params.Get("nooflegs"));
    BookRequest b = new BookRequest();
    AirplaneType apt = OperatorDAO.FindAircraftTypeByID(Request.Params.Get("aircrafttype"));
    b.PlaneType = apt;
    b.TripType = Request.Params.Get("TripType").Trim();
    Double distance;
    Double flyingtime;
    String time;
    Double totaldistance = 0;
    Double TotalFlyingTime = 0;
    String TotalTime;

    for (int i = 1; i <= noflegs; i++)
    {
        Leg l = new Leg();

        l.Sequence = i;
        ListSet fromairfields = AirfieldBO.GetAirfields(Request.Params.Get("fromleg" + i));
        ListSet toairfields = AirfieldBO.GetAirfields(Request.Params.Get("toleg" + i));

        foreach (Airfield a in fromairfields)
        {
            if (l.Source == null)
                l.Source = a;

        }

        foreach (Airfield a in toairfields)
        {
            if (l.Destination == null)
                l.Destination = a;

        }

        b.AddLeg(l);
    }
%>
<div id="detailedquote">
    <table class="bluetable" style="margin-bottom: 10px; border: 1px solid #c0c0c0; border-spacing: 0px;
        border-collapse: collapse;">
        <tr>
            <th style="width: 200px; background: #f8f8f8; font-weight: bold; padding: 10px; color: #707070;
                border-bottom: 1px solid #c0c0c0; border-right: 1px solid #c0c0c0; text-align: left;
                vertical-align: top;">
                Aircraft Type
            </th>
            <td style="width: 220px; background: white; padding: 15px 10px 15px 10px; border-bottom: 1px solid #c0c0c0;
                border-right: 1px solid #c0c0c0; vertical-align: top; color: #707070;">
                <%= b.PlaneType.PlaneTypeName.Trim()  %>
            </td>
        </tr>
        <tr>
            <th style="background: #f8f8f8; font-weight: bold; padding: 10px; color: #707070;
                border-bottom: 1px solid #c0c0c0; border-right: 1px solid #c0c0c0; text-align: left;
                vertical-align: top;">
                No of Passengers
            </th>
            <td style="background: white; padding: 15px 10px 15px 10px; border-bottom: 1px solid #c0c0c0;
                border-right: 1px solid #c0c0c0; vertical-align: top; color: #707070;">
                <%= b.PlaneType.Capacity %>
            </td>
        </tr>
    </table>
    <table class="bluetable" style="margin-bottom: 10px; border: 1px solid #c0c0c0; border-spacing: 0px;
        border-collapse: collapse;">
        <tr>
            <th style="width: 200px; color: #e7710b;color: #e7710b; background: #f8f8f8; font-weight: bold; padding: 10px;
                border-bottom: 1px solid #c0c0c0; border-right: 1px solid #c0c0c0; text-align: left;
                vertical-align: top;">
                Segments
            </th>
            <th style="width: 100px; color: #e7710b;color: #e7710b; background: #f8f8f8; font-weight: bold; padding: 10px;
                border-bottom: 1px solid #c0c0c0; border-right: 1px solid #c0c0c0; text-align: left;
                vertical-align: top;">
                Distance in Kms
            </th>
            <th style="width: 100px; color: #e7710b;color: #e7710b; background: #f8f8f8; font-weight: bold; padding: 10px;
                border-bottom: 1px solid #c0c0c0; border-right: 1px solid #c0c0c0; text-align: left;
                vertical-align: top;">
                Time in Hours
            </th>
        </tr>
        <% foreach (Leg l in b.Legs)
           {
               distance = l.Source.GetDistaneFrom(l.Destination);
               flyingtime = b.PlaneType.CalculateTimeToTravelDistance(distance);
               time = (Int32)flyingtime + ":" + TimeSpan.FromHours(flyingtime).Minutes;
               TotalFlyingTime += flyingtime;
               totaldistance += distance;
        %>
        <tr>
            <td style="background: white; padding: 15px 10px 15px 10px; border-bottom: 1px solid #c0c0c0;
                border-right: 1px solid #c0c0c0; vertical-align: top; color: #707070;">
                <%= l.GetLegString() %>
            </td>
            <td style="background: white; padding: 15px 10px 15px 10px; border-bottom: 1px solid #c0c0c0;
                border-right: 1px solid #c0c0c0; vertical-align: top; color: #707070;">
                <%= (Int32)distance %>
            </td>
            <td style="background: white; padding: 15px 10px 15px 10px; border-bottom: 1px solid #c0c0c0;
                border-right: 1px solid #c0c0c0; vertical-align: top; color: #707070;">
                <%= time  %>
            </td>
        </tr>
        <%
            }
            if (b.GetStartingLeg().Source != b.GetEndingLeg().Destination)
            {
                distance = b.GetEndingLeg().Destination.GetDistaneFrom(b.GetStartingLeg().Source);
                flyingtime = b.PlaneType.CalculateTimeToTravelDistance(distance);
                time = (Int32)flyingtime + ":" + TimeSpan.FromHours(flyingtime).Minutes;
                TotalFlyingTime += flyingtime;
                totaldistance += distance;
        %>
        <tr>
            <td style="background: white; padding: 15px 10px 15px 10px; border-bottom: 1px solid #c0c0c0;
                border-right: 1px solid #c0c0c0; vertical-align: top; color: #707070;">
                <%= b.GetEndingLeg().Destination.AirfieldName + " - " + b.GetStartingLeg().Source.AirfieldName%>
            </td>
            <td style="background: white; padding: 15px 10px 15px 10px; border-bottom: 1px solid #c0c0c0;
                border-right: 1px solid #c0c0c0; vertical-align: top; color: #707070;">
                <%= (Int32)distance %>
            </td>
            <td style="background: white; padding: 15px 10px 15px 10px; border-bottom: 1px solid #c0c0c0;
                border-right: 1px solid #c0c0c0; vertical-align: top; color: #707070;">
                <%= time  %>
            </td>
        </tr>
        <% 
            }
            TotalTime = (Int32)TotalFlyingTime + ":" + TimeSpan.FromHours(TotalFlyingTime).Minutes;
            String formattedquote = String.Format("{0:n}", (Int32)BookRequestBO.GetQuickQuote(b));
            String resp = "<span style='color: #e7710b'>" + AdminBO.GetCountry().Currency.ShortName + "  " + formattedquote.Remove(formattedquote.IndexOf(".")) + " *</span>";
            
        %>
        <tr>
            <td style="background: white; padding: 15px 10px 15px 10px; border-bottom: 1px solid #c0c0c0;
                border-right: 1px solid #c0c0c0; vertical-align: top; color: #707070;">
                Total Distance/Time
            </td>
            <td style="background: white; padding: 15px 10px 15px 10px; border-bottom: 1px solid #c0c0c0;
                border-right: 1px solid #c0c0c0; vertical-align: top; color: #707070;">
                <%= (Int32)totaldistance %>
            </td>
            <td style="background: white; padding: 15px 10px 15px 10px; border-bottom: 1px solid #c0c0c0;
                border-right: 1px solid #c0c0c0; vertical-align: top; color: #707070;">
                <%= TotalTime %>
            </td>
        </tr>
        <tr>
            <td style="background: white; padding: 15px 10px 15px 10px; border-bottom: 1px solid #c0c0c0;
                border-right: 1px solid #c0c0c0; vertical-align: top; color: #707070;">
                Daily Minimum Hours
            </td>
            <td style="background: white; padding: 15px 10px 15px 10px; border-bottom: 1px solid #c0c0c0;
                border-right: 1px solid #c0c0c0; vertical-align: top; color: #707070;">
            </td>
            <td style="background: white; padding: 15px 10px 15px 10px; border-bottom: 1px solid #c0c0c0;
                border-right: 1px solid #c0c0c0; vertical-align: top; color: #707070;">
                2:00
            </td>
        </tr>
    </table>
    <table class="bluetable" style="border: 1px solid #c0c0c0; border-spacing: 0px; border-collapse: collapse;">
        <tr>
            <th colspan="3" style="color: #e7710b; background: #f8f8f8; font-weight: bold; padding: 10px;
                border-bottom: 1px solid #c0c0c0; border-right: 1px solid #c0c0c0; text-align: left;
                vertical-align: top;">
                Price Details
            </th>
        </tr>
        <tr>
            <td style="width: 200px; background: white; padding: 15px 10px 15px 10px; border-bottom: 1px solid #c0c0c0;
                border-right: 1px solid #c0c0c0; vertical-align: top; color: #707070;">
                Flying Charges
            </td>
            <td style="width: 100px; background: white; padding: 15px 10px 15px 10px; border-bottom: 1px solid #c0c0c0;
                border-right: 1px solid #c0c0c0; vertical-align: top; color: #707070;">
                <%= TotalTime + " @ "+AdminBO.GetCountry().Currency.ShortName+" " + String.Format("{0:n}", b.PlaneType.GetRateForCurrentSession().HourlyRate).Remove(String.Format("{0:n}", b.PlaneType.GetRateForCurrentSession().HourlyRate).IndexOf(".")) + "* per hour"%>
            </td>
            <td style="width: 100px; background: white; padding: 15px 10px 15px 10px; border-bottom: 1px solid #c0c0c0;
                border-right: 1px solid #c0c0c0; vertical-align: top; color: #707070;">
                <%= resp %>
            </td>
        </tr>
        <tr>
            <td style="background: white; padding: 15px 10px 15px 10px; border-bottom: 1px solid #c0c0c0;
                border-right: 1px solid #c0c0c0; vertical-align: top; color: #707070;">
                Day Waiting Charges(more than 4 hours)
            </td>
            <td style="background: white; padding: 15px 10px 15px 10px; border-bottom: 1px solid #c0c0c0;
                border-right: 1px solid #c0c0c0; vertical-align: top; color: #707070;">
                <%= "Hours * "+AdminBO.GetCountry().Currency.ShortName+" " + String.Format("{0:n}", b.PlaneType.GetRateForCurrentSession().WaitingCharge).Remove(String.Format("{0:n}", b.PlaneType.GetRateForCurrentSession().WaitingCharge).IndexOf(".")) + "*"%>
            </td>
            <td style="background: white; padding: 15px 10px 15px 10px; border-bottom: 1px solid #c0c0c0;
                border-right: 1px solid #c0c0c0; vertical-align: top; color: #707070;">
                If Applicable
            </td>
        </tr>
        <tr>
            <td style="background: white; padding: 15px 10px 15px 10px; border-bottom: 1px solid #c0c0c0;
                border-right: 1px solid #c0c0c0; vertical-align: top; color: #707070;">
                Night Halt Charges
            </td>
            <td style="background: white; padding: 15px 10px 15px 10px; border-bottom: 1px solid #c0c0c0;
                border-right: 1px solid #c0c0c0; vertical-align: top; color: #707070;">
                <%= "Night Halts * "+AdminBO.GetCountry().Currency.ShortName+" " + String.Format("{0:n}", b.PlaneType.GetRateForCurrentSession().NightHalt).Remove(String.Format("{0:n}", b.PlaneType.GetRateForCurrentSession().NightHalt).IndexOf(".")) + "*"%>
            </td>
            <td style="background: white; padding: 15px 10px 15px 10px; border-bottom: 1px solid #c0c0c0;
                border-right: 1px solid #c0c0c0; vertical-align: top; color: #707070;">
                If Applicable
            </td>
        </tr>
        <tr>
            <td style="background: white; padding: 15px 10px 15px 10px; border-bottom: 1px solid #c0c0c0;
                border-right: 1px solid #c0c0c0; vertical-align: top; color: #707070;">
                Crew Charges
            </td>
            <td style="background: white; padding: 15px 10px 15px 10px; border-bottom: 1px solid #c0c0c0;
                border-right: 1px solid #c0c0c0; vertical-align: top; color: #707070;">
                <%= "Crews * "+AdminBO.GetCountry().Currency.ShortName+" " + String.Format("{0:n}", b.PlaneType.GetRateForCurrentSession().Crew).Remove(String.Format("{0:n}", b.PlaneType.GetRateForCurrentSession().Crew).IndexOf(".")) + "*"%>
            </td>
            <td style="background: white; padding: 15px 10px 15px 10px; border-bottom: 1px solid #c0c0c0;
                border-right: 1px solid #c0c0c0; vertical-align: top; color: #707070;">
                If Applicable
            </td>
        </tr>
        <tr>
            <td style="background: white; padding: 15px 10px 15px 10px; border-bottom: 1px solid #c0c0c0;
                border-right: 1px solid #c0c0c0; vertical-align: top; color: #707070;">
                Landing Fees
            </td>
            <td style="background: white; padding: 15px 10px 15px 10px; border-bottom: 1px solid #c0c0c0;
                border-right: 1px solid #c0c0c0; vertical-align: top; color: #707070;">
            </td>
            <td style="background: white; padding: 15px 10px 15px 10px; border-bottom: 1px solid #c0c0c0;
                border-right: 1px solid #c0c0c0; vertical-align: top; color: #707070;">
                If Applicable
            </td>
        </tr>
        <tr>
            <td style="background: white; padding: 15px 10px 15px 10px; border-bottom: 1px solid #c0c0c0;
                border-right: 1px solid #c0c0c0; vertical-align: top; color: #707070;">
                Extension of Watch Hours
            </td>
            <td style="background: white; padding: 15px 10px 15px 10px; border-bottom: 1px solid #c0c0c0;
                border-right: 1px solid #c0c0c0; vertical-align: top; color: #707070;">
            </td>
            <td style="background: white; padding: 15px 10px 15px 10px; border-bottom: 1px solid #c0c0c0;
                border-right: 1px solid #c0c0c0; vertical-align: top; color: #707070;">
                If Applicable
            </td>
        </tr>
        <tr>
            <td style="background: white; padding: 15px 10px 15px 10px; border-bottom: 1px solid #c0c0c0;
                border-right: 1px solid #c0c0c0; vertical-align: top; color: #707070;">
                Service Tax
            </td>
            <td style="background: white; padding: 15px 10px 15px 10px; border-bottom: 1px solid #c0c0c0;
                border-right: 1px solid #c0c0c0; vertical-align: top; color: #707070;">
            </td>
            <td style="background: white; padding: 15px 10px 15px 10px; border-bottom: 1px solid #c0c0c0;
                border-right: 1px solid #c0c0c0; vertical-align: top; color: #707070;">
                If Applicable
            </td>
        </tr>
    </table>
</div>

<script type="text/javascript">
$("input[name=sendquotebtn]").click(function(){
 var email=jQuery.trim($("#sendquoteform input[name=email]").val());

  if(email=="" || !((email.indexOf(".") > 2) && (email.indexOf("@") > 0)))
  {
    alert("Invalid Email");
    return false;
  }
  
   var data = {
        emaildetailedquote: 1,
        emailid: email,
        emailcontent:$("#detailedquote").html()
        };

        $.ajax({
            'url': 'FindQuickQuote.ashx',
            'data': data,
            'dataType': 'text',
            'type': 'POST',
            'beforeSend':function(){
            
              $("#sendquoteform .status").html("Sending..");
              
              
            },
            'success': function(data) {
            
               
                 $("#sendquoteform .status").html("Sent.");
                 
            }
        });



 return false;

});

</script>

