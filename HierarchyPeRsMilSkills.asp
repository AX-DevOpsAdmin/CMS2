<!DOCTYPE HTML >

<!--#include file="Includes/security.inc"--> 
<!--#include file="Connection/Connection.inc"-->
<!--#include file="Includes/checkmanager.inc"-->  
<!--include file="Includes/manageradmin.inc"-->  
<%
tab=4
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

'set rsRecSet = objCmd.Execute	'Execute CommandText when using "ADODB.Command" object'

objCmd.CommandText = "spPersDel"	'Name of Stored Procedure'
set objPara = objCmd.CreateParameter("@DelOK",3,2)
objCmd.Parameters.Append objPara

strCommand = "spPeRsMilSkillsSummary"

set objCmd = server.CreateObject("ADODB.Command")
set objPara = server.CreateObject("ADODB.Parameter")
objCmd.ActiveConnection = con
objCmd.Activeconnection.cursorlocation = 3

objCmd.CommandText = strCommand
objCmd.CommandType = 4		

set objPara = objCmd.CreateParameter ("RecID",3,1,5, request("staffID"))
objCmd.Parameters.Append objPara
set objPara = objCmd.CreateParameter ("startDate",200,1,20, request("thisDate"))
objCmd.Parameters.Append objPara
set rsRecSet = objCmd.Execute	'Execute CommandText when using "ADODB.Command" object'

for x = 1 to objCmd.parameters.count
	objCmd.parameters.delete(0)
next

postID= int(session("postID"))
if postID = "" then postID = 0

