<!DOCTYPE HTML >
<!--#include file="Includes/security.inc"--> 
<!--#include file="Connection/Connection.inc"-->
<%
' This adds personnel to tasks using the stored procedure 
set objCmd = server.CreateObject("ADODB.Command")
set objPara = server.CreateObject("ADODB.Parameter")
objCmd.ActiveConnection = con
objCmd.Activeconnection.cursorlocation = 3

Const Hidden = 2

Dim objUpload
Dim strFileName
Dim strPath
dim strFiles
dim strList

if request("cancelable") = "yes" THEN
  strCheck = 1
else
  strCheck = 0
end if
    
strRecID = request("RecID")
strGoTo = request("ReturnTo") & "?RecID=" & strRecid

'response.Write request("task") & " * " & request("T1") & " ** " & request("T2") & " *** " & strCheck
'response.End()

IF Request("newattached") <> "" THEN
	
	strList = Request("newAttached")
	strStaff = split(strList, ",")
	
	FOR intCount = 1 TO (UBound(strStaff))
'	     @ptaskid int,
'   @pstaffid int,
'   @ptask varchar(250),
'   @pstart varchar (20),
'   @pend varchar (20),
'   @pcancel bit


        objCmd.CommandText = "spPsTaInsert"	
        objCmd.CommandType = 4				
        set objPara = objCmd.CreateParameter ("TaskID",3,1,5, request("RecID"))
        objCmd.Parameters.Append objPara
        set objPara = objCmd.CreateParameter ("StaffID",3,1,5, strStaff(intCount))
        objCmd.Parameters.Append objPara
        set objPara = objCmd.CreateParameter ("Task",200,1,12, request("task"))
        objCmd.Parameters.Append objPara
        set objPara = objCmd.CreateParameter ("startDate",200,1,12, request("T1"))
        objCmd.Parameters.Append objPara
        set objPara = objCmd.CreateParameter ("endDate",200,1,12, request("T2"))
        objCmd.Parameters.Append objPara
        set objPara = objCmd.CreateParameter ("Cancelable",3,1,5, strCheck)
        objCmd.Parameters.Append objPara

        set rsRecSet = objCmd.Execute	

       for x = 1 to objCmd.parameters.count
	     objCmd.parameters.delete(0)
       next
	  'response.write comcommand.CommandText
	   Set comcommand = Nothing
	NEXT 
	'response.end
END IF
response.Redirect strGoTo
%>