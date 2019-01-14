<%@ Page Language="C#" AutoEventWireup="true" CodeFile="BroadcastEmptyLegs.aspx.cs"
    Inherits="Admin_BroadcastEmptyLegs" %>

<%@ Import Namespace="Entities" %>
<%@ Import Namespace="DataAccessLayer" %>
<%@ Import Namespace="BusinessLayer" %>
<%@ Import Namespace="System.Collections" %>
<%@ Import Namespace="System.Collections.Generic" %>
<%@ Import Namespace="System.Collections.Specialized" %>
<%@ Import Namespace="Iesi.Collections" %>
<%@ Import Namespace="NHibernate" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>Untitled Page</title>
    <link rel="stylesheet" type="text/css" href="../css/adminlayout.css" />
    <link rel="stylesheet" type="text/css" href="http://yui.yahooapis.com/combo?2.7.0/build/assets/skins/sam/skin.css" />

    <script type="text/javascript" src="../scripts/global.js"></script>

    <script type="text/javascript" src="http://yui.yahooapis.com/combo?2.7.0/build/yahoo-dom-event/yahoo-dom-event.js&2.7.0/build/container/container-min.js&2.7.0/build/element/element-min.js&2.7.0/build/menu/menu-min.js&2.7.0/build/button/button-min.js&2.7.0/build/editor/editor-min.js"></script>

    <script type="text/javascript">
  
var myEditor,myEditorsig;
(function() {
    //Setup some private variables
        var Dom = YAHOO.util.Dom,
        Event = YAHOO.util.Event;
        //The SimpleEditor config
        var myConfig = {
            height: '250px',
            width: '550px',
            dompath: true,
            focusAtStart: true
        };
    //Now let's load the SimpleEditor..
    myEditor = new YAHOO.widget.Editor('email', myConfig);
    myEditor._defaultToolbar.buttonType = 'basic';    
    myEditor.render();
    })();
    </script>

    <script type="text/javascript">
    $(document).ready(function(){
    
    $("#emailform").submit(function(){
        if($.trim($("#emailform textarea[name=tolist]").val())=="" || $.trim($("#emailform input[name=subject]").val())=="")
        {
         alert("Fields required.");
         return false;
        }
       
       $("#emailform textarea[name=email]").val(myEditor.getEditorHTML());
        $.ajax({
                'url': 'UpdateSettings.ashx',
                'data': $("#emailform").serialize()+"&broadcastemptylegs=1",
                'dataType': 'json',
                'type': 'POST',
                'beforeSend':function(){
                
                  $("#emailform .status").html("Loading....");
                  
                },
                'success': function(data) {
                
                   $("#emailform .status").html("Sent");
                
                }
                
                });
        
        
        return false;
    });
        $("#loadcustomers").click(function(){
    
           $.ajax({
                'url': 'UpdateSettings.ashx',
                'data': "loadcustomers=1",
                'dataType': 'json',
                'type': 'POST',
                'beforeSend':function(){
                
                  $("#emailform .loading").html("Loading....");
                  
                },
                'success': function(data) {
                
                   $("textarea[name=tolist]").val(data['emaillist']);
                   $("#emailform .loading").html("Loaded");
                
                }
                
                });
            return false;
    
        });
    });
    </script>

</head>
<body class="yui-skin-sam">
    <% EmptyLeg el = BookRequestDAO.FindEmptyLegByID(Int64.Parse(Request.Params.Get("eid"))); %>
    <% EmailSetting es = AdminDAO.GetEmailSettingByID("EmptyLegBroadCast"); %>
    <form id="emailform" action="broadcastemptylegs.aspx">
        <table class="bluetable" style="margin-left: 20px; margin-top: 20px">
            <input type="hidden" name="eid" value="<%= Request.Params.Get("eid") %>" />
            <tr>
                <th>
                    Customer List <a href="#" id="loadcustomers">Load Customers/Agents</a>
                    <div class="loading">
                    </div>
                </th>
                <td>
                    <textarea name="tolist" rows="4" style="width: 500px">
                    
                    </textarea>
                </td>
            </tr>
            <tr>
                <th>
                    Subject</th>
                <td>
                    <input name="subject" type="text" style="width: 500px" value="<%= es.Subject %>" />
                </td>
            </tr>
            <tr>
                <th>
                    Content</th>
                <td>
                    <textarea id="email" name="email">
                    <%= es.EmailContent %>
                    </textarea>
                </td>
            </tr>
            <tr>
                <th colspan="2">
                    <input type="submit" value="Send" class="buttons" name="sendemptylegs" />
                    <span class="status"></span>
                </th>
            </tr>
        </table>
    </form>
</body>
</html>
