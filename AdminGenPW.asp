<!DOCTYPE HTML >

<!--#include file="Includes/security.inc"-->
<!--#include file="Includes/checkadmin.asp"--> 
<!--#include file="Connection/Connection.inc"-->

<% 
' sets date to UK format - dmy
session.lcid=2057

' so the menu include - datamenu.inc knows what page we're on
dim strPage
strPage="PWD"

set objCmd = server.CreateObject("ADODB.Command")
objCmd.ActiveConnection = con
objCmd.CommandText = "spGetGenPW"	'Name of Stored Procedure
objCmd.CommandType = 4				'Code for Stored Procedure

set objPara = objCmd.CreateParameter ("nodeID",3,1,0, nodeID)
objCmd.Parameters.Append objPara
set rsRecSet = objCmd.Execute	'Execute CommandText when using "ADODB.Command" object
%>

<html>
<head>

<!--#include file="Includes/IECompatability.inc"-->


<title><%= PageTitle %></title>
<link rel="stylesheet" type="text/css" href="Includes/AMDB.css" media="Screen"/>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">

<script type="text/javascript" src="jsmd5.js"></script>
</head>
<body onLoad="document.frmLogon.txtoldpw.focus()">
<form action="writeGenPW.asp" method="POST" name="frmLogon">
    <input name="hiddenPW" id="hiddenPW" type="hidden" value="<%=strcurrPW%>">
	<input name="hiddenDefPW" id="hiddenDefPW" type="hidden" value="<%=rsRecSet("genericPW")%>">
	<table  height="100%" cellspacing=0 cellPadding=0 width=100% border=0>
    	<tr>
    		<td>
			  <!--#include file="Includes/Header.inc"-->  
  				<table cellSpacing=0 cellPadding=0 width=100% border=0 >
                    <tr style="font-size:10pt;" height=26px>
                        <td width=10><img style="margin-left:10px;" src="cms_icons/png/24x24/process.png" width="24" height="24"></td>
                        <td class="staticdatamenu"><font class="youAreHere">CMS Admin Menu / <strong>Change Default Password</strong></font></td>
                    </tr>
                    <tr><td colspan=2 class=titlearealine  height=1></td></tr>
				</table>
          
  		  <table width=100% height='<%=session("heightIs")%>px' border=0 cellpadding=0 cellspacing=0> 
      		<tr valign=Top>
        	  <td class="sidemenuwidth" background="Images/tableback.png"><!--#include file="Includes/datamenu.inc"--></td>



						<td width=16></td>
				       	<td align=left >
							<table border=0 cellpadding=0 cellspacing=0 width=100%>
								<tr height=16 class=SectionHeader>
                                	<td>
                                        <table border=0 cellpadding=0 cellspacing=0 >
                                            <td class=toolbar width=1>&nbsp;</td>
                                            <td width=20><a href="javascript:checkThis()"><img class="imagelink" src="images/saveitem.gif"></A></td>
                                            <td class=toolbar valign="middle">Save</td>
                                            <td class=titleseparator valign="middle" width=14 align="center">|</td>
                                            <td width=20><a href="javascript:Reset()"><img class="imagelink" src="images/reset.gif"></a></td>
                                            <td class=toolbar valign="middle">Reset</td>											
                                        </table>
                                    </td>									
								</tr>
								<tr>
                                	<td colspan="3">&nbsp;</td>
                              </tr>
                              <tr>
                                <td colspan="3" align="center"><p><strong><span class="style19">You are about to change the Default Password</span></strong></p></td>
                               </tr>
		                       <tr>
                                 <td colspan="3" align="center"><p><strong><span class="style19">You must Enter and Confirm a New Default Password to Continue</span></strong></p></td>
                               </tr>
		                       <tr>
		                        <td colspan="3">&nbsp;</td>
		                       </tr>
                            </table>
							<table border=0 cellpadding=0 cellspacing=0 width=100%>
		                      <tr class="columnheading">
							    <td width="274">&nbsp;</td>
                                <td width="126" align="left">Old Password:</td>
                                <td width="396"><input name="txtoldpw" id="txtoldpw" type="password"></td>
                              </tr>
		                      <tr class="columnheading">
							    <td>&nbsp;</td>
                                <td align="left">New Password:</td>
                                <td><input name="txtpw" id="txtpw" type="password"><td width="4">
							  </tr>
		                      <tr class="columnheading">
							    <td>&nbsp;</td>
                                <td align="left">Confirm Password:</td>
                                <td><input name="txtconfpw" id="txtconfpw" type="password"></td>
                              </tr>
                              <tr>
							    <td colspan="3">&nbsp;</td>
		                      </tr>  
                                <tr>
                                    <td colspan=3 class=titlearealine height=1></td> 
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

<script language="javascript">

function checkThis()
{
	//This function renoves any leading or trailing spaces from a string
	String.prototype.killWhiteSpace = function()
	{
		return this.replace(/\s/g, '');
	};

	var errMsg = "Please provide/correct the following:\n\n";
	var error = false;
	  
	var opw = document.frmLogon.txtoldpw.value
	opw = opw.killWhiteSpace();
	var npw = document.frmLogon.txtpw.value;
	npw = npw.killWhiteSpace();
	var cpw = document.frmLogon.txtconfpw.value;
	cpw = cpw.killWhiteSpace();
   
	// if we are changing a password then old password needs to have been confirmed
	//opw = getMD5(opw);

	if(opw == "")
	{
		errMsg += "Old Password\n"
		error = true;
	}

	if(opw != "" && opw != document.frmLogon.hiddenDefPW.value)
	{
		errMsg += "Old Password is incorrect\n"
		error = true;
	}
	
	if(npw == "")
	{
		errMsg += "New Password\n"
		error = true;
	}
	
	if(cpw == "")
	{
		errMsg += "Confirm Password\n"
		error = true;
	}	

	if(npw != "" && cpw != "" && npw != cpw)
	{
		errMsg += "Confirmed Password is different from the New Password\n"
		error = true;
	}	 

	//if(getMD5(npw) == opw)
	if(opw != "" && npw != "" && npw == opw)
	{
		errMsg += "You cannot pick the same default password"
		error = true;
	}	 

	if(npw == cpw && cpw != "" && npw.length < 6)
	{
		errMsg += "Your New Password must be at least 6 characters in length"
		error = true;
	}
	
	if(error == true)
	{
		alert(errMsg)
		return
	}

	document.frmLogon.submit();
}

function OverBackgroundChange(itemID)
{
	itemID.className = 'testTabHover';
}

function OutBackgroundChange(itemID)
{
	itemID.className = 'testTabUnselected';
}

function Reset()
{
	document.frmLogon.txtoldpw.value = "";
	document.frmLogon.txtpw.value = "";
	document.frmLogon.txtconfpw.value = "";
	document.frmLogon.txtoldpw.focus();
}

</script>

