<%@ Page Language="C#" MasterPageFile="~/Admin/AdminMaster.master" AutoEventWireup="true"
    CodeFile="ShowBookRequests.aspx.cs" Inherits="ShowBookRequests" Title="Untitled Page" %>

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
<asp:Content ID="Content1" ContentPlaceHolderID="scriptholder" runat="Server">
    <style type="text/css">
    div.suggestedoperators td
    {
     padding:10px;
    }
.ac_input
        {
        width:220px;
        padding:2px 5px;
        font-size:11px;
        font-family:verdana;
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
         border-bottom-style:none;
         border-right-style:none;
         padding:0px;
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
    $("a.makenormal").click(function(){
    
    if(!confirm("Are you sure?"))
       return false;
    });
    Date.format = 'mm/dd/yyyy';
    $(".date-picker").datePicker();
     $(".timepicker").timepicker();
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
     $(".getoperators").click(function(){
     
      $(this).siblings("a.hide").click();
       $(this).siblings("div.suggestedoperators:eq(0)").show();
       var target=$(this).siblings("div.suggestedoperators:eq(0)");
       var bookid=$(this).parents("table.bookrequest:eq(0)").find("input.bookid").val();
       var regionmatch=$("input[name=regionmatch"+bookid+"]:checked").val();
      var aircraftcategorymatch=$("input[name=aircraftcategorymatch"+bookid+"]:checked").val();
       $.ajax({
            'url': 'OperatorResolve.ashx',
            'data': "bookid="+bookid+"&regionmatch="+regionmatch+"&aircraftcategorymatch="+aircraftcategorymatch+"&getoperators=1",
            'dataType': 'json',
            'type': 'POST',
            'beforeSend':function(){
            
              $(target).html("<img src='../images/loadingAnimation.gif' style='margin:20px' />");
              
            },
            'success': function(data) {
            
               var resp="<table class=bluetable style='margin-top:10px'>";
               resp+="<tr>";
               resp+="<th></th>";
               resp+="<th>Name</th>";
               resp+="<th>Email</th>";
               resp+="<th>Phone No</th>";
               resp+="<th>Aircrafts</th>";
              
               resp+="</tr>";
               if($(data).size() > 0)
               {
               $.each(data,function(li,l){
               
                  resp+="<tr>";
                  resp+="<td><input type='checkbox' value='"+ l.OperatorId +"' name='selectedops"+bookid+"' checked /></td>";
                  resp+="<td>"+l.CompanyName+"</td>";
                  resp+="<td>"+l.Email+"</td>";
                  resp+="<td>"+l.ContactNo+"</td>";
                  resp+="<td><a href='aircrafts.aspx?oid="+ l.OperatorId +"&KeepThis=true&TB_iframe=true&width=850' class='thickbox small-link'>Aircrafts</a></td>";
                  
                  resp+="</tr>";
               
               });
                  resp+="<tr>";
                  resp+="<td colspan=5><input type='button' class='sendrequest buttons'  value='Send Request' /><span class='status'></span></td>";
                  resp+="</tr>";  
               }
               else
               {
                  resp+="<tr>";
                  resp+="<td colspan=5>No Operators</td>";
                  resp+="</tr>";  
               }
               resp+="</table>";
                $(target).html(resp); 
                tb_init('div.suggestedoperators a.thickbox'); 
                addhandlers();
            }
            });
       
       return false;
     
     });
     $(".getoperatorbids").click(function(){
     
     $(this).siblings("a.hide").click();
      var target=$(this).siblings("div.operatorbids:eq(0)");
       var bookid=$(this).parents("table.bookrequest:eq(0)").find("input.bookid").val();
   
     
       $.ajax({
            'url': 'OperatorResolve.ashx',
            'data': "bookid="+bookid+"&getoperatorbids=1",
            'dataType': 'json',
            'type': 'POST',
            'beforeSend':function(){
            
              $(target).html("<img src='../images/loadingAnimation.gif' style='margin:20px' />");
              $(target).show(); 
            },
            'success': function(data) {
            
               
               var resp="<table class=bluetable style='margin-top:10px'>";
               resp+="<tr>";
               resp+="<th>Aircraft</th>";
               resp+="<th>Operator</th>";
               resp+="<th>Amount</th>";
               resp+="<th>Final Amount</th>";
               resp+="<th>Additional Details</th>";
               resp+="<th>Time of Bid</th>";
               resp+="<th>Status</th>";
               resp+="<th>Send</th>";
               resp+="<th>Edit</th>";
               resp+="<th>Remove</th>";
               resp+="</tr>";
               if($(data).size() > 0)
               {
               $.each(data,function(li,l){
               
                  resp+="<tr>";
                  resp+="<td><input type='hidden' name='bidid' value='"+l.BidID+"' />"+l.Aircraft.AircraftName+" ("+l.Aircraft.AircraftLocation+")"+"</td>";
                  resp+="<td>"+l.Aircraft.Vendor.CompanyName+"</td>";
                  resp+="<td>"+l.Currency.ID+" "+l.BidAmount+"</td>";
                  resp+="<td>"+l.Currency.ID+" "+l.FinalBidAmount+"</td>";
                  resp+="<td>"+l.AdditionalDetails+"</td>";
                  resp+="<td style='width:150px'>"+l.TimeOfBid+"</td>";
                  resp+="<td>"+((l.Status==0)?"Not Shown":"Shown")+"</td>";
                  resp+="<td><a href='#' class='showbidtocustomer'>Send</a></td>";
                  resp+="<td><a href='EditBid.aspx?bidid="+l.BidID+"&editbid=1&height=300&width=300' title='edit bid' class='editbid thickbox'>Edit</a></td>";
                  resp+="<td><a href='#' class='removebid'>Remove</a></td>";
                  resp+="</tr>";
               
               });
                 
               }
               else
               {
                  resp+="<tr>";
                  resp+="<td colspan=7>No Bids</td>";
                  resp+="</tr>";  
               }
               resp+="</table>";
               resp+="<br><a href='EditBid.aspx?bookid="+bookid+"&addbid=1&height=400&width=400' title='Add bid' class='newbid thickbox'>Add New Bid</a>";
               $(target).html(resp);
               addhandlers();
               tb_init("div.operatorbids a.thickbox");
              
              
            }
            });
       
       return false;
     
     });
     $(".getoperatorrequests").click(function(){
     
       $(this).siblings("a.hide").click();
       var target=$(this).siblings("div.operatorrequests:eq(0)");
       var bookid=$(this).parents("table.bookrequest:eq(0)").find("input.bookid").val();
      
     
       $.ajax({
            'url': 'OperatorResolve.ashx',
            'data': "bookid="+bookid+"&getoperatorrequests=1",
            'dataType': 'json',
            'type': 'POST',
            'beforeSend':function(){
            
              $(target).html("<img src='../images/loadingAnimation.gif' style='margin:20px' />");
              $(target).show(); 
            },
            'success': function(data) {
            
               var resp="<table class=bluetable style='margin-top:10px'>";
               resp+="<tr>";
               resp+="<th></th>";
               resp+="<th>Name</th>";
               resp+="<th>Email</th>";
               resp+="<th>Phone No</th>";
               resp+="<th>Aircrafts</th>";
              
               resp+="</tr>";
               if($(data).size() > 0)
               {
               $.each(data,function(li,l){
               
                  resp+="<tr>";
                  resp+="<td><input type='checkbox' value='"+ l.OperatorId +"' name='selectedops"+bookid+"' checked /></td>";
                  resp+="<td>"+l.CompanyName+"</td>";
                  resp+="<td>"+l.Email+"</td>";
                  resp+="<td>"+l.ContactNo+"</td>";
                  resp+="<td><a href='aircrafts.aspx?oid="+ l.OperatorId +"&KeepThis=true&TB_iframe=true&width=850' class='thickbox small-link'>Aircrafts</a></td>";
                  
                  resp+="</tr>";
               
               });
                  resp+="<tr>";
                  resp+="<td colspan=5><input type='button' class='resendrequest buttons'  value='ReSend Request' style='width:150px' /><span class='status'></span></td>";
                  resp+="</tr>";  
               }
               else
               {
                  resp+="<tr>";
                  resp+="<td colspan=5>No Operators</td>";
                  resp+="</tr>";  
               }
               resp+="</table>";
                $(target).html(resp);
                
                tb_init('div.operatorrequests a.thickbox'); 
                addhandlers();
            }
            });
       
       return false;
     
     });
     $("a.changesettings").click(function(){
     
        $(this).siblings("a.hide").click();
        $(this).siblings("div.resolvesettings:eq(0)").show();
       
        return false;
     
     });
      $("a.hide").click(function(){
     
        $(this).siblings("div.resolvesettings:eq(0)").hide();
        $(this).siblings("div.suggestedoperators:eq(0)").hide();
        $(this).siblings("div.operatorrequests:eq(0)").hide();
         $(this).siblings("div.operatorbids:eq(0)").hide();
        
        return false;
     
     });
    });
    var addhandlers=function(){
     
    
    $("a.removebid").click(function(){
     if(!confirm("Are you sure?"))
       return false;
      var target=$(this);
        var bidid=$(this).parents("tr:eq(0)").find("input[name=bidid]").val();
       
        $.ajax({
            'url': 'OperatorResolve.ashx',
            'data': "bidid="+bidid+"&removebid=1",
            'dataType': 'text',
            'type': 'POST',
            'beforeSend':function(){
       
             
              
            },
            'success': function(data) {
             
               $(target).parents("tr:eq(0)").remove();
             
             }
            
            });
       return false;
    
    });
    
    $("a.showbidtocustomer").click(function(){
    var target=$(this);
       var bidid=$(this).parents("tr:eq(0)").find("input[name=bidid]").val();
       $(target).siblings("span.status").remove();
       $.ajax({
            'url': 'OperatorResolve.ashx',
            'data': "bidid="+bidid+"&sendbidtocustomer=1",
            'dataType': 'text',
            'type': 'POST',
            'beforeSend':function(){
            
             $(target).siblings("span.status").remove();
             $("<span class='status'>Sending..</span>").insertAfter($(target));
              
            },
            'success': function(data) {
             
             $(target).siblings("span.status").remove();
             $("<span class='status'>Sent</span>").insertAfter($(target));
            
            }
            
            });
       return false;
    
    });
    
    $(".sendrequest").click(function(){
    var ids= $(this).parents("div.suggestedoperators:eq(0)").find("input:checkbox:checked");
    var resp="";
    $.each(ids,function(li,l){
   
        resp+=$(l).val()+",";
   
    });
   
    var selops= resp.slice(0,resp.lastIndexOf(","));
    var target=$(this).siblings("span.status:eq(0)");
    if(selops=="")
    {
     alert("select operators");
     $(target).html("");
     return;
    }
   var bookid=$(this).parents("table.bookrequest:eq(0)").find("input.bookid").val();
    
     $.ajax({
            'url': 'OperatorResolve.ashx',
            'data': "bookid="+bookid+"&selectedops="+selops+"&sendrequest=1",
            'dataType': 'text',
            'type': 'POST',
            'beforeSend':function(){
            
              $(target).html("<img src='../images/loadingAnimation.gif' />");
              
            },
            'success': function(data) {
             
             $(target).html("Request Sent");
            
            }
            
            });
    return false;
    
    
    });
    $(".resendrequest").click(function(){
    var ids= $(this).parents("div.operatorrequests:eq(0)").find("input:checkbox:checked");
    var resp="";
    $.each(ids,function(li,l){
   
        resp+=$(l).val()+",";
   
    });
   
    var selops= resp.slice(0,resp.lastIndexOf(","));
    var target=$(this).siblings("span.status:eq(0)");
    if(selops=="")
    {
     alert("select operators");
     $(target).html("");
     return;
    }
   var bookid=$(this).parents("table.bookrequest:eq(0)").find("input.bookid").val();
    
     $.ajax({
            'url': 'OperatorResolve.ashx',
            'data': "bookid="+bookid+"&selectedops="+selops+"&sendrequest=1",
            'dataType': 'text',
            'type': 'POST',
            'beforeSend':function(){
            
              $(target).html("<img src='../images/loadingAnimation.gif' />");
              
            },
            'success': function(data) {
             
             $(target).html("Request Sent");
            
            }
            
            });
    return false;
    
    
    });
    
    }
    </script>

