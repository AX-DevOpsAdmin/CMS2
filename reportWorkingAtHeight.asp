
<!--#include file="Connection/Connection.inc"-->
<!--#include file  ="includes/adovbs.inc" -->
<%


response.ContentType = "application/vnd.ms-word"
response.AddHeader "content-disposition", "attachment; filename=RecordOfCompetanceWorkingAtHeights.doc"

servNo = request("servNo")

set objCmd = server.CreateObject("ADODB.Command")
objCmd.ActiveConnection = con
objCmd.ActiveConnection.cursorlocation = 3
objCmd.CommandType = AdCmdStoredProc
objCmd.Parameters.Append objCmd.CreateParameter("@servNo",adVarchar,adParamInput,15, servNo)
objCmd.CommandText = "spGetAEReport"
set rs = objCmd.Execute

mesCol = "red"
mesDesc = "No MES"

if isNull(rs("mesDesc")) = false then
	mesDesc = rs("mesDesc")
end if
if isNull(rs("mesID")) = false then
	if rs("mesID") = 2 or rs("mesID") = 3 then
		mesCol = "green"
	end if
end if

dim shortMonth(11)
shortMonth(0)= "January"
shortMonth(1)= "February"
shortMonth(2)= "March" 
shortMonth(3)= "April"
shortMonth(4)= "May" 
shortMonth(5)= "June" 
shortMonth(6)= "July"
shortMonth(7)= "August"
shortMonth(8)= "September"
shortMonth(9)= "October" 
shortMonth(10)= "November"
shortMonth(11)= "December"

theDate = datepart("d", date() ) &" "&shortMonth(datepart("m", date() ))&" "& datepart("yyyy", date() )

' http://web.apps.royalnavy.r.mil.uk/Air_90SUCMS/Asps/getPhoto.asp

%>
<html xmlns:v="urn:schemas-microsoft-com:vml"
xmlns:o="urn:schemas-microsoft-com:office:office"
xmlns:w="urn:schemas-microsoft-com:office:word"
xmlns:st1="urn:schemas-microsoft-com:office:smarttags"
xmlns="http://www.w3.org/TR/REC-html40">
<head>
<title> </title>
<!--[if gte mso 9]><xml>
 <w:WordDocument>
  <w:View>Print</w:View>
  <w:Zoom>90</w:Zoom>
 </w:WordDocument>
</xml><![endif]-->
<style>
/* Page Definitions */
@page Section1
	{margin:1.0cm 2.0cm 1.0cm 2.0cm;
	mso-footer: f1;}
	
p.MsoFooter, li.MsoFooter, div.MsoFooter
	{mso-style-priority:99;
	mso-style-link:"Footer Char";
	margin:0cm;
	margin-bottom:.0001pt;
	mso-pagination:widow-orphan;
	tab-stops:center 225.65pt right 451.3pt;
	font-size:12.0pt;
	font-family:"Times New Roman","serif";
	mso-fareast-font-family:"Times New Roman";
	mso-fareast-theme-font:minor-fareast;}
	
div.Section1
	{page:Section1;}
 .xl24
     {text-align:center; mso-rotate:45;}
	 h2{text-align:center}
	 img{text-align:center}
</style>
</head>
<body>
<div class=Section1> 


<%if rs.eof then %>
<p style='color:red;'>There is no information for this person</b></p>
<%else%>
<h2>Royal Air Force<br>Record of Competence<br>Working at Heights</h2>

<table width=650 >
    <tr>
        <td colspan="4" align="center" style="vertical-align:top;"><img width=150 height=210 src="http://ixtrsvrdev/Air_90SUCMS/Asps/getPhoto.asp?staffID=<%=rs("staffID")%>"></td>
    </tr>
    <tr><td height="20" colspan="4"><hr></td></tr>
    <tr>
        <td><b>Service No:</b></td>
        <td><%=rs("serviceno")%></td>
        <td><b>Rank:</b></td>
        <td><%=rs("shortDesc")%></td>
    </tr>
    <tr>
        <td><b>First Name:</b></td>
        <td><%=rs("firstname")%></td>
        <td><b>Surname:</b></td>
        <td><%=rs("surname")%></td>
    </tr>
    <tr><td height="20" colspan="4"><hr></td></tr>
</table>

<%
set rs = rs.nextRecordSet
if not rs.EOF then
rs.moveFirst
%>

<table width=650>
    <tr>
        <td colspan="2"></td>
        <th>Valid From</th>
        <th>Valid To</th>
        <th>Status</th>
    </tr>
    <%qNameArr = split("Rescue Procedures,Rescue Procedures Trainer,CCS 12 Month (First Aid),Rescue Procedures,RAF Fitness Test",",")
	theType = ""
	while not(rs.EOF)%>
    <%
	if rs("theType") <> theType then%>
    
		<%if rs("theType") = "A" then%>
        <tr>
            <th colspan="5" align="left"><b>General Qualification</b></th>
        </tr>
        <%elseif rs("theType") = "B" then %>
        <tr>
            <th colspan="5" align="left"><b>Military Skills</b></th>
        </tr>
        <%elseif rs("theType") = "C" then %>
        <tr>
            <th colspan="5" align="left"><b>Fitness</b></th>
        </tr>
        <%end if%>
    
    <%end if%>
    
    <tr>
	<%theType = rs("theType")%>
	<%if theType = "A" and rs("ID") = "334" then 
        theDesc = "Rescue Procedures"
        subDesc = rs("Desc")
    elseif theType = "A" and rs("ID") = "335" then
        theDesc = "Rescue Procedures Trainer"
        subDesc = rs("Desc")
    else
        theDesc = rs("Desc")
        subDesc = ""
    end if
    %>
    	<td>&nbsp;<%=theDesc%></td>
    	<%
		rsID = rs("ID")
		col = "green"

		validTo = DateAdd("d", cint(rs("vpdays")),rs("ValidFrom"))
		redDiff = datediff("d", formatDateTime(now(),2), validTo)
		
		amberDate = DateAdd("d", cint(rs("vpdays")),rs("ValidFrom")-rs("Amber"))
		ambDiff = datediff("d", formatDateTime(now(),2), amberDate)
		
		if ambDiff < 0 then
			col = "orange"
		end if
		if redDiff < 0 then
			col = "red"
		end if
		
		%>
        <td><%=subDesc%></td>
        <td><%=rs("ValidFrom")%></td>
        <td><%=validTo%></td>
        <td style="background-color:<%=col%>; border-bottom:#FFF;"></td> 
    </tr>
    <%
	rs.movenext
	wend%>

    <tr>
        <th colspan="5" align="left"><b>Medical</b></th>
    </tr>
    <tr>
    	<td>&nbsp;<%=mesDesc%></td>
        <td colspan="3"></td>
        <td style="background-color:<%=mesCol%>;"> </td>
    </tr>
</table>

<div align="left" style="color:#666; margin-top:290;">This is not a replacement for the climbers log book but it shows that climbers are in date with their competencies.</div>
<div align="right" style="color:#666;"><%=formatDateTime(date(), 1)%></div>
<%else%>
There are no Qualification records for this Staff Member.
<%end if%>
<!--<div style='mso-element:footer; margin-left:-900;' id="f1">
    <p style='tab-stops:right 481.65pt;'>
    <div align="left">This is not a replacement for the climbers log book but it shows that climbers are in date with their competencies.</div>
    <br>
   	<%'=formatDateTime(date(), 1)%>
    
    </p>
</div>-->

<%end if%>