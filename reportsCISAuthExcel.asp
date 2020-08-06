<!DOCTYPE HTML >

<!--#include file="Includes/security.inc"-->
<!--#include file="Connection/Connection.inc"-->

<%
	response.ContentType = "application/vnd.ms-excel"
	response.addHeader "content-disposition","attachment;filename=newReport.xls"
	
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
	strTeam = rsHrc("hrcname")
		
	objCmd.commandtext = "spGetCISAuth"

	' now add reporting parameters
'	set objPara = objCmd.createparameter ("@tmID",3,1,0, cint(hrcID))
'	objCmd.parameters.append objPara
	set rsCISAuth = objCmd.execute	'Execute CommandText when using "ADODB.Command" object'
	
	intRecords = rsCISAuth.recordcount

'	intUnitID = request("cboTeam")
'	
'	intUnitID = request("cboTeam")
'	
'	set objCmd = server.createobject("ADODB.Command")
'	set objPara = server.createobject("ADODB.Parameter")
'	objCmd.activeconnection = con
'	objCmd.activeconnection.cursorlocation = 3
'	objCmd.commandtype = 4
'		
'	objCmd.commandtext = "spTeamDetail"
'	
'	' now  get the team
'	set objPara = objCmd.createparameter ("teamID",3,1,0, cint(intUnitID))
'	objCmd.parameters.append objPara
'	set rsTeam = objCmd.execute
'	
'	'Retrieves the team name
'	strTeam = rsTeam("Description")
'		
'	set objCmd = server.createobject("ADODB.Command")
'	set objPara = server.createobject("ADODB.Parameter")
'	objCmd.activeconnection = con
'	objCmd.commandtext = "spGetCISAuth"
'	objCmd.activeconnection.cursorlocation = 3
'	objCmd.commandtype = 4
'	
'	' now add reporting parameters
'	set objPara = objCmd.createparameter ("@tmID",3,1,0, cint(intUnitID))
'	objCmd.parameters.append objPara
'	set rsCISAuth = objCmd.execute	'Execute CommandText when using "ADODB.Command" object'
'	
'	intRecords = rsCISAuth.recordcount
%>

<html>
<head>

<!--#include file="Includes/IECompatability.inc"-->


<title>Custom Report</title>
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

.xl26
	{mso-style-parent:style0;
	border-top:none;
	border-right:none;
	border-bottom:.5pt solid windowtext;
	border-left:none;
	white-space:normal;}

.xl27
	{mso-style-parent:style0;
	border-top:none;
	border-right:none;
	border-bottom:.5pt solid windowtext;
	border-left:none;
	white-space:normal;}
	
.xl29
	{mso-style-parent:style0;
	mso-number-format:"\@";
	border-top:none;
	border-right:none;
	border-bottom:.5pt solid windowtext;
	border-left:none;
	white-space:normal;}
-->
</style>

</head>
<body>
<table border=0 cellpadding=0 cellspacing=0 width=978px>
	<tr class=titlearea>
		<td align="center" colspan="10" style="font-size:14pt;"><U>Unit Q Authorisation Report</U></td>
	</tr>
	<tr height=16px>
		<td colspan="10">&nbsp;</td>
	</tr>
	<tr>
		<td width="100%" class="itemfont" colspan="10">Unit:&nbsp;<font color="#0033FF" size="3"><strong><%= strTeam %></strong></font></td>
	</tr>
	<tr height=16px>
		<td colspan="10">&nbsp;</td>
	</tr>
	<tr>
		<td width="100%" colspan="10">Records Found:&nbsp;<%= intRecords %></td>
	</tr>
	<tr height=16px>
		<td colspan="10">&nbsp;</td>
	</tr>
    <tr class=columnheading>
        <td width=100>&nbsp;</td>
        <td width=100>&nbsp;</td>
        <td width=350>&nbsp;</td>
        <td width=100>&nbsp;</td>
        <td width=150>&nbsp;</td>
        <td width=150>&nbsp;</td>
        <td width=100>&nbsp;</td>
        <td width=250px colspan="2" align="center" class="xl26"><strong>Exempted / Granted Auth</strong></td>
        <td width=150>&nbsp;</td>
    </tr>
    <tr class=columnheading>
        <td class="xl27"><strong>JPA No</strong></td>
        <td class="xl27"><strong>Service No</strong></td>
        <td class="xl27"><strong>Name</strong></td>
        <td class="xl27"><strong>Parent Unit</strong></td>
        <td class="xl27"><strong>Unit</strong></td>
        <td class="xl27"><strong>Post</strong></td>
        <td class="xl27"><strong>Exp Date</strong></td>
        <td class="xl27"><strong>Auth Code</strong></td>
        <td class="xl27"><strong>Description</strong></td>
        <td class="xl27"><strong>Auth'd By</strong></td>
    </tr>
    <% intCount = 0 %>
    <% do while not rsCISAuth.eof %>
        <% intStaffID = rsCISAuth("staffID") %>
        <% if isnull(rsCISAuth("firstname")) or rsCISAuth("firstname") <> "" then %>
            <% strName = rsCISAuth("rank") & " " & rsCISAuth("surname") & ", " & rsCISAuth("firstname") %>
        <% else %>
            <% strName = rsCISAuth("rank") & " " & rsCISAuth("surname") %>
        <% end if %>
        <tr class=itemfont>
            <td width=100 class="xl29"><% if intCount = 0 then %><%=rsCISAuth("assignno")%><% end if %></td>
            <td width=100 class="xl29"><% if intCount = 0 then %><%=rsCISAuth("serviceno")%><% end if %></td>
            <td width=350 class="xl27"><% if intCount = 0 then %><%=strName%><% end if %></td>
            <td width=100 class="xl27"><% if intCount = 0 then %><%=rsCISAuth("hrcparent")%><% end if %></td>
            <td width=150 class="xl27"><% if intCount = 0 then %><%=rsCISAuth("hrcname")%><% end if %></td>
            <td width=150 class="xl27"><% if intCount = 0 then %><%=rsCISAuth("post")%><% end if %></td>
            <td width=100 class="xl29"><%=rsCISAuth("expiry")%></td>
            <td width=100 class="xl27"><%=rsCISAuth("description")%></td>
            <td width=250 class="xl27"><%=rsCISAuth("longdesc")%></td>
            <td width=150 class="xl27"><%=rsCISAuth("authname")%></td>
        </tr>
        <% rsCISAuth.movenext %>
        <% if not rsCISAuth.eof then %>
            <% if intStaffID <> rsCISAuth("staffID") then %>
                <% intCount = 0 %>
            <% else %>
                <% intCount = 1 %>
            <% end if %>
        <% end if %>
    <% loop %>
</table>
</body>
</html>