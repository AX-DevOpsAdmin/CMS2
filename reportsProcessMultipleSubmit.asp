<!DOCTYPE HTML >

<!--#include file="Includes/security.inc"-->
<!--#include file="Connection/Connection.inc"-->

<%
	set objCmd = server.createobject("ADODB.Command")
	set objPara = server.createobject("ADODB.Parameter")
	objCmd.activeconnection = con
	objCmd.activeconnection.cursorlocation = 3
	objCmd.commandtype = 4
		
hrcID = request("cboHrc")

'if intUnitID <> 0 then
	objCmd.commandtext = "spHrcDetail"
	
	' now  get the team
	set objPara = objCmd.createparameter ("hrcID",3,1,0, cint(hrcID))
	objCmd.parameters.append objPara
	set rsHrc = objCmd.execute
	
	'Retrieves the team name
	strHrcName = rsHrc("hrcname")
'else
'	strHrcName = "All"
'end if
for x = 1 to objCmd.parameters.count
	objCmd.parameters.delete(0)
next

strCommand = "spListQTypes"
objCmd.CommandText = strCommand
set objPara = objCmd.CreateParameter ("nodeID",3,1,5, session("nodeID"))
objCmd.Parameters.Append objPara
set rsTypeQList = objCmd.Execute	'Execute CommandText when using "ADODB.Command" object'

'Counter = rsTypeQList.recordcount

for x = 1 to objCmd.parameters.count
	objCmd.parameters.delete(0)
next

dim qualification
dim qTypeIDStr
dim qTypeIDStrArr
qTypeIDStr = ""

qualification = ""
'for i = 1 to Counter
'	if request(i & "Q") <> "" then
'		qualification = qualification & request(i & "Q") & ", "
'	end if
'next
'
rsTypeQList.movefirst
do while not rsTypeQList.eof 
   i = rsTypeQList("qTypeID")
   if qTypeIDStr="" then
      qTypeIDStr= rsTypeQList("qTypeID") & "|" & rsTypeQList("Type")
   else
      qTypeIDStr= qTypeIDStr  & "," & rsTypeQList("qTypeID") & "|" & rsTypeQList("Type")
   end if
   
   if request(i & "Q") <> "" then
       if qualification = "" then
	     qualification = request(i & "Q")
	   else
		qualification = qualification & "," & request(i & "Q")
	   end if
    end if
	Counter=Counter + 1
   rsTypeQList.movenext
Loop

'qualification = qualification & ","

'response.write("Qs are " & qualification)


todayDate = formatdatetime(date(),2)
splitDate = split (todayDate,"/")
if splitdate(1)="01" then theMonth="Jan"
if splitdate(1)="02" then theMonth="Feb"
if splitdate(1)="03" then theMonth="Mar"
if splitdate(1)="04" then theMonth="Apr"
if splitdate(1)="05" then theMonth="May"
if splitdate(1)="06" then theMonth="Jun"
if splitdate(1)="07" then theMonth="Jul"
if splitdate(1)="08" then theMonth="Aug"
if splitdate(1)="09" then theMonth="Sep"
if splitdate(1)="10" then theMonth="Oct"
if splitdate(1)="11" then theMonth="Nov"
if splitdate(1)="12" then theMonth="Dec"

if len(splitDate(0)) < 2 then splitDate(0) = "0" & splitDate(0)
newTodaydate= splitDate(0) + " " + theMonth + " " + splitDate(2) 
startDate = request("startDate")
endDate = request("endDate")

'----------- Get QType ID's in a string

