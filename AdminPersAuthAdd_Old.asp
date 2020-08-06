<!DOCTYPE HTML >

<!--#include file="Includes/security.inc"--> 
<!--#include file="Connection/Connection.inc"-->
<!--include file="Includes/checkmanager.inc"-->  

<%

	'If user is not valid Authorisation Administrator then log them off
	If session("authadmin") <> 1 then
		Response.redirect("noaccess.asp")
	End If

tab=4
strTable = "tblstaff"
strGoTo = "AdminPeRsAuth.asp"   ' asp page to return to once record is deleted'
strTabID = "staffID"              ' key field name for table        '
strRecid = "staffID"
strCommand = "spAdminPeRsAuthSummary"

set objCmd = server.CreateObject("ADODB.Command")
set objPara = server.CreateObject("ADODB.Parameter")
objCmd.ActiveConnection = con
objCmd.Activeconnection.cursorlocation = 3
objCmd.CommandType = 4		


objCmd.CommandText = strCommand
set objPara = objCmd.CreateParameter ("RecID",3,1,5, request("staffID"))
objCmd.Parameters.Append objPara
set objPara = objCmd.CreateParameter ("atpID",3,1,5, request("atpID"))
objCmd.Parameters.Append objPara

set rsRecSet = objCmd.Execute	'Execute CommandText when using "ADODB.Command" object'

objCmd.CommandText = "spAdminAuthsAvailable"	'Name of Stored Procedure
set rsAuthAvailable = objCmd.Execute	'Execute CommandText when using "ADODB.Command" object'

%>

<html>
<head>

<!--#include file="Includes/IECompatability.inc"-->


<title>Authorisation Administration</title>
<link rel="stylesheet" type="text/css" href="Includes/AMDB.css" media="Screen"/>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">

