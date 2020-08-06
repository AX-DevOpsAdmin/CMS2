<!DOCTYPE HTML >
<!--#include file="Includes/security.inc"--> 
<!--include file="Includes/checkadmin.asp"-->
<!--#include file="Connection/Connection.inc"-->
<%
set objCmd = server.CreateObject("ADODB.Command")
set objPara = server.CreateObject("ADODB.Parameter")
objCmd.ActiveConnection = con
objCmd.Activeconnection.cursorlocation = 3
objCmd.CommandText = "spAddAuthorisor"	'Name of Stored Procedure'

Const Hidden = 2

Dim objUpload
Dim strFileName
Dim strPath
dim strFiles
dim strList

    strAuthorisor=session("staffID")
	strRecID = request("staffID")
	strGoTo = request("ReturnTo") & "?staffID=" & strRecid & "&atpID=" & request("atpID")
	
	strclass= request("lvlID")
	strstart= request("dateAttained")
	strend= request("dateTo")

'response.write(strRecID & " * " & strclass & " * " & strstart & " * " & strend & " * " & strAuthorisor)
'response.End()

		set objPara = objCmd.CreateParameter ("staffID",3,1,0, strRecID)
		objCmd.Parameters.Append objPara

		set objPara = objCmd.CreateParameter ("authclass",3,1,0, strclass)
		objCmd.Parameters.Append objPara

		set objPara = objCmd.CreateParameter ("validFrom",200,1,30, strstart)
		objCmd.Parameters.Append objPara
		
	    set objPara = objCmd.CreateParameter ("validTo",200,1,30, strend)
		objCmd.Parameters.Append objPara
			
		set objPara = objCmd.CreateParameter ("authorisor",3,1,0, strAuthorisor)
		objCmd.Parameters.Append objPara
		
		objCmd.Execute	'Execute CommandText when using "ADODB.Command" object'

'response.Write("Authorisor is " & strRecID & " Authorised by " & strAuthorisor & " Auth Class is " & strclass & " * " & strstart & " * " & strend)
'response.End()

'
'IF Request("newattached") <> "" THEN	
'	strList = Request("newAttached")
'	strDateList = Request("newdatesAttached")
'
'	
'	strNewStations = split(strList, ",")	
'	strNewdates = split(strDateList, ",")
'	
'	
'
'	FOR intCount = LBound(strNewStations) TO (UBound(strNewStations))
'	    strDates=split(strNewdates(intCount), "|")
'		strDateFrom=strDates(0)
'		strDateTo=strDates(1)
'
'       ' response.write(strDateList & " * " & strNewdates  & " ** " & strDateFrom & " *** " & strDateTo)
'	   'response.write(strDateList & " * " &  " ** " & strDateFrom & " *** " & strDateTo)
'	   
'	
'		set objPara = objCmd.CreateParameter ("staffID",3,1,0, strRecID)
'		objCmd.Parameters.Append objPara
'
'		set objPara = objCmd.CreateParameter ("MSID",3,1,0, strNewStations(intCount))
'		objCmd.Parameters.Append objPara
'
'		set objPara = objCmd.CreateParameter ("validFrom",200,1,30, strDateFrom)
'		objCmd.Parameters.Append objPara
'		
'	    set objPara = objCmd.CreateParameter ("validTo",200,1,30, strDateTo)
'		objCmd.Parameters.Append objPara
'			
'		set objPara = objCmd.CreateParameter ("authorisor",3,1,0, strAuthorisor)
'		objCmd.Parameters.Append objPara
'	
'		objCmd.Execute	'Execute CommandText when using "ADODB.Command" object'
'
'	   'response.write(strNewStations(intCount) & " * " & strRecid & " * " & strDateFrom & " * " & strDateTo & " * " & strAuthorisor )
'	   'response.end()
'
'
'		for x = 1 to objCmd.parameters.count
'			objCmd.parameters.delete(0)
'		next
'	NEXT 
'	'response.end'
'END IF
'
response.Redirect strGoTo
%>