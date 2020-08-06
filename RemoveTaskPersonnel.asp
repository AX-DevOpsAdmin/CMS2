<!DOCTYPE HTML >
<!--#include file="Includes/security.inc"--> 
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

strRecID = request("RecID")
strGoTo = request("ReturnTo") & "?RecID=" & strRecid

IF Request("newattached") <> "" THEN
	
	strList = Request("newAttached")
'	strList = replace (strList,"*","")
	strNewStations = split(strList, ",")
'	response.write strNewStations(1)
	
	FOR intCount = 1 TO (UBound(strNewStations))

		objCmd.CommandText = "spTaskPersonnelRemove"	
		objCmd.CommandType = 4				
		set objPara = objCmd.CreateParameter ("TaskID",3,1,0, request("RecID"))
		objCmd.Parameters.Append objPara
		set objPara = objCmd.CreateParameter ("taskStaffID",3,1,0, strNewStations(intCount))
		objCmd.Parameters.Append objPara
		set rsRecSet = objCmd.Execute	
		
		for x = 1 to objCmd.parameters.count
			objCmd.parameters.delete(0)
		next
	NEXT 
END IF
	
response.Redirect strGoTo
%>
