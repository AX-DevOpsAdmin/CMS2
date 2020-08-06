<!DOCTYPE HTML >
<!--#include file="Includes/security.inc"--> 
<!--include file="Includes/checkadmin.asp"-->
<!--#include file="Connection/Connection.inc"-->
<%
set objCmd = server.CreateObject("ADODB.Command")
set objPara = server.CreateObject("ADODB.Parameter")
objCmd.ActiveConnection = con
objCmd.Activeconnection.cursorlocation = 3
objCmd.CommandText = "spRemAuthLims"	'Name of Stored Procedure'

Const Hidden = 2

Dim objUpload
Dim strFileName
Dim strPath
dim strFiles
dim strList

    strAuthorisor=session("staffID")
	strStaffID = request("staffID")
	strGoTo = request("ReturnTo") & "?staffID=" & strStaffID & "&atpID=" & request("atpID")

IF Request("newattached") <> "" THEN	
	strList = Request("newAttached")
	'strDateList = Request("newdatesAttached")

	strLimsID = split(strList, ",")	
		
	'response.write( strList & " * " & Request("newAttached") & " * " & strLimsID )
	'response.end()
		
	FOR intCount = LBound(strLimsID) TO (UBound(strLimsID))
	  	set objPara = objCmd.CreateParameter ("limsID",3,1,0, strLimsID(intCount))
		objCmd.Parameters.Append objPara
		set objPara = objCmd.CreateParameter ("authorisor",3,1,0, strAuthorisor)
		objCmd.Parameters.Append objPara
	
'		set objPara = objCmd.CreateParameter ("staffID",3,1,0, strStaffID)
'		objCmd.Parameters.Append objPara


		objCmd.Execute	'Execute CommandText when using "ADODB.Command" object'

		for x = 1 to objCmd.parameters.count
			objCmd.parameters.delete(0)
		next
	NEXT 
	'response.end'
END IF
response.Redirect strGoTo
%>