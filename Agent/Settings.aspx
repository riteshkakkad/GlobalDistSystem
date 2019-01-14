<%@ Page Language="C#" MasterPageFile="~/CharterTemplate.master" AutoEventWireup="true" CodeFile="Settings.aspx.cs" Inherits="Agent_Settings" Title="Untitled Page" %>
<%@ Import Namespace="Entities" %>
<%@ Import Namespace="DataAccessLayer" %>
<%@ Import Namespace="BusinessLayer" %>
<%@ Import Namespace="System.Collections" %>
<%@ Import Namespace="System.Collections.Generic" %>
<%@ Import Namespace="System.Collections.Specialized" %>
<%@ Import Namespace="Iesi.Collections" %>
<%@ Import Namespace="NHibernate" %>
<asp:Content ID="Content1" ContentPlaceHolderID="scriptholder" Runat="Server">

    <script type="text/javascript">
$(document).ready(function(){

 
    
    $("#passwordform").submit(function(){
      $("#status").html("");
      $("#passwordform .error").remove();
        var valid=true;
        $("#passwordform .required").each(function(i){
         if($(this).val()=="")
         {
           $("<div class=error>* Field Required</div>").insertAfter($(this));
           valid=false;
         }
        
        });
        
        if(!valid)
          return false;
          
        if($("input[name=newpassword]").val()!=$("input[name=confirmnewpassword]").val())
        {
          $("#status").html("<span class=error>* Password mismatch</span>");
          valid=false;
        }
       
        if(!valid)
          return false;
          
          
         
         if(valid)
         {
             $.ajax({
                'url': 'UpdateSettings.ashx',
                'data': $(this).serialize()+"&changepassword=1",
                'dataType': 'json',
                'type': 'POST',
                'beforeSend':function(){
                
                  $("#status").html("<img src='../images/loadingAnimation.gif' />");
                  
                },
                'success': function(data) {
                
                 
                 if(data['error'])
                 {
                   $("#status").html("<span class=error>"+data['text']+"</div>");
                   return;
                 }
                 $("#passwordform .required").val("");
                  $("#status").html("Password Saved"); 
                 
                
                }
                
                });
            }
        
        return false;
    
    
    });

   $("#profileform").submit(function(){
        
      $("#profileform .error").remove();
      $("#profilestatus").html("");
        var valid=true;
        $("#profileform .required").each(function(i){
         if($(this).val()=="")
         {
           $("<div class=error>* Field Required</div>").insertAfter($(this));
           valid=false;
         }
        
        });
       $("#profileform .email").each(function(i){
       
             var temp=true;
             if($(this).val()=="")
                temp=false;
      
            if(!echeck($(this).val()) && temp)
            {
              $("<div class=error>* Invalid Email</div>").insertAfter($(this));
              valid=false;
            }
       
       });
       
        
        if(!valid)
          return false;
          
                
          
         
         if(valid)
         {
             $.ajax({
                'url': 'UpdateSettings.ashx',
                'data': $(this).serialize()+"&editprofile=1",
                'dataType': 'json',
                'type': 'POST',
                'beforeSend':function(){
                
                  $("#profilestatus").html("<img src='../images/loadingAnimation.gif' />");
                  
                },
                'success': function(data) {
                                
                  if(data['error'])
                  {
                   $("#profilestatus").html("<span class=error>"+data['text']+"</span>"); 
                  }
                  $("#profilestatus").html("Saved"); 
                           
                }
                
                });
            }
        
        return false;
    
    
    });
    });

    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="contentholder" Runat="Server">
 <% Agent a = AgentBO.GetLoggedInAgent(); %>
    <form id="passwordform">
        <table class="bluetable" style="margin: 20px; margin-left: auto; margin-right: auto;
            width: 500px">
            <tr>
                <th colspan="2" style="color: #e7710b;">
                    Change Password
                </th>
            </tr>
            <tr>
                <th>
                    Login Email
                </th>
                <td>
                    <%= a.Email %>
                </td>
            </tr>
            <tr>
                <th>
                    Old Password
                </th>
                <td>
                    <input type="password" name="oldpassword" class="required" />
                </td>
            </tr>
            <tr>
                <th>
                    New Password
                </th>
                <td>
                    <input type="password" name="newpassword" class="required" />
                </td>
            </tr>
            <tr>
                <th>
                    Confirm New Password
                </th>
                <td>
                    <input type="password" name="confirmnewpassword" class="required" />
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
    <form id="profileform">
        <table class="bluetable" style="margin: 20px; margin-left: auto; margin-right: auto;
            width: 600px">
            <tr>
                <th colspan="2" style="color: #e7710b;">
                    Edit Profile
                </th>
            </tr>
            <tr>
                <th valign="top">
                    Agent Name
                </th>
                <td>
                    <input id="AgentName" name="AgentName" type="text" class="required" value="<%= a.Name %>" />
                </td>
            </tr>
            <tr>
                <th valign="top">
                    Agency Name
                </th>
                <td>
                    <input  name="AgencyName" type="text" class="required" value="<%= a.Agency %>" />
                </td>
            </tr>
            <tr>
                <th valign="top">
                    Contact No.
                </th>
                <td>
                    <input id="ContactNo" name="ContactNo" type="text" class="required" value="<%= a.ContactNo %>" />
                </td>
            </tr>
            <tr>
                <th valign="top">
                   Billing Address
                </th>
                <td>
                    <textarea id="Address" name="Address" cols="20" class="required"><%= a.BillingAddress %></textarea>
                </td>
            </tr>
            <tr>
                <th valign="top">
                    Country
                </th>
                <td>
                    <select name="country">
                        <%  foreach (Country c in OperatorDAO.GetCountries())
                            {

                                Boolean temp = false;
                                if (a.Country.Equals(c.CountryID))
                                    temp = true;
                        %>
                        <option value="<%= c.CountryID %>" <%= (temp)?"selected" :"" %>>
                            <%= c.FullName %>
                        </option>
                        <%
               
                            } %>
                    </select>
                </td>
            </tr>
            <tr>
                <th valign="top">
                    Alternate Email(optional)
                </th>
                <td>
                    <input id="AlternateEmail" name="AlternateEmail" type="text" class="email" value="<%= a.Email1 %>" />
                </td>
            </tr>
            <tr>
                <th valign="top">
                    Alternate Contact No.(optional)
                </th>
                <td>
                    <input id="AlternateContactNo" name="AlternateContactNo" type="text" value="<%= a.ContactNo1 %>" />
                </td>
            </tr>
            <tr>
                <th valign="top">
                   Fax(Optional)
                </th>
                <td>
                    <input id="Fax" name="Fax" type="text" value="<%= a.AgentFax %>" />
                </td>
            </tr>
           
            <tr>
                <th colspan="2">
                    <input type="submit" value="Save" class="buttons" style="width: 100px" />
                    <span id="profilestatus"></span>
                </th>
            </tr>
        </table>
    </form>
</asp:Content>

