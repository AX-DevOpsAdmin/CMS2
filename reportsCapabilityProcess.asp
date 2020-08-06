<!DOCTYPE HTML >

<!--#include file="Connection/Connection.inc"-->
<%

set objCmd = server.CreateObject("ADODB.Command")
set objPara = server.CreateObject("ADODB.Parameter")
objCmd.ActiveConnection = con
objCmd.Activeconnection.cursorlocation = 3
objCmd.CommandText = "spFltTeamCapability"
objCmd.CommandType = 4		

set objPara = objCmd.CreateParameter ("thisDate",200,1,30, "18 jul 2007")
objCmd.Parameters.Append objPara

set rsRecSet = objCmd.Execute	'Execute CommandText when using "ADODB.Command" object'
%>
<html>
<head> 

<!--#include file="Includes/IECompatability.inc"-->
<title>Custom Report</title>
<link rel="stylesheet" type="text/css" href="Includes/AMDB.css" />
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1"><style type="text/css">
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
</style></head>
<body>
<table border=0 cellpadding=0 cellspacing=0 width=100%>
	<tr class=titlearea>
		<td colspan=6>These figures are for the 18th July 2007 only.</td>
	</tr>
	<tr>
	  <td  colspan=6 class=titlearealine  height=1></td> 
	</tr>
	<tr height=16px>
	  <td colspan=6  align="center">&nbsp;</td> 
	</tr>

	<tr class=titlearea>
		<td ><U>Flight</td>
		<td ><U>UnTasked</td>
		<td ><U>Tasked</td>
		<td ><U>UnTrained</td>
		<td ><U>Vacant</td>
		<td ><U>Total</td>

	</tr>

<%do while not rsRecSet.eof%>
	<tr class=titlearea>
		<td ><%=rsRecSet("Flight")%></td>
		<td ><%=rsRecSet("UnTasked")%></td>
		<td ><%=rsRecSet("Tasked")%></td>
		<td ><%=rsRecSet("UnTrained")%></td>
		<td ><%=rsRecSet("Vacant")%></td>
		<td ><%=rsRecSet("total")%></td>

	</tr>
	<tr>
	  <td  colspan=6 class=titlearealine  height=1></td> 
	</tr>

<%
rsRecSet.movenext
loop
%>
	<tr height=16px>
	  <td colspan=6  align="center">&nbsp;</td> 
	</tr>

	<tr>
	  <td colspan=6  align="center"><input type=button value=Refresh onclick="window.location.href = 'reportsCapabilityWaiting.asp';"></td> 
	</tr>

</table>

</body>
</html>
