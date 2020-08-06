<!--<!DOCTYPE HTML >-->
<!--#include file="Includes/security.inc"--> 
<!--#include file="Connection/connection.inc" -->
<!--#include file="Includes/checkadmin.asp"-->
<!--#include file="Includes/adovbs.inc" -->

<%
  	dim cmdUpdateContact
	dim strEmailName
	dim strEmail
	dim strMilPhone
	dim strExt
	
	if request.form("txtEmailName") <> "" then
		strEmailName = request.form("txtEmailName")
	else
		strEmailName = NULL
	end if
	if request.form("txtEmail") <> "" then
		strEmail = request.form("txtEmail")
	else
		strEmail = NULL
	end if
	if request.form("txtMilPhone") <> "" then
		strMilPhone = request.form("txtMilPhone")
	else
		strMilPhone = NULL
	end if
	if request.form("txtExt") <> "" then
		strExt = request.form("txtExt")
	else
		strExt = Null
	end if
	
	set cmdUpdateContact = server.createobject("ADODB.Command")
	cmdUpdateContact.activeconnection = con		
	cmdUpdateContact.commandtext = "spContactUpdate"
	cmdUpdateContact.commandtype = adCmdStoredProc
	
	'Input Parameters
	cmdUpdateContact.Parameters.Append cmdUpdateContact.CreateParameter("@nodeID",3,1,0, nodeID)
	cmdUpdateContact.Parameters.Append cmdUpdateContact.CreateParameter("@EmailName", adVarChar, adParamInput, 30, strEmailName)
	cmdUpdateContact.Parameters.Append cmdUpdateContact.CreateParameter("@Email", adVarChar, adParamInput, 30, strEmail)
	cmdUpdateContact.Parameters.Append cmdUpdateContact.CreateParameter("@MilPhone", adVarChar, adParamInput, 10, strMilPhone)
	cmdUpdateContact.Parameters.Append cmdUpdateContact.CreateParameter("@Ext", adVarChar, adParamInput, 6, strExt)

	cmdUpdateContact.execute
						
	set cmdUpdateContact = nothing
						
	response.redirect("AdminContactList.asp")
%>