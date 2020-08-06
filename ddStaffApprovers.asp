	
    <!--#include file="Includes/security.inc"--> 
    <!--include file="Includes/checkadmin.asp"-->
    <!--#include file="Connection/Connection.inc"-->

    <%
	
	'If user is not valid Authorisor then log them off
	If session("authorisor") = 0 then
		Response.redirect("noaccess.asp")
	End If

    set objCmd = server.CreateObject("ADODB.Command")
	set objPara = server.CreateObject("ADODB.Parameter")
	objCmd.ActiveConnection = con
	objCmd.Activeconnection.cursorlocation = 3
	objCmd.commandtype = 4	
	
	set objPara = objCmd.CreateParameter ("staffID",3,1,0, request("staffID"))   ' so we get ALL auth types
	objCmd.Parameters.Append objPara
	set objPara = objCmd.CreateParameter ("authID",3,1,0, request("authID"))   ' so we get ALL auth types
	objCmd.Parameters.Append objPara
	set objPara = objCmd.CreateParameter ("nodeID",3,1,0, nodeID)   ' so we know where they live
	objCmd.Parameters.Append objPara

    'response.write(" AuthID is " & request("authID"))
	'response.End()
	
	strCommand = "spListStaffApprovers"
	objCmd.CommandText = strCommand
	set rsApprv = objCmd.execute	'Execute CommandText when using "ADODB.Command" object

	for x = 1 to objCmd.parameters.count
		objCmd.parameters.delete(0)
	next
    %>
	
            <select name="apprvID" id="apprvID" class="itemfont" style="width: 150px">
                <option value="0">None</option>
                <% do while not rsApprv.eof %>
                    <option value="<%= rsApprv("apprvID") %>" ><%= rsApprv("apprvname") %> </option>
                    <% rsApprv.movenext %>
                <% loop %>
            </Select>
 