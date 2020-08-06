<!DOCTYPE HTML >

<!--#include file="Includes/security.inc"--> 
<!--#include file="Connection/Connection.inc"-->
<!--#include file="Includes/checkmanager.inc"-->  
<!--#include file="Includes/manageradmin.inc"-->  

<%
Tab=3
strTable = "tblstaff"
strGoTo = "AdminPeRsList.asp"   ' asp page to return to once record is deleted
strTabID = "staffID"              ' key field name for table        
strRecid = "staffID"

strCommand = "spPeRsQsSummary"

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
set rsRecSet = objCmd.Execute	'Execute CommandText when using "ADODB.Command" object

for x = 1 to objCmd.parameters.count
	objCmd.parameters.delete(0)
next

objCmd.CommandText = "spQualificationsTypeDetails"	'Name of Stored Procedure
objCmd.CommandType = 4				'Code for Stored Procedure
set objPara = objCmd.CreateParameter ("RecID",3,1,5, request("staffID"))
objCmd.Parameters.Append objPara
set objPara = objCmd.CreateParameter ("TypeID",3,1,5, request("QTypeID"))
objCmd.Parameters.Append objPara

set rsQualificationDetails = objCmd.Execute	'Execute CommandText when using "ADODB.Command" object

strAuth = rsQualificationDetails("Auth")
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
<form action="" method="post" name="frmDetails">
	<input type=hidden name="staffID" id="staffID" value=<%=request("staffID")%>>
	<Input Type="Hidden" name="HiddenDate" id="HiddenDate">
	<table border=0 cellpadding=0 cellspacing=0 width=100%>
    	<!--#include file="Includes/hierarchyStaffDetails.inc"-->
    	<tr>
    		<td class=titlearealine  height=1></td> 
    	</tr>    
    
    	<tr class=SectionHeader>
    		<td>
    			<table border=0 cellpadding=0 cellspacing=0>
                	<tr>
    					<td height="25" class=toolbar width=8>
    					<td height="25" width=20><a class=itemfontlink  href="HierarchyPersQualificationsAdd.asp?staffID=<%=request("staffID")%>&QTypeID=<%=request("QTypeID")%>&thisdate=<%=request("thisDate")%>"><img class="imagelink" src="images/editgrid.gif"></A></td>
    					<td height="25" class=toolbar valign="middle" >Add Qualifications</td>
    					<td height="25" class=titleseparator valign="middle" width=14 align="center">|</td>
    					<td height="25" width=20><a class=itemfontlink  href="HierarchyPersQualificationsRemove.asp?staffID=<%=request("staffID")%>&QTypeID=<%=request("QTypeID")%>&thisdate=<%=request("thisDate")%>"><img class="imagelink" src="images/editgrid.gif"></A></td>
    					<td height="25" class=toolbar valign="middle" >Remove Qualifications</td>
    					<td height="25" class=titleseparator valign="middle" width=14 align="center">|</td>
    					<td height="25" class=toolbar valign="middle" ><A class=itemfontlink href="HierarchyPeRsQualificationsSelect.asp?staffID=<%=request("staffID")%>&thisdate=<%=request("thisDate")%>">Back</A></td>											
    				</tr>
    			</table>
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
                    <tr class=columnheading height=22px>
                        <td align="left" width="2%" height="22px">&nbsp;</td>
                        <td align="left" width="13%" height="22px">Service No:</td>
                        <td align="left" width="25%" height="22px" class=itemfont><%=rsRecSet("serviceno")%></td>
                        <td align="left" width="13%" height="22px">Known as:</td>
                        <td align="left" width="25%" height="22px" class=itemfont><%=rsRecSet("knownas")%></td>
                        <td align="left" width="22%" height="22px">&nbsp;</td>
                    </tr>
                    <tr class=columnheading height=22px>
                        <td align="left" width="2%" height="22px">&nbsp;</td>
                        <td align="left" width="13%" height="22px">Rank:</td>
                        <td align="left" width="25%" height="22px" class=itemfont><%=rsRecSet("rank")%></td>
                        <td align="left" width="13%" height="22px">Trade:</td>
                        <td align="left" width="25%" height="22px" class=itemfont><%=rsRecSet("trade")%></td>
                        <td align="left" width="22%" height="22px">&nbsp;</td>
                    </tr>
                    <tr class=columnheading height=22px>
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
                        <td colspan="6" class=titlearealine height=1></td> 
                    </tr>
					<tr class=SectionHeader>
						<td width="2%" align="left" height="22px">&nbsp;</td>
						<td width="50%" align="left" height="22px" colspan=5>
    						<table border=0 cellpadding=0 cellspacing=0 width=100%>
    							<tr class="SectionHeader toolbar">
    								<td width=30% align="left" height="25%"><b><u><%=rsQualificationDetails("Type")%></u></b> Qualifications Held</td>										
    								<td width=10% align="center" height=25px>Valid From</td>
                                    <td width=10% align="center" height=25px>Valid To</td>
                                    <td width=5% align="center" height="25px">&nbsp;</td>
    								<td width=10% align="center" height=25px><%if request("QTypeID")=2 then%>Competence<%End if%></td>
									<td width=35% align="center" height=22px>&nbsp;</td>
    							</tr>
								<tr>
									<td colspan=6 height="22px">&nbsp;</td>
								</tr>                                
    							<% set rsQualificationDetails=rsQualificationDetails.nextrecordset %>
    							<% if rsQualificationDetails.recordcount > 0 then %>
									<% do while not rsQualificationDetails.eof %>
                                    
										<% intStaffID = rsQualificationDetails("StaffID") %>
                                        <% intStaffQID = rsQualificationDetails("StaffQID") %>
                                        <% strDescription = rsQualificationDetails("description") %>
                                        <% strValidFrom = rsQualificationDetails("ValidFrom") %>
                                        <% intDays = rsQualificationDetails("vpdays") %>
                                        <% strCompetent = rsQualificationDetails("Competent") %>
                                        <% strValidTo = dateadd("d", intDays, strValidFrom) %>
                                        <% intAmber = rsQualificationDetails("Amber") %>
                                        <% strAmberDate = dateadd("d", -intAmber, strValidTo) %>
                                        <% strAuthName = rsQualificationDetails("AuthName") %>
                                        
                                        <tr>    
                                            <td width="30%" height="22px" align="left" class="toolbar"><a href="javascript:DisplayForm('<%= formatdatetime(strValidFrom,2) %>','<%= strCompetent %>','<%= intStaffQID %>','<%= strDescription %>','<%= strAuthName %>');" onclick="DisplayForm" class=ItemLink><%= strDescription %></A></td>
                                            <td width="10%" height="22px" align="center" class="toolbar"><%= formatDateTime(strValidFrom,2) %></td>
                                            <td width="10%" height="22px" align="center" class="toolbar"><%= formatDateTime(strValidTo,2) %></td>
                                            <td width="5%" height="22px" align="left">
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
                                            <td width="10%" height="22px" align="center" class="toolbar"><%if request("QTypeID")=2 then%><%= strCompetent %><%end if%></td>    
                                            <td width="35%" height="22px" align="center">&nbsp;</td>
                                        </tr>
                                        <% rsQualificationDetails.movenext %>
                                    <% loop %>
    							<% else %>
    								<tr>
    									<td colspan="6" class=toolbar height=22px>None held</td>
    								</tr>
    							<% end if %>    
    						</table>
    					</td>
    				</tr>
				</table>
			</td>
		</tr>
        <tr>
            <td height=22px>&nbsp;</td>
        </tr>
        <tr>
            <td class=titlearealine height=1></td> 
        </tr>    
    </table>
