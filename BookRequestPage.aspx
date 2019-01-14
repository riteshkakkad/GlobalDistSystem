<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/CharterTemplate.master"
    CodeFile="BookRequestPage.aspx.cs" Inherits="BookRequestPage" %>

<%@ Import Namespace="Entities" %>
<%@ Import Namespace="DataAccessLayer" %>
<%@ Import Namespace="BusinessLayer" %>
<%@ Import Namespace="System.Collections" %>
<%@ Import Namespace="System.Collections.Generic" %>
<%@ Import Namespace="Iesi.Collections" %>
<%@ Import Namespace="NHibernate" %>
<asp:Content ContentPlaceHolderID="scriptholder" runat="server">
    <style type="text/css">
        .ac_input
        {
        width:200px;
        }
     
       .timepickdiv select
       {
          width:50px;        
       }
        
</style>
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
	background: url(images/calendar.png) no-repeat; 
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
input.readonly {background-color: white;}
</style>

    <script type="text/javascript" src="scripts/jquery.bgiframe-min.js">
    </script>

    <script type="text/javascript">
    $(document).ready(function(){
     
     
       getquickquote();
       Date.format="mm/dd/yyyy";
	  $('.date-picker').datePicker({displayClose:true});
	  
	 $(".timepicker").timepicker();
	  $(".ac_input").autocomplete("ReturnAirfields.ashx", {
        minChars: 3,
        width: 260,
        selectFirst: true
             
     });
     $("#submitbtn").click(function(){
       
       if(!validate())
        return;
       $("input,textarea,select").each(function(index){
       
       if($(this).attr('name')=='aircrafttype')
       {
         $("#"+$(this).attr("name")+"confirm").text($(this).siblings('span').text());
         return;
       }else if($(this).attr('name')=='fixedpricecharter')
       {
       }else
       {
       
       $("#"+$(this).attr("name")+"confirm").text(($(this).val()=="")?"Not Specified":$(this).val());
       }
       });
     
     tb_show("Confirm Your Details","#TB_inline?width=500&height=500&inlineId=modalWindow");
     return false;
     
     });
     $("#confirmbtn").click(function(){
          
      $("#bookform").submit();
     
     });
      $("#cancelbtn").click(function(){
      
      $("#TB_closeWindowButton").click();
     
     });
  
    });
    var getquickquote=function()
    {
     
      var querystring=$("#bookform").serialize();
   
      var valid=true;
      $("input[name^='fromleg'],input[name^='toleg']").each(function(index){
       if($(this).val()=="" || $(this).val().length<3)
       {
         valid=false;
       }
           
      });
      
      if(!valid){ 
      $("#quickquotevalue").html("Quick Quote not available. <a href='#' class='refreshquote small-link'>Refresh</a>");
       $(".refreshquote").click(function(){
                        getquickquote();
                      
                        return false;
                });
       return;
       } 
       
     $.ajax({
            'url': 'FindQuickQuote.ashx',
            'data': querystring,
            'dataType': 'json',
            'type': 'POST',
            'success': function(data) {
                 
               if(data['error'])
                {
                 $("#quickquotevalue").html("Quick Quote not available. <a href='#' class='refreshquote'>refresh</a>");
                 
                 return;
                }
                
               $("#quickquotevalue").html("Quick Quote: " +data['currency']+" "+data['quote']+" <a href='#' class='refreshquote'>refresh</a>"); 
           
            $(".refreshquote").click(function(){
                        getquickquote();
                        return false;
                });
           
           }
       
      
       
        });
        
    }
    var validate =function(){
    $(".error").remove();
     var valid=true;
     
    $(".required").each(function(index){
    
    if($(this).val()=="")
      {
       if($(this).hasClass("date-picker"))
         $("<div class='error'></div>").text("* Field Required.").insertAfter($(this).siblings(".clear"));
       else
       $("<div class='error'></div>").text("* Field Required.").insertAfter($(this));
       
       valid=false;
       }
          
    });
    $(".number").each(function(index){
    
    if(isNaN($(this).val()))
      {
       $("<div class='error'></div>").text("* Number required").insertAfter($(this));
       valid=false;
       }
          
    });
    $(".email").each(function(index){
    
    if(!echeck($(this).val()))
      {
       $("<div class='error'></div>").text("* Invalid email.").insertAfter($(this));
       valid=false;
       }
          
    });
    return valid;
    }
    </script>

