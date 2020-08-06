<!DOCTYPE HTML >

<!--#include file="Includes/security.inc"--> 
<!--#include file="Connection/Connection.inc"-->
<!--#include file="Includes/checkmanager.inc"-->  
<!--include file="Includes/manageradmin.inc"-->  

<%
tab=6
strTable = "tblstaff"
strGoTo = "AdminPeRsList.asp"   ' asp page to return to once record is deleted
strTabID = "staffID"              ' key field name for table        
strRecid = "staffID"

'checking for Team Manager Status etc'
strCommand = "spPeRsDetail"

set objCmd = server.CreateObject("ADODB.Command")
set objPara = server.CreateObject("ADODB.Parameter")
objCmd.ActiveConnection = con
objCmd.CommandText = strCommand
objCmd.CommandType = 4		

set objPara = objCmd.CreateParameter ("RecID",3,1,5, request("StaffID"))
objCmd.Parameters.Append objPara

set rsRecSet = objCmd.Execute	'Execute CommandText when using "ADODB.Command" object'

objCmd.CommandText = "spPersDel"	'Name of Stored Procedure'
set objPara = objCmd.CreateParameter("@DelOK",3,2)
objCmd.Parameters.Append objPara
objCmd.Execute	
strDelOK = objCmd.Parameters("@DelOK")
objCmd.Parameters.delete ("@DelOK")

strCommand = "spPeRsVacsSummary"
objCmd.CommandText = strCommand
set objPara = objCmd.CreateParameter ("startDate",200,1,20, request("thisDate"))
objCmd.Parameters.Append objPara

set rsRecSet = objCmd.Execute	'Execute CommandText when using "ADODB.Command" object'

for x = 1 to objCmd.parameters.count
	objCmd.parameters.delete(0)
next

objCmd.CommandText = "spPeRsVacsObtained"	'Name of Stored Procedure
set objPara = objCmd.CreateParameter ("nodeID",3,1,5, nodeID)
objCmd.Parameters.Append objPara
set objPara = objCmd.CreateParameter ("RecID",3,1,5, request("StaffID"))
objCmd.Parameters.Append objPara

set rsQualificationDetails = objCmd.Execute	'Execute CommandText when using "ADODB.Command" object'
%>

<script type="text/javascript" src="calendar.js"></script>

<html>
<head>

<!--#include file="Includes/IECompatability.inc"-->


<title>Personnel Details</title>
<link rel="stylesheet" type="text/css" href="Includes/AMDB.css" media="Screen"/>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">

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
-->
</style>

