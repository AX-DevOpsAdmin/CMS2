<!DOCTYPE HTML >

<!--#include file="Includes/security.inc"--> 
<!--#include file="Connection/Connection.inc"-->
<!--#include file="Includes/checkmanager.inc"-->  
<!--include file="Includes/manageradmin.inc"-->  

<%
tab=8
strTable = "tblstaff"
strGoTo = "HierarchyPeRsAuth.asp"   ' asp page to return to once record is deleted'
strTabID = "staffID"              ' key field name for table        '
strRecid = "staffID"
strCommand = "spStaffAuthSummary"

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

	for x = 1 to objCmd.parameters.count
		objCmd.parameters.delete(0)
	next

objCmd.CommandText = "spStaffAuthsAvailable"	'Name of Stored Procedure
set objPara = objCmd.CreateParameter ("RecID",3,1,5, nodeID)
objCmd.Parameters.Append objPara
set objPara = objCmd.CreateParameter ("RecID",3,1,5, request("staffID"))
objCmd.Parameters.Append objPara

set objPara = objCmd.CreateParameter ("atpID",3,1,5, request("atpID"))
objCmd.Parameters.Append objPara

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
    <form action="AddStaffAuths.asp" method="post" name="frmDetails">
        <input type="hidden" name="staffID" id="staffID" value="<%=request("staffID")%>">
         <input type="hidden" name="atpID" value="<%=request("atpID")%>">
        <input name="hiddenChange" type="hidden" value="">
        <input name="newattached" type="hidden" value="">
        <input name="newdatesattached" type="hidden" value="">
        <input name="newauthsattached" type="hidden" value="">
        <Input Type="Hidden" name="HiddenDate">
        <input type="hidden" name="ReturnTo" value="HierarchyPersAuthorise.asp">
	<table border=0 cellpadding=0 cellspacing=0 width=100%>
    	<!--#include file="Includes/hierarchyStaffDetails.inc"-->
    	<tr>
    		<td class=titlearealine  height=1></td> 
    	</tr>    
    
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
                                                    <td height="25px" class=toolbar valign="middle"><A class=itemfontlink href="HierarchyPersAuthorise.asp?staffID=<%=request("staffID")%>&thisdate=<%= request("thisDate")%>">Back</A></td>											
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
                                                                                <select name="lstAttached" size="10" multiple class="pickbox" style="width:180px;" id="lstAttached"  onChange="remAttached()"> 
                                                                                <!--<select name="lstAttached" size="10" multiple class="pickbox" style="width:180px;" id="lstAttached" > -->
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
        <input name="authID2" id="authID2" type="hidden" value="">
        
        <div id="PopUpwindow1" class="AuthPopUpWindow">
            <table border="0" cellpadding="0" cellspacing="0" width="100%">
                <tr height="22">
                    <td colspan="4" class="MenuStyleParent" align="Center"><u>Confirm Authorisation Details</u></td>
                </tr>
                <tr>
                    <td colspan="4" height="22px">&nbsp;</td>
                </tr>
                <tr class="columnheading">
                    <td valign="middle" height="22" width="1%"><img class="imagelink" src="images/info.gif" title="Click here for further details" onClick="javascript:showAuthDetails()" ></td>
                    <td valign="middle" height="22" width="46%">&nbsp;Authorisation Code:</td>
                    <td valign="middle" height="22" width="53%" class="toolbar"><DIV  id="QName"></DIV></td>
                    <td>
                      

                    </td>
                </tr>
                <tr class="columnheading">
                    <td valign="middle" height="22" width="1%"></td>
                    <td valign="middle" height="22" width="46%">Valid From:</td>
                    <td valign="middle" height="22" align="left" width="53%" class="itemfont">
                        <input name="DateAttained" type="text" id="DateAttained" class=" itemfontEdit inputboxEdit"  style="Width:85px;"  value ="<%=newTodaydate%>" readonly onclick="calSet(this)">&nbsp;
                        <img src="images/cal.gif" alt="Calender" onclick="calSet(DateAttained)" align="middle" style="cursor:hand;">
                    </td>
                    <td></td>
                </tr>
                <tr class="columnheading">
                    <td valign="middle" height="22" width="1%"></td>
                    <td valign="middle" height="22" align="left" width="46%">Valid To:</td>
                    <td valign="middle" height="22" align="left" width="53%" class="itemfont">
                        <input name="DateTo" type="text" id="DateTo" class=" itemfontEdit inputboxEdit"  style="Width:85px;"  value ="" readonly onclick="calSet(this)">&nbsp;
                        <img src="images/cal.gif" alt="Calender" onclick="calSet(DateTo)" align="middle" style="cursor:hand;">
                    </td>
                    <td></td>
                </tr>
                <tr class="columnheading">
                    <td width="1%" align="left" height="22px">&nbsp;</td>
                    <td width="46%" align="left" height="22px">Assessor:</td>
                    <td width="53%" align="left" height="22px">
                         <div id="apprvr"> 
                            <select name="apprvID" id="apprvID" class="itemfont" style="width: 100px">
                                <option value="0">None</option>
                            </Select>
                         </div>
                     </td>
                     <td></td>
                </tr>
                <tr>
                    <td colspan="3" height="22px">&nbsp;</td>
                </tr>

                <tr>
                    <td height="22px">&nbsp;</td>
                    <td align="right" height="22"><Input CLASS="StandardButton" Type=Button  Value=OK onclick="javascript:populateDateArray('DateAttained','DateTo','apprvID');"></td>
                     <td  align="center"  height="22"><Input CLASS="StandardButton" Type=Button  Value=Cancel onclick="cancelAuth();cancelpopup()"></td>
                     <td></td>
                </tr>
                <tr>
                    <td colspan="4" height="22px">&nbsp;</td>
                </tr>
            </table>
        </div>
    </form>

    	<%
    windowWidth=200
    windowHeight=200%>
    
    <Div id="detailWindow" style="background-color:#f4f4f4;visibility:hidden;" class="AuthPopUpWindow">
        <table border="0" cellpadding="0" cellspacing="0" align="right" width="100%">
            <tr class="SectionHeader">
                <td>
                    <div id="detailWindowTitleBar" style="position:relative;left:7px;top:0px;width:100%;border-color:#7f9db9;"> 
                        <table border="0" cellpadding="0" cellspacing="0" align="right" width="100%">
                            <tr> 
                                <td id="windowName" class="itemfont"></td>
                                <td align="right" ><img src="images/windowCloseIcon.png" style="cursor:pointer;" onClick="javascript:closeThisWindow('detailWindow');"></td>
                            </tr>
                        </table>
                    </div>
                </td>
            </tr>
            <tr>
                <td class="titlearealine" height="1"><img height="1" src="Images/blank.gif"></td> 
            </tr>            
            <tr>
                <td align="left" class="itemfont">
                    <div id="innerDetailWindow" style="Overflow:auto;background-color:#f4f4f4;color:#000000;position:relative;height:100%;width:100%"> 
                        <table border="0" cellpadding="0" cellspacing="0" align="right" width="100%">
                            <tr class="itemfont"> 
                                <td>&nbsp;</td>
                            </tr>
                        </table>
                    </div>
                </td>
            </tr>
        </table>
    </Div>

