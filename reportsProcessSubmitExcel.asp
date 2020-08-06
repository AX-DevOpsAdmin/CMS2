
<!--#include file="Includes/Security.inc"-->
<!--#include file="Connection/Connection.inc"-->
<%
response.ContentType = "application/vnd.ms-excel"
response.addHeader "content-disposition","attachment;filename=newReport.xls"
dim category (8) 
category (1) = "Qualification"
category (2) = "Qualification"
category (3) = "Qualification"
category (4) = "Qualification"
category (5) = "Military Skill"
category (6) = "Vaccination Type"
category (7) = "Fitness Type"
category (8) = "Dental Type"

dim whereClause

recordID =0
QType=0
if request("whereClause")="" then whereClause=""
if request("QStatus") ="1" then
	Qstatus=0
	whereClause = whereclause & " and ("
	if request ("generalQ")<>"" then
		QType=1
		recordID = int(request ("generalQ"))
		Qstatus=1
		if request("withWithout")=1 then
			whereClause = whereclause & "(generalQ.qID in (" & request ("generalQ") & ") ) "  
		else
			whereClause = whereclause & " not exists (select Qid from (select * from dbo.tblStaffQs where typeid=1) as generalQ where generalQ.staffID = dbo.tblStaff.staffID and qid = " & request ("generalQ") & ") "  
		end if
	end if
	if request ("technicalQ")<>"" then
		QType=2
		recordID = int(request ("technicalQ"))
		if Qstatus=1 then whereClause = whereclause & " and "
		Qstatus=1
		if request("withWithout")=1 then
			whereClause = whereclause & " (technicalQ.qID in (" & request ("technicalQ") & ") )  "  
		else
			whereClause = whereclause & " not exists (select Qid from (select * from dbo.tblStaffQs where typeid=2) as generalQ where generalQ.staffID = dbo.tblStaff.staffID and qid = " & request ("technicalQ") & ") "  
		end if
	end if
	if request ("operationalQ")<>"" then
		recordID = int(request ("operationalQ"))
		QType=3
		if Qstatus=1 then whereClause = whereclause & " and "
		Qstatus=1
		if request("withWithout")=1 then
			whereClause = whereclause &  "  (operationalQ.qID in (" & request ("operationalQ") & ") ) "  
		else
			whereClause = whereclause & " not exists (select Qid from (select * from dbo.tblStaffQs where typeid=3) as generalQ where generalQ.staffID = dbo.tblStaff.staffID and qid = " & request ("operationalQ") & ") "  
		end if
	end if
	if request ("driverQ")<>"" then
		recordID = int(request ("driverQ"))
		QType=4
		if Qstatus=1 then whereClause = whereclause & " and "
		Qstatus=1
		if request("withWithout")=1 then
			whereClause = whereclause &  "  (driverQ.qID in (" & request ("driverQ") & ") ) "  
		else
			whereClause = whereclause & " not exists (select Qid from (select * from dbo.tblStaffQs where typeid=4) as generalQ where generalQ.staffID = dbo.tblStaff.staffID and qid = " & request ("driverQ") & ") "  
		end if
	end if
	whereClause = whereclause & ")"
	if Qstatus=0 then whereClause =""
end if

if request("MSStatus") ="1" then
	if request ("milskill") <>"" then
		QType=5
		recordID = int(request ("milskill"))
		if request("withWithout")=1 then
			whereClause = whereclause & " and MSID in (" & request ("milskill") & ")"
		else
			whereClause = whereclause & " and not exists (select MSid from tblStaffMilSkill where tblStaffMilSkill.staffID = dbo.tblStaff.staffID and msid = " & request ("milskill") & ") "  
		end if
	end if
end if

if request("VacStatus") ="1" then
	if request ("vacs") <>"" then
	QType=6
	recordID = int(request ("vacs"))
		if request("withWithout")=1 then
			whereClause = whereclause & " and MVID in (" & request ("vacs") & ")"
		else
			whereClause = whereclause & " and not exists (select mvid from tblStaffMVs where tblStaffMVs.staffID = dbo.tblStaff.staffID and mvid = " & request ("vacs") & ") "  
		end if
	end if
end if

if request("FitnessStatus") ="1" then
	if request ("fitness") <>"" then
	QType=7
	recordID = int(request ("fitness"))
		if request("withWithout")=1 then
			whereClause = whereclause & " and fitnessID in (" & request ("fitness") & ")"
		else
			whereClause = whereclause & " and not exists (select fitnessID from tblStaffFitness where tblStaffFitness.staffID = dbo.tblStaff.staffID and fitnessID = " & request ("fitness") & ") "  
		end if
	end if
end if

if request("DentalStatus") ="1" then
	if request ("dental") <>"" then
	QType=8
	recordID = int(request ("dental"))
		if request("withWithout")=1 then
			whereClause = whereclause & " and dentalID in (" & request ("dental") & ")"
		else
			whereClause = whereclause & " and not exists (select dentalID from tblStaffDental where tblStaffDental.staffID = dbo.tblStaff.staffID and dentalID = " & request ("dental") & ") "  
		end if
	end if
