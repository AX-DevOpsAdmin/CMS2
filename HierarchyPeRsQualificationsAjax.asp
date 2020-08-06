<!DOCTYPE HTML >

<!--#include file="Includes/Security.inc"--> 
<!--#include file="Connection/Connection.inc"-->
<!--#include file="Includes/checkmanager.inc"-->  
<!--#include file="Includes/manageradmin.inc"-->  

<%
strCommand = "spPeRsDetail"
set objCmd = server.CreateObject("ADODB.Command")
set objPara = server.CreateObject("ADODB.Parameter")
objCmd.ActiveConnection = con
objCmd.Activeconnection.cursorlocation = 3

objCmd.CommandText = strCommand
objCmd.CommandType = 4		

set objPara = objCmd.CreateParameter ("RecID",3,1,5, request("StaffID"))
objCmd.Parameters.Append objPara

set rsPersonalDetails = objCmd.Execute	'Execute CommandText when using "ADODB.Command" object'

for x = 1 to objCmd.parameters.count
	objCmd.parameters.delete(0)
next

postID= request("postID")
if postID = "" then postID = 0

strCommand = "spPeRsQsSummary" 
objCmd.CommandText = strCommand
objCmd.CommandType = 4		

set objPara = objCmd.CreateParameter ("RecID",3,1,0, request("staffID"))
objCmd.Parameters.Append objPara
set objPara = objCmd.CreateParameter ("startDate",200,1,20, request("thisDate"))
objCmd.Parameters.Append objPara

set rsPersonalQs = objCmd.Execute	
set rsPersonalQs = rsPersonalQs.nextrecordset

for x = 1 to objCmd.parameters.count
	objCmd.parameters.delete(0)
next

objCmd.commandtext = "spPeRsQsObtained"
objCmd.commandtype = 4
set objPara = objCmd.CreateParameter ("staffID",3,1,0, request("staffID"))
objCmd.Parameters.Append objPara
set objPara = objCmd.createparameter("postID",3,1,4, postID)
objCmd.parameters.append objPara

set rsPostQs = objCmd.execute
					
for x = 1 to objCmd.parameters.count
	objCmd.parameters.delete(0)
next
%>