</body>
</html>


<script type="text/javascript" src="calendar.js"></script>

<script language="javascript">

var DateAttainedArray = new Array();
var DateToArray = new Array();
var authArray = new Array();

CurrentDateArray = 0;

function showAuthDetails(){
	
	var authID=document.getElementById('authID2').value;
	var authcode=document.getElementById('QName').innerHTML;
	//alert("show details for auth " + authID + " * " + authcode );
	ajaxFunction('GetAuthDetailsAjax.asp','authID='+authID,'Authorisation Details: '+authcode,100,100,250,600)
	
	
}
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
			//alert(location.value +  ' * ' + optArr[x].value + ' * ' + x);
		}
	}
	
    var txt = obj.innerHTML;
	var authID=obj.value;
	
	document.frmDetails.hiddenChange.value = "true";

	//var strSplit = obj.value.split("*");
	
	//alert( "auth now  " + txt + " * " + authID );
	
    list.options[list.options.length] = new Option(txt,obj.value,false); /* true would select it */
    obj.parentNode.removeChild(obj);

	/* if we just clicked on last entry don't try to assign focus - cos theres nowt there */
	if(document.frmDetails.lstAttached.options.length != 0)
	{  
	    //alert("new focus");
		document.frmDetails.lstAttached[0].focus();
	}	

    getAssessors(authID);
	
	//alert(authID);
	//return;
	
	// make sure what we just clicked on is selected so if we cancel from the pop-up
	// it goes back to the available list
	list.value = obj.value;
	
    //alert ("pop up is " ); //+ document.getElementById('PopUpwindow1').style.visibility);
	document.frmDetails.lstAttached.disabled=true;
	document.frmDetails.pickAttached.disabled=true;
	document.frmRon.DateAttained.value = "<%=newTodaydate%>";
	document.frmRon.DateTo.value = "";
	
	document.getElementById('PopUpwindow1').style.visibility = "Visible";
	document.getElementById('QName').innerHTML=txt;
	document.getElementById('authID2').value=authID;
	
	//alert("Window visible");
	
	//getAssessors(authID);
}

