<%@ Page Language="C#" MasterPageFile="~/Admin/AdminMaster.master" AutoEventWireup="true"
    CodeFile="Settings.aspx.cs" Inherits="Settings" Title="Untitled Page" %>

<%@ Import Namespace="Entities" %>
<%@ Import Namespace="DataAccessLayer" %>
<%@ Import Namespace="BusinessLayer" %>
<%@ Import Namespace="System.Collections" %>
<%@ Import Namespace="System.Text" %>
<%@ Import Namespace="System.IO" %>
<%@ Import Namespace="Iesi.Collections" %>
<%@ Import Namespace="Helper" %>
<%@ Import Namespace="System.Xml" %>
<asp:Content ID="Content1" ContentPlaceHolderID="scriptholder" runat="Server">
    <style type="text/css">
.option
{
 width:200px;
}

</style>
   

    <script type="text/javascript">
$(document).ready(function(){

$("#adminemailsettings").submit(function(){

       $.ajax({
                'url': 'UpdateSettings.ashx',
                'data': $(this).serialize()+"&setadminemails=1",
                'dataType': 'text',
                'type': 'POST',
                'beforeSend':function(){
                
                  $("#adminemailsettings .status").html("<img src='../images/loadingAnimation.gif' />");
                  
                },
                'success': function(data) {
               
                  $("#adminemailsettings .status").html("Saved"); 
               
                }
                
            });

return false;
});
$("#contactnoform").submit(function(){

       $.ajax({
                'url': 'UpdateSettings.ashx',
                'data': $(this).serialize()+"&setcontactnos=1",
                'dataType': 'text',
                'type': 'POST',
                'beforeSend':function(){
                
                  $("#contactnoform .status").html("<img src='../images/loadingAnimation.gif' />");
                  
                },
                'success': function(data) {
               
                  $("#contactnoform .status").html("Saved"); 
               
                }
                
            });

return false;
});
 $("#contactnoform select[name=country]").change(function(){
 
   var country=$(this).val();
   $("#contactnoform .loading").html("");
 
   $.ajax({
                'url': 'UpdateSettings.ashx',
                'data': "country="+country+"&getcontactnos=1",
                'dataType': 'text',
                'type': 'POST',
                'beforeSend':function(){
                
                  $("#contactnoform .loading").html("Loading....");
                  
                },
                'success': function(data) {
                
                   $("#contactnoform .loading").html("Loaded.");
                   $("#contactnoform input[name=contactnos]").val(data);                
                 
                
                }
                
            });
 
 });
$("#contactnoform select[name=country]").change();
$("#passwordform").submit(function(){
    if(validate($(this)))
    {         
          $.ajax({
                'url': 'UpdateSettings.ashx',
                'data': $(this).serialize()+"&changepassword=1",
                'dataType': 'json',
                'type': 'POST',
                'beforeSend':function(){
                
                  $("#passwordform .status").html("<img src='../images/loadingAnimation.gif' />");
                  
                },
                'success': function(data) {
                
                 if(data['error'])
                 {
                   $("#passwordform .status").html("<span class=errortext>"+data['text']+"</div>");
                   return;
                 }
                 $("#passwordform .required").val("");
                  $("#passwordform .status").html("Password Saved"); 
                 
                
                }
                
            });
           
        }
        
        return false;
    
    
    });
    $("#contentsettings").submit(function(){
    
        setemailcontentrequest($("#contentsettings select[name=country]").val());
    
    return false;
    });
    $("#contentsettings a.makethisdefault").click(function(){
    
         setemailcontentrequest("default");
         return false;
    });
    $("#contentsettings select[name=country]").change(function(){
    
         getemailcontentrequest($(this).val());
         
    });
    $("#contentsettings a.settodefault").click(function(){
    
         getemailcontentrequest("default");
         return false;
    });
$("#marginmodeform").submit(function(){
    
       setmarginmoderequest($("#marginmodeform select[name=country]").val());
    
    return false;
    });
    $("#marginmodeform a.makethisdefault").click(function(){
    
      setmarginmoderequest("default");
      return false;
    
    });
    
    $("#marginmodeform select[name=country]").change(function(){
    
         getmodmarginrequest($(this).val());
         
    });
    $("#marginmodeform a.settodefault").click(function(){
    
         getmodmarginrequest("default");
         return false;
    });
     $("#contentsettings select[name=country]").change();
     $("#marginmodeform select[name=country]").change();
     
     
});