end if

'response.write whereClause

set objCmd = server.CreateObject("ADODB.Command")
set objPara = server.CreateObject("ADODB.Parameter")
objCmd.ActiveConnection = con
objCmd.Activeconnection.cursorlocation = 3
objCmd.CommandText = "spManningReport"
objCmd.CommandType = 4		

set objPara = objCmd.CreateParameter ("QStatus",3,1,0, int(request("QStatus")))
objCmd.Parameters.Append objPara
set objPara = objCmd.CreateParameter ("QType",3,1,0, QType)
objCmd.Parameters.Append objPara
set objPara = objCmd.CreateParameter ("MSStatus",3,1,0, int(request("MSStatus")))
objCmd.Parameters.Append objPara
set objPara = objCmd.CreateParameter ("VacStatus",3,1,0, request("VacStatus"))
objCmd.Parameters.Append objPara
set objPara = objCmd.CreateParameter ("FitnessStatus",3,1,0, request("FitnessStatus"))
objCmd.Parameters.Append objPara
set objPara = objCmd.CreateParameter ("DentalStatus",3,1,0, request("DentalStatus"))
objCmd.Parameters.Append objPara
set objPara = objCmd.CreateParameter ("recordID",3,1,0, recordID)
objCmd.Parameters.Append objPara

set objPara = objCmd.CreateParameter ("whereClause",200,1,200, whereClause)
objCmd.Parameters.Append objPara


set rsRecSet = objCmd.Execute	'Execute CommandText when using "ADODB.Command" object'
%>
<html>
<head>

<!--#include file="Includes/IECompatability.inc"-->


<title><%= PageTitle %></title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1"><style type="text/css">
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
</style></head>
<body>
<table border=1 cellpadding=0 cellspacing=0 width=630px>
	<tr class=titlearea>
		<td align="center"><U>CMS - Manning Report</U></td>
	</tr>
	<tr height=16px>
		<td>&nbsp;</td>
	</tr>
	<tr>
		<td>
<div class=borderArea>
			<table border=0 cellpadding=0 cellspacing=0 height=50px width=100%>
				<tr >
					<td align="center" class=itemfont>Personnel who <%if request("withWithout") = 0 then response.write "do <U><B>not</B></U> "%>hold the following 
					<%select case Qtype
					
					case 1
					
					response.write  category (Qtype) 
	
					case 2
					
					response.write  category (Qtype) 
					case 3
					
					response.write  category (Qtype) 
					case 4
					
					response.write  category (Qtype) 
					case 5
					
					response.write  category (Qtype) 
					case 6
					
					response.write  category (Qtype) 
					case 7
					
					response.write  category (Qtype) 
					case 8
					
					response.write category (Qtype) 
	
					case 8
					
					response.write category (Qtype) & " Qualifiactions"
					
					end select%>
					: <B><font class=titlearea><%=rsRecSet("description")%></font></B></td>
				</tr>
			</table>
</div>
		</td>
	</tr>
	<tr height=16px>
		<td>&nbsp;</td>
	</tr>
	<%set rsRecSet = rsRecSet.nextrecordset%>
	<tr>
		<td>
			<table border=1 cellpadding=0 cellspacing=0 width=100%>
				<tr>
					<td >
<div class=borderAreaTableRow>
						<table border=0 cellpadding=0 cellspacing=0 >
							<tr class=itemfont height=20px>
								<td  valign="middle" >Search Results: <Font class=searchheading>records found: <%=rsRecSet.recordcount%></Font></td>
							</tr>
						</table>
</div>
					</td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td>
			<table border=0 cellpadding=0 cellspacing=0 width=100%>
				<tr>
					<td >
<div class=borderAreaTableRow>
						<table border=1 cellpadding=0 cellspacing=0 width=100%>
							<tr class=columnheading height=20px>
								<td  width=150px>Rank</td><td width=300px>Surname</td><td>Firstname</td>
							</tr>
						</table>
</div>	
					</td>
				</tr>
			</table>
		</td>
	</tr>
	<%do while not rsRecSet.eof
	%>
	
	<tr>
		<td>
			<table border=1 cellpadding=0 cellspacing=0 width=100%>
				<tr>
					<td >
<div class=borderAreaTableRow>	
						<table border=1 cellpadding=0 cellspacing=0 width=100%>
							<tr class=itemfont height=20px>
								<td  width=150px><%=rsRecSet("shortDesc")%></td><td width=300px><%=rsRecSet("surname")%></td><td><%=rsRecSet("firstname")%></td>
							</tr>
						</table>
</div>	
					</td>
				</tr>
			</table>
		</td>
	</tr>
		<%rsRecSet.movenext
	loop%>

</table>
</body>

<SCRIPT LANGUAGE="JavaScript">

window.close();
</script>
</html>