function getAssessors(authID)
{
	//var atp=document.getElementById("atpID").value;
	//document.getElementById("apprvr").style.display="block";
	var staffID=document.getElementById("staffID").value;
	var str = 'authID='+authID+'&staffID='+staffID
	//alert("Auth is " + authID + " * " + staffID);
	//return;
	//ajax('ddStaffAssessors.asp',str,'apprvr');
	ajax('ddStaffAuthorisors.asp',str,'apprvr');
	
}

//----------------standard ajax function with option for secondary function----------------
function ajax(url,strMessage,div,func,loading){
    // prompt('',url+'?'+strMessage + '?'+div+'?'+func+'?'+loading)
  
    //var str = 'pagesize='+pagesize+'&filSearch='+crsenum+' &orderBy='+orderBy+'&dir='+dir + ' &searchby=number ';
	//prompt("",'userlist.asp?'+str)
	//ajax('courselist.asp',str,'List');
  
  
	if(loading){
		//document.getElementById(div).innerHTML = '<div align="center" style="width:100%; margin-top:250px;"><img src="images/loading1.gif"/><div style="margin-bottom:10px; color:#999;">Loading</div> <div>'
		//document.getElementById("loading").style.display = 'block';
		loadingImg(loading);
	}
	var timeoutcounter = 0;	//Count ajax call as being active, reset the countdown counter.
	var xhr;  
	if (typeof XMLHttpRequest !== 'undefined') {
		xhr = new XMLHttpRequest(); 
	}
	else{  
		var versions = ["MSXML2.XmlHttp.6.0",
						"MSXML2.XmlHttp.5.0",
						"MSXML2.XmlHttp.4.0",
						"MSXML2.XmlHttp.3.0",
						"MSXML2.XmlHttp.2.0",
						"Microsoft.XmlHttp"];
		for(var i = 0; i < versions.length; i++){  
			try{  
				xhr = new ActiveXObject(versions[i]);
				break;  
			}  
			catch(e){}  
		} 
	}  
	xhr.onreadystatechange = function(){ 
		if ((xhr.readyState === 4) && (xhr.status === 200)){
			
			  // alert(xhr.responseText);
				//if there is a div specified then place the response text inside.
				if (div !== ''){
					document.getElementById(div).innerHTML = xhr.responseText;
				
				}
				//alert(document.getElementById(div).innerHTML)
				//If there is a function (func) specified then run it.
				if (func){
					//alert("into func " + xhr.responseText);
					eval(func);
				}
				if(loading){
					document.getElementById("loading").style.display = 'none';
				}
				//alert("Yep")
		}
		else if ((xhr.readyState === 4) && (xhr.status !== 200)){
			window.open("error.asp?code="+xhr.responseText)
			//prompt("",xhr.responseText)
		}
		else{
			return;
		}
	}  
	xhr.open("post",url,true);
	xhr.setRequestHeader("Content-type","application/x-www-form-urlencoded");
	
	//alert("out of ajax");
	xhr.send(strMessage);
	//xhr.send(encodeURI(strMessage)); 
}

function cancelpopup() 
{
	document.getElementById('PopUpwindow1').style.visibility = 'Hidden';
	document.frmDetails.lstAttached.disabled=false;
	document.frmDetails.pickAttached.disabled=false;
	
	list = document.forms['frmDetails']['pickAttached'];
	list.value='';
}

function populateDateArray(DateAttained,DateTo, apprvID)
{
	var errMsg = "";
	
	var dateStr=document.all[DateAttained].value;
	var datetoStr=document.all[DateTo].value;
	var authStr=document.all[apprvID].value;
	
	if(dateStr == "")
		{
			errMsg += "Enter the Date From\n";
		}
	
    if(datetoStr == "")
		{
			errMsg += "Enter the Date To\n";
		}
	
    if(authStr == 0)
		{
			errMsg += "Choose an Authorisor\n";
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
	//alert("Authorisor  " + authStr);
	
	//document.getElementById('PopUpwindow1').style.visibility = 'Hidden';
	DateAttainedArray[CurrentDateArray] = dateStr + '|' + datetoStr;
	authArray[CurrentDateArray] =authStr
	CurrentDateArray++;
	cancelpopup();
	
	//document.frmDetails.lstAttached.disabled=false;
	//document.frmDetails.pickAttached.disabled=false;
}

/* clicked on assigned list - this will remove entry they clicked from the list and put it back on unassigned list */
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

    alert(location);
	
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
	
		//alert("Date array is " + CurrentDateArray);

}

