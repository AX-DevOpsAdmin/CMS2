<!DOCTYPE HTML >

<!--#include file="Includes/security.inc"-->
<!--#include file="Connection/Connection.inc"-->

<%
	intStaffID = request("newattached")
	
'	response.write(intStaffID)
'	response.end()
	
	set objCmd = server.createobject("ADODB.Command")
	set objPara = server.createobject("ADODB.Parameter")
	objCmd.activeconnection = con
	objCmd.commandtext = "spGetIndividualAuths"
	objCmd.activeconnection.cursorlocation = 3
	objCmd.commandtype = 4
	
	' now add reporting parameters
	set objPara = objCmd.createparameter ("@staffID",3,1,0, cint(intStaffID))
	objCmd.parameters.append objPara
	set rsCISAuth = objCmd.execute	'Execute CommandText when using "ADODB.Command" object'
	
	if isnull(rsCISAuth("firstname")) or rsCISAuth("firstname") <> "" then
	   strName = rsCISAuth("rank") & " " & rsCISAuth("surname") & ", " & rsCISAuth("firstname")
	else
	   strName = rsCISAuth("rank") & " " & rsCISAuth("surname")
	end if
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
<table border=0 cellpadding=0 cellspacing=0 width=80% align="center">
	<tr>
		<td colspan="6">&nbsp;</td>
	</tr>
	<tr>
		<td colspan="6">Individual Authorisation Report</td>
	</tr>
    <tr>
        <td colspan="6" class=titlearealine  height=1></td> 
    </tr>
	<tr>
		<td colspan="6">&nbsp;</td>
	</tr>
	<tr>
        <td width="19%">Ref: AP600 Chapter 3.9</td>
        <td align="center" colspan="2"><u>Record of Authorisations</u></td> 
        <td width="24%"  colspan="3">&nbsp;</td>
	</tr>
	<tr>
		<td colspan="6">&nbsp;</td>
	</tr>

</table>
<table border=1 cellpadding=0 cellspacing=0 width=80% align="center">
    <tr class=columnheading>	
        <td width=77 >&nbsp;JPA No</td>
        <td width=90 >&nbsp;Service No</td>
        <td width=242 >&nbsp;Name</td>
        <td width=69 >&nbsp;Wing</td>
        <td width=99 >&nbsp;Squadron</td>
        <td width=183 >&nbsp;Post</td>
    </tr>

    <tr>
        <td height=20 class="itemfont">&nbsp;<%=rsCISAuth("assignno")%></td>
        <td height=20 class="itemfont">&nbsp;<%=rsCISAuth("serviceno")%></td>
        <td height=20 class="itemfont">&nbsp;<%=strName%></td>
        <td height=20 class="itemfont">&nbsp;<%=rsCISAuth("wg")%></td>
        <td height=20 class="itemfont">&nbsp;<%=rsCISAuth("sqn")%></td>
        <td height=20 class="itemfont">&nbsp;<%=rsCISAuth("post")%></td>
    </tr>
              
    <% intCount = 1 %>
    <% if not rsCISAuth.eof then %>
        <% do while not rsCISAuth.eof %>
            
            <% if intCount = 1 then %>              
              <tr>
                <td height=20 colspan="6">&nbsp;</td> 
              </tr>
              <tr>
                <td width=106 rowspan="2">&nbsp;Exp Date</td>
                <td width=397 colspan="3" height=20 align="center">Exempted/Granted Auth</td>
                <td width=122 rowspan="2">&nbsp;Assessor</td>
                <td width=122 rowspan="2">&nbsp;Approver</td>
              </tr>
              <tr class=columnheading>
                <td width=139 height=20>&nbsp;Auth Code</td>
                <td width=258 height=20 colspan="2">&nbsp;Description</td>
              </tr>
            <% end if %>
            <tr>
                <td height=20 class="itemfont">&nbsp;<%=rsCISAuth("expiry")%></td>
                <td height=20 class="itemfont" >&nbsp;<%=rsCISAuth("description")%></td>
                <td height=20 class="itemfont" colspan="2">&nbsp;<%=rsCISAuth("longdesc")%></td>
                <td height=20 class="itemfont">&nbsp;<%=rsCISAuth("assessor")%></td>
                 <td height=20 class="itemfont">&nbsp;<%=rsCISAuth("approver")%></td>
            </tr>
            <% intCount = intCount + 1 %>
            <% rsCISAuth.movenext %>
        <% loop %>
    <% end if %>
    
    
    <% if intCount < 10 then %>
        <% for i = intCount to 10 %>
    
            <tr>
                <td height=20>&nbsp;</td>
                <td height=20>&nbsp;</td>
                <td height=20 colspan="2">&nbsp;</td>
                <td height=20>&nbsp;</td>
                <td height=20>&nbsp;</td>
            </tr>
            
        <% next %>
    <% end if %>
    <tr>
		<td colspan=4 height=80 width=409 valign="middle">
        	I certify that I have read the AP600 Chapters relating to the tasks listed
			above and understand the responsibilities associated with them and the
			implications of using my signature/initials on maintenance documentation.
		</td>
		<td colspan=2>&nbsp;</td>
    </tr>
    
</table>
</body>
</html>