<style type="text/css">
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
    <form action="AdminAddAuths.asp" method="post" name="frmDetails">
        <input type="hidden" name="staffID" value="<%=request("staffID")%>">
         <input type="hidden" name="atpID" value="<%=request("atpID")%>">
        <input name="hiddenChange" type="hidden" value="">
        <input name="newattached" type="hidden" value="">
        <input name="newdatesattached" type="hidden" value="">
        <Input Type="Hidden" name="HiddenDate">
        <input type="hidden" name="ReturnTo" value="AdminPersAuths.asp">
         <table border=0 cellpadding=0 cellspacing=0 width=100%>
            <tr>
                <td>
                    <!--#include file="Includes/Header.inc"--> 
                    <table cellSpacing=0 cellPadding=0 width=100% border=0 >
                        <tr style="font-size:10pt;" height=26px>
                            <td width=10><img style="margin-left:10px;" src="cms_icons/png/24x24/process.png" width="24" height="24"></td>
                            <td class="staticdatamenu"><font class="youAreHere">CMS Admin Menu / <strong>Authorisations</strong></font></td>
                        </tr>
                        <tr>
                            <td colspan=2 class=titlearealine  height=1></td>
                        </tr>
                    </table>
                    
                  <!--<table width=100% height='<%'=session("heightIs")%>px' border=0 cellpadding=0 cellspacing=0> -->
                  <table style="height:900px;" width=100% height="328" border=0 cellpadding=0 cellspacing=0>       		   		
                        <tr valign=Top>
                            <td class="sidemenuwidth" background="Images/tableback.png"><!--#include file="Includes/authmenu.inc"--></td>
                            <td width=16></td>
                            <td align=left >
                                <table border=0 cellpadding=0 cellspacing=0 width=100%>
                                    <tr class=SectionHeader>
                                        <td>
                                            <table border=0 cellpadding=0 cellspacing=0 >
                                                <tr>
                                                    <td height="25px" class=toolbar width=8></td>
                                                    <td height="25px" width=20><a  href="javascript:saveNew();"><img class="imagelink" src="images/saveitem.gif"></A></td>
                                                    <td height="25px" valign="middle" class=toolbar>Save</td>
                                                    <td height="25px" class=titleseparator valign="middle" width=14 align="center">|</td>
                                                    <td height="25px" class=toolbar valign="middle"><A class=itemfontlink href="AdminPersAuths.asp?staffID=<%=request("staffID")%>&atpID=<%=cint(request("atpID"))%>">Back</A></td>											
                                                </tr>
                                            </table>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <table border=0 cellpadding=0 cellspacing=0 width=100%>
                                                <tr>
                                                    <td height="22px" colspan=6>&nbsp;</td>
                                                </tr>
                                                <tr class=columnheading>
                                                    <td align="left" width="2%" height="22px">&nbsp;</td>
                                                    <td align="left" width="13%" height="22px">First Name:</td>
                                                    <td align="left" width="25%" height="22px" class=itemfont><%=rsRecSet("firstname")%></td>
                                                    <td align="left" width="13%" height="22px">Surname:</td>
                                                    <td align="left" width="25%" height="22px" class=itemfont><%=rsRecSet("surname")%></td>
                                                    <td align="left" width="22%" height="22px">&nbsp;</td>
                                                </tr>
                                                <tr class=columnheading height=22>
                                                    <td align="left" width="2%" height="22px">&nbsp;</td>
                                                    <td align="left" width="13%" height="22px">Service No:</td>
                                                    <td align="left" width="25%" height="22px" class=itemfont><%=rsRecSet("serviceno")%></td>
                                                    <td align="left" width="13%" height="22px">Known as:</td>
                                                    <td align="left" width="25%" height="22px" class=itemfont><%=rsRecSet("knownas")%></td>
                                                    <td align="left" width="22%" height="22px">&nbsp;</td>
                                                </tr>
                                                <tr class=columnheading height=22>
                                                    <td align="left" width="2%" height="22px">&nbsp;</td>
                                                    <td align="left" width="13%" height="22px">Rank:</td>
                                                    <td align="left" width="25%" height="22px" class=itemfont><%=rsRecSet("rank")%></td>
                                                    <td align="left" width="13%" height="22px">Trade:</td>
                                                    <td align="left" width="25%" height="22px" class=itemfont><%=rsRecSet("trade")%></td>
                                                    <td align="left" width="22%" height="22px">&nbsp;</td>
                                                </tr>
                                                <tr class=columnheading height=22>
                                                    <td align="left" width="2%" height="22px">&nbsp;</td>
                                                    <td align="left" width="13%" height="22px">Post:</td>
                                                    <td align="left" width="25%" height="22px" class=itemfont><%=rsRecSet("post")%></td>
                                                    <td align="left" width="13%" height="22px">Unit:</td>
                                                    <td align="left" width="25%" height="22px" class=itemfont><%=rsRecSet("unit")%></td>
                                                    <td align="left" width="22%" height="22px">&nbsp;</td>
                                                </tr>
                                                <tr>
                                                    <td colspan=6 height="22px">&nbsp;</td>
                                                </tr>
                                                <tr>
                                                    <td colspan=6 class=titlearealine height=1></td> 
                                                </tr>
                                            </table>
                                            <table border=0 cellpadding=0 cellspacing=0 width=100%>
                                                <tr class=SectionHeader>
                                                    <td width="2%" align="left" height="25px">&nbsp;</td>
                                                    <td width="50%" valign="top" height="25px">
                                                        <table border=0 cellpadding=0 cellspacing=0 width=98%>
                                                            <tr class="SectionHeader toolbar">
                                                                <td width="30%" align="left" height="25px"><b><u>Authorisations</u></b> Held</td>
                                                                <td width=10% align="center" height="25px">Valid From</td>
                                                                <td width=10% align="center" height="25px">Valid To</td>
                                                            </tr>
                                                            <tr>
                                                                <td colspan=3 height="22px">&nbsp;</td>
                                                            </tr>
                                                            <% set rsRecSet=rsRecSet.nextrecordset %>
                                                            <% if rsRecSet.recordcount > 0 then %>
                                                                <% do while not rsRecSet.eof %>
                                                                    <tr>
                                                                        <td width="30%" height="22px" align="left" class=toolbar><%= rsRecSet("authCode") %></td>
                                                                        <td width="10%" height="22px" align="center" class=toolbar><%= formatDateTime(rsRecSet("startdate"),2) %></td>
                                                                        <td width="10%" height="22px" align="center" class=toolbar><%= formatDateTime(rsRecSet("enddate"),2) %></td>
                                                                    </tr>
                                                                    <% rsRecSet.movenext %>
                                                                <% loop %>
                                                            <% else %>
                                                                <tr>
                                                                    <td colspan="3" height="22px" class="toolbar">None held</td>
                                                                </tr>
                                                            <% end if %>
                                                        </table>
                                                    </td>
                                                    <td width="48%" height="22px" valign="top">
                                                        <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                                            <tr>
                                                                <td>
                                                                    <table border=0 cellpadding=0 cellspacing=0 width=100%>
                                                                        <tr class="SectionHeader toolbar">
                                                                            <td height="25px" align="left">Authorisations Available</td>
                                                                            <td height="25px">&nbsp;</td>
                                                                            <td height="25px" align="left">Authorisations to Add</td>
                                                                        </tr>
                                                                        <tr>
                                                                            <td colspan="3" height="20">&nbsp;</td>
                                                                        </tr>
                                                                        <tr>
                                                                            <td class="ColorBackground">
                                                                                <select name="lstAttached" size="10" multiple class="pickbox" style="width:180px;" id="lstAttached" onChange="remAttached()"> 
                                                                                    <% if not rsAuthAvailable.bof and not rsAuthAvailable.eof then %>
                                                                                        <% do while not rsAuthAvailable.eof %>
                                                                                            <option value=<%= rsAuthAvailable("authID")%>><%= rsAuthAvailable("authCode") %></option>
                                                                                            <% rsAuthAvailable.Movenext() %>
                                                                                        <% loop %>
                                                                                    <% end if %>
                                                                                </select>
                                                                            </td>
                                                                            <td>&nbsp;</td>
                                                                            <td>
                                                                                <select name="pickAttached" size="10" class="pickbox" style="width:180px;" id="pickAttached" onChange="addAttached()">
                                                                                </select>
                                                                            </td>
                                                                        </tr>
                                                                    </table>
                                                                </td>
                                                            </tr>
                                                        </table>
                                                    </td>
                                                </tr>
                                                <tr height=16>
                                                    <td colspan=3></td>
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

    <form name="frmRon">
        <div id="PopUpwindow1" class="PopUpWindow">
            <table border="0" cellpadding="0" cellspacing="0" width="100%">
                <tr height="22">
                    <td colspan="3" class="MenuStyleParent" align="Center"><u>Confirm Authorisation Details</u></td>
                </tr>
                <tr>
                    <td colspan="3" height="22px">&nbsp;</td>
                </tr>
                <tr class="columnheading">
                    <td valign="middle" height="22" width="2%"></td>
                    <td valign="middle" height="22" width="30%">Authorisation Code:</td>
                    <td valign="middle" height="22" width="68%" class="toolbar"><DIV  id="QName"></DIV></td>
                </tr>
                <tr class="columnheading">
                    <td valign="middle" height="22" width="2%"></td>
                    <td valign="middle" height="22" width="30%">Valid From:</td>
                    <td valign="middle" height="22" width="68%" class="itemfont">
                        <input name="DateAttained" type="text" id="DateAttained" class=" itemfontEdit inputboxEdit"  style="Width:85px;"  value ="<%=newTodaydate%>" readonly onclick="calSet(this)">&nbsp;
                        <img src="images/cal.gif" alt="Calender" onclick="calSet(DateAttained)" align="middle" style="cursor:hand;"></td>
                    </td>
                </tr>
                <tr class="columnheading">
                    <td valign="middle" height="22" width="2%"></td>
                    <td valign="middle" height="22" width="30%">Valid To:</td>
                    <td valign="middle" height="22" width="68%" class="itemfont">
                        <input name="DateTo" type="text" id="DateTo" class=" itemfontEdit inputboxEdit"  style="Width:85px;"  value ="" readonly onclick="calSet(this)">&nbsp;
                        <img src="images/cal.gif" alt="Calender" onclick="calSet(DateTo)" align="middle" style="cursor:hand;"></td>
                    </td>
                </tr>
                <tr>
                    <td colspan="3" height="22px">&nbsp;</td>
                </tr>


                <tr>
                    <td height="22px">&nbsp;</td>
                    <td align="right" height="22"><Input CLASS="StandardButton" Type=Button style="width:60px;" Value=OK onclick="javascript:populateDateArray('DateAttained','DateTo');"></td>
                    <td align="center"  height="22"><Input CLASS="StandardButton" Type=Button  Value=Cancel onclick="addAttached();cancelpopup()"></td>
                </tr>
                <tr>
                    <td colspan="3" height="22px">&nbsp;</td>
                </tr>
                
            </table>
        </div>
    </form>

