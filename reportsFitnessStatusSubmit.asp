<!DOCTYPE HTML >

<!--#include file="Includes/security.inc"-->
<!--#include file="Connection/Connection.inc"-->

<%
	hrcID = request("cboHrc")
	
	set objCmd = server.createobject("ADODB.Command")
	set objPara = server.createobject("ADODB.Parameter")
	objCmd.activeconnection = con
	objCmd.activeconnection.cursorlocation = 3
	objCmd.commandtype = 4
		
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

	strCommand = "spListFitness"
	objCmd.CommandText = strCommand

	set objPara = objCmd.createparameter ("ndeID",3,1,0, nodeID)
	objCmd.parameters.append objPara

	set rsFitnessList = objCmd.Execute	'Execute CommandText when using "ADODB.Command" object'
	
	if not rsFitnessList.eof then
		do while not rsFitnessList.eof
			strList = strList & rsFitnessList("fitnessID") & ","
			rsFitnessList.movenext
		loop
	end if
	
	for x = 1 to objCmd.parameters.count
		objCmd.parameters.delete(0)
	next
	
	objCmd.commandtext = "spGetFitnessStatus"
	' now add reporting parameters
	set objPara = objCmd.createparameter ("@hrcID",3,1,0, cint(hrcID))
	objCmd.parameters.append objPara
	set objPara = objCmd.createparameter ("@fitnessID",200,1,800, strList)
	objCmd.parameters.append objPara
	set rsFitness = objCmd.execute	'Execute CommandText when using "ADODB.Command" object'
	
	intRecords = rsFitness.recordcount
%>

<html>
<head>

<!--#include file="Includes/IECompatability.inc"-->


<title>Custom Report</title>
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
		<td align="center">RAF Fitness Report</td>
	</tr>
	<tr height=16px>
		<td>&nbsp;</td>
	</tr>
	<tr>
		<td>
			<table width="100%" border="0" cellpadding="0" cellspacing="0">
				<tr>
					<td width="100%" class="teamReports">Unit:&nbsp;<strong><%= strHrc %></strong></td>
				</tr>
			</table>
		</td>
	</tr>
	<tr height=16px>
		<td>&nbsp;</td>
	</tr>
	<tr>
		<td>
			<table width="100%" border="0" cellpadding="0" cellspacing="0">
				<tr class="itemfont">
					<td width="100%">Records Found:&nbsp;<%= intRecords %></td>
				</tr>
			</table>
		</td>
	</tr>
	<tr height=16px>
		<td>&nbsp;</td>
	</tr>
	<tr>	
		<td>
			<table border=0 cellpadding=0 cellspacing=0 width=100%>
				<tr>
					<td >
                        <table border=0 cellpadding=0 cellspacing=0 width=100%>
                            <tr class=columnheading height=20px>
                                <td width=4px>&nbsp;</td>
                                <td width=250px>Name</td>
                                <td width=70px>Service No</td>
                                <td width=150px>Team</td>
                                <td width=100px>Valid From</td>
                                <td width=100px>Valid To</td>
                                <td width="20px" align="center">&nbsp;</td>
                                <td width=100px>Status</td>
                                <td width=100px>Expiry Date</td>
                            </tr>
                            <tr>
                                <td colspan=9 class=titlearealine  height=1></td> 
                            </tr>
							<% do while not rsFitness.eof %>
								<% if isnull(rsFitness("firstname")) or rsFitness("firstname") <> "" then %>
                                    <% strName = rsFitness("shortDesc") & " " & rsFitness("surname") & ", " & rsFitness("firstname") %>
                                <% else %>
                                    <% strName = rsFitness("shortDesc") & " " & rsFitness("surname") %>
                                <% end if %>
                                <tr class=itemfont height=30px>
                                    <td width=4px>&nbsp;</td>
                                    <td width=250px><%=strName%></td>
                                    <td width=70px><%=rsFitness("serviceno")%></td>
                                    <td width=150px><%=rsFitness("description")%></td>
                                    <td width=100px><%=rsFitness("validfrom")%></td>
                                    <td width=100px><%=rsFitness("validto")%></td>
                                    <td width=20px align="center">
                                        <% if isnull(rsFitness("validto")) and rsFitness("remedial") = 0 and rsFitness("exempt") = 0 then %>
                                            <img src="Images/black box.gif" width="13" height="13" align="middle" alt="No Record">                                                
                                        <% elseif rsFitness("validto") < date and rsFitness("remedial") = 0 and rsFitness("exempt") = 0 then %>
                                            <img src="Images/red box.gif" width="13" height="13" align="middle" alt="Out of Date">                                                
                                        <% elseif rsFitness("remedial") = 1 and rsFitness("expiryDate") <= date then %>
                                            <img src="Images/red box.gif" width="13" height="13" align="middle" alt="Remedial has expired">                                                
                                        <% elseif rsFitness("remedial") = 1 and rsFitness("expiryDate") > date or rsFitness("remedial") = 1 and isnull(rsFitness("expiryDate")) then %>
                                            <img src="Images/yellow box.gif" width="13" height="13" align="middle" alt="Remedial">                                                
                                        <% elseif rsFitness("exempt") = 1 and rsFitness("expiryDate") <= date then %>
                                            <img src="Images/red box.gif" width="13" height="13" align="middle" alt="Exempt has expired">                                                
                                        <% elseif rsFitness("exempt") = 1 and rsFitness("expiryDate") > date or rsFitness("exempt") = 1 and isnull(rsFitness("expiryDate")) then %>
                                            <img src="Images/yellow box.gif" width="13" height="13" align="middle" alt="Exempt">                                                
                                        <% elseif rsFitness("validto") => date and rsFitness("remedial") = 0 and rsFitness("exempt") = 0 then %>
                                            <img src="Images/green box.gif" width="13" height="13" align="middle" alt="In Date">
                                        <% end if %>
                                    </td>
                                    <td width="100px">
                                        <% if isnull(rsFitness("validto")) and rsFitness("remedial") = 0 and rsFitness("exempt") = 0 then %>No Record
                                        <% elseif  rsFitness("validto") < date and rsFitness("remedial") = 0 and rsFitness("exempt") = 0 then %>	Out of Date
                                        <% elseif rsFitness("remedial") = 1 then %>Remedial
                                        <% elseif rsFitness("exempt") = 1 then %>Exempt
                                        <% elseif rsFitness("validto") => date and rsFitness("remedial") = 0 and rsFitness("exempt") = 0 then %>In Date
                                        <% end if %>
                                    </td>
                                    <td width=100px><%=rsFitness("expiryDate")%></td>
                                </tr>
                                <tr>
                                    <td colspan=9 class=titlearealine  height=1></td> 
                                </tr>
                                <% rsFitness.movenext %>
                            <% loop %>
                        </table>
                    </td>
                </tr>
			</table>
		</td>
	</tr>
	<tr>
		<td>&nbsp;</td>
	</tr>
</table>
</body>
</html>