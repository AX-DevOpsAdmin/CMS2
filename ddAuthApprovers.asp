	
    <!--#include file="Includes/security.inc"--> 
    <!--include file="Includes/checkadmin.asp"-->
    <!--#include file="Connection/Connection.inc"-->
	<!--#include file="Includes/authsecurity.inc"-->
    
    <%
    '
    ''If user is not valid Authorisation Administrator then log them off
    'If session("authadmin") <> 1 then
    '	Response.redirect("noaccess.asp")
    'End If
    
    set objCmd = server.CreateObject("ADODB.Command")
	set objPara = server.CreateObject("ADODB.Parameter")
	objCmd.ActiveConnection = con
	objCmd.Activeconnection.cursorlocation = 3
	objCmd.commandtype = 4	
	
	set objPara = objCmd.CreateParameter ("authID",3,1,0, request("authID"))   ' so we get ALL auth types
	objCmd.Parameters.Append objPara
	set objPara = objCmd.CreateParameter ("RecID",3,1,0, request("atpID"))   ' so we get ALL auth types
	objCmd.Parameters.Append objPara

	strCommand = "spListAuthApprovers"
	objCmd.CommandText = strCommand
	set rsApprv = objCmd.execute	'Execute CommandText when using "ADODB.Command" object

	for x = 1 to objCmd.parameters.count
		objCmd.parameters.delete(0)
	next
    %>
	
            <select name="apprvID" id="apprvID" class="itemfont" style="width: 150px">
                <option value="0">All Authorisations </option>
                <% do while not rsApprv.eof %>
                    <option value="<%= rsApprv("authID") %>" <% if cint(rsApprv("authID"))= cint(request("apprvID")) then %> selected <% end if %> ><%= rsApprv("authCode") %> </option>
                    <% rsApprv.movenext %>
                <% loop %>
            </Select>
 