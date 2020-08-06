<!DOCTYPE HTML >
<!--#include file="Includes/security.inc"--> 
<!--#include file="Includes/checkadmin.asp"-->
<!--#include file="Connection/Connection.inc"-->

<%

' This is the Initial Display Page of Task Category table data

' so the menu include - datamenu.inc knows what page we're on
dim strPage
strPage="OpTc"

strTable = "tblOpTaskCategory"
strCommand = "spListTable"

set objCmd = server.CreateObject("ADODB.Command")
set objPara = server.CreateObject("ADODB.Parameter")
objCmd.ActiveConnection = con
objCmd.CommandText = strCommand
objCmd.CommandType = 4		

set objPara = objCmd.CreateParameter ("TableName",200,1,50, strTable)
objCmd.Parameters.Append objPara
set rsRecSet = objCmd.Execute	'Execute CommandText when using "ADODB.Command" object
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
</style>

</head>
<body>
<form  action="" method="POST" name="frmDetails">
	<table  height="100%" cellspacing=0 cellPadding=0 width=100% border=0>
      <tr>
        <td>
          <!--#include file="Includes/Header.inc"--> 
  		  <table cellSpacing=0 cellPadding=0 width=100% border=0 >
    	    <tr >
      		  <td align="center" class="sidemenuwidth" ><img alt="" src="images/spssites.gif" ></td>
       		  <td  class=titlearea >CMS<BR>
       		  <span class="style1"><Font class=subheading> Op Task Category </Font></span></td>
    		</tr>
  			<tr>
       		  <td colspan=2 class=titlearealine  height=1></td> 
     		</tr>
  		  </table>
  		  <table width=100% height='<%=session("heightIs")%>px' border=0 cellpadding=0 cellspacing=0 > 
      		<tr valign=Top>
        	  <td class="sidemenuwidth" background="Images/tableback.png">
			     <!--#include file="Includes/Opmenu.inc"-->
				</td> 
				  <td width=16></td>
				  <td align=left >
				    <table border=0 cellpadding=0 cellspacing=0 width=80%>
					  <tr height=16 class=SectionHeader>
					    <td>
						  <table width="176" border=0 cellpadding=0 cellspacing=0 >
						    <tr>
							  <td class=toolbar width=9></td>
							  <td width=22><a class=itemfontlink href="AdminOpTcAdd.asp"><img class="imagelink" src="images/newitem.gif"></a></td>
							  <td width="141" valign="middle" class=toolbar >New Op Task Category</td>
							  <td class=titleseparator valign="middle" width=10 align="center">|</td>
							</tr>  
					      </table>
						</td>
					  </tr>
					  <tr>
					    <td>
						  <table width=100% border=0 cellpadding=0 cellspacing=0>
						    <tr class=columnheading height=20>
							  <td valign="middle" width=1%></td>
							  <td valign="middle" width=27%>Task Category</td>
							  <td valign="middle" width=36%> </td>
							</tr>
						  	<tr>
       						  <td colspan=5 class=titlearealine  height=1></td> 
     					    </tr>
							<%do while not rsRecSet.eof%>
							  <tr class=itemfont ID="TableRow<%=rsRecSet ("otcID")%>" height=20>
								<td valign="middle" width=1%></td>
								<td valign="middle"><A class=itemfontlink href="AdminOpTcDetail.asp?RecID=<%=rsRecSet("otcID")%>"><%=rsRecSet("Description")%></A></td>
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
