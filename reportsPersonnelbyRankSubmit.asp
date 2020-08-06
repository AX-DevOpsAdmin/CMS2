<!DOCTYPE HTML >

<!--#include file="Includes/security.inc"-->
<!--#include file="Connection/Connection.inc"-->

<% 
chksubs = cint(request("chkSub"))

set objCmd = server.CreateObject("ADODB.Command")
set objPara = server.CreateObject("ADODB.Parameter")
objCmd.ActiveConnection = con
objCmd.Activeconnection.cursorlocation = 3
objCmd.CommandType = 4	

hrcID=request("cboHrc")
objCmd.commandtext = "spGetHierarchyDetail"

' now  get the unit
set objPara = objCmd.createparameter ("hrcID",3,1,0, cint(hrcID))
objCmd.parameters.append objPara
set rsHrc = objCmd.execute

'Retrieves the team name
strHrc = rsHrc("hrcname")

' If we want to see ALL sub teams or not 
if chksubs=0 then
  objCmd.CommandText = "spGetPersonnelbyRank"
else
  objCmd.CommandText = "spGetSubPersbyRank"
end if
set objPara = objCmd.CreateParameter ("rankID",3,1,0, cint(request("cboRank")))
objCmd.Parameters.Append objPara
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
		<td align="center"><U>Personnel by Rank Report</U></td>
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
                                <td width=95>Service No.</td>
                                <td width=250>Name</td>
                                <td width=250>Post Description</td>
                            </tr>
                            <tr>
                                <td colspan=4 class=titlearealine  height=1></td> 
                            </tr>
                            <% do while not rsRecSet.eof %>
                                <% if isnull(rsRecSet("firstname")) or rsRecSet("firstname") <> "" then %>
                                    <% strName = rsRecSet("rank") & " " & rsRecSet("surname") & ", " & rsRecSet("firstname") %>
                                <% else %>
                                    <% strName = rsRecSet("rank") & " " & rsRecSet("surname") %>
                                <% end if %>
                                <tr class=itemfont height=20px>
                                    <td>&nbsp;</td>
                                    <td width=95><%= rsRecSet("serviceno") %></td>
                                    <td width=250><%= strName %></td>
                                    <td width=250><%= rsRecSet("postDesc") %></td>
                                </tr>
                                <tr>
                                    <td colspan=4 class=titlearealine  height=1></td> 
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