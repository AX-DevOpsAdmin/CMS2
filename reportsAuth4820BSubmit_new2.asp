<!DOCTYPE HTML >

<!--#include file="Includes/security.inc"-->
<!--#include file="Connection/Connection.inc"-->

<%
	intStaffID = request("newattached")
	
	'response.write(intStaffID)
'	response.end()
	set objCmd = server.createobject("ADODB.Command")
	set objPara = server.createobject("ADODB.Parameter")
	objCmd.activeconnection = con
	objCmd.commandtext = "spGetIndividualAuths"
	objCmd.activeconnection.cursorlocation = 3
	objCmd.commandtype = 4
	
	'set objCmd = server.createobject("ADODB.Command")
'	set objPara = server.createobject("ADODB.Parameter")
'	objCmd.activeconnection = con
'	objCmd.commandtext = "spGetAuthList"
'	objCmd.activeconnection.cursorlocation = 3
'	objCmd.commandtype = 4
	

	'set objPara = objCmd.Createparameter ("@authID",3,1,0, cint(authID))
'	objCmd.Parameters.Append objPara
'	set rsRecSet = objCmd.execute
'	
'	set objPara = objCmd.createparameter ("@nodeID",3,1,0, cint(intnodeID))
'	objCmd.parameters.append objPara
'	set rsRecSet = objCmd.execute
	
	set objPara = objCmd.createparameter ("@staffID",3,1,0, cint(intStaffID))
	objCmd.parameters.append objPara
	set rsAuths = objCmd.execute
	
	
	
	
	' now add reporting parameters
	'set objPara = objCmd.createparameter ("@staffID",3,1,0, cint(intStaffID))
	'objCmd.parameters.append objPara
	'set rsAuths = objCmd.execute	'Execute CommandText when using "ADODB.Command" object'
	
	strServiceNo = rsAuths("serviceno")
	strPost = rsAuths("post")
	if isnull(rsAuths("firstname")) or rsAuths("firstname") <> "" then
	   strName = rsAuths("surname") & ", " & rsAuths("firstname")
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
        <td width="10%"><b>CAE 4000 - MAP-01</b></td>
	</tr>
    <tr>
        <td width="20%">&nbsp;</td>
        <td><h3><center>RECORD OF ENGINEERING AUTHORISATIONS</center></h3></td> 
        <td width="10%">&nbsp;</td>
	</tr>
    <tr>
        <td width="20%">&nbsp;</td>
        <td>&nbsp;</td> 
        <td width="10%">&nbsp;</td>
	</tr>
    <tr>
		<td colspan="3">&nbsp;</td>
	</tr>
</table>

