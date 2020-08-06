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

strGoTo = request("ReturnTo") '& "?RecID=" & strRecid & "&QTypeID=" & strQTypeID'

if request("postID") <>"" then
	strRecID = request("postID")
	strGoTo = strGoTo & "?postID=" & strRecid 
else
	strRecID = request("RecID")
	strGoTo = strGoTo & "?RecID=" & strRecid 
end if

IF Request("newattached") <> "" THEN
	
	strList = Request("newAttached")
	strStatusList = Request("newStatusAttached")
	strCompetentList = Request("newCompetentAttached")
	
	'response.write strList & " * " & strStatusList & " ** " & strCompetentList

	'response.write "IDs:" & strList'
	'response.write "Status:" & strStatusList'
	'response.write "Competents:" & strCompetentList'

	strNewStations = split(strList, ",")
	
	strNewStatus = split(strStatusList, ",")

	strNewCompetences = split(strCompetentList, ",")
	FOR intCount = LBound(strNewStations) TO (UBound(strNewStations))
		if strNewcompetences(intCount) = "True" then currentCompetence=1
		if strNewcompetences(intCount) = "False" then currentCompetence=0
	   set comcommand=server.createobject("ADODB.command")
	   comcommand.CommandText = "INSERT INTO tblPostMilSkill (PostID,MSID,Status,Competent) VALUES ('"& strRecID &"'  , '"  & strNewStations(intCount) & "'  , '" & strNewStatus(intCount)& "'  , '" & currentCompetence&"'" &  ")"
	   comcommand.Activeconnection = con
	   comcommand.Execute
	   Set comcommand = Nothing
		'response.write "test:" & currentCompetence
	NEXT 
END IF
response.Redirect strGoTo
%>