'For Each x in request.Form()
'	
'	if right(x,1) = "Q" and request.Form(x) <> "" and left(x,3) <> "all" and left(x,2) <> "or" then
'		qTypeIDStr = qTypeIDStr&replace(x,"Q","")&","
'		'& ":"&request.Form(x)&
'	end if
'		
'Next
'qTypeIDStr = left(qTypeIDStr, len(qTypeIDStr)-1)
''response.Write(qTypeIDStr)
'
'qTypeIDStrArr = split(qTypeIDStr, ",")
''response.Write(uBound(qTypeIDStrArr))
'for i = lbound(qTypeIDStrArr) to ubound(qTypeIDStrArr)
'	for j = lbound(qTypeIDStrArr) to ubound(qTypeIDStrArr)
'		if j <> ubound(qTypeIDStrArr) then
'			if cint(qTypeIDStrArr(j)) > cint(qTypeIDStrArr(j + 1)) then
'				tempvalue = cint(qTypeIDStrArr(j + 1))
'				qTypeIDStrArr(j + 1) = cint(qTypeIDStrArr(j))
'				qTypeIDStrArr(j) = cint(tempvalue)
'			end if
'		end if
'	next
'next 

'if qualification = "" then qualification = "" else qualification = left(qualification, len(qualification) - 2)
if request ("milskill")="" then milskill ="" else milskill =request ("milskill")
if request ("vacs")="" then vacs ="" else vacs =request ("vacs")
if request ("fitness")="" then fitness ="" else fitness =request ("fitness")
if request ("dental")="" then dental ="" else dental =request ("dental")
gender = 1 ' request("gender")    ' 1 = BOTH,  2=MALE, 3=FEMALE
'personnel = request("radpersonnel")	'1 = Active,	2 = Inactive, 3 = Both

dim whereClause
dim strList
dim QCounter
redim QCounter(Counter)

for i = 1 to Counter
	QCounter(i) = 0
next

QCount = 0
msCount = 0
vacCount = 0
fitnessCount = 0
dentalCount = 0

recordID = 0
QType = 0

if request("whereClause")="" then whereClause=""

'Have any qualifications been selected
if request("QStatus") = "1" then
	Qstatus = 0 'Used to identify that a Q has already been added to the query
	whereClause = whereclause & " AND "
	
	'response.write("Qs " & qualification)
	
'	strSplit = split(qualifications)

	strList = split(qualification, ",")
	'response.write("Str List is " & LBound(strList) & " * " & UBound(strList))
	
	for i = LBound(strList) to UBound(strList)
		 strQList=strList(i)
		 
		 'response.write(" i is " & i & " str is " & strQList)
		 whereClause = whereclause & strQList & " IN (SELECT QID FROM tblStaffQs WHERE staffID = tblStaff.staffID) AND "
    Next
	'Have any qualifications been selected
'	for i = 1 to Counter
'		if request(i & "Q") <> "" then
'			QType = i 'Identifies type of Q for output
'			strList = request(i & "Q") 'To be sent to Stored Proc to return name of Qs
'			strList = replace(strList," ","")	'Removes the space and replace it with a comma
'			strList = split(strList ,",")
'			QCounter(i) = (ubound(strList)) + 1 'How many selected
'			
'			Qstatus = 1 'Do not include "and" later on in query
'			queryCount = 0
'			
'			if request("all" & i & "Q") = 1 then 
'				do while queryCount < QCounter(i)
'					whereClause = whereclause & strList(queryCount) & " IN (SELECT QID FROM tblStaffQs WHERE staffID = tblStaff.staffID) AND "
'					queryCount = queryCount + 1
'				loop
'			else
'				if i = 0 then
'					whereClause = whereclause & "("
'				end if
'
'				do while queryCount < QCounter(i)
'					whereClause = whereclause & "(Q0.qID IN (" & request (i & "Q") & ")) "  
'					queryCount = queryCount + 1
'					if queryCount < QCounter(i) then whereClause = whereclause & " OR "
'				loop
'			end if
'		end if
'		
'		QCount = QCount + QCounter(i)
'	next
	
	'response.write ("Where Clause is " & whereClause )
	whereClause = left(whereClause, len(whereClause) - 4)
	'response.write ("Where Clause now is " & hrcID & " * " & whereClause)
	
	'response.End()
	
end if

