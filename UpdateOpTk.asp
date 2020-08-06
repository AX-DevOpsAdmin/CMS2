<!DOCTYPE HTML >
<!--#include file="Connection/Connection.inc"-->
<%
dim strCommand
dim strAction
dim strGoTo

strStDate = request("T1")
strEndDate = request("T2")
strCatID = request("cmbCat")
strStatID = cInt(request("cmbStat"))

'response.write strCatID & " ** " & strStatID
'response.End()

' Now get the action required - we will want to ADD a NEW one or UPDATE an Existing one or DELETE one
strAction=request("strAction")
IF strAction = "Update" THEN
    strCommand = "spOpTkUpdate"
    strGoTo = "AdminOpTkDetail.asp?RecID=" & request("RecID")
ELSEIF  strAction = "Add" THEN
    strCommand = "spOpTkInsert"
	strGoTo = "AdminOpTkAdd.asp"
ELSE
	
END IF  
'response.write strAction & " * " & strCommand & " * " & strGoTo
'response.End()

set objCmd = server.CreateObject("ADODB.Command")
set objPara = server.CreateObject("ADODB.Parameter")
objCmd.ActiveConnection = con
'objCmd.CommandText = "spRankDetailUpdate"	'Name of Stored Procedure
objCmd.CommandText = strCommand
objCmd.CommandType = 4						'Code for Stored Procedure

' Here its UPDATE so pass the Record ID
IF strAction = "Update" THEN
    set objPara = objCmd.CreateParameter ("RecID",3,1,0, request("RecID"))
    objCmd.Parameters.Append objPara
	'set objPara = objCmd.CreateParameter ("TableID",200,1,50, request("strTabID"))
    'objCmd.Parameters.Append objPara
END IF

' Now set the common parameters
'set objPara = objCmd.CreateParameter ("Tablename",200,1,50, request("strTable"))
'objCmd.Parameters.Append objPara
set objPara = objCmd.CreateParameter ("Name",200,1,100, request("txtname"))
objCmd.Parameters.Append objPara
set objPara = objCmd.CreateParameter ("Location",200,1,100, request("txtlocation"))
objCmd.Parameters.Append objPara
set objPara = objCmd.CreateParameter ("ProjO",200,1,100, request("txtprojo"))
objCmd.Parameters.Append objPara
set objPara = objCmd.CreateParameter ("DetCdr",200,1,100, request("txtdetcdr"))
objCmd.Parameters.Append objPara
set objPara = objCmd.CreateParameter ("NominalRole",200,1,100, request("txtnomrol"))
objCmd.Parameters.Append objPara
set objPara = objCmd.CreateParameter ("OpOrder",200,1,100, request("txtopord"))
objCmd.Parameters.Append objPara
set objPara = objCmd.CreateParameter ("StartDate",200,1,20, strStDate)
objCmd.Parameters.Append objPara
set objPara = objCmd.CreateParameter ("EndDate",200,1,20, strEndDate)
objCmd.Parameters.Append objPara
set objPara = objCmd.CreateParameter ("Overview",200,1,100, request("txtoview"))
objCmd.Parameters.Append objPara
set objPara = objCmd.CreateParameter ("OpCat",3,1,0, strCatID)
objCmd.Parameters.Append objPara
set objPara = objCmd.CreateParameter ("OpCat",3,1,0, strStatID)
objCmd.Parameters.Append objPara

objCmd.Execute	'Execute CommandText when using "ADODB.Command" object

con.close
set con=Nothing
'response.redirect "AdminRankDetail.asp?rankid=" + request("rankid")
response.redirect(strGoTo)
%>