</asp:Content>
<asp:Content runat="server" ContentPlaceHolderID="contentholder">
    <% Customer cust = CustomerBO.GetLoggedInCustomer(); %>
    <%  Boolean fixedcharter = false;
    %>
    <form id="bookform" action="AddBookRequest.aspx">
        <fieldset style="float: left; width: 470px;">
            <legend>Trip Details</legend>
            <% 
                NameValueCollection pars = new NameValueCollection(Request.Params);
                if (pars.Get("TripType") == "RoundTrip")
                {
                    pars.Add("fromleg2", pars.Get("toleg1"));
                    pars.Add("toleg2", pars.Get("fromleg1"));
                }
            %>
            <div>
                <table class='bluetable' style="margin-left: 10px;">
                    <%if (Request.Params.Get("fixedpricecharter") != null)
                      {
                          FixedPriceCharter el = BookRequestDAO.FindFixedPriceCharterByID(Int64.Parse(Request.Params.Get("fixedpricecharter")));
                          fixedcharter = true;

                    %>
                    <tr>
                        <th>
                            Aircraft Details
                        </th>
                        <td>
                            <%= el.Aircraft.AircraftName + " (" + el.Aircraft.AircraftLocation + ")"%>
                            <div style="margin-top: 5px; font-size: 9px; margin-bottom: 5px;">
                                Capacity :
                                <%= el.Aircraft.PassengerCapacity %>
                            </div>
                            <div style="margin-top: 5px; font-size: 9px; margin-bottom: 5px;">
                                operated by
                                <%= el.Aircraft.Vendor.OperatorShortName%>
                            </div>
                            <div>
                                <%             
                                    AircraftPhoto dp = el.Aircraft.GetDisplayPic();
                                    if (dp != null)
                                    {
                                %>
                                <a href="aircraftphotos/<%= dp.PhotoID %>.jpeg" title="<%= dp.Caption %>" class="thickbox"
                                    rel="aircraftpics<%= el.ID %>">Photos </a>
                                <% 
                                    }
                                %>
                                <div style="display: none">
                                    <%
                                        foreach (AircraftPhoto ap in el.Aircraft.PhotoList)
                                        {
                                            if (!ap.Equals(dp))
                                            {
                                    %>
                                    <a href="aircraftphotos/<%= ap.PhotoID %>.jpeg" title="<%= ap.Caption %>" class="thickbox"
                                        rel="aircraftpics<%= el.ID %>">Click</a>
                                    <%
                                        }
                                    } %>
                                </div>
                            </div>
                            <input type="hidden" name="fixedpricecharter" value="<%=pars.Get("fixedpricecharter") %>" />
                        </td>
                    </tr>
                    <tr>
                        <th style="width: 200px">
                            Quote Details
                        </th>
                        <td style="width: 200px">
                            <% String actual = String.Format("{0:n}", el.Quote);%>
                            <div>
                                <div style="color: #e7710b; font-weight: bold">
                                    <%= el.Currency.ID + " " + actual.Remove(actual.LastIndexOf(".")) %>
                                </div>
                            </div>
                            <div style="margin-top: 10px">
                                <%= "Quote Expires on " + el.ExpiresOn.ToString("MM/dd/yyyy")%>
                            </div>
                        </td>
                    </tr>
                    <%} %>
                    <tr>
                        <th style="width: 200px">
                            Plane Type
                        </th>
                        <td style="width: 200px">
                            <span>
                                <%= OperatorDAO.FindAircraftTypeByID(pars.Get("aircrafttype")).PlaneTypeName %>
                            </span>
                            <input type="hidden" name="aircrafttype" value="<%=pars.Get("aircrafttype") %>" />
                        </td>
                    </tr>
                    <tr>
                        <th>
                            Trip Type
                        </th>
                        <td>
                            <%= pars.Get("TripType") %>
                            <input type="hidden" name="TripType" value="<%=pars.Get("TripType") %>" />
                        </td>
                    </tr>
                </table>
            </div>
            <input type="hidden" name="nooflegs" value="<%= pars.Get("nooflegs") %>" />
            <%

                Int32 noflegs = Int32.Parse(pars.Get("nooflegs"));

                for (int i = 1; i <= noflegs; i++)
                {
            %>
            <div class="leg">
                <table class="bluetable">
                    <tr>
                        <th colspan="2">
                            <div class="leghead">
                                Leg
                                <%= i%>
                            </div>
                        </th>
                    </tr>
                    <tr>
                        <td style="width: 200px;">
                            <div class="boldtext">
                                From
                            </div>
                            <div>
                                <% 
                                    ListSet fromfields = AirfieldBO.GetAirfields(pars.Get("fromleg" + i));
                                    if (fromfields.Count > 1)
                                    {
                                %>
                                <select name="fromleg<%=i %>" style="width: 160px;">
                                    <%
                                        foreach (Airfield a in fromfields)
                                        {
                                    %>
                                    <option>
                                        <%= a.GetAirfieldString()%>
                                    </option>
                                    <%
                                        }
                                    %>
                                </select>
                                <%
                                    }
                                    else if (fromfields.Count == 1)
                                    {
                                        foreach (Airfield a in fromfields)
                                        {
                                %>
                                <textarea spellcheck="false" name="fromleg<%=i %>" onfocus="this.blur()" style="width: 200px"
                                    class="required readonly"><%= (a.IsTemporary()) ? pars.Get("fromleg" + i) : a.GetAirfieldString()%></textarea>
                                <%
                                    }
                                }
                                else
                                {%>
                                <input type="text" autocomplete="off" class="ac_input fromplace required" name="fromleg<%=i %>" />
                                <div>
                                    Airfield not found.Please use autocomplete feature.</div>
                                <%
                                    }
                            
                        
                                %>
                            </div>
                        </td>
                        <td>
                            <div class="boldtext">
                                To
                            </div>
                            <div>
                                <% 
                                    ListSet tofields = AirfieldBO.GetAirfields(pars.Get("toleg" + i));
                                    if (tofields.Count > 1)
                                    {
                                %>
                                <select name="toleg<%=i %>" style="width: 160px;">
                                    <%
                                        foreach (Airfield a in tofields)
                                        {
                                    %>
                                    <option>
                                        <%= a.GetAirfieldString()%>
                                    </option>
                                    <%
                                        }
                                    %>
                                </select>
                                <%
                                    }
                                    else if (tofields.Count == 1)
                                    {
                                        foreach (Airfield a in tofields)
                                        {
                                %>
                                <textarea spellcheck="false" name="toleg<%=i %>" onfocus="this.blur()" style="width: 200px"
                                    class="required readonly"><%= (a.IsTemporary()) ? pars.Get("toleg" + i) : a.GetAirfieldString()%></textarea>
                                <%
                                    }
                                }
                                else
                                {
                                %>
                                <input type="text" autocomplete="off" class="ac_input toplace required" name="toleg<%=i %>" />
                                <div>
                                    Airfield not found.Please use autocomplete feature.</div>
                                <%

                                    }
                            
                        
                
                                %>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <div class="boldtext">
                                Date
                            </div>
                            <div>
                                <input type="text" name="dateleg<%=i %>" onfocus="this.blur()" class="date-picker required"
                                    value="<%= Request.Params.Get("dateleg"+i) %>" />
                                <div class="clear">
                                </div>
                            </div>
                        </td>
                        <td>
                            <div class="boldtext">
                                Time
                            </div>
                            <div class="timepickdiv">
                                <input type="text" name="timeleg<%=i %>" id="timeleg<%= i %>" class="timepicker"
                                    value="<%= Request.Params.Get("timeleg"+i) %>" />
                            </div>
                        </td>
                    </tr>
                </table>
            </div>
            <%
        
                }
            %>
        </fieldset>
        <fieldset style="float: left; width: 300px;">
            <legend>Personal Details</legend>
            <table id="personaldetails" class="bluetable">
                <tr>
                    <th style="width: 130px;">
                        Your Budget<br />
                        (<%= AdminBO.GetCountry().Currency.ShortName %>)
                    </th>
                    <td>
                        <input id="budget" name="budget" type="text" class="required number" value="<%= Request.Params.Get("budget") %>" />
                    </td>
                </tr>
                <tr>
                    <td colspan="2" <%= (fixedcharter)?"style='display:none'":"" %>>
                        <div id="quickquotevalue">
                        </div>
                    </td>
                </tr>
                <tr>
                    <th>
                        No. of Passengers
                    </th>
                    <td>
                        <input id="PAX" name="PAX" type="text" class="required number" value="<%= Request.Params.Get("budget") %>" />
                    </td>
                </tr>
                <tr>
                    <th>
                        Name
                    </th>
                    <td>
                        <% if (cust != null)
                           {
                        %>
                        <%= cust.Name %>
                        <input id="Name" name="Name" type="hidden" value="<%= cust.Name %>" />
                        <%
                            }
                            else
                            {
                        %>
                        <input id="Name" name="Name" type="text" class="required" value="<%= Request.Params.Get("Name") %>" />
                        <%

                            } %>
                    </td>
                </tr>
                <tr>
                    <th>
                        Email
                    </th>
                    <td>
                        <% if (cust != null)
                           {
                        %>
                        <%= cust.Email %>
                        <input id="Email" name="Email" type="hidden" value="<%= cust.Name %>" />
                        <%
                            }
                            else
                            {
                        %>
                        <input id="Email" name="Email" type="text" class="email required" value="<%= Request.Params.Get("Email") %>" />
                        <%
                            } %>
                    </td>
                </tr>
                <tr>
                    <th>
                        Phone No.
                    </th>
                    <td>
                        <% if (cust != null)
                           {
                        %>
                        <%= cust.ContactNo %>
                        <input id="ContactNo" name="ContactNo" type="hidden" value="<%= cust.ContactNo %>" />
                        <%
                            }
                            else
                            {
                        %>
                        <input id="ContactNo" name="ContactNo" type="text" class="required" value="<%= Request.Params.Get("ContactNo") %>" />
                        <%
                            } %>
                    </td>
                </tr>
                <tr>
                    <th>
                        Other Details(Optional)
                    </th>
                    <td>
                        <textarea id="OtherDetails" name="OtherDetails" cols="15" rows="2" value="<%= Request.Params.Get("OtherDetails") %>"></textarea>
                    </td>
                </tr>
                <tr>
                    <th colspan="2">
                        <input type="button" name="subbtn" class="buttons" style="width: 100px" id="submitbtn"
                            value="Submit" />
                    </th>
                </tr>
            </table>
        </fieldset>
        <div class="clear">
        </div>
    </form>
    <div id="modalWindow" style="display: none;">
        <table class="bluetable" style="margin-left: 10px;">
            <%if (Request.Params.Get("fixedpricecharter") != null)
              {
                  FixedPriceCharter el = BookRequestDAO.FindFixedPriceCharterByID(Int64.Parse(Request.Params.Get("fixedpricecharter")));
                  fixedcharter = true;

            %>
            <tr>
                <th>
                    Aircraft Details
                </th>
                <td>
                    <%= el.Aircraft.AircraftName + " (" + el.Aircraft.AircraftLocation + ")"%>
                    <div style="margin-top: 5px; font-size: 9px; margin-bottom: 5px;">
                        Capacity :
                        <%= el.Aircraft.PassengerCapacity %>
                    </div>
                    <div style="margin-top: 5px; font-size: 9px; margin-bottom: 5px;">
                        operated by
                        <%= el.Aircraft.Vendor.OperatorShortName%>
                    </div>
                   
                </td>
            </tr>
            <tr>
                <th style="width: 200px">
                    Quote Details
                </th>
                <td style="width: 200px">
                    <% String actual = String.Format("{0:n}", el.Quote);%>
                    <div>
                        <div style="color: #e7710b; font-weight: bold">
                            <%= el.Currency.ID + " " + actual.Remove(actual.LastIndexOf(".")) %>
                        </div>
                    </div>
                    <div style="margin-top: 10px">
                        <%= "Quote Expires on " + el.ExpiresOn.ToString("MM/dd/yyyy")%>
                    </div>
                </td>
            </tr>
            <%} %>
            <tr>
                <th style="width: 200px">
                    Plane Type
                </th>
                <td id="aircrafttypeconfirm">
                </td>
            </tr>
            <tr>
                <th>
                    Trip Type
                </th>
                <td id="TripTypeconfirm">
                </td>
            </tr>
        </table>
        <%for (int i = 1; i <= noflegs; i++)
          { %>
        <div class="leg">
            <table class="bluetable">
                <tr>
                    <th colspan="2">
                        <div class="leghead">
                            Leg
                            <%= i%>
                        </div>
                    </th>
                </tr>
                <tr>
                    <td style="width: 200px">
                        <div class="boldtext">
                            From
                        </div>
                        <div id="fromleg<%=i %>confirm">
                        </div>
                    </td>
                    <td>
                        <div class="boldtext">
                            To
                        </div>
                        <div id="toleg<%=i %>confirm">
                        </div>
                    </td>
                </tr>
                <tr>
                    <td>
                        <div class="boldtext">
                            Date
                        </div>
                        <div id="dateleg<%=i %>confirm">
                        </div>
                    </td>
                    <td>
                        <div class="boldtext">
                            Time
                        </div>
                        <div id="timeleg<%=i %>confirm">
                        </div>
                    </td>
                </tr>
            </table>
        </div>
        <%} %>
        <table id="personaldetailsconfirm" class="bluetable" style="width: 350px; margin-left: auto;
            margin-right: auto">
            <tr>
                <th>
                    Your Budget (<%= AdminBO.GetCountry().Currency.ShortName %>)
                </th>
                <td id="budgetconfirm">
                </td>
            </tr>
            <tr>
                <th>
                    No. of Passengers
                </th>
                <td id="PAXconfirm">
                </td>
            </tr>
            <tr>
                <th>
                    Name
                </th>
                <td id="Nameconfirm">
                </td>
            </tr>
            <tr>
                <th>
                    Email
                </th>
                <td id="Emailconfirm">
                </td>
            </tr>
            <tr>
                <th>
                    Phone No.
                </th>
                <td id="ContactNoconfirm">
                </td>
            </tr>
            <tr>
                <th>
                    Other Details(Optional)
                </th>
                <td id="OtherDetailsconfirm">
                </td>
            </tr>
        </table>
        <div style="text-align: center; margin-top: 15px">
            <input type="button" value="Confirm" style="width: 150px; margin-right: 20px" name="confirmbtn"
                class="buttons" id="confirmbtn" />
            <input type="button" value="Cancel" style="width: 150px" name="cancelbtn" class="buttons"
                id="cancelbtn" />
        </div>
    </div>
</asp:Content>
