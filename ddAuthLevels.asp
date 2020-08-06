	
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
	
	set objPara = objCmd.CreateParameter ("nodeID",3,1,0, nodeID)   ' so we get ALL auth types
	objCmd.Parameters.Append objPara

	strCommand = "spGetAuthsLevelList"
	objCmd.CommandText = strCommand
	set rsLvl = objCmd.execute	'Execute CommandText when using "ADODB.Command" object

	for x = 1 to objCmd.parameters.count
		objCmd.parameters.delete(0)
	next
	
	'response.Write("auth levels")
	'response.End()
	
    %>
	
            <select name="authLvlID" id="authLvlID" class="itemfont" style="width: 150px">
                <option value="0">Select ... </option>
                <% do while not rsLvl.eof %>
                    <option value="<%= rsLvl("lvlID") %>" <% if rsLvl("authlevel")= request("authlevel") then %> selected <% end if %> ><%= rsLvl("authlevel") %> </option>
                    <% rsLvl.movenext %>
                <% loop %>
            </Select>
 