<table border=0 cellpadding=0 cellspacing=0 width=97%>
	<tr>
		<td colspan=3>
			<table border=0 cellpadding=0 cellspacing=0 width=100%>
		  		<tr height=16>
					<td></td>
		  		</tr>
				<tr class="personalDetails">
					<td width="70px">First Name:</td>
                    <td width="150px">
                    	<Div class=borderArea style="background-color:#FFFFFF;" >
                        	<table border=0 cellpadding=0 cellspacing=1>
                            	<tr>
                                	<td class=itemfont ><%=rsPersonalDetails("firstname")%>&nbsp;</td>
								<tr>
							</table>
						</Div>
					</td>
					<td width=10px></td>
					<td width="70px">Surname:</td>
                    <td width="150px">
                    	<Div class=borderArea style="background-color:#FFFFFF;">
                        	<table border=0 cellpadding=0 cellspacing=1>
                            	<tr>
                                	<td class=itemfont><%=rsPersonalDetails("surname")%>&nbsp;</td>
								<tr>
							</table>
						</Div>
					</td>
				</tr>
				<tr height=16>
					<td></td>
		  		</tr>
			</table>
	  	</td>
	</tr>
	<tr>
		<td>
			<table border=0 cellpadding=0 cellspacing=0 width=640px>
				<tr class="SectionHeader toolbar">
					<td width="1px" height="25px">&nbsp;</td>
					<td width="339px" align="left" height="25px">Qualifications - Personal</td>
					<td width="65px" align="center" height="25px">Held</td>
					<td width="85px" align="left" height="25px">Valid From</td>
					<td width="85px" align="left" height="25px">Valid To</td>
					<td width="65px" align="center" height="25px">Status</td>
				</tr>
			</table>
			<div class="ScrollingAreaQs">
				<table border=0 cellpadding=0 cellspacing=0 width=640px>
					<tr>
						<td colspan=6 height="22px">&nbsp;</td>
					</tr>
	
					<% if not rsPersonalQs.eof then %>
						<% do while not rsPersonalQs.eof %>
							<% strQualification = rsPersonalQs("description") %>
							<% strValidFrom = rsPersonalQs("ValidFrom") %>
							<% intDays = rsPersonalQs("vpdays") %>
							<% strValidTo = dateadd("d", intDays, strValidFrom) %>
							<% intAmber = rsPersonalQs("Amber") %>
							<% strAmberDate = dateadd("d", -intAmber, strValidTo) %>
							
							<tr>
								<td width="1px" height="22px">&nbsp;</td>
								<td width="339px" align="left" height="22px" class=toolbar><%= strQualification %></td>
								<td width="65px" align="center" height="22px"><% if rsPersonalQs("staffID") <> "" then %><img src="images/yes.gif"><% else %><img src="images/no.gif"><% end if %></td>
								<td width="85px" align="left" height="22px" class=toolbar><% if rsPersonalQs("staffID") <> "" then %><%= strValidFrom %><% else %>-<% end if %></td>
								<td width="85px" align="left" height="22px" class=toolbar><% if rsPersonalQs("staffID") <> "" then %><%= strValidTo %><% else %>-<% end if %></td>
								<td width="65px" align="center" height="22px" class=toolbar>
									<% if date > strValidTo then %>
										<img src="Images/red box.gif" alt="Out of Date" width="12" height="12">
									<% elseif date >= strAmberDate and date <= strValidTo then %>
										<img src="Images/yellow box.gif" alt="Almost out of Date" width="12" height="12">
									<% elseif date >= strValidFrom and date < strAmberDate then %>
										<img src="Images/green box.gif" alt="In Date" width="12" height="12">
									<% else %>
										-
									<% end if %>
								</td>
							</tr>
							<% rsPersonalQs.movenext %>
						<% loop %>
                        <tr>
                        	<td colspan="6" height="22px">&nbsp;</td>
                        </tr>
					<% else %>
						<tr>
							<td width="1%" hight="22px">&nbsp;</td>
							<td colspan="5" width="99%" align="left" height="22px" class="toolbar">None Held</td>
						</tr>
					<% end if %>
				</table>
			</div>
		</td>
	</tr>
	<tr>
		<td height="1px">&nbsp;</td>
	</tr>
	<tr>
		<td>
            <table border=0 cellpadding=0 cellspacing=0 width=640px>
                <tr class="SectionHeader toolbar">
                    <td width="1px" height="25px">&nbsp;</td>
                    <td width="339px" align="left" height="25px">Qualifications - Post</td>
                    <td width="65px" align="center" height="25px">Held</td>
                    <td width="85px" align="center" height="25px">Valid From</td>
                    <td width="85px" align="center" height="25px">Valid To</td>
                    <td width="65px" align="center" height="25px">Status</td>
                </tr>
            </table>
			<div class="ScrollingAreaQs">
				<table border=0 cellpadding=0 cellspacing=0 width=640px>
					<tr>
						<td colspan=6 height="22px">&nbsp;</td>
					</tr>
	
					<% if not rsPostQs.eof then %>
						<% do while not rsPostQs.eof %>
							<% strQualification = rsPostQs("description") %>
							<% strValidFrom = rsPostQs("ValidFrom") %>
							<% intDays = rsPostQs("vpdays") %>
							<% strValidTo = dateadd("d", intDays, strValidFrom) %>
							<% intAmber = rsPostQs("Amber") %>
							<% strAmberDate = dateadd("d", -intAmber, strValidTo) %>
							
							<tr>
								<td width="1px" height="22px">&nbsp;</td>
								<td width="339px" align="left" height="22px" class=toolbar><%= strQualification %></td>
								<td width="65px" align="center" height="22px"><% if rsPostQs("staffID") <> "" then %><img src="images/yes.gif"><% else %><img src="images/no.gif"><% end if %></td>
								<td width="85px" align="center" height="22px" class=toolbar><% if rsPostQs("staffID") <> "" then %><%= strValidFrom %><% else %>-<% end if %></td>
								<td width="85px" align="center" height="22px" class=toolbar><% if rsPostQs("staffID") <> "" then %><%= strValidTo %><% else %>-<% end if %></td>
								<td width="65px" align="center" height="22px" class=toolbar>
									<% if date > strValidTo then %>
										<img src="Images/red box.gif" alt="Out of Date" width="12" height="12">
									<% elseif date >= strAmberDate and date <= strValidTo then %>
										<img src="Images/yellow box.gif" alt="Almost out of Date" width="12" height="12">
									<% elseif date >= strValidFrom and date < strAmberDate then %>
										<img src="Images/green box.gif" alt="In Date" width="12" height="12">
									<% else %>
										-
									<% end if %>
								</td>
							</tr>
							<% rsPostQs.movenext %>
						<% loop %>
                        <tr>
                        	<td colspan="6" height="22px">&nbsp;</td>
                        </tr>
					<% else %>
						<tr>
							<td width="1%" hight="22px">&nbsp;</td>
							<td colspan="5" width="99%" align="left" height="22px" class="toolbar">None Required</td>
						</tr>
					<% end if %>
				</table>
			</div>
		</td>
	</tr>
</table>
