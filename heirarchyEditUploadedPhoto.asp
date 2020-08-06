<%
'Stops the page retrieving data from cache
Response.CacheControl = "no-cache"
Response.AddHeader "Pragma", "no-cache"
Response.Expires = -1

'Initiate connection to database
'Set con = Server.CreateObject("ADODB.Connection") 'Create a connection object  
'con.Open "DSN=manTrack"


%>

<HTML>
<HEAD>

<!--#include file="Includes/IECompatability.inc"-->


<link rel="stylesheet" type="text/css" href="Includes/tracker.css" media="Screen"/>

	<style type="text/css">
<!--
body {
	background-image: url();
	margin-left: 0px;
	margin-top: 0px;
	margin-right: 0px;
	margin-bottom: 0px;
}
.style1 {color: #0000FF}
-->
</style>	

</HEAD>

<BODY class=PageBackground>

<form  method="post" action="updateStaffPhoto.asp"   ENCTYPE="multipart/form-data" name="frmDetails"  id="frmDetails">
<input type = hidden name=staffID  name="staffID" value = "<%=request("staffID")%>" >
<%
windowWidth=700
windowHeight=120%>
<Div id="detailWindow" class="windowBorderArea" style="background-color:#f4f4f4;position:absolute;left:0px;top:0px;height:<%=windowHeight%>px;width:<%=windowWidth%>px;">
	<table border=0 cellpadding=0 cellspacing=0 align=right width=100%>
		<tr  class=SectionHeader>
			<td>
<DIV id="detailWindowTitleBar" style="position:relative;left:7px;top:0px;width:<%=windowWidth-16%>px;border-color:#7f9db9;">
				<table border=0 cellpadding=0 cellspacing=0 align=right width=100%>
					<tr>
						<td id="windowName" class=itemfont>Upload Photo</td><td ALIGN=RIGHT></td>
					</tr>
				</table>
</Div>
			</td>
		</tr>
		<tr>
			<td  class=titlearealine  height=1></td> 
		</tr>

		<tr  >
			<td align=left class=itemfont>
<Div id="innerDetailWindow" class="innerWindowBorderArea" style="Overflow:auto;background-color:#f4f4f4;color:#000000;position:relative;height:<%=windowHeight-40%>px;width:<%=windowWidth-16%>px">
				<table border=0 cellpadding=0 cellspacing=0 align=right width=100%>
					<tr class="personalDetails">
						<td width=4px></td><td width="108px">Document Title:</td><td class=itemfont width="530px"><input style="width:530px;height:20px;" name="FILE1" type="file" class="inputbox itemfontEdit " id="documentTitle" size="100"></td>
					</tr>
					<tr height=24px>
						<td  colspan=3 align="center">
						</td>
					</tr>
	
					<tr>
						<td  colspan=3 align="center">
							<input name="taskCancelButton" class=itemfont type=submit value=Upload style="width:80px;cursor:hand;">
						</td>
					</tr>
				</table>
</Div>
			</td>
		</tr>
	</table>
</Div>

</form>
<script language="javascript">

function populateDetailsWindow(name,text,xPos,yPos,xHeight,xWidth){
//alert (name);
<!--Create Div Window with Parameters sent to function-->
document.getElementById('windowName').innerHTML = name;
var innerDetailWindow = document.getElementById('innerDetailWindow');
innerDetailWindow.innerHTML = text;
var innerDetailWindow = document.getElementById('detailWindow');
detailWindow.style.visibility="visible";
detailWindow.style.left=xPos;
detailWindow.style.top=yPos;
detailWindow.style.height=xHeight+ "px";
detailWindow.style.width=xWidth + "px";
innerDetailWindow.style.height=xHeight-40 + "px";
innerDetailWindow.style.width=xWidth - 16 + "px";
document.getElementById('detailWindowTitleBar').style.width=xWidth - 16 + "px";
}

function closeThisWindow (thisWindow){
thisWindow.style.visibility="hidden";
}

function updateTaskDocument(taskID){
	
document.frmDetails.action = "insertTaskDocumentfile.asp?taskID="+taskID;
document.frmDetails.submit();
	
}


</script>
</BODY>
</HTML>