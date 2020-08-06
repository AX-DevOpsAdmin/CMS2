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

stratpID = request ("atpID")
strGoTo = request("ReturnTo") 

if request("staffID") <>"" then
	strRecID = request("staffID")
	strGoTo = strGoTo & "?staffID=" & strRecid & "&thisDate=" & request("thisDate")
else
	strRecID = request("RecID")
	strGoTo = strGoTo & "?RecID=" & strRecid 
end if

IF Request("newattached") <> "" THEN
	
	set objCmd = server.CreateObject("ADODB.Command")
    set objPara = server.CreateObject("ADODB.Parameter")
    objCmd.ActiveConnection = con
    objCmd.Activeconnection.cursorlocation = 3

    objCmd.CommandText = "spStaffAuthsAdd"	
	objCmd.CommandType = 4				

	strList = Request("newAttached")
	strDateList = Request("newdatesAttached")
	strAuthList = Request("newauthsattached")
	
	'if isNull(strAuthList) = true or strAuthList = "" then strAuthList = "null" end if	
	strNewStations = split(strList, ",")	
	strNewdates = split(strDateList, ",")
	strNewAuth = split(strAuthList, ",")
	
	response.Write("strList= "&strList&"<br>"&Request("newauthattached"))
	response.Write("strDateList= "&strDateList&"<br>")
'	response.Write("strCompetentList= "&strCompetentList&"<br>")
	response.Write("strAuthList= "&strAuthList&"<br>")
	response.Write("strDateList= "&strDateList&"<br>")
	response.Write("strGoTo= "&strGoTo&"<br>")
'	response.Write(UBound(strNewStations))
	'response.End()
	
	' adminID ,admindate  ,staffID  ,startdate   ,enddate   ,authID ,authorisor  ,authOK  ,authdate  ,approver  ,apprvOK  ,apprvdate  ,ndeID
	
	' staffID, adminID, authID, startdate, enddate ,authorisor, ndeID
	
	strAdmin=session("StaffID")   ' this is the authoriser
	
	FOR intCount = 0 TO (UBound(strNewStations))

		strDates = split(strNewdates(intCount), "|")
		
		set objPara = objCmd.CreateParameter ("StaffID",3,1,0, strRecID)
		objCmd.Parameters.Append objPara
		set objPara = objCmd.CreateParameter ("admin",3,1,0, strAdmin)
		objCmd.Parameters.Append objPara
	    set objPara = objCmd.CreateParameter ("authID",3,1,0, strNewStations(intCount)) ' The record from tblAuths being requested 
		objCmd.Parameters.Append objPara
		set objPara = objCmd.CreateParameter ("sdate",200,1,20, strDates(0))
		objCmd.Parameters.Append objPara
		set objPara = objCmd.CreateParameter ("edate",200,1,20, strDates(1))
		objCmd.Parameters.Append objPara

        set objPara = objCmd.CreateParameter ("Authorisor",200,1,20, strNewAuth(intCount))    ' The staff member requested to authorise this
		objCmd.Parameters.Append objPara

		set objPara = objCmd.CreateParameter ("nodeID",3,1,0, nodeID)
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