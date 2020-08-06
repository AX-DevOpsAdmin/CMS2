<!DOCTYPE HTML >

<!--#include file="Includes/security.inc"--> 
<!--#include file="Includes/checkadmin.asp"-->
<!--#include file="Connection/Connection.inc"-->

<%

' so the menu include - datamenu.inc knows what page we're on
dim strPage
strPage="Dent"

set objCmd = server.CreateObject("ADODB.Command")
objCmd.ActiveConnection = con
objCmd.CommandText = "spListDental"	'Name of Stored Procedure
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
<form  action="" method="POST" name="frmDetails">
	<table  height="100%" cellspacing=0 cellPadding=0 width=100% border=0>
      <tr>
        <td>
          <!--#include file="Includes/Header.inc"--> 
  		  <table cellSpacing=0 cellPadding=0 width=100% border=0 >
                    <tr style="font-size:10pt;" height=26px>
                        <td width=10><img style="margin-left:10px;" src="cms_icons/png/24x24/process.png" width="24" height="24"></td>
                        <td class="staticdatamenu"><font class="youAreHere">CMS Admin Menu / <strong>Dental</strong></font></td>
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
					  <tr height=16 class=SectionHeader>
					    <td>
						  <table border=0 cellpadding=0 cellspacing=0 >
						    <tr>
							  <td class=toolbar width=8></td>
							  <td width=20><a class=itemfontlink href="AdminDentalAdd.asp"><img class="imagelink" src="images/newitem.gif"></a></td>
							  <td class=toolbar valign="middle">New Dental</td>
							</tr>  
					      </table>
						</td>
					  </tr>
					  <tr>
					    <td>
						  <table width=100% border=0 cellpadding=0 cellspacing=0>
						    <tr class=columnheading height=20>
							  <td align="center" width=2%>&nbsp;</td>
							  <td align=left width=20%>Dental</td>
							  <td align=left width=20%>Validity Period</td>
							  <td align="center" width=16%>Combat Ready</td>
                              <td align="center" width=42%>&nbsp;</td>
							</tr>
						  	<tr>
       						  <td colspan=5 class=titlearealine  height=1></td> 
     					    </tr>
							<%do while not rsRecSet.eof%>
							  <tr class=itemfont ID="TableRow<%=rsRecSet ("DentalID")%>" height=20>
								<td align="center" width=2%></td>
								<td align=left width=20%><A class=itemfontlink href="AdminDentalDetail.asp?RecID=<%=rsRecSet("DentalID")%>"><%=rsRecSet("Description")%></A></td>
								<td align=left width=20%><%=rsRecSet("ValidityPeriod")%></td>
								<td align="center" width=16%><% if rsRecSet("Combat") = true then %><img src="Images/yes.gif"><% end if %></td>
								<td align="center" width=42%>&nbsp;</td>
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

</body>
</html>
