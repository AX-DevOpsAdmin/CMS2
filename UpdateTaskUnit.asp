<!DOCTYPE HTML >

<!--#include file="Includes/security.inc"--> 
<!--#include file="Connection/Connection.inc"-->

<%
set objCmd = server.CreateObject("ADODB.Command")
set objPara = server.CreateObject("ADODB.Parameter")
objCmd.ActiveConnection = con
objCmd.Activeconnection.cursorlocation = 3
	
Const Hidden = 2

dim strRecId
dim strGoTo
dim strList
dim strTaskThis

strRecID = request("RecID")
strGoTo = request("ReturnTo") & "?RecID=" & strRecid & "&StartDate=" & request("startDate") & "&EndDate=" & request("endDate")

if Request("newattached") <> "" then
	strList = request("newAttached")
	strTaskThis = split(strList, ",")

	for intCount = lbound(strTaskThis) to (ubound(strTaskThis))	   
		objCmd.CommandText = "spTaskUnitAdd"	
		objCmd.CommandType = 4
						
		set objPara = objCmd.CreateParameter ("TaskID",3,1,0, request("RecID"))
		objCmd.Parameters.Append objPara
		set objPara = objCmd.CreateParameter ("currentUser",3,1,0, strTaskThis(intCount))
		objCmd.Parameters.Append objPara
		set objPara = objCmd.CreateParameter ("StartDate",135,1,8, request("startDate"))
		objCmd.Parameters.Append objPara
		set objPara = objCmd.CreateParameter ("EndDate",135,1,8, request("endDate"))
		objCmd.Parameters.Append objPara
		set objPara = objCmd.CreateParameter ("notes",200,1,2000, request("notes"))
		objCmd.Parameters.Append objPara
		set objPara = objCmd.CreateParameter ("currentUser",3,1,0, session("staffID"))
		objCmd.Parameters.Append objPara
		objCmd.execute	
				
		'response.write userAddedStatus
		for x = 1 to objCmd.parameters.count
			objCmd.parameters.delete(0)
		next
	next
end if
	
response.redirect(strGoTo)
%>
