<!DOCTYPE HTML >
<!--#include file="Connection/Connection.inc"-->
<%
' This is the delete for Operational Tasks - we also need to make sure we have deleted any attached files

'response.write request("ParentID")
dim strCommand
dim strAction
dim strGoTo

Const Hidden = 2

Dim objUpload
Dim strFileName
Dim strPath
dim strFiles
dim strList

strRecID = request("RecID")
'strGoTo = request("ReturnTo") & "?RecID=" & strRecid
strGoTo = request("GoTo") 

strList = request("RemFiles")

'response.write strList 
'response.End()


strFiles = split(strList, ",")

Set oFSO = Server.CreateObject("Scripting.FileSystemObject")

FOR intCount = LBound(strFiles) TO (UBound(strFiles))
   strPath = Server.MapPath("Upload/"  & strFiles(intcount))
   oFSO.DeleteFile(strPath)
   'response.write strPath
NEXT

' Release upload object from memory and redirect, no errors
Set oFSO = Nothing

'response.write strGoTo
'response.End()

'/***********************************************/

strCommand = "spDeleteRec"
set objCmd = server.CreateObject("ADODB.Command")
set objPara = server.CreateObject("ADODB.Parameter")
objCmd.ActiveConnection = con
objCmd.CommandText = strCommand
objCmd.CommandType = 4						

set objPara = objCmd.CreateParameter ("TeamID",3,1,0, request("RecID"))
    objCmd.Parameters.Append objPara
	strparam = objpara
set objPara = objCmd.CreateParameter ("TableId",200,1,50, request("TabID"))
    objCmd.Parameters.Append objPara	
	strParam = strparam & " ** " & objpara
set objPara = objCmd.CreateParameter ("TableName",200,1,50, request("TableName"))
    objCmd.Parameters.Append objPara	

strParam = strparam & " *** " & objpara
'response.write strParam
'response.End()

objCmd.Execute	'Execute CommandText when using "ADODB.Command" object

con.close
set con=Nothing

response.redirect(strGoTo)
%>
