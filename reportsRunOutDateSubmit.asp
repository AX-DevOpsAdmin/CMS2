<!DOCTYPE HTML >

<!--#include file="Includes/security.inc"-->
<!--#include file="Connection/Connection.inc"-->

<%
set objCmd = server.CreateObject("ADODB.Command")
set objPara = server.CreateObject("ADODB.Parameter")
objCmd.ActiveConnection = con
objCmd.Activeconnection.cursorlocation = 3
objCmd.commandtype = 4

hrcID = request("cbohrc")
objCmd.commandtext = "spGetHierarchyDetail"

' now  get the unit
set objPara = objCmd.createparameter ("hrcID",3,1,0, cint(hrcID))
objCmd.parameters.append objPara
set rsHrc = objCmd.execute

'Retrieves the team name
strHrc = rsHrc("hrcname")
		
for x = 1 to objCmd.parameters.count
	objCmd.parameters.delete(0)
next

strCommand = "spListQTypes"
objCmd.CommandText = strCommand
set objPara = objCmd.CreateParameter ("nodeID",3,1,0, nodeID)
objCmd.Parameters.Append objPara

set rsTypeQList = objCmd.Execute	'Execute CommandText when using "ADODB.Command" object'

for x = 1 to objCmd.parameters.count
	objCmd.parameters.delete(0)
next

Counter = rsTypeQList.recordcount

strTitle1 = "Expiry Date Report"

if request("newattached") = "" then
	qualifications = ""
else
	qualifications = request("newattached")
	strTitle2 = "Qualification "
end if

if request("milskill") = "" then
	milskill = ""
else
	milskill = request("milskill")
	strTitle2 = "Military Skill "
end if

if request("vacs") = "" then
	vacs = ""
else
	vacs = request("vacs")
	strTitle2 = "Vaccination "
end if

if request("fitness") = "" then
	fitness = ""
else
	fitness = request("fitness")
	strTitle2 = "Fitness "
end if

if request("dental") = "" then
	dental = ""
else
	dental = request("dental")
	strTitle2 = "Dental "
end if

gender = request("gender")    ' 1 = BOTH,  2=MALE, 3=FEMALE

if request("civi") = 1 then
	civi = request("civi")
else
	civi = 0
end if

objCmd.CommandText = "spGetRunOutDate"

set objPara = objCmd.CreateParameter ("teamID",3,1,0, hrcID)
objCmd.Parameters.Append objPara
set objPara = objCmd.CreateParameter ("QStatus",3,1,0, int(request("Status1")))
objCmd.Parameters.Append objPara
set objPara = objCmd.createparameter("qualification",200,1,1000, qualifications)
objCmd.parameters.append objPara
set objPara = objCmd.CreateParameter ("MSStatus",3,1,0, int(request("Status2")))
objCmd.Parameters.Append objPara
set objPara = objCmd.CreateParameter ("milSkill",200,1,500,  milSkill)
objCmd.Parameters.Append objPara
set objPara = objCmd.CreateParameter ("VacStatus",3,1,0, int(request("Status3")))
objCmd.Parameters.Append objPara
set objPara = objCmd.CreateParameter ("vacs",200,1,500,  vacs)
objCmd.Parameters.Append objPara
set objPara = objCmd.CreateParameter ("FitnessStatus",3,1,0, int(request("Status4")))
objCmd.Parameters.Append objPara
set objPara = objCmd.CreateParameter ("fitness",200,1,500,  fitness)
objCmd.Parameters.Append objPara
set objPara = objCmd.CreateParameter ("DentalStatus",3,1,0, int(request("Status5")))
objCmd.Parameters.Append objPara
set objPara = objCmd.CreateParameter ("dental",200,1,500, dental)
objCmd.Parameters.Append objPara
set objPara = objCmd.CreateParameter ("civi",3,1,0, civi)
objCmd.Parameters.Append objPara
set objPara = objCmd.CreateParameter ("gender",3,1,0, gender)
objCmd.Parameters.Append objPara
set rsRecSet = objCmd.Execute	'Execute CommandText when using "ADODB.Command" object'

