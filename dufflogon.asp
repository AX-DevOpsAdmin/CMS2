<!DOCTYPE HTML >

<!--include file="Includes/security.inc"--> 

<% 
dim strReason

strReason = request("strReason")
strDSN=session("con")

'response.write "DSN is " & strDSN

' now clear all session variables so we're secure(ish)
session.Abandon
session.Contents.RemoveAll()

session("con") = strDSN
' get screen height - use for table height calculation
'if request("myHeight1") = "" then  
'	%>
<!--'		<script language="JScript">	
'			var myHeight = document.documentElement.clientHeight - 135;
'			window.location = "dufflogon.asp?myHeight1="+myHeight+"&strReason=<%'= strReason %>";
'		</script>
-->
	<%
'else
'   'session.timeout = 60
'   session("heightIs") = request("myHeight1") 
'end if 

' sets date to UK format - dmy
session.lcid=2057

%>

<html>
<head>

<!--#include file="Includes/IECompatability.inc"-->


<title><%= PageTitle %></title>
<link rel="stylesheet" type="text/css" href="Includes/AMDB.css" media="Screen"/>
<meta http-equiv="refresh">

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

#userNum {text-transform:uppercase;}
-->
</style>

</head>
<body>

<div class="LogonWrapper">   

       <div class="LogonMessage">
            <p style="color:#FF0000"><strong> Please Note: CMS will be unavailable from 14:00 Monday 26th June 2017 to 08:00 Tuesday 27th June 2017
               for essential maintenance. <br /> <br /> Please ensure you are logged off by this time as any changes made and not saved will be lost </strong> </p>
       </div>

    	<div class="LogonInner">
    	  <h1 class="CMSTitle"> CMS</h1>
        <form action="verifylogon.asp" method="POST" name="frmDetails" onSubmit="return checkform()">
     <input type="hidden" name="DSN" id="DSN" value=<%=session("con")%>>
          <table width="100%" border=0 cellpadding=0 cellspacing=0 class="itemfont">					            	
									<tr>          								
										<td align=right height=28>Service No: </td>
										<td align=left height=28><input name="userNum" id="userNum" type="text" value="" size="15" maxlength="20" onKeyUp="capitalise()"></td>
                                    </tr>
									<tr>
                                    	<td align=right height=28>Password: </td>
										<td align=Left height=28><input name="txtpasswd" id="txtpasswd"  type="password" value="" size="15" maxlength="20"></td>
                                    </tr>
									<tr>
          								<td colspan="4" height="20" align="center">
                                        <input name="btnGo" type="submit" id="btnGo" value="Sign In" style="width:70px;">
                                        <input name="btnreset" type="button" id="btnreset" value="Reset" style="width:70px" onClick="btnReset()"></td>
									</tr>
								</table>
								
								
								<% if (strReason = "Password"  or  strReason = "Staff")  then %>
								
								   <p class="error">Service Number/Password Incorrect </p>
                                <% elseif strReason = "Active" then %>
								
								    <p class="error">You have been Posted Out and no longer have access to CMS.</p>
								
								<% elseif strReason = "DSN" then %>
								
								    <p class="error">If you have been Posted Out you no longer have access to CMS <br /> <br />
                                       or the Service Number/Password you entered are incorrect 
                                    </p>
                                
                                <% end if %>                               
                                                        
                               </form>
                                         </div>

        </div>    
    </div>

</body>
</html>

<SCRIPT LANGUAGE="JavaScript">
function OverBackgroundChange(itemID){
    itemID.className='testTabHover';
}

function OutBackgroundChange(itemID){
    itemID.className='testTabUnselected';
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

function capitalise() {
	$('#userNum').val($('#userNum').val().toUpperCase());
}
	
}
</Script>
