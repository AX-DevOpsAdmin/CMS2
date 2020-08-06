<!DOCTYPE HTML >

<!--#include file="Includes/security.inc"--> 
<!--#include file="Connection/Connection.inc"-->
<!--#include file="includes/md5.asp" -->

<% 
' sets date to UK format - dmy
session.lcid=2057
%>
<html>
<head>

<!--#include file="Includes/IECompatability.inc"-->
<title>CMS</title>
<link rel="stylesheet" type="text/css" href="Includes/AMDB.css" media="Screen"/>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">

<script type="text/javascript" src="jsmd5.js"></script>

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
.errorbox{  background-color:#FFCECE;}

.errMsgBox{ color:#F00;padding:5px; background-color:#FFCECE; display:block;}
-->
</style>

</head>
<body onLoad="error('<%=request("error")%>','<%=request("pswdExp")%>');">

	<table  height="100%" cellspacing=0 cellPadding=0 width=100% border=0>
    	<tr>
    		<td>
			  <!--#include file="Includes/Header.inc"-->  
  				
                <form name="changepassword" method="post" action="writepw.asp" >
  				<table id="tblMain" width=100% border=0 cellpadding=0 cellspacing=0 > 
      				<tr valign=Top>
        				<td class="sidemenuwidth" background="Images/tableback.png"></td>
						<td width=16></td>
				       	<td align=left >
							<table border=0 cellpadding=0 cellspacing=0 width=100%>
								<tr height=22 class=SectionHeader>
									<td colspan="3" class=toolbar>
                                        <table border=0 cellpadding=0 cellspacing=0 >
                                            <td class=toolbar width=1>&nbsp;</td>
                                            <td width=20><a href="javascript:valchangepassword();"><img class="imagelink" src="images/saveitem.gif"></A></td>
                                            <td class=toolbar valign="middle">Save</td>
                                            <td class=titleseparator valign="middle" width=14 align="center">|</td>
                                            <td class=toolbar valign="middle"><a href="logon.asp" class="toolbar">Cancel</a></td>											
                                            <td class=titleseparator valign="middle" width=14 align="center">|</td>
                                            <td width=20><a href="javascript:document.changepassword.reset();"><img class="imagelink" src="images/reset.gif"></a></td>
                                            <td class=toolbar valign="middle">Reset</td>											
                                        </table>
                                    </td>
								</tr>
								<tr>
                                    <td width="247">&nbsp;</td>
                              </tr>
								
		                       <tr>
                               	<td>
                                    <p id="topMsg" style="color:#999;"></p>
                                    <label style="width:150px; color:#003399;">New Password:</label>
                                    <input style="display:block; margin-bottom:5px;" type="password" name="password" id="password" maxlength="10" onKeyDown="valPassword(this);">
                                    <label style="width:175px; color:#003399;">Confirm New Password:</label>
                                    <input style="display:block;" type="password" name="confirmPassword" id="confirmPassword" maxlength="10" onKeyDown="valPassword(this);">
                                    
                                    <div id="errBox" class="errMsgBox" style="display:none; width:400px;" align="left"></div>
                                </td>
                               </tr>
		                       
						  </table>
						</td>
      				</tr>
    			</table>
            </form>
			</td>
		</tr>
	</table>

</body>
</html>

<script language="javascript">

document.getElementById('tblMain').style.height = (document.documentElement.clientHeight - 138)+'px';	

function valchangepassword(){
	var frmObj = document.changepassword;
	var let = /[a-z,A-Z]/g;
	var num = /[0-9]/g;
	var err = 0;
	var errMsg = "";
	
	frmObj.password.className = '';
	
	frmObj.confirmPassword.className = '';
	if(frmObj.password.value !== frmObj.confirmPassword.value){
		frmObj.password.className = 'errorbox';
		frmObj.confirmPassword.className = 'errorbox';
		errMsg = '* The passwords do not match. <br>';
		err = err +1;
	}
	if(! let.test(frmObj.password.value)){
		frmObj.password.className = 'errorbox';
		frmObj.confirmPassword.className = 'errorbox';
		errMsg = errMsg+'* Password must contain at least one letter. <br>';
		err = err +1;
	}
	if(! num.test(frmObj.password.value)){
		frmObj.password.className = 'errorbox';
		frmObj.confirmPassword.className = 'errorbox';
		errMsg = errMsg+'* Password must contain at least one number. <br>';
		err = err +1;
	}
	if(frmObj.password.value.length < 6 || frmObj.password.value.length > 10){
		frmObj.password.className = 'errorbox';
		frmObj.confirmPassword.className = 'errorbox';
		errMsg = errMsg+'* Password must contain 6 to 10 characters. <br>';
		err = err +1;
	}

	if(frmObj.password.value == ""){
		frmObj.password.className = 'errorbox';
		frmObj.confirmPassword.className = 'errorbox';
		err = err +1;
		errMsg = '* You must complete the highlighted areas.';
	}
	if(frmObj.confirmPassword.value == ""){
		frmObj.confirmPassword.className = 'errorbox';
		err = err +1;
		errMsg = '* You must complete the highlighted areas.';
	}
	if(err > 0){
		errBox.innerHTML = errMsg;
		errBox.style.display = 'block';
	}
	if(err == 0){
		frmObj.submit();
	}
}

function valPassword(obj){

	if(obj.value.length > 9 && window.event.keyCode != 8 && window.event.keyCode != 110){
		alert("Password cannot be more then 10 characters long.")
	}

}


function error(err,pswdExp) {
	var topMsg = "";
	
	if (err !== ''){
		if(err == 1){
			topMsg = '* Your password has expired. Please create a new one.';
		}
		else if(err == 2){
			topMsg = 'Your password will expire in '+pswdExp+' days. Click "Home" on the menu bar to continue without changing.';
		}
		else if(err == 3){
			document.getElementById("errBox").innerHTML = '* You cannot use your previous password again.';
			document.getElementById("errBox").style.display = 'block';		
		}
	}
	else{	
		topMsg = '* Your password has been reset by the administrator. As a security measure please generate a new password.';
	}
	topMsg = topMsg+' Password must contain 6 to 10 characters, combining letters and numbers.';
	document.getElementById('topMsg').innerHTML = topMsg;
	document.changepassword.password.focus();
}
</script>