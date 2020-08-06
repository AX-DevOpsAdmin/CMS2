<!DOCTYPE HTML >
<!--#include file="Includes/security.inc"--> 
<!--#include file="Includes/checkadmin.asp"-->
<!--#include file="Connection/Connection.inc"-->

<%

' This is the Initial Display Page of Task Type table data

' so the menu include - datamenu.inc knows what page we're on'
dim strPage
strPage="PsTy"

strTable = "tblTaskType"
strCommand = "spListTable"

set objCmd = server.CreateObject("ADODB.Command")
set objPara = server.CreateObject("ADODB.Parameter")
objCmd.ActiveConnection = con
'objCmd.CommandText = strCommand'
objCmd.CommandType = 4		

set objPara = objCmd.CreateParameter ("nodeID",3,1,0, nodeID)
objCmd.Parameters.Append objPara

objCmd.CommandText = "spListTaskTypes"
set rsRecSet = objCmd.Execute	

'set objPara = objCmd.CreateParameter ("TableName",200,1,50, strTable)'
'objCmd.Parameters.Append objPara'
'set rsRecSet = objCmd.Execute	'Execute CommandText when using "ADODB.Command" object
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
	<table  height="100%" cellspacing=0 cellPadding=0 width=100% border=0>
      <tr>
        <td>
          <!--#include file="Includes/Header.inc"--> 
  		  <table cellSpacing=0 cellPadding=0 width=100% border=0 >
                    <tr style="font-size:10pt;" height=26px>
                        <td width=10><img style="margin-left:10px;" src="cms_icons/png/24x24/process.png" width="24" height="24"></td>
                        <td class="staticdatamenu"><font class="youAreHere">CMS Admin Menu / <strong>Task Type</strong></font></td>
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
						  <table width="203" height="17" border=0 cellpadding=0 cellspacing=0 >
						    <tr>
							  <td class=toolbar width=11></td>
							  <td width=22><a class=itemfontlink href="AdminPsTyAdd.asp"><img class="imagelink" src="images/newitem.gif"></a></td>							  
		                      <td width="153" valign="middle" class=toolbar >New Task Type</td>
							</tr>  
					      </table>
						</td>
					  </tr>
					  <tr>
					    <td>
						  <table width=100% border=0 cellpadding=0 cellspacing=0>
						    <tr class=columnheading height=20>
							  <td valign="middle" width=2%></td>
							  <td valign="middle" width=20%>Task Type</td>
							  <td valign="middle" width=10%>Task Colour</td>
                              <td valign="middle" width="68%">&nbsp;</td>
							</tr>
						  	<tr>
       						  <td colspan=4 class=titlearealine  height=1></td> 
     					    </tr>
							<%do while not rsRecSet.eof%>
							  <tr class=itemfont ID="TableRow<%=rsRecSet ("ttID")%>" height=30>
								<td valign="middle" width=2%>&nbsp;</td>
								<td valign="middle" width="20%"><a class=itemfontlink href="AdminPsTyDetail.asp?RecID=<%=rsRecSet("ttID")%>"><%=rsRecSet("Description")%></A></td>
                                <td valign="middle" width="10%" bgcolor="<%=rsRecSet("taskcolor")%>"></td>
								<td valign="middle" width=68%>&nbsp;</td>
					        </tr>
  							  <tr>
       						    <td colspan=4 class=titlearealine height=1></td> 
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