</form>

<form action="ManningPersSingleQualificationUpdate.asp" method="post" name="popupDetails">
    <input type=hidden name="staffID" id="staffID" value=<%=request("staffID")%>>
    <input type=hidden name="QTypeID" id="QTypeID" value=<%=request("QTypeID")%>>    
    <input type="hidden" name="ReturnTo" id="ReturnTo" value="HierarchyPersQualificationsDetails.asp">
    <Input Type="Hidden" name="StaffQID" id="StaffQID" value="<%=request("staffQID")%>">
    <Div id="PopUpwindow1" class="PopUpWindow">
    	<table border=0 cellpadding=0 cellspacing=0 width=100%>
    		<tr>
    			<td colspan=3 align="center" height=22px class=MenuStyleParent><u>Confirm Qualification Details</u></td>
    		</tr>
            <tr>
            	<td colspan="3" height="22px">&nbsp;</td>
            </tr>
    		<tr class=columnheading>
    			<td valign="middle" height=22px width=2%></td>
    			<td valign="middle" height=22px width=30%>Qualification:</td>
    			<td valign="middle" height=22px width=68% class=toolbar><DIV  id="QName"></DIV></td>
    		</tr>    
    		<tr class=columnheading>
    			<td valign="middle" height=22px width=2%></td>
    			<td valign="middle" height=22px width=30%>Valid From:</td>
    			<td valign="middle" height=22px width=68% class=itemfont>
					<INPUT id="DateAttained" class="itemfont"  style="Width:75px;"  name="DateAttained" value="<%= newTodaydate %>" readonly>&nbsp;
    				<img src="Images/cal.gif" onclick="calSet(DateAttained)" align="absmiddle" style="cursor:hand;" alt="Calendar"></td>
    			</td>
    		</tr>
			<% if strAuth = "True" then %>
                <tr id="auth" class="columnheading">
                    <td valign="middle" height="22" width="2%"></td>
                    <td valign="middle" height="22" width="30%">Authorised By:</td>
                    <td valign="middle" height="22" width="68%" class="itemfont"><input type="text" name="txtAuth" id="txtAuth" class="itemfont" style="Width:160px;" value=""></td>
                </tr>
			<% end if %>
    		<%if request("QTypeID") = 2 then%>
    			<tr class=columnheading>
    				<td valign="middle" height=22px width=2%></td>
    				<td valign="middle" height=22px width=30%>Competence:</td>
    				<td valign="middle" height=22px width=68% class=itemfont>
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
    		<%else%>
    			<tr class=columnheading>
    				<td valign="middle" height=22px width=2%></td>
    				<td valign="middle" height=22px width=30%></td>
    				<td valign="middle" height=22px width=68% class=itemfont><input type=hidden name="Competent" id="Competent" value=N></td>
    			</tr>
    		<%end if%>
    		<tr class=columnheading>
    			<td colspan=3 align="center" height=22px><Input CLASS="StandardButton" Type=Button style="width:60px;" Value=Cancel onclick="PopUpwindow1.style.visibility = 'hidden';"><Input CLASS="StandardButton" Type=Button style="width:60px;" Value=OK onclick="SaveAs()"></td>
    		</tr>        
    		<tr>
    			<td colspan=3 height=22px>&nbsp;</td>
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
    
	input_box = confirm("Are you sure you want to delete this Record ?")
	if(input_box == true)
	{
		delOK = true;
	}
	
    return delOK;
}

function DisplayForm(ValidDate,Competent,staffQID,Description,AuthName)
{
	document.popupDetails.StaffQID.value = staffQID;
	var months = new Array('Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec');
	datestr_array = ValidDate.split("/");
	monthInt=datestr_array[1]
	newMonth=months[monthInt-1];
	document.popupDetails.DateAttained.value = ValidDate; //datestr_array[0] + " " + newMonth + " " + datestr_array[2];
	
	if('<%= strAuth %>' == 'True')
	{
		document.getElementById('txtAuth').value = AuthName;
	}
	
	<%if request("QTypeID")=2  then%>
		for(var i = 0; i < document.popupDetails.Competent.options.length; i++)
		{
			if(document.popupDetails.Competent[i].value == Competent)
			{
				document.popupDetails.Competent.selectedIndex=i;		
			}
		}
	<%end if%>
	
	document.getElementById('QName').innerHTML=Description
	document.getElementById('PopUpwindow1').style.visibility = "Visible";
}

function SaveAs()
{
	if('<%= strAuth %>' == 'True')
	{
		if(document.getElementById('txtAuth').value == "")
		{
			alert("Enter Authorised By");
			return;
		}
	}
	
	document.popupDetails.submit();
}

</script>
