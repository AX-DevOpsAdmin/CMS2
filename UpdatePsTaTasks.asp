<!DOCTYPE HTML >
<!--#include file="Includes/security.inc"--> 
<!--#include file="Connection/Connection.inc"-->
<%
' This assigns a task to an individual staff using the stored procedure 
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
strGoTo = "ManningPersTasks.asp?RecID=" & strRecid

'response.Write request("task") & " * " & request("T1") & " ** " & request("T2") & " *** " & strCheck
'response.End()

        objCmd.CommandText = "spPsTaInsert"	
        objCmd.CommandType = 4				
        set objPara = objCmd.CreateParameter ("TaskID",3,1,5, request("cmbtask"))
        objCmd.Parameters.Append objPara
        set objPara = objCmd.CreateParameter ("StaffID",3,1,5, request("recID"))
        objCmd.Parameters.Append objPara
        set objPara = objCmd.CreateParameter ("TaskNotes",200,1,12, request("task"))
        objCmd.Parameters.Append objPara
        set objPara = objCmd.CreateParameter ("startDate",200,1,12, request("T1"))
        objCmd.Parameters.Append objPara
        set objPara = objCmd.CreateParameter ("endDate",200,1,12, request("T2"))
        objCmd.Parameters.Append objPara
        set objPara = objCmd.CreateParameter ("Cancelable",3,1,5, strCheck)
        objCmd.Parameters.Append objPara

        set rsRecSet = objCmd.Execute	
response.Redirect strGoTo
%>