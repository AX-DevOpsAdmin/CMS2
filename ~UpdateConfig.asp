<!DOCTYPE HTML >

<!--#include file="Connection/Connection.inc"-->

<%
dim strCommand
dim strAction
dim strGoTo

strCommand = "spConfigUpdate"
strGoTo = "AdminConfigList.asp"
	
set objCmd = server.CreateObject("ADODB.Command")
set objPara = server.CreateObject("ADODB.Parameter")
objCmd.ActiveConnection = con
objCmd.CommandText = strCommand
objCmd.CommandType = 4						'Code for Stored Procedure

set objPara = objCmd.CreateParameter ("@configID", 3, 1, 0, request("configID"))
objCmd.Parameters.Append objPara

' Now set the common parameters
'set objPara = objCmd.CreateParameter("@pla", 11, 1, 1, request("radPla"))
'objCmd.Parameters.Append objPara
'set objPara = objCmd.CreateParameter("@tas", 11, 1, 1, request("radTas"))
'objCmd.Parameters.Append objPara
radman=0
if request("radMan") = "on" then
  radman=1
end if

radPer=0
if request("radPer") = "on" then
  radPer=1
end if

radUni=0
if request("radUni") = "on" then
  radUni=1
end if

radFit=0
if request("radFit") = "on" then
  radFit=1
end if

radBoa=0
if request("radBoa") = "on" then
  radBoa=1
end if

radRan=0
if request("radRan") = "on" then
  radRan=1
end if

radAut=0
if request("radAut") = "on" then
  radAut=1
end if

radInd=0
if request("radInd") = "on" then
  radInd=1
end if

radRod=0
if request("radRod") = "on" then
  radRod=1
end if

radPaq=0
if request("radPaq") = "on" then
  radPaq=1
end if

'response.write ("Check are " & radman & " * " &  isNull (request("radPer")) )
'response.End()



set objPara = objCmd.CreateParameter("@pla", 11, 1, 1, 0)
objCmd.Parameters.Append objPara
set objPara = objCmd.CreateParameter("@tas", 11, 1, 1, 0)
objCmd.Parameters.Append objPara

set objPara = objCmd.CreateParameter("@man", 11, 1, 1, radMan)
objCmd.Parameters.Append objPara
set objPara = objCmd.CreateParameter("@per", 11, 1, 1, radPer)
objCmd.Parameters.Append objPara
set objPara = objCmd.CreateParameter("@uni", 11, 1, 1, radUni)
objCmd.Parameters.Append objPara
set objPara = objCmd.CreateParameter("@cap", 11, 1, 1, 0)   ' don't need this report
objCmd.Parameters.Append objPara
set objPara = objCmd.CreateParameter("@pre", 11, 1, 1, 0)    ' don't need this report
objCmd.Parameters.Append objPara
set objPara = objCmd.CreateParameter("@fit", 11, 1, 1, radFit)
objCmd.Parameters.Append objPara
set objPara = objCmd.CreateParameter("@boa", 11, 1, 1, radBoa)
objCmd.Parameters.Append objPara
set objPara = objCmd.CreateParameter("@sch", 11, 1, 1, 0)  ' don't need this report
objCmd.Parameters.Append objPara
set objPara = objCmd.CreateParameter("@nom", 11, 1, 1, 0)   ' don't need this report
objCmd.Parameters.Append objPara
set objPara = objCmd.CreateParameter("@ran", 11, 1, 1, radRan)
objCmd.Parameters.Append objPara
set objPara = objCmd.CreateParameter("@aut", 11, 1, 1, radAut)
objCmd.Parameters.Append objPara
set objPara = objCmd.CreateParameter("@ind", 11, 1, 1, radInd)
objCmd.Parameters.Append objPara
set objPara = objCmd.CreateParameter("@pos", 11, 1, 1, 0)  ' don't need this report
objCmd.Parameters.Append objPara
set objPara = objCmd.CreateParameter("@rod", 11, 1, 1, radRod)
objCmd.Parameters.Append objPara
set objPara = objCmd.CreateParameter("@paq", 11, 1, 1, radPaq)
objCmd.Parameters.Append objPara

objCmd.execute	'Execute CommandText when using "ADODB.Command" object

if err.number = 0 then
	session("Pla") = 0
	session("Tas") = 0
	session("Man") = radMan
	session("Per") = radPer
	session("Uni") = radUni
	session("Cap") = 0
	session("Pre") = 0
	session("Fit") = radFit
	session("Boa") = radBoa
	session("Sch") = 0
	session("Nom") = 0
	session("Ran") = radRan
	session("Aut") = radAut
	session("Ind") = radInd
	session("Pos") = 0
	session("Rod") = radRod
	session("Paq") = radPaq
end if

con.close
set con = nothing
response.redirect(strGoTo)
%>