objCmd.CommandText = "spPeRsMilitarySkillsObtained"	
objCmd.CommandType = 4				'Code for Stored Procedure'
set objPara = objCmd.CreateParameter ("staffID",3,1,0, request("staffID"))
objCmd.Parameters.Append objPara
set objPara = objCmd.CreateParameter ("postID",3,1,0, postID)
objCmd.Parameters.Append objPara
set objPara = objCmd.CreateParameter ("startDate",200,1,20, request("thisDate"))
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
	<input type=hidden name="staffID" id="staffID" value=<%=request("staffID")%>>
	<input type="Hidden" name="HiddenDate" id="HiddenDate">
	
	<table border=0 cellpadding=0 cellspacing=0 width=100%>
		<!--#include file="Includes/hierarchyStaffDetails.inc"--> 
		<tr>
			<td colspan=10 class=titlearealine  height=1></td> 
		</tr>
		<tr class=SectionHeader>
			<td>
				<% if strManager = "1" then %>
					<table border=0 cellpadding=0 cellspacing=0 >
						<tr>
							<td height="25px" class=toolbar width=8></td><td width=20><a class=itemfontlink  href="HierarchyPersMSAdd.asp?staffID=<%=request("staffID")%>&thisDate=<%=request("thisDate")%>"><img class="imagelink" src="images/editgrid.gif"></A></td>
							<td height="25px" class=toolbar valign="middle" >Add Military Skills</td>
							<td height="25px" class=titleseparator valign="middle" width=14 align="center">|</td>
							<td height="25px" width=20><a class=itemfontlink  href="HierarchyPersMSRemove.asp?staffID=<%=request("staffID")%>&thisDate=<%=request("thisDate")%>"><img class="imagelink" src="images/editgrid.gif"></A></td>
							<td height="25px" class=toolbar valign="middle" >Remove Military Skills</td>
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
                    <tr class=columnheading height=22>
                        <td align="left" width="2%" height="22px">&nbsp;</td>
                        <td align="left" width="13%" height="22px">Service No:</td>
                        <td align="left" width="25%" height="22px" class=itemfont><%=rsRecSet("serviceno")%></td>
                        <td align="left" width="13%" height="22px">Known as:</td>
                        <td align="left" width="25%" height="22px" class=itemfont><%=rsRecSet("knownas")%></td>
                        <td align="left" width="22%" height="22px">&nbsp;</td>
                    </tr>
                    <tr class=columnheading height=22>
                        <td align="left" width="2%" height="22px">&nbsp;</td>
                        <td align="left" width="13%" height="22px">Rank:</td>
                        <td align="left" width="25%" height="22px" class=itemfont><%=rsRecSet("rank")%></td>
                        <td align="left" width="13%" height="22px">Trade:</td>
                        <td align="left" width="25%" height="22px" class=itemfont><%=rsRecSet("trade")%></td>
                        <td align="left" width="22%" height="22px">&nbsp;</td>
                    </tr>
                    <tr class=columnheading height=22>
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
				</table>
                <table border=0 cellpadding=0 cellspacing=0 width=100%>
                    <tr class=SectionHeader>
                        <td width="2%" align="left" height="25px">&nbsp;</td>
                        <td width="98%" align="left" height="25px" colspan=5>
                            <table border=0 cellpadding=0 cellspacing=0 width=100%>
                                <tr class="SectionHeader toolbar">
                                    <td width="32%" align="left" height="25px">Summary of Military Skills</td>
                                    <td width="10%" align="center" height="25px">Held</td>
                                    <td width="10%" align="center" height="25px">Valid From</td>
                                    <td width="10%" align="center" height="25px">Valid To</td>
                                    <td width="10%" align="center" height="25px">Exempt</td>
                                    <td width="10%" align="center" height="25px">Status</td>
                                    <td width="10%" align="center" height="25px"><% if request("QTypeID")=2 then%>Competent<% end if %></td>
                                    <td width="8%" align="center" height="25px">&nbsp;</td>
                                </tr>
                                <tr>
                                    <td colspan=8 height="22px">&nbsp;</td>
                                </tr>
                                <% if rsQualificationDetails.recordcount > 0 then %>
                                    <% do while not rsQualificationDetails.eof %>
                                    
                                        <% strMilitarySkill = rsQualificationDetails("description") %>
                                        <% strValidFrom = rsQualificationDetails("ValidFrom") %>
                                        <% intDays = rsQualificationDetails("vpdays") %>
                                        <% strValidTo = dateadd("d", intDays, strValidFrom) %>
                                        <% intAmber = rsQualificationDetails("Amber") %>
                                        <% strAmberDate = dateadd("d", -intAmber, strValidTo) %>
                                        <% strQExempt = rsQualificationDetails("qExempt") %>
                                        <% strExempt = rsQualificationDetails("Exempt") %>
                                        <% strCompetent = rsQualificationDetails("Competent") %>
                                        
                                        <tr>
                                            <% if rsQualificationDetails("staffID") <> "" then %>
                                                <% if strExempt = 0 then %>
                                                    <td align="left" height="22px" class=toolbar><% if strManager = 1 then %><a href="javascript:DisplayForm('<%=formatdatetime(strValidFrom,2)%>','<%=strCompetent%>','<%=rsQualificationDetails("StaffMSID")%>','<%=strMilitarySkill%>','<%=strQExempt%>','<%=strExempt%>');" onclick="DisplayForm" class=ItemLink><%=strMilitarySkill%></A><% else %><%=strMilitarySkill%><% end if %></td>
                                                    <td align="center" height="22px"><img src="images/yes.gif"></td>
                                                    <td align="center" height="22px" class=toolbar><%=formatDateTime(strValidFrom,2) %></td>
                                                    <td align="center" height="22px" class=toolbar><%=formatDateTime(strValidTo,2) %></td>
                                                    <td align="center" height="22px"><img src="images/no.gif"></td>
                                                    <td align="center" height="22px">
                                                        <% if date > strValidTo then %>
                                                            <img src="Images/red box.gif" alt="Out of Date" width="12" height="12">
                                                        <% elseif date >= strAmberDate and date <= strValidTo then %>
                                                            <img src="Images/yellow box.gif" alt="Almost out of Date" width="12" height="12">
                                                        <% elseif date >= strValidFrom and date < strAmberDate then %>
                                                            <img src="Images/green box.gif" alt="In Date" width="12" height="12">
                                                        <% else %>
                                                            &nbsp;
                                                        <% end if %>
                                                    </td>
                                                    <td align="center" height="22px" class=toolbar><% if request("QTypeID")=2 then%><%= strCompetent %><% end if %></td>
                                                    <td align="center" height="22px">&nbsp;</td>
                                                <% else %>
                                                    <td align="left" height="22px" class=toolbar><% if strManager = 1 then %><a href="javascript:DisplayForm('<%=formatdatetime(strValidFrom,2)%>','<%=strCompetent%>','<%=rsQualificationDetails("StaffMSID")%>','<%=strMilitarySkill%>','<%=strQExempt%>','<%=strExempt%>');" onclick="DisplayForm" class=ItemLink><%=strMilitarySkill%></A><% else %><%=strMilitarySkill%><% end if %></td>
                                                    <td align="center" height="22px"><img src="images/no.gif"></td>
                                                    <td align="center" height="22px" class=toolbar>-</td>
                                                    <td align="center" height="22px" class=toolbar>-</td>
                                                    <td align="center" height="22px"><img src="images/yes.gif"></td>
                                                    <td align="center" height="22px" class=toolbar>-</td>
                                                    <td align="center" height="22px" class=toolbar><% if request("QTypeID")=2 then%><%= strCompetent %><% end if %></td>
                                                    <td align="center" height="22px">&nbsp;</td>
                                                <% end if %>
                                            <% else %>
                                                <td class=toolbar><%=strMilitarySkill%></td>
                                                <td align="center" height="22px" class=toolbar><img src="images/no.gif"></td>
                                                <td align="center" height="22px" class=toolbar>-</td>
                                                <td align="center" height="22px" class=toolbar>-</td>
                                                <td align="center" height="22px"><img src="images/no.gif"></td>
                                                <td align="center" height="22px" class=toolbar>-</td>
                                                <td align="center" height="22px" class=toolbar><% if request("QTypeID")=2 then%><%= strCompetent %><% end if %></td>
                                                <td align="center" height="22px">&nbsp;</td>
                                            <% end if %>
                                            <% rsQualificationDetails.movenext %>
                                        </tr>
                                    <% loop %>
                                <% else %>
                                    <tr>
                                        <td colspan="8" height="22px" class=toolbar>None Required</td>
                                    </tr>
                                <% end if %>
                                <tr>
                                    <td colspan="8" height="22px">&nbsp;</td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                    <tr>
                        <td colspan=7 class=titlearealine  height=1></td> 
                    </tr>
                </table>
			</td>
		</tr>
	</table>
