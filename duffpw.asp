<!DOCTYPE HTML >

<!--#include file="Includes/security.inc"--> 

<% 
' get screen height - use for table height calculation
if request("myHeight1") = "" then  
	%>
		<script language="JScript">
			var myHeight = document.documentElement.clientHeight - 138;
			window.location = "duffpw.asp?myHeight1="+myHeight;
		</script>
	<%
else
   'session.timeout = 60
   session("heightIs") = request("myHeight1")
end if

' sets date to UK format - dmy
session.lcid=2057

%>

<html>
<head>

<!--#include file="Includes/IECompatability.inc"-->


<title>CMS</title>
<link rel="stylesheet" type="text/css" href="Includes/AMDB.css" media="Screen"/>
<meta http-equiv="refresh" content="10;URL=logon.asp">

<style type="text/css">
<!--
body {
	background-image: url();
	margin-left: 0px;
	margin-top: 0px;
	margin-right: 0px;
	margin-bottom: 0px;
}
.style1 {
	color: #0000FF;
}

.style2 {
	font-size: 10px;
}

.style8 {
	color: #000000;
}

.style9 {
	font-family: Verdana, Arial, Helvetica, sans-serif;
}

.style18 {
	font-size: 12px;
}

.style19 {
	font-size: 14px;
	color: #FF0000
}
-->
</style>

</head>
<body>
<form action="logon.asp" method="POST" name="frmDetails">
	<table  height="100%" cellspacing=0 cellPadding=0 width=100% border=0>
    	<tr>
    		<td>
			  <!--#include file="Includes/Header.inc"-->  
  				<table cellSpacing=0 cellPadding=0 width=100% border=0 >
    				<tr >
      					<td>&nbsp;</td> 
						<td>&nbsp;</td>
    				</tr>
  					<tr>
       					<td colspan=2 class=titlearealine  height=1></td> 
     				</tr>
  				</table>
  				<table width=100% height='<%=session("heightIs")%>px' border=0 cellpadding=0 cellspacing=0 > 
      				<tr valign=Top>
        				<!--<td width=134 class="sideMenu">-->
        				<td class="sidemenuwidth" background="Images/tableback.png"></td>
				       	<td align=left >
							<table border=0 cellpadding=0 cellspacing=0 width=98% align="right">
								<tr height=16 class=SectionHeader>
									<td class=toolbar>&nbsp;</td>
								</tr>
								<tr>
                                    <td>&nbsp;</td>
                                 </tr>
                                 <tr>
                                    <td>&nbsp;</td>
                                 </tr>
								<tr>
                                    <td><div align="center" class="style19">You have entered an Incorrect Password</div></td>
                                 </tr>
                                 <tr>
                                    <td>&nbsp;</td>
                                 </tr>
                                 <tr>
                                    <td>
                                      <div align="center" class="style19">You will be redirected to the Log On screen shortly </div>
									</td>
                                 </tr>
                                 <tr>
                                    <td><div align="center" class="style19">or click CLOSE to return there now </div></td>
                                 </tr>
								 <tr>
                                    <td>&nbsp;</td>
                                 </tr>
                                 <tr>
                                    <td>&nbsp;</td>
                                 </tr>
                                 <tr>
	                                  <td><div align="center">
		                                <input type="submit" name="Submit" value="Close">
                                         </div>
	                                  </td>
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
function OverBackgroundChange(itemID){
    itemID.className='testTabHover';
}

function OutBackgroundChange(itemID){
    itemID.className='testTabUnselected';
}
</Script>
