<!DOCTYPE HTML >

<!--#include file="Includes/security.inc"--> 
<!--#include file="Includes/checkadmin.asp"-->
<!--#include file="Connection/Connection.inc"-->

<%

' so the menu include - datamenu.inc knows what page we're on
dim strPage
strPage="Teams"

set objCmd = server.CreateObject("ADODB.Command")
objCmd.ActiveConnection = con
objCmd.CommandText = "spListTeams"	'Name of Stored Procedure
objCmd.CommandType = 4				'Code for Stored Procedure
set rsRecSet = objCmd.Execute	'Execute CommandText when using "ADODB.Command" object
%>

<html>
<head>

<!--#include file="Includes/IECompatability.inc"-->


<title><%= PageTitle %></title>
<link rel="stylesheet" type="text/css" href="Includes/AMDB.css" media="Screen"/>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">

</head>
<body>
<form action="" method="POST" name="frmDetails">
	<table  height="100%" cellspacing=0 cellPadding=0 width=100% border=0>
      <tr>
        <td>
          <!--#include file="Includes/Header.inc"--> 
  		<table cellSpacing=0 cellPadding=0 width=100% border=0 >
                    <tr style="font-size:10pt;" height=26px>
                        <td width=10><img style="margin-left:10px;" src="cms_icons/png/24x24/process.png" width="24" height="24"></td>
                        <td class="staticdatamenu"><font class="youAreHere">CMS Admin Menu / <strong>Teams</strong></font></td>
                    </tr>
                    <tr><td colspan=2 class=titlearealine  height=1></td></tr>
				</table>
          
  		  <table width=100% height='<%=session("heightIs")%>px' border=0 cellpadding=0 cellspacing=0> 
      		<tr valign=Top>
        	  <td class="sidemenuwidth" background="Images/tableback.png"><!--#include file="Includes/datamenu.inc"--></td>
				</td> 
				  <td width=16></td>
				  <td align=left >
				    <table border=0 cellpadding=0 cellspacing=0 width=100%>
					  <tr height=16 class=SectionHeader>
					    <td>
						  <table border=0 cellpadding=0 cellspacing=0 >
						    <tr>
							  <td class=toolbar width=8></td>
							  <td width=20><a class=itemfontlink href="AdminTeamAdd.asp"><img class="imagelink" src="images/newitem.gif"></a></td>
							  <td class=toolbar valign="middle">New Team</td>
							</tr>  
					      </table>
						</td>
					  </tr>
					  <tr>
					    <td>
						  <table width=100% border=0 cellpadding=0 cellspacing=0>
						    <tr class=columnheading height=20>
							  <td valign="middle" width=2%></td>
							  <td valign="middle" width=25%>Team</td>
							  <td valign="middle" width=25%>Cycle</td>
							  <td width="50%" valign="middle">Team Hierarchy </td>
							</tr>
						  	<tr>
       						  <td colspan=8 class=titlearealine  height=1></td> 
     					    </tr>
							<%
							   ' Now get the Cycle and Stage the Team is currently in
                              objCmd.CommandText = "spTeamCurrStage"	'Name of Stored Procedure
							%>
							<%do while not rsRecSet.eof%>
							  <tr class=itemfont ID="TableRow<%=rsRecSet ("TeamID")%>" height=30>
								<td valign="middle" ></td>
								<td valign="middle"><A class=itemfontlink href="AdminTeamDetail.asp?RecID=<%=rsRecSet("TeamID")%>"><%=rsRecSet("description")%></A></td>
								<% 'need to reset the parameters for each record
								   set objPara = objCmd.CreateParameter ("TeamID",3,1,5, rsRecSet ("TeamID"))
                                       objCmd.Parameters.Append objPara
								   set objPara = objCmd.CreateParameter ("CurrStage",3,2)
                                       objCmd.Parameters.Append objPara
                                   set objPara = objCmd.CreateParameter ("teamCycle",200,2, 20)
                                       objCmd.Parameters.Append objPara
                                   set objPara = objCmd.CreateParameter ("teamStage",200,2, 20)
                                       objCmd.Parameters.Append objPara
                                   set objPara = objCmd.CreateParameter ("endDate",200,2,20)
                                       objCmd.Parameters.Append objPara
                                   objCmd.Execute	'Execute CommandText when using "ADODB.Command" object
								   
								   ' now get the output from spTeamCurrStage
                                   strTeamCycle = objCmd.Parameters("teamCycle") + "/" + objCmd.Parameters("teamStage")
								   
								   ' now delete the parameters ready for the re-set
                                   objCmd.Parameters.delete("TeamID")
                                   objCmd.Parameters.delete("CurrStage")
                                   objCmd.Parameters.delete("teamCycle") 
                                   objCmd.Parameters.delete("teamStage")
                                   objCmd.Parameters.delete("endDate")
                                 %>
								<td valign="middle" ><%=strTeamCycle%></td>
								<td valign="middle" ><%=rsRecSet("ParentDescription")%></td>
								<td width="1%" valign="middle" ></td>
						      </tr>
  							  <tr>
       						    <td colspan=8 class=titlearealine  height=1></td> 
     						  </tr>
							<%rsRecSet.MoveNext
							Loop%>
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
<%
rsRecSet.close
set rsRecSet=Nothing
con.close
set con=Nothing
%>
</body>
</html>