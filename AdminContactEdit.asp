<!DOCTYPE HTML >
<!--#include file="Includes/security.inc"--> 
<!--#include file="Includes/checkadmin.asp"-->
<!--#include file="Connection/Connection.inc"-->
<!--#include file="Includes/adovbs.inc"-->

<%
  	dim cmdEditContact
	dim intRetContactID
	dim strRetEmailName
	dim strRetEmail
	dim strRetMilPhone
	dim strRetExt
	
	set cmdEditContact = server.createobject("ADODB.Command")
	cmdEditContact.activeconnection = con
	cmdEditContact.commandtext = "spContactSelect"
	cmdEditContact.commandtype = adCmdStoredProc
	
	cmdEditContact.Parameters.Append cmdEditContact.CreateParameter("@nodeID",3,1,0, nodeID)
	
	'Output Parameters
	cmdEditContact.parameters.append cmdEditContact.createparameter("@RetEmailName", adVarChar, adParamOutput, 30)	
	cmdEditContact.parameters.append cmdEditContact.createparameter("@RetEmail", adVarChar, adParamOutput, 30)
	cmdEditContact.parameters.append cmdEditContact.createparameter("@RetMilPhone", adVarChar, adParamOutput, 10)
	cmdEditContact.parameters.append cmdEditContact.createparameter("@RetExt", adVarChar, adParamOutput, 6)
	
	cmdEditContact.execute
	
	intRetContactID = 1
	strRetEmailName = cmdEditContact.parameters("@RetEmailName")
	strRetEmail = cmdEditContact.parameters("@RetEmail")
	strRetMilPhone = cmdEditContact.parameters("@RetMilPhone")
	strRetExt = cmdEditContact.parameters("@RetExt")
									
	set cmdEditContact = nothing
%>

<html>

<!--#include file="Includes/IECompatability.inc"-->


<head> <title><%= PageTitle %></title>
<link rel="stylesheet" type="text/css" href="Includes/AMDB.css" media="Screen"/>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
</head>
<body>
<form  action="AdminContactUpdate.asp" method="POST" name="frmContact">
  <table  height="100%" cellspacing=0 cellPadding=0 width=100% border=0>
    <tr>
      <td>
        <!--#include file="Includes/Header.inc"--> 
  		  <table cellSpacing=0 cellPadding=0 width=100% border=0 >
                    <tr style="font-size:10pt;" height=26px>
                        <td width=10><img style="margin-left:10px;" src="cms_icons/png/24x24/process.png" width="24" height="24"></td>
                        <td class="staticdatamenu"><font class="youAreHere">CMS Admin Menu / <strong>Edit Contact</strong></font></td>
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
					    <td class=toolbar width=8></td>
						<td width=20><a href="javascript:btnSave_onClick();"><img class="imagelink" src="images/saveitem.gif"></A></td>
						<td class=toolbar valign="middle">Save and Close</td>
                        <td class=titleseparator valign="middle" width=14 align="center">|</td>
						<td class=toolbar valign="middle"><A class= itemfontlink href="AdminContactList.asp">Back</A></td>											
					 </table>
					</td>
			      </tr>
				  <tr>
					<td>
                        <table align="center" width="100%" border="0" cellspacing="0" cellpadding="0">
                        	<tr>
                            	<td colspan="3" height="16px">&nbsp;</td>
                            </tr>
                            <tr class="columnheading">
                            	<td valign="middle" width="2%">&nbsp;</td>
                                <td valign="middle" width="13%">Email Name:</td>
                                <td valign="middle" width="85%"><input name="txtEmailName" type="text" class="itemfont" id="txtEmailName" style="width:300px" value="<%= strRetEmailName %>" maxlength="30" onFocus="this.select();" /></td>
                            </tr>
                            <tr class="columnheading">
                            	<td valign="middle" width="2%">&nbsp;</td>
                                <td valign="middle" width="13%">Email:</td>
                                <td valign="middle" width="85%"><input name="txtEmail" type="text" class="itemfont" id="txtEmail" style="width:300px" value="<%= strRetEmail %>" maxlength="30" onFocus="this.select();" /></td>
                            </tr>
                            <tr>
                                <td colspan="3" height="22px">&nbsp;</td>
                            </tr>
                            <tr class="columnheading">
                            	<td valign="middle" width="2%">&nbsp;</td>
                                <td valign="middle" width="13%">PSTN:</td>
                                <td valign="middle" width="85%"><input name="txtMilPhone" type="text" class="itemfont" id="txtMilPhone" value="<%= strRetMilPhone %>" maxlength="30" onFocus="this.select();" /></td>
                            </tr>
                            <tr class="columnheading">
                            	<td valign="middle" width="2%">&nbsp;</td>
                                <td valign="middle" width="13%">Ext:</td>
                                <td valign="middle" width="85%"><input name="txtExt" type="text" class="itemfont" id="txtExt" value="<%= strRetExt %>" maxlength="4" style="width:60px" onFocus="this.select();" /></td>			
                            </tr>
                            <tr height=16>
                            	<td>&nbsp;</td>
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
		</td>
	  </tr>
  </table>
</form>
<%
con.close
set con=Nothing
%>
</body>
</html>

<SCRIPT LANGUAGE="JavaScript">
function btnSave_onClick()
	{
		document.frmContact.submit()
	}
</Script>
