<!DOCTYPE HTML >
<!--#include file="Includes/security.inc"--> 
<!--#include file="Includes/checkadmin.asp"-->
<!--#include file="Connection/Connection.inc"-->

<%
dim strAction
strAction="ADD"

strTable = "tblCycle"
strRecid = "cyID"

' set basic commands
set objCmd = server.CreateObject("ADODB.Command")
set objPara = server.CreateObject("ADODB.Parameter")
objCmd.ActiveConnection = con
objCmd.CommandType = 4		

' now get any stages attached to this cycle
strCommand = "spGetCurrStages"
set objPara = objCmd.CreateParameter ("RecID",3,1,5, request("RecID"))
objCmd.Parameters.Append objPara
objCmd.CommandText = strCommand
set rsCySteps = objCmd.Execute

' now get any that are available to ADD
'strCommand = "spGetAvailStages"
'objCmd.CommandText = strCommand
'set rsCyAdd = objCmd.Execute


' now get the Cycle 
strCommand = "spRecDetail"
set objPara = objCmd.CreateParameter ("TableID",200,1,50, strRecID)
objCmd.Parameters.Append objPara
set objPara = objCmd.CreateParameter ("Tablename",200,1,50, strTable)
objCmd.Parameters.Append objPara
objCmd.CommandText = strCommand
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
<form  action="AddCycleStages.asp?strAction=<%=strAction%>" method="POST" name="frmDetails">
  <input type="hidden" name="RecID" id="RecID" value="<%=request("RecID")%>">
  
  <table  height="100%" cellspacing=0 cellPadding=0 width=100% border=0>
    <tr>
      <td>
        <!--#include file="Includes/Header.inc"--> 
  		 	<table cellSpacing=0 cellPadding=0 width=100% border=0 >
                    <tr style="font-size:10pt;" height=26px>
                        <td width=10><img style="margin-left:10px;" src="cms_icons/png/24x24/process.png" width="24" height="24"></td>
                        <td class="staticdatamenu"><font class="youAreHere">CMS Admin Menu / <strong>Remove Cycle Stages</strong></font></td>
                    </tr>
                    <tr><td colspan=2 class=titlearealine  height=1></td></tr>
				</table>
          
  		  <table width=100% height='<%=session("heightIs")%>px' border=0 cellpadding=0 cellspacing=0> 
      		<tr valign=Top>
        	  <td class="sidemenuwidth" background="Images/tableback.png"><!--#include file="Includes/datamenu.inc"--></td>
			  <td width=10></td>
			  <td align=left >
			    <table border=0 cellpadding=0 cellspacing=0 width=100%>
				  <tr height=16 class=SectionHeader>
					<td>
					  <table border=0 cellpadding=0 cellspacing=0 >
					    <td class=toolbar width=8></td>
						<td width=20><a  href="javascript:saveNew();"><img class="imagelink" src="images/saveitem.gif"></A></td>
						<td class=toolbar valign="middle" >Save and Close</td><td class=titleseparator valign="middle" width=14 align="center">|</td>
						<td class=toolbar valign="middle" ><A class= itemfontlink href="AdminCycleDetail.asp?RecID=<%=request("RecID")%>">Back</A></td>											
					 </table>
					</td>
			      </tr>
				  <tr>
					<td>
					<table width=100% border=0 cellpadding=0 cellspacing=0>
					  <tr height=16>
						<td colspan="7">&nbsp;</td>
					  </tr>
					  <tr class=columnheading height=22>
					    <td valign="middle" width=2%>&nbsp;</td>
						<td valign="middle" width=13%>Cycle:</td>
						<td colspan="5" valign="middle" class=itemfont><%=rsRecSet("Description")%></td>
					  </tr>
					  <tr class=columnheading height=22>
					    <td valign="middle" width=2%>&nbsp;</td>
					    <td valign="middle" width="13%">Cycle Days:</td>
						<td colspan="5" valign="middle" class=itemfont><%=rsRecSet("cydays")%></td>
					  </tr>
					  <tr class=columnheading height=22>
					    <td valign="middle" width=2%>&nbsp;</td>
					    <td valign="middle" width="13%">Cycle Stages:</td>
						<td valign="middle" width="3%">&nbsp;</td>
                        <td valign="middle" width="30%">Cycle Stages Available</td>
                        <td valign="middle" width="3%">&nbsp;</td>
                        <td valign="middle" width="30%">Cycle Stages to Remove</td>
                        <td valign="middle" width="21%">&nbsp;</td>
                      </tr>
					  <tr class=columnheading height=22>
					    <td valign="middle" width=3%>&nbsp;</td>
						<td valign=top width=13% class=itemfont>&nbsp;</td>
                        <td valign="middle" width="3%">&nbsp;</td>
                        <td valign="top" width="30%" class="itemfont"><select name="lstAttached" size="10" multiple class="pickbox" id="lstAttached" onChange="remAttached()">
                          <%do while not rsCySteps.eof%>
                          <option value = "<%= rsCySteps("cysID") %>" ><%= rsCySteps("description") %></option>
                          <% rsCySteps.movenext
			                loop%>
                        </select>
                        <td valign="middle" width="3%">&nbsp;</td>
						<td valign=middle% class=itemfont>
						   <select name="pickAttached"  size="10" class="pickbox" id="pickAttached" onChange="addAttached()">
					       </select>
						</td>
                        <td valign="middle" width="21%">&nbsp;</td>
					  </tr>
					  <tr height=16>
						<td></td>
					  </tr>
					  <tr>
       					<td colspan=7 class=titlearealine  height=1></td> 
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
    <input name="hiddenChange" id="hiddenChange"  type="hidden" value="">
  <input name="currStages" id="currStages" type="hidden" value="<%=strCurrStages%>">
  <input name="newattached" id="newattached" type="hidden" value="">
  <input type="hidden" name="ReturnTo" id="ReturnTo" value="AdminCycleDetail.asp"> 
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

     var desc = document.frmDetails.description.value; 
	 var era = document.frmDetails.txtdays.value;
 	 //var fcs = document.frmDetails.txtfcs.value;
	 var chk ="1234567890";
	 var chknum
	 var chkOK = 0
	 var chr
	 
     var errMsg = "";
	/* make sure they entered a era */
	if(!era.length > 0) {
	   errMsg += "Please enter the Cycle Length in Days\n"
	   document.frmDetails.txtdays.focus(); 
	   }
	   
	/* now make sure its numeric */
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
	  
	/* now check fcs */  
	/*
    chkOK=0;
	
	if(!fcs.length > 0) {
	   errMsg += "Please enter the FCS Number\n"
	   document.frmDetails.txtfcs.focus(); 
	   }
	*/  
	/* now make sure its numeric */
	/*
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
	   errMsg += "Please enter the Cycle Description\n"
	   document.frmDetails.description.focus(); 
	   }
	   
	if(!errMsg=="") {
	  alert(errMsg)
	  return;	  		
	} 
	
    document.frmDetails.submit();  
}

function remAttached(){

    /* we've clicked on an Attachment to REMOVE it */
	var list, field, location, picked, txt;
	var newattached;
		
	list = document.forms['frmDetails']['pickAttached'];        /* list of Sections to REMOVE */
	location = document.forms['frmDetails']['lstAttached'];     /* list of Sections that can be REMOVED */
	field = document.frmDetails.lstAttached.options.value ;     /* Section selected to REMOVE */
	
	/* this is the value for the assigned list */
	/* newattached = document.frmAdmin.lstLocation.value + "|" + field;  */
	document.frmDetails.hiddenChange.value = "true";
	
	var inum = 2000
	for (var i = 0; i < location.options.length; i++){
	  if (field == document.frmDetails.lstAttached[i].value)
	     inum = i ;
	}
			 
    txt=document.frmDetails.lstAttached.options[inum].text;
	list.options[list.options.length] = new Option(txt,field,false); /* true would select it */

	document.frmDetails.lstAttached[inum] = null;
	
	/* if we just clicked on last entry don't try to
	   assign focus - cos theres nowt there */
	if (document.frmDetails.lstAttached.options.length != 0) {  
		document.frmDetails.lstAttached[0].focus();
	}	
}

