<!DOCTYPE HTML >

<!--#include file="Includes/security.inc"--> 
<!--include file="Includes/checkadmin.asp"-->
<!--#include file="Connection/Connection.inc"-->

<%
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

objCmd.CommandType = 4
objCmd.CommandText = "spUpdateRemedial"	'Name of Stored Procedure'

set objPara = objCmd.CreateParameter ("staffID",3,1,0, strRecID)
objCmd.Parameters.Append objPara
set objPara = objCmd.CreateParameter ("remedial",3,1,0, 1)
objCmd.Parameters.Append objPara
set objPara = objCmd.CreateParameter ("exempt",3,1,0, 0)
objCmd.Parameters.Append objPara
set objPara = objCmd.CreateParameter ("expiryDate",135,1,8, request("newexpirydateattached"))
objCmd.Parameters.Append objPara
objCmd.Execute	'Execute CommandText when using "ADODB.Command" object'

response.Redirect strGoTo
%>