<!DOCTYPE HTML >

<!--#include file="Includes/security.inc"--> 
<!--#include file="Connection/Connection.inc"-->
<!--#include file="Includes/checkmanager.inc"-->  
<!--#include file="Includes/manageradmin.inc"-->  

<%
tab=3
strTable = "tblstaff"
strGoTo = "AdminPeRsList.asp"   ' asp page to return to once record is deleted
strTabID = "staffID"              ' key field name for table        
strRecid = "staffID"

strCommand = "spPostDetailSummary"

set objCmd = server.CreateObject("ADODB.Command")
set objPara = server.CreateObject("ADODB.Parameter")
objCmd.ActiveConnection = con
objCmd.Activeconnection.cursorlocation = 3

objCmd.CommandText = strCommand
objCmd.CommandType = 4		
set objPara = objCmd.CreateParameter ("RecID",3,1,5, request("postID"))
objCmd.Parameters.Append objPara
set rsRecSet = objCmd.Execute	'Execute CommandText when using "ADODB.Command" object

for x = 1 to objCmd.parameters.count
	objCmd.parameters.delete(0)
next

objCmd.CommandText = "spPostQualificationsTypeDetails"	'Name of Stored Procedure
objCmd.CommandType = 4				'Code for Stored Procedure
set objPara = objCmd.CreateParameter ("RecID",3,1,5, request("postID"))
objCmd.Parameters.Append objPara
set objPara = objCmd.CreateParameter ("TypeID",3,1,5, request("QTypeID"))
objCmd.Parameters.Append objPara

set rsQualificationDetails = objCmd.Execute	'Execute CommandText when using "ADODB.Command" object

intHrc= int(rsRecSet("hrcID"))

%>

<html>
<head>

<!--#include file="Includes/IECompatability.inc"-->


<title>Personnel Details</title>
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
<form action="RemovePostQualifications.asp" method="post" name="frmDetails">
	<Input Type="Hidden" name="postID" id="postID" value="<%=request("postID")%>">
	<input type=hidden name="QTypeID" id="QTypeID" value=<%=request("QTypeID")%>>
    <input type="hidden" name="hrcID" id="hrcID"  value=<%=intHrc%>>
	<input name="hiddenChange" id="hiddenChange" type="hidden" value="">
	<input name="newattached" id="newattached" type="hidden" value="">
	<input type="hidden" name="ReturnTo" id="ReturnTo" value="hierarchyPostQualificationsRemove.asp"/>
    
	<table border=0 cellpadding=0 cellspacing=0 width=100%>
		<!--#include file="Includes/hierarchyPostDetails.inc"--> 
		<tr>
			<td colspan=10 class=titlearealine  height=1></td> 
		</tr>
		<tr class=SectionHeader>
			<td>
				<table border=0 cellpadding=0 cellspacing=0>
                	<tr>
						<td height="25px" class=toolbar width=8></td>
						<td height="25px" width=20><a href="javascript:saveNew();"><img class="imagelink" src="images/saveitem.gif"></A></td>
						<td height="25px" width="110" valign="middle" class=toolbar >Save and Close </td>
						<td height="25px" class=titleseparator valign="middle" width=12 align="center">|</td>
						<td width="32" height="25px" valign="middle" class=toolbar ><A class=itemfontlink href="HierarchyPostQualificationsDetails.asp?postID=<%=request("postID")%>&QTypeID=<%=request("QTypeID")%>">Back</A></td>											
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
									<% rsQualificationDetails.movefirst %>
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
                                                <td height="25px" align="left">Qualifications Held</td>
                                                <td height="25px">&nbsp;</td>
                                                <td height="25px" align="left">Qualifications to Remove</td>
                                            </tr>
                                            <tr>
                                                <td colspan="3" height="20">&nbsp;</td>
                                            </tr>
                                            <tr>
                                                <td class="ColorBackground">
                                                    <select name="lstAttached" size="10" multiple class="pickbox" style="width:180px;" id="lstAttached" onChange="remAttached()"> 
													<% if not rsQualificationDetails.bof and not rsQualificationDetails.eof then %>
                                                        <% do while not rsQualificationDetails.eof %>
                                                            <option value=<%= rsQualificationDetails("PostQid") %>><%= rsQualificationDetails("Description") %></option>
                                                            <% rsQualificationDetails.movenext() %>
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
</form>

