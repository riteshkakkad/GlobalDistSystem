<%@ Page Language="C#" AutoEventWireup="true" CodeFile="EditBid.aspx.cs" Inherits="Operators_EditBid" %>
<%@ Import Namespace="Entities" %>
<%@ Import Namespace="DataAccessLayer" %>
<%@ Import Namespace="BusinessLayer" %>
<%@ Import Namespace="System.Collections" %>
<%@ Import Namespace="System.Collections.Generic" %>
<%@ Import Namespace="System.Collections.Specialized" %>
<%@ Import Namespace="Iesi.Collections" %>
<%@ Import Namespace="NHibernate" %>

<% Operator op = OperatorBO.GetLoggedinOperator();
   OperatorBid ob = BookRequestDAO.GetOperatorBidByID(Int64.Parse(Request.Params.Get("bidid")));
   
      %>
      <script type="text/javascript">
       addhandlers();
      </script>
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
                        <%foreach (Airplane a in op.Aircrafts)
                          {
                              Boolean temp = false;
                              if(ob.Aircraft.Equals(a))
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

