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
strQTypeID = request ("QTypeID")
strGoTo = request("ReturnTo") & "?RecID=" & strRecid

IF Request("newattached") <> "" THEN
	
	strList = Request("newAttached")
	'response.write "IDs:" & strList & "Next:"
	strNewStations = split(strList, ",")
	
	FOR intCount = 1 TO (UBound(strNewStations))
  	  'strStation = split(strNewStations(intCount), "*")
	  'strCode = strStation(0)
	  'strDesc = strStation(1)
	  'response.write strCode & " " & strDesc
 	  'response.write strNewStations(intCount) & ","
      'Insert a new record setting the flag field to 1, to show that it doesn't need to be deleted

objCmd.CommandText = "spTeamPostRemove"	
objCmd.CommandType = 4				
set objPara = objCmd.CreateParameter ("TeamID",3,1,5, request("RecID"))
objCmd.Parameters.Append objPara
set objPara = objCmd.CreateParameter ("PostID",3,1,5, strNewStations(intCount))
objCmd.Parameters.Append objPara
set rsRecSet = objCmd.Execute	

for x = 1 to objCmd.parameters.count
	objCmd.parameters.delete(0)
next
	  'response.write comcommand.CommandText
	   Set comcommand = Nothing
	NEXT 
	'response.end
END IF
response.Redirect strGoTo
%>