</form>
	
<form action="ManningPersSingleMilSkillUpdate.asp" method="post" name="popupDetails">
	<input type=hidden name=staffID value=<%=request("staffID")%>>
	<input Type="hidden" name="thisDate" id="thisDate" value="<%=request("thisDate")%>">	
	<input type="hidden" name="ReturnTo" id="ReturnTo" value="HierarchyPersMilSkills.asp">	
	<input Type="Hidden" name="StaffMSID" id="StaffMSID">
	
  <div id="PopUpwindow1" class="PopUpWindow">
	  <table border=0 cellpadding=0 cellspacing=0 width=100%>
		  <tr>
			  <td colspan=3 align="center" height=22 class=MenuStyleParent><u>Confirm Military Skill Details</u></td>
		  </tr>
          <tr>
           	  <td colspan="3" height="22px">&nbsp;</td>
          </tr>
		  <tr class=columnheading>
			  <td valign="middle" height=22 width=2%></td>
			  <td valign="middle" height=22 width=30%>Qualification:</td>
			  <td valign="middle" height=22 width=68% class=toolbar><div  id="QName"></div></td>
		  </tr>
		  <tr class=columnheading>
			  <td valign="middle" height=22 width=2%></td>
			  <td valign="middle" height=22 width=30%>Valid From:</td>
			  <td valign="middle" height=22 width=68% class=itemfont>
				  <INPUT id="DateAttained" class="itemfont" style="Width:75px;" name="DateAttained" value = "<%= newTodaydate %>" readonly>&nbsp;
				  <img src="images/cal.gif" onclick="calSet(DateAttained)" align="absmiddle" alt="Calendar" style="cursor:hand;"></td>
			  </td>
		  </tr>
		  <tr id="exempt" style="display:none;" class="columnheading">
			  <td valign="middle" height="22" width="2%"></td>
			  <td valign="middle" height="22" width="30%">Exempt:</td>
			  <td valign="middle" height="22" width="68%" class="itemfont"><input name="chkExempt" type="checkbox" id="chkExempt" value="1">
		  </tr>
		  <%if request("QTypeID")=2  then%>
			  <tr class=columnheading>
				  <td valign="middle" height=22 width=2%></td>
				  <td valign="middle" height=22 width=30%>Competent:</td>
				  <td valign="middle" height=22 width=68% class=itemfont>
					  <select class="itemfont" name="Competent"  id="Competent">
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
		  <%else%>
			  <tr class=columnheading>
				  <td valign="middle" height=22 width=2%></td>
				  <td valign="middle" height=22 width=30%></td>
				  <td valign="middle" height=22 width=68% class=itemfont><input type=hidden name=Competent id="Competent" value=N></td>
			  </tr>
		  <%end if%>
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

function DisplayForm(ValidDate,Competent,staffMSID,Description,QExempt,Exempt)
{
	document.popupDetails.StaffMSID.value = staffMSID;
	var months = new Array('Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec');
	var datestr_array = ValidDate.split("/");
	var monthInt=datestr_array[1]
	var newMonth=months[monthInt-1];
	document.popupDetails.DateAttained.value = ValidDate; //datestr_array[0] + " " + newMonth + " " + datestr_array[2];
	
	if(QExempt == 1)
	{
		document.getElementById('exempt').style.display = 'block';
	}
	else
	{
		document.getElementById('exempt').style.display = 'none';
	}
	
	if(Exempt == 1)
	{
		document.getElementById('chkExempt').checked = true
	}
	else
	{
		document.getElementById('chkExempt').checked = false
	}

	document.getElementById('QName').innerHTML=Description;
	document.getElementById('PopUpwindow1').style.visibility = "Visible";
}

</Script>