var setemailcontentrequest=function(country){

      var form=$(this);
        var valid=true;
        $("#contentsettings .errortext").remove();
        $("#contentsettings .status").html("");
       $("#contentsettings").find("textarea").each(function(li){
       
         if(jQuery.trim($(this).val())=="")
         {
           $("<div class=errortext>* Field Required</div>").insertAfter($(this));
           valid=false;
         }
       
       });
       if(valid)
       {
       $.ajax({
                'url': 'UpdateSettings.ashx',
                'data': "country="+country+"&pricingdisclaimer="+$("#contentsettings textarea[name=pricingdisclaimer]").val()+"&copyright="+$("#contentsettings textarea[name=copyright]").val()+"&updatecontentsettings=1",
                'dataType': 'text',
                'type': 'POST',
                'beforeSend':function(){
                
                  $("#contentsettings .status").html("<img src='../images/loadingAnimation.gif' />");
                  
                },
                'success': function(data){
                
                   $("#contentsettings .status").html("Details Saved");
                   $("#contentsettings .errortext").remove();            
                 
                
                }
                
            });
            
      }


}


var setmarginmoderequest=function(country)
{
        var form=$(this);
        var valid=true;
       
        $("#marginmodeform .status").html("");
      var margin=$("#marginmodeform input[name=margin]");
      if(isNaN(margin.val()) || Number(margin.val())< 0)
      {
         valid=false;
        alert("invalid margin");
       }
       
      
       if(valid)
       {
       var sendrequesttooperatorval=$("#marginmodeform input[name=sendrequesttooperator]:checked").val();
       var sendbidtocustomerval=$("#marginmodeform input[name=sendbidtocustomer]:checked").val();
       
       
       $.ajax({
                'url': 'UpdateSettings.ashx',
                'data': "country="+country+"&margin="+margin.val()+"&sendrequesttooperator="+sendrequesttooperatorval+"&sendbidtocustomer="+sendbidtocustomerval+"&updatemarginmodesettings=1",
                'dataType': 'text',
                'type': 'POST',
                'beforeSend':function(){
                
                  $("#marginmodeform .status").html("<img src='../images/loadingAnimation.gif' />");
                  
                },
                'success': function(data) {
                
                   $("#marginmodeform .status").html("Details Saved");
                             
                 
                
                }
                
            });
            
      }
    
}
var getmodmarginrequest=function(country)
{
    $("#marginmodeform .status").html("");
    $("#marginmodeform .loading").html("");
  
   $.ajax({
                'url': 'UpdateSettings.ashx',
                'data': "country="+country+"&getmarginmodesettings=1",
                'dataType': 'json',
                'type': 'POST',
                'beforeSend':function(){
                
                  $("#marginmodeform .loading").html("Loading....");
                  
                },
                'success': function(data) {
                
                   $("#marginmodeform .loading").html("Loaded.");
                   $("#marginmodeform input[name=margin]").val(data.margin);
                   if((data.sendrequesttooperator))
                      $("#marginmodeform input[name=sendrequesttooperator]").attr("checked","checked");
                   else
                       $("#marginmodeform input[name=sendrequesttooperator]").removeAttr("checked");
                       
                   if(Boolean(data.sendbidtocustomer))
                      $("#marginmodeform input[name=sendbidtocustomer]").attr("checked","checked");
                   else
                       $("#marginmodeform input[name=sendbidtocustomer]").removeAttr("checked");
                   
                                
               
                
                }
                
            });
}    
var getemailcontentrequest=function(country)
{
    $("#contentsettings .loading").html("");
    $("#contentsettings .errortext").remove();
   $.ajax({
                'url': 'UpdateSettings.ashx',
                'data': "country="+country+"&getcontentsettings=1",
                'dataType': 'json',
                'type': 'POST',
                'beforeSend':function(){
                
                  $("#contentsettings .loading").html("Loading....");
                  
                },
                'success': function(data) {
                
                   $("#contentsettings .loading").html("Loaded.");
                   $("#contentsettings textarea[name=pricingdisclaimer]").val(data['pricingdisclaimer']);
                   $("#contentsettings textarea[name=copyright]").val(data['copyright']);                
                 
                
                }
                
            });
}    
var validate=function(form)
{
  $(form).find(".errortext").remove();
      $(form).find(".status").html("");
        var valid=true;
        $(form).find(".required").each(function(i){
         if($(this).val()=="")
         {
           $("<div class=errortext>* Field Required</div>").insertAfter($(this));
           valid=false;
         }
        
        });
       $(form).find(".email").each(function(i){
       
             var temp=true;
             if($(this).val()=="")
                temp=false;
      
            if(!echeck($(this).val()) && temp)
            {
              $("<div class=errortext>* Invalid Email</div>").insertAfter($(this));
              valid=false;
            }
       
       });
       if($(form).attr("id")=="passwordform")
       {
        if($("input[name=newpassword]").val()!=$("input[name=confirmnewpassword]").val())
        {
         $("#passwordform .status").html("<span class=errortext>* Password mismatch</span>");
          valid=false;
        }
       }
       
       
     return valid;   
        
          
                
          
}    
    </script>

