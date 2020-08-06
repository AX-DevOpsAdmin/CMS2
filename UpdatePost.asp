<!DOCTYPE HTML >
<!--#include file="Includes/security.inc"-->
<!--#include file="Connection/Connection.inc"-->

<%
dim strCommand
dim strAction
dim strGoTo
strGhost = 0

' Now get the action required - we will want to ADD a NEW one or UPDATE an Existing one or DELETE one'
strAction=request("strAction")
if strAction = "Update" then

    strCommand = "spPostUpdate"
'	if request("hiddenGhost") = "True" then
'		strGhost = 1
'	else
'		strGhost = 0
'	end if
	
	if request("hiddenPostHolder") <> "" or request("Status") = 1 then
		strStatus = 1
	else
		strStatus = 0
	end if
		
	if request("strGoto") <> "" then
		strGoTo = request("strGoto") & "?postID=" & request("postID") & "&hrcID=" & request("hrcID")
		postId = request("postID")
	else
    	strGoTo = "AdminPostDetail.asp?recID=" & request("recID")
		postId = request("recID")
	end if
	
	'response.write(request("postID") & " * " & strStatus & " * " & request("hrcID") & " * " & strGhost & " * " & strGoTo)
	'response.end()

elseif strAction = "Add" then
    strCommand = "spPostInsert"
	
'	if request("chkGhost") = 1 then
'		strGhost = 1
'	else
'		strGhost = 0
'	end if
	
	strStatus = 1
	if request("Status") = 0 then
		strStatus = 0
	end if
	
	if request("strGoto") <> "" then
		strGoTo = "HierarchyPostAdd.asp"
	else
		strGoTo = "AdminPostAdd.asp"
	end if	
end if


set objCmd = server.CreateObject("ADODB.Command")
set objPara = server.CreateObject("ADODB.Parameter")
objCmd.ActiveConnection = con
objCmd.CommandText = strCommand
objCmd.CommandType = 4						'Code for Stored Procedure

if strAction = "Update" then

    strCommand = "spPostUpdate"
    set objPara = objCmd.CreateParameter ("PostID",3,1,0, postID)
    objCmd.Parameters.Append objPara
else
    set objPara = objCmd.CreateParameter ("nodeID",3,1,0, nodeID)
    objCmd.Parameters.Append objPara

end if

' Now set the common parameters
set objPara = objCmd.CreateParameter ("Description",200,1,50, request("txtDescription"))
objCmd.Parameters.Append objPara
set objPara = objCmd.CreateParameter ("AssignNo",200,1,50, request("txtassignNo"))
objCmd.Parameters.Append objPara
'set objPara = objCmd.CreateParameter ("TeamID",3,1,0, request("TeamID"))
'objCmd.Parameters.Append objPara
set objPara = objCmd.CreateParameter ("hrcID",3,1,0, request("hrcID"))
objCmd.Parameters.Append objPara

set objPara = objCmd.CreateParameter ("PositionDesc",200,1,50, request("Position"))
objCmd.Parameters.Append objPara
set objPara = objCmd.CreateParameter ("RankID",3,1,0, request("RankID"))
objCmd.Parameters.Append objPara
set objPara = objCmd.CreateParameter ("TradeID",3,1,0, request("TradeID"))
objCmd.Parameters.Append objPara
set objPara = objCmd.CreateParameter ("RWID",3,1,0, request("RWID"))
objCmd.Parameters.Append objPara
set objPara = objCmd.CreateParameter ("Notes",200,1,255, request("Notes"))
objCmd.Parameters.Append objPara
'set objPara = objCmd.CreateParameter ("QOveride",3,1,0, request("QOveride"))
set objPara = objCmd.CreateParameter ("QOveride",3,1,0, 0)
objCmd.Parameters.Append objPara
'set objPara = objCmd.CreateParameter ("MSOveride",3,1,0, request("MSOveride"))
set objPara = objCmd.CreateParameter ("MSveride",3,1,0, 0)
objCmd.Parameters.Append objPara
'set objPara = objCmd.CreateParameter ("Overborne",3,1,0, request("overborne"))
set objPara = objCmd.CreateParameter ("Overborne",3,1,0, 0)
objCmd.Parameters.Append objPara
set objPara = objCmd.CreateParameter ("manager",3,1,0, request("manager"))
objCmd.Parameters.Append objPara
set objPara = objCmd.CreateParameter ("Ghost",11,1,1, strGhost)
objCmd.Parameters.Append objPara
set objPara = objCmd.CreateParameter ("Status",11,1,1, strStatus)
objCmd.Parameters.Append objPara
set objPara = objCmd.CreateParameter ("blnFlag",11,2,4)
objCmd.Parameters.Append objPara

objCmd.Execute	'Execute CommandText when using "ADODB.Command" object

strFlag = objCmd.Parameters("blnFlag")

con.close
set con=Nothing

if strFlag = True and request("strGoto") = "" then
%>
	<html>
	<Body>
	<form name=frmDetails action="AdminPostAdd.asp?err=True"  method="POST">
        <input type=hidden name=chkGhost id="chkGhost" value="<%=strGhost%>">
        <input type=hidden name=Description id="Description" value="<%=request("Description")%>">
        <input type=hidden name=assignno id="assignno" value="<%=request("assignNo")%>">
        <input type=hidden name=TeamID id="TeamID" value="<%=request("hrcID")%>">
        <input type=hidden name=position  id="position" value="<%=request("Position")%>">
        <input type=hidden name=RankID  id="RankID" value="<%=request("RankID")%>">
        <input type=hidden name=TradeID id="TradeID" value="<%=request("TradeID")%>">
        <input type=hidden name=RWID id="RWID" value="<%=request("RWID")%>">
        <input type=hidden name=Notes id="Notes" value="<%=request("Notes")%>">
        <input type=hidden name=QOveride id="QOveride" value="<%=request("QOveride")%>">
        <input type=hidden name=MSOveride id="MSOveride" value="<%=request("MSOveride")%>">
        <input type=hidden name=overborne  id="overborne" value="<%=request("overborne")%>">
        <input type=hidden name=manager id="manager" value="<%=request("manager")%>">
        <input type=hidden name=status id="status" value="<%=request("status")%>">
	</form>
	
	<SCRIPT LANGUAGE="JavaScript">
		document.forms["frmDetails"].submit();
	</script>
	</Body>
	</html>
<%
else
	response.redirect(strGoTo)
end if
%>
