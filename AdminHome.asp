<!DOCTYPE HTML >

<!--#include file="Includes/security.inc"--> 

<!--#include file="Includes/checkadmin.asp"--> 

<%
' get screen height - use for table height calculation
if request("myHeight1") = "" then  
	%>
		<script language="JScript">
			var myHeight = document.documentElement.clientHeight - 161;
			window.location = "AdminHome.asp?myHeight1="+myHeight;
		</script>
	<%
else
	'response.write(request("myHeight1"))
   'session.timeout = 60
   session("heightIs") = request("myHeight1")
end if
%>

<html>
<head>

<!--#include file="Includes/IECompatability.inc"-->


<title><%= PageTitle %></title>
<link rel="stylesheet" type="text/css" href="Includes/AMDB.css" media="Screen"/>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">

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

</head>
<body>
<form  action="" method="POST" name="frmDetails">
	<table  height="100%" cellspacing=0 cellPadding=0 width=100% border=0>
    	<tr>
    		<td>
			  <!--#include file="Includes/Header.inc"--> 
  			  <table cellSpacing=0 cellPadding=0 width=100% border=0 >
    			<tr >
      			  <td align="center" class="sidemenuwidth"><img alt="" src="images/spssites.gif" ></td>
       			  <td class=titlearea >CMS<BR><span class="style1"><Font class=subheading>Administration</Font></span></td>
    			</tr>
				<tr>
       			  <td colspan=2 class=titlearealine  height=1></td> 
     			</tr>
  			  </table>
  			  <table width=100% height='<%=session("heightIs")%>px' border=0 cellpadding=0 cellspacing=0 > 
      			<tr valign=Top>
      			  <td class="sidemenuwidth" background="Images/tableback.png">
					<table width=100%  border=0 cellpadding=0 cellspacing=0 class=MenuStyleParent>
					  <tr height=22>
          				 <td width=10></td>
						 <td colspan=3 align=left height=20>Current Location</td>
					   </tr>
					   <tr height=22>
	          			  <td></td>
						  <td width="18" valign="top"><img src="images/arrow.gif"></td>
						  <td width="170" align="left"><A title="" href="index.asp">Home</A></td>
						  <td width="50" align="left"></td>
						</tr>
						<tr height=22>
	          			  <td></td>
						  <td valign="top"><img src="images/arrow.gif"></td>
    					  <td align="left" bgcolor="#FFFFFF"><Div style="height:18px; width:16em; border:Solid; border-width:1px; border-color:#438BE4; color: #003399;">Administration</Div></td>
						  <td align="left" class=rightmenuspace></td>
						</tr>
						<tr height=22>
	          			  <td></td>
						  <td valign="top"></td>
						  <td align=Left><A title="" href="AdminDataMenu.asp">&bull;&nbsp;Static Data</A></td>
						  <td align=Left></td>
						</tr>
					 </table>
				  </td>
				  <td width=16></td>
				  <td align=left>
					<table border=0 cellpadding=0 cellspacing=0 width=100%>
					  <tr height=16 class=SectionHeader>
						 <td class=toolbar>Administration</td>
					  </tr>
					</table>
				 </td>
      		  </tr>
    	   </table>
		</td>
	  </tr>
	</table>
</form>
</body>
</html>

<SCRIPT LANGUAGE="JavaScript">
/**
function OverBackgroundChange(itemID){
    itemID.className='testTabHover';
}

function OutBackgroundChange(itemID){
    itemID.className='testTabUnselected';
}
**/
</Script>
