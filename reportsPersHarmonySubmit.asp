<!DOCTYPE HTML >
<!--#include file="Includes/security.inc"-->
<!--#include file="Connection/Connection.inc"-->
<%

set objCmd = server.CreateObject("ADODB.Command")
set objPara = server.CreateObject("ADODB.Parameter")
objCmd.ActiveConnection = con
objCmd.Activeconnection.cursorlocation = 3
objCmd.CommandType = 4	

' first get the harmony Day Limits
objCmd.CommandText = "spGetHarmonyLimits"	'Name of Stored Procedure'
set rsOOA = objCmd.Execute	'Execute CommandText when using "ADODB.Command" object'

strooa = rsOOA("ooaperiod") & " Month Period"
strssa = rsOOA("ssaperiod") & " Month Period"
strssb = rsOOA("ssbperiod") & " Month Period"
'response.write strmaxdays & " * " &  strambdays

' now  get the team
set objPara = objCmd.CreateParameter ("hrcID",3,1,0, cint(request("hrcID")))
objCmd.Parameters.Append objPara

strTeam="All"
if cint(request("hrcID")) <> 0 then
  objCmd.CommandText = "spHrcDetail"
  set rsHrc = objCmd.Execute
  strTeam=rsHrc("hrcname")
end if  

' now get the report details - we still need teamID
objCmd.CommandText = "spGetHarmonyReportDetails"
set objPara = objCmd.CreateParameter ("gender",3,1,0, cint(request("gender")))
objCmd.Parameters.Append objPara
set rsRecSet = objCmd.Execute	'Execute CommandText when using "ADODB.Command" object'

%>
<html>
<head>

<!--#include file="Includes/IECompatability.inc"-->


<title><%= PageTitle %></title>
<link rel="stylesheet" type="text/css" href="Includes/AMDB.css" />
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1"><style type="text/css">
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
</style></head>
<body>
<table border=0 cellpadding=0 cellspacing=0 width=978px>
	<tr class=titlearea>
		<td align="center"><U>Harmony Status Report </U></td>
	</tr>
	<tr height=16px>
		<td>&nbsp;</td>
	</tr>
	<tr>
		<td>
		</td>
	</tr>

	<tr height=16px>
		<td>
		</td>
	</tr>
	<tr>
		<td>
			<table border=0 cellpadding=0 cellspacing=0 width=100%>
				<tr>
					<td >
                        <div class=borderAreaTableRow>
						<table width="500" border=0 cellpadding=0 cellspacing=0 >
							<tr class=itemfont height=20px>
								<td width="215"  valign="middle" >
								  Search Results: <Font class=searchheading>records found: <%=rsRecSet.recordcount%></Font>
							  </td>
								<td width="29">&nbsp;</td>
								<td width="69" valign="middle">For Unit:</td>
							  <td width="187" valign="middle"><%=strTeam%></td>
							</tr>
						</table>
                        </div>
					</td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
	  <td>
	    <table border=0 cellpadding=0 cellspacing=0 width=100%>
		  <tr>
		    <td >
               <div class=borderAreaTableRow>
			   <table border=0 cellpadding=0 cellspacing=0 width=100%>
				 <tr class=columnheading valign="bottom" height=20px>
				   <td>&nbsp;</td>
				   <td  width=95>Rank</td>
				   <td width=164>Surname</td>
				   <td width=188>Firstname</td>
				   <td width=129>Service No</td>
				   <td width="117">Last OOA</td>
				   <td width="101">OOA Days</td>
				   <td width="5">&nbsp;</td>
				   <td width="101">SSC A Days</td>
				   <td width="5">&nbsp;</td>
				   <td width="101">SSC B Days</td>
				   <td width="5">&nbsp;</td>
				   <td colspan="5" >Harmony</td>
			     </tr>
				 <tr class=columnheading valign="top" height=20px>
				   <td>&nbsp;</td>
				   <td  width=95>&nbsp;</td>
				   <td width=164>&nbsp;</td>
				   <td width=188>&nbsp;</td>
				   <td width=129>&nbsp;</td>
				   <td width="117">&nbsp;</td>
				   <td width="101"><%= strooa %></td>
				   <td width="5">&nbsp;</td>
				   <td width="101"><%= strssa %></td>
				   <td width="5">&nbsp;</td>
				   <td width="101"><%= strssb %></td>
				   <td width="5">&nbsp;</td>
				   <td colspan="5" >Status</td>
			     </tr>
                 <tr>
       				<td colspan=11 class=titlearealine  height=1></td> 
     			  </tr>
				 
				 <% do while not rsRecSet.eof	%>
				   <tr class=itemfont height=20px>
				     <td>&nbsp;</td>
					 <td  width=95><%=rsRecSet("shortDesc")%></td>
					 <td width=164><%=rsRecSet("surname")%></td>
					 <td width=188><%=rsRecSet("firstname")%></td>
					 <td width=129><%=rsRecSet("serviceNo")%></td>
					 <td width="117"><%=rsRecSet("lastOOA")%></td>
					 <td width="101" align="center"><%=rsRecSet("ooaDays")%></td>
					 <td width="5">&nbsp;</td>
					 <td width="101" align="center"><%=rsRecSet("ssaDays")%></td>
					 <td width="5">&nbsp;</td>
					 <td width="101" align="center"><%=rsRecSet("ssbDays")%></td>
					 <td width="5">&nbsp;</td>
					 <td>&nbsp;</td>
					 <% if  (rsRecSet("ooaDays") >= rsOOA("ooared")) OR (rsRecSet("ssaDays") >= rsOOA("ssared")) OR (rsRecSet("ssbDays") >= rsOOA("ssbred"))then %>							
					   <td width=18 bgcolor="#FF0000" ></td>
					 <% elseif  ((rsRecSet("ooaDays") < rsOOA("ooared")) AND (rsRecSet("ooaDays") >= rsOOA("ooaamber"))) OR ((rsRecSet("ssaDays") < rsOOA("ssared")) AND (rsRecSet("ssaDays") >= rsOOA("ssaamber"))) OR ((rsRecSet("ssbDays") < rsOOA("ssbred")) AND (rsRecSet("ssbDays") >= rsOOA("ssbamber"))) then%> 
					   <td bgcolor="#FF9900" width=18></td>
					 <% elseif (rsRecSet("ooaDays") < rsOOA("ooaamber")) AND (rsRecSet("ssaDays") < rsOOA("ssaamber")) AND (rsRecSet("ssbDays") < rsOOA("ssbamber"))then%>
					   <td  bgcolor="#00CC00" width=18></td> 
					 <% end if %> 
					 <td width="128" >&nbsp;</td>  
				 </tr>
				 <tr>
       				<td colspan=11 class=titlearealine  height=1></td> 
     			  </tr>

				 <% 
				    rsRecSet.movenext 
					loop
				 %>
				</table>
               </div>	
			  </td>
			</tr>
		 </table>
		</td>
	</tr>
</table>
</body>
</html>