</body>
</html>


<script type="text/javascript" src="calendar.js"></script>

<script language="javascript">

var DateAttainedArray = new Array();
var DateToArray = new Array();
CurrentDateArray = 0;

function remAttached()
{
    /* we've clicked on an Attachment to REMOVE it */
	var list, field, location, picked, txt;
	var newattached;
		
	list = document.forms['frmDetails']['pickAttached'];        /* list of Sections to REMOVE */
	location = document.forms['frmDetails']['lstAttached'];     /* list of Sections that can be REMOVED */
	//field = document.frmDetails.lstAttached.options.value ;     /* Section selected to REMOVE */
	
	var optArr = document.frmDetails.lstAttached.options;
	
	for(x=0;x<optArr.length;x++){
		if(optArr[x].value == location.value){
			var obj = optArr[x];
		}
	}
    var txt = obj.innerHTML;
	document.frmDetails.hiddenChange.value = "true";

	var strSplit = obj.value.split("*");
	
    list.options[list.options.length] = new Option(txt,obj.value,false); /* true would select it */
    obj.parentNode.removeChild(obj);

	/* if we just clicked on last entry don't try to assign focus - cos theres nowt there */
	if(document.frmDetails.lstAttached.options.length != 0)
	{  
	    //alert("new focus");
		document.frmDetails.lstAttached[0].focus();
	}	

   // alert ("pop up is " ); //+ document.getElementById('PopUpwindow1').style.visibility);
	// make sure what we just clicked on is selected so if we cancel from the pop-up
	// it goes back to the available list
	list.value = obj.value;
	
	document.frmDetails.lstAttached.disabled=true;
	document.frmDetails.pickAttached.disabled=true;
	document.frmRon.DateAttained.value = "<%=newTodaydate%>";
	document.frmRon.DateTo.value = "";
	document.getElementById('PopUpwindow1').style.visibility = "Visible";
	document.getElementById('QName').innerHTML=txt;
}

