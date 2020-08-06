<!DOCTYPE HTML >
<!--#include file="Includes/security.inc"--> 
<!--#include file="Includes/checkadmin.asp"-->
<!--#include file="Connection/Connection.inc"-->
<%
' sets date to UK format - dmy
session.lcid=2057

dim strAction
dim strTable
dim strSQL
dim strGoTo

strAction="Add"
strGoTo="AdminPersAdd.asp"

' get the rank list - Only ACTIVE Ranks
strCommand = "spListRanks"

set objCmd = server.CreateObject("ADODB.Command")
set objPara = server.CreateObject("ADODB.Parameter")
objCmd.ActiveConnection = con
objCmd.CommandType = 4	

objCmd.CommandText = strCommand
set objPara = objCmd.CreateParameter ("nodeID",200,1,50, nodeID)
objCmd.Parameters.Append objPara 

set rsRank = objCmd.Execute	'Execute CommandText when using "ADODB.Command" object
'	for x = 1 to objCmd.parameters.count
'		objCmd.parameters.delete(0)
'	next

strCommand = "spListTable"
objCmd.CommandText = strCommand
' now get the MES details
strTable = "tblMES"
set objPara = objCmd.CreateParameter ("TableName",200,1,50, strTable)
objCmd.Parameters.Append objPara
set rsMES = objCmd.Execute	'Execute CommandText when using "ADODB.Command" object
'	for x = 1 to objCmd.parameters.count
'		objCmd.parameters.delete(0)
'	next

' now get the Trades
'set objCmd = server.CreateObject("ADODB.Command")
'objCmd.ActiveConnection = con
objCmd.Parameters.delete("TableName") 
objCmd.CommandText = "spListTrades"	'Name of Stored Procedure
'objCmd.CommandType = 4				'Code for Stored Procedure
set rsTrade = objCmd.Execute	'Execute CommandText when using "ADODB.Command" object
	
%>
<html>
<head> 

