<!DOCTYPE HTML >
<!--#include file="Includes/security.inc"--> 
<!--#include file="Connection/Connection.inc"-->
<%

Const Hidden = 2
competent = 0
Dim objUpload
Dim strFileName
Dim strPath
dim strFiles
dim strList
if request ("competent") = "True" then competent =1
'response.write competent & "," & request ("competent")

 if request("postID") <>"" then
	strRecID = request("postID")
	strGoTo = request("ReturnTo") & "?postID=" & strRecid 
else
	strRecID = request("RecID")
	strGoTo = request("ReturnTo") & "?RecID=" & strRecid 
end if




      'Update a new record 
	   set comcommand=server.createobject("ADODB.command")
	   comcommand.CommandText = "update tblPostMilSkill set status ='"& request("status") &"', competent= '" & competent &"' where PostMSID = '" & request("PostMSID") &"'"
	   comcommand.Activeconnection = con
	   comcommand.Execute
	   'response.write comcommand.CommandText
	   Set comcommand = Nothing
	
	'response.end

response.Redirect strGoTo
%>