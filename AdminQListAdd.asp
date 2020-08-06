<!DOCTYPE HTML >

<!--#include file="Includes/security.inc"--> 
<!--#include file="Includes/checkadmin.asp"-->
<!--#include file="Connection/Connection.inc"-->

<%
dim strAction
strAction="Add"

set objCmd = server.CreateObject("ADODB.Command")
set objPara = server.CreateObject("ADODB.Parameter")
objCmd.ActiveConnection = con
objCmd.Activeconnection.cursorlocation = 3
objCmd.commandtype = 4	

strTable = "tblQTypes"
strCommand = "spListTable"
objCmd.commandtext = strCommand
set objPara = objCmd.createparameter("nodeID",3,1,5, nodeID)
objCmd.parameters.append objPara		
set objPara = objCmd.createparameter ("TableName",200,1,50, strTable)
objCmd.parameters.append objPara
set rsQTypeList = objCmd.execute	''Execute CommandText when using "ADODB.Command" object

for x = 1 to objCmd.parameters.count
	objCmd.parameters.delete(0)
next

strTable = "tblValPeriod"
strCommand = "spListTable"
objCmd.commandtext = strCommand
set objPara = objCmd.createparameter("nodeID",3,1,5, nodeID)
objCmd.parameters.append objPara		
set objPara = objCmd.createparameter ("TableName",200,1,50, strTable)
objCmd.parameters.append objPara
set rsValidityPeriodList = objCmd.execute	'Execute CommandText when using "ADODB.Command" object
%>

<html>
<head>

<!--#include file="Includes/IECompatability.inc"-->



<title><%= PageTitle %></title>
<link rel="stylesheet" type="text/css" href="Includes/AMDB.css" media="Screen"/>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">

