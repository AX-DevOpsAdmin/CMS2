<!DOCTYPE HTML >
<!--#include file="Includes/security.inc"--> 
<!--#include file="Connection/Connection.inc"-->

<%
dim blnEnduring
dim blnContingent
dim strCommand
dim strAction
dim strGoTo

' Now get the action required - we will want to ADD a NEW one or UPDATE an Existing one or DELETE one
strAction=request("strAction")
if strAction = "Update" then
    strCommand = "spQUpdate"
    strGoTo = "AdminQListDetail.asp?QID=" & request("RecID")
elseif  strAction = "Add" then
    strCommand = "spQInsert"
	strGoTo = "AdminQListAdd.asp"	
end if

intQType = split(request("cboQType"), "*")
if request("chkEnduring") = 0 then blnEnduring = 0 else blnEnduring = 1
if request("chkContingent") = 0 then blnContingent = 0 else blnContingent = 1
if request("txtLongDesc") <> "" then strLongDesc = request("txtLongDesc") else strLongDesc = null

'response.write(strLongDesc)
'response.end()

set objCmd = server.CreateObject("ADODB.Command")
set objPara = server.CreateObject("ADODB.Parameter")
objCmd.ActiveConnection = con
objCmd.CommandText = strCommand
objCmd.CommandType = 4						'Code for Stored Procedure

' Here its UPDATE so pass the Record ID
if strAction = "Update" then
    set objPara = objCmd.createparameter("RecID",3,1,0, request("RecID"))
    objCmd.parameters.append objPara
else
    set objPara = objCmd.createparameter("nodeID",3,1,0,nodeID)
    objCmd.parameters.append objPara

end if

' Now set the common parameters
set objPara = objCmd.createparameter("@Description",200,1,50, request("txtDescription"))
objCmd.parameters.append objPara
set objPara = objCmd.createparameter("@QTypeID",3,1,4, intQType(0))
objCmd.parameters.append objPara
set objPara = objCmd.createparameter("@vpID",3,1,4, request("cboVPeriod"))
objCmd.parameters.append objPara
set objPara = objCmd.createparameter("@Amber",3,1,4, request("txtAmberDays"))
objCmd.parameters.append objPara
set objPara = objCmd.createparameter("@Enduring",11,1,1, blnEnduring)
objCmd.parameters.append objPara
set objPara = objCmd.createparameter("@Description",11,1,1, blnContingent)
objCmd.parameters.append objPara
set objPara = objCmd.createparameter("@LongDesc",200,1,300, strLongDesc)
objCmd.parameters.append objPara

if strAction = "Add" then
	set objPara = objCmd.createparameter("@Exists",11,2,1, blnExists)
	objCmd.parameters.append objPara
end if

objCmd.execute	'Execute CommandText when using "ADODB.Command" object

con.close
set con = nothing

response.redirect(strGoTo)
%>