intAmber = rsRecSet("Amber")
intDays = rsRecSet("vpdays")
%>

<html>
<head>

<!--#include file="Includes/IECompatability.inc"-->


<title><%= PageTitle %></title>
<link rel="stylesheet" type="text/css" href="Includes/AMDB.css" />
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

<table border=0 cellpadding=0 cellspacing=0 width=100%>
	<tr>
		<td>&nbsp;</td>
	</tr>
	<tr class=titlearea>
		<td align="center"><U><%= strTitle2 & " " & strTitle1 %></U></td>
	</tr>
	<tr height=16px>
		<td>&nbsp;</td>
	</tr>
	<tr>
		<td>
			<table border=0 cellpadding=0 cellspacing=0 height=50px width=100%>
                <tr>
                    <td width="100%" class="itemfont">Unit:&nbsp;<font color="#0033FF" size="3"><strong><%= strHrc %></strong></font></td>
                </tr>
				<tr>
					<td>&nbsp;</td>
				</tr>
                <tr>
                	<td valign="middle" height=22px class=itemfont><%= rsRecSet("Type") & " " & strType %><b><%= rsRecSet("Description") %></b></td>
                </tr>
				<tr>
					<td>&nbsp;</td>
				</tr>
                <% set rsRecSet = rsRecSet.nextrecordset %>
                <tr class=itemfont>
                    <td valign="middle" height=22px>Records Found: <%=rsRecSet.recordcount%></Font></td>
                </tr>
                <tr>
                    <td>&nbsp;</td>
                </tr>
                <tr>
                    <td>
                        <table border=0 cellpadding=0 cellspacing=0 width=100%>
                            <tr>
                                <td >
                                    <table border=0 cellpadding=0 cellspacing=0 width=100%>
                                        <tr class=columnheading>
                                            <td width=4px>&nbsp;</td>
                                            <td width=250px>Name</td>
                                            <td width=70px>Service No</td>
                                            <td width=150px>Unit</td>
                                            <td width=100px>Valid From</td>
                                            <td width=100px>Valid To</td>
                                            <td width="20px" align="center">&nbsp;</td>
                                            <td width=100px>Status</td>
                                        </tr>
                                        <tr>
                                            <td colspan=9 class=titlearealine  height=1></td> 
                                        </tr>
                                        <% do while not rsRecSet.eof %>
											<% if isnull(rsRecSet("firstname")) or rsRecSet("firstname") <> "" then %>
                                                <% strName = rsRecSet("shortDesc") & " " & rsRecSet("surname") & ", " & rsRecSet("firstname") %>
                                            <% else %>
                                                <% strName = rsRecSet("shortDesc") & " " & rsRecSet("surname") %>
                                            <% end if %>
                                            <% strValidFrom = rsRecSet("ValidFrom") %>
                                            <% strValidTo = dateadd("d", intDays, strValidFrom) %>
                                            <% strAmberDate = dateadd("d", -intAmber, strValidTo) %>
                                            
                                            <tr class=itemfont height=20px>
                                                <td width=4px>&nbsp;</td>
                                                <td width=250px><%= strName %></td>
                                                <td width=70px><%= rsRecSet("serviceno") %></td>
                                                <td width=150px><%= rsRecSet("hrcname") %></td>
                                                <td width=100px><%= rsRecSet("validfrom") %></td>
                                                <td width=100px><%= strValidTo %></td>
                                                <td width=20px align="center">
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
                                                <td width="100px">
                                                    <% if strValidTo < date then %>	Out of Date
                                                    <% elseif strValidTo >= date then %>In Date
                                                    <% end if %>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td colspan=9 class=titlearealine  height=1></td> 
                                            </tr>
                                            <% rsRecSet.movenext %>
                                        <% loop %>
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
</body>
</html>