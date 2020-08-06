<!DOCTYPE HTML >

<%
session.("con") = "90SUCMS"
strDSN=session("con")

response.write("DSN is " & strDSN)
response.end()

if isNull(strDSN) or strDSN="" then
   response.redirect "asps/logon.asp"

end if

'Stops the page retrieving data from cache
response.cachecontrol = "no-cache"
response.addheader "Pragma", "no-cache"
response.expires = -1

' first save the DSN connection so we know which database we're connecting to cos
' this is now the CMS logon.asp for ALL instances and NOT just 90SU 
' CMS redirects from the users bespoke logon.asp to here having set the required DSN in the bespoke logon.asp
' that is in the asp directory of the users old website eg: Air_LeemingCMS/asps/logon.asp

'response.write "DSN is " & strDSN
'response.end()

' now clear all session variables so we're secure(ish)
session.Abandon
session.Contents.RemoveAll()


' response.write " * DSN now is " & strDSN & " * " &  request("myHeight1")
 'response.end()

' get screen height - use for table height calculation
'if request("myHeight1") = "" then  
'    
%>
<!--
		<script type="text/javascript" language="JScript">
			var myHeight = document.documentElement.clientHeight - 138;
			window.location = "logon.asp?myHeight1="+myHeight;
		</script>
-->
<%
'else
'	'response.write(request("myHeight1"))
'   ''session.timeout = 60
'   session("heightIs") = request("myHeight1")
'end if

session.timeout = 60

' sets date to UK format - dmy
session.lcid=2057

' now initialse session variables
	
session("con")=strDSN                  ' so we know what Dbase we are logging onto
session("StaffID") = ""                ' so we know who is logging on
session("UserStatus") =  ""            ' so we know whether they are a manager or not
session("CMS2CMSLogIn") = ""           ' so we know they have successfully logged on
session("imxAdmin")=0                  ' IMX Admin - so we can add new Groups 

'response.write " * * Now DSN is " & session("con")
'	response.end()

%>

<html>
<head>
<!--#include file="Includes/IECompatability.inc"-->
<title>CMS</title>
<link rel="stylesheet" type="text/css" href="Includes/AMDB.css" media="Screen"/>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
</head>
<body onLoad="document.all.userNum.focus()">

	<div class="LogonWrapper">   
    	<div class="LogonInner"> 
        <h1 class="CMSTitle">CMS</h1>
        <form action="VerifyLogon.asp" method="POST" name="frmDetails">
             <input type="hidden" name="DSN" id="DSN" value=<%=session("con")%>>
    <table width="100%" border=0 cellpadding=0 cellspacing=0 class="itemfont">					            	
									<tr>          								
										<td align=right height=28>Service No: </td>
										<td align=left height=28><input name="userNum" id="userNum" type="text" value="" size="15" maxlength="20"></td>
                                    </tr>
									<tr>
                                    	<td align=right height=28>Password: </td>
										<td align=Left height=28><input name="txtpasswd" id="txtpasswd" type="password" value="" size="15" maxlength="20"></td>
                                    </tr>
									<tr>
          								<td colspan="4" height="20" align="center">
                                        <input name="btnGo" type="submit" id="btnGo" value="Sign In" style="width:70px;">
                                        <input name="btnreset" type="button" id="btnreset" value="Reset" style="width:70px" onClick="btnReset()"></td>
									</tr>
								</table>
         	</form>
        </div>    
    </div>

</body>
</html>

<script type="text/javascript" language="javascript">

function OverBackgroundChange(itemID)
{
	itemID.className ='testTabHover';
}

function OutBackgroundChange(itemID)
{
	itemID.className ='testTabUnselected';
}

function btnReset()
{
 	document.frmDetails.userNum.value = "";
	document.frmDetails.txtpasswd.value = "" ;
	document.frmDetails.userNum.focus()
}

</script>
