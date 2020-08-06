<!DOCTYPE HTML >

<!--#include file="Includes/security.inc"-->
<!--#include file="Connection/Connection.inc"-->

<%
response.ContentType = "application/vnd.ms-excel"
response.addHeader "content-disposition","attachment;filename=newReport.xls"

set objCmd = server.CreateObject("ADODB.Command")
set objPara = server.CreateObject("ADODB.Parameter")
objCmd.ActiveConnection = con
objCmd.Activeconnection.cursorlocation = 3
objCmd.CommandType = 4	

' first get the harmony Day Limits
objCmd.CommandText = "spGetHarmonyLimits"	'Name of Stored Procedure'
set rsOOA = objCmd.Execute	'Execute CommandText when using "ADODB.Command" object'

strooa = rsOOA("ooaperiod") & " Month Period"
strssa = rsOOA("ssaperiod") & " Month Period"
strssb = rsOOA("ssbperiod") & " Month Period"

' now  get the unit
set objPara = objCmd.CreateParameter ("hrcID",3,1,0, cint(request("cboHRC")))
objCmd.Parameters.Append objPara

if cint(request("cboHRC")) <> 0 then
  objCmd.CommandText = "spHrcDetail"
  set rsHrc = objCmd.Execute
  strHrc=rsHrc("hrcname")
end if  

if request("chkSub") = 1 then
	'Execute this stored procedure if sub team(s) has been checked
	objCmd.CommandText = "spGetHarmonyReport"
	set objPara = objCmd.CreateParameter ("gender",3,1,0, cint(request("cboGender")))
	objCmd.Parameters.Append objPara
else
	'Executes this stored procedure if sub team is NOT checked
	objCmd.CommandText = "spGetHarmonyReportDetails"
	set objPara = objCmd.CreateParameter ("gender",3,1,0, cint(request("cboGender")))
	objCmd.Parameters.Append objPara
end if

' now  get the team
'set objPara = objCmd.CreateParameter ("tmID",3,1,0, cint(request("cboTeam")))
'objCmd.Parameters.Append objPara

'if cint(request("cboTeam")) <> 0 then
'  objCmd.CommandText = "spTeamDetail"
'  set rsTeam = objCmd.Execute
'  strHrc=rsTeam("Description")
'end if  
'
'if request("chkSub") = 1 then
'	'Execute this stored procedure if sub team(s) has been checked
'	objCmd.CommandText = "spGetHarmonyReport"
'	set objPara = objCmd.CreateParameter ("gender",3,1,0, cint(request("cboGender")))
'	objCmd.Parameters.Append objPara
'else
'	'Executes this stored procedure if sub team is NOT checked
'	objCmd.CommandText = "spGetHarmonyReportDetails"
'	set objPara = objCmd.CreateParameter ("gender",3,1,0, cint(request("cboGender")))
'	objCmd.Parameters.Append objPara
'end if

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
	
.xl39
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
		<td align="center" colspan="9" style="font-size:14pt;"><U>Personnel Harmony Report</U></td>
	</tr>
	<tr height=16px>
		<td colspan="9">&nbsp;</td>
	</tr>
	<tr>
		<td width="100%" colspan="9" class="itemfont">Unit:&nbsp;<font color="#0033FF" size="3"><strong><%= strHrc %></strong></font></td>
	</tr>
	<tr height=16px>
		<td colspan="9">&nbsp;</td>
	</tr>
	<tr>
		<td width="100%" colspan="9">Records Found:&nbsp;<%=rsRecSet.recordcount%></td>
	</tr>
	<tr height=16px>
		<td colspan="9">&nbsp;</td>
	</tr>
    <tr class=columnheading valign="bottom" height=20px>
        <td width=480><strong>Name</strong></td>
        <td width=100><strong>Service No</strong></td>
        <td width="100"><strong>Last OOA</strong></td>
        <td colspan="2" width="100" align="center"><strong>OOA Days</strong></td>
        <td colspan="2" width="100" align="center"><strong>SSC A Days</strong></td>
        <td colspan="2" width="100" align="center"><strong>SSC B Days</strong></td>
    </tr>
    <tr class=columnheading valign="top" height=20px>
        <td width=480>&nbsp;</td>
        <td width=100>&nbsp;</td>
        <td width="100">&nbsp;</td>
        <td colspan="2" width="100" align="center"><strong><%= strooa %></strong></td>
        <td colspan="2" width="100" align="center"><strong><%= strssa %></strong></td>
        <td colspan="2" width="100" align="center"><strong><%= strssb %></strong></td>
    </tr>
    <% do while not rsRecSet.eof %>
        <tr class=itemfont height=20px>
            <td width=480 class="xl27"><%=rsRecSet("shortDesc") & " " & rsRecSet("surname") & ", " & rsRecSet("firstname")%></td>
            <td width=100 class="xl39"><%=rsRecSet("serviceNo")%></td>
            <td width="100" align="left" class="xl27"><%=rsRecSet("lastOOA")%></td>
            <td width="80" align="center" class="xl27"><%=rsRecSet("ooaDays")%></td>
            <td width="20" class="xl27" bgcolor="<% if (rsRecSet("ooaDays") >= rsOOA("ooared")) then %>#FF0000<% elseif (rsRecSet("ooaDays") < rsOOA("ooared")) AND (rsRecSet("ooaDays") >= rsOOA("ooaamber")) then %>#FF9900<% elseif (rsRecSet("ooaDays") < rsOOA("ooaamber")) then %>#00CC00<% end if %>"></td>
            <td width="80" class="xl27" align="center"><%=rsRecSet("ssaDays")%></td>
            <td width="20" class="xl27" bgcolor="<% if (rsRecSet("ssaDays") >= rsOOA("ssared")) then %>#FF0000<% elseif (rsRecSet("ssaDays") < rsOOA("ssared")) AND (rsRecSet("ssaDays") >= rsOOA("ssaamber")) then %>#FF9900<% elseif (rsRecSet("ssaDays") < rsOOA("ssaamber")) then %>#00CC00<% end if %>"></td>                     
            <td width="80" class="xl27" align="center"><%=rsRecSet("ssbDays")%></td>
            <td width="20" class="xl27" bgcolor="<% if (rsRecSet("ssbDays") >= rsOOA("ssbred")) then %>#FF0000<% elseif (rsRecSet("ssbDays") < rsOOA("ssbred")) AND (rsRecSet("ssbDays") >= rsOOA("ssbamber")) then %>#FF9900<% elseif (rsRecSet("ssbDays") < rsOOA("ssbamber")) then %>#00CC00<% end if %>"></td>
        </tr>
        <% rsRecSet.movenext %>
    <% loop %>
</table>
</body>
</html>