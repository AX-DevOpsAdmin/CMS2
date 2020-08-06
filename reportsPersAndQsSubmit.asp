<!DOCTYPE HTML >

<!--#include file="Includes/security.inc"-->
<!--#include file="Connection/Connection.inc"-->

<%
set objCmd = server.CreateObject("ADODB.Command")
set objPara = server.CreateObject("ADODB.Parameter")
objCmd.ActiveConnection = con
objCmd.Activeconnection.cursorlocation = 3
objCmd.CommandType = 4	

strCommand = "spListQTypes"
objCmd.CommandText = strCommand
set objPara = objCmd.CreateParameter ("nodeID",3,1,0, nodeID)
objCmd.Parameters.Append objPara
	
set rsTypeQList = objCmd.Execute	'Execute CommandText when using "ADODB.Command" object'

for x = 1 to objCmd.parameters.count
	objCmd.parameters.delete(0)
next


Counter = rsTypeQList.recordcount

strTitle1 = "Qualification Expiry Date Report"
qID=cint(request("newattached"))

if request("civi") = 1 then
	civi = request("civi")
else
	civi = 0
end if

gender = request("gender")    ' 1 = BOTH,  2=MALE, 3=FEMALE
'personnel = request("radpersonnel")

'if request("newattached") = "" then
'	qualifications = ""
'else
'	qualifications = request("newattached")
'	strTitle2 = "Qualification Report"
'end if

'response.Write qualifications
'response.end()
'response.write(request("Status1")&", "& qID&", "&civi&", "&gender&", "&personnel)
'response.end()

set objCmd = server.CreateObject("ADODB.Command")
set objPara = server.CreateObject("ADODB.Parameter")
objCmd.ActiveConnection = con
objCmd.Activeconnection.cursorlocation = 3
objCmd.CommandText = "spGetPersonnelAndQs"
objCmd.CommandType = 4

set objPara = objCmd.CreateParameter ("QStatus",3,1,0, int(request("Status1")))
objCmd.Parameters.Append objPara
'set objPara = objCmd.createparameter("qualification",200,1,1000, qualifications)
set objPara = objCmd.CreateParameter ("civi",3,1,0, qID)
objCmd.parameters.append objPara
set objPara = objCmd.CreateParameter ("civi",3,1,0, civi)
objCmd.Parameters.Append objPara
set objPara = objCmd.CreateParameter ("gender",3,1,0, gender)
objCmd.Parameters.Append objPara

set rsRecSet = objCmd.Execute	'Execute CommandText when using "ADODB.Command" object'
'response.end()
'response.write(intUnitID&", "&request("Status1")&", "&qualifications&", "&request("Status2")&", "&milSkill&", "&request("Status3")&", "&vacs&", "&request("Status4")&", "&fitness&", "&request("Status5")&", "&dental&", "&civi&", "&gender&", "&active)
'response.end()

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
		<td align="center"><U><%= strTitle1 %></U></td>
	</tr>
	<tr height=16px>
		<td>&nbsp;</td>
	</tr>
	<tr>
		<td>
			<table border=0 cellpadding=0 cellspacing=0 height=50px width=100%>
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
                                            <td width=80px>Valid From</td>
                                            <td width=80px>Valid To</td>
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