function cancelAuth()
{
		var list, field, location, current;
	var cval, ctxt, cstr;
	var newattached;
	
	var re = /,/; 
	var lstxt= new Array;
	var lsval= new Array;

	list = document.forms['frmDetails']['lstAttached'];      /* Available list */
	location = document.forms['frmDetails']['pickAttached']; /* REMOVE list */

   // alert(location);
	
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
		var newauths;
		var errMsg = "";
	
		/* not picked any so ignore submit */		
		if(document.frmDetails.hiddenChange.value == "")
		{
			errMsg += "Select Authorisations Available";
			document.frmDetails.lstAttached.focus(); 
		}

		/* now build the section list - if any - to be saved */
		if(document.frmDetails.pickAttached.options.length != 0)
		{
			//list = document.frmDetails.pickAttached.value;
			id = document.frmDetails.pickAttached[0].value;
			
			//alert("id is " + id + " list is " + list);
			
			strSplit = id.split("*")
			newattached = strSplit[0]
			newdatesattached = DateAttainedArray[0]; 
			newauths=authArray[0];
	
			for(var i = 1; i < document.frmDetails.pickAttached.options.length; i++)
			{
				id = document.frmDetails.pickAttached[i].value
				strSplit = id.split("*")
				newattached = newattached + "," + strSplit[0]
				newdatesattached = newdatesattached + "," + DateAttainedArray[i];
				newauths= newauths + ',' + authArray[i];
			}
				
			document.frmDetails.newattached.value = newattached;
			document.frmDetails.newdatesattached.value = newdatesattached;
			document.frmDetails.newauthsattached.value = newauths;
			
		}

		if(!errMsg=="")
		{
			alert(errMsg)
			return;	  		
		} 

        //alert("Auth is " + newattached + " * " + newdatesattached + " * " + newauths);
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

function ajaxFunction(ajaxFile,vars,name,xPos,yPos,xHeight,xWidth,type,task)
{
	//alert(ajaxFile + " * " + vars + " * " + type + " * " + task + " * "  + name + " * "  + " * " + xPos + " * " + yPos + " * " + xHeight + " * " + xWidth)
	var ajaxRequest;  // The variable that makes Ajax possible!
	vars = encodeURI(vars + '&' + type + '&' + task);   
	try
	{
        // Opera 8.0+, Firefox, Safari
        ajaxRequest = new XMLHttpRequest();
    }
	catch(e)
	{
    	// Internet Explorer Browsers
        try
		{
        	ajaxRequest = new ActiveXObject("Msxml2.XMLHTTP");
        }
		catch(e)
		{
        	try
			{
            	ajaxRequest = new ActiveXObject("Microsoft.XMLHTTP");
            }
			catch(e)
			{
            	// Something went wrong
            	alert("Your browser broke!");
            	return false;
            }
        }
    }
	
	xPos = (screen.width - xWidth) / 2 - 250
	yPos = (screen.height - xHeight) / 2 - 200 
	
    // Create a function that will receive data sent from the server
	ajaxRequest.onreadystatechange = function()
	{
		if(ajaxRequest.readyState == 4)
		{
			//alert("window is " + name + " * " + ajaxRequest.responseText + " * " + screen.height + " * " + xPos + " * " + yPos + " * " + xHeight + " * " + xWidth)
			populateDetailsWindow(name,ajaxRequest.responseText,xPos,yPos,xHeight,xWidth);
		}
	}
	
    ajaxRequest.open("POST", ajaxFile, true);
    ajaxRequest.setRequestHeader("Content-type","application/x-www-form-urlencoded");
    ajaxRequest.send(vars); 
}

function populateDetailsWindow(name,text,xPos,yPos,xHeight,xWidth)
{
	document.getElementById('windowName').innerHTML = name;
	document.getElementById('innerDetailWindow').innerHTML = text;
	
	var detailWindow = document.getElementById('detailWindow');
	detailWindow.style.visibility = "visible";
	detailWindow.style.width = xWidth + "px";

	//detailWindow.style.width = '400px';
	detailWindow.style.top = (document.body.parentNode.scrollTop+80)+'px';
	detailWindow.style.left = (document.body.parentNode.scrollLeft)+'px';
	
	//alert(document.getElementById('unitPlanner').scrollTop)
	
	//alert(document.body.parentNode.scrollTop)
	
	document.getElementById('detailWindowTitleBar').style.width = xWidth - 16 + "px";
}

function closeThisWindow(thisWindow)
{
	document.getElementById(thisWindow).style.visibility = "hidden";
}


</script>