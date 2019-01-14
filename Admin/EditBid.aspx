<%@ Page Language="C#" AutoEventWireup="true" CodeFile="EditBid.aspx.cs" Inherits="Admin_EditBid" %>

<%@ Import Namespace="Entities" %>
<%@ Import Namespace="DataAccessLayer" %>
<%@ Import Namespace="BusinessLayer" %>
<%@ Import Namespace="System.Collections" %>
<%@ Import Namespace="System.Collections.Generic" %>
<%@ Import Namespace="System.Collections.Specialized" %>
<%@ Import Namespace="Iesi.Collections" %>
<%@ Import Namespace="NHibernate" %>
<% 
    if (Request.Params.Get("editbid") != null)
    {
        OperatorBid ob = BookRequestDAO.GetOperatorBidByID(Int64.Parse(Request.Params.Get("bidid")));
   
%>
<form id="updatebidform">
    <table class="bluetable" style="margin-top: 20px;">
        <tr>
            <th>
                Select Aircraft
            </th>
            <td>
                <input type="hidden" name="bidid" value="<%= ob.BidID %>" />
                <input type="hidden" name="bookid" value="<%= ob.Request.BookID %>" />
                <select name="aircraftlist">
                    <%foreach (Airplane a in ob.Aircraft.Vendor.Aircrafts)
                      {
                          Boolean temp = false;
                          if (ob.Aircraft.Equals(a))
                          {
                              temp = true;
                          }
                    %>
                    <option value="<%= a.AircraftId %>" <%= (temp)?"selected":"" %>>
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
                            Boolean temp = false;
                            if (ob.Currency.Equals(c))
                            {
                                temp = true;
                            }
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
                Bid Amount
            </th>
            <td>
                <input type="text" name="bidamount" value="<%= ob.BidAmount %>" />
            </td>
        </tr>
        <tr>
            <th>
                Final Bid
            </th>
            <td>
                <input type="text" name="finalbidamount" value="<%= ob.FinalBidAmount %>" />
            </td>
        </tr>
        <tr>
            <th>
                Additional Details
            </th>
            <td>
                <textarea name="additionaldetails" rows="4" cols="20"><%= ob.AdditionalDetails %></textarea>
            </td>
        </tr>
        <tr>
            <th colspan="2">
                <input type="submit" value="Save" class="buttons" style="width: 100px" />
                <span id="updatestatus"></span>
            </th>
        </tr>
    </table>
</form>

<script type="text/javascript">
$("#updatebidform").submit(function(){
     
     var request=$("input[value="+$(this).find("input[name=bookid]").val()+"].bookid").parents("table.bookrequest:eq(0)");
     $.ajax({
            'url': 'UpdateBookRequests.ashx',
            'data': $(this).serialize()+"&updatebid=1",
            'dataType': 'text',
            'type': 'POST',
            'beforeSend':function(){
            
              $("#updatestatus").html("<img src='../images/loadingAnimation.gif' />");
              
            },
            'success': function(data) {
             
             $("#updatestatus").html("Saved");
             $(request).find("a.getoperatorbids").click();
            
            }
            
            });
    return false;
 
 });

</script>

<%}
  else if (Request.Params.Get("addbid") != null)
  {
%>
<form id="addnewbid">
    <table class="bluetable" style="margin-top: 20px;">
        <tr>
            <th>
                Select Operator - Aircraft
                <% IList<Operator> oplist = OperatorDAO.GetOperatorRequests(BookRequestDAO.FindBookRequestByID(Int64.Parse(Request.Params.Get("bookid")))); %>
                <% ListSet aircrafts = new ListSet();
                   foreach (Operator op in oplist)
                   {
                       aircrafts.AddAll(op.Aircrafts);
                   }
                %>
            </th>
            <td>
                <input type="hidden" name="bookid" value="<%= Request.Params.Get("bookid") %>" />
                <select name="aircraftlist">
                    <%foreach (Airplane a in aircrafts)
                      {
                          
                    %>
                    <option value="<%= a.AircraftId %>">
                        <%= a.Vendor.CompanyName + " - "+ a.AircraftName +"("+a.AircraftLocation+")" %>
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
                <span id="addnewstatus"></span>
            </th>
        </tr>
    </table>
</form>

<script type="text/javascript">
$("#addnewbid").submit(function(){
     
     var request=$("input[value="+$(this).find("input[name=bookid]").val()+"].bookid").parents("table.bookrequest:eq(0)");
     $.ajax({
            'url': 'UpdateBookRequests.ashx',
            'data': $(this).serialize()+"&addbid=1",
            'dataType': 'text',
            'type': 'POST',
            'beforeSend':function(){
            
              $("#addnewstatus").html("<img src='../images/loadingAnimation.gif' />");
              
            },
            'success': function(data) {
             
             $("#addnewstatus").html("Saved");
             $(request).find("a.getoperatorbids").click();
            
            }
            
            });
    return false;
 
 });

</script>

<%
    }
%>