</head>
<body>
<form action="" method="POST" name="frmDetails">
	<input name="staffID" id="staffID" type="hidden" value="<%=request("StaffID")%>">
	<input Type="Hidden" name="HiddenDate" id="HiddenDate">

	<table border=0 cellpadding=0 cellspacing=0 width=100%>
		<!--#include file="Includes/hierarchyStaffDetails.inc"--> 
		<tr>
			<td colspan=10 class=titlearealine  height=1></td> 
		</tr>
		<tr class=SectionHeader>
			<td>
				<% if strManager = 1 then %>
					<table border=0 cellpadding=0 cellspacing=0 >
						<tr>
							<td height="25px" class=toolbar width=8><td width=20><a class=itemfontlink  href="HierarchyPersVacsAdd.asp?staffID=<%=request("staffID")%>&thisDate=<%=request("thisDate")%>"><img class="imagelink" src="images/editgrid.gif"></A></td>
							<td height="25px" class=toolbar valign="middle" >Add Vaccinations</td>
							<td height="25px" class=titleseparator valign="middle" width=14 align="center">|</td>
							<td height="25px" width=20><a class=itemfontlink  href="HierarchyPersVacsRemove.asp?staffID=<%=request("staffID")%>&thisDate=<%=request("thisDate")%>"><img class="imagelink" src="images/editgrid.gif"></A></td>
							<td height="25px" class=toolbar valign="middle" >Remove Vaccinations</td>
						</tr>
					</table>
				<% end if %>
			</td>
		</tr>
		<tr>
			<td>
				<table border=0 cellpadding=0 cellspacing=0 width=100%>
					<tr>
						<td height="22px" colspan=6>&nbsp;</td>
					</tr>
					<tr class=columnheading>
						<td align="left" width="2%" height="22px">&nbsp;</td>
						<td align="left" width="13%" height="22px">First Name:</td>
						<td align="left" width="25%" height="22px" class=itemfont><%=rsRecSet("firstname")%></td>
						<td align="left" width="13%" height="22px">Surname:</td>
						<td align="left" width="25%" height="22px" class=itemfont><%=rsRecSet("surname")%></td>
						<td align="left" width="22%" height="22px">&nbsp;</td>
					</tr>
					<tr class=columnheading>
						<td align="left" width="2%" height="22px">&nbsp;</td>
						<td align="left" width="13%" height="22px">Service No:</td>
						<td align="left" width="25%" height="22px" class=itemfont><%=rsRecSet("serviceno")%></td>
						<td align="left" width="13%" height="22px">Known as:</td>
						<td align="left" width="25%" height="22px" class=itemfont><%=rsRecSet("knownas")%></td>
						<td align="left" width="22%" height="22px">&nbsp;</td>
					</tr>
					<tr class=columnheading>
						<td align="left" width="2%" height="22px">&nbsp;</td>
						<td align="left" width="13%" height="22px">Rank:</td>
						<td align="left" width="25%" height="22px" class=itemfont><%=rsRecSet("rank")%></td>
						<td align="left" width="13%" height="22px">Trade:</td>
						<td align="left" width="25%" height="22px" class=itemfont><%=rsRecSet("trade")%></td>
						<td align="left" width="22%" height="22px">&nbsp;</td>
					</tr>
					<tr class=columnheading>
						<td align="left" width="2%" height="22px">&nbsp;</td>
						<td align="left" width="13%" height="22px">Post:</td>
						<td align="left" width="25%" height="22px" class=itemfont><%=rsRecSet("post")%></td>
						<td align="left" width="13%" height="22px">Unit:</td>
						<td align="left" width="25%" height="22px" class=itemfont><%=rsRecSet("unit")%></td>
						<td align="left" width="22%" height="22px">&nbsp;</td>
					</tr>
					<tr>
						<td colspan=6 height="22px">&nbsp;</td>
					</tr>
					<tr>
						<td colspan=6 class=titlearealine height=1></td> 
					</tr>
					<tr class=SectionHeader>
						<td width="2%" align="left" height="22px">&nbsp;</td>
						<td width="50%" align="left" height="22px" colspan=5>
    						<table border=0 cellpadding=0 cellspacing=0 width=100%>
    							<tr class="SectionHeader toolbar">
                                    <td width="32%" align="left" height="25px">Summary of Vaccinations</td>
                                    <td width="10%" align="center" height="25px">Held</td>
                                    <td width="10%" align="center" height="25px">Valid From</td>
                                    <td width="10%" align="center" height="25px">Valid To</td>
                                    <td width="10%" align="center" height="25px">Status</td>
                                    <td width="10%" align="center" height="25px"><% if request("QTypeID")=2 then%>Competent<% end if %></td>
                                    <td width="18%" align="center" height="25px">&nbsp;</td>
                                </tr>
								<tr>
									<td colspan=7 height="22px">&nbsp;</td>
								</tr>                                
								<% if rsQualificationDetails.recordcount > 0 then %>
									<% do while not rsQualificationDetails.eof %>
                                    	<% strVaccination = rsQualificationDetails("description") %>
                                        <% strValidFrom = rsQualificationDetails("ValidFrom") %>
                                        <% strValidTo = rsQualificationDetails("ValidTo") %>
                                        <% strCompetent = rsQualificationDetails("Competent") %>

                                        <tr>
                                        	<% if rsQualificationDetails("staffID") <> "" then %>
												<td align="left" height="22px" class=toolbar><a href="javascript:DisplayForm('<%=formatdatetime(strValidFrom,2)%>','<%=strCompetent%>','<%=rsQualificationDetails("StaffMVID")%>','<%=strVaccination%>');" onclick="DisplayForm" class=ItemLink><%=strVaccination%></A></td>
                                                <td align="center" height="22px"><img src="images/yes.gif"></td>
                                                <td align="center" height="22px" class=toolbar><%=formatDateTime(strValidFrom,2) %></td>
                                                <td align="center" height="22px" class=toolbar><%=formatDateTime(strValidTo,2) %></td>
                                                <td align="center" height="22px" class=toolbar>
													<% if date > strValidTo then %>
														<img src="Images/red box.gif" alt="Out of Date" width="12" height="12">
													<% elseif date >= strValidFrom and date <= strValidTo then %>
														<img src="Images/green box.gif" alt="In Date" width="12" height="12">
													<% else %>
														&nbsp;
                                                    <% end if %>
                                                </td>
                                                <td align="center" height="22px" class=toolbar><% if request("QTypeID")=2 then%><%= strCompetent %><% end if %></td>
                                                <td align="center" height="22px" class=toolbar>&nbsp;</td>
											<% else %>
                                            	<td class=toolbar><%=strVaccination%></td>
                                                <td align="center" height="22px" class=toolbar><img src="images/no.gif"></td>
                                                <td align="center" height="22px" class=toolbar>-</td>
                                                <td align="center" height="22px" class=toolbar>-</td>
                                                <td align="center" height="22px" class=toolbar>-</td>
                                                <td align="center" height="22px" class=toolbar><% if request("QTypeID")=2 then%><%= strCompetent %><% end if %></td>
                                                <td align="center" height="22px" class=toolbar>&nbsp;</td>
                                            <% end if %>
											<% rsQualificationDetails.movenext %>
                                        </tr>
                                	<% loop %>
								<% else %>
                                    <tr>
                                        <td colspan="7" height="22px" class=toolbar>None Required</td>
                                    </tr>
								<% end if %>
                                <tr>
                                    <td colspan="7" height="22px">&nbsp;</td>
                                </tr>
							</table>
                    	</td>
					</tr>
					<tr>
						<td colspan=6 class=titlearealine  height=1></td> 
					</tr>
				</table>
			</td>
		</tr>
	</table>
