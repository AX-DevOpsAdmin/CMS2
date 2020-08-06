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
	
	strList = Request("newAttached")
	response.write "test" & strList
	strNewStations = split(strList, ",")
	
	FOR intCount = LBound(strNewStations) TO (UBound(strNewStations))
  	  'strStation = split(strNewStations(intCount), "*")
	  'strCode = strStation(0)
	  'strDesc = strStation(1)
	   'response.write strCode & " " & strDesc
 		'response.write strNewStations(intCount)
      'Insert a new record setting the flag field to 1, to show that it doesn't need to be deleted
	   set comcommand=server.createobject("ADODB.command")
	   comcommand.CommandText = "Delete tblStaffQs where staffQID=" & strNewStations(intCount)
	   comcommand.Activeconnection = con
	   comcommand.Execute
	   'response.write comcommand.CommandText
	   Set comcommand = Nothing
	NEXT 
	'response.end
END IF
response.Redirect strGoTo
%>