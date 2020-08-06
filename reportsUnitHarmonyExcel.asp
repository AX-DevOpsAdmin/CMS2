<!DOCTYPE HTML >

<!--#include file="Includes/security.inc"-->
<!--#include file="Connection/Connection.inc"-->

<%
response.ContentType = "application/vnd.ms-excel"
response.addHeader "content-disposition","attachment;filename=HarmonyReport.xls"
	
strRepUnit=request("repunit")
if strRepUnit = 0 then
  strCommand = "spGetUnitHarmony"
  strlabel="Harmony Status of Units within "
  strColLabel="Unit Name"
elseif strRepUnit = 1 then
  strCommand = "spGetUnitRankHarmony"
  strlabel="Harmony Status of Ranks within "
  strColLabel="Unit Rank"
else
  strCommand = "spGetUnitTradeHarmony"
    strlabel="Harmony Status of Trades within "
  strColLabel="Unit Trade"
end if

if cint(request("repby"))= 0 then
  strrepby=" Unit Strength "
else  
  strrepby=" Unit Establishment "
end if

set objCmd = server.CreateObject("ADODB.Command")
set objPara = server.CreateObject("ADODB.Parameter")
objCmd.ActiveConnection = con
objCmd.Activeconnection.cursorlocation = 3
objCmd.CommandType = 4	

' first get the harmony Day Limits
objCmd.CommandText = "spGetUnitHarmonyLimits"	'Name of Stored Procedure'
set rslimits = objCmd.Execute	'Execute CommandText when using "ADODB.Command" object'

' now  get the team
set objPara = objCmd.CreateParameter ("@hrcID",3,1,0, cint(request("cboHrc")))
objCmd.Parameters.Append objPara

objCmd.CommandText = "spHrcDetail"
set rsHrc = objCmd.Execute
strTeam=rsHrc("hrcname")

objCmd.CommandText = strCommand

'response.write("HRC param is " & objCmd.Parameters("@hrcID") & " * " & strCommand & " * " & request("repunit"))
'response.End()

' now add reporting parameters
set objPara = objCmd.CreateParameter ("repUnit",3,1,0, cint(request("repunit")))
objCmd.Parameters.Append objPara
set objPara = objCmd.CreateParameter ("repBy",3,1,0, cint(request("repby")))
objCmd.Parameters.Append objPara

set rsRecSet = objCmd.Execute	'Execute CommandText when using "ADODB.Command" object'

'' first get the harmony Day Limits
'objCmd.CommandText = "spGetUnitHarmonyLimits"	'Name of Stored Procedure'
'set rslimits = objCmd.Execute	'Execute CommandText when using "ADODB.Command" object'
'
'' now  get the team
'set objPara = objCmd.CreateParameter ("teamID",3,1,0, cint(request("cboTeam")))
'objCmd.Parameters.Append objPara
'
'objCmd.CommandText = "spTeamDetail"
'set rsTeam = objCmd.Execute
'strTeam=rsTeam("Description")
'
'objCmd.CommandText = strCommand
'
'' now add reporting parameters
'set objPara = objCmd.CreateParameter ("repUnit",3,1,0, cint(request("repunit")))
'objCmd.Parameters.Append objPara
'set objPara = objCmd.CreateParameter ("repBy",3,1,0, cint(request("repby")))
'objCmd.Parameters.Append objPara
'
'set rsRecSet = objCmd.Execute	'Execute CommandText when using "ADODB.Command" object'
%>

<html>
<head>

<!--#include file="Includes/IECompatability.inc"-->


<title><%= PageTitle %></title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">

