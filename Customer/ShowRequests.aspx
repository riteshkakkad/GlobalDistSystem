<%@ Page Language="C#" MasterPageFile="~/CharterTemplate.master" AutoEventWireup="true"
    CodeFile="ShowRequests.aspx.cs" Inherits="Customer_ShowRequests" Title="Untitled Page" %>

<%@ Import Namespace="Entities" %>
<%@ Import Namespace="DataAccessLayer" %>
<%@ Import Namespace="BusinessLayer" %>
<%@ Import Namespace="System.Collections" %>
<%@ Import Namespace="System.Collections.Generic" %>
<%@ Import Namespace="System.Text" %>
<%@ Import Namespace="System.IO" %>
<%@ Import Namespace="Iesi.Collections" %>
<%@ Import Namespace="Helper" %>
<%@ Import Namespace="System.Xml" %>
<%@ Import Namespace="System.Collections.Specialized" %>
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
input.readonly {background-color: white;}
</style>

    <script type="text/javascript">
    $(document).ready(function(){
    Date.format = 'mm/dd/yyyy';
   $.editable.addInputType('planetypes', {
    element : function(settings, original) {
        var input = $('select[name=aircrafttype]').clone();
        input.find("option[value=all]").remove();
        $(this).append(input);
        return(input);
     }
    });
    $.editable.addInputType('datepicker', {
    element : function(settings, original) {
        var input=$("<input type='text' name='datepick' />");
        $(this).append(input);
        return($(input).datePicker());
     }
    });
  
    $('.editplane').editable("UpdateBookRequests.ashx", {
         indicator : '<img src="../css/indicator.gif">',
         tooltip   : 'Double click to edit...',
         event     : "dblclick",
         submit    : "OK",
         type:"planetypes",
         submitdata : function(value, settings) {
            var bookid=$(this).parents("table.bookrequest:eq(0)").find("input.bookid").val();
            return {bid:bookid,property:"PlaneType",updaterequest:'1'};
         },
         style   : 'display: inline'
     });
     $('.edit').editable("UpdateBookRequests.ashx", {
         indicator : '<img src="../css/indicator.gif">',
         tooltip   : 'Double click to edit...',
         event     : "dblclick",
         submit    : "OK",
         submitdata : function(value, settings) {
         
         var bookid=$(this).parents("table.bookrequest:eq(0)").find("input.bookid").val();
      
         var prop =jQuery.trim($(this).siblings("th:eq(0)").find("span").text());
         return {bid:bookid,property:prop,updaterequest:'1'};
         
         },
         onsubmit:function(settings, original){
         
          if($(this).parents("td:eq(0)").hasClass("number"))
          {
            if(isNaN($(this).find("input[type=text]").val()))
             {
                alert("Number Required.");
               original.editing = false;
              $(original).html(original.revert);
              return false;
             }
          }
          if($(this).parents("td:eq(0)").hasClass("required"))
          {
            if(jQuery.trim($(this).find("input[type=text]").val())=="")
             {
                alert("Field Required.");
               original.editing = false;
              $(original).html(original.revert);
              return false;
             }
          }
         
               
         },
         style   : 'display: inline'
     });
        $('.edittext').editable("UpdateBookRequests.ashx", {
         indicator : '<img src="../css/indicator.gif">',
         tooltip   : 'Double click to edit...',
         event     : "dblclick",
         submit    : "OK",
         type:"autogrow",
         submitdata : function(value, settings) {
            var bookid=$(this).parents("table.bookrequest:eq(0)").find("input.bookid").val();
          
          var prop =jQuery.trim($(this).siblings("th:eq(0)").find("span").text());
          return {bid:bookid,property:prop,updaterequest:'1'};
         },
         style   : 'display: inline',
         autogrow : {
           lineHeight : 16,
           minHeight  : 32
        }
     });
      $('.edittime').editable("UpdateBookRequests.ashx", {
         indicator : '<img src="../css/indicator.gif">',
         tooltip   : 'Double click to edit...',
         event     : "dblclick",
         submit    : "OK",
         type:"timepicker",
        
         cancel:"Cancel",
         submitdata : function(value, settings) {
            var bookid=$(this).parents("table.bookrequest:eq(0)").find("input.bookid").val();
             var legno=$(this).parents("div.leg:eq(0)").find("input.legid").val();
             return {bid:bookid,property:"Time",leg:legno,updaterequest:'1'};
           
         },
         style   : 'display: inline'
     });
      $('.editdate').editable("UpdateBookRequests.ashx", {
         indicator : '<img src="../css/indicator.gif">',
         tooltip   : 'Double click to edit...',
         event     : "dblclick",
         submit    : "OK",
         type:"datepicker",
         onblur:null,
         cancel:"Cancel",
         submitdata : function(value, settings) {
            var bookid=$(this).parents("table.bookrequest:eq(0)").find("input.bookid").val();
             var legno=$(this).parents("div.leg:eq(0)").find("input.legid").val();
             return {bid:bookid,property:"Date",leg:legno,updaterequest:'1'};
           
         },
          onsubmit:function(settings, original){
         
         
          if($(this).parents("div:eq(0)").hasClass("required"))
          {
            if(jQuery.trim($(this).find("input[type=text]").val())=="")
             {
                alert("Field Required.");
               original.editing = false;
              $(original).html(original.revert);
              return false;
             }
          }
         
               
         },
         style   : 'display: inline'
     });
     $('.editselectstatus').editable("UpdateBookRequests.ashx", {
         indicator : '<img src="../css/indicator.gif">',
         tooltip   : 'Double click to edit...',
         event     : "dblclick",
         submit    : "OK",
         type:'select',
         data:"{'1':'Closed','0':'Active'}",
         submitdata : function(value, settings) {
               var bookid=$(this).parents("table.bookrequest:eq(0)").find("input.bookid").val();
               return {bid:bookid,property:"Status",updaterequest:'1'}; 
         },
         style   : 'display: inline'
     });
    
     
    });
   
    
    </script>