</body>
</html>

<script language="javascript">

function remAttached()
{
	 //alert("remAttached");
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

	/* this is the value for the assigned list */
	/* newattached = document.frmAdmin.lstLocation.value + "|" + field;  */
	document.frmDetails.hiddenChange.value = "true";
		 
    // txt=document.frmDetails.lstAttached.options[inum].text;
	var txt = obj.innerHTML;
	list.options[list.options.length] = new Option(txt,obj.value,false); /* true would select it */
	//document.frmDetails.lstAttached[inum] = null;
	obj.parentNode.removeChild(obj);
	
	/* if we just clicked on last entry don't try to assign focus - cos theres nowt there */
	if(document.frmDetails.lstAttached.options.length != 0)
	{
		document.frmDetails.lstAttached[0].focus();
	}	
}

/* clicked on assigned list - this will remove entry they clicked from the list and put it back on unassigned list */
function addAttached()
{
	//alert("addAttached");
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
	
	//alert("remove this " + txt);
	
	//list.options[list.options.length] = new Option(newattached,field,false); /* true would select it */
	list.options[list.options.length] = new Option(txt,obj.value,false); /* true would select it */

    var icount = 0;
	for (var i = 0; i < list.options.length; i++)
	{	    
		lsval[icount]= document.frmDetails.lstAttached[i].value;
		lstxt[icount]= document.frmDetails.lstAttached[i].text + "," + document.frmDetails.lstAttached[i].value;
		icount++;
	}

    lsval.sort();
	lstxt.sort();
	for(var i = 0; i < lstxt.length; i ++)
	{
		current = lstxt[i];
		cstr = current.split(re);
		ctxt= cstr[0];
		cval= cstr[1]; 
		//alert("add " + ctxt + " * " + cval);
        document.frmDetails.lstAttached[i].value = cval;
		document.frmDetails.lstAttached[i].text = ctxt;
	}
 
	//document.frmDetails.pickAttached[inum] = null;
	obj.parentNode.removeChild(obj);

	document.frmDetails.pickAttached.selectedIndex=-1
	
	/* There is nothing picked to remove - so make sure change flag is unset */
    if(document.frmDetails.pickAttached.options.length == 0)
	{
		document.frmDetails.hiddenChange.value = "";
	}
	
	//CurrentDateArray=CurrentDateArray-1;
}

/* clicked the SUBMIT button - so write the changes to the database  via writeGroups.asp */
function saveNew(){
    var list, field, location, current;
	var newattached;
	var errMsg = "";
	
	/* not picked any so ignore submit */		
    if(document.frmDetails.hiddenChange.value == "")
	{
		errMsg += "Please provide/correct the following:\n\n- Qualifications to Remove"
		document.frmDetails.lstAttached.focus(); 
	}

    /* now build the section list - if any - to be removed */
	if(document.frmDetails.pickAttached.options.length != 0)
	{
    	list = document.frmDetails.pickAttached.value;
	
		/* now build hidden value with list of Locations to submit so the program writelocations can update database */
		newattached = document.frmDetails.pickAttached[0].value; 
		for(var i = 1; i < document.frmDetails.pickAttached.options.length; i++)
		{
	    	newattached = newattached + "," + document.frmDetails.pickAttached[i].value
		}
		document.frmDetails.newattached.value = newattached;
	}

	if(!errMsg=="")
	{
		alert(errMsg)
		return;	  		
	} 

	document.frmDetails.hiddenChange.value = "";
	document.frmDetails.submit();  
}

</Script>
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