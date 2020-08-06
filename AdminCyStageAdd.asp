<!DOCTYPE HTML >
<!--#include file="Includes/security.inc"--> 
<!--#include file="Includes/checkadmin.asp"-->
<!--#include file="Connection/Connection.inc"-->
<%
dim strAction
strAction="Add"
%>

<html>
<head>

<!--#include file="Includes/IECompatability.inc"-->
 <title><%= PageTitle %></title>
<link rel="stylesheet" type="text/css" href="Includes/AMDB.css" media="Screen"/>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">

</head>
<body>
<form  action="UpdateCyStage.asp?strAction=<%=strAction%>" method="POST" name="frmDetails">
  <input type="hidden" name="CycleID"  id="CycleID" value="<%=request("CycleID")%>">  
  <table  height="100%" cellspacing=0 cellPadding=0 width=100% border=0>
    <tr>
      <td>
        <!--#include file="Includes/Header.inc"-->
  	  	<table cellSpacing=0 cellPadding=0 width=100% border=0 >
                    <tr style="font-size:10pt;" height=26px>
                        <td width=10><img style="margin-left:10px;" src="cms_icons/png/24x24/process.png" width="24" height="24"></td>
                        <td class="staticdatamenu"><font class="youAreHere">CMS Admin Menu / <strong>Add New Cycle Stage</strong></font></td>
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
						<td class=toolbar width=8></td>
						<td width=20><a  href="javascript:checkThis();"><img class="imagelink" src="images/saveitem.gif"></A></td>
						<td class=toolbar valign="middle" >Save and Close</td>
						<td class=titleseparator valign="middle" width=14 align="center">|</td>
						<td class=toolbar valign="middle" ><A class= itemfontlink href="AdminCyStageList.asp">Back To List</A></td>											
					</table>
				  </td>
				</tr>
				<tr>
				  <td>
					<table width=100% border=0 cellpadding=0 cellspacing=0>
					  <tr height=16>
					    <td colspan="3">&nbsp;</td>
					  </tr>
					  <tr class=columnheading height=22>
                      	<td valign="middle" width="2%">&nbsp;</td>
					    <td valign="middle" width="13%">Description:</td>
						<td valign="middle" width="85%"><input type="text" class="itemfont" name="description" id="description" height=""></td>
					  </tr>
					  <tr height=16>
					    <td colspan="3">&nbsp;</td>
					  </tr>
					  <tr>
       					 <td colspan=3 class=titlearealine  height=1></td> 
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

     var desc = document.frmDetails.description.value; 
	 //var era = document.frmDetails.txtdays.value;
 	 //var fcs = document.frmDetails.txtfcs.value;
	 var chk ="1234567890";
	 var chknum
	 var chkOK = 0
	 var chr
	 
     var errMsg = "";
	/* make sure they entered a era 
	if(!era.length > 0) {
	   errMsg += "Please enter the Cycle length in days\n"
	   document.frmDetails.txtdays.focus(); 
	   }
	   
	/* now make sure its numeric 
	for (var i=0;i<era.length; i++){
	   chr = era.charAt(i);
	   
	   for (var j=0; j<chk.length; j++){
	     if (chr == chk.charAt(j)) break;
		 
		 if (j+1 ==chk.length) {
		    chkOK=1
	     }		
	   } 
	}
	if(chkOK==1){
	  	  errMsg += "Cycle Days MUST be numeric\n" 
		  document.frmDetails.txtdays.focus(); 
	  }   
	  
	now check fcs  
    chkOK=0;
	
	if(!fcs.length > 0) {
	   errMsg += "Please enter the FCS Number\n"
	   document.frmDetails.txtfcs.focus(); 
	   }
	   
	/* now make sure its numeric 
	for (var i=0;i<fcs.length; i++){
	   chr = fcs.charAt(i);
	   
	   for (var j=0; j<chk.length; j++){
	     if (chr == chk.charAt(j)) break;
		 
		 if (j+1 ==chk.length) {
		    chkOK=1
	     }		
	   } 
	}
	if(chkOK==1){
	  	  errMsg += "FCS MUST be numeric\n" 
		  document.frmDetails.txtfcs.focus(); 
	  }   
     */
	/* make sure they have entered comments for the next stage */
    if(!desc.length > 0) {
	   errMsg += "Please enter the Cycle Stage Description\n"
	   document.frmDetails.description.focus(); 
	   }
	   
	if(!errMsg=="") {
	  alert(errMsg)
	  return;	  		
	} 
	
    document.frmDetails.submit();  
}

/*
function checkNum(){
  var vpl = document.frmDetails.vpLength.value;
   if(((vpl / vpl) != 1) && (vpl != 0)){
   	  	  errMsg += "Validity Period Length MUST be numeric\n" 
		  document.frmDetails.vpLength.focus(); 
   }
    
}

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
