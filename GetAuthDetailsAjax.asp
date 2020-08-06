<!DOCTYPE HTML >
<!--#include file="Includes/security.inc"--> 
<!--#include file="Connection/Connection.inc"-->
<%

strCommand = "spGetAuthDetail"

set objCmd = server.CreateObject("ADODB.Command")
set objPara = server.CreateObject("ADODB.Parameter")
objCmd.ActiveConnection = con
objCmd.CommandText = strCommand
objCmd.CommandType = 4		

set objPara = objCmd.CreateParameter ("authID",3,1,5, request("authID"))
objCmd.Parameters.Append objPara

set rsRecSet = objCmd.Execute

for x = 1 to objCmd.parameters.count
	objCmd.parameters.delete(0)
next

fixedWidth="210"

%>
<table border="0" cellpadding="0" cellspacing="0" style="margin-bottom:10px; margin-left:10px" width="580px" >
			
    <!--
    <tr class="personalDetails">
        <td width="30%">Authorisation Code:<%'=rsRecSet("authcode")%></td>
    </tr>
    -->
    <tr class="personalDetails">
        <td width="30%">Authorisation Task:</td>
    </tr>
    <tr>
        <td width=200px>
            
                 <p> <%=rsRecSet("authtask")%> </p>
            
        </td>
    </tr>

    <tr>
      <td>&nbsp;</td>
    </tr>
    <tr class="personalDetails">
        <td width="30%">Authorisations Requirements:</td>
    </tr>
    <tr>
        <td width=200px>
                 <p> <%=rsRecSet("authreqs")%> </p>
        </td>
    </tr>
    <tr>
      <td>&nbsp;</td>
    </tr>

</table>


