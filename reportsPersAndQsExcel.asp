<!DOCTYPE HTML >

<!--#include file="Includes/security.inc"-->
<!--#include file="Connection/Connection.inc"-->

<%
response.ContentType = "application/vnd.ms-excel"
response.addHeader "content-disposition","attachment;filename=PersonnelAndQsReport.xls"

set objCmd = server.CreateObject("ADODB.Command")
set objPara = server.CreateObject("ADODB.Parameter")
objCmd.ActiveConnection = con
objCmd.Activeconnection.cursorlocation = 3
objCmd.CommandType = 4

strCommand = "spListQTypes"
objCmd.CommandText = strCommand
objCmd.CommandType = 4	

set objPara = objCmd.CreateParameter ("nodeID",3,1,0, nodeID)
objCmd.Parameters.Append objPara
	
set rsTypeQList = objCmd.Execute	'Execute CommandText when using "ADODB.Command" object'

Counter = rsTypeQList.recordcount

for x = 1 to objCmd.parameters.count
	objCmd.parameters.delete(0)
next

'response.write(counter)
'response.end()

strTitle1 = "Qualification Expiry Date Report"
qID=cint(request("newattached"))

gender = request("gender")    ' 1 = BOTH,  2=MALE, 3=FEMALE

if request("civi") = 1 then
	civi = request("civi")
else
	civi = 0
end if
objCmd.CommandText = "spGetPersonnelAndQs"

set objPara = objCmd.CreateParameter ("QStatus",3,1,0, int(request("Status1")))
objCmd.Parameters.Append objPara
set objPara = objCmd.CreateParameter ("civi",3,1,0, qID)
objCmd.parameters.append objPara
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
		<td colspan="7" align="center" style="font-size:14pt;"><U><%= strTitle1 %></U></td>
	</tr>
    <tr>
        <td colspan="7">&nbsp;</td>
    </tr>
    <tr>
        <td colspan="7" valign="middle" height=22px class=itemfont><%= rsRecSet("Type") & " " & strType %><b><%= rsRecSet("Description") %></b></td>
    </tr>
    <tr>
        <td colspan="7">&nbsp;</td>
    </tr>
    <% set rsRecSet = rsRecSet.nextrecordset %>
    <tr class=itemfont>
        <td colspan="7" valign="middle" height=22px>Records Found: <%=rsRecSet.recordcount%></Font></td>
    </tr>
    <tr>
        <td colspan="7">&nbsp;</td>
    </tr>
    <tr class=columnheading>
        <td width=350><strong>Name</strong></td>
        <td width=100><strong>Service No</strong></td>
        <td width=100><strong>Valid From</strong></td>
        <td width=100><strong>Valid To</strong></td>
        <td width=50 align="center">&nbsp;</td>
        <td width=100><strong>Status</strong></td>
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
            <td width=350 class="xl27"><%= strName %></td>
            <td width=100 class="xl29"><%= rsRecSet("serviceno") %></td>
            <td width=100 class="xl29"><%= rsRecSet("validfrom") %></td>
            <td width=100 class="xl29"><%= strValidTo %></td>
            <td width=50 class="xl27" align="center" bgcolor="
                <% if date > strValidTo then %>
                    #FF0000
                <% elseif date >= strAmberDate and date <= strValidTo then %>
                    #FF0000
                <% elseif date >= strValidFrom and date < strAmberDate then %>
                    #00FF00
                <% else %>
                    &nbsp;
                <% end if %>">
            </td>
            <td width=100 class="xl27">
                <% if strValidTo < date then %>	Out of Date
                <% elseif strValidTo >= date then %>In Date
                <% end if %>
            </td>
        </tr>
        <% rsRecSet.movenext %>
    <% loop %>
</table>
</body>
</html>