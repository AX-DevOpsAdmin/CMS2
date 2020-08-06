<!DOCTYPE HTML >

<!--#include file="Includes/security.inc"-->
<!--#include file="Connection/Connection.inc"-->

<%
	response.ContentType = "application/vnd.ms-excel"
	response.addHeader "content-disposition","attachment;filename=newReport.xls"
	
	intUnitID = request("cboTeam")
			
	set objCmd = server.CreateObject("ADODB.Command")
	set objPara = server.CreateObject("ADODB.Parameter")
	objCmd.ActiveConnection = con
	objCmd.Activeconnection.cursorlocation = 3
	
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

.xl27
	{mso-style-parent:style0;
	border-top:.5pt solid windowtext;
	border-right:none;
	border-bottom:.5pt solid windowtext;
	border-left:none;
	white-space:normal;}
	
.xl29
	{mso-style-parent:style0;
	mso-number-format:"\@";
	border-top:.5pt solid windowtext;
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
		<td align="center" colspan="8" style="font-size:14pt;"><U>RAF Fitness Report</U></td>
	</tr>
	<tr height=16px>
		<td colspan="8">&nbsp;</td>
	</tr>
	<tr>
		<td width="100%" class="itemfont" colspan="8">Unit:&nbsp;<font color="#0033FF" size="3"><strong><%= strHrc %></strong></font></td>
	</tr>
	<tr height=16px>
		<td colspan="9">&nbsp;</td>
	</tr>
	<tr>
		<td width="100%" colspan="8">Records Found:&nbsp;<%= intRecords %></td>
	</tr>
	<tr height=16px>
		<td colspan="8">&nbsp;</td>
	</tr>
	<tr>	
    <tr class=columnheading height=20px>
        <td width=350><strong>Name</strong></td>
        <td width=100><strong>Service No</strong></td>
        <td width=250%><strong>Team</strong></td>
        <td width=100><strong>Valid From</strong></td>
        <td width=100><strong>Valid To</strong></td>
        <td width="50" align="center">&nbsp;</td>
        <td width=100><strong>Status</strong></td>
        <td width=100><strong>Expiry Date</strong></td>
    </tr>
	<% do while not rsFitness.eof %>
		<% if isnull(rsFitness("firstname")) or rsFitness("firstname") <> "" then %>
            <% strName = rsFitness("shortDesc") & " " & rsFitness("surname") & ", " & rsFitness("firstname") %>
        <% else %>
            <% strName = rsFitness("shortDesc") & " " & rsFitness("surname") %>
        <% end if %>
        <tr class=itemfont height=20px>
            <td width=350 class="xl27"><%=strName%></td>
            <td width=100 class="xl29"><%=rsFitness("serviceno")%></td>
            <td width=250 class="xl27"><%=rsFitness("description")%></td>
            <td width=100 class="xl29"><%=rsFitness("validfrom")%></td>
            <td width=100 class="xl29"><%=rsFitness("validto")%></td>
            <td width=50 align="center" class="xl27" bgcolor="
                <% if isnull(rsFitness("validto")) and rsFitness("remedial") = 0 and rsFitness("exempt") = 0 then %>
                    #000000
                <% elseif rsFitness("validto") < date and rsFitness("remedial") = 0 and rsFitness("exempt") = 0 then %>
                    #FF0000
                <% elseif rsFitness("remedial") = 1 and rsFitness("expiryDate") <= date then %>
                    #FF0000
                <% elseif rsFitness("remedial") = 1 and rsFitness("expiryDate") > date or rsFitness("remedial") = 1 and isnull(rsFitness("expiryDate")) then %>
                    #FFFF00
                <% elseif rsFitness("exempt") = 1 and rsFitness("expiryDate") <= date then %>
                    #FF0000
                <% elseif rsFitness("exempt") = 1 and rsFitness("expiryDate") > date or rsFitness("exempt") = 1 and isnull(rsFitness("expiryDate")) then %>
                    #FFFF00
                <% elseif rsFitness("validto") => date and rsFitness("remedial") = 0 and rsFitness("exempt") = 0 then %>
                    #00FF00
                <% end if %>">
            </td>
            <td width="100" class="xl27">
                <% if isnull(rsFitness("validto")) and rsFitness("remedial") = 0 and rsFitness("exempt") = 0 then %>No Record
                <% elseif  rsFitness("validto") < date and rsFitness("remedial") = 0 and rsFitness("exempt") = 0 then %>	Out of Date
                <% elseif rsFitness("remedial") = 1 then %>Remedial
                <% elseif rsFitness("exempt") = 1 then %>Exempt
                <% elseif rsFitness("validto") => date and rsFitness("remedial") = 0 and rsFitness("exempt") = 0 then %>In Date
                <% end if %>
            </td>
            <td width=100 class="xl29"><%=rsFitness("expiryDate")%></td>
        </tr>
		<% rsFitness.movenext %>
	<% loop %>
</table>
</body>
</html>