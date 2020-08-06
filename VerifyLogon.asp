<%@LANGUAGE="VBSCRIPT" CODEPAGE="1252"%>
<!--#include file="includes/adovbs.inc" -->
<!--#include file="includes/md5.asp" -->

<%
' NB: ALL CMS version now run the default Web Site - Air_CMS2 so this means we only have ONE set
' of web pages to maintain - BUT - there is still a separate DBase for each site so in order to ensure we log-on
' to the correct site each instance now has a unique logon.asp that runs when a user logs on. This logon.asp is held
' in the asps directory of the target website eg: Air_lemmingCMS/asps/logon.asp and it is the ONLY program that runs in that directory 

dim strSQL ' SQL string to run against database
dim strName
dim strRank
dim intRankID
dim strNum
dim strLocation
dim strSection
dim strUnit
dim strValues
dim strChar
dim stationid
dim strADD
dim newUser
dim strStatus
dim strToday
'dim strDSN

' first get the DSN connection so we know which database we're connecting to cos
' this is now the Air_CMS2 logon.asp for ALL instances and NOT just 90SU 
' CMS gets the DSN from the tblStaffNode and tblNode in the 90SUCMS database
' so we need to connect to that first to get the data then drop the connection
' and carry on as normal
strNum = Cstr(request.form("usernum"))
strpassword = trim(request("txtpasswd"))

' NB - COMMENTED OUT FOR DEVELOPMENT ONLY
 Set con = Server.CreateObject("ADODB.Connection") 'Create a connection object  
 con.Open "DSN=90SUDev"
 
 set objCmd = Server.CreateObject("ADODB.Command")
 set objCmd.ActiveConnection = con
 ObjCmd.CommandType = AdCmdStoredProc
 ObjCmd.CommandText = "spGetDSN"	
 
 ObjCmd.Parameters.Append ObjCmd.CreateParameter("@ServiceNo", adVarChar, adParamInput, 20, strNum)	
 ObjCmd.Parameters.Append ObjCmd.CreateParameter("@dsn", adVarChar, adParamOutput, 20)
 ObjCmd.Parameters.Append ObjCmd.CreateParameter("@error", adInteger, adParamOutput, 4)
 ObjCmd.execute

 ' if it's come back error then they don't have an entry in tblStaffNode in 90SU dbase
 ' which COULD mean they have been posted out - but it also COULD mean they have just entered
 ' the ServiceNo/Password incorrect - so flag the error and check it AFTER we have checked for
 ' correct ServiceNo/Password
 'conerror=0
 ' No logon authorised

 if  ObjCmd.Parameters("@error") = 1 then
   'conerror=1
   response.redirect "dufflogon.asp?strReason=DSN"
 end if
 
 ' If we get to this then we can validate logon and password with DSN from 90SUCMS.tblNode
 ' This is the DSN of the site to connect to - eg; Leeming, Boulmer, 90SU etc
 
   session("con")=request("DSN")
   session("con")= ObjCmd.Parameters("@dsn")
 
 for x = 1 to objCmd.parameters.count
	objCmd.parameters.delete(0)
 next
' 
' ' now close the connection cos we're going to set it up with the DSN of dBase we actually want
' 'close con

 con.close

 strCon=("DSN="&session("con"))

' ****** REMOVE NEXT 2 LINES  FOR LIVE ******************
 'session("con")="CMS2Auths"
 'strCon=("DSN="&session("con"))
' ******************************************************

 Set con = Server.CreateObject("ADODB.Connection") 'Create a connection object  
 con.Open strCon
 
 set objCmd = Server.CreateObject("ADODB.Command")
 set objCmd.ActiveConnection = con
 ObjCmd.CommandType = AdCmdStoredProc
 
%>	
    <!-- Connection include MUST be here cos we need to know the DSN to connect to first -->
    <!--include file="Connection/Connection.inc"-->
