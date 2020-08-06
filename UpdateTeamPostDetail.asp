<!DOCTYPE HTML >
<!--#include file="Connection/Connection.inc"-->
<%

TeamID=request("TeamID")

set objCmd = server.CreateObject("ADODB.Command")
set objPara = server.CreateObject("ADODB.Parameter")
objCmd.ActiveConnection = con
objCmd.CommandText = "spPostManagerUpdate"
objCmd.CommandType = 4						'Code for Stored Procedure

' Here its UPDATE so pass the Record ID
    set objPara = objCmd.CreateParameter ("PostID",3,1,0, request("recID"))
    objCmd.Parameters.Append objPara
 ' Now set the common parameters'

set objPara = objCmd.CreateParameter ("Manager",3,1,0, request("Manager"))
objCmd.Parameters.Append objPara
set objPara = objCmd.CreateParameter ("tmLevelID",3,1,0, request("tmLevelID"))
objCmd.Parameters.Append objPara
set objPara = objCmd.CreateParameter ("tmLevel",3,1,0, request("tmLevel"))
objCmd.Parameters.Append objPara

objCmd.Execute	'Execute CommandText when using "ADODB.Command" object

con.close
set con=Nothing
response.redirect("ManningTeamPosts.asp?RecID="+TeamID)
%>
