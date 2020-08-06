<!DOCTYPE HTML >

<!--#include file="Includes/security.inc"-->
<!--#include file="Connection/Connection.inc"-->

<%
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
%>

<html>
<head>

<!--#include file="Includes/IECompatability.inc"-->


<title><%= PageTitle %></title>
<link rel="stylesheet" type="text/css" href="Includes/AMDB.css" />
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
-->
</style>

</head>
<body>
<table border=0 cellpadding=0 cellspacing=0 width=100%>
    <tr>
        <td>&nbsp;</td>
    </tr>
    <tr class=titlearea>	
        <td align="center"><U>Unit Harmony Report</U></td>
    </tr>
    <tr height=16px>
        <td>&nbsp;</td>
    </tr>
	<tr>
		<td>
			<table border=0 cellpadding=0 cellspacing=0 width=100%>
				<tr>
					<td >
                        <table width="100%" border=0 cellpadding=0 cellspacing=0 >
                            <tr class=itemfont height=20px>
                               <td colspan="4"  valign="middle" align="left"><font size="2">Harmony Status by <%=strrepby%> of </font> <font color="#0033FF" size="2"><strong><%=strTeam%></strong></font></td>
                            </tr>
                        </table>
					</td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
        <td>
            <table border=0 cellpadding=0 cellspacing=0 width=100%>
                <tr>
                    <td>
						<table border=0 cellpadding=0 cellspacing=0 width=100%>
                    		<tr class=columnheading valign="bottom" height=20px> 
                                <td width=25%>&nbsp;</td>
                                <td width=7%><div align="center">Unit</div></td>
                                <td width=7%><div align="center">Unit</div></td>
								<% if strRepUnit <> 0 then %>
                                    <td width=7%><div align="center">&nbsp;</div></td>
                                    <td width=7%><div align="center">&nbsp;</div></td>
                                <% end if %>  
                                <td width=7%><div align="center">OOA</div></td>
                                <td width=7%><div align="center">OOA</div></td>
								<% if strRepUnit <> 0 then %>
                                    <td width=7%><div align="center">&nbsp;</div></td>
                                    <td width=7%><div align="center">&nbsp;</div></td>
                                <% end if %>  
                                <td width=7%><div align="center">BNA</div></td>
                                <td width=7%><div align="center">BNA</div></td>
                                <td width=5% align="center">Harmony</td>
                            </tr>
                            <tr class=columnheading valign="top" height=20px> 
                                <td width=25%>&nbsp;</td>
                                <td width=7%><div align="center">Establishment</div></td>
                                <td width=7%><div align="center">Strength</div></td>
								<% if strRepUnit <> 0 then %>
                                    <td width=7%><div align="center">&nbsp;</div></td>
                                    <td width=7%><div align="center">&nbsp;</div></td>
                                <% end if %>  
                                <td width=7%><div align="center">Red Personnel</div></td>
                                <td width=7%><div align="center">Red %</div></td>
								<% if strRepUnit <> 0 then %>
                                    <td width=7%><div align="center">&nbsp;</div></td>
                                    <td width=7%><div align="center">&nbsp;</div></td>
                                <% end if %>  
                                <td width=7%><div align="center">Red Personnel</div></td>
                                <td width=7%><div align="center">Red %</div></td>
                                <td width=5% align="center">Status</td>
                            </tr>
                            <tr> 
                                <td colspan=12 class=titlearealine  height=1></td>
                            </tr>
                    		<% rsRecSet.movefirst %>
                            <tr class=itemfont height=20px> 
	                            <td width=25%>&nbsp;</td>
    	                        <td width=7% align="center"><%=rsRecSet("established")%></td>
        	                    <td width=7% align="center"><%=rsRecSet("strength")%></td>
								<% if strRepUnit <> 0 then %>
                                    <td width=7%><div align="center">&nbsp;</div></td>
                                    <td width=7%><div align="center">&nbsp;</div></td>
                                <% end if %>  
            	                <td width=7% align="center"><%=rsRecSet("ooaredtot")%></td>
                	            <td width=7% align="center"><%=rsRecSet("ooapcnt")%></td>
								<% if strRepUnit <> 0 then %>
                                    <td width=7%><div align="center">&nbsp;</div></td>
                                    <td width=7%><div align="center">&nbsp;</div></td>
                                <% end if %>  
                    	        <td width=7% align="center"><%=rsRecSet("bnaredtot")%></td>
                        	    <td width=7% align="center"><%=rsRecSet("bnapcnt")%></td>
								<% if rsRecSet("harmony") = 3 then %>
                                    <% colour = "#FF0000" %>
                                <% elseif rsRecSet("harmony") = 2 then %>
                                    <% colour = "#FF6600" %>
                                <% elseif rsRecSet("harmony") = 1 then %>
                                    <% colour = "#FFCC00" %>
                                <% else %>
                                    <% colour = "#006600" %>
                                <% end if %>
                            	<td width=5% bgcolor="<%= colour %>">&nbsp;</td>
                            </tr>
                            <tr> 
                                <td colspan=12 class=titlearealine  height=1></td>
                            </tr>
							<% rsRecSet.movenext %>
                        </table>
                	</td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td>&nbsp;</td>
    </tr>
    <tr>
        <td>&nbsp;</td>
    </tr>
    <tr>
        <td>
			<table border=0 cellpadding=0 cellspacing=0 width=100%>
				<tr>
					<td >
                        <table width="100%" border=0 cellpadding=0 cellspacing=0 >
                            <tr class=itemfont height=20px>
                                <td colspan="4" valign="middle" align="left"><font size="2"><%=strlabel%> </font> <font color="#0033FF" size="2"><strong><%=strTeam%></strong></font></td>
                            </tr>
                        </table>
					</td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td>
            <table border=0 cellpadding=0 cellspacing=0 width=100%>
            	<tr class=columnheading valign="bottom" height=20px>
                    <td width=25%>&nbsp;</td>
                    <td width=7%><div align="center">Unit</div></td>
                    <td width=7%><div align="center">Unit</div></td>
                    <% if strRepUnit <> 0 then %>
                        <td width=7%><div align="center">OOA</div></td>
                        <td width=7%><div align="center">OOA</div></td>
                    <% end if %>  
                    <td width=7%><div align="center">OOA</div></td>
                    <td width=7%><div align="center">OOA</div></td>
                    <% if strRepUnit <> 0 then %>
                        <td width=7%><div align="center">BNA</div></td>
                        <td width=7%><div align="center">BNA</div></td>
                    <% end if %>  
                    <td width=7%><div align="center">BNA</div></td>
                    <td width=7%><div align="center">BNA</div></td>
                    <td width=5%><div align="center">Harmony</div></td>
                </tr>
                <tr class=columnheading valign="top" height=20px> 
                    <td width=25%>&nbsp;<%=strColLabel%></td>
                    <td width=7%><div align="center">Establishment</div></td>
                    <td width=7%><div align="center">Strength</div></td>
                    <% if strRepUnit <>0 then %>
                        <td width=7%><div align="center">Total Days</div></td>
                        <td width=7%><div align="center">Avg Days</div></td>
                    <% end if %>  
                    <td width=7%><div align="center">Red Personnel</div></td>
                    <td width=7%><div align="center">Red %</div></td>
                    <% if strRepUnit <>0 then %> 
                        <td width=7%><div align="center">Total Days</div></td>
                        <td width=7%><div align="center">Avg Days</div></td>
                    <% end if %>  
                    <td width=7%><div align="center">Red Personnel</div></td>
                    <td width=7%><div align="center">Red %</div></td>
                    <td width=5%><div align="center">Status</div></td>
                </tr>
                <tr>
                    <td colspan=12 class=titlearealine  height=1></td> 
                </tr>
				<% do while not rsRecSet.eof %>	
                    <tr class=itemfont height=20px> 
                        <td width=25%><%=rsRecSet("dispdata")%></td>
                        <td width=7% align="center"><%=rsRecSet("established")%></td>
                        <td width=7% align="center"><%=rsRecSet("strength")%></td>
                        <% if strRepUnit <>0 then %> 
                            <td width=7% align="center"> <%=rsRecSet("ooatot")%></td>
                            <td width=7% align="center"><%=rsRecSet("ooaavg")%></td>
                        <% end if %>  
                        <td width=7% align="center"><%=rsRecSet("ooaredtot")%></td>
                        <td width=7% align="center"><%=rsRecSet("ooapcnt")%></td>
                        <% if strRepUnit <>0 then %> 
                            <td width=7% align="center"> <%=rsRecSet("bnatot")%></td>
                            <td width=7% align="center"><%=rsRecSet("bnaavg")%></td>
                        <% end if %>  
                        <td width=7% align="center"><%=rsRecSet("bnaredtot")%></td>
                        <td width=7% align="center"><%=rsRecSet("bnapcnt")%></td>
                        <% if rsRecSet("harmony") = 3 then %>
                        	<% colour = "#FF0000" %>
                        <% elseif rsRecSet("harmony") = 2 then %>
                        	<% colour = "#FF6600" %>
                        <% elseif rsRecSet("harmony") = 1 then %>
                        	<% colour = "#FFCC00" %>
                        <% else %>
                        	<% colour = "#006600" %>
                        <% end if %>
                        <td width=5% align="center" bgcolor="<%= colour %>">&nbsp;</td>
                    </tr>
                    <tr>
                    <td colspan=12 class=titlearealine  height=1></td> 
                    </tr>
                	<% rsRecSet.movenext %>
                <% loop %>
            </table>
		</td>
	</tr>
</table>
</body>
</html>