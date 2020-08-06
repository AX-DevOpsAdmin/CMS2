<%@LANGUAGE="VBSCRIPT" CODEPAGE="1252"%>

<!--#include file="Connection/Connection.inc"-->
<!--#include file="includes/adovbs.inc" -->

<%
	set objCmd = Server.CreateObject("ADODB.Command")
	set objCmd.ActiveConnection = con
	ObjCmd.CommandType = AdCmdStoredProc
	ObjCmd.CommandText = "spChangePassword"		
	ObjCmd.Parameters.Append ObjCmd.CreateParameter("@StaffID", adInteger, adParamInput, 4, session("StaffID"))
	ObjCmd.Parameters.Append ObjCmd.CreateParameter("@pswd", adVarChar, adParamInput, 10, request("password"))
	ObjCmd.Parameters.Append ObjCmd.CreateParameter("@pswdExp", adInteger, adParamOutput,4)
	ObjCmd.Parameters.Append ObjCmd.CreateParameter("@error", adInteger, adParamOutput,4)
	ObjCmd.execute
	'1. check if password is the same as the old one. If so then return to change password page.
	if ObjCmd.Parameters("@error") = 1 then
		response.Redirect("changepw.asp?error=3")
	else
	session("SignInFlag") = 1
	session("pswdExp") = ObjCmd.Parameters("@pswdExp") 
		if session("CMS2CMSLogIn") = "TRUE" then
			response.redirect "index.asp"
		else
			session("CMS2CMSLogIn") = "TRUE"
			response.redirect "index.asp"
		end if
	end if
	
%>
