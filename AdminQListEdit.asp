<!DOCTYPE HTML >

<!--#include file="Includes/security.inc"--> 
<!--#include file="Includes/checkadmin.asp"-->
<!--#include file="Connection/Connection.inc"-->

<%
dim strAction
dim strTable

strAction="Update"
strTable = "tblQs"
strRecID = "QID"
strCommand = "spRecDetail"

set objCmd = server.createobject("ADODB.Command")
set objPara = server.createobject("ADODB.Parameter")
objCmd.activeconnection = con
objCmd.commandtext = strCommand
objCmd.commandtype = 4

set objPara = objCmd.createparameter("RecID",3,1,5, request("QID"))
objCmd.parameters.append objPara
set objPara = objCmd.createparameter("TableID",200,1,50, strRecID)
objCmd.parameters.append objPara
set objPara = objCmd.createparameter("Tablename",200,1,50, strTable)
objCmd.parameters.append objPara
set rsRecSet = objCmd.execute	'Execute CommandText when using "ADODB.Command" object

for x = 1 to objCmd.parameters.count
	objCmd.parameters.delete(0)
next

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
<form  action="UpdateQList.asp?strAction=<%=strAction%>" method="POST" name="frmDetails">
	<input type="hidden" name="RecID" id="RecID" value="<%= request("QID") %>">  
    <table  height="100%" cellspacing=0 cellPadding=0 width=100% border=0>
    	<tr>
    		<td>
    			<!--#include file="Includes/Header.inc"--> 
    				<table cellSpacing=0 cellPadding=0 width=100% border=0 >
                    <tr style="font-size:10pt;" height=26px>
                        <td width=10><img style="margin-left:10px;" src="cms_icons/png/24x24/process.png" width="24" height="24"></td>
                        <td class="staticdatamenu"><font class="youAreHere">CMS Admin Menu / <strong>Edit Qualification Details</strong></font></td>
                    </tr>
                    <tr><td colspan=2 class=titlearealine  height=1></td></tr>
				</table>
          
  		  <table width=100% height='<%=session("heightIs")%>px' border=0 cellpadding=0 cellspacing=0> 
      		<tr valign=Top>
        	  <td class="sidemenuwidth" background="Images/tableback.png"><!--#include file="Includes/datamenu.inc"--></td>
                        <td width=16></td>
                        <td align=left>
                            <table border=0 cellpadding=0 cellspacing=0 width=100%>
                                <tr height=16 class=SectionHeader>
                                    <td>
                                        <table border=0 cellpadding=0 cellspacing=0>
                                            <tr>
                                                <td class=toolbar width=8></td>
                                                <td width=20><a href="javascript:checkThis();"><img class="imagelink" src="images/saveitem.gif"></A></td>
                                                <td class=toolbar valign="middle">Save and Close</td>
                                                <td class=titleseparator valign="middle" width=14 align="center">|</td>
                                                <td class=toolbar valign="middle"><a class= itemfontlink href="AdminQListDetail.asp?QID=<%=request("QID")%>">Back</a></td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <table width=100% border=0 cellpadding=0 cellspacing=0>
                                            <tr height=16>
                                                <td colspan="3">&nbsp;</td>
                                            </tr>
											<tr class=columnheading height=22>
												<td valign="middle" width=2%>&nbsp;</td>
												<td valign="middle" width=13%>Description:</td>
												<td valign="middle" width=85%><input class="itemfont" style="width: 360px" maxLength=300 name="txtDescription" id="txtDescription" type="text" value="<%= rsRecSet("Description") %>"/></td>
											</tr>
                                            <tr class="columnheading" height="22">
                                            	<td valign="middle" width="2%">&nbsp;</td>
                                                <td valign="middle" width="13%">Q Type:</td>
                                                <td valign="middle" width="85%">
                                                	<select name="cboQType" id="cboQType" class="itemfont" style="width: 150px" onChange="QAuth(this.value)">
                                                        <option value="0">...Select</option>
                                                        <% do while not rsQTypeList.eof %>
                                                            <option value="<%= rsQTypeList("QTypeID") %>*<%= rsQTypeList("Auth") %>" <% if rsQTypeList("QTypeID") = rsRecSet("QTypeID") then %> selected <% end if %>><%= rsQTypeList("description") %></option>
                                                            <% rsQTypeList.movenext %>
                                                        <% loop %>
                                                    </select>
                                                </td>
                                            </tr>
                                          
                                            <tr class="columnheading">
                                            	<td height="22" valign="middle" width="2%">&nbsp;</td>
                                                <td height="22" valign="top" width="13%">Description:</td>
                                                <td height="22" valign="middle" width="85%"><textarea name="txtLongDesc" rows="4" class="itemfont" id="txtLongDesc" style="width: 360px; height: 60px;"><%= rsRecSet("LongDesc") %></textarea></td>

                                            </tr>
                                           
                                            <tr class="columnheading" height="22px">
												<td align="left" width="2%">&nbsp;</td>
                                                <td align="left" width="13%">Validity Period:</td>
                                                <td align="left" width="85%">
                                            	    <select name="cboVPeriod" id="cboVPeriod" class="itemfont" style="width: 100px">
                                                    	<option value="0">...Select</option>
                                                		<% do while not rsValidityPeriodList.eof %>
                                                			<option value="<%= rsValidityPeriodList("vpID") %>" <% if rsValidityPeriodList("vpID") = rsRecSet("vpID") then %> selected <% end if %>><%= rsValidityPeriodList("description") %></option>
                                                			<% rsValidityPeriodList.movenext %>
                                                		<% loop %>
                                                	</Select>
                                                </td>
                                            </tr>
                                            <tr class="columnheading" height="22px">
												<td align="left" width="2%">&nbsp;</td>
                                            	<td align="left" width="13%">Amber Period</td>
                                                <td align="left" width="85%"><input class="itemfont" style="width:30px" name="txtAmberDays" id="txtAmberDays" type="text" value="<%= rsRecSet("Amber") %>"/></td>
                                            </tr>
                                            <% if session("boa") <> 0 then %>
                                                <tr class="columnheading" height="22px">
                                                    <td align="left" width="2%">&nbsp;</td>
                                                    <td align="left" width="13%">Enduring Q:</td>
                                                    <td align="left" width="85%"><input name="chkEnduring" type="checkbox" id="chkEnduring" <% if rsRecSet("Enduring") = true then %> checked <% end if %> value="1"></td>
                                                </tr>
                                                <tr class="columnheading" height="22px">
                                                    <td align="left" width="2%">&nbsp;</td>
                                                    <td align="left" width="13%">Contingent Q:</td>
                                                    <td align="left" width="85%"><input name="chkContingent" type="checkbox" id="chkContingent" <% if rsRecSet("Contingent") = true then %> checked <% end if %> value="1"></td>
                                                </tr>
                                            <% end if %>
                                            <tr height=16>
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
            </td>
        </tr>
    </table>
</form>

<%
	rsRecSet.close
	set rsRecSet = nothing
	con.close
	set con = nothing
%>

</body>
</html>

<script language="javascript">
var val = document.getElementById('cboQType').value;
//QAuth(val);

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
		errMsg += "Validity Period"
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

</script>
