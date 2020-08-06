<!DOCTYPE HTML >

<!--#include file="Includes/security.inc"-->
<!--#include file="Connection/Connection.inc"-->

<%
set objCmd = server.CreateObject("ADODB.Command")
set objPara = server.CreateObject("ADODB.Parameter")
objCmd.ActiveConnection = con
objCmd.Activeconnection.cursorlocation = 3
objCmd.CommandType = 4	

response.ContentType = "application/vnd.ms-excel"
response.addHeader "content-disposition","attachment;filename=RunOutDateReport.xls"

hrcID = request("cbohrc")
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


strCommand = "spListQTypes"
objCmd.CommandText = strCommand
set objPara = objCmd.CreateParameter ("nodeID",3,1,0, nodeID)
objCmd.Parameters.Append objPara
	
set rsTypeQList = objCmd.Execute	'Execute CommandText when using "ADODB.Command" object'

for x = 1 to objCmd.parameters.count
	objCmd.parameters.delete(0)
next

Counter = rsTypeQList.recordcount

strTitle1 = "Expiry Date Report"

if request("newattached") = "" then
	qualifications = ""
else
	qualifications = request("newattached")
	strTitle2 = "Qualification "
end if

if request("milskill") = "" then
	milskill = ""
else
	milskill = request("milskill")
	strTitle2 = "Military Skill "
end if

if request("vacs") = "" then
	vacs = ""
else
	vacs = request("vacs")
	strTitle2 = "Vaccination "
end if

if request("fitness") = "" then
	fitness = ""
else
	fitness = request("fitness")
	strTitle2 = "Fitness "
end if

if request("dental") = "" then
	dental = ""
else
	dental = request("dental")
	strTitle2 = "Dental "
end if

gender = request("gender")    ' 1 = BOTH,  2=MALE, 3=FEMALE

if request("civi") = 1 then
	civi = request("civi")
else
	civi = 0
end if

objCmd.CommandText = "spGetRunOutDate"

set objPara = objCmd.CreateParameter ("hrcID",3,1,0, hrcID)
objCmd.Parameters.Append objPara
set objPara = objCmd.CreateParameter ("QStatus",3,1,0, int(request("Status1")))
objCmd.Parameters.Append objPara
set objPara = objCmd.createparameter("qualification",200,1,1000, qualifications)
objCmd.parameters.append objPara
set objPara = objCmd.CreateParameter ("MSStatus",3,1,0, int(request("Status2")))
objCmd.Parameters.Append objPara
set objPara = objCmd.CreateParameter ("milSkill",200,1,500,  milSkill)
objCmd.Parameters.Append objPara
set objPara = objCmd.CreateParameter ("VacStatus",3,1,0, int(request("Status3")))
objCmd.Parameters.Append objPara
set objPara = objCmd.CreateParameter ("vacs",200,1,500,  vacs)
objCmd.Parameters.Append objPara
set objPara = objCmd.CreateParameter ("FitnessStatus",3,1,0, int(request("Status4")))
objCmd.Parameters.Append objPara
set objPara = objCmd.CreateParameter ("fitness",200,1,500,  fitness)
objCmd.Parameters.Append objPara
set objPara = objCmd.CreateParameter ("DentalStatus",3,1,0, int(request("Status5")))
objCmd.Parameters.Append objPara
set objPara = objCmd.CreateParameter ("dental",200,1,500, dental)
objCmd.Parameters.Append objPara
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
		<td colspan="7" align="center" style="font-size:14pt;"><U><%= strTitle2 & " " & strTitle1 %></U></td>
	</tr>
	<tr height=16px>
		<td colspan="7">&nbsp;</td>
	</tr>
    <tr>
        <td colspan="7" width="100%" class="itemfont">Unit:&nbsp;<font color="#0033FF" size="3"><strong><%= strHrc %></strong></font></td>
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
        <td width=250><strong>Unit</strong></td>
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
            <td width=250 class="xl27"><%= rsRecSet("hrcname") %></td>
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