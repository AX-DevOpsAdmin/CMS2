	
    <!--#include file="Includes/security.inc"--> 
    <!--include file="Includes/checkadmin.asp"-->
    <!--#include file="Connection/Connection.inc"-->
    <!--#include file="Includes/authsecurity.inc"--> 
    
    <%

	strStaffID = request("recID")
	strasrID = request("asrID")

    set objCmd = server.CreateObject("ADODB.Command")
	set objPara = server.CreateObject("ADODB.Parameter")
	objCmd.ActiveConnection = con
	objCmd.Activeconnection.cursorlocation = 3
	objCmd.commandtype = 4	
	
	set objPara = objCmd.CreateParameter ("staffID",3,1,0, strStaffID)   ' who is being authorised
	objCmd.Parameters.Append objPara
	set objPara = objCmd.CreateParameter ("asrID",3,1,0, strasrID)   ' What is being authorised
	objCmd.Parameters.Append objPara
	set objPara = objCmd.CreateParameter ("nodeID",3,1,0, nodeID)   ' so we get ALL auth types
	objCmd.Parameters.Append objPara
	'set objPara = objCmd.CreateParameter ("RecID",3,1,0, request("atpID"))   ' so we get ALL auth types
	'objCmd.Parameters.Append objPara

    'response.write(" AuthID is " & strasrID & "staffID is " & strStaffID)
	'response.End()
	strCommand = "spGetAuthLimsCurrent"
	objCmd.CommandText = strCommand
	set rsLCR = objCmd.execute	'Execute CommandText when using "ADODB.Command" object
	
	for x = 1 to objCmd.parameters.count
		objCmd.parameters.delete(0)
	next
    %>
           <select name="limsAdded" size="10" multiple class="" style="width:180px;" id="limsAdded"> 
                <% do while not rsLCR.eof %>
                    <option value="<%= rsLCR("almID") %>" ><%= rsLCR("authcode") %> </option>
                    <% rsLCR.movenext %>
                <% loop %>
            </Select>
	
         
 