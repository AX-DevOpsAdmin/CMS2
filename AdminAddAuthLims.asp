<!DOCTYPE HTML >
<!--#include file="Includes/security.inc"--> 
<!--include file="Includes/checkadmin.asp"-->
<!--#include file="Connection/Connection.inc"-->
<!--#include file="Includes/authsecurity.inc"--> 

<%

set objCmd = server.CreateObject("ADODB.Command")
set objPara = server.CreateObject("ADODB.Parameter")
objCmd.ActiveConnection = con
objCmd.Activeconnection.cursorlocation = 3
objCmd.CommandType = 4

objCmd.CommandText = "spAddAuthLims"

dim strList

    strAuthorisor=session("staffID")
	strStaffID = request("staffID")
	strAuthLevel = request("authlevel")
	strGoTo = request("ReturnTo") & "?staffID=" & strStaffID & "&atpID=" & request("atpID")

IF Request("newattached") <> "" THEN	

	strList = Request("newAttached")
	
	strAuthLim = split(strList, ",")	

	FOR intCount =  LBound(strAuthLim) TO (UBound(strAuthLim))
	   ' strDates=split(strNewdates(intCount), "|")
	   ' strDateFrom=strDates(0)
	   ' strDateTo=strDates(1)

		set objPara = objCmd.CreateParameter ("staffID",3,1,0, strStaffID)
		objCmd.Parameters.Append objPara

		set objPara = objCmd.CreateParameter ("authID",3,1,0, strAuthLim(intCount))
		objCmd.Parameters.Append objPara

		set objPara = objCmd.CreateParameter ("authlevel",3,1,0, strAuthLevel)
		objCmd.Parameters.Append objPara

		set objPara = objCmd.CreateParameter ("authorisor",3,1,0, strAuthorisor)
		objCmd.Parameters.Append objPara
	        
        objCmd.Execute
		
		for x = 1 to objCmd.parameters.count
			objCmd.parameters.delete(0)
		next

	NEXT 

END IF

response.Redirect strGoTo
%>