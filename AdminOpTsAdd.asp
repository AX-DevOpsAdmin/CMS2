<!DOCTYPE HTML >
<!--#include file="Includes/security.inc"--> 
<!--#include file="Includes/checkadmin.asp"-->
<!--#include file="Connection/Connection.inc"-->
<%
dim strAction
dim strTable

strAction="Add"
strTable = "tblTaskStatus"

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
<form  action="UpdateOpTs.asp?strAction=<%=strAction%>&strTable=<%=strTable%>" method="POST" name="frmDetails">
  <input type="hidden" name="RecID" id="RecID" value="<%=request("RecID")%>">  
  <table  height="100%" cellspacing=0 cellPadding=0 width=100% border=0>
    <tr>
      <td>
        <!--#include file="Includes/Header.inc"-->
  	    <table cellSpacing=0 cellPadding=0 width=100% border=0 >
    	  <tr >
      		<td align="center" width=200 ><img alt="" src="images/spssites.gif" ></td>
       		<td  class=titlearea >Operational Tasks <BR>
   		    <span class="style1"><Font class=subheading>New Operational Task Status </Font></span></td>
    	  </tr>
  		  <tr>
       		<td colspan=2 class=titlearealine  height=1></td> 
     		</tr>
  		</table>
  		<table width=100% height='<%=session("heightIs")%>px' border=0 cellpadding=0 cellspacing=0 > 
      	  <tr valign=Top>
        	<td width=200 background="Images/tableback.png">
			  <table width=100% border=0 cellpadding=0 cellspacing=0 class=MenuStyleParent>
			    <tr height=20>
          		  <td width=11></td>
				  <td colspan=3 align=left height=20>Current Location</td>
				</tr>
				<tr height=20>
	          	  <td width=11></td>
				  <td width="18" valign=top><img src="images/arrow.gif"></td>
				  <td width="162" align=Left  ><A title="" href="index.asp">Home</A></td>
				  <td width="9" align=Left  ></td>
			    </tr>
				<tr height=20>
	          	  <td width=11 ></td>
	              <td valign=top><img src="images/arrow.gif"></td>
				  <td align=Left  ><A title="" href="AdminHome.asp">Administration</A></td>
				  <td align=Left  ></td>
				</tr>
				<tr height=20>
	          	  <td width=11></td>
				  <td valign=top><img src="images/arrow.gif"></td>
				  <td align=Left  ><A title="" href="AdminDataMenu.asp">Static Data</a></td>
				  <td align=Left  ></td>
				</tr>
				<tr height=20>
	          	  <td width=11></td>
				  <td valign=top><img src="images/arrow.gif"></td>
			      <td align=Left  ><A title="" href="AdminOpTasks.asp">Operational Tasks</a></td>
			      <td align=Left  ></td>
				</tr>
				<tr height=20>
	          	  <td width=11></td>
				  <td valign=top><img src="images/vnavicon.gif"></td>
				  <td align=Left bgcolor="#FFFFFF"><Div style="height:18px; border:Solid; border-width:1px; border-color:#438BE4; color: #003399;">New Op Task Status</Div></td>
				  <td align=Left  ></td>
				</tr>
			  </table>
			</td>
			<td width=16></td>
		    <td align=left >
			  <table border=0 cellpadding=0 cellspacing=0 width=60%>
				<tr height=16 class=SectionHeader>
				  <td>
					<table border=0 cellpadding=0 cellspacing=0 >
						<td class=toolbar width=8></td>
						<td width=20><a  href="javascript:checkThis();"><img class="imagelink" src="images/saveitem.gif"></A></td>
						<td class=toolbar valign="middle" >Save and Close</td>
						<td class=titleseparator valign="middle" width=14 align="center">|</td>
						<td class=toolbar valign="middle" ><A class= itemfontlink href="AdminOpTsList.asp">Back To List</A></td>											
					</table>
				  </td>
				</tr>
				<tr>
				  <td>
					<table width=100% border=0 cellpadding=0 cellspacing=0>
					  <tr height=16>
					    <td></td>
					  </tr>
					  <tr class=columnheading height=22>
			            <td valign="middle" width=2%></td>
						<td valign="middle" width=15%>Description:</td>
						<td valign="middle" width=76% >
						 <INPUT name="description" class="itemfont" id="description" style="WIDTH: 360px" Value="" maxLength=300></td>
						<td valign="middle" width=2%></td>
					  </tr>
					  <tr height=16>
					    <td></td>
					  </tr>
					  <tr>
       					 <td colspan=5 class=titlearealine  height=1></td> 
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
function checkThis(){

     var txt = document.frmDetails.description.value; 
     var errMsg = "";
	  
	/* make sure they have entered comments for the next stage */
    if(!txt.length > 0) {
	   errMsg += "You must enter a Description\n"
	   document.frmDetails.description.focus(); 
	   }
	  	   
	if(!errMsg=="") {
	  alert(errMsg)
	  return;	  		
	} 
	
    document.frmDetails.submit();  
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