function populateDateArray(DateAttained,DateTo)
{
	//document.getElementById('PopUpwindow1').style.visibility = 'Hidden';
	var errMsg = "";
	var dateStr=document.all[DateAttained].value;
	var datetoStr=document.all[DateTo].value;
	
		if(dateStr == "")
		{
			errMsg += "Enter the Date From\n";
		}
	
    if(datetoStr == "")
		{
			errMsg += "Enter the Date To\n";
		}
	
    if(dateStr != "" && datetoStr != "")
	 {
		var intSDate = parseInt(dateStr.split("/")[2] + dateStr.split("/")[1] + dateStr.split("/")[0])
		var intEDate = parseInt(datetoStr.split("/")[2] + datetoStr.split("/")[1] + datetoStr.split("/")[0])
		
		if(intEDate < intSDate)
		{
			errMsg += "End date can not be earlier than start date\n"
		}
	 }
	 
    if(!errMsg=="")
		{
			alert(errMsg)
			return;	  		
		} 

	DateAttainedArray[CurrentDateArray] = dateStr + '|' + datetoStr;
	CurrentDateArray++;
	
	//alert("Date Array is " + DateAttainedArray);
	cancelpopup();

	//document.frmDetails.lstAttached.disabled=false;
	//document.frmDetails.pickAttached.disabled=false;
}

