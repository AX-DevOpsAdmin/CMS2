<!DOCTYPE HTML >


<!--#include file="Includes/security.inc"-->
<!--#include file="Connection/Connection.inc"-->

<%
response.ContentType = "application/vnd.ms-excel"
response.addHeader "content-disposition","attachment;filename=ManningReport.xls"

'intUnitID = request("cboTeam")
'
'if intUnitID <> 0 then
'	set objCmd = server.createobject("ADODB.Command")
'	set objPara = server.createobject("ADODB.Parameter")
'	objCmd.activeconnection = con
'	objCmd.activeconnection.cursorlocation = 3
'	objCmd.commandtype = 4
'		
'	objCmd.commandtext = "spTeamDetail"
'	
'	' now  get the team
'	set objPara = objCmd.createparameter ("teamID",3,1,0, cint(intUnitID))
'	objCmd.parameters.append objPara
'	set rsTeam = objCmd.execute
'	
'	'Retrieves the team name
'	strTeam = rsTeam("Description")
'else
'	strTeam = "All"
'end if
'
'startDate = request("startDate")
'endDate = request("endDate")

'----------- Get QType ID's in a string
dim qTypeIDStr
dim qTypeIDStrArr
qTypeIDStr = ""

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

set objCmd = server.CreateObject("ADODB.Command")
set objPara = server.CreateObject("ADODB.Parameter")
objCmd.ActiveConnection = con
objCmd.Activeconnection.cursorlocation = 3

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

Counter = rsTypeQList.recordcount

for x = 1 to objCmd.parameters.count
	objCmd.parameters.delete(0)
next


dim qualification
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

'if qualification = "" then qualification = "" else qualification = left(qualification, len(qualification) - 2)
if request ("milskill")="" then milskill ="" else milskill =request ("milskill")
if request ("vacs")="" then vacs ="" else vacs =request ("vacs")
if request ("fitness")="" then fitness ="" else fitness =request ("fitness")
if request ("dental")="" then dental ="" else dental =request ("dental")
gender = 1 'request("gender")    ' 1 = BOTH,  2=MALE, 3=FEMALE
personnel = request("radpersonnel")	'1 = Active,	2 = Inactive, 3 = Both

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

startDate = request("startDate")
endDate = request("endDate")

if request("whereClause")="" then whereClause=""

if request("QStatus") = "1" then
 	Qstatus = 0 'Used to identify that a Q has already been added to the query
	whereClause = whereclause & " AND "
	
	strList = split(qualification, ",")	
	for i = LBound(strList) to UBound(strList)
		 strQList=strList(i)
		 
		 'response.write(" i is " & i & " str is " & strQList)
		 whereClause = whereclause & strQList & " IN (SELECT QID FROM tblStaffQs WHERE staffID = tblStaff.staffID) AND "
    Next
 
    whereClause = left(whereClause, len(whereClause) - 4)
end if

if request("MSStatus") ="1" then
	if request ("milskill") <>"" then
		QType=5
		strList = request("milskill") 'To be sent to Stored Proc to return name of Qs
		strList = replace(strList," ","")
		strList = split(strList ,",")
		MSCount = (UBound(strList))+1 'How many selected
		'if request("withWithout")=1 then
			whereClause = whereclause & " and "
			queryCount =0
			do while queryCount < MSCount
			whereClause = whereclause & " milSkill" & queryCount & ".MSID = " & strList(queryCount)& " and "
			queryCount=queryCount+1
			loop
			whereClause = whereclause & " 1=1 "  
		'else
			'whereClause = whereclause & " and not exists (select MSid from tblStaffMilSkill where tblStaffMilSkill.staffID = dbo.tblStaff.staffID and msid = " & request ("milskill") & ") "  
		'end if
	end if
end if

if request("VacStatus") ="1" then
	if request ("vacs") <>"" then
		QType=6
		strList = request("vacs") 'To be sent to Stored Proc to return name of Qs
		strList = replace(strList," ","")
		strList = split(strList ,",")
		vacCount = (UBound(strList))+1 'How many selected
		'if request("withWithout")=1 then
			whereClause = whereclause & " and "
			queryCount =0
			do while queryCount < vacCount
			whereClause = whereclause & " MVs" & queryCount & ".mvID = " & strList(queryCount)& " and "
			queryCount=queryCount+1
			loop
			whereClause = whereclause & " 1=1 "  
		'else
			'whereClause = whereclause & " and not exists (select mvid from tblStaffMVs where tblStaffMVs.staffID = dbo.tblStaff.staffID and mvid = " & request ("vacs") & ") "  
		'end if
	end if
end if

