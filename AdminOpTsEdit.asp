<!DOCTYPE HTML >
<!--#include file="Includes/security.inc"--> 
<!--#include file="Includes/checkadmin.asp"-->
<!--#include file="Connection/Connection.inc"-->

<%
dim strAction
strAction="Update"

strTable = "tblTaskStatus"
strRecid = "otsID"
strCommand = "spRecDetail"

set objCmd = server.CreateObject("ADODB.Command")
set objPara = server.CreateObject("ADODB.Parameter")
objCmd.ActiveConnection = con
objCmd.CommandText = strCommand
objCmd.CommandType = 4		

set objPara = objCmd.CreateParameter ("RecID",3,1,5, request("RecID"))
objCmd.Parameters.Append objPara
set objPara = objCmd.CreateParameter ("TableID",200,1,50, strRecID)
objCmd.Parameters.Append objPara
set objPara = objCmd.CreateParameter ("Tablename",200,1,50, strTable)
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
</style></head>
<body>
<!-- <form  action="UpdateOperational Task.asp?strAction=<%=strAction%>" method="POST" name="frmDetails"> -->
<form  action="UpdateOpTs.asp?strAction=<%=strAction%>&strTable=<%=strTable%>&strTabid=<%=strRecID%>" method="POST" name="frmDetails">
  <input type="hidden" name="RecID" id="RecID" value="<%=request("RecID")%>"> 
  <table  height="100%" cellspacing=0 cellPadding=0 width=100% border=0>
    <tr>
      <td>
        <!--#include file="Includes/Header.inc"--> 
  		  <table cellSpacing=0 cellPadding=0 width=100% border=0 >
    	    <tr >
      		  <td align="center" width=200 ><img alt="" src="images/spssites.gif" ></td>
       		  <td  class=titlearea >Operational Tasks<BR>
       		  <span class="style1"><Font class=subheading>Edit Operational Task Status Details</Font></span></td>
    		</tr>
  			<tr>
       		  <td colspan=2 class=titlearealine  height=1></td> 
     		</tr>
  		  </table>
  		  <table width=100% height='<%=session("heightIs")%>px' border=0 cellpadding=0 cellspacing=0 > 
      	    <tr valign=Top>
        	  <td width=200 background="Images/tableback.png">
			    <table width=104% border=0 cellpadding=0 cellspacing=0 class=MenuStyleParent>
				  <tr height=20>
          		    <td width=11></td>
					<td colspan=3 align=left height=20>Current Location</td>
				  </tr>
				  <tr height=20>
	          	    <td width=11></td>
				    <td width="18" valign=top><img src="images/arrow.gif"></td>
				    <td width="165" align=Left  ><A title="" href="index.asp">Home</A></td>
					<td width="6" align=Left  ></td>
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
				    <td align=Left  ><A title="" href="AdminOpTsList.asp">Operational Tasks</a></td>
				    <td align=Left  ></td>
				  </tr>
				  <tr height=20>
	          	    <td width=11></td>
				    <td valign=top><img src="images/arrow.gif"></td>
                    <td align=Left  ><A title="" href="AdminOpTsDetail.asp?RecID=<%=request("RecID")%>">Op Task Status Details</a></td>
					<td class=rightmenuspace align=Left ></td>
				  </tr>
				  <tr height=20>
	          	    <td width=11></td>
				    <td valign=top><img src="images/vnavicon.gif"></td>
					<td align=Left bgcolor="#FFFFFF"><Div style="height:18px; border:Solid; border-width:1px; border-color:#438BE4; color: #003399;">Edit Op Task Status </Div></td>
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
						<td class=toolbar valign="middle" >Save and Close</td><td class=titleseparator valign="middle" width=14 align="center">|</td>
						<td class=toolbar valign="middle" ><A class= itemfontlink href="AdminOpTsDetail.asp?RecID=<%=request("RecID")%>">Back</A></td>											
					 </table>
					</td>
			      </tr>
				  <tr>
					<td>
					  <table width=111% border=0 cellpadding=0 cellspacing=0>
						<tr height=16>
						  <td></td>
						</tr>
						<tr class=columnheading height=22>
						  <td valign="middle" width=14></td>
						  <td valign="middle" width=94>Op Task Status:</td>
						  <td valign="middle" width=327>
						    <INPUT class="itemfont" style="WIDTH: 300px" maxLength="200" name="description" id="description" Value="<%=rsRecSet("Description")%>"></td>
						  <td valign="middle" width=59></td>
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
<%
rsRecSet.close
set rsRecSet=Nothing
con.close
set con=Nothing
%>
</body>
</html>

<SCRIPT LANGUAGE="JavaScript">
function checkThis(){

     var txt = document.frmDetails.description.value; 
     var errMsg = "";
	  
	/* make sure they have entered comments for the next stage */
    if(!txt.length > 0) {
	   errMsg += "You must enter a Operational Task\n"
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