function cancelpopup() 
{
	document.getElementById('PopUpwindow1').style.visibility = 'Hidden';
	document.frmDetails.lstAttached.disabled=false;
	document.frmDetails.pickAttached.disabled=false;
	
	list = document.forms['frmDetails']['pickAttached'];
	list.value='';
}

function addAttached()
{
	var list, field, location, current;
	var cval, ctxt, cstr;
	var newattached;
	
	var re = /,/; 
	var lstxt= new Array;
	var lsval= new Array;

	list = document.forms['frmDetails']['lstAttached'];      /* Available list */
	location = document.forms['frmDetails']['pickAttached']; /* REMOVE list */

	var optArr = document.frmDetails.pickAttached.options;
	
	for(x=0;x<optArr.length;x++){
		
		if(optArr[x].value == location.value){
			var obj = optArr[x];
		}
	}

	var txt = obj.innerHTML;

    // add the one we just clicked on in the List to Add
	// back into the List Available
	list.options[list.options.length] = new Option(txt,obj.value,false); /* true would select it */

    // now sort the list with the one we just added in it
    sortSelect(list);

	obj.parentNode.removeChild(obj);
	document.frmDetails.pickAttached.selectedIndex=-1;
	
	/* There is nothing picked to remove - so make sure change flag is unset */
    if(document.frmDetails.pickAttached.options.length == 0)
	{
		document.frmDetails.hiddenChange.value = "";
	}
	
	CurrentDateArray=CurrentDateArray-1;
}

function sortSelect(selElem) {
    var tmpAry = new Array();
    for (var i=0;i<selElem.options.length;i++) {
        tmpAry[i] = new Array();
        tmpAry[i][0] = selElem.options[i].text;
        tmpAry[i][1] = selElem.options[i].value;
    }
    tmpAry.sort();
    while (selElem.options.length > 0) {
        selElem.options[0] = null;
    }
    for (var i=0;i<tmpAry.length;i++) {
        var op = new Option(tmpAry[i][0], tmpAry[i][1]);
        selElem.options[i] = op;
    }
    return;
}


