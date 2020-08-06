	
    <!--#include file="Includes/security.inc"--> 
    <!--include file="Includes/checkadmin.asp"-->
    <!--#include file="Connection/Connection.inc"-->

    <%

	'If user is not valid Authorisation Administrator OR Level K/J  then log them off
	If (session("authadmin") =0 AND  strAuth > 2 ) then
		Response.redirect("noaccess.asp")
	End If


    set objCmd = server.CreateObject("ADODB.Command")
	set objPara = server.CreateObject("ADODB.Parameter")
	objCmd.ActiveConnection = con
	objCmd.Activeconnection.cursorlocation = 3
	objCmd.commandtype = 4	
	
	strCommand = "spGetAuthList"

	objCmd.CommandText = strCommand

	set objPara = objCmd.CreateParameter ("authType",3,1,0, request("atpID"))
	objCmd.Parameters.Append objPara
	set objPara = objCmd.CreateParameter ("nodeID",3,1,0, 0)
	objCmd.Parameters.Append objPara
	
	set rsAuths = objCmd.Execute	'Execute CommandText when using "ADODB.Command" object'


	for x = 1 to objCmd.parameters.count
		objCmd.parameters.delete(0)
	next
	
	'response.Write("auth levels")
	'response.End()
	
    %>
	
            <select name="authID" id="authID" class="itemfont" style="width: 150px">
				<% if not rsAuths.bof and not rsAuths.eof then %>
                    <% do while not rsAuths.eof %>
                        <option value=<%= rsAuths("authID")%>><%= rsAuths("authCode") %></option>
                        <% rsAuths.Movenext() %>
                    <% loop %>
                <% end if %>
            </Select>
 