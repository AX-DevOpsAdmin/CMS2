<!DOCTYPE HTML >
<!--#include file="Includes/security.inc"--> 
<!--#include file="Includes/checkadmin.asp"-->
<%
' so the menu include - QMenu.inc knows what page we're on
dim strPage
strPage="PeRs"
%>

<html>

<head> 

<!--#include file="Includes/IECompatability.inc"-->
<title><%= PageTitle %></title>
<link rel="stylesheet" type="text/css" href="Includes/AMDB.css" media="Screen"/>
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
<form  action="" method="POST" name="frmDetails">
  <table  height="100%" cellspacing=0 cellPadding=0 width=100% border=0>
    <tr>
      <td>
        <!--#include file="Includes/Header.inc"-->
		<table cellSpacing=0 cellPadding=0 width=100% border=0 >
    	  <tr >
      	    <td align="center" class="sidemenuwidth" ><img alt="" src="images/spssites.gif" ></td>
       		<td  class=titlearea >Personnel<BR>
       		<span class="style1"><Font class=subheading>Personnel</Font></span></td>
    	  </tr>
  		  <tr>
       		<td colspan=2 class=titlearealine  height=1></td> 
     	  </tr>
  		</table>
  		<table width=100% height='<%=session("heightIs")%>px' border=0 cellpadding=0 cellspacing=0 > 
      	  <tr valign=Top>
            <td class="sidemenuwidth" background="Images/tableback.png">
			</td>
			<td width=16></td>
		    <td align=left >
			  <table border=0 cellpadding=0 cellspacing=0 width=60%>
				<tr height=16 class=SectionHeader>
				  <td>
				     <table border=0 cellpadding=0 cellspacing=0 width=80%>
							<tr height=16 class=SectionHeader>
							  <td width="12%" class=toolbar>Personnel</td>
							</tr>
					</table>
				    <table border=0 cellpadding=0 cellspacing=0 width=85% class=MenuStyleParent>
					  <tr height=16 class="">
					    <td width="5%" class=toolbar>&nbsp;</td>
					    <td width="20%" class=toolbar>&nbsp;</td>
					    <td width="31%" class=toolbar>&nbsp;</td>
					    <td width="44%" class=toolbar>&nbsp;</td>
					  </tr>
					 </table>
				  </td>
				</tr>
				<tr>
				  <td>
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
