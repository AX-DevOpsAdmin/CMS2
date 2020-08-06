<!DOCTYPE HTML >
<!--#include file="Includes/security.inc"--> 
<!--#include file="Includes/checkadmin.asp"-->
<!--#include file="Connection/Connection.inc"-->

<%

' This is the Initial Display Page of Wing table data

' so the menu include - datamenu.inc knows what page we're on
dim strPage
strPage="AdminCon"

strTable = "tblContact"
strCommand = "spContactList"

set objCmd = server.CreateObject("ADODB.Command")
set objPara = server.CreateObject("ADODB.Parameter")
objCmd.ActiveConnection = con
objCmd.CommandText = strCommand
objCmd.CommandType = 4		

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
</head>
<body>
<form  action="" method="POST" name="frmDetails">
  <Input name="wingID" id="wingID" type="Hidden">
	<table  height="100%" cellspacing=0 cellPadding=0 width=100% border=0>
      <tr>
        <td>
          <!--#include file="Includes/Header.inc"--> 
  		  <table cellSpacing=0 cellPadding=0 width=100% border=0 >
                    <tr style="font-size:10pt;" height=26px>
                        <td width=10><img style="margin-left:10px;" src="cms_icons/png/24x24/process.png" width="24" height="24"></td>
                        <td class="staticdatamenu"><font class="youAreHere">CMS Admin Menu / <strong>Contact </strong></font></td>
                    </tr>
                    <tr><td colspan=2 class=titlearealine  height=1></td></tr>
		</table>
          
  		  <table width=100% height='<%=session("heightIs")%>px' border=0 cellpadding=0 cellspacing=0> 
      		<tr valign=Top>
        	  <td class="sidemenuwidth" background="Images/tableback.png"><!--#include file="Includes/datamenu.inc"--></td>



				  <td width=16></td>
				  <td align=left >
				    <table border=0 cellpadding=0 cellspacing=0 width=100%>
					  <tr height=16 class=SectionHeader>
					    <td>
						  <table border=0 cellpadding=0 cellspacing=0 >
						    <tr>
							  <td class=toolbar width=8>&nbsp;</td>
							  <td width=20><a class=itemfontlink href="AdminContactEdit.asp"><img class="imagelink" src="images/newitem.gif"></a></td>
							  <td class=toolbar valign="middle">Edit Contact</td>
							</tr>  
					      </table>
						</td>
					  </tr>
					  <tr>
					    <td>
						  <table width=100% border=0 cellpadding=0 cellspacing=0>
						    <tr class=columnheading height=20>
							  <td width="2%">&nbsp;</td>
                              <td align="left" width="20%">Email Name</td>
                              <td align="left" width="20%">Email</td>
							  <td align="left" width="10%">Telephone</td>
							  <td align="left" width="48%">Ext</td>
							</tr>
						  	<tr>
       						  <td colspan=5 class=titlearealine  height=1></td> 
     					    </tr>
							<%do while not rsRecSet.eof%>
							  <tr class=itemfont ID="TableRow1" height=30>
								<td align="left" width="2%"></td>
								<td align="left" width="20%"><%=rsRecSet("EmailName")%></td>
				                <td align="left" width="20%"><%=rsRecSet("Email")%></td> 
                                <td align="left" width="10%"><%=rsRecSet("MilPhone")%></td>
                                <td align="left" width="48%"><%=rsRecSet("Ext")%></td>
						      </tr>
  							  <tr>
       						    <td colspan=5 class=titlearealine  height=1></td> 
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
