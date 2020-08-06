<!DOCTYPE HTML >

<% 
'Stops the page retrieving data from cache
response.cachecontrol = "no-cache"
response.addheader "Pragma", "no-cache"
response.expires = -1
 
' get screen height - use for table height calculation
if request("myHeight1") = "" then  
	%>
		<script language="JScript">
			var myHeight = document.documentElement.clientHeight - 138;
			window.location = "noaccess.asp?myHeight1="+myHeight;
		</script>
	<%
else
   'session.timeout = 60
   session("heightIs") = request("myHeight1")
end if  
%>

<html>
<head>

<!--#include file="Includes/IECompatability.inc"-->


<title>CMS</title>
<link rel="stylesheet" type="text/css" href="Includes/AMDB.css" media="Screen"/>
<meta http-equiv="refresh" content="10;URL=logon.asp">
</head>
<body>

<div class="LogonWrapper">   
    	<div class="LogonInner"> 
        <h1 class="CMSTitle"></h1>
        <form action="logon.asp" method="POST" name="frmDetails">
    
    <table width="100%" border=0 cellpadding=0 cellspacing=0 class="itemfont">					            	
									
							</table>
							<p class="error">You are not authorized to view this page. You will be redirected to the sign in page shortly. Click CLOSE to redirect now. </p>
								<input style="margin-top:10px;" type="submit" name="Submit" value="Close">
								
                                </form>
                                
                                

       </div>    
</div>

</body>
</html>


<script language="javascript">
	 
	//currentLocation = window.parent.location.href.substring (26)
	currentLocation = window.parent.location.href;
	stringLength=currentLocation.length
	stringPos = stringLength - 17
	currentLocation = currentLocation.substring (stringPos,stringLength)
	//alert(stringPos + "," + stringLength + "," + currentLocation)
	if (currentLocation=="cms_hierarchy.asp"){
	window.parent.location.href="noaccess.asp"
	}

</script>
<script language="javascript">

function OverBackgroundChange(itemID)
{
	itemID.className = 'testTabHover';
}

function OutBackgroundChange(itemID)
{
	itemID.className = 'testTabUnselected';
}

</Script>