</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="contentholder" runat="Server">
    <%
        XmlDocument doc = new XmlDocument();
        doc.Load(Server.MapPath("~/RequestResolveSettings.xml"));
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
    <form id="marginmodeform">
        <table class="bluetable" style="margin: 20px; margin-left: auto; margin-right: auto;
            width: 500px">
            <tr>
                <th style="color: #e7710b;">
                    Country
                </th>
                <td>
                    <select name="country">
                        <option value="default" selected>Default</option>
                        <%  foreach (Country c in OperatorDAO.GetCountriesWithCurrency())
                            {
                                String cid = c.CountryID;
                        %>
                        <option value="<%= cid %>">
                            <%= c.FullName%>
                            (<%= c.CountryID %>)</option>
                        <%
               
                            } %>
                    </select>
                    <span class='loading' style='margin-left: 10px'></span>
                    <br />
                    <a href="#" class="settodefault" style="margin-right: 10px">Load Default</a><a href="#"
                        class="makethisdefault">Make this default</a>
                </td>
            </tr>
            <tr>
                <th style="color: #e7710b;">
                    Set Margin Percentage
                </th>
                <td>
                    <input type="text" name="margin" />
                </td>
            </tr>
            <tr>
                <th style="color: #e7710b;">
                    Set Mode
                </th>
                <td>
                    <input type="checkbox" name="sendrequesttooperator" />
                    <span>Send requests to operators automatically</span>
                    <br />
                    <br />
                    <input type="checkbox" name="sendbidtocustomer" />
                    <span>Send bids to customer directly</span>
                </td>
            </tr>
            <tr>
                <th colspan="2">
                    <input type="submit" value="Save" class="buttons" name="savemargin" />
                    <span class="status"></span>
                </th>
            </tr>
        </table>
    </form>
    <form action="settings.aspx">
        <table class="bluetable" style="width: 600px; margin-left: auto; margin-right: auto">
            <tr>
                <th colspan="2" style="color: #e7710b;">
                    Operator Resolve Settings
                </th>
            </tr>
            <tr>
                <th style="width: 200px">
                    Region match
                </th>
                <td>
                    <table class="noborder">
                        <tr>
                            <td valign="top">
                                <input type="radio" name="regionmatch" value="all" <%= (rmatch_all=="true")?"checked" : ""  %> /></td>
                            <td>
                                Dont match
                            </td>
                        </tr>
                    </table>
                    <table class="noborder">
                        <tr>
                            <td valign="top">
                                <input type="radio" name="regionmatch" value="allinoperatedcountries" <%= (rmatch_allinoperatedcountries=="true")?"checked" : ""  %> /></td>
                            <td>
                                All flying in operator operated countries (includes operator registered country)
                            </td>
                        </tr>
                    </table>
                    <table class="noborder">
                        <tr>
                            <td valign="top">
                                <input type="radio" name="regionmatch" value="startingoperatedcountries" <%= (rmatch_startingoperatedcountries=="true")?"checked" : ""  %> /></td>
                            <td>
                                Flying starts from operator's operated countries (includes operator registered country)
                            </td>
                        </tr>
                    </table>
                    <table class="noborder">
                        <tr>
                            <td valign="top">
                                <input type="radio" name="regionmatch" value="aircraftpresentinstartlocation" <%= (rmatch_aircraftpresentinstartlocation=="true")?"checked" : ""  %> /></td>
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
                                <input type="radio" name="aircraftcategorymatch" value="all" <%= (amatch_all=="true")?"checked" : ""  %> /></td>
                            <td>
                                Dont Match
                            </td>
                        </tr>
                    </table>
                    <table class="noborder">
                        <tr>
                            <td valign="top">
                                <input type="radio" name="aircraftcategorymatch" value="parentmatch" <%= (amatch_parentmatch=="true")?"checked" : ""  %> /></td>
                            <td>
                                Parent category match
                            </td>
                        </tr>
                    </table>
                    <table class="noborder">
                        <tr>
                            <td valign="top">
                                <input type="radio" name="aircraftcategorymatch" value="exactmatch" <%= (amatch_exactmatch=="true")?"checked" : ""  %> /></td>
                            <td>
                                Exact category match
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
            <tr>
                <th colspan="2">
                    <input type="submit" name="settingsbtn" value="Save" class="buttons" />
                    <input type="submit" name="defaultsettingsbtn" value="Set Defaults" class="buttons" />
                </th>
            </tr>
        </table>
    </form>
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
                    Username
                </th>
                <td>
                    <%= AdminBO.GetAdmin().AdminID %>
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
                    <span class="status"></span>
                </th>
            </tr>
        </table>
    </form>
    <form id="contentsettings">
        <table class="bluetable" style="margin: 30px; margin-left: auto; margin-right: auto;
            width: 700px">
            <tr>
                <th colspan="2" style="color: #e7710b;">
                    Content Settings
                </th>
            </tr>
            <tr>
                <th>
                    Select Country<br />
                    (Countries with currencies)
                </th>
                <td>
                    <select name="country">
                        <option value="default" selected>Default</option>
                        <%  foreach (Country c in OperatorDAO.GetCountriesWithCurrency())
                            {
                                String cid = c.CountryID;
                        %>
                        <option value="<%= cid %>">
                            <%= c.FullName%>
                            (<%= c.CountryID %>)</option>
                        <%
               
                            } %>
                    </select>
                    <span class='loading' style='margin-left: 10px'></span>
                </td>
            </tr>
            <tr>
                <th>
                    Pricing Disclaimer
                </th>
                <td>
                    <textarea rows="8" cols="70" name="pricingdisclaimer"></textarea>
                </td>
            </tr>
            <tr>
                <th>
                    Copyright
                </th>
                <td>
                    <textarea rows="8" cols="70" name="copyright">  
                    
                    
                    </textarea>
                    <br />
                    <a href="#" class="settodefault" style="margin-right: 10px">load default</a> <a href="#"
                        class="makethisdefault">Make this default</a>
                </td>
            </tr>
            <tr>
                <th colspan="2">
                    <input type="submit" value="Save" class="buttons" style="width: 100px" />
                    <span class="status"></span>
                </th>
            </tr>
        </table>
    </form>
    <form id="contactnoform">
        <table class="bluetable" style="margin: 30px; margin-left: auto; margin-right: auto;
            width: 700px">
            <tr>
                <th colspan="2" style="color: #e7710b;">
                    Contact Nos
                </th>
            </tr>
            <tr>
                <th>
                    Select Country<br />
                    (Countries with currencies)
                </th>
                <td>
                    <select name="country">
                        <%  foreach (Country c in OperatorDAO.GetCountriesWithCurrency())
                            {
                                String cid = c.CountryID;
                        %>
                        <option value="<%= cid %>">
                            <%= c.FullName%>
                            (<%= c.CountryID %>)</option>
                        <%
               
                            } %>
                    </select>
                    <span class='loading' style='margin-left: 10px'></span>
                </td>
            </tr>
            <tr>
                <th>
                    Contact Nos(comma seperated)
                </th>
                <td>
                    <input type="text" name="contactnos" style="width: 300px" />
                </td>
            </tr>
            <tr>
                <th colspan="2">
                    <input type="submit" value="Save" class="buttons" style="width: 100px" />
                    <span class="status"></span>
                </th>
            </tr>
        </table>
    </form>
    <form id="adminemailsettings">
        <table class="bluetable" style="margin: 30px; margin-left: auto; margin-right: auto;
            width: 700px">
            <tr>
                <th style="color: #e7710b;">
                    Admin Emails(comma seperated)
                </th>
                <td>
                    <textarea name="adminemails" rows="5" cols="50"><%= Default.adminemails %></textarea>
                </td>
            </tr>
            <tr>
                <th colspan="2">
                    <input type="submit" value="Save" class="buttons" style="width: 100px" />
                    <span class="status"></span>
                </th>
            </tr>
        </table>
    </form>
</asp:Content>
