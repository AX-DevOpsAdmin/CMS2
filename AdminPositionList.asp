<!DOCTYPE HTML >
<!--#include file="Includes/security.inc"--> 
<!--#include file="Includes/checkadmin.asp"-->
<!--#include file="Connection/Connection.inc"-->

<%

' This is the Initial Display Page of Position table data

' so the menu include - datamenu.inc knows what page we're on
dim strPage
strPage="Position"

strTable = "tblPosition"
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
  <Input name="RecID" id="RecID" type="Hidden">

	<table  height="100%" cellspacing=0 cellPadding=0 width=100% border=0>
      <tr>
        <td>
          <!--#include file="Includes/Header.inc"--> 
  		  <table cellSpacing=0 cellPadding=0 width=100% border=0 >
    	    <tr >
      		  <td align="center" class="sidemenuwidth" ><img alt="" src="images/spssites.gif" ></td>
       		  <td  class=titlearea >CMS<BR>
       		    <span class="style1"><Font class=subheading>Positions</Font></span></td>
    		</tr>
  			<tr>
       		  <td colspan=2 class=titlearealine  height=1></td> 
     		</tr>
  		  </table>
  		  <table width=100% height='<%=session("heightIs")%>px' border=0 cellpadding=0 cellspacing=0 > 
      		<tr valign=Top>
        	  <td class="sidemenuwidth" background="Images/tableback.png">
			     <!--#include file="Includes/datamenu.inc"-->
				 <!--
				 <table width=100% border=0 cellpadding=0 cellspacing=0 class=MenuStyleParent>
					  <tr height=20>
          			    <td width=30></td><td colspan=3 align=left height=20>Current Location</td>
					  </tr>
					  <tr height=20>
	          		    <td width=30></td>
						<td width="25" valign=top><img src="images/arrow.gif"></td>
						<td width="132" align=Left  ><A title="" href="index.asp">Home</A></td>
					    <td width="13" align=Left  ></td>
					  </tr>
					  <tr height=20>
	          		    <td width=30 ></td>
						<td valign=top><img src="images/arrow.gif"></td>
						<td align=Left  ><A title="" href="AdminHome.asp">Administration</A></td>
					    <td align=Left  ></td>
					  </tr>
					  <tr height=20>
	          		    <td width=30></td>
						<td valign=top><img src="images/arrow.gif"></td>
						<td align=Left  ><A title="" href="AdminDataMenu.asp">Static Data</a></td>
						<td align=Left  ></td>
					  </tr>
					  <tr height=20>
	          			<td width=30></td>
						<td valign=top><img src="images/vnavicon.gif"></td>
						<td align=Left  ><A title="" href="AdminRankList.asp">Ranks</A></td>
						<td align=Left  ></td>
					  </tr>
					  <tr height=20>
	          			<td width=30></td>
						<td valign=top><img src="images/vnavicon.gif"></td>
						<td align=Left bgcolor="#FFFFFF"><Div style="height:18px; border:Solid; border-width:1px; border-color:#438BE4; color: #003399;"> Positions</Div></td>
					    <td class=rightmenuspace align=Left ></td>
					   </tr>
					  <tr height=20>
	          			<td width=30></td>
						<td valign=top><img src="images/vnavicon.gif"></td>
						<td align=Left  ><A title="" href="AdminTradeList.asp">Trade</A></td>
					    <td align=Left  ></td>
					  </tr>
					  <tr height=20>
	          			<td width=30></td>
						<td valign=top><img src="images/vnavicon.gif"></td>
						<td align=Left  ><A title="" href="">Training Courses</A></td>
						<td align=Left  ></td>
					  </tr>
				  </table>
				  -->
				</td> 
				  <td width=16></td>
				  <td align=left >
				    <table border=0 cellpadding=0 cellspacing=0 width=80%>
					  <tr height=16 class=SectionHeader>
					    <td>
						  <table border=0 cellpadding=0 cellspacing=0 >
						    <tr>
							  <td class=toolbar width=8></td>
							  <td width=20><a class=itemfontlink href="AdminPositionAdd.asp"><img class="imagelink" src="images/newitem.gif"></a></td>
							  <td class=toolbar valign="middle" >New Position</td>
							  <td class=titleseparator valign="middle" width=14 align="center">|</td>
							</tr>  
					      </table>
						</td>
					  </tr>
					  <tr>
					    <td>
						  <table width=100% border=0 cellpadding=0 cellspacing=0>
						    <tr class=columnheading height=20>
							  <td valign="middle" width=2%></td>
							  <td valign="middle" width=20%>Position</td>
							  <td valign="middle" width=56%></td>
							  <td valign="middle" width=20%%></td>
							  <td valign="middle" width=2%></td>
							</tr>
						  	<tr>
       						  <td colspan=5 class=titlearealine  height=1></td> 
     					    </tr>
							<%do while not rsRecSet.eof%>
							  <tr class=itemfont ID="TableRow<%=rsRecSet ("positionID")%>" height=20>
								<td valign="middle" width=2%></td>
				                <td valign="middle"><A class=itemfontlink href="javascript: subForm(<%=rsRecSet("positionID")%>)"><%=rsRecSet("Description")%></A></td> 

								<!--
								<td valign="middle"><%if rsRecSet("Description")="" or isnull(rsRecSet("Description")) then%>
								   <%response.write("There is currently no description for this Position.")%>
								   <%Else response.write rsRecSet("Description")%>
								   <%End if%>
								</td>
								-->
								<td valign="middle" width=2%></td>
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
function subForm(recID){
     document.forms.frmDetails.action = "AdminPositionDetail.asp";
	 document.forms.frmDetails.RecID.value = recID;
	 document.forms.frmDetails.submit(); 
}
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
