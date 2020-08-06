<!DOCTYPE HTML >

<!--#include file="Includes/security.inc"-->
<!--#include file="Connection/Connection.inc"-->

<%
response.ContentType = "application/vnd.ms-excel"
response.addHeader "content-disposition","attachment;filename=PersonnelbyPost.xls"

set objCmd = server.CreateObject("ADODB.Command")
set objPara = server.CreateObject("ADODB.Parameter")
objCmd.ActiveConnection = con
objCmd.Activeconnection.cursorlocation = 3
objCmd.CommandType = 4	

' now  get the team
set objPara = objCmd.CreateParameter ("tmID",3,1,0, cint(request("cboTeam")))
objCmd.Parameters.Append objPara

if cint(request("cboTeam")) <> 0 then
  objCmd.CommandText = "spTeamDetail"
  set rsTeam = objCmd.Execute
  strTeam=rsTeam("Description")
end if
  
objCmd.CommandText = "spGetPersonnelbyPost"

set objPara = objCmd.CreateParameter ("sub",3,1,0, cint(request("chkSub")))
objCmd.Parameters.Append objPara
set objPara = objCmd.CreateParameter ("post",200,1,50, request("cboPost"))
objCmd.Parameters.Append objPara
set rsRecSet = objCmd.Execute	'Execute CommandText when using "ADODB.Command" object'
%>

<html>
<head>

<!--#include file="Includes/IECompatability.inc"-->


<title><%= PageTitle %></title>
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
<table border=0 cellpadding=0 cellspacing=0 width=100%>
	<tr class=titlearea>
		<td colspan="3" align="center" style="font-size:14pt;"><U>Personnel by Post Report</U></td>
	</tr>
	<tr height=16px>
		<td colspan="3">&nbsp;</td>
	</tr>
	<tr>
		<td width="100%" colspan="3" class="itemfont">Unit:&nbsp;<font color="#0033FF" size="3"><strong><%= strTeam %></strong></font></td>
	</tr>
	<tr height=16px>
		<td colspan="3">&nbsp;</td>
	</tr>
	<tr>
		<td width="100%" colspan="3">Records Found:&nbsp;<%=rsRecSet.recordcount%></td>
	</tr>
	<tr height=16px>
		<td colspan="3">&nbsp;</td>
	</tr>
    <tr class=columnheading valign="bottom" height=20px>
        <td width=100><strong>Service No.</strong></td>
        <td width=350><strong>Name</strong></td>
        <td width=350><strong>Post Description</strong></td>
    </tr>
    <tr>
        <td colspan=3 class=titlearealine  height=1></td> 
    </tr>
    <% do while not rsRecSet.eof %>
        <% if isnull(rsRecSet("firstname")) or rsRecSet("firstname") <> "" then %>
            <% strName = rsRecSet("rank") & " " & rsRecSet("surname") & ", " & rsRecSet("firstname") %>
        <% else %>
            <% strName = rsRecSet("rank") & " " & rsRecSet("surname") %>
        <% end if %>
        <tr class=itemfont height=20px>
            <td width=100 class="xl29"><%= rsRecSet("serviceno") %></td>
            <td width=350 class="xl27"><%= strName %></td>
            <td width=350 class="xl27"><%= rsRecSet("postDesc") %></td>
        </tr>
        <% rsRecSet.movenext %>
    <% loop %>
</table>
</body>
</html>