if request("MSStatus") ="1" then
	if request ("milskill") <>"" then
		QType=5
		strList = request("milskill") 'To be sent to Stored Proc to return name of Qs
		strList = replace(strList," ","")
		strList = split(strList ,",")
		MSCount = (UBound(strList))+1 'How many selected
		Qstatus=1 
		if request("orMilskill") ="1" then
			whereClause = whereclause & " AND "
		else
			whereClause = whereclause & " OR "
		end if
		queryCount =0
		if request("allMilskill") = 1 then 
			do while queryCount < MSCount
			whereClause = whereclause & " milSkill" & queryCount & ".MSID = " & strList(queryCount)& " AND "
			queryCount=queryCount+1
			loop
			whereClause = whereclause & " 1=1 "  
		else
			whereClause = whereclause & "("
			do while queryCount < MSCount
				whereClause = whereclause & "(milSkill" & queryCount & ".MSID IN (" & request ("milskill") & ")) "  
				queryCount=queryCount+1
				if queryCount < MSCount then whereClause = whereclause & " OR "
			loop
			whereClause = whereclause & ")"
		end if
	end if
end if

if request("VacStatus") ="1" then
	if request ("vacs") <>"" then
		QType=6
		strList = request("vacs") 'To be sent to Stored Proc to return name of Qs
		strList = replace(strList," ","")
		strList = split(strList ,",")
		vacCount = (UBound(strList))+1 'How many selected
		Qstatus=1 
		if request("orVacs") ="1" then
			whereClause = whereclause & " AND "
		else
			whereClause = whereclause & " OR "
		end if
		queryCount =0
		if request("allVacs") = 1 then 
			do while queryCount < vacCount
			whereClause = whereclause & " MVs" & queryCount & ".mvID = " & strList(queryCount)& " AND "
			queryCount=queryCount+1
			loop
			whereClause = whereclause & " 1=1 "  
		else
			whereClause = whereclause & "("
			do while queryCount < vacCount
				whereClause = whereclause & "(MVs" & queryCount & ".mvID IN (" & request ("vacs") & ")) "  
				queryCount=queryCount+1
				if queryCount < vacCount then whereClause = whereclause & " OR "
			loop
			whereClause = whereclause & ")"
		end if
	end if
end if

if request("FitnessStatus") ="1" then
	if request ("fitness") <>"" then
		QType=7
		strList = request("fitness") 'To be sent to Stored Proc to return name of Qs
		strList = replace(strList," ","")
		strList = split(strList ,",")
		fitnessCount = (UBound(strList))+1 'How many selected
		Qstatus=1 

		if request("orFitness") ="1" then
			whereClause = whereclause & " AND "
		else
			whereClause = whereclause & " OR "
		end if
		queryCount = 0
		if request("allFitness") = 1 then 
			do while queryCount < fitnessCount
			whereClause = whereclause & " fitness" & queryCount & ".fitnessID = " & strList(queryCount)& " AND "
			queryCount=queryCount+1
			loop
			whereClause = whereclause & " 1=1 "  
		else
			whereClause = whereclause & "("
			do while queryCount < fitnessCount
				whereClause = whereclause & "(fitness" & queryCount & ".fitnessID IN (" & request ("fitness") & ")) "  
				queryCount=queryCount+1
				if queryCount < fitnessCount then whereClause = whereclause & " OR "
			loop
			whereClause = whereclause & ")"
		end if
	end if
end if

if request("DentalStatus") ="1" then
	if request ("dental") <>"" then
		QType=8
		strList = request("dental") 'To be sent to Stored Proc to return name of Qs
		strList = replace(strList," ","")
		strList = split(strList ,",")
		dentalCount = (UBound(strList))+1 'How many selected
		Qstatus=1 

		if request("orDental") ="1" then
			whereClause = whereclause & " AND "
		else
			whereClause = whereclause & " OR "
		end if
		queryCount =0
		if request("allDental") = 1 then 
			do while queryCount < dentalCount
			whereClause = whereclause & " dental" & queryCount & ".dentalID = " & strList(queryCount)& " AND "
			queryCount=queryCount+1
			loop
			whereClause = whereclause & " 1=1 "  
		else
			whereClause = whereclause & "("
			do while queryCount < dentalCount
				whereClause = whereclause & "(dental" & queryCount & ".dentalID IN (" & request ("dental") & ")) "  
				queryCount=queryCount+1
				if queryCount < dentalCount then whereClause = whereclause & " OR "
			loop
			whereClause = whereclause & ")"
		end if
	end if
