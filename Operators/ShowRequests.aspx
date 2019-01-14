<%@ Page Language="C#" MasterPageFile="~/Operators/OperatorMaster.master" AutoEventWireup="true"
    CodeFile="ShowRequests.aspx.cs" Inherits="Operators_ShowRequests" Title="Untitled Page" %>

<%@ Import Namespace="Entities" %>
<%@ Import Namespace="DataAccessLayer" %>
<%@ Import Namespace="BusinessLayer" %>
<%@ Import Namespace="System.Collections" %>
<%@ Import Namespace="System.Collections.Generic" %>
<%@ Import Namespace="System.Collections.Specialized" %>
<%@ Import Namespace="Iesi.Collections" %>
<%@ Import Namespace="NHibernate" %>
<asp:Content ID="Content1" ContentPlaceHolderID="scriptholder" runat="Server">

    <script type="text/javascript">

$(document).ready(function(){
  addhandlers();
  $("a.addbid").click(function(){
  
    var bookid=$(this).parents("table.bookrequest:eq(0)").find("input.bookid").val();
    tb_show("Add Bid","#TB_inline?width=400&height=350&inlineId=ModalWindow");
    $("#bidform").find("input[name=bookid]").val(bookid);
   
    return false;
  
  });
 $("#bidform").submit(function(){
      
    
     var request=$("input[value="+$(this).find("input[name=bookid]").val()+"].bookid").parents("table.bookrequest:eq(0)");
    
     $.ajax({
            'url': 'UpdateBids.ashx',
            'data': $(this).serialize()+"&addbid=1",
            'dataType': 'json',
            'type': 'POST',
            'beforeSend':function(){
            
              $("#status").html("<img src='../images/loadingAnimation.gif' />");
              
            },
            'success': function(data) {
           
             $("#status").html("Saved");
             updaterequests(request,data);
             addhandlers();
            
            }
            
            });
    return false;
 
 });

});
var addhandlers= function(){
 
$("a.removebid").click(function(){


var target=$(this);
var request=$(this).parents("table.bookrequest:eq(0)");
if(confirm("Are you sure?"))
{
 
  $.ajax({
            'url': 'UpdateBids.ashx',
            'data': "bidid="+$(this).siblings("input.bidid:eq(0)").val()+"&removebid=1",
            'dataType': 'json',
            'type': 'POST',
            'beforeSend':function(){
            
            },
            'success': function(data) {
         
             alert("removed");
             $(target).parents("div.bid:eq(0)").remove();
             updaterequests(request,data);
             addhandlers();
            
            }
            
       });
}
return false;

});
$("#updatebidform").submit(function(){
     
     var request=$("input[value="+$(this).find("input[name=bookid]").val()+"].bookid").parents("table.bookrequest:eq(0)");
     $.ajax({
            'url': 'UpdateBids.ashx',
            'data': $(this).serialize()+"&updatebid=1",
            'dataType': 'json',
            'type': 'POST',
            'beforeSend':function(){
            
              $("#updatestatus").html("<img src='../images/loadingAnimation.gif' />");
              
            },
            'success': function(data) {
             
             $("#updatestatus").html("Saved");
             updaterequests(request,data);
             addhandlers();
            
            }
            
            });
    return false;
 
 });

}
var updaterequests=function(request,data){

    
    if(data.TotalBids>0)
    {
     var bookid=$(request).find("input.bookid").val();
     $(request).find("td.totalbids").html(data.TotalBids+"&nbsp;&nbsp;<a href='ShowBids.aspx?bookid="+bookid+"' title='TOTAL BIDS : "+ data.TotalBids +"' class='thickbox'>See all</a>");
     tb_init($(request).find("td.totalbids a.thickbox"));
    
    }
    else
    {
     $(request).find("td.totalbids").html("No Bids");
    }
    
    if($(data.OperatorBids).size() > 0)
    {
     var resp="";
     
     
     $.each(data.OperatorBids,function(li,l){
        
        resp+="<div class='bid'>";
        resp+= l.Currency.ShortName + " " + l.BidAmount;
        resp+="<div style='margin-bottom: 10px'>"
        resp+="<a href='ShowBids.aspx?bidid="+l.BidID+"&bookid="+bookid+"' title='All Bids' class='thickbox' style='margin-right: 5px;'>Show</a>";
        resp+="<a href='EditBid.aspx?bidid="+l.BidID+"' class='thickbox'  title='Edit Bid' style='margin-right: 5px;'>Change</a>";
        resp+="<a href='#' class='small-link removebid'>Remove</a>";
        resp+="<input type='hidden' class='bidid' value="+l.BidID+" />";
        resp+="</div>";
        resp+="</div>";
     });
         $(request).find("td.yourbids").html(resp);
         tb_init($(request).find("td.yourbids").find("a.thickbox"));
        
         
                            
    }
    else
    {
     $(request).find("td.yourbids").html("No Bids");
    }
    if(data.MinBid)
    {
     $(request).find("td.lowestbid").html(data.MinBid.Currency.ShortName + " "+ data.MinBid.BidAmount);
    }
    else
    {
     $(request).find("td.lowestbid").html("No Bids");
     
    }


}
    </script>

