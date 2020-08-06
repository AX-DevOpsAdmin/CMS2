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

'response.write strGoTo & " * " &  Request("newattached") '("Staff ID is " & request("staffID") & " * " & request("ReturnTo") & " * " & request("thisDate"))
'response.End()

IF Request("newattached") <> "" THEN
	
	strList = Request("newAttached")
	strDateList = Request("newdatesAttached")
	strCompetentList = Request("newcompetentAttached")

	strNewStations = split(strList, ",")
	
	strNewdates = split(strDateList, ",")

	strNewcompetences = split(strCompetentList, ",")
	
	FOR intCount = LBound(strNewStations) TO (UBound(strNewStations))

		set objPara = objCmd.CreateParameter ("staffID",3,1,0, strRecID)
		objCmd.Parameters.Append objPara

		set objPara = objCmd.CreateParameter ("MVID",3,1,0, strNewStations(intCount))
		objCmd.Parameters.Append objPara

		set objPara = objCmd.CreateParameter ("validFrom",200,1,30, strNewDates(intCount))
		objCmd.Parameters.Append objPara
		set objPara = objCmd.CreateParameter ("competent",200,1,5, strNewcompetences(intCount))
		objCmd.Parameters.Append objPara
		
		objCmd.CommandText = "spInsertStaffVaccination"	'Name of Stored Procedure'
		objCmd.Execute	'Execute CommandText when using "ADODB.Command" object'

		for x = 1 to objCmd.parameters.count
			objCmd.parameters.delete(0)
		next
	NEXT 
	'response.end
END IF
response.Redirect strGoTo
%>