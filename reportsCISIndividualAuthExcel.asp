<!DOCTYPE HTML >

<!--#include file="Includes/security.inc"-->
<!--#include file="Connection/Connection.inc"-->

<%
	response.ContentType = "application/vnd.ms-excel"
	response.addHeader "content-disposition","attachment;filename=newReport.xls"
	
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
%>

<html>
<head>

<!--#include file="Includes/IECompatability.inc"-->


<title>Custom Report</title>
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

tr
	{mso-height-source:auto;}
col
	{mso-width-source:auto;}
br
	{mso-data-placement:same-cell;}
.style0
	{mso-number-format:General;
	text-align:general;
	vertical-align:bottom;
	white-space:nowrap;
	mso-rotate:0;
	mso-background-source:auto;
	mso-pattern:auto;
	color:black;
	font-size:11.0pt;
	font-weight:400;
	font-style:normal;
	text-decoration:none;
	font-family:Calibri, sans-serif;
	mso-font-charset:0;
	border:none;
	mso-protection:locked visible;
	mso-style-name:Normal;
	mso-style-id:0;}
td
	{mso-style-parent:style0;
	padding-top:1px;
	padding-right:1px;
	padding-left:1px;
	mso-ignore:padding;
	color:black;
	font-size:11.0pt;
	font-weight:400;
	font-style:normal;
	text-decoration:none;
	font-family:Calibri, sans-serif;
	mso-font-charset:0;
	mso-number-format:General;
	text-align:general;
	vertical-align:bottom;
	border:none;
	mso-background-source:auto;
	mso-pattern:auto;
	mso-protection:locked visible;
	white-space:nowrap;
	mso-rotate:0;}
.xl65
	{mso-style-parent:style0;
	font-weight:700;
	border-top:none;
	border-right:.5pt solid windowtext;
	border-bottom:.5pt solid windowtext;
	border-left:none;
	white-space:normal;}
.xl66
	{mso-style-parent:style0;
	mso-number-format:"\@";
	border-top:none;
	border-right:.5pt solid windowtext;
	border-bottom:.5pt solid windowtext;
	border-left:.5pt solid windowtext;
	white-space:normal;}
.xl67
	{mso-style-parent:style0;
	border-top:none;
	mso-number-format:"\@";
	border-right:.5pt solid windowtext;
	border-bottom:.5pt solid windowtext;
	border-left:none;
	white-space:normal;}
.xl68
	{mso-style-parent:style0;
	text-decoration:underline;
	text-underline-style:single;
	text-align:center;}
.xl69
	{mso-style-parent:style0;
	border-top:none;
	border-right:none;
	border-bottom:.5pt solid windowtext;
	border-left:none;}
.xl70
	{mso-style-parent:style0;
	font-weight:700;
	mso-number-format:"\@";
	vertical-align:121;
	border-top:.5pt solid windowtext;
	border-right:.5pt solid windowtext;
	border-bottom:none;
	border-left:.5pt solid windowtext;}
.xl71
	{mso-style-parent:style0;
	font-weight:700;
	mso-number-format:"\@";
	vertical-align:121;
	border-top:none;
	border-right:.5pt solid windowtext;
	border-bottom:.5pt solid black;
	border-left:.5pt solid windowtext;}
.xl72
	{mso-style-parent:style0;
	font-weight:700;
	vertical-align:121;
	border-top:.5pt solid windowtext;
	border-right:.5pt solid windowtext;
	border-bottom:none;
	border-left:.5pt solid windowtext;}
.xl73
	{mso-style-parent:style0;
	font-weight:700;
	vertical-align:121;
	border-top:none;
	border-right:.5pt solid windowtext;
	border-bottom:.5pt solid black;
	border-left:.5pt solid windowtext;}
