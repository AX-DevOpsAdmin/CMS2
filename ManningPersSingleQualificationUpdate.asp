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

strQTypeID = request("QTypeID")
strGoTo = request("ReturnTo") & "?QTypeID=" & strQTypeID

strAuth = null
strUpBy = null
strUpdated = null
 
if request("staffID") <>"" then
	strRecID = request("staffID")
	strGoTo = strGoTo & "&staffID=" & strRecid & "&thisDate=" & request("thisDate")
else
	strRecID = request("RecID")
	strGoTo = strGoTo & "&RecID=" & strRecid 
end if

if request("txtAuth") <> "" then
	strAuth = request("txtAuth")
	strUpBy = session("StaffID")
	strUpdated = date
end if

set objCmd = server.CreateObject("ADODB.Command")
set objPara = server.CreateObject("ADODB.Parameter")
objCmd.ActiveConnection = con
objCmd.Activeconnection.cursorlocation = 3
set objPara = objCmd.CreateParameter ("validFrom",200,1,20, request("dateAttained"))
objCmd.Parameters.Append objPara
set objPara = objCmd.CreateParameter ("competent",200,1,5, request("Competent"))
objCmd.Parameters.Append objPara
set objPara = objCmd.CreateParameter ("StaffQID",3,1,0, request("staffQID"))
objCmd.Parameters.Append objPara
set objPara = objCmd.CreateParameter ("Auth",200,1,20, strAuth)
objCmd.Parameters.Append objPara
set objPara = objCmd.CreateParameter ("UpBy",3,1,0, strUpBy)
objCmd.Parameters.Append objPara
set objPara = objCmd.CreateParameter ("Updated",135,1,8, strUpdated)
objCmd.Parameters.Append objPara


objCmd.CommandText = "spUpdateStaffQ"	'Name of Stored Procedure'
objCmd.Execute	'Execute CommandText when using "ADODB.Command" object'

response.Redirect strGoTo
%>