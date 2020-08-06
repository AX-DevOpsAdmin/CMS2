<%@LANGUAGE="VBSCRIPT" CODEPAGE="1252"%>
<!--#include file="Connection/Connection.inc"-->
<%
' Run when Staff updates their details in StaffUpdate.asp

dim strSQL ' SQL string to run against database

' COMMAND Variables
dim adCmdText
dim adCmdStoredProc
dim adVarChar
dim adInteger
dim adParamInput 
dim setParm

' set COMMAND variable defaults
adCmdText = 4
adCmdStoredProc = 4
adVarChar = 200
adInteger = 3
adParamInput = 1

' reset default password
set objCmd = server.CreateObject("ADODB.Command")
set objPara = server.CreateObject("ADODB.Parameter")
objCmd.ActiveConnection = con
objCmd.CommandText = strCommand
objCmd.CommandType = 4		
objCmd.CommandText= "spResetPW"
 
 'response.write("staffID is " & request("staffID"))
 'response.End()
 
set objPara = objCmd.CreateParameter ("staffID",3,1,5, request("staffID"))
objCmd.Parameters.Append objPara
set objPara = objCmd.CreateParameter ("@randomWord",200,&H0002,9)
objCmd.Parameters.Append objPara

objCmd.Execute
  

%>
<html>
    <Body>
        <form name=frmDetails action="AdminPeRsDetail.asp"  method="POST">
            <input type=hidden name="staffID" id="staffID" value="<%=request("staffID")%>">
            <input type=hidden name="randomWord" id="randomWord" value="<%=ObjCmd.Parameters("@randomWord")%>">
        </form>
        
        <SCRIPT LANGUAGE="JavaScript">
            document.forms["frmDetails"].submit();
        </script>
    </Body>
</html>
