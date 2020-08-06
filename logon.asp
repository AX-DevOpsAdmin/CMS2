<!DOCTYPE HTML >

<%
'Stops the page retrieving data from cache
response.cachecontrol = "no-cache"
response.addheader "Pragma", "no-cache"
response.expires = -1

' now clear all session variables so we're secure(ish)
session.Abandon
session.Contents.RemoveAll()

' sets date to UK format - dmy
session.lcid=2057

' now initialse session variables
	
session("StaffID") = ""                ' so we know who is logging on
session("UserStatus") =  ""            ' so we know whether they are a manager or not
session("CMS2CMSLogIn") = ""           ' so we know they have successfully logged on
session("imxAdmin")=0                  ' IMX Admin - so we can add new Groups 
%>

<style>

#userNum {text-transform:uppercase;}

</style>

<html>
<head>
<!--#include file="Includes/IECompatability.inc"-->
<title>CMS</title>
<link rel="stylesheet" type="text/css" href="Includes/AMDB.css" media="Screen"/>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
</head>
<body onLoad="document.all.userNum.focus()">

	<div class="LogonWrapper">   
       <div class="LogonMessage">
       <!--
            <p style="color:#FF0000"><strong> Please Note: All users should change their CMS shortcut to the following URL: http://web.apps.royalnavy.r.mil.uk/Air_CMS2/<br /> <br /> 
              Existing shortcuts will continue to work until COP 30/06/2017 after which only the above URL will give access to CMS</strong> </p>
        -->
       </div>
              
      <div class="LogonInner"> 
        <h1 class="CMSTitle">CMS</h1>
        <form action="VerifyLogon.asp" method="POST" name="frmDetails" onSubmit="return checkform()">
    		<table width="100%" border=0 cellpadding=0 cellspacing=0 class="itemfont">					            	
                <tr>          								
                    <td align=right height=28>Service No: </td>
                    <td align=left height=28><input name="userNum" id="userNum" type="text" value="" size="15" maxlength="20" onKeyUp="capitalise()"></td>
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
            <br /> <br /> 
            <p style="color:#FF0000"><strong> Please Note: In order to comply fully with the Data Protection Act all Personal Data classed Official Sensitive has been removed from CMS This includes the Dental and Vaccination data for individuals. <br /> <br /> 
             The only Personal Data now held is Name, Rank, Service Number, Trade and Known As</strong> </p>
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

function checkform()
{
	
	var sno=document.getElementById("userNum").value;
	var pwd=document.getElementById("txtpasswd").value;

	if(sno =="" || pwd == ""){
		return false;
	}
	else
	{
		return true;
	}
}

function capitalise() {
	$('#userNum').val($('#userNum').val().toUpperCase());
}

</script>