end if

if request("civi") = 1 then
	civi = request("civi")
else
	civi = 0
end if

'response.write("Q Stats " & request("QStatus") & " / " & QCount & " Mil Stats " & request("MSStatus") & " / " & MSCount &  " Vacs Stats " & request("VacStatus") & " / " & vacCount ) &vbCRLF
'response.write("Fit Stats " & request("FitnessStatus") & " / " & fitnessCount & " Dental Stats " & request("dentalStatus") & " / " & dentalCount &  " With Stats " & request("withWithout") ) &vbCRLF
'response.write(" WhereClause " & whereClause & " qualification " & qualification &  " milskill " & milSkill & " vacs " & vacs  ) &vbCRLF
'response.write(" fitness " & fitness & " dental " & dental &  " teamID " & request("cboTeam") & " thisdate " & startdate  ) 
'response.write(" civi " & civi & " endDate " & endDate &  " gender " & gender  ) 
'
'
'response.write (request("cboHrc")& " * " & request("QStatus")& " * " & QCount & " ** " & whereClause & " *** " & qualification)
'response.write ( request("MSStatus") & " * " & MSCount & " * " & request("VacStatus")& " * " & vacCount & " * " & request("FitnessStatus")) &vbCRLF
'response.write ( " * " & fitnessCount & " * " & request("DentalStatus")& " * " & dentalCount& " * " & request("withWithout")& " * "  & milSkill & " * " & vacs ) &vbCRLF
'response.write ( " * " & fitness & " * " & dental & " * " & startDate & " * " & civi & " * " & endDate)
'response.End()

objCmd.CommandText = "spManningReportMultiple2"
set objPara = objCmd.CreateParameter ("hrcID",3,1,0, cint(request("cboHrc")))
objCmd.Parameters.Append objPara

set objPara = objCmd.CreateParameter ("QStatus",3,1,0, int(request("QStatus")))
objCmd.Parameters.Append objPara
set objPara = objCmd.CreateParameter ("QCount",3,1,0, QCount)
objCmd.Parameters.Append objPara

set objPara = objCmd.CreateParameter ("MSStatus",3,1,0, int(request("MSStatus")))
objCmd.Parameters.Append objPara
set objPara = objCmd.CreateParameter ("MSCount",3,1,0, MSCount)
objCmd.Parameters.Append objPara
set objPara = objCmd.CreateParameter ("VacStatus",3,1,0, int(request("VacStatus")))
objCmd.Parameters.Append objPara
set objPara = objCmd.CreateParameter ("vacCount",3,1,0, vacCount)
objCmd.Parameters.Append objPara
set objPara = objCmd.CreateParameter ("FitnessStatus",3,1,0, int(request("FitnessStatus")))
objCmd.Parameters.Append objPara
set objPara = objCmd.CreateParameter ("fitnessCount",3,1,0, fitnessCount)
objCmd.Parameters.Append objPara
set objPara = objCmd.CreateParameter ("DentalStatus",3,1,0, int(request("DentalStatus")))
objCmd.Parameters.Append objPara
set objPara = objCmd.CreateParameter ("dentalCount",3,1,0, dentalCount)
objCmd.Parameters.Append objPara
set objPara = objCmd.CreateParameter ("withWithout",3,1,0, int(request("withWithout")))
objCmd.Parameters.Append objPara
set objPara = objCmd.CreateParameter ("whereClause",200,1,8000, whereClause)
objCmd.Parameters.Append objPara
set objPara = objCmd.createparameter("qualification",200,1,1000, qualification)
objCmd.parameters.append objPara
set objPara = objCmd.CreateParameter ("milSkill",200,1,500,  milSkill)
objCmd.Parameters.Append objPara
set objPara = objCmd.CreateParameter ("vacs",200,1,500,  vacs)
objCmd.Parameters.Append objPara
set objPara = objCmd.CreateParameter ("fitness",200,1,500,  fitness)
objCmd.Parameters.Append objPara
set objPara = objCmd.CreateParameter ("dental",200,1,500, dental)
objCmd.Parameters.Append objPara
set objPara = objCmd.CreateParameter ("thisDate",200,1,30, startDate)
objCmd.Parameters.Append objPara
set objPara = objCmd.CreateParameter ("civi",3,1,0, civi)
objCmd.Parameters.Append objPara
set objPara = objCmd.CreateParameter ("endDate",200,1,30, endDate)
objCmd.Parameters.Append objPara
set objPara = objCmd.CreateParameter ("gender",3,1,0, gender)
objCmd.Parameters.Append objPara
'set objPara = objCmd.CreateParameter ("personnel",3,1,0, personnel)
'objCmd.Parameters.Append objPara

