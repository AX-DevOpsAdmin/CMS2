<!DOCTYPE HTML >

<!--#include file="Includes/security.inc"--> 
<!--#include file="Connection/Connection.inc"-->

<%
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

set objCmd = server.CreateObject("ADODB.Command")
set objPara = server.CreateObject("ADODB.Parameter")
objCmd.ActiveConnection = con
objCmd.Activeconnection.cursorlocation = 3
set objPara = objCmd.CreateParameter ("validFrom",200,1,30, request("dateAttained"))
objCmd.Parameters.Append objPara
set objPara = objCmd.CreateParameter ("competent",200,1,5, request("Competent"))
objCmd.Parameters.Append objPara
set objPara = objCmd.CreateParameter ("staffMVID",3,1,0, request("staffMVID"))
objCmd.Parameters.Append objPara

objCmd.CommandText = "spUpdateStaffVaccination"	'Name of Stored Procedure'
objCmd.Execute	'Execute CommandText when using "ADODB.Command" object'

response.Redirect strGoTo
%>