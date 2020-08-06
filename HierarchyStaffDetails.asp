<!DOCTYPE HTML >
<!--#include file="Includes/security.inc"--> 
<!--#include file="Connection/Connection.inc"-->
<!--#include file="Includes/checkmanager.inc"-->  
<!--#include file="Includes/manageradmin.inc"-->  

<%
teamID=request("recID")
todayDate = formatdatetime(date(),2)
splitDate = split (todayDate,"/")
if splitdate(1)="01" then theMonth="Jan"
if splitdate(1)="02" then theMonth="Feb"
if splitdate(1)="03" then theMonth="Mar"
if splitdate(1)="04" then theMonth="Apr"
if splitdate(1)="05" then theMonth="May"
if splitdate(1)="06" then theMonth="Jun"
if splitdate(1)="07" then theMonth="Jul"
if splitdate(1)="08" then theMonth="Aug"
if splitdate(1)="09" then theMonth="Sep"
if splitdate(1)="10" then theMonth="Oct"
if splitdate(1)="11" then theMonth="Nov"
if splitdate(1)="12" then theMonth="Dec"

newTodaydate= splitDate(0) + " " + theMonth + " " + splitDate(2) 

if Session("openfield") = "" or request("openfield") <> "" then
	Session("openfield") = request("openfield")
end if

if request ("thisDate") <>"" then
	thisDate = request ("thisDate")
else
	thisDate = newTodaydate
End if

strTable = "tblTeam"    
strGoTo = request("fromPage")    
strTabID = "teamID"                      

set objCmd = server.CreateObject("ADODB.Command")
set objPara = server.CreateObject("ADODB.Parameter")
objCmd.ActiveConnection = con
objCmd.Activeconnection.cursorlocation = 3

objCmd.CommandText = "spListTaskTypes"
objCmd.CommandType = 4				
set rsTaskTypes = objCmd.Execute	

objCmd.CommandText = "spTeamPostsInAndOut"	
objCmd.CommandType = 4				
set objPara = objCmd.CreateParameter ("TeamID",3,1,5, request("RecID"))
objCmd.Parameters.Append objPara
set objPara = objCmd.CreateParameter ("thisDate",200,1,16, thisDate)
objCmd.Parameters.Append objPara
set rsRecSet = objCmd.Execute	

' make sure we set the levelID to EITHER the parent if its Wing/Sqn/Flt
' OR if its a TEAM then the actual teamID
tmLevel = rsRecSet("teamIn")
IF tmLevel < 4 THEN
  tmLevelID = rsRecSet("ParentID")
ELSE
  tmLevelID = request("RecID")
END IF  
%>

<html>
<head>

<!--#include file="Includes/IECompatability.inc"-->


<title>Team Hierarchy</title>
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
<body onClick="checkPage();">
<form  action="" method="POST" name="frmDetails" id="frmDetails">
	<input name="recID" id="recID" type="hidden" value="<%=request("recID")%>">
<table width=100%  border=0 cellpadding=0 cellspacing=0>
	<tr height=16px >
		<td>
		</td>
	</tr>

	<!--#include file="Includes/hierarchyStaffDetails.inc"--> 

	<tr height=16 class=tabBottom>
		<td>
			<table border=0 cellpadding=0 cellspacing=0 >
				<tr>
				   <td class=toolbar width=8></td>
				   
				</tr>  
			</table>
		</td>
	</tr>
</table>

</form>
</body>
</html>

<SCRIPT LANGUAGE="JavaScript">

var thisDate = window.parent.frmDetails.startDate.value;
var homeString ="javascript:refreshIframeAfterDateSelect();'";

window.parent.crumbTrail.innerHTML="<A title='' href='index.asp' class=itemfontlinksmall >Home</A> > <A title='' href='" + homeString + "' class=itemfontlinksmall >Team Hierarchy</A> > <font class='youAreHere' >Personnel Staff Details</font>" 

function showMenu(postName)
{
	document.getElementById('postNameForTasking').innerHTML = postName;
	var taskListState = document.getElementById('TaskList').style.visibility;
	document.getElementById('TaskList').style.visibility = "Visible";
	justOpened = 1
	return false;
}

</Script>
<SCRIPT LANGUAGE="JavaScript">
var previousPostObject = new Object();
var tempObject = new Object();
var firstClick=1;
var previousBGColor, previousFGColor;

function taskItemOver(thisObject){
	previousBGColor = thisObject.style.backgroundColor;
	previousFGColor = thisObject.style.color;
	thisObject.style.backgroundColor = "#7a9ddc";
	thisObject.style.color = "#ffffff";
}

function taskItemOut(thisObject){
	thisObject.style.backgroundColor = previousBGColor;
	thisObject.style.color = previousFGColor;
}

function postItemOnclick(thisObject,postID,serviceNo){
	if (firstClick==0) {
		previousPostObject.style.backgroundColor = previousBGColor;
		previousPostObject.style.color = previousFGColor;
		//alert(previousBGColor + "," + previousFGColor)
	}
	//alert (postID + "," + serviceNo)
	var frmDetails = document.getElementById('frmDetails');
	frmDetails.postID.value=postID;
	frmDetails.serviceNo.value=serviceNo;
	firstClick=0;
	previousBGColor = thisObject.style.backgroundColor;
	previousFGColor = thisObject.style.color;
	previousPostObject = thisObject;
	thisObject.style.backgroundColor = "#7a9ddc";
	thisObject.style.color = "#ffffff";
}

function checkPage(){
	var taskListState=document.getElementById('TaskList').style.visibility;
	if (taskListState=="visible" && justOpened==0 ){
		document.getElementById('TaskList').style.visibility="Hidden";
		//alert(taskListState)
	}
	justOpened=0;
}



function checkDelete(){
     var delOK = false 
    
	  var input_box = confirm("Are you sure you want to delete this Record ?")
	  if(input_box==true) {
		    delOK = true;
	    }
    return delOK;
}
function MovetoPage (PageNo) {
	document.forms["frmDetails"].elements["Page"].value = PageNo;
	document.forms["frmDetails"].submit();
}

function gotoTask(ttID,description){
	//alert (ttID + "," + description)
	document.frmDetails.ttID.value=ttID;
	document.frmDetails.description.value=description;
	
	document.frmDetails.action="HierarchyTaskIndividual.asp";
	//alert(document.frmDetails.action);
	document.frmDetails.submit();
	window.parent.startTimer()
}

function gotoTaskingOverView(){
	document.frmDetails.action="HierarchyTeamTaskingOverview.asp";
	//alert(document.frmDetails.action);
	document.frmDetails.submit();
	window.parent.startTimer()
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