if request("FitnessStatus") ="1" then
	if request ("fitness") <>"" then
		QType=7
		strList = request("fitness") 'To be sent to Stored Proc to return name of Qs
		strList = replace(strList," ","")
		strList = split(strList ,",")
		fitnessCount = (UBound(strList))+1 'How many selected
		'if request("withWithout")=1 then
			whereClause = whereclause & " and "
			queryCount =0
			do while queryCount < fitnessCount
			whereClause = whereclause & " fitness" & queryCount & ".fitnessID = " & strList(queryCount)& " and "
			queryCount=queryCount+1
			loop
			whereClause = whereclause & " 1=1 "  
		'else
			'whereClause = whereclause & " and not exists (select fitnessID from tblStaffFitness where tblStaffFitness.staffID = dbo.tblStaff.staffID and fitnessID = " & request ("fitness") & ") "  
		'end if
	end if
end if

if request("DentalStatus") ="1" then
	if request ("dental") <>"" then
		QType=8
		strList = request("dental") 'To be sent to Stored Proc to return name of Qs
		strList = replace(strList," ","")
		strList = split(strList ,",")
		dentalCount = (UBound(strList))+1 'How many selected
		'if request("withWithout")=1 then
			whereClause = whereclause & " and "
			queryCount =0
			do while queryCount < dentalCount
			whereClause = whereclause & " dental" & queryCount & ".dentalID = " & strList(queryCount)& " and "
			queryCount=queryCount+1
			loop
			whereClause = whereclause & " 1=1 "  
		'else
			'whereClause = whereclause & " and not exists (select dentalID from tblStaffDental where tblStaffDental.staffID = dbo.tblStaff.staffID and dentalID = " & request ("dental") & ") "  
		'end if
	end if
end if

if request("civi") = 1 then
	civi = request("civi")
else
	civi = 0
end if

set objCmd = server.CreateObject("ADODB.Command")
set objPara = server.CreateObject("ADODB.Parameter")
objCmd.ActiveConnection = con
objCmd.Activeconnection.cursorlocation = 3
objCmd.CommandText = "spManningReportMultiple"
objCmd.CommandType = 4		

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

'response.write ("Here 1 ")

set rsRecSet = objCmd.Execute	'Execute CommandText when using "ADODB.Command" object'

'response.write ("Here 2 ")

