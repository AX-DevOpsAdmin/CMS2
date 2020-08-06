<!DOCTYPE HTML >

<!--#include file="Includes/security.inc"--> 
<!--#include file="Connection/Connection.inc"-->

<%
if request("id") <> "" then
	intID = request("id")
else
	intID = 0
end if

if request("flag") <> "" then
	intFlag = request("flag")
else
	intFlag = 0
end if

'response.write(request("serviceNo") & " * ")
'response.end()
'response.write " Update Task Confirm " & request("ttID") & " ** " & request("RecID") & " * " & request("staffID") & " * " & strOOADays & " * " & session("staffID") & " * " & request("startDate") & " * " & request("endDate") & " * " & request("notes") & " * " & intID & " * " & intflag
'response.End()

set objCmd = server.CreateObject("ADODB.Command")
set objPara = server.CreateObject("ADODB.Parameter")
objCmd.ActiveConnection = con
objCmd.Activeconnection.cursorlocation = 3
objCmd.CommandText = "spTaskPersonnelAddAfterCheck"	
objCmd.CommandType = 4

set objPara = objCmd.CreateParameter ("node",3,1,0, session("nodeID"))
objCmd.Parameters.Append objPara	
set objPara = objCmd.CreateParameter ("TaskID",3,1,0, request("RecID"))
objCmd.Parameters.Append objPara
set objPara = objCmd.CreateParameter ("staffID",200,1,50, request("staffID"))
objCmd.Parameters.Append objPara
set objPara = objCmd.CreateParameter ("currentUser",3,1,0, session("staffID"))
objCmd.Parameters.Append objPara
set objPara = objCmd.CreateParameter ("StartDate",200,1,16, request("startDate"))
objCmd.Parameters.Append objPara
set objPara = objCmd.CreateParameter ("EndDate",200,1,16, request("endDate"))
objCmd.Parameters.Append objPara
set objPara = objCmd.CreateParameter ("notes",200,1,2000, request("notes"))
objCmd.Parameters.Append objPara
set objPara = objCmd.CreateParameter ("id",3,1,0, intID)
objCmd.Parameters.Append objPara		
set objPara = objCmd.CreateParameter ("flag",3,1,0, intFlag)
objCmd.Parameters.Append objPara

objCmd.Execute	
%>

<SCRIPT LANGUAGE="JavaScript">
	window.parent.refreshIframeAfterDateSelect("HierarchyTaskingView.asp");
</Script>

