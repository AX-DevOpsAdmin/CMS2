<!DOCTYPE HTML >
<!--#include file="Includes/security.inc"--> 
<!--#include file="Includes/checkadmin.asp"-->
<!--#include file="Connection/Connection.inc"-->
<%

Const Hidden = 2

Dim objUpload
Dim strFileName
Dim strPath
dim strFiles
dim strList

strRecID = request("RecID")

strGoTo = request("ReturnTo") & "?RecID=" & strRecid 

' set basic commands
strCommand = "spAddCyStages"
set objCmd = server.CreateObject("ADODB.Command")
set objPara = server.CreateObject("ADODB.Parameter")
objCmd.ActiveConnection = con
objCmd.CommandType = 4		

set objPara = objCmd.CreateParameter ("RecID",3,1,5, request("RecID"))
objCmd.Parameters.Append objPara
set objPara = objCmd.CreateParameter ("TableID",200,1,50, Request("newattached"))
objCmd.Parameters.Append objPara

objCmd.CommandText = strCommand
set rsCySteps = objCmd.Execute

response.Redirect strGoTo
%>