/* clicked on assigned list - this will remove entry they clicked
   from the list and put it back on unassigned list */
function addAttached(){
	var list, field, location, current;
	var cval, ctxt, cstr;
	var newattached;
	
	re = /,/; 
	lstxt= new Array;
	lsval= new Array;

	list = document.forms['frmDetails']['lstAttached'];      /* Available list */
	location = document.forms['frmDetails']['pickAttached']; /* REMOVE list */
	field = document.frmDetails.pickAttached.options.value;  /* Entry in REMOVE list they clicked to remove */

    /* now get text from the selected entry so we can replace it in unassigned list */
	var inum = 2000
	for (var i = 0; i < location.options.length; i++){
	  if (field == document.frmDetails.pickAttached[i].value) {
	     newattached= document.frmDetails.pickAttached[i].text;
	     inum = i ;
		 }
	}
	
	list.options[list.options.length] = new Option(newattached,field,false); /* true would select it */

    var icount = 0;
	/* lstxt[0]= newattached + "," + field; */
	for (var i = 0; i < list.options.length; i++){	    
	    lsval[icount]= document.frmDetails.lstAttached[i].value;
		lstxt[icount]= document.frmDetails.lstAttached[i].text + "," + document.frmDetails.lstAttached[i].value;
		icount++;
	}

    lsval.sort();
	lstxt.sort();
	for (var i = 0; i < lstxt.length; i ++){
	    current = lstxt[i];
		/* alert("current is " + current); */
		/* cstr= split(current, ","); */
		cstr = current.split(re);
		ctxt= cstr[0];
		cval= cstr[1]; 
		/*alert("strings are " + ctxt + " " + cval);*/
        document.frmDetails.lstAttached[i].value = cval;
		document.frmDetails.lstAttached[i].text = ctxt;
	}
 
	document.frmDetails.pickAttached[inum] = null;
	document.frmDetails.pickAttached.selectedIndex=-1
	
	/* There is nothing picked to remove - so make sure change flag is unset */
    if (document.frmDetails.pickAttached.options.length == 0){
		  document.frmDetails.hiddenChange.value = "";
	}
}

