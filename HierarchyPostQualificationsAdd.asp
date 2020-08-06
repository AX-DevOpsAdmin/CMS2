<!DOCTYPE HTML >

<!--#include file="Includes/security.inc"--> 
<!--#include file="Connection/Connection.inc"-->
<!--#include file="Includes/checkmanager.inc"-->  
<!--#include file="Includes/manageradmin.inc"-->  

<%
tab=3
strTable = "tblstaff"
strGoTo = "AdminPeRsList.asp"   ' asp page to return to once record is deleted'
strTabID = "staffID"              ' key field name for table '       
strRecid = "staffID"

'response.write request("postID") & " * " &  request("QTypeID")

set objCmd = server.CreateObject("ADODB.Command")
set objPara = server.CreateObject("ADODB.Parameter")
objCmd.ActiveConnection = con
objCmd.Activeconnection.cursorlocation = 3
objCmd.CommandType = 4		

strCommand = "spPostDetailSummary"
objCmd.CommandText = strCommand
set objPara = objCmd.CreateParameter ("RecID",3,1,5, request("postID"))
objCmd.Parameters.Append objPara
set rsRecSet = objCmd.Execute	'Execute CommandText when using "ADODB.Command" object'

for x = 1 to objCmd.parameters.count
	objCmd.parameters.delete(0)
next

objCmd.CommandText = "spPostQualificationsTypeDetails"	'Name of Stored Procedure'
objCmd.CommandType = 4				'Code for Stored Procedure'
set objPara = objCmd.CreateParameter ("RecID",3,1,5, request("postID"))
objCmd.Parameters.Append objPara
set objPara = objCmd.CreateParameter ("TypeID",3,1,5, request("QTypeID"))
objCmd.Parameters.Append objPara

set rsQualificationDetails = objCmd.Execute	'Execute CommandText when using "ADODB.Command" object'

QtypeID=request("QTypeID")

for x = 1 to objCmd.parameters.count
	objCmd.parameters.delete(0)
next

objCmd.CommandText = "spPostQsAvailable"	'Name of Stored Procedure
objCmd.CommandType = 4				'Code for Stored Procedure
set objPara = objCmd.CreateParameter ("RecID",3,1,5, request("postID"))
objCmd.Parameters.Append objPara
set objPara = objCmd.CreateParameter ("TypeID",3,1,5, request("QTypeID"))
objCmd.Parameters.Append objPara

set rsQAvailableList = objCmd.Execute	'Execute CommandText when using "ADODB.Command" object'

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
QTypeID=request("QTypeID")

intHrc= int(rsRecSet("hrcID"))

%>

<html>
<head>

<!--#include file="Includes/IECompatability.inc"-->


<title>Post Details</title>
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

