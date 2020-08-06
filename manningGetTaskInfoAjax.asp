<!DOCTYPE HTML >
<!--#include file="Includes/security.inc"--> 
<!--#include file="Connection/Connection.inc"-->
<%
todayDate = formatdatetime(date(),2)
splitDate = split (todayDate,"/")
if splitdate(1)="01" then theMonth="Jan"
if splitdate(1)="02" then theMonth="Feb"
if splitdate(1)="03" then theMonth="Mar"
if splitdate(1)="04" then theMonth="Apr"
if splitdate(1)="05" then theMonth="May"
if splitdate(1)="06" then theMonth="Jun"
if splitdate(1)="07" then theMonth="Jul"
if splitdate(1)="08" then theMonth="Aug"
if splitdate(1)="09" then theMonth="Sep"
if splitdate(1)="10" then theMonth="Oct"
if splitdate(1)="11" then theMonth="Nov"
if splitdate(1)="12" then theMonth="Dec"

newTodaydate= splitDate(0) + " " + theMonth + " " + splitDate(2) 

strCommand = "spPeRsDetail"

set objCmd = server.CreateObject("ADODB.Command")
set objPara = server.CreateObject("ADODB.Parameter")
objCmd.ActiveConnection = con
objCmd.CommandText = strCommand
objCmd.CommandType = 4		

set objPara = objCmd.CreateParameter ("RecID",3,1,5, request("StaffID"))
objCmd.Parameters.Append objPara

set rsRecSet = objCmd.Execute

for x = 1 to objCmd.parameters.count
	objCmd.parameters.delete(0)
next

fixedWidth="210"
%>
<table border="0" cellpadding="0" cellspacing="0" width="100%" >
	<tr >
		<td valign="top" width="48%" >
			<div>
				<table border="0" cellpadding="0" cellspacing="8" width="98%">
				<tr  class="personalDetails">
					<td width="30%">First Name:</td><td width=200px ><Div class=borderArea style="background-color:#FFFFFF;" ><table  border=0 cellpadding=0 cellspacing=1 ><tr><td class=itemfont ><%=rsRecSet("firstname")%>&nbsp;</td><tr></table></Div></td>
				</tr>
				<tr  class="personalDetails">
					<td width="30%">Surname:</td><td width=200px ><Div class=borderArea style="background-color:#FFFFFF;" ><table  border=0 cellpadding=0 cellspacing=1 ><tr><td class=itemfont ><%=rsRecSet("surname")%>&nbsp;</td><tr></table></Div></td>
				</tr>
				<tr  class="personalDetails">
					<td >Known As:</td><td width=200px ><Div class=borderArea style="background-color:#FFFFFF;" ><table  border=0 cellpadding=0 cellspacing=1 ><tr><td class=itemfont ><%=rsRecSet("knownas")%>&nbsp;</td><tr></table></Div></td>
				</tr>

				<tr  class="personalDetails">
					<td >Military No:</td><td width=150px ><Div class=borderArea style="background-color:#FFFFFF;" ><table  border=0 cellpadding=0 cellspacing=1 ><tr><td class=itemfont ><%=rsRecSet("serviceno")%>&nbsp;</td><tr></table></Div></td>
				</tr>
				<tr  class="personalDetails">
					<td >Rank:</td><td width=150px ><Div class=borderArea style="background-color:#FFFFFF;" ><table  border=0 cellpadding=0 cellspacing=1 ><tr><td class=itemfont ><%=rsRecSet("Rank")%>&nbsp;</td><tr></table></Div></td>
				</tr>
				<tr  class="personalDetails">
					<td >Trade:</td><td width=150px ><Div class=borderArea style="background-color:#FFFFFF;" ><table  border=0 cellpadding=0 cellspacing=1 ><tr><td class=itemfont ><%=rsRecSet("trade")%>&nbsp;</td><tr></table></Div></td>
				</tr>
							<tr class="personalDetails">
								<!--<td colspan=2 align="center"><img width=200 height=200 src="<%'=rsRecSet("photoPath")%>"></td>-->
								<td valign=top>Photograph:</td><td colspan=1 align=left><img width=200 height=200 src="getPhoto.asp?staffID=<%=request("staffID")%>"></td>
							</tr>

			</table>
			</div>
		</td>
		<td></td>
		<td valign="top" width="48%" >
			<div>
			<table border="0" cellpadding="0" cellspacing="8" width="98%">

			</table>
			</div>
		</td>

	</tr>

</table>