<!--#include file="Includes/IECompatability.inc"-->
<title><%= PageTitle %></title>
<link rel="stylesheet" type="text/css" href="Includes/AMDB.css" media="Screen"/>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<script type="text/javascript" src="Includes/ajax.js"></script>

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
.style2 {color: #F00000}
-->
</style>

</head>
<body>

<div id="overDiv" style="position:absolute; visibility:hidden; z-index:1000;"></div>

<form  action="UpdatePeRs.asp?strAction=<%=strAction%>&strGoto=<%=strGoTo%>" method="post" name="frmDetails">
    <input type="hidden" name="administrator" id="administrator" value=""> 
	<table  height="100%" cellspacing="0" cellPadding="0" width="100%" border="0">
		<tr>
			<td>
				<!--#include file="Includes/Header.inc"-->
                <table cellSpacing=0 cellPadding=0 width=100% border=0 >
                    <tr style="font-size:10pt;" height=26px>
                        <td width=10><img style="margin-left:10px;" src="cms_icons/png/24x24/process.png" width="24" height="24"></td>
                        <td class="staticdatamenu"><font class="youAreHere">CMS Admin Menu / <strong>Add New Personnel Details </strong></font></td>
                    </tr>
                    <tr><td colspan=2 class=titlearealine  height=1></td></tr>
				</table>
          
  		  <table width=100% height='<%=session("heightIs")%>px' border=0 cellpadding=0 cellspacing=0> 
      		<tr valign=Top>
        	  <td class="sidemenuwidth" background="Images/tableback.png"><!--#include file="Includes/datamenu.inc"--></td>



						<td width="16">&nbsp;</td>
						<td align="left">
							<table border="0" cellpadding="0" cellspacing="0" width="100%">
								<tr height="25" class="SectionHeader">
									<td>
                                        <table border="0" cellpadding="0" cellspacing="0" >
                                            <td class="toolbar" width="8">&nbsp;</td>
                                            <td width="20"><a href="javascript:checkThis();"><img class="imagelink" src="images/saveitem.gif"></a></td>
                                            <td class="toolbar" valign="middle">Save and Close</td>
                                            <td class=titleseparator valign="middle" width="14" align="center">|</td>
                                            <td class="toolbar" valign="middle"><a class="itemfontlink" href="AdminPeRsList.asp">Back To List</a></td>
                                        </table>
									</td>
								</tr>
								<tr>
									<td>
										<table width="100%" border="0" cellpadding="0" cellspacing="0">
                                            <tr height="20px">
                                                <td>&nbsp;</td>
                                            </tr>
                                            <tr height="16">
                                                <td class="itemfont" height="20px"><font class="style2"><span class="style2">*</span> Mandatory Fields</font></td>
                                            </tr>
                                            <tr height="20px">
                                                <td>&nbsp;</td>
                                            </tr>
                                        </table>
										<table width="100%" border="0" cellpadding="0" cellspacing="0">
                                        	<tr valign="top">
                                                <td width="8px">&nbsp;</td>
                                                <td width="400px">
                                                    <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                                        <tr class="personalDetails">
                                                            <td width="160px">First Name:</td>
                                                            <td class="itemfont" width="200px"><input name="txtfirstname" type="text" style="width:160px;" id="txtfirstname" class="inputbox itemfont" Value="<%=request("txtfname")%>">&nbsp;<span class="style2">*</span></td>
                                                        </tr>
                                                        <tr height="5px">
                                                            <td colspan="2">&nbsp;</td>
                                                        </tr>
                                                        <tr class="personalDetails">
															<td width="160px">Service No:</td>
                      										<td class="itemfont" width="200px"><input name="txtserviceno" type="text" style="width:90px;" class="inputbox itemfont" id="txtserviceno" Value="<%=request("txtserviceno")%>">&nbsp;<span class="style2">*<%if request("duplicateServiceNo")=1 then%>&nbsp;Already exists<%end if%></span></td>
                                                        </tr>
                                                        <tr height="5px">
                                                            <td colspan="2">&nbsp;</td>
                                                        </tr>
                                                        <tr class="personalDetails">
															<td width="160px">Rank:</td>
															<td class="itemfont" width="200px">
                                                                <select name="cmbRank" id="cmbRank" class="inputbox itemfont" style="width:80px;">
                                                                    <option value="">...Select...</option>
                                                                    <%do while not rsRank.eof %>
                                                                    		<option value = "<%= rsRank("rankid") %>" <%if cint(request("cmbRank"))=cint(rsRank("rankid")) then response.write (" selected")%>><%= rsRank("shortDesc") %></option>
                                                                    	<%  
                                                                    	rsRank.movenext
                                                                    loop%>
                                                                </select>&nbsp;<span class="style2">*</span>
                                                            </td>
                                                        </tr>
                                                        <tr height="5px">
                                                            <td colspan="2">&nbsp;</td>
                                                        </tr>
                                                        <tr class="personalDetails">
															<td width="160px">Gender:</td>
                                                            <td class="itemfont" width="200px">
                                                                <select  class="inputbox" name="cmbGender" id="cmbGender" style="width:70px;">
                                                                    <option value=""></option>
                                                                    <option value="M" <%if request("cmbGender") = "M" then response.write(" Selected")%>>Male</option>
                                                                    <option value="F" <%if request("cmbGender") = "F" then response.write(" Selected")%>>Female</option>
                                                                </select>&nbsp;<span class="style2">*</span>
                                                            </td>
                                                        </tr>
                                                        <tr height="5px">
                                                            <td colspan="2">&nbsp;</td>
                                                        </tr>
                                                        <tr class="personalDetails">
															<td width="160px">Arrival Date:</td>
															<td class="itemfont" width="200px">
                                                                <input name="txtarrival" type="text" id="txtarrival" class="itemfont inputbox"  style="Width:85px;" value ="<%=request("txtarrival")%>" readonly onclick="calSet(this)">
                                                                &nbsp;<img src="images/cal.gif" alt="Calender" onclick="calSet(txtarrival)" style="cursor:hand;">&nbsp;<span class="style2">*</span>
                                                            </td>
                                                        </tr>
                                                        <tr height="5px">
                                                            <td colspan="2">&nbsp;</td>
                                                        </tr>
                                                        <tr class="personalDetails">
                                                            <td width="160px">Last OOA Date:</td>
                                                            <td class="itemfont" width="200px">
                                                                <input name="txtooa" type="text" id="txtooa" class=" itemfont inputbox"  style="Width:85px;"  value ="" readonly onclick="calSet(this)">
                                                                &nbsp;<img src="images/cal.gif" alt="Calender" onclick="calSet(txtooa)" style="cursor:hand;">
                                                            </td>
                                                        </tr>
                                                        <tr height="5px">
                                                            <td colspan="2">&nbsp;</td>
                                                        </tr>
                                                        <tr class="personalDetails">
                                                            <td width="160px">Home Phone:</td>
                                                            <td class="itemfont" width="200px"><input name="txthphone" type="text" style="width:125px;" id="txthphone" class="inputbox itemfont" <%if request("duplicateServiceNo")=1 then%>Value="<%=request("txthphone")%>"<%end if%>></td>
                                                        </tr>
                                                        <tr height="5px">
                                                            <td colspan="2">&nbsp;</td>
                                                        </tr>
                                                        <tr class="personalDetails">
                                                            <td width="160px">Town of Birth:</td>
                                                            <td class="itemfont" width="200px"><input name="txtpob" type="text" style="width:125px;" id="txtpob" class="inputbox itemfont" <%if request("duplicateServiceNo")=1 then%>Value="<%=request("txtpob")%>"<%end if%>></td>
                                                        </tr>
                                                        <tr height="5px">
                                                            <td colspan="2">&nbsp;</td>
                                                        </tr>
                                                        <tr class="personalDetails">
                                                            <td width="160px">Passport Issued By:</td>
                                                            <td class="itemfont" width="200px"><input name="txtissueby" type="text" style="width:125px;" id="txtissueby" class="inputbox itemfont" <%if request("duplicateServiceNo")=1 then%>Value="<%=request("txtissueby")%>"<%end if%>></td>
                                                        </tr>
                                                        <tr height="5px">
                                                            <td colspan="2">&nbsp;</td>
                                                        </tr>
                                                        <tr class="personalDetails">
                                                            <td width="160px">Administrator:</td>
                                                            <td class="itemfont" width="200px">
                                                                <select  class="inputbox" name="cbadmin" id="cbadmin" style="width:50px;">
                                                                    <option value=0  <%if cint(request("cbadmin"))=0 then response.write (" selected")%>>No</option>
                                                                    <option value=1  <%if cint(request("cbadmin"))=1 then response.write (" selected")%>>Yes</option>
                                                                </select>
                                                            </td>
                                                        </tr>
                                                        <tr height="5px">
                                                            <td colspan="2">&nbsp;</td>
                                                        </tr>
                                                        <tr class="personalDetails">
                                                            <td width="160px">Welfare POC:</td>
                                                            <td class="itemfont" width="200px"><input name="txtpoc" type="text" style="width:160px;" id="txtpoc" class="inputbox itemfont" <%if request("duplicateServiceNo")=1 then%>Value="<%=request("txtpoc")%>"<%end if%>></td>
                                                        </tr>
                                                        <tr height="5px">
                                                            <td colspan="2">&nbsp;</td>
                                                        </tr>
                                                        <tr class="personalDetails">
                                                            <td width="160px">Welfare Wishes:</td>
                                                            <td class="itemfont" width="200px"><textarea name="txtwwishes" rows="5" class="pickbox" id="txtwwishes" ><%if request("duplicateServiceNo")=1 then%><%=request("txtwwishes")%><%end if%></textarea></td>
                                                        </tr>
                                                        <tr height="5px">
                                                            <td colspan="2">&nbsp;</td>
                                                        </tr>
                                                        <tr class="personalDetails">                                                        
                                                            <td width="160px">Notes:</td>
                                                            <td class="itemfont" width="200px"><textarea name="txtnotes" rows="5" class="pickbox" id="txtnotes" ><%if request("duplicateServiceNo")=1 then%><%=request("txtnotes")%><%end if%></textarea></td>
                                                        </tr>
                                                        <tr height="5px">
                                                            <td colspan="2">&nbsp;</td>
                                                        </tr>
                                                        <tr class="personalDetails">                                                        
                                                            <td width="160px">Weapon No:</td>
                                                            <td class="itemfont" width="200px"><input name="txtWeaponNo" type="text" id="txtWeaponNo" style="width:160px" class="inputbox itemfont" value=""\></td>
                                                        </tr>
                                                        <tr height="5px">
                                                            <td colspan="2">&nbsp;</td>
                                                        </tr>
                                                        <tr class="personalDetails">                                                        
                                                            <td width="160px">Susat Required:</td>
                                                            <td class="itemfont" width="200px"><input name="chkSusat" type="checkbox" id="chkSusat" value="1"></td>
                                                        </tr>
                                                        <tr height="5px">
                                                            <td colspan="2">&nbsp;</td>
                                                        </tr>
                                                    </table>
                                                </td>
                                                
                                                <td class="toolbar" width="30px">&nbsp;</td>
                                                
                                                <td width="400px">
                                                    <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                                        <tr class="personalDetails">
                                                            <td width="160px">Surname:</td>
                                                            <td class="itemfont" width="200px"><input name="txtsurname" type="text" style="width:160px;" class="inputbox itemfont" id="txtsurname" value="<%=request("txtsname")%>">&nbsp;<span class="style2">*</span></td>
                                                        </tr>
                                                        <tr height="5px">
                                                            <td colspan="2">&nbsp;</td>
                                                        </tr>
														<tr class="personalDetails">
                                                            <td width="160px">Known As:</td>
                                                            <td class="itemfont" width="200px"><input name="txtknownas" type="text" style="width:120px;" id="txtknownas2" class="inputbox itemfont" Value="<%=request("txtknownas")%>"></td>
                                                        </tr>
                                                        <tr height="5px">
                                                            <td colspan="2">&nbsp;</td>
                                                        </tr>
														<tr class="personalDetails">
                                                            <td width="160px">Trade:</td>
                                                            <td class="itemfont" width="200px">
                                                                <select name="cmbTrade" id="cmbTrade" class="inputbox itemfont" style="width:190px;">
                                                                    <option value="">...Select...</option>
                                                                    <%do while not rsTrade.eof %>
                                                                        <option value = "<%= rsTrade("tradeid") %>"  <%if cint(request("cmbTrade"))=cint(rsTrade("tradeid")) then response.write (" selected")%>><%= rsTrade("description") %></option>
                                                                        <% rsTrade.movenext
                                                                    loop%>
                                                                </select>&nbsp;<span class="style2">*</span>
                                                            </td>
                                                        </tr>
                                                        <tr height="5px">
                                                            <td colspan="2">&nbsp;</td>
                                                        </tr>
														<tr class="personalDetails">
                                                            <td width="160px">MES:</td>
                                                            <td class="itemfont" width="200px">
                                                                <select name="cmbmes" id="cmbmes" class="inputbox itemfont" style="width:90px;">
                                                                    <option value="">...Select...</option>
                                                                    <%do while not rsMES.eof %>
                                                                        <option value = "<%= rsMES("mesID") %>" <%if cint(request("cmbmes"))=cint(rsMES("mesid")) then response.write (" selected")%>><%= rsMES("description") %></option>
                                                                        <% rsMES.movenext
                                                                    loop%>
                                                                </select>                      
                                                            </td>
                                                        </tr>
                                                        <tr height="5px">
                                                            <td colspan="2">&nbsp;</td>
                                                        </tr>
														<tr class="personalDetails">
                                                            <td width="160px">Posting Due Date:</td>
                                                            <td class="itemfont" width="200px">
                                                                <input name="txtposting" type="text" id="txtposting" class=" itemfont inputbox"  style="Width:85px;"  value ="" readonly onclick="calSet(this)">	
                                                                &nbsp;<img src="images/cal.gif" alt="Calender" onclick="calSet(txtposting)" style="cursor:hand;">
                                                            </td>
                                                        </tr>
                                                        <tr height="5px">
                                                            <td colspan="2">&nbsp;</td>
                                                        </tr>
														<tr class="personalDetails">
                                                            <td width="160px">Discharge Date:</td>
                                                            <td class="itemfont" width="200px">
                                                                <input name="txtdischarge" type="text" id="txtdischarge" class=" itemfont inputbox"  style="Width:85px;"  value ="" readonly onclick="calSet(this)">
                                                                &nbsp;<img src="images/cal.gif" alt="Calender" onclick="calSet(txtdischarge)" style="cursor:hand;">
                                                            </td>
                                                        </tr>
                                                        <tr height="5px">
                                                            <td colspan="2">&nbsp;</td>
                                                        </tr>
														<tr class="personalDetails">
                                                            <td width="160px">Mobile:</td>
                                                            <td class="itemfont" width="200px"><input name="txtmobile" type="text" style="width:125px;" id="txtmobile2" class="inputbox itemfont" <%if request("duplicateServiceNo")=1 then%>Value="<%=request("txtmobile")%>"<%end if%>></td>
                                                        </tr>
                                                        <tr height="5px">
                                                            <td colspan="2">&nbsp;</td>
                                                        </tr>
														<tr class="personalDetails">
                                                            <td width="160px">Work No.:</td>
                                                            <td class="itemfont" width="200px"><input name="txtWorkPhone" type="text" style="width:125px;" id="txtWorkPhone" class="inputbox itemfont" <%if request("duplicateServiceNo")=1 then%>Value="<%=request("txtWorkPhone")%>"<%end if%>></td>
                                                        </tr>
                                                        <tr height="5px">
                                                            <td colspan="2">&nbsp;</td>
                                                        </tr>
														<tr class="personalDetails">
                                                            <td width="160px">Passport No:</td>
                                                            <td class="itemfont" width="200px"><input name="txtpptno" type="text" style="width:125px;" id="txtpptno" class="inputbox itemfont" <%if request("duplicateServiceNo")=1 then%>Value="<%=request("txtpptno")%>"<%end if%>></td>
                                                        </tr>
                                                        <tr height="5px">
                                                            <td colspan="2">&nbsp;</td>
                                                        </tr>
														<tr class="personalDetails">
                                                            <td width="160px">Passport Expiry Date:</td>
                                                            <td class="itemfont" width="200px">
                                                                <input name="txtexpiry" type="text" id="txtexpiry" class=" itemfont inputbox"  style="Width:85px;"  value ="" readonly onclick="calSet(this)">	
                                                                &nbsp;<img src="images/cal.gif" alt="Calender" onclick="calSet(txtexpiry)" style="cursor:hand;">
                                                            </td>
                                                        </tr>
                                                        <tr height="5px">
                                                            <td colspan="2">&nbsp;</td>
                                                        </tr>
														<tr class="personalDetails">
                                                            <td width="160px">Welfare Handbook Issued:</td>
                                                            <td class="itemfont" width="200px">
                                                                <input name="txthandbook" type="text" id="txthandbook" class=" itemfont inputbox"  style="Width:85px;"  value ="" readonly onclick="calSet(this)">	
                                                                &nbsp;<img src="images/cal.gif" alt="Calender" onclick="calSet(txthandbook)" style="cursor:hand;">
                                                            </td>
                                                        </tr>
                                                        <tr height="5px">
                                                            <td colspan="2">&nbsp;</td>
                                                        </tr>
														<tr class="personalDetails">
                                                            <td width="160px">Date of Birth: </td>
                                                            <td class="itemfont" width="200px">
                                                                <input name="txtdob" type="text" id="txtdob" class=" itemfont inputbox"  style="Width:85px;"  value ="" readonly onClick="calSet(this)">
                                                                &nbsp;<img src="images/cal.gif" alt="Calender" onclick="calSet(txtdob)" style="cursor:hand;"><!--&nbsp;<span class="style2">*</span>-->
                                                            </td>
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
			</td>
		</tr>
	</table>
</form>


</body>
</html>

<script type="text/javascript" src="calendar.js"></script>
<script language="javascript">

function checkThis()
{
	var txtfnm = document.frmDetails.txtfirstname.value;
	var txtsnm = document.frmDetails.txtsurname.value; 
	var txtsvn = document.frmDetails.txtserviceno.value;
	var txtkas = document.frmDetails.txtknownas.value;
	var txthph = document.frmDetails.txthphone.value;
	var txtmob = document.frmDetails.txtmobile.value;
	var txtpob = document.frmDetails.txtpob.value;
	var txtppn = document.frmDetails.txtpptno.value;
	var txtiss = document.frmDetails.txtissueby.value;
	var txtpoc = document.frmDetails.txtpoc.value;
	var txtwfw = document.frmDetails.txtwwishes.value;
	var txtarr = document.frmDetails.txtarrival.value;
	var txtpst = document.frmDetails.txtposting.value;
	var txtppp = document.frmDetails.txtexpiry.value;
	var txtwlf = document.frmDetails.txthandbook.value;

	var errMsg = "Please provide/correct the following:\n\n";
	var error = false;
	  
	/* make sure they have entered all details for the next stage */
    if(!txtfnm.length > 0) {
		errMsg += "First Name\n"
		error = true
		}
    if(!txtsvn.length > 0) {
		errMsg += "Service No.\n"
		error = true
		}
    if (document.frmDetails.cmbRank.value == ""){
		errMsg += "Rank\n"
		error = true
		}   
	if(document.frmDetails.cmbGender.value == "") {
		errMsg += "Gender\n"
		error = true
		}  
	if(!txtarr.length > 0) {
		errMsg += "Arrival Date\n"
		error = true
		} 
    if(!txtsnm.length > 0) {
		errMsg += "Surname\n"
		error = true
		}
    if (document.frmDetails.cmbTrade.value == ""){
		errMsg += "Trade\n"
		error = true
		}
	/**
	if (document.frmDetails.txtdob.value == "") {
		errMsg += "Date of Birth\n"
		error = true
		}
	**/
	/* now check the dates are in order */
	if(txtarr.length > 0 && txtpst.length > 0)
	{
		var dst = parseInt(txtarr.substring(0,2),10);
		var mst = parseInt(txtarr.substring(3,5),10);
		var yst = parseInt(txtarr.substring(6,10),10);
		var den = parseInt(txtpst.substring(0,2),10);
		var men = parseInt(txtpst.substring(3,5),10);
		var yen = parseInt(txtpst.substring(6,10),10);

		days0 = txtarr.substring(0,2);
		months0 = txtarr.substring(3,5)-1;
		year0 = txtarr.substring(6,10);

		days1 = txtpst.substring(0,2);
		months1 = txtpst.substring(3,5)-1;
		year1 = txtpst.substring(6,10);

		dateStartedX = new Date();
		dateStartedX.setDate(1);

		dateStartedX.setYear(year0);
		dateStartedX.setMonth(months0);
		dateStartedX.setDate(days0);

		dateEndedX = new Date();
		dateEndedX.setDate(1);

		dateEndedX.setYear(year1);
		dateEndedX.setMonth(months1);
		dateEndedX.setDate(days1);

		if(dateStartedX > dateEndedX)
		{
			errMsg += "Posting Due Date must be greater than the Arrival Date"
		}
	}
	  	   
	if(error == true)
	{
		alert(errMsg)
		return;	  		
	} 
	
	document.frmDetails.administrator.value=document.frmDetails.cbadmin.value;
    document.frmDetails.submit();  
}

</Script>