</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="contentholder" runat="Server">
    <%  NameValueCollection pars = Request.QueryString;
        Int32 pageid = 1;
        if (Request.Params.Get("pageid") != null)
        {
            pageid = Int32.Parse(Request.Params.Get("pageid"));
        }
        string oneway = "OneWay";
        string roundtrip = "RoundTrip";
        string multileg = "MultiLeg";
    %>
    <table class="bluetable" style="width: 800px; margin-left: auto; margin-right: auto;
        margin-top: 20px">
        <tr>
            <td>
                <form action="ShowRequests.aspx">
                    <span>Plane type</span>
                    <select name="aircrafttype">
                        <option value="all" <%= (pars["aircrafttype"]!=null)?"":"selected" %>>All</option>
                        <% 
                            foreach (AirplaneType a in OperatorDAO.GetAirplaneTypes())
                            {
                                String atypeid = a.PlaneTypeID;   
                        %>
                        <option value="<%= a.PlaneTypeID %>" <%= (pars["aircrafttype"]!=atypeid)?"":"selected" %>>
                            <%= a.PlaneTypeName +"("+a.Capacity+" PAX)" %>
                        </option>
                        <%
                            }
                    
                        %>
                    </select>
                    <span>Trip type</span>
                    <select name="triptype">
                        <option value="all" <%= (pars["triptype"]!=null)?"":"selected" %>>All</option>
                        <option value="OneWay" <%= (pars["triptype"]==oneway)?"selected" :"" %>>One Way</option>
                        <option value="RoundTrip" <%= (pars["triptype"]==roundtrip)?"selected" :"" %>>Round
                            Trip</option>
                        <option value="MultiLeg" <%= (pars["triptype"]==multileg)?"selected" :"" %>>Multi Leg</option>
                    </select>
                    <input type="submit" name="requestsearchbtn" value="search" />
                </form>
            </td>
        </tr>
    </table>
    <%
        IList<BookRequest> bfulllist = BookRequestDAO.GetBookRequests(Request.QueryString);
        IList<BookRequest> blist = BookRequestDAO.GetBookRequests(Request.QueryString, pageid, 10);


    %>
    <br />
    <span class="brown">Pages: </span><span id="pages">
        <%
            Int32 noofpages = (Int32)Math.Ceiling(bfulllist.Count / 10.0);

            for (int i = 1; i <= noofpages; i++)
            {
                if (i != pageid)
                {
        %>
        <a href="<%= AdminBO.GetPagingURL(Request.QueryString,"ShowBookRequests.aspx", i) %>"
            style="margin-right: 5px">
            <%= i %>
        </a>
        <%
            }
            else
            {
        %>
        <span style="margin-right: 5px">
            <%=i %>
        </span>
        <%
            }
        }
           
        %>
    </span>
    <br />
    <% if (bfulllist.Count > 0)
       {
           foreach (BookRequest b in blist)
           {
    %>
    <table class="bookrequest" style="border: 1px solid #C0C0C0; background: white; margin: 5px;
        width: 850px">
        <tr>
            <td colspan="2" style="padding: 5px; color: #e7710b; font-size: 14px; font-weight: bold">
                <%= b.GetLegString()%>
                <input type="hidden" class="bookid" value="<%= b.BookID %>" />
            </td>
        </tr>
        <tr>
            <td style="padding: 5px; vertical-align: top; padding-right: 20px">
                <table class="bluetable" style="width: 300px">
                    <tr>
                        <th>
                            Plane Type
                        </th>
                        <td class="editplane">
                            <%= b.PlaneType.PlaneTypeName + "(" + b.PlaneType.Capacity + " PAX)"%>
                        </td>
                    </tr>
                    <tr>
                        <th>
                            Trip Type
                        </th>
                        <td>
                            <%= b.TripType%>
                        </td>
                    </tr>
                    <tr>
                        <th>
                            Budget (<%= b.Domain.Currency.ShortName%>) <span style="display: none">Budget</span>
                        </th>
                        <td class="edit required number">
                            <%= b.Budget %>
                        </td>
                    </tr>
                    <tr>
                        <th>
                            No of Passengers <span style="display: none">NoOfPassengers</span>
                        </th>
                        <td class="edit required number">
                            <%= b.PAX %>
                        </td>
                    </tr>
                    <tr>
                        <th>
                            Other Details <span style="display: none">OtherDetails</span>
                        </th>
                        <td class="edittext">
                            <%= b.ContactDetails.Description %>
                        </td>
                    </tr>
                    <tr>
                        <th style="color: #e7710b">
                            Request Status
                        </th>
                        <td class="editselectstatus">
                            <%= (b.Status == 0) ? "Active" : "Closed"%>
                        </td>
                    </tr>
                    <tr>
                        <th style="color: #e7710b">
                            Fixed Price Charter ?
                        </th>
                        <td>
                            <% if (b.FixedPriceCharter != null)
                               {
                            %>
                            Yes <a href="../FixedPriceCharterDetails.aspx?fid=<%= b.FixedPriceCharter.ID %>&width=800"
                                style="text-decoration: underline; margin-right: 10px" class="thickbox" title="Fixed Price Charter Details">
                                Details</a>
                            <%
                                }
                                else
                                {
                            %>
                            No
                            <%
                                } %>
                        </td>
                    </tr>
                </table>
            </td>
            <td style="padding: 5px; vertical-align: top;">
                <%foreach (Leg l in b.Legs)
                  {%>
                <div class="leg">
                    <input type="hidden" class="legid" value="<%= l.Sequence %>" />
                    <table class="bluetable" style="width: 450px">
                        <tr>
                            <th colspan="2">
                                <div class="leghead">
                                    Leg
                                    <%=  l.Sequence%>
                                </div>
                            </th>
                        </tr>
                        <tr>
                            <td style="width:210px">
                                <div class="boldtext">
                                    From</div>
                                <div>
                                    <%= l.Source.GetAirfieldString()%>
                                </div>
                            </td>
                            <td style="width:210px">
                                <div class="boldtext">
                                    To
                                </div>
                                <div>
                                    <%= l.Destination.GetAirfieldString()%>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <div class="boldtext">
                                    Date<span style="display: none">Date</span></div>
                                <div class="editdate required">
                                    <%= l.Date.ToShortDateString()%>
                                </div>
                            </td>
                            <td>
                                <div class="boldtext">
                                    Time<span style="display: none">Time</span></div>
                                <div class="edittime required">
                                    <%= l.Date.ToString("hh:mm tt")%>
                                </div>
                            </td>
                        </tr>
                    </table>
                </div>
                <%} %>
            </td>
        </tr>
    </table>
    <%
        }
    }
    else
    {
    %>
    <table style="border: 1px solid #C0C0C0; background: white; margin: 20px 5px 5px 5px;
        width: 850px">
        <tr>
            <td style="text-align: center">
                No Book Requests found.
            </td>
        </tr>
    </table>
    <%
        } %>
</asp:Content>
