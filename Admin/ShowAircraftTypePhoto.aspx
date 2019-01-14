<%@ Page Language="C#" AutoEventWireup="true" CodeFile="ShowAircraftTypePhoto.aspx.cs"
    Inherits="Admin_ShowAircraftTypePhoto" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title></title>
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
    <link rel="stylesheet" type="text/css" media="screen" href="../css/swf.css" />

    <script type="text/javascript" src="../scripts/global.js"></script>

    <script type="text/javascript" src="../scripts/swfscript.js"></script>

    <% String aid = Request.Params.Get("atypeid");  %>

    <script type="text/javascript">
    $(document).ready(function() {
	var settings = {
				flash_url : "../scripts/swfupload.swf",
				upload_url: "UpdateAircraftImages.ashx",
				 post_params : {
                    "atypeid" : "<%= aid %>","addaircrfttypephoto":"1","ASPSESSID":"<%= Session.SessionID %>","AUTHID" : "<% = Request.Cookies[FormsAuthentication.FormsCookieName]==null ?"" : Request.Cookies[FormsAuthentication.FormsCookieName].Value %>"
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
		location.reload();
		
	}
}



});

    
    </script>

</head>
<body>
    <form id="form1" action="UpdateAircraftImages.ashx" style="margin-top: 15px" method="post"
        enctype="multipart/form-data">
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
    <img src="../images/<%= aid %>.jpeg" style="margin-top: 20px;" />
</body>
</html>
