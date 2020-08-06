<!DOCTYPE HTML >

<!--#include file="Connection/Connection.inc"-->

<%
dim strCommand
dim strGoTo
strCommand = "spStaffPostUpdate"
strGoTo = "hierarchyPostDetail.asp?postID="& request("PostID")

if request("endDate") <> "" then
	strEndDate = request("endDate")
else
	strEndDate = NULL
end if  

' 'response.write strGoTo & " * " & strID1 & " * " & strID2 & " * " & request("startDate") & " * " & strEndDate
' 'response.End()

set objCmd = server.CreateObject("ADODB.Command")
set objPara = server.CreateObject("ADODB.Parameter")
objCmd.ActiveConnection = con
objCmd.CommandText = strCommand
objCmd.CommandType = 4						'Code for Stored Procedure'

set objPara = objCmd.CreateParameter ("PostID",3,1,0, request("PostID"))
objCmd.Parameters.Append objPara
set objPara = objCmd.CreateParameter ("StaffID",3,1,0, request("staffID"))
objCmd.Parameters.Append objPara
set objPara = objCmd.CreateParameter ("startDate",200,1,12, request("startDate"))
objCmd.Parameters.Append objPara
set objPara = objCmd.CreateParameter ("endDate",200,1,12, strEndDate)
objCmd.Parameters.Append objPara

objCmd.Execute	' 'Execute CommandText when using "ADODB.Command" object

con.close
set con=Nothing
response.write request("strGoTo")
response.redirect(strGoTo)
%>