<table id="RAF4820B" border="1" cellpadding="0" cellspacing="0" width="90%">
    <thead>
        <tr>
            <td class="centeralign" colspan="2">Rank/Grade</td>
            <td class="centeralign" colspan="2">Name</td>
            <td class="centeralign" colspan="2">Service/Staff No</td>
            <td class="centeralign" colspan="3">Post</td>
            <td class="centeralign" colspan="3">Stn/Ship/Unit</td>
        </tr>
        <tr>
            <td height=25 class="itemfont" colspan="2"><%=rsAuths("rank")%></td>
            <td height=25 class="itemfont" colspan="2"><div><%=strName%></div></td>
            <td height=25 class="itemfont" colspan="2"><div><%=strServiceNo%></div></td>
            <td height=25 class="itemfont" colspan="3"><div><%=strPost%></div></td>
            <td height=25 class="itemfont" colspan="3"><div><%=strTrade%></div></td>
        </tr>
        <tr>
        	<td colspan="11">&nbsp;</td>
        </tr>
        <tr>
            <td class="centeralign" width="5%">Line No</td>	
            <td class="centeralign" width="6%">Comp ID</td>
            <td class="centeralign" colspan="2" width="31.5%">Task Requiring Authorisation</td>
            <td class="centeralign" colspan="2" width="31.5%">Additional Authorisation Criteria</td>
            <td class="centeralign" width="5%">Source Chapter</td>
            <td class="centeralign" width="5%">Auth By</td>
            <td class="centeralign" width="5%">St/Sp</td>
            <td class="centeralign" width="5%">Lim Ref</td>
            <td class="centeralign" colspan="2" width="6%">Approve ID</td>
        </tr>
    </thead>
    <tbody>
        <%i = 1%>	
        <%do while Not rsAuths.eof%>
        <tr>
            <td height=25 class="centeralign"><div><%=i%></div></td>
            <td height=25 class="itemfont"><div><%=rsAuths("description")%></div></td>
            <td height=25 class="itemfont" colspan="2"><div><%=rsAuths("longdesc")%></div></td>
            <td height=25 class="itemfont" colspan="2"><div><%=rsAuths("authReqs")%></div></td>
            <td height=25 class="centeralign"><div><%=rsAuths("authRef")%></div></td>
            <td height=25 class="centeralign"><div><%=rsAuths("authclass")%></div></td>
            <td height=25 class="itemfont"><div>&nbsp;</div></td>
            <td height=25 class="centeralign"><div><%=i%></div></td>
            <td height=25 class="itemfont"colspan="2"><div><%=rsAuths("parent")%></div></td>
        </tr>
        <%i = i + 1%>
        <%rsAuths.movenext%>
        <%loop%>
        <%while i <= 12 %>
         <tr>
            <td height=25 class="centeralign"><div><%=i%></div></td>
            <td height=25 class="itemfont"><div>&nbsp;</div></td>
            <td height=25 class="itemfont" colspan="2"><div>&nbsp;</div></td>
            <td height=25 class="itemfont" colspan="2"><div>&nbsp;</div></td>
            <td height=25 class="centeralign"><div>&nbsp;</div></td>
            <td height=25 class="itemfont"><div>&nbsp;</div></td>
            <td height=25 class="itemfont"><div>&nbsp;</div></td>
            <td height=25 class="centeralign"><div>&nbsp;</div></td>
            <td height=25 class="itemfont"><div>&nbsp;</div></td>
       </tr>
        <%i = i + 1%>
        <%wend%>
        <tr>
            <td colspan="11">&nbsp;</td>
         </tr>
         <%i = 1%>	
         <%rsAuths.movefirst%>
         <tr>
            <td class="centeralign" colspan="2">Lim Ref</td>	
            <td class="centeralign" colspan="4">Limitation</td>
            <td class="centeralign" colspan="3">From</td>
            <td class="centeralign" colspan="3">To</td>
         </tr>
        <%do while Not rsAuths.eof%>
         <tr>
            <td height=25 class="centeralign"colspan="2"><div><%=i%></div></td>
            <td height=25 class="leftalign"colspan="4"><div><%=rsAuths("notes")%></div></td>
            <td height=25 class="centeralign"colspan="3"><div><%=rsAuths("startdate")%></div></td>
            <td height=25 class="centeralign"colspan="3"><div><%=rsAuths("enddate")%></div></td>
         </tr>
         <%i = i + 1%>
        <%rsAuths.movenext%>
        <%loop%>
        <%'while i <= 12 %>
        <tr>
            <td colspan="11">&nbsp;</td>
          </tr>
          
          <tr>
            <td class="centeralign" colspan="2">Declaration</td>	
            <td class="centeralign" colspan="2">Rank</td>
            <td class="centeralign" colspan="2">Name</td>
            <td class="centeralign" colspan="2">Post Title</td>
            <td class="centeralign"	colspan="2">Signature</td>
            <td class="centeralign"	colspan="2">Date</td>
          </tr>
          <tr>
          	<td height=25 class="itemfont" colspan="2">&nbsp;</td>
          	<td height=25 class="itemfont" colspan="2">&nbsp;</td>
            <td height=55 class="itemfont" colspan="2"><div><%=strName%></div></td>
            <td height=55 class="itemfont" colspan="2"><div><%=strPost%></div></td>
            <td height=25 class="itemfont" colspan="2">&nbsp;</td>
            <td height=25 class="itemfont" colspan="2"><%=Date%></td>
          <tr>
          	<td class="centeralign" colspan="6" rowspan="2">
            	I certify that I have read the MAP-01 Chapters relating to the task(s)
            	listed above and understand the responsibilities associated with them and the implications of using my specimen signature/initials
            	given opposite on maintenance documentation.
            </td>
            <td class="centeralign" colspan="2">Rank/Rate</td> 
            <td class="centeralign" colspan="2">Initial</td>
            <td class="centeralign" colspan="2">Ser/Staff No</td>
          </tr>
          <tr>
          	<!--<td height=25 class="itemfont" colspan="7">&nbsp;</td>-->
            <td height=55 class="itemfont" colspan="2"><div><%=strName%></div></td>
            <td height=55 class="itemfont" colspan="2">&nbsp;</td>
            <td height=55 class="itemfont" colspan="2"><div><%=strServiceNo%></div></td>
    </tbody>
</table>
</body>
</html>