<%
	'if session("con")="ValleyCMS" then
	'	response.write (session("con"))
	'	response.End()
	'end if

	Session.Timeout = 60
	
	'set objCmd = Server.CreateObject("ADODB.Command")
	'set objCmd.ActiveConnection = con
	'ObjCmd.CommandType = AdCmdStoredProc
	ObjCmd.CommandText = "spLogOn"		
	ObjCmd.Parameters.Append ObjCmd.CreateParameter("@ServiceNo", adVarChar, adParamInput, 20, strNum)
	ObjCmd.Parameters.Append ObjCmd.CreateParameter("@Password", adVarChar, adParamInput, 20, strpassword)
	ObjCmd.Parameters.Append ObjCmd.CreateParameter("@StaffID", adInteger, adParamOutput, 4)
	ObjCmd.Parameters.Append ObjCmd.CreateParameter("@nodeID", adInteger, adParamOutput, 4)
	ObjCmd.Parameters.Append ObjCmd.CreateParameter("@StaffStatus", adInteger, adParamOutput, 4)
	ObjCmd.Parameters.Append ObjCmd.CreateParameter("@Active", adInteger, adParamOutput, 4)
	ObjCmd.Parameters.Append ObjCmd.CreateParameter("@CMSAdmin", adInteger, adParamOutput, 4)
	ObjCmd.Parameters.Append ObjCmd.CreateParameter("@SysAdmin", adInteger, adParamOutput, 4)
	ObjCmd.Parameters.Append ObjCmd.CreateParameter("@hrcID", adInteger, adParamOutput, 4)
	ObjCmd.Parameters.Append ObjCmd.CreateParameter("@authadmin", adVarChar, adParamOutput, 4)
	ObjCmd.Parameters.Append ObjCmd.CreateParameter("@authorisor", adVarChar, adParamOutput, 4)
	'ObjCmd.Parameters.Append ObjCmd.CreateParameter("@lvlKAuth", adInteger, adParamOutput, 4)
	'ObjCmd.Parameters.Append ObjCmd.CreateParameter("@lvlJAuth", adInteger, adParamOutput, 4)
	'ObjCmd.Parameters.Append ObjCmd.CreateParameter("@teamIDStr", adVarChar, adParamOutput, 200)
	ObjCmd.Parameters.Append ObjCmd.CreateParameter("@pswdExp", adInteger, adParamOutput, 4)
	ObjCmd.Parameters.Append ObjCmd.CreateParameter("@error", adInteger, adParamOutput, 4)
	ObjCmd.execute


	' if return error = 1 then there is a problem with the password, username  
	'	redirects back to login for next attempt.
	if  ObjCmd.Parameters("@error") = 1  then
	    response.redirect "dufflogon.asp?strReason=Staff"
	end if

	
	' they are inactive ie Posted Out 
	if  ObjCmd.Parameters("@active") = 0 then
	  response.redirect "dufflogon.asp?strReason=Active"
	end if

	session("serviceNo") = strNum
	session("StaffID") = objCmd.Parameters("@StaffID")
	session("nodeID") = objCmd.Parameters("@nodeID")	
	session("UserStatus") =  objCmd.Parameters("@StaffStatus")  ' 1 = Manager
	session("hrcID") = objCmd.Parameters("@hrcID") 	
	session("authorisor") = objCmd.Parameters("@authorisor")
	session("authadmin")= objCmd.Parameters("@authadmin")
	session("Administrator") = objCmd.Parameters("@SysAdmin")
	session("CMSAdministrator") = objCmd.Parameters("@CMSAdmin")
	session("DeptID") = 1
	session("imxAdmin")=0  ' IMX Admin - if 1 then we can add new Groups

	pswdExp = objCmd.Parameters("@pswdExp")
	
	'Now retrieve the configuration settings depending on the unit
		set rsConfig = server.createobject("ADODB.Recordset")
		set cmdConfigList = server.createobject("ADODB.Command")
		cmdConfigList.activeconnection = con
		cmdConfigList.activeconnection.cursorlocation = 3
		cmdConfigList.commandtype = 4
		cmdConfigList.commandtext = "spConfig(" & session("nodeID") & ")"	
		set rsConfig = cmdConfigList.execute
		
		'Now get the output from spConfig
		session("Pla") = rsConfig("pla")
		session("Tas") = rsConfig("tas")
		session("Man") = rsConfig("man")
		session("Per") = rsConfig("per")
		session("Uni") = rsConfig("uni")
		session("Cap") = rsConfig("cap")
		session("Pre") = rsConfig("pre")
		session("Fit") = rsConfig("fit")
		session("Boa") = rsConfig("boa")
		session("sta") = rsConfig("sta")
		session("map") = rsConfig("map")
		session("Sch") = rsConfig("sch")
		session("Nom") = rsConfig("nom")
		session("Ran") = rsConfig("ran")
		session("Aut") = rsConfig("aut")
		session("Ind") = rsConfig("ind")
		session("Pos") = rsConfig("pos")
		session("Rod") = rsConfig("rod")
		session("Paq") = rsConfig("paq")
		
		'response.Write(ObjCmd.Parameters("@error"))
	'response.End()

	'if session("con")="ValleyCMS" then
	'	response.write (session("con"))
	'	response.End()
	'end if

' if return error = 0 the login details are correct and the user can advance to the home page.
 	if (ObjCmd.Parameters("@error")) = 0 and ObjCmd.Parameters("@active") = 1 then
		
		session("CMS2CMSLogIn") = "TRUE"  
		session("SignInFlag") = 1
		'response.redirect "cms_hierarchy3.asp?hrcID="&session("hrcID")
		response.redirect "cms_hierarchy3.asp"
		
	end if

	' if return error = 2 then the login details are correct but the password matches the default password (set by system admin) and 
	'	password requires changing. redirects to change password page.
	if ObjCmd.Parameters("@error") = 2 then
		session("CMS2CMSLogIn") = "TRUE" 
		response.redirect "changepw.asp"
	end if	
	' if return error = 3 then the password has expired and is redirected to the change password page.
	if ObjCmd.Parameters("@error") = 3 then
		session("CMS2CMSLogIn") = "TRUE" 
		response.redirect "changepw.asp?error=1"
	end if	
	' if return error = 4 then the password is due to expire in the next 5 days and is redirected to the change password page.
	if ObjCmd.Parameters("@error") = 4 then
		session("CMS2CMSLogIn") = "TRUE" 
		session("SignInFlag") = 1
		response.redirect "changepw.asp?error=2&pswdExp="&pswdExp
	end if	
   
%>
