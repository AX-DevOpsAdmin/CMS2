<!DOCTYPE HTML >
<!--#include file="Includes/security.inc"--> 
<!--include file="Includes/checkadmin.asp"-->
<!--#include file="Connection/Connection.inc"-->
<%

Const Hidden = 2

Dim objUpload
Dim strFileName
Dim strPath
dim strFiles
dim strList


		
stratpID = request ("atpID")
strGoTo = request("ReturnTo") 

if request("staffID") <>"" then
	strRecID = request("staffID")
	strGoTo = strGoTo & "?staffID=" & strRecid & "&thisDate=" & request("thisDate")
else
	strRecID = request("RecID")
	strGoTo = strGoTo & "?RecID=" & strRecid 
end if

 'response.write ("Add Auths " & strRecid & " * " & strGoTo & " * " & request("authID2") & " * " & request("apprvID2") & " * " & request("staID2"))
 'response.End()

	
	set objCmd = server.CreateObject("ADODB.Command")
    set objPara = server.CreateObject("ADODB.Parameter")
    objCmd.ActiveConnection = con
    objCmd.Activeconnection.cursorlocation = 3

    objCmd.CommandText = "spStaffAuthEdit"	
	objCmd.CommandType = 4				

	strAdmin=session("StaffID")   ' this is the authoriser
	        
		set objPara = objCmd.CreateParameter ("StaffID",3,1,0, request("staffID"))
		objCmd.Parameters.Append objPara
        set objPara = objCmd.CreateParameter ("authID",3,1,0, request("authID2")) ' The record from tblAuths being requested 
		objCmd.Parameters.Append objPara

		set objPara = objCmd.CreateParameter ("admin",3,1,0, strAdmin)
		objCmd.Parameters.Append objPara
		set objPara = objCmd.CreateParameter ("sdate",200,1,20, request("fromdate"))
		objCmd.Parameters.Append objPara
		set objPara = objCmd.CreateParameter ("edate",200,1,20, request("todate"))
		objCmd.Parameters.Append objPara

        set objPara = objCmd.CreateParameter ("Authorisor",200,1,20, request("apprvID2"))    ' The staff member requested to authorise this
		objCmd.Parameters.Append objPara
        set objPara = objCmd.CreateParameter ("staffAuth",200,1,20, request("staID2"))    ' The staff member requested to authorise this
		objCmd.Parameters.Append objPara

		set objPara = objCmd.CreateParameter ("nodeID",3,1,0, nodeID)
		objCmd.Parameters.Append objPara

	    objCmd.Execute
	   
		for x = 1 to objCmd.parameters.count
			objCmd.parameters.delete(0)
		next

     response.Redirect strGoTo
%>