/* clicked the SUBMIT button - so write the changes to the database  via writeGroups.asp */
function saveNew(){
    var list, field, location, current;
	//var newattached;
	//var newlocations;
	var newattached;
	//var currstages = document.frmDetails.currStages.value;
	var errMsg = "";
	
	/* not picked any so ignore submit */		
    if (document.frmDetails.hiddenChange.value == "") {
		  errMsg += "There are no Stages to Remove from this Cycle\n"
	      document.frmDetails.lstAttached.focus(); 
	}

    /* now build the  list - if any - to be add - BUT 
	   include any EXISTING stages cos they MUST be kept in order
	if (document.frmDetails.pickAttached.options.length != 0) {
         list = document.frmDetails.pickAttached.value;
	
	     /* now build hidden value with list of Stages NOT removed then these will be added again
		    once the existing ones are deleted 
	     newattached = document.frmDetails.pickAttached[0].value  + ","; 
		
	     for (var i = 1; i < document.frmDetails.pickAttached.options.length; i++){
	           newattached = newattached + document.frmDetails.pickAttached[i].value  + ","
	     }
         document.frmDetails.newattached.value = newattached;
     }
   */
   	if (document.frmDetails.lstAttached.options.length != 0) {
         list = document.frmDetails.lstAttached.value;
	
	     /* now build hidden value with list of Stages NOT removed then these will be added again
		    once the existing ones are deleted */
	     newattached = document.frmDetails.lstAttached[0].value  + ","; 
		
	     for (var i = 1; i < document.frmDetails.lstAttached.options.length; i++){
	           newattached = newattached + document.frmDetails.lstAttached[i].value  + ","
	     }
         document.frmDetails.newattached.value = newattached;
     }

   
   if(!errMsg=="") {
	  alert(errMsg)
	  return;	  		
	} 

	document.frmDetails.hiddenChange.value = "";
	//alert("Remaining stages are " + document.frmDetails.newattached.value);   
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