<form action="AddPostQualifications.asp" method="get" name="frmDetails">
	<input type=hidden name="recID" id="recID" value=<%=request("recID")%>>
    <input type=hidden name="QTypeID" id="QTypeID" value=<%=request("QTypeID")%>>
    <input name="hiddenChange" id="hiddenChange" type="hidden" value="">
    <input name="newattached" id="newattached" type="hidden" value="">
    <input name="newStatusAttached" id="newStatusAttached" type="hidden" value="">
    <input name="newCompetentAttached" id="newCompetentAttached" type="hidden" value="">
    <Input Type="Hidden" name="postID" id="postID" value="<%=request("postID")%>">
    <input type="hidden" name="hrcID" id="hrcID"  value=<%=intHrc%>>
    <Input Type="Hidden" name="HiddenDate" id="HiddenDate">
    <input type="hidden" name="ReturnTo" id="ReturnTo" value="hierarchyPostQualificationsAdd.asp"/>
    
	<table border=0 cellpadding=0 cellspacing=0 width=100%>
		<!--#include file="Includes/hierarchyPostDetails.inc"--> 
		<tr>
			<td class=titlearealine  height=1></td> 
		</tr>
		<tr class=SectionHeader>
			<td>
				<table border=0 cellpadding=0 cellspacing=0 >
                	<tr>
						<td height="25px" class=toolbar width=8></td>
						<td height="25px" width=20><a href="javascript:saveNew();"><img class="imagelink" src="images/saveitem.gif"></A></td>
						<td height="25px" width="114" valign="middle" class=toolbar >Save and Close </td>
						<td height="25px" class=titleseparator valign="middle" width=10 align="center">|</td>
						<td width="41" height="25px" valign="middle" class=toolbar ><A class=itemfontlink href="HierarchyPostQualificationsDetails.asp?postID=<%=request("postID")%>&QTypeID=<%=request("QTypeID")%>">Back</A></td>
                    </tr>
				</table>
			</td>
		</tr>
		<tr>
			<td>
				<table border=0 cellpadding=0 cellspacing=0 width=100%>
					<tr>
						<td height="22px" colspan=3>&nbsp;</td>
					</tr>
					<tr class=columnheading>
						<td width="2%" valign="middle" height="22px">&nbsp;</td>
						<td width="13%" valign="middle" height="22px">Post:</td>
						<td width="85%" valign="middle" height="22px" class=itemfont><%=rsRecSet("Description")%></td>
					</tr>
					<tr class=columnheading>
					    <td width="2%" valign="middle" height="22px">&nbsp;</td>
						<td width="13%" valign="middle" height="22px">Assignment Number:</td>
						<td width="85%" valign="middle" height="22px" class=itemfont><%=rsRecSet("assignno")%></td>
					</tr>
					<tr class=columnheading height="22px">
						<td width="2%" valign="middle" height="22px">&nbsp;</td>
						<td width="13%" valign="middle" height="22px">Unit:</td>
						<td width="85%" valign="middle" height="22px" class=itemfont><%=rsRecSet("team")%></td>
					</tr>
                    <tr>
                    	<td colspan=3 height="22px">&nbsp;</td>
                    </tr>
					<tr>
       					<td colspan=3 class=titlearealine height=1></td> 
     				</tr>
				</table>
				<table border=0 cellpadding=0 cellspacing=0 width=100%>
                    <tr class=SectionHeader>
                    	<td width="2%" align="left" height="25">&nbsp;</td>
                    	<td width="50%" valign="top" height="25">
							<table border=0 cellpadding=0 cellspacing=0 width=98%>
								<tr class="SectionHeader toolbar">
                                    <td width=60% align="left" height="25px"><b><u><%=rsQualificationDetails("Type")%></u></b> Qualifications Required</td>
                                    <td width=20% align="center" height="25px">Status</td>
                                    <td width=20% align="center" height="25px">Competent</td>
								</tr>
								<tr>
									<td colspan=3 height="22">&nbsp;</td>
								</tr>
								<% color1="#fcfcfc" %>
                                <% color2="#f7f7f7" %>
                                <% counter = 0 %>
                                <% set rsQualificationDetails=rsQualificationDetails.nextrecordset %>
                                <% if rsQualificationDetails.recordcount > 0 then %>
                                    <% do while not rsQualificationDetails.eof %>
                                        <tr <%if counter=0 then%>style="background-color:<%=color1%>;"<%else%>style="background-color:<%=color2%>;"<%end if%>>
                                            <td class=toolbar height="22px"><%= rsQualificationDetails("description") %></td>
                                            <td align="center" class=toolbar height="22px"><%= rsQualificationDetails("statusDesc") %></td>
                                            <td align="center" class=toolbar height="22px"><% if rsQualificationDetails("competent") = true then response.write("Yes") else response.write("No") end if %></td>									 
                                        </tr>
                                        <% rsQualificationDetails.movenext %>
                                        <% if counter=0 then %>
                                            <% counter=1 %>
                                        <% else %>
                                            <%if counter=1 then counter=0 %>
                                        <% end if %>
                                    <% loop %>
                                <% else %>
                                    <tr>
                                        <td colspan="3" height="22px" class="toolbar">None held</td>
                                    </tr>
                                <% end if%>
                            </table>
                        </td>
                        <td width="48%" height="22px" valign="top">
                        	<table border="0" cellpadding="0" cellspacing="0" width="100%">
                            	<tr>
                                	<td>
                                        <table border=0 cellpadding=0 cellspacing=0 width=100%>
                                            <tr class="SectionHeader toolbar">
                                                <td height="25px" align="left">Qualifications Available</td>
                                                <td height="22px">&nbsp;</td>
												<td height="22px" align="left">Qualifications to Add</td>
                                            </tr>
                                            <tr>
                                                <td colspan="3" height="20">&nbsp;</td>
                                            </tr>
                                            <tr>
                                                <td class="ColorBackground">
                                                    <select name="lstAttached" size="10" multiple class="pickbox" style="width:180px;" id="lstAttached" onChange="remAttached()"> 
                                                    <% if not rsQAvailableList.bof and not rsQAvailableList.eof then %>
														<% do while not rsQAvailableList.eof %>
                                                            <option value=<%= rsQAvailableList("Qid") %>><%= rsQAvailableList("Description") %></option>
                                                            <% rsQAvailableList.movenext() %>
                                                        <% loop %>
                                                    <% end if %>
                                                    </select>
                                                </td>
                                                <td>&nbsp;</td>
                                                <td>
                                                    <select name="pickAttached" size="10" class="pickbox"  style="width:180px;" id="pickAttached" onChange="addAttached()">
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
</form>

