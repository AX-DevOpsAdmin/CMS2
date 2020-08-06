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
	set rsAuths = objCmd.execute	'Execute CommandText when using "ADODB.Command" object'
	
	strServiceNo = rsAuths("serviceno")
	strPost = rsAuths("post")
	if isnull(rsAuths("firstname")) or rsAuths("firstname") <> "" then
	   strName = rsAuths("rank") & " " & rsAuths("surname") & ", " & rsAuths("firstname")
	else
	   strName = rsAuths("rank") & " " & rsAuths("surname")
	end if
	strTrade = rsAuths("trade")
%>
            
<html>
<head>

<!--#include file="Includes/IECompatability.inc"-->


<title>Custom Report</title>
<link rel="stylesheet" type="text/css" href="Includes/AMDB.css" />
<link rel="stylesheet" type="text/css" href="Includes/print.css" />
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

.grayout {
	/*opacity:0.6;*/
	background:#ccc;
	}

a {
	text-decoration:none;
	cursor:default;
}

a:hover {
	text-decoration:underline;
}

.centeralign {
	padding:3px;
	text-align:center;
}

.itemfont {
	padding:3px;
}

table {
	margin:0 auto;
}

table td {
	text-align:left;
}
-->
</style>

</head>
<body>
<table border="0" cellpadding="0" cellspacing="0" width="90%">
	<tr>
		<td colspan="3">&nbsp;</td>
	</tr>
    <tr>
        <td width="20%"><a onClick="window.print();"><img src="Images/print.gif">&nbsp;Print</a></td>
        <td>&nbsp;</td> 
        <td width="10%"><b>RAF Form 4820B</b></td>
	</tr>
    <tr>
        <td width="20%">&nbsp;</td>
        <td>&nbsp;</td> 
        <td width="10%"><b>(Revised Jun 13)</b></td>
	</tr>
    <tr>
        <td width="20%"><b>Authorisations</b></td>
        <td>&nbsp;</td> 
        <td width="10%"><b>PPQ = 100</b></td>
	</tr>
    <tr>
		<td colspan="3">&nbsp;</td>
	</tr>
</table>

<table id="RAF4820B" border="1" cellpadding="0" cellspacing="0" width="90%">
    <thead>
        <tr>
            <td class="centeralign" width=30>Line No</td>	
            <td class="centeralign" width=40>MAP/Local Auth</td>
            <td class="centeralign" width=220>Activity</td>
            <td class="centeralign" width=69>Validity Period</td>
            <td class="centeralign" width=69>Expiry Date</td>
            <td class="centeralign" width=178>Examiners Signature/Printed Name</td>
            <td class="centeralign" width=183>Authorisers Signature/Printed Name</td>
            <td class="centeralign" width=69>Expiry Date</td>
            <td class="centeralign" width=178>Examiners Signature/Printed Name</td>
            <td class="centeralign" width=180>Authorisers Signature/Printed Name</td>
        </tr>
    </thead>
    <tbody>
        <%i = 1%>	
        <%do while Not rsAuths.eof%>
        <tr>
            <td height=25 class="centeralign"><div><%=i%></div></td>
            <td height=25 class="itemfont"><div><%=rsAuths("description")%></div></td>
            <td height=25 class="itemfont"><div><%=rsAuths("longdesc")%></div></td>
            <td height=25 class="itemfont"><div></div></td>
            <td height=25 class="centeralign"><div><%=rsAuths("expiry")%></div></td>
            <td height=25 class="itemfont"><div><%=rsAuths("assessor")%></div></td>
            <td height=25 class="itemfont"><div><%=rsAuths("approver")%></div></td>
            <td height=25 class="centeralign"><div>&nbsp;</div></td>
            <td height=25 class="itemfont"><div>&nbsp;</div></td>
            <td height=25 class="itemfont"><div>&nbsp;</div></td>
        </tr>
        <%i = i + 1%>
        <%rsAuths.movenext%>
        <%loop%>
        <%while i <= 12 %>
         <tr>
            <td height=25 class="centeralign"><div><%=i%></div></td>
            <td height=25 class="itemfont"><div>&nbsp;</div></td>
            <td height=25 class="itemfont"><div>&nbsp;</div></td>
            <td height=25 class="itemfont"><div>&nbsp;</div></td>
            <td height=25 class="centeralign"><div>&nbsp;</div></td>
            <td height=25 class="itemfont"><div>&nbsp;</div></td>
            <td height=25 class="itemfont"><div>&nbsp;</div></td>
            <td height=25 class="centeralign"><div>&nbsp;</div></td>
            <td height=25 class="itemfont"><div>&nbsp;</div></td>
            <td height=25 class="itemfont"><div>&nbsp;</div></td>
        </tr>
        <%i = i + 1%>
        <%wend%>
    </tbody>
    <tfoot>
        <tr>	
            <td height=25 colspan="4" class="grayout">&nbsp;</td>
            <td height=25 class="itemfont" colspan="2">Service/Staff No</td>
            <td height=25 class="itemfont">Post</td>
            <td height=25 class="itemfont" colspan="2">Name</td>
            <td height=25 class="itemfont">Trade</td>
         </tr> 
         <tr>
            <td height=25 colspan="4" class="grayout">&nbsp;</td>
            <td height=25 colspan="2" class="itemfont"><%=strServiceNo%></td>
            <td height=25 class="itemfont"><%=strPost%></td>
            <td height=25 colspan="2" class="itemfont"><%=strName%></td>
            <td height=25 class="itemfont"><%=strTrade%></td>
          </tr>
    </tfoot>
</table>
</body>
</html>