<html xmlns:o="urn:schemas-microsoft-com:office:office"
xmlns:x="urn:schemas-microsoft-com:office:excel"
xmlns="http://www.w3.org/TR/REC-html40">

<!--#include file="Includes/Security.inc"-->
<!--#include file="Connection/Connection.inc"-->
<%
response.ContentType = "application/vnd.ms-excel"
response.addHeader "content-disposition","attachment;filename=newReport.xls"

inthrcID = request("cboHrc")
	
'response.write(inthrcID)
'response.end()
	
set objCmd = server.createobject("ADODB.Command")
set objPara = server.createobject("ADODB.Parameter")
objCmd.activeconnection = con
objCmd.commandtext = "spGetUnitMatrix"
objCmd.activeconnection.cursorlocation = 3
objCmd.commandtype = 4
	
' now add reporting parameters
set objPara = objCmd.createparameter ("@hrcID",3,1,0, cint(inthrcID))
objCmd.parameters.append objPara
set rsMatrix = objCmd.Execute	'Execute CommandText when using "ADODB.Command" object'

i = 0
if not rsMatrix.eof then
	do until rsMatrix("num") > 1
		i = i + 1
		rsMatrix.movenext
	loop
	i = i + 1
	rsMatrix.movefirst
end if
%>

<html>
<head>
<meta http-equiv=Content-Type content="text/html; charset=windows-1252">
<meta name=ProgId content=Excel.Sheet>
<meta name=Generator content="Microsoft Excel 11">

<style>
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
	font-size:9.0pt;
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
	font-size:9.0pt;
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
	font-size:12.0pt;
	font-weight:700;
	font-family:Arial, sans-serif;
	mso-font-charset:0;
	text-align:center;
	vertical-align:middle;
	white-space:normal;}
.xl66
	{mso-style-parent:style0;
	font-weight:700;
	font-family:Arial, sans-serif;
	mso-font-charset:0;
	vertical-align:middle;
	border:.5pt solid windowtext;
	white-space:normal;}
.xl67
	{mso-style-parent:style0;
	font-weight:700;
	font-family:Arial, sans-serif;
	mso-font-charset:0;
	text-align:center;
	vertical-align:middle;
	border-top:.5pt solid windowtext;
	border-right:.5pt solid windowtext;
	border-bottom:.5pt solid windowtext;
	border-left:none;
	white-space:normal;}
.xl68
	{mso-style-parent:style0;
	font-weight:700;
	font-family:Arial, sans-serif;
	mso-font-charset:0;
	vertical-align:middle;
	border-top:none;
	border-right:.5pt solid windowtext;
	border-bottom:.5pt solid windowtext;
	border-left:.5pt solid windowtext;
	white-space:normal;}
.xl69
	{mso-style-parent:style0;
	font-family:Arial, sans-serif;
	mso-font-charset:0;
	text-align:center;
	vertical-align:middle;
	border-top:none;
	border-right:.5pt solid windowtext;
	border-bottom:.5pt solid windowtext;
	border-left:.5pt solid windowtext;
	border-left:none;}
</style>

<!--[if gte mso 9]><xml>
 <x:ExcelWorkbook>
  <x:ExcelWorksheets>
   <x:ExcelWorksheet>
    <x:Name>Sheet1</x:Name>
    <x:WorksheetOptions>
     <x:Print>
      <x:ValidPrinterInfo/>
      <x:PaperSizeIndex>9</x:PaperSizeIndex>
     </x:Print>
     <x:FreezePanes/>
     <x:FrozenNoSplit/>
     <x:SplitHorizontal>3</x:SplitHorizontal>
     <x:TopRowBottomPane>3</x:TopRowBottomPane>
     <x:ActivePane>2</x:ActivePane>
    </x:WorksheetOptions>
   </x:ExcelWorksheet>
  </x:ExcelWorksheets>
 </x:ExcelWorkbook>
 <x:ExcelName>
  <x:Name>Print_Titles</x:Name>
  <x:SheetIndex>1</x:SheetIndex>
  <x:Formula>=Sheet1!$1:$4</x:Formula>
 </x:ExcelName>
</xml><![endif]-->

</head>
<body>
<table border=0 cellpadding=0 cellspacing=0 width=2090 style='border-collapse:collapse;table-layout:fixed;width:1577pt'>
	<col width=110 span=19 style='mso-width-source:userset;mso-width-alt:4022;width:83pt'>
	<tr height=20 style='height:15.0pt'>
        <td colspan="<%=i%>"  rowspan=2 height=40 class=xl65 width=2090 style='height:30.0pt;width:1577pt'>MATRIX OF STAFF AUTH LIMITS</td> 
	</tr>
	<tr height=20 style='height:15.0pt'></tr>
    <%i = 0%>
	<tr height=53 style='mso-height-source:userset;height:39.95pt'>
    	<td height=53 class=xl66 width=110 style='height:39.95pt;width:83pt'>MAP No</td>
     	<%do until rsMatrix("num") > 1%>
        	<td class=xl67 width=110 style='width:83pt'><%=RSmATRIX("rnk")%><br /><%=rsMatrix("staff")%><br /><%=rsMatrix("serviceno")%></td>
            <%i = i + 1%>
            <%rsMatrix.movenext%>
		<%loop%>
    </tr>
    <%rsMatrix.movefirst%>

    <%while not rsMatrix.eof%>
    	<%j = 1%>
    	<tr height=25 style='mso-height-source:userset;height:18.75pt'>
        	<td height=25 class=xl68 width=110 style='height:18.75pt;width:83pt'><%=rsMatrix("authCode")%></td>
            
            <%do until j > i%>
           		<td class=xl69><%if rsMatrix("haveAuth") = true then%>&#10004;<%end if%></td>
				<%j = j + 1%>
               	<%rsMatrix.movenext%>
            <%loop%>
		</tr>
        <%'rsMatrix.movenext%>
	<%wend%>
</table>

</body>
</html>
