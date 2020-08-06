<!DOCTYPE HTML >

<!--#include file="Includes/security.inc"--> 
<!--#include file="Connection/Connection.inc"-->

<%

set objCmd = server.CreateObject("ADODB.Command")
set objPara = server.CreateObject("ADODB.Parameter")
objCmd.ActiveConnection = con
objCmd.Activeconnection.cursorlocation = 3

const Hidden = 2

dim strList

intQID = request("QID")
intQTypeID = request ("TypeID")
strQList = split(intQTypeID, "*")
intQTypeID = strQList(0)
strDateAttained = request("DateAttained")
strCompetent = request("Competent")
strAuth = null
strUpBy = null
strUpdated = null

if request("Auth") = "True" then
	strAuth = request("txtAuth")
	strUpBy = session("StaffID")
	strUpdated = date
end if

strGoTo = request("ReturnTo") & "?RecID=" & strRecid

if request("newattached") <> "" then
	
	set objCmd = server.CreateObject("ADODB.Command")
    set objPara = server.CreateObject("ADODB.Parameter")
    objCmd.ActiveConnection = con
    objCmd.Activeconnection.cursorlocation = 3

    objCmd.CommandText = "spAddStaffGroupQs"	
	objCmd.CommandType = 4				

	strList = request("newAttached")
	strNewStations = split(strList, ",")
	
	for intCount = 1 to (ubound(strNewStations))
		set objPara = objCmd.CreateParameter ("serviceno",200,1,50, strNewStations(intCount))
		objCmd.Parameters.Append objPara
		set objPara = objCmd.CreateParameter ("QTypeID",3,1,0, intQTypeID)
		objCmd.Parameters.Append objPara
	    set objPara = objCmd.CreateParameter ("QID",3,1,0, intQID)
		objCmd.Parameters.Append objPara
		set objPara = objCmd.CreateParameter ("QDate",200,1,20, strDateAttained)
		objCmd.Parameters.Append objPara
        set objPara = objCmd.CreateParameter ("QComp",200,1,20, strCompetent)
		objCmd.Parameters.Append objPara
        set objPara = objCmd.CreateParameter ("Auth",200,1,20, strAuth)
		objCmd.Parameters.Append objPara
        set objPara = objCmd.CreateParameter ("UpBy",3,1,4, strUpBy)
		objCmd.Parameters.Append objPara
        set objPara = objCmd.CreateParameter ("Updated",135,1,8, strUpdated)
		objCmd.Parameters.Append objPara

		objCmd.Execute
		for x = 1 to objCmd.parameters.count
			objCmd.parameters.delete(0)
		next
		
	   Set comcommand = Nothing
	next
end if

response.Redirect strGoTo
%>