<!DOCTYPE HTML >

<!--#include file="Includes/security.inc"--> 
<!--#include file="Includes/checkadmin.asp"-->
<!--#include file="Connection/Connection.inc"-->

<%
' so the menu include - datamenu.inc knows what page we're on
dim strPage
strPage="MS"


set objCmd = server.CreateObject("ADODB.Command")
objCmd.ActiveConnection = con
objCmd.CommandText = "spListMilitaryskills"	'Name of Stored Procedure
objCmd.CommandType = 4				'Code for Stored Procedure

set objPara = objCmd.CreateParameter ("nodeID",3,1,5, nodeID)
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
<form action="" method="POST" name="frmDetails">
	<table  height="100%" cellspacing=0 cellPadding=0 width=100% border=0>
		<tr>
			<td>
				<!--#include file="Includes/Header.inc"--> 
				<table cellSpacing=0 cellPadding=0 width=100% border=0 >
                    <tr style="font-size:10pt;" height=26px>
                        <td width=10><img style="margin-left:10px;" src="cms_icons/png/24x24/process.png" width="24" height="24"></td>
                        <td class="staticdatamenu"><font class="youAreHere">CMS Admin Menu / <strong>Military Skills</strong></font></td>
                    </tr>
                    <tr><td colspan=2 class=titlearealine  height=1></td></tr>
				</table>
          
  		  <table width=100% height='<%=session("heightIs")%>px' border=0 cellpadding=0 cellspacing=0> 
      		<tr valign=Top>
        	  <td class="sidemenuwidth" background="Images/tableback.png"><!--#include file="Includes/datamenu.inc"--></td>



						<td align=left>
							<table border=0 cellpadding=0 cellspacing=0 width=100%>
								<tr class=SectionHeader>
									<td>
										<table border=0 cellpadding=0 cellspacing=0>
											<tr>
												<td height="25px" class=toolbar width=8></td>
												<td height="25px" width=20><a class=itemfontlink href="AdminMSAdd.asp"><img class="imagelink" src="images/newitem.gif"></a></td>
												<td height="25px" class=toolbar valign="middle">New Military Skill</td>
											</tr>  
					    				</table>
									</td>
								</tr>
								<tr>
					    			<td>
										<table width="100%" border="0" cellpadding="0" cellspacing="0">
						    				<tr class="columnheading" height="30">
												<td align="center" width="2%">&nbsp;</td>
												<td align="left" width="30%">Military Skill</td>
												<td align="left" width="10%">Validity Period</td>
												<td align="center" width="15%">Amber Period (Days)
												<td align="center" width="10%">Exempt</td>
												<td align="center" width="12%">Combat Ready</td>
												<td align="center" width="12%">FE@R</td>
												<td align="left" width="9%">&nbsp;</td>                              
											</tr>
						  	<tr>
       						  <td colspan="8" class="titlearealine" height="1"></td> 
     					    </tr>
							<%do while not rsRecSet.eof%>
							  <tr class="itemfont" ID="TableRow<%=rsRecSet("MSID")%>" height="30">
								<td align="center" width="2%"></td>
								<td align="left" width="30%"><A class=itemfontlink href="AdminMSDetail.asp?RecID=<%=rsRecSet("MSID")%>"><%=rsRecSet("MSDescription")%></A></td>
								<td align="left" width="10%"><%=rsRecSet("ValidityPeriod")%></td>
								<td align="center" width="15%"><%= rsRecSet("Amber") %></td>
								<td align="center" width="10%"><% if rsRecSet("Exempt") = 1 then %><img src="Images/yes.gif"><% end if %></td>
								<td align="center" width="12%"><% if rsRecSet("Combat") = true then %><img src="Images/yes.gif"><% end if %></td>
								<td align="center" width="12%"><% if rsRecSet("Fear") = true then %><img src="Images/yes.gif"><% end if %></td>                                
								<td align="left" width="9%">&nbsp;</td>
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

<SCRIPT LANGUAGE="JavaScript">
/**
function OverBackgroundChange(itemID){
    itemID.className='testTabHover';
}

function OutBackgroundChange(itemID){
    itemID.className='testTabUnselected';
}
RowColor=1
function ChangeRowColor(RowID){
	if (RowColor == 1) {
		document.all[RowID].style.backgroundColor= '#eeeeee'
		RowColor=2
	} else {
		document.all[RowID].style.backgroundColor= '#ffffff'
		RowColor=1
	}	
}
function ConfirmRefuse (LoanID, Action) {
	document.forms["Form"].elements["LoanID"].value=LoanID;
	document.forms["Form"].elements["ConfirmOrRefuse"].value=Action;
	document.forms["Form"].submit();
}
**/
</Script>
