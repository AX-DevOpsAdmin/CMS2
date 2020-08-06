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
    strCommand = "spAuthsUpdate"
    strGoTo = "AdminAuthListDetail.asp?authID=" & request("RecID")
elseif  strAction = "Add" then
    strCommand = "spAuthsInsert"
	strGoTo = "AdminAuthListAdd.asp"	
end if

if request("txtTask") <> "" then strTask = request("txtTask") else strTask = null
if request("txtReqs") <> "" then strReqs = request("txtReqs") else strReqs = null
if request("txtRef") <> "" then strRef = request("txtRef") else strRef = null


'if request("authclassID") = 1 then
'  strAuthClass="J"
'else
'  strAuthClass="K"
'end if

'response.write request("authapprv")
'response.end()

set objCmd = server.CreateObject("ADODB.Command")
set objPara = server.CreateObject("ADODB.Parameter")
objCmd.ActiveConnection = con
objCmd.CommandType = 4						'Code for Stored Procedure

' Here its UPDATE so pass the Record ID
if strAction = "Update" then
    set objPara = objCmd.createparameter("RecID",3,1,0, request("RecID"))
    objCmd.parameters.append objPara
else
    set objPara = objCmd.createparameter("nodeID",3,1,0,0)
    objCmd.parameters.append objPara

end if

classauth=0
if request("classauth") = "on" then
  classauth=1
end if

'response.Write( request("classauth") )
'response.End()

' Now set the common parameters
set objPara = objCmd.createparameter("@authcode",200,1,50, request("authCode"))
objCmd.parameters.append objPara
set objPara = objCmd.createparameter("@authclass",200,1,50, request("authclassID"))
objCmd.parameters.append objPara
set objPara = objCmd.createparameter("@atp",3,1,0, request("atpID"))
objCmd.parameters.append objPara
set objPara = objCmd.createparameter("@Amber",3,1,0, request("apprvID"))
objCmd.parameters.append objPara
set objPara = objCmd.createparameter("@task",200,1,2000, strTask)
objCmd.parameters.append objPara
set objPara = objCmd.createparameter("@reqs",200,1,2000, strReqs)
objCmd.parameters.append objPara
set objPara = objCmd.createparameter("@ref",200,1,2000, strRef)
objCmd.parameters.append objPara
set objPara = objCmd.CreateParameter("@classauth", 11, 1, 1, classauth)
objCmd.Parameters.Append objPara
set objPara = objCmd.CreateParameter("@authlvl", 200, 1, 50, request("authlevel"))
objCmd.Parameters.Append objPara

if strAction = "Add" then
	set objPara = objCmd.createparameter("@Exists",11,2,1, blnExists)
	objCmd.parameters.append objPara
end if

objCmd.CommandText = strCommand
objCmd.execute	'Execute CommandText when using "ADODB.Command" object


if strAction = "Add" then
   strError = objCmd.Parameters("@Exists")

   if strError = 1 then 
     response.Write("alert('!Save Failed \n - " & " This Authorisation already exists "&  request("authCode") &".')")
  end if
end if
 response.redirect(strGoTo)
'if strAction = "Add" then
'	response.redirect(strGoTo & "?err=" & strError & "&description=" & request("authCode"))
'elseif strAction = "Update" then
'	response.redirect(strGoTo)
'end if

con.close
set con = nothing

%>
