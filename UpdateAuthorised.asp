<!DOCTYPE HTML >
<!--#include file="Includes/security.inc"--> 
<!--#include file="Connection/Connection.inc"-->

<%
dim blnEnduring
dim blnContingent
dim strCommand
dim strAction
dim strGoTo

strGoTo = "HierarchyAuthorisations.asp?staffID=" & request("staffID") & "&startDate=" &  request("startDate")

strCommand = "spUpdateAuthorised"

'authID=request("staffID") 
if request("authlist") <> "" then strAuths = request("authlist") else strAuths = null
if request("apprvlist") <> "" then strApprvs = request("apprvlist") else strApprvs = null
'if request("authnotes") <> "" then strnotes = request("authnotes") else strnotes = null

'response.write("updateAuthorised "&"<br>")
'response.write(request("staffID")&"<br>")
'response.write(strAuths&"<br>")
'response.write(strApprvs&"<br>")
''response.write(strnotes&"<br>")
'response.end()

set objCmd = server.CreateObject("ADODB.Command")
set objPara = server.CreateObject("ADODB.Parameter")
objCmd.ActiveConnection = con
objCmd.CommandType = 4						'Code for Stored Procedure

' Now set the common parameters
set objPara = objCmd.createparameter("@staffID",3,1,0, request("staffID"))
objCmd.parameters.append objPara
set objPara = objCmd.createparameter("@authlist",200,1,8000, strAuths)
objCmd.parameters.append objPara
set objPara = objCmd.createparameter("@apprvlist",200,1,8000, strApprvs)
objCmd.parameters.append objPara
'set objPara = objCmd.createparameter("@noteslist",200,1,5000, strnotes)
'objCmd.parameters.append objPara


objCmd.CommandText = strCommand
objCmd.execute	'Execute CommandText when using "ADODB.Command" object

con.close
set con = nothing

 response.redirect(strGoTo)


%>
