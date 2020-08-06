<!DOCTYPE HTML >
<!--#include file="Includes/security.inc"--> 
<!--#include file="Includes/checkadmin.asp"-->
<%
' so the menu include - QMenu.inc knows what page we're on
dim strPage
strPage="AdminQ"
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
                        <td  class=titlearea >Qualifications<BR><span class="style1"><Font class=subheading>Qualifications</Font></span></td>
                    </tr>
                    <tr>
                    	<td colspan=2 class=titlearealine  height=1></td> 
                    </tr>
                </table>
                <table width=100% height='<%=session("heightIs")%>px' border=0 cellpadding=0 cellspacing=0 > 
                	<tr valign=Top>
                		<td class="sidemenuwidth" background="Images/tableback.png"><!--#include file="Includes/QMenu.inc"--></td>
                		<td width=16>&nbsp;</td>
                		<td align=left >
                            <table border=0 cellpadding=0 cellspacing=0 width=100%>
                                <tr height=16 class=SectionHeader>
                                	<td width="12%" class=toolbar>Qualifications</td>
					            </tr>
            					<tr>
            						<td>&nbsp;</td>
            					</tr>
                                <tr>
                                	<td>
                                    	<table width="100%" class="MenuStyleParent" border="0" cellpadding="0" cellspacing="0">
                                        	<tr>
                                            	<td width="2%" class="toolbar">&nbsp;</td>
                                            	<td width="20%" class="toolbar"><a href="AdminQTypeList.asp">Qualification Types</a></td>
                                                <td width="20%" class="toolbar"><a href="AdminQList.asp">Qualifications</a></td>
                                                <td width="20%" class="toolbar"><a href="AdminQWtList.asp">Q Weight</a></td>
                                                <td width="38%">&nbsp;</td>
                                            </tr>
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