<form name="frmPopUpForm">
	<div id="PopUpwindow1" class="PopUpWindow">
		<table border=0 cellpadding=0 cellspacing=0 width=100%>
			<tr height="22px">
				<td class=MenuStyleParent colspan=5 align="center"><u>Confirm Qualification Details</u></td>
			</tr>
            <tr>
            	<td colspan="3" height="22px">&nbsp;</td>
            </tr>
			<tr class=columnheading>
				<td valign="middle" height="22px" width=2%></td>
				<td valign="middle" height="22px" width=30%>Qualification:</td>
				<td valign="middle" height="22px" width=68% class=toolbar><div id="QName"></div></td>
			</tr>
			<tr class=columnheading>
				<td valign="middle" height="22px" width=2%></td>
				<td valign="middle" height="22px" width=30%>Status:</td>
				<td valign="middle" height="22px" width=68% class=itemfont>
					<select class="itemfont" name="strstatus" id="strstatus">
						<option value=1>Mandatory</option>
						<option value=2>Desirable</option>
						<option value=3>Nice to Have</option>
					</select>
				</td>
			</tr>
			<tr class=columnheading>
				<td valign="middle" height="22px" width=2%></td>
				<td valign="middle" height="22px" width=30%>Competent:</td>
				<td valign="middle" height="22px" width=68% class=itemfont>
					<select class="itemfont" name="competent" id="competent">
						<option value=False>No</option>
						<option value=True selected>Yes</option>
					</select>
				</td>
			</tr>
			<tr>
				<td height="22px" colspan=3></td>
			</tr>
			<tr>
				<td height="22px" align="center" colspan=3><Input CLASS="StandardButton" Type=Button style="width:60px;" Value=OK onclick="javascript:populateArrays();"></td>
			</tr>
            <tr>
                <td colspan="3" height="22px">&nbsp;</td>
            </tr>
		</table>
	</div>
</form>

</body>
</html>


<script language="JavaScript">

var statusArray = new Array();
var competentArray = new Array();

currentArray = 0;