.xl74
	{mso-style-parent:style0;
	font-weight:700;
	text-align:center;
	border-top:.5pt solid windowtext;
	border-right:none;
	border-bottom:.5pt solid windowtext;
	border-left:.5pt solid windowtext;
	white-space:normal;}
.xl75
	{mso-style-parent:style0;
	font-weight:700;
	text-align:center;
	border-top:.5pt solid windowtext;
	border-right:.5pt solid windowtext;
	border-bottom:.5pt solid windowtext;
	border-left:none;
	white-space:normal;}
.xl76
	{mso-style-parent:style0;
	border-top:.5pt solid windowtext;
	border-right:none;
	border-bottom:none;
	border-left:.5pt solid windowtext;}
.xl77
	{mso-style-parent:style0;
	border-top:.5pt solid windowtext;
	border-right:.5pt solid windowtext;
	border-bottom:none;
	border-left:none;}
.xl78
	{mso-style-parent:style0;
	border-top:none;
	border-right:none;
	border-bottom:none;
	border-left:.5pt solid windowtext;}
.xl79
	{mso-style-parent:style0;
	border-top:none;
	border-right:.5pt solid windowtext;
	border-bottom:none;
	border-left:none;}
.xl80
	{mso-style-parent:style0;
	border-top:none;
	border-right:none;
	border-bottom:.5pt solid windowtext;
	border-left:.5pt solid windowtext;}
.xl81
	{mso-style-parent:style0;
	border-top:none;
	border-right:.5pt solid windowtext;
	border-bottom:.5pt solid windowtext;
	border-left:none;}
.xl82
	{mso-style-parent:style0;
	border-top:.5pt solid windowtext;
	border-right:.5pt solid windowtext;
	border-bottom:none;
	border-left:.5pt solid windowtext;}
.xl83
	{mso-style-parent:style0;
	border-top:none;
	border-right:.5pt solid windowtext;
	border-bottom:none;
	border-left:.5pt solid windowtext;}
.xl84
	{mso-style-parent:style0;
	border-top:none;
	border-right:.5pt solid windowtext;
	border-bottom:.5pt solid windowtext;
	border-left:.5pt solid windowtext;}
.xl85
	{mso-style-parent:style0;
	vertical-align:top;
	border-top:.5pt solid windowtext;
	border-right:none;
	border-bottom:none;
	border-left:.5pt solid windowtext;
	white-space:normal;}
.xl86
	{mso-style-parent:style0;
	vertical-align:top;
	border-top:.5pt solid windowtext;
	border-right:none;
	border-bottom:none;
	border-left:none;
	white-space:normal;}
.xl87
	{mso-style-parent:style0;
	vertical-align:top;
	border-top:.5pt solid windowtext;
	border-right:.5pt solid windowtext;
	border-bottom:none;
	border-left:none;
	white-space:normal;}
.xl88
	{mso-style-parent:style0;
	vertical-align:top;
	border-top:none;
	border-right:none;
	border-bottom:none;
	border-left:.5pt solid windowtext;
	white-space:normal;}
.xl89
	{mso-style-parent:style0;
	vertical-align:top;
	white-space:normal;}
.xl90
	{mso-style-parent:style0;
	vertical-align:top;
	border-top:none;
	border-right:.5pt solid windowtext;
	border-bottom:none;
	border-left:none;
	white-space:normal;}
.xl91
	{mso-style-parent:style0;
	vertical-align:top;
	border-top:none;
	border-right:none;
	border-bottom:.5pt solid windowtext;
	border-left:.5pt solid windowtext;
	white-space:normal;}
.xl92
	{mso-style-parent:style0;
	vertical-align:top;
	border-top:none;
	border-right:none;
	border-bottom:.5pt solid windowtext;
	border-left:none;
	white-space:normal;}
.xl93
	{mso-style-parent:style0;
	vertical-align:top;
	border-top:none;
	border-right:.5pt solid windowtext;
	border-bottom:.5pt solid windowtext;
	border-left:none;
	white-space:normal;}