</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="contentholder" runat="Server">
    <%
        XmlDocument doc = new XmlDocument();
        doc.Load(Server.MapPath(@"~/RequestResolveSettings.xml"));
        XmlNode rmatch = doc.SelectSingleNode("/requestresolve/regionmatch");
        String rmatch_all = rmatch.SelectSingleNode("all").InnerText.Trim();
        String rmatch_allinoperatedcountries = rmatch.SelectSingleNode("allinoperatedcountries").InnerText.Trim();
        String rmatch_startingoperatedcountries = rmatch.SelectSingleNode("startingoperatedcountries").InnerText.Trim();
        String rmatch_aircraftpresentinstartlocation = rmatch.SelectSingleNode("aircraftpresentinstartlocation").InnerText.Trim();

        XmlNode amatch = doc.SelectSingleNode("/requestresolve/aircraftcategorymatch");
        String amatch_all = amatch.SelectSingleNode("all").InnerText.Trim();
        String amatch_parentmatch = amatch.SelectSingleNode("parentmatch").InnerText.Trim();
        String amatch_exactmatch = amatch.SelectSingleNode("exactmatch").InnerText.Trim();
    
    %>
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
    <table class="bluetable" style="width: 900px; margin-left: auto; margin-right: auto;
        margin-top: 20px">
        <tr>
            <td>
                <form action="showbookrequests.aspx" style="text-align: center">
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
                    <span>Name</span>
                    <input type="text" name="name" value="<%= pars.Get("name") %>" /><br />
                    <br />
                    <span>Email</span>
                    <input type="text" name="email" value="<%= pars.Get("email") %>" />
                    <span>Status</span>
                    <select name="status">
                        <option value="0" <%= (pars["status"]=="0")?"selected":"" %>>Active</option>
                        <option value="1" <%= (pars["status"]=="1")?"selected":"" %>>Closed</option>
                    </select>
                    <input type="hidden" name="agentid" value="<%= pars.Get("agentid") %>" />
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
        width: 950px">
        <tr>
            <td colspan="2" style="padding: 5px; color: #e7710b; font-size: 14px; font-weight: bold">
                <%= b.GetLegString()%>
                <input type="hidden" class="bookid" value="<%= b.BookID %>" />
            </td>
        </tr>
        <tr>
            <td style="padding: 5px; vertical-align: top; padding-right: 20px">
                <table class="bluetable" style="width: 350px">
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
                            Actual Budget(<%= b.Domain.Currency.ShortName%>)<span style="display: none">Budget</span>
                        </th>
                        <td class="edit">
                            <%= b.Budget %>
                        </td>
                    </tr>
                    <tr>
                        <th>
                            Budget - Margin (<%= b.Domain.Currency.ShortName%>) <span style="display: none">FinalBudget</span>
                        </th>
                        <td class="edit">
                            <%= b.FinalBudget %>
                        </td>
                    </tr>
                    <tr>
                        <th>
                            No of Passengers <span style="display: none">NoOfPassengers</span>
                        </th>
                        <td class="edit">
                            <%= b.PAX%>
                        </td>
                    </tr>
                    <tr>
                        <th>
                            Name <span style="display: none">Name</span>
                        </th>
                        <td class="edit">
                            <%= b.ContactDetails.Name%>
                        </td>
                    </tr>
                    <tr>
                        <th>
                            Email <span style="display: none">Email</span>
                        </th>
                        <td class="edit">
                            <%= b.ContactDetails.Email%>
                        </td>
                    </tr>
                    <tr>
                        <th>
                            Phone No <span style="display: none">PhoneNo</span>
                        </th>
                        <td class="edit">
                            <%= b.ContactDetails.Phone%>
                        </td>
                    </tr>
                    <tr>
                        <th>
                            Other Details <span style="display: none">OtherDetails</span>
                        </th>
                        <td class="edittext">
                            <%= b.ContactDetails.Description%>
                        </td>
                    </tr>
                    <tr>
                        <th style="color: #e7710b">
                            Agent
                        </th>
                        <td>
                            <%= (b.IsAgent) ? b.Agent.Agency : "No Agent"%>
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
                            Fixed Price Charter
                        </th>
                        <td>
                            <% if (b.FixedPriceCharter != null)
                               {
                            %>
                            Yes <a href="../FixedPriceCharterDetails.aspx?fid=<%= b.FixedPriceCharter.ID %>&width=800"
                                style="text-decoration: underline; margin-right: 10px" class="thickbox" title="Fixed Price Charter Details">
                                Details</a><a href="updatebookrequests.ashx?bookid=<%= b.BookID %>&makenormal=1" style="text-decoration: underline; margin-right: 10px" class="makenormal">Make normal</a>
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
                    <table class="bluetable" style="width: 550px">
                        <tr>
                            <th colspan="2">
                                <div class="leghead">
                                    Leg
                                    <%=  l.Sequence%>
                                </div>
                            </th>
                        </tr>
                        <tr>
                            <td>
                                <div class="boldtext">
                                    From</div>
                                <div class='editairfield'>
                                    <%= l.Source.GetAirfieldString()%>
                                </div>
                            </td>
                            <td>
                                <div class="boldtext">
                                    To
                                </div>
                                <div class='editairfield'>
                                    <%= l.Destination.GetAirfieldString()%>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <div class="boldtext">
                                    Date<span style="display: none">Date</span></div>
                                <div class="editdate">
                                    <%= l.Date.ToShortDateString()%>
                                </div>
                            </td>
                            <td>
                                <div class="boldtext">
                                    Time<span style="display: none">Time</span></div>
                                <div class="edittime">
                                    <%= l.Date.ToString("hh:mm tt")%>
                                </div>
                            </td>
                        </tr>
                    </table>
                </div>
                <%} %>
                <a href="EditLegs.aspx?bookid=<%= b.BookID %>&height=500" class='small-link thickbox'
                    title='Edit Legs'>Edit Legs</a>
            </td>
        </tr>
        <tr>
            <td colspan="2">
                <div style="border: 1px solid #c0c0c0; padding: 10px; margin: 10px">
                    <a href="#" class="getoperators small-link" style="margin-right: 20px;">Get Relevant
                        Operators</a> <a href="#" class="changesettings small-link" style="margin-right: 20px;">
                            Change settings</a> <a href="#" class="getoperatorrequests small-link" style="margin-right: 20px;">
                                Operator Requests</a> <a href="#" class="getoperatorbids small-link" style="margin-right: 20px;">
                                    Operator Bids</a> <a href="#" class="hide small-link">Hide</a>
                    <div class="suggestedoperators">
                    </div>
                    <div class="resolvesettings" style="height: 300px; overflow: auto; display: none">
                        <table class="bluetable" style="margin-top: 10px; margin-left: 20px">
                            <tr>
                                <th style="width: 200px">
                                    Region match
                                </th>
                                <td>
                                    <table class="noborder">
                                        <tr>
                                            <td valign="top">
                                                <input type="radio" name="regionmatch<%=b.BookID %>" value="all" <%= (rmatch_all=="true")?"checked" : ""  %> /></td>
                                            <td>
                                                Dont match
                                            </td>
                                        </tr>
                                    </table>
                                    <table class="noborder">
                                        <tr>
                                            <td valign="top">
                                                <input type="radio" name="regionmatch<%=b.BookID %>" value="allinoperatedcountries"
                                                    <%= (rmatch_allinoperatedcountries=="true")?"checked" : ""  %> /></td>
                                            <td>
                                                All flying in operator operated countries (includes operator registered country)
                                            </td>
                                        </tr>
                                    </table>
                                    <table class="noborder">
                                        <tr>
                                            <td valign="top">
                                                <input type="radio" name="regionmatch<%=b.BookID %>" value="startingoperatedcountries"
                                                    <%= (rmatch_startingoperatedcountries=="true")?"checked" : ""  %> /></td>
                                            <td>
                                                Flying starts from operator's operated countries (includes operator registered country)
                                            </td>
                                        </tr>
                                    </table>
                                    <table class="noborder">
                                        <tr>
                                            <td valign="top">
                                                <input type="radio" name="regionmatch<%=b.BookID %>" value="aircraftpresentinstartlocation"
                                                    <%= (rmatch_aircraftpresentinstartlocation=="true")?"checked" : ""  %> /></td>
                                            <td>
                                                Aircraft present in request's starting location
                                            </td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                            <tr>
                                <th>
                                    Aircraft Category Match
                                </th>
                                <td>
                                    <table class="noborder">
                                        <tr>
                                            <td valign="top">
                                                <input type="radio" name="aircraftcategorymatch<%=b.BookID %>" value="all" <%= (amatch_all=="true")?"checked" : ""  %> /></td>
                                            <td>
                                                Dont Match
                                            </td>
                                        </tr>
                                    </table>
                                    <table class="noborder">
                                        <tr>
                                            <td valign="top">
                                                <input type="radio" name="aircraftcategorymatch<%=b.BookID %>" value="parentmatch"
                                                    <%= (amatch_parentmatch=="true")?"checked" : ""  %> /></td>
                                            <td>
                                                Parent category match
                                            </td>
                                        </tr>
                                    </table>
                                    <table class="noborder">
                                        <tr>
                                            <td valign="top">
                                                <input type="radio" name="aircraftcategorymatch<%=b.BookID %>" value="exactmatch"
                                                    <%= (amatch_exactmatch=="true")?"checked" : ""  %> /></td>
                                            <td>
                                                Exact category match
                                            </td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                            <tr>
                                <th colspan="2">
                                    <input type="button" class="buttons" value="Get Operators for this settings" onclick="$(this).parents('div.resolvesettings:eq(0)').siblings('a.getoperators:eq(0)').click();" />
                                </th>
                            </tr>
                        </table>
                    </div>
                    <div style="display: none" class="operatorrequests">
                    </div>
                    <div style="display: none" class="operatorbids">
                    </div>
                </div>
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
        width: 950px">
        <tr>
            <td style="text-align: center">
                No Book Requests found.
            </td>
        </tr>
    </table>
    <%
        } %>
</asp:Content>