</head>
<body>
<form action="UpdateQList.asp?strAction=<%=strAction%>" method="POST" name="frmDetails">
  <input type="hidden" name="QID" id="QID" value="<%= request("QID") %>">  
  <table  height="100%" cellspacing=0 cellPadding=0 width=100% border=0>
    	<tr>
    		<td>
                <!--#include file="Includes/Header.inc"-->
  					<table cellSpacing=0 cellPadding=0 width=100% border=0 >
                    <tr style="font-size:10pt;" height=26px>
                        <td width=10><img style="margin-left:10px;" src="cms_icons/png/24x24/process.png" width="24" height="24"></td>
                        <td class="staticdatamenu"><font class="youAreHere">CMS Admin Menu / <strong>New Qualification Details</strong></font></td>
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
											<td height=25 class=toolbar width=8></td>
                                            <td height=25 width=20><a href="javascript:checkThis();"><img class="imagelink" src="images/saveitem.gif"></A></td>											
											<td height=25 class=toolbar valign="middle">Save and Close</td>
                                            <td height=25 class=titleseparator valign="middle" width=14 align="center">|</td>
											<td height=25 class=toolbar valign="middle"><a class= itemfontlink href="AdminQList.asp">Back To List</a></td>
										</table>
									</td>									
								</tr>
								<tr>
									<td>
										<table width=100% border=0 cellpadding=0 cellspacing=0>
											<tr height=16>
												<td></td>
											</tr>
											<tr class=columnheading>
												<td height=22 valign="middle" width=2%>&nbsp;</td>
												<td height=22 valign="middle" width=13%>Qualification:</td>
												<td height=22 valign="middle" width=85%><input class="itemfont" style="width: 360px" maxLength=300 name="txtDescription" id="txtDescription" type="text"/></td>
											</tr>
                                            <tr class="columnheading">
                                            	<td height="22" valign="middle" width="2%">&nbsp;</td>
                                                <td height="22" valign="middle" width="13%">Q Type:</td>
                                                <td height="22" valign="middle" width="85%">
                                                	<!--<select name="cboQType" id="cboQType" class="itemfont" style="width: 150px" onChange="QAuth(this.value)">-->
                                                    <select name="cboQType" id="cboQType" class="itemfont" style="width: 150px">
                                                    	<option value="0">...Select</option>
														<% do while not rsQTypeList.eof %>
                                                            <option value="<%= rsQTypeList("QTypeID") %>*<%= rsQTypeList("Auth") %>"><%= rsQTypeList("description") %></option>
                                                            <% rsQTypeList.movenext %>
                                                        <% loop %>
                                                    </select>
                                                </td>
                                            </tr>
                                            <tr class="columnheading">
                                            	<td height="22" valign="middle" width="2%">&nbsp;</td>
                                                <td height="22" valign="top" width="13%">Description:</td>
                                                <td height="22" valign="middle" width="85%"><textarea name="txtLongDesc" rows="4" class="itemfont" id="txtLongDesc" style="width: 360px; height: 60px; "></textarea></td>
                                            </tr>
                                            <tr class="columnheading">
												<td height="22px" align="left" width="2%">&nbsp;</td>
                                                <td height="22px" align="left" width="13%">Validity Period:</td>
                                                <td height="22px" align="left" width="85%">
                                            	    <select name="cboVPeriod" id="cboVPeriod" class="itemfont" style="width: 100px">
                                                    	<option value="0">...Select</option>
                                                		<% do while not rsValidityPeriodList.eof %>
                                                			<option value="<%= rsValidityPeriodList("vpID") %>"><%= rsValidityPeriodList("description") %></option>
                                                			<% rsValidityPeriodList.movenext %>
                                                		<% loop %>
                                                	</Select>
                                                </td>
                                            </tr>
                                            <tr class="columnheading">
												<td height="22px" align="left" width="2%">&nbsp;</td>
                                            	<td height="22px" align="left" width="13%">Amber Period</td>
                                                <td height="22px" align="left" width="85%"><input class="itemfont" style="width:30px" name="txtAmberDays" id="txtAmberDays" type="text" value="0"/></td>
                                            </tr>
                                            <% if session("boa") <> 0 then %>
                                                <tr class="columnheading">
                                                    <td height="22px" align="left" width="2%">&nbsp;</td>
                                                    <td height="22px" align="left" width="13%">Enduring Q:</td>
                                                    <td height="22px" align="left" width="85%"><input name="chkEnduring" type="checkbox" id="chkEnduring" value="1"></td>
                                                </tr>
                                                <tr class="columnheading">
                                                    <td height="22px" align="left" width="2%">&nbsp;</td>
                                                    <td height="22px" align="left" width="13%">Contingent Q:</td>
                                                    <td height="22px" align="left" width="85%"><input name="chkContingent" type="checkbox" id="chkContingent" value="1"></td>
                                                </tr>
                                            <% end if %>
											<tr>
												<td colspan="3" height="22px">&nbsp;</td>
											</tr>
						  					<tr>
       											<td colspan=3 class=titlearealine  height=1></td> 
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
	  
	var q = document.frmDetails.txtDescription.value;
	q = q.killWhiteSpace();
	var qt = document.frmDetails.cboQType.value;
	var vp = document.frmDetails.cboVPeriod.value;
	var a = document.frmDetails.txtAmberDays.value;
	var re = /[a-z,A-Z\^,£<>$":;{}\[\]\*\.+\-_=~#@?\\\/%\'!¬`¦&]/g;

	/* make sure they have entered comments for the next stage */
	if(q == "")
	{
		errMsg += "Qualification\n"
		error = true;
	}
	
	if(qt == 0)
	{
		errMsg += "Q Type\n"
		error = true;
	}
	
	if(vp == 0)
	{
		errMsg += "Validity Period\n"
		error = true;
	}
	
	if(a == "")
	{
		errMsg += "Amber Period"
		error = true;
	}
	
	if(re.test(a))
	{
		errMsg += "Amber Period - Numeric characters only\n"
		error = true;
	}

	if(error == true)
	{
		alert(errMsg)
		return;	  		
	} 
	
    document.frmDetails.submit();  
}

function QAuth(val)
{
	var strSplit = val.split("*");
	if(strSplit[1] == 'True')
	{
		document.getElementById('txtLongDesc').style.backgroundColor='#FFFFFF';
		document.getElementById('txtLongDesc').disabled = false;
		document.getElementById('txtLongDesc').focus();
	}
	else
	{
		document.getElementById('txtLongDesc').style.backgroundColor='#E1E1E1';
		document.getElementById('txtLongDesc').disabled = true;
		document.getElementById('txtLongDesc').value = "";
	}
}

</Script>
