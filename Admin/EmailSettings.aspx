<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/Admin/AdminMaster.master"
    CodeFile="EmailSettings.aspx.cs" Inherits="Admin_EmailSettings" Title="Untitled Page" %>

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
<asp:Content runat="server" ContentPlaceHolderID="scriptholder">
    <link rel="stylesheet" type="text/css" href="http://yui.yahooapis.com/combo?2.7.0/build/assets/skins/sam/skin.css" />

    <script type="text/javascript" src="http://yui.yahooapis.com/combo?2.7.0/build/yahoo-dom-event/yahoo-dom-event.js&2.7.0/build/container/container-min.js&2.7.0/build/element/element-min.js&2.7.0/build/menu/menu-min.js&2.7.0/build/button/button-min.js&2.7.0/build/editor/editor-min.js"></script>

    <script type="text/javascript">
  
var myEditor,myEditorsig;
(function() {
    //Setup some private variables
    var Dom = YAHOO.util.Dom,
        Event = YAHOO.util.Event;

        //The SimpleEditor config
        var myConfig = {
            height: '300px',
            width: '600px',
            dompath: true,
            focusAtStart: true
        };

    //Now let's load the SimpleEditor..
   myEditor = new YAHOO.widget.Editor('email', myConfig);
    myEditor._defaultToolbar.buttonType = 'basic';    
    myEditor.render();
    
      var myConfigsig = {
            height: '150px',
            width: '600px',
            dompath: true,
            focusAtStart: true
        };

    //Now let's load the SimpleEditor..
   myEditorsig = new YAHOO.widget.Editor('signature', myConfigsig);
    myEditorsig._defaultToolbar.buttonType = 'basic';    
    myEditorsig.render();
    myEditorsig.on("afterRender", function(){jQuery("#emailform select[name=emailsetting]").change();jQuery("a.settodefault").click(); }); 
    
    })();
    </script>

    <script type="text/javascript">
$(document).ready(function(){


$("#emailform").submit(function(){

  $("#emailform textarea[name=email]").val(myEditor.getEditorHTML());
  $.ajax({
                'url': 'UpdateSettings.ashx',
                'data': $(this).serialize()+"&setemailcontent=1",
                'dataType': 'text',
                'type': 'POST',
                'beforeSend':function(){
                
                  $("#emailform .status").html("<img src='../images/loadingAnimation.gif' />");
                  
                },
                'success': function(data) {
                
                 
                 $("#emailform .status").html("Saved");
                       
                    
                }
                
            });

return  false;

});

$("#emailform select[name=emailsetting]").change(function(){

$("#emailform .loading").html("");
        $.ajax({
                'url': 'UpdateSettings.ashx',
                'data': "settingid="+$("select[name=emailsetting]").val()+"&getemailcontent=1",
                'dataType': 'json',
                'type': 'POST',
                'beforeSend':function(){
                
                  $("#emailform .loading").html("Loading....");
                  
                },
                'success': function(data) {
                
                  
                   $("#emailform .loading").html("Loaded.");
                    myEditor.setEditorHTML(data['email']);  
                   $("#emailform input[name=subject]").val(data['subject']);
                   if(data['status']=="1")
                       $("#emailform input[name=status]").attr("checked","checked");
                   else
                        $("#emailform input[name=status]").removeAttr("checked");    
                    
                }
                
            });
            

return false;

});



$("#signatureform").submit(function(){
    
  setsignatureajax($("#signatureform select[name=country]").val());
     
    return false;
    });
    $("a.makethisdefault").click(function(){
    
     setsignatureajax("default");
    return false;
    });
    
    $("#signatureform select[name=country]").change(function(){
    
          var successfn=function(data) {
                            $("#signatureform .loading").html("Loaded.");
                            myEditorsig.setEditorHTML(data);                   
                      }
          getsignatureajax($(this).val(),successfn);  
          return false;          
    });

   $("a.settodefault").click(function(){
   
          var successfn=function(data) {
                            $("#signatureform .loading").html("Loaded.");
                            myEditorsig.setEditorHTML(data);                   
                      }
          getsignatureajax("default",successfn); 
          return false; 
   });

});
var setsignatureajax=function(country)
{
      $("#signatureform .status").html("");
    
       $.ajax({
                'url': 'UpdateSettings.ashx',
                'data': "country="+country+"&signature="+myEditorsig.getEditorHTML()+"&updatesignaturecontent=1",
                'dataType': 'text',
                'type': 'POST',
                'beforeSend':function(){
                
                  $("#signatureform .status").html("<img src='../images/loadingAnimation.gif' />");
                  
                },
                'success': function(data) {
                
                   
                   $("#signatureform .status").html("Details Saved");
                             
                 
                
                }
                
            });
}
var getsignatureajax=function(country,successfunction){

        
         $("#signatureform .loading").html("");
         $.ajax({
                'url': 'UpdateSettings.ashx',
                'data': "country="+country+"&getsignaturecontent=1",
                'dataType': 'text',
                'type': 'POST',
                'beforeSend':function(){
                
                  $("#signatureform .loading").html("Loading....");
                 
                },
                'success': successfunction
                
            });

}
    </script>

