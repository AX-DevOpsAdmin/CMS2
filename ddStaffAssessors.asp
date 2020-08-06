	
    <!--#include file="Includes/security.inc"--> 
    <!--include file="Includes/checkadmin.asp"-->
    <!--#include file="Connection/Connection.inc"-->

    <%
	
	'If user is not valid Authorisor then log them off
'	If session("authorisor") <> 1 then
'		Response.redirect("noaccess.asp")
'	End If

	strStaffID=request("staffID")
	
	response.write(" AuthID is " & request("authID") & " * " & request("staffID"))
	response.End()
	
    set objCmd = server.CreateObject("ADODB.Command")
	set objPara = server.CreateObject("ADODB.Parameter")
	objCmd.ActiveConnection = con
	objCmd.Activeconnection.cursorlocation = 3
	objCmd.commandtype = 4	
	
	set objPara = objCmd.CreateParameter ("authID",3,1,0, request("authID"))   
	objCmd.Parameters.Append objPara
	set objPara = objCmd.CreateParameter ("staffID",3,1,0, request("staffID"))   
	objCmd.Parameters.Append objPara

    'response.write(" AuthID is " & request("authID"))
	'
	
	strCommand = "spListStaffAuthorisors"
	objCmd.CommandText = strCommand
	set rsApprv = objCmd.execute	'Execute CommandText when using "ADODB.Command" object

	for x = 1 to objCmd.parameters.count
		objCmd.parameters.delete(0)
	next
    %>
	        <% strstaID="" %>
            <select name="apprvID" id="apprvID" class="itemfont" style="width: 150px">
                <option value="0">None</option>
                <% do while not rsApprv.eof %>
                    <option value="<%= rsApprv("authID") %>" <% if rsApprv("selected") = "1" then %> selected <% end if %>><%= rsApprv("authName") %> </option>
                   <% if rsApprv("selected") = "1" then strstaID=rsApprv("staffauth") end if %>
                       
                    <% rsApprv.movenext %>
                <% loop %>
            </Select>
            <input type=hidden name="staID" id="staID" value="<%=strstaID %>">
 