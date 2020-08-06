<%
	dim con
	dim strDSN
	
        Set con = Server.CreateObject("ADODB.Connection") 'Create a connection object  
	
	response.cachecontrol = "no-cache"
	response.addheader "Pragma", "no-cache"
	response.expires = -1
	
	
	' Live Database - DSN is set when user logs in in their version of logon.asp
	' and this is passed to actual logon.asp vis default.html in what is now the default CMS Web Site - Air_90SUCMS

	' if session("con")="90SUDev" then
	'   con.Open "DSN=90SUDev"
	' elseif session("con")="LeemingCMS" then
	'   con.Open "DSN=LeemingCMS"
	' elseif session("con")="BoulmerCMS" then
	'   con.Open "DSN=BoulmerCMS"
	' elseif session("con")="RAFPCMS" then
	'   con.Open "DSN=RAFPCMS"
        ' elseif session("con")="HWYCMS" then
	'   con.Open "DSN=HWYCMS"
	' end if
  	 

        ' This is is the DSN set in the users original logon.asp
	strDSN=session("con")
	
	con.Open strDSN
	
	
%>