.xl94
	{mso-style-parent:style0;
	font-weight:700;
	border-top:.5pt solid windowtext;
	border-right:none;
	border-bottom:.5pt solid windowtext;
	border-left:.5pt solid windowtext;}
.xl95
	{mso-style-parent:style0;
	border-top:.5pt solid windowtext;
	border-right:none;
	border-bottom:.5pt solid windowtext;
	border-left:none;}
.xl96
	{mso-style-parent:style0;
	border-top:.5pt solid windowtext;
	border-right:.5pt solid windowtext;
	border-bottom:.5pt solid windowtext;
	border-left:none;}
.xl97
	{mso-style-parent:style0;
	font-weight:700;
	border:.5pt solid windowtext;}
-->
</style>

</head>
<body>
<table border=0 cellpadding=0 cellspacing=0 width=1385 style='border-collapse:collapse;table-layout:fixed;width:1041pt'>
    <col width=77 style='mso-width-source:userset;mso-width-alt:2816;width:58pt'>
    <col width=90 style='mso-width-source:userset;mso-width-alt:3291;width:68pt'>
    <col width=242 style='mso-width-source:userset;mso-width-alt:8850;width:182pt'>
    <col width=69 style='mso-width-source:userset;mso-width-alt:2523;width:52pt'>
    <col width=99 style='mso-width-source:userset;mso-width-alt:3620;width:74pt'>
    <col width=183 style='mso-width-source:userset;mso-width-alt:6692;width:137pt'>
    <col width=106 style='mso-width-source:userset;mso-width-alt:3876;width:80pt'>
    <col width=139 style='mso-width-source:userset;mso-width-alt:5083;width:104pt'>
    <col width=258 style='mso-width-source:userset;mso-width-alt:9435;width:194pt'>
    <col width=122 style='mso-width-source:userset;mso-width-alt:4461;width:92pt'>
	<tr height=20 style='height:15.0pt'>
		<td colspan=11 height=20 width=1385 style='height:15.0pt;width:1041pt'>Ref: AP600 Chapter 3.9</td>
	</tr>
	<tr height=20 style='height:15.0pt'>
		<td colspan=11 height=20 style='height:15.0pt'></td>
	</tr>
	<tr height=20 style='height:15.0pt'>
		<td colspan=11 height=20 class="xl68" style='height:15.0pt'> Record of Authorisations</td>
	</tr>
	<tr height=20 style='height:15.0pt'>
		<td colspan=11 height=20 class=xl69 style='height:15.0pt'>&nbsp;</td>
	</tr>
	<tr height=20 style='height:15.0pt'>
		<td rowspan=2 height=40 class=xl70 style='border-bottom:.5pt solid black;height:30.0pt;border-top:none'>JPA No</td>
		<td rowspan=2 class=xl72 style='border-bottom:.5pt solid black;border-top:none'>Service No</td>
		<td rowspan=2 class=xl72 style='border-bottom:.5pt solid black;border-top:none'>Name</td>
		<td rowspan=2 class=xl72 style='border-bottom:.5pt solid black;border-top:none'>Wing</td>
		<td rowspan=2 class=xl72 style='border-bottom:.5pt solid black;border-top:none'>Squadron</td>
		<td rowspan=2 class=xl72 style='border-bottom:.5pt solid black;border-top:none'>Post</td>
		<td rowspan=2 class=xl72 style='border-bottom:.5pt solid black;border-top:none'>Exp Date</td>
		<td colspan=2 class=xl74 width=397 style='border-right:.5pt solid black;border-left:none;width:298pt'>Exempted / Granted Auth</td>
		<td rowspan=2 class=xl72 style='border-bottom:.5pt solid black;border-top:none'>Assessor</td>
        <td rowspan=2 class=xl72 style='border-bottom:.5pt solid black;border-top:none'>Approver</td>
	</tr>
	<tr height=20 style='height:15.0pt'>
		<td height=20 class=xl65 width=139 style='height:15.0pt;width:104pt'>Auth Code</td>
		<td class=xl65 width=258 style='width:194pt'>Description</td>
	</tr>
	<% intCount = 1 %>
    <% if not rsCISAuth.eof then %>
        <% do while not rsCISAuth.eof %>
            <% if isnull(rsCISAuth("firstname")) or rsCISAuth("firstname") <> "" then %>
                <% strName = rsCISAuth("rank") & " " & rsCISAuth("surname") & ", " & rsCISAuth("firstname") %>
            <% else %>
                <% strName = rsCISAuth("rank") & " " & rsCISAuth("surname") %>
            <% end if %>
            <tr height=20 style='height:15.0pt'>
                <td height=20 class=xl66 width=77 style='height:15.0pt;width:58pt'><% if intCount = 1 then %><%=rsCISAuth("assignno")%><% end if %></td>
				<td class=xl67 width=90 style='width:68pt'><% if intCount = 1 then %><%=rsCISAuth("serviceno")%><% end if %></td>
                <td class=xl67 width=242 style='width:182pt'><% if intCount = 1 then %><%=strName%><% end if %></td>
                <td class=xl67 width=69 style='width:52pt'><% if intCount = 1 then %><%=rsCISAuth("wg")%><% end if %></td>
                <td class=xl67 width=99 style='width:74pt'><% if intCount = 1 then %><%=rsCISAuth("sqn")%><% end if %></td>
                <td class=xl67 width=183 style='width:137pt'><% if intCount = 1 then %><%=rsCISAuth("post")%><% end if %></td>
                <td class=xl67 width=106 style='width:80pt'><%= rsCISAuth("expiry") %></td>
                <td class=xl67 width=139 style='width:104pt'><%=rsCISAuth("description")%></td>
                <td class=xl67 width=258 style='width:194pt'><%=rsCISAuth("longdesc")%></td>
                <td class=xl67 width=122 style='width:92pt'><%=rsCISAuth("assessor")%></td>
                 <td class=xl67 width=122 style='width:92pt'><%=rsCISAuth("assessor")%></td>
            </tr>
            <% intCount = intCount + 1 %>
            <% rsCISAuth.movenext %>
        <% loop %>
    <% end if %>
    <% if intCount < 10 then %>
        <% for i = intCount to 10 %>
            <tr height=20 style='height:15.0pt'>
                <td height=20 class=xl66 width=77 style='height:15.0pt;width:58pt'>&nbsp;</td>
				<td class=xl67 width=90 style='width:68pt'>&nbsp;</td>
                <td class=xl67 width=242 style='width:182pt'>&nbsp;</td>
                <td class=xl67 width=69 style='width:52pt'>&nbsp;</td>
                <td class=xl67 width=99 style='width:74pt'>&nbsp;</td>
                <td class=xl67 width=183 style='width:137pt'>&nbsp;</td>
                <td class=xl67 width=106 style='width:80pt'>&nbsp;</td>
                <td class=xl67 width=139 style='width:104pt'>&nbsp;</td>
                <td class=xl67 width=258 style='width:194pt'>&nbsp;</td>
                <td class=xl67 width=122 style='width:92pt'>&nbsp;</td>
                <td class=xl67 width=122 style='width:92pt'>&nbsp;</td>
            </tr>
        <% next %>
    <% end if %>
    <!--
    <tr height=20 style='height:15.0pt'>
    	<td height=20 colspan=10 style='height:15.0pt;mso-ignore:colspan'></td>
    </tr>
    <tr height=20 style='height:15.0pt'>
    	<td colspan=3 height=20 class=xl94 style='border-right:.5pt solid black;height:15.0pt'>Authorisation:</td>
		<td></td>
		<td class=xl97>Rank:</td>
		<td colspan=2 class=xl94 style='border-right:.5pt solid black'>Name:</td>
		<td colspan=2 class=xl94 style='border-right:.5pt solid black;border-left:none'>Signature:</td>
		<td class=xl97>Date:</td>
    </tr>
    <tr height=20 style='height:15.0pt'>
    	<td height=20 colspan=10 style='height:15.0pt;mso-ignore:colspan'></td>
    </tr>
    <tr height=20 style='height:15.0pt'>
    	<td colspan=3 rowspan=4 height=80 class=xl85 width=409 style='border-right:.5pt solid black;border-bottom:.5pt solid black;height:60.0pt;width:308pt'>
        	I authorise the personnel detailed on this record to carry out the above
			task(s) and sign the necessary documentation.
		</td>
		<td></td>
		<td rowspan=4 class=xl82 style='border-bottom:.5pt solid black'>&nbsp;</td>
		<td colspan=2 rowspan=4 class=xl76 style='border-right:.5pt solid black;border-bottom:.5pt solid black'>&nbsp;</td>
		<td colspan=2 rowspan=4 class=xl76 style='border-right:.5pt solid black;border-bottom:.5pt solid black'>&nbsp;</td>
		<td rowspan=4 class=xl82 style='border-bottom:.5pt solid black'>&nbsp;</td>
    </tr>
    <tr height=20 style='height:15.0pt'>
		<td height=20 style='height:15.0pt'></td>
    </tr>
    <tr height=20 style='height:15.0pt'>
		<td height=20 style='height:15.0pt'></td>
    </tr>
    <tr height=20 style='height:15.0pt'>
		<td height=20 style='height:15.0pt'></td>
    </tr>
    <tr height=20 style='height:15.0pt'>
		<td height=20 colspan=10 style='height:15.0pt;mso-ignore:colspan'></td>
    </tr>
    -->
    <tr height=20 style='height:15.0pt'>
		<td colspan=8 rowspan=4 height=80 class=xl85 width=409  style='border-right:.5pt solid black;border-bottom:.5pt solid black;height:60.0pt;width:308pt;'>
        	I certify that I have read the AP600 Chapters relating to the tasks listed
			above and understand the responsibilities associated with them and the
			implications of using my signature/initials on maintenance documentation.
		</td>
		<!--<td></td>
		<td rowspan=4 class=xl82 style='border-bottom:.5pt solid black'>&nbsp;</td>
		<td colspan=2 rowspan=4 class=xl76 style='border-right:.5pt solid black;border-bottom:.5pt solid black'>&nbsp;</td>-->
		<td colspan=3 rowspan=4 class=xl76 style='border-right:.5pt solid black;border-bottom:.5pt solid black'>&nbsp;</td>
		<!--<td rowspan=4 class=xl82 style='border-bottom:.5pt solid black'>&nbsp;</td>-->
    </tr>
    <!--
    <tr height=20 style='height:15.0pt'>
		<td height=20 style='height:15.0pt'></td>
    </tr>
    <tr height=20 style='height:15.0pt'>
		<td height=20 style='height:15.0pt'></td>
    </tr>
    <tr height=20 style='height:15.0pt'>
		<td height=20 style='height:15.0pt'></td>
    </tr>
   
    <![if supportMisalignedColumns]>
    <tr height=0 style='display:none'>
    <td width=77 style='width:58pt'></td>
    <td width=90 style='width:68pt'></td>
    <td width=242 style='width:182pt'></td>
    <td width=69 style='width:52pt'></td>
    <td width=99 style='width:74pt'></td>
    <td width=183 style='width:137pt'></td>
    <td width=106 style='width:80pt'></td>
    <td width=139 style='width:104pt'></td>
    <td width=258 style='width:194pt'></td>
    <td width=122 style='width:92pt'></td>
     <td width=122 style='width:92pt'></td>
    </tr>
    <![endif]>
     -->
</table>
</body>
</html>