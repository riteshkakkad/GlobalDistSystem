<%@ Page Language="C#" Async="true" AutoEventWireup="true" CodeFile="Test.aspx.cs"
    Inherits="Test" %>

<html>
<head>
    <title></title>
    <style type="text/css">
    #jsddmmenu
{	margin: 0;
	padding: 0}

	#jsddmmenu li
	{	float: left;
		list-style: none;
		}

	#jsddmmenu li a
	{	display: block;		
		padding: 4px;
		text-decoration: none;
		border-top: 1px solid #c0c0c0;
		border-left: 1px solid #c0c0c0;
		border-bottom: 1px solid #c0c0c0;		
		width:120px;
		font-size:13px;
		font-weight:bold;
		text-align:center;		
        font-family:verdana;
		color: white;		
		background-image: url(images/linkbutton.jpg);
		white-space: nowrap}

	#jsddmmenu li a:hover
	{	background: #white;
		color:#e7701b;
		
	    
	}
		
		#jsddmmenu li ul
		{	margin: 0;
			padding: 0;
			position: absolute;
			visibility: hidden;
			
			border-collapse:collapse;
			}
		
			#jsddmmenu li ul li
			{	float: none;
				display: inline}
			
			#jsddmmenu li ul li a
			{	width: auto;
				background-image: url(images/linkbutton.jpg);
				color: white;
				padding:4px;
				border-top-style:none;
				border-left: 1px solid #c0c0c0;
				border-right: 1px solid #c0c0c0;
				
				}
			
			#jsddmmenu li ul li a:hover
			{	background: white;
			    color:#e7701b;
			    }
    
    </style>

    <script type="text/javascript" src="scripts/global.js"></script>

    <script type="text/javascript">
    var timeout         = 500;
var closetimer		= 0;
var ddmenuitem      = 0;

function jsddm_open()
{	jsddm_canceltimer();
	jsddm_close();
	ddmenuitem = $(this).find('ul').eq(0).css('visibility', 'visible');}

function jsddm_close()
{	if(ddmenuitem) ddmenuitem.css('visibility', 'hidden');}

function jsddm_timer()
{	closetimer = window.setTimeout(jsddm_close, timeout);}

function jsddm_canceltimer()
{	if(closetimer)
	{	window.clearTimeout(closetimer);
		closetimer = null;}}

$(document).ready(function()
{	$('#jsddm > li').bind('mouseover', jsddm_open);
	$('#jsddm > li').bind('mouseout',  jsddm_timer);
	
	
	});

document.onclick = jsddm_close;
    </script>

</head>
<body>
    <ul id="jsddmmenu">
      
        <li><a href="operators.aspx">Operators</a>
            <ul>
                <li><a href="operators.aspx">Show Operators</a></li>
                <li><a href="AddOperators.aspx">Add Operator</a></li>
                <li><a href="ShowEmptyLegs.aspx">Show Empty Legs</a></li>
            </ul>
        </li>
        <li><a href="AirplaneTypes.aspx">Plane Types</a>
            <ul>
                <li><a href="AirplaneTypes.aspx">Show Plane types</a></li>
                <li><a href="AirplaneTypeRates.aspx">Manage Rates</a></li>
            </ul>
        </li>
        <li><a href="Currencies.aspx">Currencies</a> </li>
        <li><a href="settings.aspx">Settings</a>
            <ul>
                <li><a href="Settings.aspx">Admin Settings</a></li>
                <li><a href="EmailSettings.aspx">Email Settings</a></li>
            </ul>
        </li>
        <li><a href="ShowAirfields.aspx" style="border-right:1px solid #c0c0c0">Airfields</a>
            <ul>
                <li><a href="ShowAirfields.aspx">Show Airfields</a></li>
                <li><a href="AddAirfields.aspx">Add Airfield</a></li>
            </ul>
        </li>
       
    </ul>
    <% Response.Write(System.IO.Path.GetFileName(System.Web.HttpContext.Current.Request.Url.AbsolutePath)); %>
</body>
</html>
