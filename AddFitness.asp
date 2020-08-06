<!DOCTYPE HTML >
<!--#include file="Includes/security.inc"--> 
<!--include file="Includes/checkadmin.asp"-->
<!--#include file="Connection/Connection.inc"-->
<%
set objCmd = server.CreateObject("ADODB.Command")
set objPara = server.CreateObject("ADODB.Parameter")
objCmd.ActiveConnection = con
objCmd.Activeconnection.cursorlocation = 3

Const Hidden = 2

Dim objUpload
Dim strFileName
Dim strPath
dim strFiles
dim strList
	
if request("staffID") <>"" then
	strRecID = request("staffID")
	strGoTo = request("ReturnTo") & "?staffID=" & strRecid & "&thisDate=" & request("thisDate")
else
	strRecID = request("RecID")
	strGoTo = request("ReturnTo") & "?RecID=" & strRecid 
end if

IF Request("newattached") <> "" THEN
	
	set objPara = objCmd.CreateParameter ("staffID",3,1,0, strRecID)
	objCmd.Parameters.Append objPara
	set objPara = objCmd.CreateParameter ("remedial",3,1,0, 0)
	objCmd.Parameters.Append objPara
	set objPara = objCmd.CreateParameter ("exempt",3,1,0, 0)
	objCmd.Parameters.Append objPara
	set objPara = objCmd.CreateParameter ("expiryDate",135,1,8, NULL)
	objCmd.Parameters.Append objPara	
	
	objCmd.CommandText = "spUpdateRemedial"	'Name of Stored Procedure'
	objCmd.Execute	'Execute CommandText when using "ADODB.Command" object'
	
	for x = 1 to objCmd.parameters.count
		objCmd.parameters.delete(0)
	next
	
	set objPara = objCmd.CreateParameter ("staffID",3,1,0, strRecID)
	objCmd.Parameters.Append objPara
	set objPara = objCmd.CreateParameter ("exempt",3,1,0, 0)
	objCmd.Parameters.Append objPara
	set objPara = objCmd.CreateParameter ("remedial",3,1,0, 0)
	objCmd.Parameters.Append objPara
	set objPara = objCmd.CreateParameter ("expiryDate",135,1,8, NULL)
	objCmd.Parameters.Append objPara	
	
	objCmd.CommandText = "spUpdateExempt"	'Name of Stored Procedure'
	objCmd.Execute	'Execute CommandText when using "ADODB.Command" object'
	
	for x = 1 to objCmd.parameters.count
		objCmd.parameters.delete(0)
	next

	strList = Request("newAttached")
	strDateList = Request("newdatesAttached")
	strCompetentList = Request("newcompetentAttached")

	strNewStations = split(strList, ",")
	
	strNewdates = split(strDateList, ",")

	strNewcompetences = split(strCompetentList, ",")
	
	FOR intCount = LBound(strNewStations) TO (UBound(strNewStations))

		set objPara = objCmd.CreateParameter ("staffID",3,1,0, strRecID)
		objCmd.Parameters.Append objPara

		set objPara = objCmd.CreateParameter ("FitnessID",3,1,0, strNewStations(intCount))
		objCmd.Parameters.Append objPara

		set objPara = objCmd.CreateParameter ("validFrom",200,1,30, strNewDates(intCount))
		objCmd.Parameters.Append objPara
		set objPara = objCmd.CreateParameter ("competent",200,1,5, strNewcompetences(intCount))
		objCmd.Parameters.Append objPara
		
		objCmd.CommandText = "spInsertStaffFitness"	'Name of Stored Procedure'
		objCmd.Execute	'Execute CommandText when using "ADODB.Command" object'

		for x = 1 to objCmd.parameters.count
			objCmd.parameters.delete(0)
		next


	   'set comcommand=server.createobject("ADODB.command")
	   ''comcommand.CommandText = "INSERT INTO tblStaffFitness (StaffID,FitnessID,ValidFrom,Competent) VALUES ('"& strRecID & "'  , '" & strNewStations(intCount) & "'  , '" & strNewDates(intCount)& "'  , '" & strNewcompetences(intCount) &  "'" &  ")"
	   ''comcommand.Activeconnection = con
	   ''comcommand.Execute
	   ''response.write comcommand.CommandText
	   ''Set comcommand = Nothing'
	NEXT 
	
END IF
response.Redirect strGoTo
%>