<!DOCTYPE HTML >

<!--#include file="Includes/security.inc"-->
<!--#include file="Connection/Connection.inc"-->

<%



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

' now  get the team
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

set rsRecSet = objCmd.Execute	'Execute CommandText when using "ADODB.Command" object'
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
		<td align="center"><U>Personnel Harmony Report</U></td>
	</tr>
	<tr height=16px>
		<td>&nbsp;</td>
	</tr>
	<tr>
		<td>
			<table width="100%" border="0" cellpadding="0" cellspacing="0">
				<tr>
					<td width="100%" class="itemfont">Unit:&nbsp;<font color="#0033FF" size="3"><strong><%= strHrc %></strong></font></td>
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
					<td width="100%">Records Found:&nbsp;<%=rsRecSet.recordcount%></td>
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
					<td>
                        <table border=0 cellpadding=0 cellspacing=0 width=100%>
                            <tr class=columnheading valign="bottom" height=20px>
                                <td width="4">&nbsp;</td>
                                <td width=447>Name</td>
                                <td width=129>Service No</td>
                                <td width="117">Last OOA</td>
                                <td colspan="2" width="100" align="center">OOA Days</td>
                                <td width="9">&nbsp;</td>
                                <td colspan="2" width="100" align="center">SSC A Days</td>
                                <td width="9">&nbsp;</td>
                                <td colspan="2" width="100" align="center">SSC B Days</td>
                            </tr>
                            <tr class=columnheading valign="top" height=20px>
                                <td>&nbsp;</td>
                                <td width=447>&nbsp;</td>
                                <td width=129>&nbsp;</td>
                                <td width="117">&nbsp;</td>
                                <td colspan="2" width="100" align="center"><%= strooa %></td>
                                <td width="9">&nbsp;</td>
                                <td colspan="2" width="100" align="center"><%= strssa %></td>
                                <td width="9">&nbsp;</td>
                                <td colspan="2" width="100" align="center"><%= strssb %></td>
                            </tr>
                            <tr>
                                <td colspan=18 class=titlearealine  height=1></td> 
                            </tr>
                            <% do while not rsRecSet.eof %>
                                <tr class=itemfont height=20px>
                                    <td>&nbsp;</td>
                                    <td width=447><%=rsRecSet("shortDesc") & " " & rsRecSet("surname") & ", " & rsRecSet("firstname")%></td>
                                    <td width=129><%=rsRecSet("serviceNo")%></td>
                                    <td width="117"><%=rsRecSet("lastOOA")%></td>
                                    <td width="82" align="center"><%=rsRecSet("ooaDays")%></td>
                                    <td width="18" bgcolor="<% if (rsRecSet("ooaDays") >= rsOOA("ooared")) then %>#FF0000<% elseif (rsRecSet("ooaDays") < rsOOA("ooared")) AND (rsRecSet("ooaDays") >= rsOOA("ooaamber")) then %>#FF9900<% elseif (rsRecSet("ooaDays") < rsOOA("ooaamber")) then %>#00CC00<% end if %>"></td>
                                    <td width="9">&nbsp;</td>
                                    <td width="82" align="center"><%=rsRecSet("ssaDays")%></td>
                                    <td width="18" bgcolor="<% if (rsRecSet("ssaDays") >= rsOOA("ssared")) then %>#FF0000<% elseif (rsRecSet("ssaDays") < rsOOA("ssared")) AND (rsRecSet("ssaDays") >= rsOOA("ssaamber")) then %>#FF9900<% elseif (rsRecSet("ssaDays") < rsOOA("ssaamber")) then %>#00CC00<% end if %>"></td>                     
                                    <td width="9">&nbsp;</td>
                                    <td width="82" align="center"><%=rsRecSet("ssbDays")%></td>
                                    <td width="18" bgcolor="<% if (rsRecSet("ssbDays") >= rsOOA("ssbred")) then %>#FF0000<% elseif (rsRecSet("ssbDays") < rsOOA("ssbred")) AND (rsRecSet("ssbDays") >= rsOOA("ssbamber")) then %>#FF9900<% elseif (rsRecSet("ssbDays") < rsOOA("ssbamber")) then %>#00CC00<% end if %>"></td>
                                </tr>
                                <tr>
                                    <td colspan=18 class=titlearealine  height=1></td> 
                                </tr>
                                <% rsRecSet.movenext %>
                            <% loop %>
                        </table>
					</td>
				</tr>
            	<tr>
            		<td>&nbsp;</td> 
            	</tr>
			</table>
		</td>
	</tr>
</table>
</body>
</html>