set rsRecSet = objCmd.Execute	'Execute CommandText when using "ADODB.Command" object'

QStatus=0
%>

<html>
<head>

<!--#include file="Includes/IECompatability.inc"-->


<title><%= PageTitle %></title>
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
		<td align="center"><U>Manning Report</U></td>
	</tr>
	<tr height=16px>
		<td>&nbsp;</td>
	</tr>
	<tr>
		<td>
			<table border=0 cellpadding=0 cellspacing=0 height=50px width=100%>
				<tr>
					<td align="center" class=subheading height=22px><u>Personnel Who <%if request("withWithout") = 0 then response.write "Do <U><B>NOT</B></U> "%>Hold the Following:</U></td>
				</tr>
				<tr>
					<td align="center" class=subheading height=22px><u>For the Whole Period:&nbsp;<strong><%=request("startDate")%></strong> to <strong><%=request("endDate")%></strong></U></td>
				</tr>
				<tr>
					<td>&nbsp;</td>
				</tr>
                <tr>
                    <td width="100%" class="itemfont">Unit:&nbsp;<font color="#0033FF" size="3"><strong><%= strHrcName %></strong></font></td>
                </tr>
				<tr>
					<td>&nbsp;</td>
				</tr>
                <% if qualification <> "" or milskill <> "" or vacs <> "" or fitness <> "" or dental <> "" then %>
				<tr>
					<td>
						<table border=0 cellpadding=0 cellspacing=0 width=100%>
							<% if qualification <> "" then 
                            	strList = split(qTypeIDStr, ",")
								'response.write ("QTypes are "&	qTypeIDStr) 
								rsRecSet.movefirst 
	                            for i = LBound(strList) to UBound(strList)
		                            strQTList=strList(i)
									strQT= split(strQTList, "|")
									strQTID=strQT(0)
									strQType=strQT(1)
									
									%>
								    <%' for i = 1 to Counter %>
									<%if request(strQTID & "Q") <> "" then%>
										<tr class=itemfont>
											<td valign="Top" width=120px height=22px>&nbsp;<u><%= strQType %>Qs:</U></td>
											<td valign="Top" height="22px">
												<% first = 1 %>
												<% do while not rsRecSet.eof %>
												    <%' response.write ("QType is " & strQTID & " " &  strQType & " first is " & first & " " & request("all" & strQTID & "Q") & " ")  %>
													<% if first = 0 and rsRecSet("QTypeID") = cint(strQTID) then %>
														<% if request("all" & strQTID & "Q") = 1 then %>
															<% response.write (" & ") %>
														<% else %>
															<% response.write ("or ") %>
														<% end if %>
													<% end if %>
													<%  'response.write ("Q name " & strQTID & " " & rsRecSet("QTypeID") & " " & rsRecSet("description")) %>
													<% if rsRecSet("QTypeID") = cint(strQTID) then %>
                                                       
														<B><font class=itemfont><%=rsRecSet("description")%></font></B>
                                                        <% first = 0 %>
													<% end if %>
													
													
													<% rsRecSet.movenext %>
												<% loop %>
											</td>
										</tr>
										<% rsRecSet.movefirst %>
										<% QStatus = 1 %>
									<% end if %>
									<%' rsTypeQList.movenext %>
								<% next %>
								<% set rsRecSet = rsRecSet.nextrecordset %>
							<% end if %>
							
							<%if milskill <> "" then%>
								<tr>
									<td colspan=2>
										<table border=0 cellpadding=0 cellspacing=0 width=100%>
											<tr>
												<td colspan=6 ></td> 
											</tr>
										</table>
									</td>
								</tr>
								<tr class=itemfont>
									<td valign="Top" width=120px height=22px>&nbsp;<u>Military Skills:</U></td>
									<td valign="Top" height=22px>
										<% if Qstatus = 1 then %>
											<% if request("orMilSkill") = 1 then %>
												<% response.write ("") %>
											<% else %>
												<% response.write ("or") %>
											<% end if %>
										<% end if %>
										<% first = 1 %>
										<% do while not rsRecSet.eof %>
											<% if first=0 then %>
												<% if request("allMilskill") = 1 then %>
													<% response.write (" & ") %>
												<% else %>
													<% response.write ("or ") %>
												<% end if %>
											<% end if %>
											<B><font class=itemfont><%=rsRecSet("description")%></font></B>
											<% first = 0 %>
											<% rsRecSet.movenext %>
										<% loop %>
									</td>
								</tr>
								<% set rsRecSet = rsRecSet.nextrecordset %>
								<% qStatus = 1 %>
							<%end if%>
                            
							<%if vacs <> "" then%>
								<tr>
									<td colspan=2>
										<table border=0 cellpadding=0 cellspacing=0 width=100%>
											<tr>
												<td colspan=6 ></td> 
											</tr>
										</table>
									</td>
								</tr>
								<tr class=itemfont>
									<td valign="Top" width=120px height=22px>&nbsp;<u>Vaccinations:</U></td>
									<td valign="Top" height=22px>
										<% if Qstatus = 1 then %>
											<% if request("orVacs") = 1 then %>
												<% response.write ("") %>
											<% else %>
												<% response.write ("or") %>
											<% end if %>
										<% end if %>
										<% first = 1 %>
										<% do while not rsRecSet.eof %>
											<% if first = 0 then %>
												<% if request("allVacs") = 1 then %>
													<% response.write (" & ") %>
												<% else %>
													<% response.write ("or ") %>
												<% end if %>
											<% end if %>
											<B><font class=itemfont><%=rsRecSet("description")%></font></B>
											<% first = 0 %>
											<% rsRecSet.movenext %>
										<% loop %>
									</td>
								</tr>
								<% set rsRecSet = rsRecSet.nextrecordset %>
								<% qStatus = 1 %>
								<% end if %>
                                
								<% if fitness <> "" then %>
									<tr>
										<td colspan=2>
											<table border=0 cellpadding=0 cellspacing=0 width=100%>
												<tr>
													<td colspan=6 ></td> 
												</tr>
											</table>
										</td>
									</tr>
									<tr class=itemfont>
										<td valign="Top" width=120px height=22px>&nbsp;<u>Fitness Types:</U></td>
										<td valign="Top" height=22px>
										<% if Qstatus = 1 then %>
											<% if request("orFitness") = 1 then %>
												<% response.write ("") %>
											<% else %>
												<% response.write ("or") %>
											<% end if %>
										<% end if %>
										<% first = 1 %>
										<% do while not rsRecSet.eof %>
											<% if first=0 then %>
												<% if request("allFitness") = 1 then %>
													<% response.write (" & ") %>
												<% else %>
													<% response.write ("or ") %>
												<% end if %>
											<% end if %>
											<B><font class=itemfont><%=rsRecSet("description")%></font></B>
											<% first = 0 %>
											<% rsRecSet.movenext %>
										<% loop %>
										</td>
									</tr>
									<%set rsRecSet = rsRecSet.nextrecordset%>
									<%qStatus=1%>
									<%end if%>
                                    
									<%if dental <> "" then%>
										<tr>
											<td colspan=2>
												<table border=0 cellpadding=0 cellspacing=0 width=100%>
													<tr>
														<td colspan=6 ></td> 
													</tr>
												</table>
											</td>
										</tr>
										<tr class=itemfont>
											<td valign="Top" width=120px height=22px>&nbsp;<u>Dental Types:</U></td>
											<td valign="Top" height=22px>
												<% if Qstatus = 1 then %>
													<% if request("orDental") = 1 then %>
														<% response.write ("") %>
													<% else %>
														<% response.write ("or") %>
													<% end if %>
												<% end if %>
												<% first = 1 %>
												<% do while not rsRecSet.eof %>
													<% if first=0 then %>
														<% if request("allDental") = 1 then %>
															<% response.write (" & ") %>
														<% else %>
															<% response.write ("or ") %>
														<% end if %>
													<% end if %>
													<B><font class=itemfont><%=rsRecSet("description")%></font></B>
													<% first = 0 %>
													<% rsRecSet.movenext %>
												<% loop %>
											</td>
										</tr>
										<% set rsRecSet = rsRecSet.nextrecordset %>
									<% end if %>
								</table>
							</td>
						</tr>
					</table>
				</td>
			</tr>
			<tr>
				<td>&nbsp;</td>
			</tr>
            <% end if %>
            <tr class=itemfont>
                <td valign="middle" height=22px>Records Found: <%=rsRecSet.recordcount%></Font></td>
            </tr>
            <tr>
                <td>&nbsp;</td>
            </tr>
			<tr>
				<td>
					<table border=0 cellpadding=0 cellspacing=0 width=100%>
						<tr>
							<td >
                                <table border=0 cellpadding=0 cellspacing=0 width=100%>
                                    <tr class=columnheading>
                                        <td width=4px height=22px>&nbsp;</td>
                                        <td width=180px height=22px>Name</td>
                                        <td width=70px height=22px>Service No</td>
                                        <td width=150px height=22px>Team</td>
                                        <!--
                                        <td width=85px height=22px>Arrival Date</td>
                                        <td width=85px height=22px>Posting Date</td>
                                        <td width=90px height=22px>Discharge Date</td>
                                        <td width=85px height=22px>Last OOA</td>
                                        <td width=85px height=22px>&nbsp;MES</td>
                                        -->
                                    </tr>
                                    <tr>
                                        <td colspan=11 class=titlearealine  height=1></td> 
                                    </tr>
									<% do while not rsRecSet.eof %>
                                        <tr class=itemfont>
                                            <td width=4px height=22px>&nbsp;</td>
                                            <td width=180px height=22px><%=rsRecSet("shortDesc") & " " & rsRecSet("surname") & ", " & rsRecSet("firstname")%></td>
                                            <td width=70px height=22px><%=rsRecSet("serviceNo")%></td>
                                            <td width=150px height=22px><%=rsRecSet("Team")%></td>
                                            <!--
                                            <td width=85px height=22px><%'=rsRecSet("arrivaldate")%></td>
                                            <td width=85px height=22px><%'=rsRecSet("postingduedate")%></td>
                                            <td width=90px height=22px><%'=rsRecSet("dischargeDate")%></td>   
                                            <td width=85px height=22px><%'=rsRecSet("lastOOA")%></td>
                                            <td width=85px height=22px><%'=rsRecSet("MES")%></td>
                                            -->
                                        </tr>
                                        <tr>
                                            <td colspan=11 class=titlearealine  height=1></td> 
                                        </tr>
                                        <% rsRecSet.movenext %>
                                    <% loop %>
								</table>
							</td>
						</tr>
					</table>
				</td>
			</tr>
		</td>
	</tr>
</table>
</body>
</html>