<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Photos.aspx.cs" Inherits="Operators_Photos" %>

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
    <style type="text/css">
.bluetable
{
 border: 1px solid #c0c0c0;
 border-spacing: 0px; 
 border-collapse: collapse;
}
.bluetable th
{
 background:#f8f8f8;
 padding:10px;
 color: #707070; 
 border-bottom:1px solid #c0c0c0;
 border-right:1px solid #c0c0c0;


} 
.bluetable td
{
 background:white;
 padding:10px;
 border-bottom:1px solid #c0c0c0;
 border-right:1px solid #c0c0c0;

 vertical-align:top;

}    

    
    </style>
       <script type="text/javascript" src="../scripts/global.js"></script>
    <link rel="stylesheet" type="text/css" media="screen" href="../css/swf.css" />

   <script type="text/javascript" src="../scripts/swfscript.js"></script>

    <% String aid = Request.Params.Get("aid");  %>

    <script type="text/javascript">
    $(document).ready(function() {
	var settings = {
				flash_url : "../scripts/swfupload.swf",
				upload_url: "UpdateAircraftImages.ashx",
				 post_params : {
                    "aid" : "<%= aid %>","addphoto":"1","ASPSESSID":"<%= Session.SessionID %>","AUTHID" : "<% = Request.Cookies[FormsAuthentication.FormsCookieName]==null ?"" : Request.Cookies[FormsAuthentication.FormsCookieName].Value %>"
                },
				file_size_limit : "100 MB",
				file_types : "*.*",
				file_types_description : "All Files",
				file_upload_limit : 100,
				file_queue_limit : 0,
				custom_settings : {
					progressTarget : "fsUploadProgress",
					cancelButtonId : "btnCancel"
				},
				debug: false,

				// Button settings
			    button_image_url : "../swfimages/blankButton.png",
				button_placeholder_id : "spanButtonPlaceHolder",
				button_width: 110,
				button_height: 22,
				button_text : '<span class="button1">Select Images</span>',
				button_text_style : '.button1 { font-family: Helvetica, Arial, sans-serif; font-size: 14pt; } .buttonSmall { font-size: 10pt; }',
				button_text_top_padding: 1,
				button_text_left_padding: 5,
				
				// The event handler functions are defined in handlers.js
				file_queued_handler : fileQueued,
				file_queue_error_handler : fileQueueError,
				file_dialog_complete_handler : fileDialogComplete,
				upload_start_handler : uploadStart,
				upload_progress_handler : uploadProgress,
				upload_error_handler : uploadError,
				upload_success_handler : uploadSuccess,
				upload_complete_handler : uploadFullComplete,
				queue_complete_handler : queueComplete	// Queue plugin event
			};

			swfu = new SWFUpload(settings);
	function uploadFullComplete(file) {
	if (this.getStats().files_queued === 0) {
		document.getElementById(this.customSettings.cancelButtonId).disabled = true;
		location.href="Photos.aspx?aid=<%= aid %>";
		
	}
}

$(".removephoto").click(function(){

if(!confirm("Are you sure?"))
  return false;

});

$("input[name=displaystatus]").click(function(){

  $(".status").remove();
  var target=$(this).parents("td:eq(0)"); 
  var id=parseInt($(this).parents("tr:eq(0)").attr("id"));
             $.ajax({
                'url': 'UpdateAircraftImages.ashx',
                'data': "pid="+id+"&setdisplaystatus=1",
                'dataType': 'text',
                'type': 'POST',
                'beforeSend':function(){
                
                 $(target).append("<div class=status>Saving...</div>");
                  
                },
                'success': function(data) {
                                
                  $(".status").remove();
                  $(target).append("<div class=status>Saved</div>");
                           
                }
                
                });


});

$("input[name=savecaption]").click(function(){
     
     var id=parseInt($(this).parents("tr:eq(0)").attr("id"));
     
     var caption=$(this).siblings("textarea[name=caption]:eq(0)").val();
     var target=$(this);
     
     $.ajax({
                'url': 'UpdateAircraftImages.ashx',
                'data': "pid="+id+"&caption="+caption+"&savecaption=1",
                'dataType': 'text',
                'type': 'POST',
                'beforeSend':function(){
                
                 $("<div class=status>Saving...</div>").insertAfter($(target));
                  
                },
                'success': function(data) {
                                
                  $(".status").remove();
                 $("<div class=status>Saved</div>").insertAfter($(target));
                 $(target).parents("tr:eq(0)").find("div.caption").html(caption);
                           
                }
                
                });
     

});
});
    
    </script>

</head>
<body>
    <% Airplane a = OperatorDAO.FindAircraftByID(Int64.Parse(aid)); %>
    <form id="form1" action="UpdateAircraftImages.ashx" style="margin-top:15px" method="post" enctype="multipart/form-data">
        <div class="fieldset flash" id="fsUploadProgress">
            <span class="legend">Upload Queue</span>
        </div>
        <div id="divStatus">
        </div>
        <div>
            <span id="spanButtonPlaceHolder"></span>
            <input id="btnCancel" type="button" value="Cancel All Uploads" onclick="swfu.cancelQueue();"
                disabled="disabled" style="margin-left: 2px; font-size: 8pt;" />
        </div>
    </form>
    <table class="bluetable" style="margin-top: 30px;width:400px;margin-left:auto;margin-right:auto">
        <% if (a.PhotoList.Count > 0)
           {
               foreach (AircraftPhoto p in a.PhotoList)
               {
                   Boolean temp = p.DisplayPic;
        %>
        <tr id="<%= p.PhotoID %>Photo">
           <td style="text-align:center">
                <img src="../GetThumbnailAircraftImage.ashx?pid=<%= p.PhotoID %>" alt="No pic" />
                <div class="caption" style="text-align:center">
                    <%= p.Caption %>
                </div>
                <div style="margin-top: 5px;">
                    <input type="radio" name="displaystatus" <%= (temp)?"checked":"" %> value="<%= p.PhotoID %>Display" />
                    <span>Display pic</span>
                </div>
            </td>
            <td>
                
                <span>Edit Caption</span>
                <div>
                <textarea name="caption" rows="4" cols="15"><%= p.Caption %></textarea>
                <br />
                <input type="button" name="savecaption" value="Save" />
                </div>
                <a href="updateaircraftimages.ashx?removephoto=1&pid=<%= p.PhotoID %>" class="removephoto"
                    style="color: #e7710b; font-size: 11px">Remove Photo</a>
            </td>
        </tr>
        <% 
            }
        }
        else
        {
        %>
        <tr>
            <td colspan="2">
                No pics uploaded.
            </td>
        </tr>
        <%
            } %>
    </table>
</body>
</html>