<style type="text/css">
<!--
body {
	background-image: url();
	margin-left: 0px;
	margin-top: 0px;
	margin-right: 0px;
	margin-bottom: 0px;
}
.style1 {color: #0000FF}

.xl27
	{mso-style-parent:style0;
	border-top:.5pt solid windowtext;
	border-right:none;
	border-bottom:.5pt solid windowtext;
	border-left:none;
	white-space:normal;}

-->
</style>

</head>
<body>
<table border=0 cellpadding=0 cellspacing=0 width=978px>
	<tr>
		<td align="center" colspan="<% if strRepUnit <>0 then %>12<%else%>8<%end if%>" style="font-size:14pt;"><U>Unit Harmony Report</U></td>
	</tr>
	<tr>
		<td colspan="<% if strRepUnit <>0 then %>12<%else%>8<%end if%>">&nbsp;</td>
	</tr>
	<tr>
		<td width="100%" colspan="<% if strRepUnit <>0 then %>12<%else%>8<%end if%>" valign="middle"><font size="2">Harmony Status by <%=strrepby%> of </font> <font color="#0033FF" size="2"><strong><%=strTeam%></strong></font></td>
	</tr>
	<tr> 
		<td width="230">&nbsp;</td>
        <td width=95><div style="font-weight:bold;" align="center">Unit</div></td>
        <td width=90><div style="font-weight:bold;" align="center">Unit</div></td>
		<% if strRepUnit <>0 then %> 
            <td width=95>&nbsp;</td>
            <td width=90>&nbsp;</td>
        <% end if %>  
        <td width=100><div style="font-weight:bold;" align="center">OOA</div></td>
        <td width=90><div style="font-weight:bold;" align="center">OOA</div></td>
		<% if strRepUnit <>0 then %> 
            <td width=90>&nbsp;</td>
            <td width=90>&nbsp;</td>
        <% end if %>  
        <td width=100><div style="font-weight:bold;" align="center">BNA</div></td>
        <td width=90><div style="font-weight:bold;" align="center">BNA</div></td>
        <td width=90 align="center"><div style="font-weight:bold;" align="center">Harmony</div></td>   
    </tr>
    <tr> 
        <td>&nbsp;</td>
        <td width=95><div style="font-weight:bold;" align="center">Establishment</div></td>
        <td width=90><div style="font-weight:bold;" align="center">Strength</div></td>
		<% if strRepUnit <>0 then %> 
            <td width=90>&nbsp;</td>
            <td width=90>&nbsp;</td>
        <% end if %>  
        <td width=100><div style="font-weight:bold;" align="center">Red Personnel</div></td>
        <td width=90><div style="font-weight:bold;" align="center">Red %</div></td>
		<% if strRepUnit <>0 then %> 
            <td width=90>&nbsp;</td>
            <td width=90>&nbsp;</td>
        <% end if %>  
        <td width=100><div style="font-weight:bold;" align="center">Red Personnel</div></td>
        <td width=90><div style="font-weight:bold;" align="center">Red %</div></td>
        <td width=90 align="center"><div style="font-weight:bold;" align="center">Status</div></td>
    </tr>
    <% rsRecSet.movefirst %>
    <tr> 
        <td class="xl27">&nbsp;</td>
        <td align="center" width=90 class="xl27"><%=rsRecSet("established")%></td>
        <td align="center" width=90 class="xl27"><%=rsRecSet("strength")%></td>
		<% if strRepUnit <>0 then %> 
            <td width=90 class="xl27" align="center">&nbsp;</td>
            <td width=90 class="xl27" align="center">&nbsp;</td>
        <% end if %>  
        <td align="center" width=90 class="xl27"><%=rsRecSet("ooaredtot")%></td>
        <td align="center" width=90 class="xl27"><%=rsRecSet("ooapcnt")%></td>
		<% if strRepUnit <>0 then %> 
            <td width=90 class="xl27" align="center">&nbsp;</td>
            <td width=90 class="xl27" align="center">&nbsp;</td>
        <% end if %>  
        <td align="center" width="90" class="xl27"><%=rsRecSet("bnaredtot")%></td>
        <td align="center" width="90" class="xl27"><%=rsRecSet("bnapcnt")%></td>
        <% if  rsRecSet("harmony") = 3 then %>
        	<td width=90 bgcolor="#FF0000" class="xl27"></td>
        <% elseif  rsRecSet("harmony") = 2 then%>
        	<td width=90 bgcolor="#FF6600" class="xl27"></td>
        <% elseif rsRecSet("harmony") = 1 then%>
        	<td width=90 bgcolor="#FFCC00" class="xl27"></td>
        <% else %>
        	<td bgcolor="#006600" width=90 class="xl27"></td>
        <% end if %>
    </tr>
    <% rsRecSet.movenext %>
    <tr>
    	<td colspan="<% if strRepUnit <>0 then %>12<%else%>8<%end if%>">&nbsp;</td>
    </tr>
	<tr>
		<td width="100%" colspan="<% if strRepUnit <>0 then %>12<%else%>8<%end if%>" valign="middle" ><font size="2"><%=strlabel%> </font> <font color="#0033FF" size="2"><strong><%=strTeam%></strong></font></td>
	</tr>
	<tr> 
        <td width="230">&nbsp;</td>
        <td width=95><div style="font-weight:bold;" align="center">Unit</div></td>
        <td width=90><div style="font-weight:bold;" align="center">Unit</div></td>
        <% if strRepUnit <>0 then %>
            <td width=90><div style="font-weight:bold;" align="center">OOA</div></td>
            <td width=90><div style="font-weight:bold;" align="center">OOA</div></td>
        <%end if %>  
        <td width=100><div style="font-weight:bold;" align="center">OOA</div></td>
        <td width=90><div style="font-weight:bold;" align="center">OOA</div></td>
        <% if strRepUnit <>0 then %> 
            <td width=90><div style="font-weight:bold;" align="center">BNA</div></td>
            <td width=90><div style="font-weight:bold;" align="center">BNA</div></td>
        <% end if %>  
        <td width=100><div style="font-weight:bold;" align="center">BNA</div></td>
        <td width=90><div style="font-weight:bold;" align="center">BNA</div></td>
        <td align="center" width="90"><div style="font-weight:bold;" align="center">Harmony</div></td>
    </tr>
    <tr> 
        <td ><div style="font-weight:bold;"><%=strColLabel%></div></td>
        <td width=95><div style="font-weight:bold;" align="center">Establishment</div></td>
        <td width=90><div style="font-weight:bold;" align="center">Strength</div></td>
        <% if strRepUnit <>0 then %>
            <td width=90><div style="font-weight:bold;" align="center">Total Days</div></td>
            <td width=90><div style="font-weight:bold;" align="center">Avg Days</div></td>
        <% end if %>  
        <td width=100><div style="font-weight:bold;" align="center">Red Personnel</div></td>
        <td width=90><div style="font-weight:bold;" align="center">Red%</div></td>
        <% if strRepUnit <>0 then %> 
            <td width=90><div style="font-weight:bold;" align="center">Total Days</div></td>
            <td width=90><div style="font-weight:bold;" align="center">Avg Days</div></td>
        <% end if %>  
        <td width=100><div style="font-weight:bold;" align="center">Red Personnel</div></td>
        <td width=90><div style="font-weight:bold;" align="center">Red%</div></td>
        <td  align="center" width=90><div style="font-weight:bold;" align="center">Status</div></td>
    </tr>
    
	<% do while not rsRecSet.eof %>
        <tr> 
            <td width=230 class="xl27"><%=rsRecSet("dispdata")%></td>
            <td width=90 class="xl27" align="center"><%=rsRecSet("established")%></td>
            <td width=90 class="xl27" align="center"><%=rsRecSet("strength")%></td>
            <% if strRepUnit <>0 then %> 
                <td width=90 class="xl27" align="center"> <%=rsRecSet("ooatot")%></td>
                <td width=90 class="xl27" align="center"><%=rsRecSet("ooaavg")%></td>
            <% end if %>  
            <td width=90 class="xl27" align="center"><%=rsRecSet("ooaredtot")%></td>
            <td width=90 class="xl27" align="center"><%=rsRecSet("ooapcnt")%></td>
            
            <% if strRepUnit <>0 then %> 
                <td width=90 class="xl27"align="center"> <%=rsRecSet("bnatot")%></td>
                <td width=90 class="xl27" align="center"><%=rsRecSet("bnaavg")%></td>
            <% end if %>  
            <td width=90 class="xl27" align="center"><%=rsRecSet("bnaredtot")%></td>
            <td width=90 class="xl27" align="center"><%=rsRecSet("bnapcnt")%></td>
            <% if  rsRecSet("harmony") = 3 then %>
            	<td width=90 class="xl27" bgcolor="#FF0000" ></td>
            <% elseif rsRecSet("harmony") = 2 then%>
                <td width=90 class="xl27" bgcolor="#FF6600"></td>
            <% elseif rsRecSet("harmony") = 1 then%>
                <td width=90 class="xl27"  bgcolor="#FFCC00"></td>
            <% else %>
               <td width=90 class="xl27" bgcolor="#006600"></td>
            <% end if %>
        </tr>
        <% rsRecSet.movenext %>
	<% loop %>
</table>

</body>
</html>