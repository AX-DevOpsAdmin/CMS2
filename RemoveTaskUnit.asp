<!DOCTYPE HTML >
<!--#include file="Includes/security.inc"--> 
<!--#include file="Connection/Connection.inc"-->
<%

set objCmd = server.CreateObject("ADODB.Command")
set objPara = server.CreateObject("ADODB.Parameter")
objCmd.ActiveConnection = con
objCmd.Activeconnection.cursorlocation = 3

Const Hidden = 2

dim strGoTo

strRecID = request("RecID")
strGoTo = request("ReturnTo") & "?RecID=" & strRecid

if request("newattached") <> "" then
	
	strList = request("newAttached")
	strNewStations = split(strList, ",")
	
	for intCount = 1 to (ubound(strNewStations))
		objCmd.CommandText = "spTaskUnitsRemove"	
		objCmd.CommandType = 4				
		set objPara = objCmd.CreateParameter ("taskUnitID",3,1,0, strNewStations(intCount))
		objCmd.Parameters.Append objPara
		set rsRecSet = objCmd.execute	
		
		for x = 1 to objCmd.parameters.count
			objCmd.parameters.delete(0)
		next
	next
end if

response.Redirect strGoTo
%>
