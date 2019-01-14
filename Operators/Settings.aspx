<%@ Page Language="C#" MasterPageFile="~/Operators/OperatorMaster.master" AutoEventWireup="true"
    CodeFile="Settings.aspx.cs" Inherits="Operators_Settings" Title="Untitled Page" %>

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

    addhanlders();
    $("select[name=countries]").change();
    
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
var addhanlders=function(){

    $("select[name=countries]").change(function(){
      
        $("input[class=continents]").each(function(i){
        
           
          var expsize= $("select[name=countries]").children("option[cont="+$(this).val()+"]").size(); 
          var actsize= $("select[name=countries]").children("option[cont="+$(this).val()+"]:selected").size(); 
          if(expsize>actsize)
           $(this).removeAttr("checked");
          else
            $(this).attr("checked","checked");
        });
      
      });
     
     
     $("input[class=continents]").click(function(){
     
         if($(this).is(":checked"))
          {
             $("select[name=countries]").children("option[cont="+$(this).val()+"]").attr('selected','selected');
           
          }
          else
          {
            $("select[name=countries]").children("option[cont="+$(this).val()+"]").removeAttr('selected');

          }
        });


}
    </script>

</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="contentholder" runat="Server">
    <% Operator op = OperatorBO.GetLoggedinOperator(); %>
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
                    <%= op.Email %>
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
                    Company Name
                </th>
                <td>
                    <input id="OperatorName" name="OperatorName" type="text" class="required" value="<%= op.CompanyName %>" />
                </td>
            </tr>
            <tr>
                <th valign="top">
                    Contact No.
                </th>
                <td>
                    <input id="ContactNo" name="ContactNo" type="text" class="required" value="<%= op.ContactNo %>" />
                </td>
            </tr>
            <tr>
                <th valign="top">
                    Address
                </th>
                <td>
                    <textarea id="Address" name="Address" cols="20" class="required"><%= op.Address %></textarea>
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
                                if (op.Country.Equals(c.CountryID))
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
                    <input id="AlternateEmail" name="AlternateEmail" type="text" class="email" value="<%= op.Email1 %>" />
                </td>
            </tr>
            <tr>
                <th valign="top">
                    Alternate Contact No.(optional)
                </th>
                <td>
                    <input id="AlternateContactNo" name="AlternateContactNo" type="text" value="<%= op.ContactNo1 %>" />
                </td>
            </tr>
            <tr>
                <th valign="top">
                    Certificate
                </th>
                <td>
                    <input id="NSOPRegNo" name="NSOPRegNo" type="text" class="required" value="<%= op.NSOPRegNo %>" />
                </td>
            </tr>
            <tr>
                <th valign="top">
                    We Operate in
                </th>
                <td>
                    <div style="float: left; margin-right: 15px;">
                        <%
                            foreach (String s in AdminDAO.GetContinents())
                            { 
                        %>
                        <div>
                            <input type="checkbox" style="width: 15px;" class="continents" value="<%= s %>" /><%= s %></div>
                        <%
                     
                            }
                        %>
                    </div>
                    <div style="float: left">
                        <div>
                            Countries</div>
                        <select name="countries" multiple="multiple" style="height: 200px">
                            <%  foreach (Country c in OperatorDAO.GetCountries())
                                {
                                    Boolean temp = false;
                                    if (op.OperatorCountries.Contains(c.CountryID.Trim()))
                                        temp = true;
                            %>
                            <option cont="<%= c.Continent %>" value="<%= c.CountryID %>" <%= (temp)?"selected" :"" %>>
                                <%= c.FullName%>
                            </option>
                            <%
               
                                } %>
                        </select>
                    </div>
                    <div style="clear: both">
                    </div>
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