</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="contentholder" runat="Server">
    <%      Operator op = OperatorBO.GetLoggedinOperator();
            Int32 pageid = 1;
            if (Request.Params.Get("pageid") != null)
            {
                pageid = Int32.Parse(Request.Params.Get("pageid"));
            }
            bool tempstatus = true;
            NameValueCollection pars = new NameValueCollection();
            if (Request.Params.Get("status") != null)
            {
                if (Request.Params.Get("status") == "1")
                {
                    pars.Add("status", "1");
                    tempstatus = false;
                }

            }
                   
        
    %>
    <%
        IList<BookRequest> bfulllist = BookRequestDAO.GetBookRequests(op, pars);
        IList<BookRequest> blist = BookRequestDAO.GetBookRequests(op, pars, pageid, 5);
        
    %>
    <table class="bluetable" style="margin-bottom: 15px; border-color: #e7710b; width: 850px;
        margin-left: auto; margin-right: auto">
        <tr>
            <th style="border-color: #e7710b; border-right-style: none">
                Charter Requests
                <% if (tempstatus)
                   {
                %>
                <a href="showrequests.aspx?status=1" style="margin-left: 10px; color: #e7710b; font-size: 11px;
                    font-weight: normal">Show closed requests</a>
                <%
                    }
                    else
                    {
                %>
                <a href="showrequests.aspx" style="margin-left: 10px; color: #e7710b; font-size: 11px;
                    font-weight: normal">Show active requests</a>
                <%
                    } %>
            </th>
            <th style="border-color: #e7710b; border-left-style: none; text-align: right">
                <div>
                    <span>
                        <%= (bfulllist.Count>0)?"Pages: ":"" %>
                    </span><span id="pages">
                        <%
                            Int32 noofpages = (Int32)Math.Ceiling(bfulllist.Count / 5.0);

                            for (int i = 1; i <= noofpages; i++)
                            {
                                if (i != pageid)
                                {
                       
                        %>
                        <a href="<%= AdminBO.GetPagingURL(Request.QueryString,"ShowRequests.aspx", i) %>"
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
                </div>
            </th>
        </tr>
    </table>
    <% if (bfulllist.Count > 0)
       {

           foreach (BookRequest b in blist)
           {
    %>
    <table class="bookrequest" style="border: 1px solid #C0C0C0; background: white; margin: 10px;">
        <tr>
            <td colspan="2" style="padding: 5px; color: #e7710b; font-size: 14px; font-weight: bold">
                <%= b.GetLegString()%>
                <input type="hidden" class="bookid" value="<%= b.BookID %>" />
            </td>
        </tr>
        <tr>
            <td style="padding: 5px; width: 300px; vertical-align: top; padding-right: 20px">
                <table class="bluetable">
                    <tr>
                        <th>
                            Plane Type
                        </th>
                        <td>
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
                            Budget (<%= b.Domain.Currency.ShortName%>)
                        </th>
                        <td>
                            <%= b.FinalBudget%>
                        </td>
                    </tr>
                    <tr>
                        <th>
                            No. of Passengers
                        </th>
                        <td>
                            <%= b.PAX%>
                        </td>
                    </tr>
                    <tr>
                        <th>
                            Request Status
                        </th>
                        <td style="color: #e7710b">
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
                <% IList<OperatorBid> bidlist = BookRequestDAO.GetBidsForRequest(b);
                   ListSet opbids = new ListSet();

                   OperatorBid minbid = null;
                   Currency targetcurr = AdminDAO.GetCurrencyByID("USD");
                   Double minval = double.PositiveInfinity;
                   foreach (OperatorBid ob in bidlist)
                   {
                       if (ob.Operator.Equals(op))
                           opbids.Add(ob);

                       Double temp = ob.Currency.ConvertTo(ob.BidAmount, targetcurr);
                       if (temp < minval)
                       {
                           minval = temp;
                           minbid = ob;
                       }

                   }
                
                %>
                <table class="bluetable" style="margin-top: 15px;">
                    <tr>
                        <th style="color: #e7710b">
                            Total no of bids
                        </th>
                        <td class="totalbids">
                            <%if (bidlist.Count > 0)
                              {
                            %>
                            <%= bidlist.Count%>
                            &nbsp;&nbsp;<a href="ShowBids.aspx?bookid=<%= b.BookID %>&height=300" title="TOTAL BIDS : <%= bidlist.Count %>"
                                class="thickbox">See all</a>
                            <%
                                }
                                else
                                {
                            %>
                            No Bids
                            <%
                                }  %>
                        </td>
                    </tr>
                    <tr>
                        <th style="color: #e7710b">
                            Your bids
                        </th>
                        <td class="yourbids">
                            <% if (opbids.Count > 0)
                               {
                                   foreach (OperatorBid ob in opbids)
                                   {
                            %>
                            <div class="bid">
                                <%= ob.Currency.ShortName + " " + ob.BidAmount%>
                                <div style="margin-bottom: 10px">
                                    <a href="ShowBids.aspx?bidid=<%= ob.BidID %>&bookid=<%= b.BookID %>&height=200&width=300"
                                        title="BID" class="thickbox" style="margin-right: 5px;">Show</a> <a href="EditBid.aspx?bidid=<%= ob.BidID %>&height=300&width=300"
                                            class='thickbox' style="margin-right: 5px;">Change</a> <a href="#" class='small-link removebid'>
                                                Remove</a>
                                    <input type="hidden" class="bidid" value="<%= ob.BidID %>" />
                                </div>
                            </div>
                            <%
                                }
                            }
                            else
                            {
                            %>
                            No Bids
                            <%  
                                } %>
                        </td>
                    </tr>
                    <tr>
                        <th style="color: #e7710b">
                            Current Lowest Bid
                        </th>
                        <td class="lowestbid">
                            <% if (minbid != null)
                               {
                            %>
                            <%= minbid.Currency.ShortName + " " + minbid.BidAmount%>
                            <%
                                  
                                }
                                else
                                {
                            %>
                            No Bids
                            <%  
                                } %>
                        </td>
                    </tr>
                    <tr>
                        <th colspan="2" style="text-align: center">
                            <a href="#" title="Add Bid" class="addbid small-link">Add New Bid</a>
                        </th>
                    </tr>
                </table>
            </td>
            <td style="padding: 5px; vertical-align: top;">
                <%foreach (Leg l in b.Legs)
                  {%>
                <div class="leg">
                    <table class="bluetable">
                        <tr>
                            <th colspan="2">
                                <div class="leghead">
                                    Leg
                                    <%= l.Sequence%>
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
                                    To</div>
                                <div>
                                    <%= l.Destination.GetAirfieldString()%>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <div class="boldtext">
                                    Date</div>
                                <div>
                                    <%= l.Date.ToShortDateString()%>
                                </div>
                            </td>
                            <td>
                                <div class="boldtext">
                                    Time</div>
                                <div>
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
    <table style="border: 1px solid #C0C0C0; background: white; margin: 30px 5px 5px 5px;
        width: 850px">
        <tr>
            <td style="text-align: center">
                No Requests found.
            </td>
        </tr>
    </table>
    <%
        }
    %>
    <div style="display: none" id="ModalWindow">
        <form id="bidform">
            <table class="bluetable" style="margin-top: 20px;">
                <tr>
                    <th>
                        Select Aircraft
                    </th>
                    <td>
                        <input type="hidden" name="bookid" />
                        <input type="hidden" name="opid" value="<%= op.OperatorId %>" />
                        <select name="aircraftlist">
                            <%foreach (Airplane a in op.Aircrafts)
                              {
                          
                            %>
                            <option value="<%= a.AircraftId %>">
                                <%= a.AircraftName +"("+a.AircraftLocation+")" %>
                            </option>
                            <%
                                }  %>
                        </select>
                    </td>
                </tr>
                <tr>
                    <th>
                        Currency
                    </th>
                    <td>
                        <select name="currency">
                            <%  foreach (Currency c in AdminDAO.GetCurrencies())
                                {
                               
                            %>
                            <option value="<%= c.ID %>">
                                <%= c.FullName +"("+ c.ID+")"%>
                            </option>
                            <%
               
                                } %>
                        </select>
                    </td>
                </tr>
                <tr>
                    <th>
                        Bid Amount
                    </th>
                    <td>
                        <input type="text" name="bidamount" />
                    </td>
                </tr>
                <tr>
                    <th>
                        Additional Details
                    </th>
                    <td>
                        <textarea name="additionaldetails" rows="4" cols="20"></textarea>
                    </td>
                </tr>
                <tr>
                    <th colspan="2">
                        <input type="submit" value="Save" class="buttons" style="width: 100px" />
                        <span id="status"></span>
                    </th>
                </tr>
            </table>
        </form>
    </div>
</asp:Content>
