<!DOCTYPE HTML >
<!--#include file="Includes/security.inc"--> 
<!--#include file="Connection/Connection.inc"-->
<%

dim strCommand
dim strAction
dim strGoTo

strGoTo=request("GoTo")

cancellable=1
if request("cancellable")="" or request("cancellable")=0 then cancellable=0

'response.write request("ooaTask")
'response.End()


' Now get the action required - we will want to ADD a NEW one or UPDATE an Existing one or DELETE one'
strAction=request("strAction")
if strAction = "Update" then
    strCommand = "sp_TaskUpdate"
    strGoTo = strGoTo & "?RecID=" & request("RecID") 
else 
    strCommand = "sp_TaskInsert"
	' 'strGoTo = "ManningTaskSearch.asp?dosearch=1&task=&ttID=1&startdate=&endDate="
end if 

'response.write request("sscID")
'response.end

set objCmd = server.CreateObject("ADODB.Command")
set objPara = server.CreateObject("ADODB.Parameter")
objCmd.ActiveConnection = con
objCmd.CommandText = strCommand
objCmd.CommandType = 4						'Code for Stored Procedure

' Here its UPDATE so pass the Record ID
if strAction = "Update" then
    set objPara = objCmd.CreateParameter ("TaskID",3,1,0, request("recID"))
    objCmd.Parameters.Append objPara
else  
' We're ADDING a new one so make sure the nodeID is set
    set objPara = objCmd.CreateParameter ("nodeID",3,1,0, nodeID)
    objCmd.Parameters.Append objPara
end if

' Now set the common parameters'

set objPara = objCmd.CreateParameter ("ttID",3,1,0, request("TypeID"))
objCmd.Parameters.Append objPara
set objPara = objCmd.CreateParameter ("description",200,1,50, request("task"))
objCmd.Parameters.Append objPara
'set objPara = objCmd.CreateParameter ("startDate",200,1,16, request("startDate"))
'objCmd.Parameters.Append objPara
'set objPara = objCmd.CreateParameter ("endDate",200,1,16, request("endDate"))
'objCmd.Parameters.Append objPara
set objPara = objCmd.CreateParameter ("cancellable",3,1,0, cancellable)
objCmd.Parameters.Append objPara
set objPara = objCmd.CreateParameter ("ooa",3,1,0, request("ooaTask"))
objCmd.Parameters.Append objPara
set objPara = objCmd.CreateParameter ("ssc",3,1,0, request("sscID"))
objCmd.Parameters.Append objPara
set objPara = objCmd.CreateParameter ("hq",3,1,0, request("hqTask"))
objCmd.Parameters.Append objPara

'response.write request("ooaTask")
'response.End()

objCmd.Execute	'Execute CommandText when using "ADODB.Command" object

con.close
set con=Nothing
response.redirect(strGoTo)
%>
