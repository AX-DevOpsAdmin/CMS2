<!DOCTYPE HTML >
<!--#include file="Connection/Connection.inc"-->
<%
' Updates team record with Cycle details 

' COMMAND Variables
dim adCmdText
dim adCmdStoredProc
dim adVarChar
dim adInteger
dim adParamInput 
dim setParm

' set COMMAND variable defaults
adCmdText = 1
adCmdStoredProc = 4
adVarChar = 200
adInteger = 3
adParamInput = 1

'response.write request("ParentID")
dim strCommand
dim strAction
dim strGoTo
dim strSQL
dim strStartDate
dim strCyID
dim strCysID
dim strList

strStartDate = request("T1")
strCyID = request("cmbCycle")
strList = split(request("cmbStage"), "*")
strCysID = strList(1)
'strGoTo = "AdminTeamDetail.asp?recID=" & request("recID")
strGoTo = request("goTo") & "?recID=" & request("recID")

strSQL = "SET DATEFORMAT dmy UPDATE tblTeam SET tblTeam.cycleID = '" & strCyID & "', tblTeam.firstStage = '" & strCysID & "', tblTeam.cycleStart = '" & strStartDate & "' WHERE tblTeam.teamID = '" & request("recID") & "'"

set objCmd = server.CreateObject("ADODB.Command")
set objPara = server.CreateObject("ADODB.Parameter")
objCmd.ActiveConnection = con
objCmd.CommandText = strSQL
objCmd.CommandType = 1
'objCmd.CommandType = adCmdText
objCmd.prepared = false
objCmd.Execute	'Execute CommandText when using "ADODB.Command" object

con.close
set con=Nothing

'response.write strSQL
'response.End()

response.redirect(strGoTo)

' *****************************************************
'objCmd.CommandText = 
' "UPDATE tblUser SET userName = '" &strName&"', userRankID = '" &intRankID& "', userLocationID = '"&strLocation& "',  userSectionID = '" &strSection& "', userEmail = '" &stremail& "', userStatus = '" & strStatus & "'  WHERE tblUser.userNumber = '"&intUserNum& "'"

%>