</form>

<form action="ManningPersSingleVaccinationUpdate.asp" method="post" name="popupDetails">
	<input type=hidden name="staffID" id="staffID" value=<%=request("staffID")%>>
	<input type="hidden" name="ReturnTo" id="ReturnTo" value="HierarchyPersVacs.asp">
	<input Type="hidden" name="thisDate" id="thisDate" value="<%=request("thisDate")%>">	
	<input Type="Hidden" name="staffMVID" id="staffMVID">
	
  <div id="PopUpwindow1" class="PopUpWindow">
	  <table border=0 cellpadding=0 cellspacing=0 width=100%>
		  <tr>
			  <td colspan=3 height=22 align="center" class=MenuStyleParent><u>Confirm Vaccination Details</u></td>
		  </tr>
          <tr>
           	  <td colspan="3" height="22px">&nbsp;</td>
          </tr>
		  <tr class=columnheading height=22>
			  <td valign="middle" width=2%></td>
			  <td valign="middle" width=30%>Qualification:</td>
			  <td valign="middle" width=68% class=toolbar><div id="QName"></div></td>
		  </tr>
		  <tr class=columnheading height=22>
			  <td valign="middle" width=2%></td>
			  <td valign="middle" width=30%>Valid From:</td>
			  <td valign="middle" width=68% class=itemfont>
				  <input id="DateAttained" class="itemfont"  style="Width:75px;"  name="DateAttained" value = "<%= newTodaydate %>" readonly>&nbsp;
				  <img src="images/cal.gif" onclick="calSet(DateAttained)" alt="Calendar" align="absmiddle" style="cursor:hand;"></td>
			  </td>
		  </tr>
		  <% if request("QTypeID")=2 then %>
			  <tr class=columnheading height=22>
				  <td valign="middle" width=2%></td>
				  <td valign="middle" width=30%>Competent:</td>
				  <td valign="middle" width=68% class=itemfont>
					  <select class="itemfont" name="Competent" id="Competent">
						  <option value=A>A</option>
						  <option value=B>B</option>
						  <option value=C>C</option>
						  <option value=N selected>N</option>
					  </select>
				  </td>
			  </tr>
              <tr>
               	  <td colspan="3" height="22px">&nbsp;</td>
              </tr>
		  <% else %>
			  <tr class=columnheading height=22>
				  <td valign="middle" width=2%></td>
				  <td valign="middle" width=30%></td>
				  <td valign="middle" width=68% class=itemfont><input type=hidden name="Competent" id="Competent" value=N></td>
			  </tr>
		  <% end if %>
		  <tr>
			  <td colspan=3 align="center" height=22><Input CLASS="StandardButton" Type=Button style="width:60px;" Value=Cancel onclick="PopUpwindow1.style.visibility = 'hidden';"><Input CLASS="StandardButton" Type=Button style="width:60px;" Value=OK onclick="popupDetails.submit();"></td>
		  </tr>
		  <tr>
			  <td colspan=3 height=22>&nbsp;</td>
		  </tr>
	  </table>
  </div>
</form>

</body>
</html>

<script language="javascript">

function checkDelete()
{
	var delOK = false 
    
	var input_box = confirm("Are you sure you want to delete this Record ?")
	if(input_box==true)
	{
		delOK = true;
	}
	return delOK;
}

function DisplayForm(ValidDate,Competent,staffMVID,Description)
{
	document.popupDetails.staffMVID.value = staffMVID;
	var months = new Array('Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec');
	var datestr_array = ValidDate.split("/");
	var monthInt=datestr_array[1]
	var newMonth=months[monthInt-1];
	document.popupDetails.DateAttained.value = ValidDate; //datestr_array[0] + " " + newMonth + " " + datestr_array[2];
	document.getElementById('QName').innerHTML=Description;
	document.getElementById('PopUpwindow1').style.visibility = "Visible";
}

</script>

