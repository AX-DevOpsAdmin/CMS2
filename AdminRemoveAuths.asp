<!DOCTYPE HTML >
<!--#include file="Includes/security.inc"--> 
<!--include file="Includes/checkadmin.asp"-->
<!--#include file="Connection/Connection.inc"-->
<%
set objCmd = server.CreateObject("ADODB.Command")
set objPara = server.CreateObject("ADODB.Parameter")
objCmd.ActiveConnection = con
objCmd.Activeconnection.cursorlocation = 3
objCmd.CommandText = "spRemAuthorisor"	'Name of Stored Procedure'

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
	strAuthID = split(strList, ",")	
			
	FOR intCount = LBound(strAuthID) TO (UBound(strAuthID))

		set objPara = objCmd.CreateParameter ("authID",3,1,0, strAuthID(intCount))
		objCmd.Parameters.Append objPara	
		set objPara = objCmd.CreateParameter ("authorisor",3,1,0, strAuthorisor)
		objCmd.Parameters.Append objPara
		set objPara = objCmd.CreateParameter ("staffID",3,1,0, strStaffID)
		objCmd.Parameters.Append objPara

         'response.write( strList & " ** " & strAuthID(intCount) & " * " & strAuthorisor & " * " & strStaffID)
	     'response.end()
	


		objCmd.Execute	'Execute CommandText when using "ADODB.Command" object'

		for x = 1 to objCmd.parameters.count
			objCmd.parameters.delete(0)
		next
	NEXT 
	'response.end'
END IF

response.Redirect strGoTo
%>