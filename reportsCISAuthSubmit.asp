<!DOCTYPE HTML >

<!--#include file="Includes/security.inc"-->
<!--#include file="Connection/Connection.inc"-->

<%
	authID = request("apprvID")
	atpID = request("atpID")
	
	'response.write (authID & " * " & atpID )
	'response.End()
	
	set objCmd = server.createobject("ADODB.Command")
	set objPara = server.createobject("ADODB.Parameter")
	objCmd.activeconnection = con
	objCmd.activeconnection.cursorlocation = 3
	objCmd.commandtype = 4
		
	objCmd.commandtext = "spGetOneAuth"
	' now  get the unit
	set objPara = objCmd.createparameter ("authID",3,1,0, authID)
	objCmd.parameters.append objPara
	set objPara = objCmd.createparameter ("atpID",3,1,0, atpID)
	objCmd.parameters.append objPara

	set rsAuth = objCmd.execute
	
	objCmd.commandtext = "spAuthIndividualList"

	' now add reporting parameters
'	set objPara = objCmd.createparameter ("@tmID",3,1,0, cint(hrcID))
'	objCmd.parameters.append objPara
	set rsCISAuth = objCmd.execute	'Execute CommandText when using "ADODB.Command" object'
	
	intRecords = rsCISAuth.recordcount
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
<table border=0 cellpadding=0 cellspacing=0 width=100%>
	<tr>
		<td>&nbsp;</td>
	</tr>
	<tr class=titlearea>
		<td align="center"><U>CMS Authorisation Report</U></td>
	</tr>
	<tr height=16px>
		<td>&nbsp;</td>
	</tr>
	<tr>
		<td>
			<table width="100%" border="0" cellpadding="0" cellspacing="0">
				<tr>
					<td width="100%" class="itemfont">Authorisation Code:&nbsp;<font color="#0033FF" size="3"><%=rsAuth("authcode")%></font></td>
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
					<td width="100%">Records Found:&nbsp;<%= intRecords %></td>
				</tr>
			</table>
		</td>
	</tr>
	<tr height=16px>
		<td>&nbsp;</td>
	</tr>
	<tr>	
		<td>
			<table border=0 cellpadding=0  cellspacing=0 width=100%>
				<tr>
					<td >
                        <table border=0 cellpadding=0 cellspacing=0   width=100%>
                            <tr class=columnheading>
                                <td width=4 height=20px>&nbsp;</td>
                                <td width=70 height=20px>&nbsp;</td>
                                <td width=150 height=20px>&nbsp;</td>
                                <td height=20px>&nbsp;</td>
                                <td height=20px>&nbsp;</td>
                                <td width=150 height=20px>&nbsp;</td>
                                <td width=80 height=20px>&nbsp;</td>
                                <td width=100 height=20px>&nbsp;</td>
                            </tr>
                            <tr class=columnheading>
                                <td height=20px>&nbsp;</td>
                                <td height=20px>Service No</td>
                                <td height=20px>Name</td>
                                <td height=20px>Unit</td>
                                <td height=20px>Post</td>
                                <td height=20px>Exp Date</td>
                                <td height=20px>Auth'd By</td>
                                <td height=20px>Status</td>
                            </tr>
                            <tr>
                                <td colspan=8 class=titlearealine  height=1></td> 
                            </tr>
                            <% intCount = 0 %>
                            <% do while not rsCISAuth.eof %>
                          
                                <tr class=itemfont>
                                    <td width=4 height=20px>&nbsp;</td>
                                    <td width=70 height=20px><% if intCount = 0 then %><%=rsCISAuth("serviceno")%><% end if %></td>
                                    <td width=150 height=20px><% if intCount = 0 then %><%=rsCISAuth("name")%><% end if %></td>
                                    <td width=100 height=20px><% if intCount = 0 then %><%=rsCISAuth("unit")%><% end if %></td>
                                    <td width=100 height=20px><% if intCount = 0 then %><%=rsCISAuth("post")%><% end if %></td>
                                    <td width=60 height=20px><%= rsCISAuth("expiry") %></td>
                                    <td width=150 height=20px><%=rsCISAuth("authby")%></td>
                                    <td width=20 height=20px>
                                        <% if rsCISAuth("expiry") < date then %>
                                            <img src="Images/red box.gif" width="13" height="13" align="middle" alt="Out of Date">                                                
                                        <% elseif rsCISAuth("expiry")  > date and (rsCISAuth("expiry") < date + 14) then %>
                                            <img src="Images/yellow box.gif" width="13" height="13" align="middle" alt="Remedial">                                                
                                        <% elseif rsCISAuth("expiry") => date then %>
                                            <img src="Images/green box.gif" width="13" height="13" align="middle" alt="In Date">
                                        <% end if %>
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan=8 class=titlearealine  height=1></td> 
                                </tr>
                                <% rsCISAuth.movenext %>
                            <% loop %>
                        </table>
					</td>
			 	</tr>
			</table>
		</td> 
	</tr>
	<tr>
		<td>&nbsp;</td>
	</tr>
</table>
</body>
</html>