/* clicked on assigned list - this will remove entry they clicked from the list and put it back on unassigned list */
//function addAttached()
//{
//	var list, field, location, current;
//	var cval, ctxt, cstr;
//	var newattached;
//	
//	var re = /,/; 
//	var lstxt= new Array;
//	var lsval= new Array;
//
//	list = document.forms['frmDetails']['lstAttached'];      /* Available list */
//	location = document.forms['frmDetails']['pickAttached']; /* REMOVE list */
//	//field = document.frmDetails.pickAttached.options.value;  /* Entry in REMOVE list they clicked to remove */
//
//	var optArr = document.frmDetails.pickAttached.options;
//	
//	for(x=0;x<optArr.length;x++){
//		if(optArr[x].value == location.value){
//			var obj = optArr[x];
//		}
//	}
//
//	var txt = obj.innerHTML;
//   
//	list.options[list.options.length] = new Option(txt,obj.value,false); /* true would select it */
//	
//    var icount = 0;
//	for(var i = 0; i < list.options.length; i++)
//	{	    
//		lsval[icount]= document.frmDetails.lstAttached[i].value;
//		lstxt[icount]= document.frmDetails.lstAttached[i].text + "," + document.frmDetails.lstAttached[i].value;
//		icount++;
//	}
//
//    lsval.sort();
//	lstxt.sort();
//	for(var i = 0; i < lstxt.length; i ++)
//	{
//		current = lstxt[i];
//		cstr = current.split(re);
//		ctxt= cstr[0];
//		cval= cstr[1]; 
//        document.frmDetails.lstAttached[i].value = cval;
//		document.frmDetails.lstAttached[i].text = ctxt;
//	}
// 
//	//document.frmDetails.pickAttached[inum] = null;
//	obj.parentNode.removeChild(obj);
//	document.frmDetails.pickAttached.selectedIndex=-1;
//	
//	/* There is nothing picked to remove - so make sure change flag is unset */
//    if(document.frmDetails.pickAttached.options.length == 0)
//	{
//		document.frmDetails.hiddenChange.value = "";
//	}
//	
//	CurrentDateArray=CurrentDateArray-1;
//}
//
/* clicked the SUBMIT button - so write the changes to the database  via writeGroups.asp */
function saveNew()
{	
	if(document.getElementById('PopUpwindow1').style.visibility=="visible")
	{
		return;
	}
	else
	{
    	var list, field, location, current;
		var newattached;
		var errMsg = "";
	
		/* not picked any so ignore submit */		
		if(document.frmDetails.hiddenChange.value == "")
		{
			errMsg += "Select MAuthorisations Available";
			document.frmDetails.lstAttached.focus(); 
		}

		/* now build the section list - if any - to be removed */
		if(document.frmDetails.pickAttached.options.length != 0)
		{
			list = document.frmDetails.pickAttached.value;
			/* now build hidden value with list of Locations to submit so the program writelocations can update database */
			id = document.frmDetails.pickAttached[0].value;
			strSplit = id.split("*")
			newattached = strSplit[0]
			newdatesattached = DateAttainedArray[0]; 
	
			for(var i = 1; i < document.frmDetails.pickAttached.options.length; i++)
			{
				id = document.frmDetails.pickAttached[i].value
				strSplit = id.split("*")
				newattached = newattached + "," + strSplit[0]
				newdatesattached = newdatesattached + "," + DateAttainedArray[i]
			}
				
			document.frmDetails.newattached.value = newattached;
			document.frmDetails.newdatesattached.value = newdatesattached;
		}

		if(!errMsg=="")
		{
			alert(errMsg)
			return;	  		
		} 

        //alert("Auth is " + document.frmDetails.staffID.value + " ** "  + newattached + " * " + newdatesattached);
		document.frmDetails.hiddenChange.value = "";
		document.frmDetails.submit();  
	}
}

function CalenderScript(CalImg)
{
	CalImg.style.visibility = "Visible";
}

function CloseCalender(CalImg)
{
	CalImg.style.visibility = "Hidden";	 
}

function InsertCalenderDate(Calender,SelectedDate)
{
	var str=Calender.value;
	document.forms["frmDetails"].elements["HiddenDate"].value = str;
	var whole = document.forms["frmDetails"].elements["HiddenDate"].value;
	var day = document.forms["frmDetails"].elements["HiddenDate"].value.substring (8,10);
	day.replace (" ","");
	var month = document.forms["frmDetails"].elements["HiddenDate"].value.substring (4,7);
	var strlength = document.forms["frmDetails"].elements["HiddenDate"].value.length;
	var year = document.forms["frmDetails"].elements["HiddenDate"].value.substring (strlength-4,strlength);
	document.all.DateAttained.value = day + " " + month + " " + year;
}

function checkDelete()
{
	var delOK = false 
    
	var input_box = confirm("Are you sure you want to delete this Record ?")
	if(input_box==true)
	{
		delOK = true;
	}
    return delOK;
}

</script>