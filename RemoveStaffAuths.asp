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

'if request("staffID") <>"" then
	strRecID = request("staffID")
	strGoTo = request("ReturnTo") & "?staffID=" & strRecid & "&thisDate=" & request("thisDate")
'else
'	strRecID = request("RecID")
'	strGoTo = request("ReturnTo") & "?RecID=" & strRecid 
'end if

IF Request("newattached") <> "" THEN
	
	set objCmd = server.CreateObject("ADODB.Command")
    set objPara = server.CreateObject("ADODB.Parameter")
    objCmd.ActiveConnection = con
    objCmd.Activeconnection.cursorlocation = 3

    objCmd.CommandText = "spStaffAuthsDelete"	
	objCmd.CommandType = 4				

	strList = Request("newAttached")
	'response.write "test" & strList
	strNewStations = split(strList, ",")
	
	FOR intCount = LBound(strNewStations) TO (UBound(strNewStations))
	
		set objPara = objCmd.CreateParameter ("StaffID",3,1,0, loginID)
    	objCmd.Parameters.Append objPara

		set objPara = objCmd.CreateParameter ("admin",3,1,0, strNewStations(intCount))
		objCmd.Parameters.Append objPara

	    objCmd.Execute
	   
		for x = 1 to objCmd.parameters.count
		    'response.write loginID & " ** " & strNewStations(intCount) & " *** " 
			objCmd.parameters.delete(0)
		next

'	   set comcommand=server.createobject("ADODB.command")
'	   comcommand.CommandText = "Delete tblStaffMilSkill where staffMSID=" & strNewStations(intCount)
'	   comcommand.Activeconnection = con
'	   comcommand.Execute
'	   'response.write comcommand.CommandText
'	   Set comcommand = Nothing
	NEXT 
	'response.end
END IF
response.Redirect strGoTo
%>