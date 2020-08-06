<!DOCTYPE HTML >
<!--#include file="Includes/security.inc"--> 
<!--#include file="Connection/Connection.inc"-->
<%

set objCmd = server.CreateObject("ADODB.Command")
set objPara = server.CreateObject("ADODB.Parameter")
objCmd.ActiveConnection = con
objCmd.Activeconnection.cursorlocation = 3

Const Hidden = 2
dim taskStaffID
dim taskStaffIDWithComma
dim intCount

strRecID = request("staffID")
strGoTo = request("ReturnTo") & "?staffID=" & strRecid & "&thisDate=" & request("thisDate")

taskStaffIDWithComma = request("taskStaffID")
'response.write taskStaffIDWithComma
taskStaffID = split(taskStaffIDWithComma, ",")
'response.write taskStaffID
IF Request("taskStaffID") <> "" THEN
	
	FOR intCount = 0 TO (UBound(taskStaffID))

		objCmd.CommandText = "spPersUntask"	
		objCmd.CommandType = 4				
		set objPara = objCmd.CreateParameter ("taskStaffID",3,1,0, taskStaffID(intCount))
		objCmd.Parameters.Append objPara
		objCmd.Execute	
		response.write taskStaffID(intCount)		
		for x = 1 to objCmd.parameters.count
			objCmd.parameters.delete(0)
		next
	NEXT 
	'response.end'
END IF

'response.write taskStaffIDWithComma & "," & UBound(taskStaffID)
response.Redirect strGoTo
%>
