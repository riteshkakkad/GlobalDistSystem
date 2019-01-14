<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/CharterTemplate.master"
    CodeFile="OperatorRegister.aspx.cs" Inherits="OperatorRegister" %>

<%@ Import Namespace="Entities" %>
<%@ Import Namespace="DataAccessLayer" %>
<%@ Import Namespace="BusinessLayer" %>
<%@ Import Namespace="System.Collections" %>
<%@ Import Namespace="System.Collections.Generic" %>
<%@ Import Namespace="Iesi.Collections" %>
<%@ Import Namespace="NHibernate" %>
<asp:Content runat="server" ContentPlaceHolderID="scriptholder">
    <style type="text/css">
input,textarea
{
 width:220px;
 padding:2px 5px;

}
.errorelem
{
 border:1px solid #e7710b;


}
.errortext
{
 color:#e7710b;
}
</style>

    <script type="text/javascript">
    
    $(document).ready(function(){
    
    $("#OperatorForm input[type=button]").click(function(){
    
    if(validate())
    {
      $.ajax({
            'url': 'UpdateRegistration.ashx',
            'data': $("#OperatorForm").serialize()+"&operatoradd=1",
            'dataType': 'json',
            'type': 'POST',
            'beforeSend':function(){
            
              $("#loading").html("<img src='images/loadingAnimation.gif' />");
              $("#Status").hide().html("");
              
            },
            'success': function(data) {
            
               if(data['success'])
                {
                  $("#loading").html("");
                  $("#Status").show().html(data['text']);
                  
                  $("#OperatorForm input[type=text],#OperatorForm input[type=password],#OperatorForm textarea").val("");
                 
                  $("#OperatorForm input[type=checkbox]").removeAttr("checked");
                  $("select[name=countries]").children("option").removeAttr('selected');
                  scrollTo("#contentsection");
                  
                }
                else
                {
                 $("#loading").html(data['text']);
                 $("#Status").hide().html("");
                }
                
                 
            }
            });
    }  
    return false;
    });
    
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
    
    });
    
var validate=function(){
 
 var valid=true;
    $(".required,.number").removeClass("errorelem");
    $("div.errortext").remove();
    $(".required").each(function(i){
    
     if($(this).val()=="")
      {
       valid=false;
       if($(this).parents("td:eq(0)").find("div.errortext").size()==0)
         $(this).parents("td:eq(0)").append($("<div class='errortext'>* Required.</div>"));
       
       $(this).addClass('errorelem');
      }
    
    });
    $(".number").each(function(){
    
     if($(this).val()!="" && isNaN($(this).val()))
      {
        
         valid=false;
          if($(this).parents("td:eq(0)").find("div.errortext:contains('Number')").size()==0)
                $(this).parents("td:eq(0)").append($("<div class='errortext'>* Number Required.</div>"));
         
         $(this).addClass('errorelem');
       }
    
    });
    $(".email").each(function(index){
    var temp=true;
    if($(this).val()=="")
     temp=false;
      
    if(!echeck($(this).val()) && temp)
      {
        valid=false;
          if($(this).parents("td:eq(0)").find("div.errortext").size()==0)
                $(this).parents("td:eq(0)").append($("<div class='errortext'>* Invalid Email.</div>"));
         
         $(this).addClass('errorelem');
       }
          
    });
    
    if($("#Password").val()!=$("#Confirm").val())
     {  
        valid=false;
        $("<div class='errortext'>* Password Mismach.</div>").insertAfter($("#Password"));
     }
     
   if(valid==false)
        scrollTo($("div.errortext:first").parents("td:eq(0)")); 
         
   return valid;
  
 }   
    </script>

</asp:Content>
<asp:Content runat="server" ContentPlaceHolderID="contentholder">
    <div id="Status" style="border: solid 1px #e7710b; padding: 15px; text-align: center;font-size:12px;
        width: 600px; margin-left: auto; margin-right: auto; display: none; margin-bottom: 10px;background:white">
    </div>
    <form id="OperatorForm" action="operatorregister.aspx" method="post">
        <table class="bluetable" style="width: 700px; margin-left: auto; margin-right: auto;">
            <tr>
                <th colspan="2" style="color: #e7710b;">
                    Operator Registration
                </th>
            </tr>
            <tr>
                <th>
                    Company Name
                </th>
                <td>
                    <input id="OperatorName" name="OperatorName" type="text" class="required" />
                </td>
            </tr>
            <tr>
                <th>
                    Login Email
                </th>
                <td>
                    <input id="Email" name="Email" type="text" class="required email" />
                </td>
            </tr>
            <tr>
                <th>
                    Password
                </th>
                <td>
                    <input id="Password" name="Password" type="password" class="required" />
                </td>
            </tr>
            <tr>
                <th>
                    Confirm Password
                </th>
                <td>
                    <input id="Confirm" name="Confirm" type="password" class="required" />
                </td>
            </tr>
            <tr>
                <th>
                    Contact No.
                </th>
                <td>
                    <input id="ContactNo" name="ContactNo" type="text" class="required" />
                </td>
            </tr>
            <tr>
                <th>
                    Address
                </th>
                <td>
                    <textarea id="Address" name="Address" cols="20" class="required"></textarea>
                </td>
            </tr>
            <tr>
                <th>
                    Country
                </th>
                <td>
                    <select name="country">
                        <%  foreach (Country c in OperatorDAO.GetCountries())
                            {
                        %>
                        <option value="<%= c.CountryID %>">
                            <%= c.FullName%>
                        </option>
                        <%
               
                            } %>
                    </select>
                </td>
            </tr>
            <tr>
                <th>
                    Alternate Email(optional)
                </th>
                <td>
                    <input id="AlternateEmail" name="AlternateEmail" type="text" class="email" />
                </td>
            </tr>
            <tr>
                <th>
                    Alternate Contact No.(optional)
                </th>
                <td>
                    <input id="AlternateContactNo" name="AlternateContactNo" type="text" />
                </td>
            </tr>
            <tr>
                <th>
                    Certificate
                </th>
                <td>
                    <input id="NSOPRegNo" name="NSOPRegNo" type="text" class="required" />
                </td>
            </tr>
            <tr>
                <th>
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
                            %>
                            <option cont="<%= c.Continent %>" value="<%= c.CountryID %>">
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
                   
                    <input type="button" name="registerbtn" value="Register" class="buttons" style="width: 150px;" />
                    <span id="loading" class="errortext"></span>
                </th>
            </tr>
        </table>
    </form>
</asp:Content>