function remAttached()
{
	
    /* we've clicked on an Attachment to REMOVE it */
	var list, field, location, picked, txt;
	var newattached;
		
	list = document.forms['frmDetails']['pickAttached'];        /* list of Sections to REMOVE */
	location = document.forms['frmDetails']['lstAttached'];     /* list of Sections that can be REMOVED */
	
	var optArr = document.frmDetails.lstAttached.options;
	
	//alert("1 " + optArr.length + " * " + location.value);
	for(x=0;x<optArr.length;x++){
		if(optArr[x].value == location.value){
			var obj = optArr[x];
		}
	}

	/* this is the value for the assigned list */
	document.frmDetails.hiddenChange.value = "true";
	var txt = obj.innerHTML;
	
	var strSplit = obj.value.split("*");
	
	//alert("txt is " + txt + " * " + strSplit[0] + " * " + strSplit[1]);
	
	list.options[list.options.length] = new Option(txt,obj.value,false); /* true would select it */

	obj.parentNode.removeChild(obj);
	
	/* if we just clicked on last entry don't try to assign focus - cos theres nowt there */
	if(document.frmDetails.lstAttached.options.length != 0)
	{
		document.frmDetails.lstAttached[0].focus();
	}	

    document.frmDetails.lstAttached.disabled=true;
	document.frmDetails.pickAttached.disabled=true;
	PopUpwindow1.style.visibility = "Visible";
	QName.innerHTML=txt;
}


/* clicked on assigned list - this will remove entry they clicked from the list and put it back on unassigned list */
function addAttached()
{
	
	var list, field, location, current;
	var cval, ctxt, cstr;
	var newattached;
	
	re = /,/; 
	lstxt= new Array;
	lsval= new Array;

	list = document.forms['frmDetails']['lstAttached'];      /* Available list */
	location = document.forms['frmDetails']['pickAttached']; /* REMOVE list */
	//field = document.frmDetails.pickAttached.options.value;  /* Entry in REMOVE list they clicked to remove */

	var optArr = document.frmDetails.pickAttached.options;
	
	for(x=0;x<optArr.length;x++){
		if(optArr[x].value == location.value){
			var obj = optArr[x];
		}
	}

	var txt = obj.innerHTML;

    // add the one we just clicked on in the List to Add
	// back into the List Available
	list.options[list.options.length] = new Option(txt,obj.value,true); /* true would select it */

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

function populateArrays()
{
	document.getElementById('PopUpwindow1').style.visibility = 'Hidden';
	var competent=status=document.all["competent"].value;
	competentArray[currentArray] = competent;
	var strstatus=document.all["strstatus"].value;
	statusArray[currentArray] = strstatus;
	currentArray++;
	document.frmDetails.lstAttached.disabled=false;
	document.frmDetails.pickAttached.disabled=false;
	document.all["competent"].selectedIndex=1;
}

///* clicked the SUBMIT button - so write the changes to the database  via writeGroups.asp */
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
			errMsg += "Please provide/correct the following:\n\n- Qualifications Available"
			document.frmDetails.lstAttached.focus(); 
		}

	    /* now build the section list - if any - to be removed */
		if(document.frmDetails.pickAttached.options.length != 0)
		{
        	list = document.frmDetails.pickAttached.value;
	
	    	/* now build hidden value with list of Locations to submit so the program writelocations can update database */
			newattached = document.frmDetails.pickAttached[0].value; 
			newStatusAttached = statusArray[0]; 
			newCompetentAttached = competentArray [0];

			for(var i = 1; i < document.frmDetails.pickAttached.options.length; i++)
			{
		 		newattached = newattached + "," + document.frmDetails.pickAttached[i].value
				newStatusAttached = newStatusAttached + "," + statusArray[i]
				newCompetentAttached = newCompetentAttached + "," + competentArray [i];
			}
			
			document.frmDetails.newattached.value = newattached;
			document.frmDetails.newStatusAttached.value = newStatusAttached;
			document.frmDetails.newCompetentAttached.value = newCompetentAttached;
		}

		if(!errMsg=="")
		{
			alert(errMsg)
			return;	  		
		}

        //alert( newattached);
		document.frmDetails.hiddenChange.value = "";
		document.frmDetails.submit();  
	}
}
	
</script>
<script language="javascript">

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