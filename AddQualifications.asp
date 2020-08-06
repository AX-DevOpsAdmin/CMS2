<!DOCTYPE HTML >
<!--#include file="Includes/security.inc"--> 
<!--include file="Includes/checkadmin.asp"-->
<!--#include file="Connection/Connection.inc"-->
<%

Const Hidden = 2

Dim objUpload
Dim strFileName
Dim strPath
dim strFiles
dim strList

strQTypeID = request ("QTypeID")
strGoTo = request("ReturnTo") & "?QTypeID=" & strQTypeID

if request("staffID") <>"" then
	strRecID = request("staffID")
	strGoTo = strGoTo & "&staffID=" & strRecid & "&thisDate=" & request("thisDate")
else
	strRecID = request("RecID")
	strGoTo = strGoTo & "&RecID=" & strRecid 
end if

IF Request("newattached") <> "" THEN
	
	set objCmd = server.CreateObject("ADODB.Command")
    set objPara = server.CreateObject("ADODB.Parameter")
    objCmd.ActiveConnection = con
    objCmd.Activeconnection.cursorlocation = 3

    objCmd.CommandText = "spAddStaffQs"	
	objCmd.CommandType = 4				

	strList = Request("newAttached")
	strDateList = Request("newdatesAttached")
	strCompetentList = Request("newcompetentAttached")
	strAuthList = Request("newauthattached")
	strUpByList = Request("newupbyattached")
	strUpdatedList = Request("newupdatedattached")
	
	if isNull(strAuthList) = true or strAuthList = "" then strAuthList = "null" end if
	if isNull(strUpByList) = true or strUpByList = "" then strUpByList = "null" end if
	if isNull(strUpdatedList) = true or strUpdatedList = "" then strUpdatedList = "null" end if
	
	strNewStations = split(strList, ",")	
	strNewdates = split(strDateList, ",")
	strNewcompetences = split(strCompetentList, ",")
	strNewAuth = split(strAuthList, ",")
	strNewUpBy = split(strUpByList, ",")
	strNewUpdated = split(strUpdatedList, ",")
	
'	response.Write("strList= "&strList&"<br>"&Request("newauthattached"))
'	response.Write("strDateList= "&strDateList&"<br>")
'	response.Write("strCompetentList= "&strCompetentList&"<br>")
'	response.Write("strAuthList= "&strAuthList&"<br>")
'	response.Write("strUpByList= "&strUpByList&"<br>")
'	response.Write("strUpdatedList= "&strUpdatedList&"<br>")
'	response.Write(UBound(strNewStations))
	'response.End()
	
	'FOR intCount = LBound(strNewStations) TO (UBound(strNewStations))
	FOR intCount = 0 TO (UBound(strNewStations))
		if strNewAuth(intCount) = "null" then
			strNewAuth(intCount) = NULL
		end if
		if strNewUpBy(intCount) = "null" then
			strNewUpBy(intCount) = NULL
		end if
		if strNewUpdated(intCount) = "null" then
			strNewUpdated(intCount) = NULL
		end if
		
		set objPara = objCmd.CreateParameter ("StaffID",3,1,0, strRecID)
		objCmd.Parameters.Append objPara
		set objPara = objCmd.CreateParameter ("QTypeID",3,1,0, request("QTypeID"))
		objCmd.Parameters.Append objPara
	    set objPara = objCmd.CreateParameter ("QID",3,1,0, strNewStations(intCount))
		objCmd.Parameters.Append objPara
		set objPara = objCmd.CreateParameter ("QDate",200,1,20, strNewDates(intCount))
		objCmd.Parameters.Append objPara
        set objPara = objCmd.CreateParameter ("QComp",200,1,20, strNewcompetences(intCount))
		objCmd.Parameters.Append objPara
        set objPara = objCmd.CreateParameter ("Auth",200,1,20, strNewAuth(intCount))
		objCmd.Parameters.Append objPara
        set objPara = objCmd.CreateParameter ("UpBy",3,1,0, strNewUpBy(intCount))
		objCmd.Parameters.Append objPara
        set objPara = objCmd.CreateParameter ("Updated",135,1,8, strNewUpdated(intCount))
		objCmd.Parameters.Append objPara
	    objCmd.Execute
	   
		for x = 1 to objCmd.parameters.count
			objCmd.parameters.delete(0)
		next

	   Set comcommand = Nothing
	NEXT 
	'response.end
END IF
response.Redirect strGoTo
%>