'response.End()
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
    <table width="1125px" border="0" cellpadding="0" cellspacing="0">
        <tr>
            <td colspan="8" align="center" style="font-size:14pt"><U>Manning Report</U></td>
        </tr>
        <tr>
            <td colspan="8">&nbsp;</td>
        </tr>
        <tr>
            <td colspan="8" align="center" style="color:#003399;  font-family: verdana;"><u>Personnel Who <% if request("withWithout") = 0 then response.write "Do <U><B>NOT</B></U> "%>Hold the Following:</u></td>
        </tr>
        <tr>
            <td colspan="8" align="center" style="color:#003399;  font-family: verdana;"><u>For the Whole Period: <strong><%=request("startDate")%></strong> to <strong><%=request("startDate")%></strong></u></td>
        </tr>
        <tr>
            <td colspan="8">&nbsp;</td>
        </tr>
        <tr>
            <td colspan="8" class="itemfont">Unit:&nbsp;<font color="#0033FF" size="3"><strong><%= strHrcName %></strong></font></td>
        </tr>
        <tr>
            <td colspan="8">&nbsp;</td>
        </tr>
		<% on error resume next %>
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
												    <%' response.write ("QType is " & strQTID & " " &  strQType & " first is " & first )  %>
													<% if first = 0 and rsRecSet("QTypeID") = cint(strQTID) then %>
														<% if request("all" & strQTID & "Q") = 1 then %>
															<% response.write (" & ") %>
														<% else %>
															<% response.write ("or ") %>
														<% end if %>
													<% end if %>
													<% ' response.write ("Q name " & strQTID & " " & rsRecSet("QTypeID") & " " & rsRecSet("description")) %>
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
            <tr class=itemfont>
                <td valign="Top" width=150pt height=22px>&nbsp;<u>Military Skills:</U></td>
                <td valign="Top" colspan="7" width="1050pt" height="22px">
                <% if Qstatus = 1 then %>
                    <% if request("orMilSkill") = 1 then %>
                        <% response.write (" & ") %>
                    <% else %>
                        <% response.write ("or") %>
                    <% end if %>
                <% end if %>
                <%
                first=1
                do while not rsRecSet.eof
                if first=0 then response.write (" & ")
                %>
                
                <B><font class=itemfont><%=rsRecSet("description")%></font></B>
                <%
                first=0
                rsRecSet.movenext
                loop
                %>
                </td>
            </tr>
            <%set rsRecSet = rsRecSet.nextrecordset%>	
        <%end if%>
    
        <%if vacs <> "" then%>
            <tr class=itemfont>
                <td valign="Top" width=150pt height=22px>&nbsp;<u>Vaccinations:</U></td>
                <td valign="Top" colspan="7" width="1050pt" height="22px">
                <% if Qstatus = 1 then %>
                    <% if request("orVacs") = 1 then %>
                        <% response.write (" & ") %>
                    <% else %>
                        <% response.write ("or") %>
                    <% end if %>
                <% end if %>
                <%
                first=1
                do while not rsRecSet.eof
                if first=0 then response.write (" & ")
                %>
                
                <B><font class=itemfont><%=rsRecSet("description")%></font></B>
                <%
                first=0
                rsRecSet.movenext
                loop
                %>
                </td>
            </tr>
            <%set rsRecSet = rsRecSet.nextrecordset%>	
        <%end if%>
    
        <%if fitness <> "" then%>
            <tr class=itemfont>
                <td valign="Top" width=150pt height=22px>&nbsp;<u>Fitness Types:</U></td>
                <td valign="Top" colspan="7" width="1050pt" height="22px">
                <% if Qstatus = 1 then %>
                    <% if request("orFitness") = 1 then %>
                        <% response.write (" & ") %>
                    <% else %>
                        <% response.write ("or") %>
                    <% end if %>
                <% end if %>
                <%
                first=1
                do while not rsRecSet.eof
                if first=0 then response.write (" & ")
                %>
                
                <B><font class=itemfont><%=rsRecSet("description")%></font></B>
                <%
                first=0
                rsRecSet.movenext
                loop
                %>
                </td>
            </tr>
            <%set rsRecSet = rsRecSet.nextrecordset%>	
        <%end if%>
    
        <%if dental <> "" then%>
            <tr class=itemfont>
                <td valign="Top" width=150pt height=22px>&nbsp;<u>Dental Types:</U></td>
                <td valign="Top" colspan="7" width="1050pt" height="22px">
                <% if Qstatus = 1 then %>
                    <% if request("orDental") = 1 then %>
                        <% response.write ("&") %>
                    <% else %>
                        <% response.write ("or") %>
                    <% end if %>
                <% end if %>
                <%
                first=1
                do while not rsRecSet.eof
                if first=0 then response.write (" & ")
                %>
                
                <B><font class=itemfont><%=rsRecSet("description")%></font></B>
                <%
                first=0
                rsRecSet.movenext
                loop
                %>
                </td>
            </tr>
            <%set rsRecSet = rsRecSet.nextrecordset%>	
        <%end if%>
        <tr>
            <td colspan="8">&nbsp;</td>
        </tr>
        <tr class=itemfont>
            <td  colspan="8" valign="middle" height=22px>Search Results: <Font class=searchheading>records found: <%=rsRecSet.recordcount%></Font></td>
        </tr>
        <tr>
            <td colspan="8">&nbsp;</td>
        </tr>
        <tr>
            <td width=350 height=22px><strong>Name</strong></td>
            <td width=100 height=22x><strong>Service No</strong></td>
            <td width=250 height=22pt><strong>Unit</strong></td>
            <!--
            <td width=100 height=22px><strong>Arrival Date</strong></td>
            <td width=100 height=22pt><strong>Posting Date</strong></td>                      
            <td width=125 height=22pt><strong>Discharge Date</strong></td>  
            <td width=100 height=22pt><strong>Last OOA</strong></td>
            <td width=100 height=22pt><strong>MES</strong></td>
            -->
        </tr>
        <% do while not rsRecSet.eof %>
            <tr>
                <td width=350 class="xl27" height=22px><%=rsRecSet("shortDesc") & " " & rsRecSet("surname") & ", " & rsRecSet("firstname")%></td>
                <td width=100 class="xl29" height=22px><%=rsRecSet("serviceNo")%></td>
                <td width=250 class="xl27" height=22px><%=rsRecSet("Team")%></td>
                <!--
                <td width=100 class="xl29" height=22px><%'=rsRecSet("arrivaldate")%></td>
                <td width=100 class="xl29" height=22px><%'=rsRecSet("postingduedate")%></td>                        
                <td width=125 class="xl29" height=22px><%'=rsRecSet("dischargeDate")%></td>
                <td width=100 class="xl29" height=22px><%'=rsRecSet("lastOOA")%></td>
                <td width=100 class="xl29" height=22px><%'=rsRecSet("MES")%></td>
                -->
            </tr>
            <% rsRecSet.movenext %>
        <% loop %>
    </table>
</body>
</html>