<!DOCTYPE HTML >

<!--#include file="Includes/security.inc"--> 
<!--#include file="Includes/checkadmin.asp"-->
<!--#include file="Connection/Connection.inc"-->

<%
' so the menu include - datamenu.inc knows what page we're on
dim strPage
strPage="Fit"

set objCmd = server.CreateObject("ADODB.Command")
objCmd.ActiveConnection = con
objCmd.CommandText = "spListFitness"	'Name of Stored Procedure
objCmd.CommandType = 4				'Code for Stored Procedure

set objPara = objCmd.CreateParameter ("nodeID",3,1,0, nodeID)
objCmd.Parameters.Append objPara

set rsRecSet = objCmd.Execute	'Execute CommandText when using "ADODB.Command" object
%>

<html>
<head>

<!--#include file="Includes/IECompatability.inc"-->


<title><%= PageTitle %></title>
<link rel="stylesheet" type="text/css" href="Includes/AMDB.css" media="Screen"/>
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
<form action="" method="POST" name="frmDetails">
	<table height="100%" cellspacing=0 cellPadding=0 width=100% border=0>
		<tr>
			<td>
				<!--#include file="Includes/Header.inc"--> 
				<table cellSpacing=0 cellPadding=0 width=100% border=0 >
                    <tr style="font-size:10pt;" height=26px>
                        <td width=10><img style="margin-left:10px;" src="cms_icons/png/24x24/process.png" width="24" height="24"></td>
                        <td class="staticdatamenu"><font class="youAreHere">CMS Admin Menu / <strong>Fitness</strong></font></td>
                    </tr>
					<tr>
						<td colspan=2 class=titlearealine  height=1></td> 
					</tr>
				</table>
				<table width=100% height='<%=session("heightIs")%>px' border=0 cellpadding=0 cellspacing=0 > 
					<tr valign=Top>
						<td class="sidemenuwidth" background="Images/tableback.png"><!--#include file="Includes/datamenu.inc"--></td> 
						<td width=16></td>
						<td align=left >
							<table border=0 cellpadding=0 cellspacing=0 width=100%>
								<tr class=SectionHeader>
									<td>
										<table border=0 cellpadding=0 cellspacing=0>
											<tr>
												<td height="25px" class=toolbar width=8></td>
												<td height="25px" width=20><a class=itemfontlink href="AdminFitnessAdd.asp"><img class="imagelink" src="images/newitem.gif"></a></td>
												<td height="25px" class=toolbar valign="middle" >New Fitness</td>
											</tr>  
										</table>
									</td>
								</tr>
								<tr>
									<td>
										<table width=100% border=0 cellpadding=0 cellspacing=0>
											<tr class=columnheading height=20>
												<td align="left" width=2%>&nbsp;</td>
												<td align="left" width=20%>Fitness</td>
												<td align="left" width=20%>Validity Period</td>
												<td align="center" width=20%>Combat Ready</td>
												<td align="left" width="38%">&nbsp;</td>
											</tr>
											<tr>
       											<td colspan=5 class=titlearealine  height=1></td> 
     										</tr>
											<% do while not rsRecSet.eof %>
												<tr class=itemfont ID="TableRow<%= rsRecSet ("fitnessID") %>" height=20>
													<td align="left" width=2%>&nbsp;</td>
													<td align="left" width=20%><A class=itemfontlink href="AdminFitnessDetail.asp?RecID=<%=rsRecSet("fitnessID")%>"><%=rsRecSet("Description")%></A></td>
													<td align="left" width=20%><%=rsRecSet("ValidityPeriod")%></td>
													<td align="center" width=20%><% if rsRecSet("Combat") = true then %><img src="Images/yes.gif"><% end if %></td>
													<td align="left" width=38%>&nbsp;</td>
						    					</tr>
  												<tr>
       												<td colspan=5 class=titlearealine  height=1></td> 
												</tr>
												<% rsRecSet.moveNext %>
											<% loop %>
										</table>
									</td>
								</tr>
							</table>
						</td>
					</tr>
				</table>
			</td>  
		</tr>
	</table>
</form>

</body>
</html>