</asp:Content>
<asp:Content runat="server" ContentPlaceHolderID="contentholder">
    <form id="emailform">
        <table class="bluetable" style="margin: 20px; margin-left: auto; margin-right: auto;
            width: 500px">
            <tr>
                <th style="color: #e7710b;">
                    Email content settings
                </th>
                <td>
                    Select User:
                    <select name="emailsetting" id="emailsetting">
                        <% IList<EmailSetting> elist = AdminDAO.GetEmailSettings();
                           foreach (EmailSetting es in elist)
                           {
                        %>
                        <option value="<%= es.ID %>">
                            <%= es.EmailType %>
                        </option>
                        <%
                            }
                           
                        %>
                    </select>
                    <span class="loading"></span>
                    <br />
                    <table class="noborder">
                        <tr>
                            <th style="border-style: none; background: white;">
                                Place holders
                                <br />
                                Should be used
                                <br />
                                with {{placeholder}}
                            </th>
                            <td>
                                Agent
                                <ul>
                                    <li>Agent-Name</li>
                                    <li>Agent-AgentID</li>
                                    <li>Agent-Agency</li>
                                    <li>Agent-Email</li>
                                    <li>Agent-Password</li>
                                    <li>Agent-ContactNo</li>
                                    <li>Agent-AgentCode</li>
                                    <li>Agent-BillingAddress</li>
                                </ul>
                            </td>
                            <td>
                                Operator
                                <ul>
                                    <li>Operator-OperatorID</li>
                                    <li>Operator-CompanyName</li>
                                    <li>Operator-Email</li>
                                    <li>Operator-Password</li>
                                    <li>Operator-OperatorShortName</li>
                                    <li>Operator-ContactNo</li>
                                    <li>Operator-Address</li>
                                </ul>
                            </td>
                            <td>
                                Customer
                                <ul>
                                    <li>Customer-Email</li>
                                    <li>Customer-ContactNo</li>
                                    <li>Customer-Password</li>
                                    <li>Customer-Name</li>
                                    <li>Customer-CompanyName</li>
                                    <li>Customer-Address</li>
                                </ul>
                            </td>
                            <td>
                                Book Request
                                <ul>
                                    <li>BookRequest-BookID</li>
                                </ul>
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
            <tr>
                <th>
                    Status
                </th>
                <td>
                    <div style="width: 700px">
                        <input type="checkbox" name="status" value="1" /><span style="margin-left: 20px;">Turn
                            On Email</span>
                    </div>
                </td>
            </tr>
            <tr>
                <th>
                    Subject
                </th>
                <td>
                    <div style="width: 700px">
                        <input type="text" style="width: 500px" name="subject" />
                    </div>
                </td>
            </tr>
            <tr>
                <th>
                    Content
                </th>
                <td>
                    <div style="width: 700px">
                        <textarea id="email" name="email">
                        
                        </textarea>
                    </div>
                </td>
            </tr>
            <tr>
                <th colspan="2">
                    <input type="submit" value="Save" class="buttons" name="savecontent" />
                    <span class="status"></span>
                    <div style="text-align: right">
                        <a href="emailsettings.aspx?emailon=1" style="margin-right:15px;">Turn On All Emails</a> <a href="emailsettings.aspx?emailon=0">
                            Turn OFF All Emails</a>
                    </div>
                </th>
            </tr>
        </table>
    </form>
    <form id="signatureform">
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
                </td>
            </tr>
            <tr>
                <th style="color: #e7710b;">
                    Email Signature
                </th>
                <td>
                    <textarea id="signature" name="signature"></textarea>
                    <a href="#" class="settodefault" style="margin-right: 10px">Load Default</a><a href="#"
                        class="makethisdefault">Make this default</a>
                </td>
            </tr>
            <tr>
                <th colspan="2">
                    <input type="submit" value="Save" class="buttons" name="savesignature" />
                    <span class="status"></span>
                </th>
            </tr>
        </table>
    </form>
</asp:Content>
