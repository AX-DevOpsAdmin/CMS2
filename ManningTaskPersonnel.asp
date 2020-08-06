<!DOCTYPE HTML >

<!--#include file="Includes/security.inc"--> 
<!--#include file="Connection/Connection.inc"-->

<%

u = Request.ServerVariables("LOGON_USER")
color1="#f4f4f4"
color2="#fafafa"
counter=0
' parameters for the Delete Option
strTable = "tblTeam"    ' tablename
strGoTo = "ManningTeamSearch.asp"   ' asp page to return to once record is deleted
strTabID = "teamID"              ' key field name for table  
strFrom="Manning"  

' ' Make sure session dates have been reset if we chose different ones in ManningTaskSearch(hiddenStartDate) or updated the task with different ones(startdate)
if request("StartDate") <> "" then 
    session("tSearchStartDate") = request("StartDate")
elseif  request("HiddenStartDate") <> "" then 
    session("tSearchStartDate") = request("HiddenStartDate")
end if

if request("EndDate") <> "" then 
  session("tSearchEndDate") = request("EndDate")
elseif request("HiddenEndDate") <> "" then 
  session("tSearchEndDate") = request("HiddenEndDate")
end if

set objCmd = server.CreateObject("ADODB.Command")
set objPara = server.CreateObject("ADODB.Parameter")
objCmd.ActiveConnection = con
objCmd.Activeconnection.cursorlocation = 3
objCmd.CommandType = 4				'Code for Stored Procedure

' first find out whether its an HQ Tasking Group - cos if it is then we display HQ Task details
'strCommand = "spCheckHqTask"
'objCmd.CommandText = strCommand
'set objPara = objCmd.CreateParameter ("StaffID",3,1,0, session("StaffID"))
'objCmd.Parameters.Append objPara
'set objPara = objCmd.CreateParameter ("HQTasking",3,2)
'objCmd.Parameters.Append objPara
'objCmd.Execute	             'Execute CommandText when using "ADODB.Command" object
'strHQTasking   = objCmd.Parameters("HQTasking") 
'' Now Delete the parameters
'objCmd.Parameters.delete ("StaffID")
'objCmd.Parameters.delete ("HQTasking")

strHQTasking=0

' now get the task personnel
set objPara = objCmd.CreateParameter ("TaskID",3,1,5, request("RecID"))
objCmd.Parameters.Append objPara
set objPara = objCmd.CreateParameter ("startDate",200,1,50, session("tSearchStartDate"))
objCmd.Parameters.Append objPara
set objPara = objCmd.CreateParameter ("endDate",200,1,50, session("tSearchEndDate"))
objCmd.Parameters.Append objPara

objCmd.CommandText = "sp_TaskPersonnelSummary"	'Name of Stored Procedure'
set rsRecSet = objCmd.Execute	'Execute CommandText when using "ADODB.Command" object'

' Now check if they are Administrators
if session("Administrator") = "1" then
  strAdmin = "1" 
end if

%>

<html>
<head> 

<!--#include file="Includes/IECompatability.inc"-->


<title><%=pageTitle%></title>
<link rel="stylesheet" type="text/css" href="Includes/AMDB.css" media="Screen"/>

<script type="text/javascript" src="calendar.js"></script>

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
<form  action="" method="POST" name="frmDetails">
    <Input name="RecID" id="RecID" type="hidden" value=<%=request("RecID")%>>
    <input name="newattached" id="newattached" type="hidden" value="">
    <input name="ReturnTo" id="ReturnTo" type="hidden"  value="ManningTaskPersonnel.asp">
    <Input name="DoSearch" id="DoSearch" type="hidden" value=1>
    <Input name="Page" id="Page" type="hidden" value=1>
    <Input name="HiddenDate" id="HiddenDate" type="hidden" >
    <input name="currentlyChecked" id="currentlyChecked" type=hidden value=<%=request("currentlyChecked")%>>
    <input name="criteriaChange" id="criteriaChange" type=hidden value=0>
    <table  height="100%" cellspacing=0 cellPadding=0 width=100% border=0>
    	<tr>
    		<td>
    			<!--#include file="Includes/Header.inc"-->
                <table cellSpacing=0 cellPadding=0 width=100% border=0 >
                    <tr style="font-size:10pt;" height=26px>
    	                <td width=10px>&nbsp;</td>
	                    <td><A title="" href="index.asp" class=itemfontlinksmall>Home</A> > <a href="ManningTaskSearch.asp?dosearch=1&task=&ttID=1&startdate=&endDate=" class=itemfontlinksmall >Tasking</A> > <a href="ManningTask.asp?RecID=<%=request("RecID")%>" class="itemfontlinksmall">Task</a> > </a><font class="youAreHere" >Tasked Personnel</font></td>
                    </tr>
                    <tr>
                    	<td colspan=2 class=titlearealine  height=1></td> 
                    </tr>
                </table>
               <table style="height:900px;" width=100% height="328" border=0 cellpadding=0 cellspacing=0> 
                    <tr valign=Top>
                        <td class="sidemenuwidth" background="Images/tableback.png">
                            <table width=100% border=0 cellpadding=0 cellspacing=0 class=MenuStyleParent>
                                <tr height=30>
                                    <td></td>
                                    <td width="9" valign=top></td>
                                    <td width="170" align=left><a href="index.asp">Home</a></td>
                                    <td width="50" align=Left class=rightmenuspace ></td>
                                </tr>
                                <tr height=30>
                                	<td></td>
                                	<td valign=top></td>
                                	<% if strPage = "Tasks" then %>
                                		<td align=Left class="selected">Tasking</td>
                                	<% else %>  
                                		<td align=Left><A title="" href="ManningTaskSearch.asp">Tasking</A></td>
                                	<% end if %> 
                                	<td class=rightmenuspace align=Left></td>
                                </tr>
							</table>
                        </td>
					    <td width=16>&nbsp;</td>
    					<td align=left>
                            <table border=0 cellpadding=0 cellspacing=0 width=100%>
                                <tr height=16 class=SectionHeader>
                                    <td>
                                		<table border=0 cellpadding=0 cellspacing=0>
                                        	<tr>
                                				<td width=20><a class=itemfontlink href="ManningTaskPersonnelAdd.asp?RecID=<%=request("RecID")%>"><img src="images/newitem.gif" width="17" class="imagelink"></A></td>
                                				<td class=toolbar valign="middle">Add Personnel</td>
                                				<td class=titleseparator valign="middle" width=14 align="center">|</td>
                                				<td width=20><a class=itemfontlink href="javascript:confirmRemove();"><img class="imagelink" src="images/delitem.gif"></A></td>
                                				<td class=toolbar valign="middle" >Remove Personnel</td>        
												<% if strDelOK = "0" then %>
                                                    <td class=titleseparator valign="middle" width=14 align="center">|</td>
                                                    <td class=toolbar width=8></td>
                                                    <td width=20><a class=itemfontlink href="DeleteRec.asp?RecID=<%=request("recID")%>&TableName=<%=strTable%>&TabId=<%=strTabID%>&GoTo=<%=strGoTo%>" onClick="javascript:return(checkDelete());"><img class="imagelink" src="images/delitem.gif"></A></td>
                                                    <td class=toolbar valign="middle">Delete Task</td>
                                                <% end if %>
                                				<td class=titleseparator valign="middle" width=14 align="center">|</td>    
                                				<td class=toolbar valign="middle" ><A class=itemfontlink href="ManningTaskSearch.asp">Back</A></td>
                                            </tr>
			                            </table>
								    </td>
							    </tr>
                                <tr>
								    <td>
    									<table width=100% border=0 cellpadding=0 cellspacing=0>
    										<tr height=16>
    											<td>&nbsp;</td>
    										</tr>
    										<tr class=columnheading>
                                                <td valign="middle" height="22px" width=2%></td>
                                                <td valign="middle" height="22px" width=13%>Task:</td>
                                                <td valign="middle" height="22px" width=85% class=itemfont><%=rsRecSet("Task")%></td>
                                                <td>&nbsp;</td>
                                            </tr>    
                                            <tr class=columnheading>
                                                <td valign="middle" height="22px" width=2%>&nbsp;</td>
                                                <td valign="middle" height="22px" width="13%">Task Type:</td>
                                                <td valign="middle" height="22px" width="85%" class=itemfont ><%=rsRecSet("Type")%></td>
                                                <td>&nbsp;</td>
                                            </tr>
                                            <tr class=columnheading>
                                                <td valign="middle" height="22px" width=2%>&nbsp;</td>
                                                <td valign="middle" height="22px" width="13%">Start Date:</td>
                                                <td valign="middle" height="22px" width="85%" class=itemfont ><%=session("tSearchStartDate")%></td>
                                                <td>&nbsp;</td>
                                            </tr>
                                            <tr class=columnheading>
                                                <td valign="middle" height="22px" width=2%>&nbsp;</td>
                                                <td valign="middle" height="22px" width="13%">End Date:</td>
                                                <td valign="middle" height="22px" width="85%" class=itemfont ><%=session("tSearchEndDate")%></td>
                                                <td>&nbsp;</td>
                                            </tr>    
                                            <tr class=columnheading>
                                                <td valign="middle" height="22px" width=2%>&nbsp;</td>
                                                <td valign="middle" height="22px" width="13%">Cancellable:</td>
                                                <td valign="middle" height="22px" width=85% class=itemfont>
                                                	<% if rsRecSet("cancellable") = true then %>
                                                		Yes
                                                	<% else %>
                                                		No									 
                                                	<% end if %>
                                                </td>
                                                <td>&nbsp;</td>
											</tr>	
											<% ooastr="No" %>
                                            <% bnastr="No" %>
                                            <% if rsRecSet("ooa") <> 0 then %>
                                            	<% bnastr="Yes" %>
                                            	<% if rsRecSet("ooa") = 1 then %>
                                            		<% ooastr="Yes" %>
                                            	<% end if %>
                                            <% end if %> 
                                            <tr class=columnheading>
                                                <td valign="middle" height="22px" width=2%>&nbsp;</td>
                                                <td valign="middle" height="22px">Out of Area:</td>
                                                <td width=82% height="22px" class=itemfont><%= ooastr %></td>
                                                <td>&nbsp;</td>
                                            </tr>	
                                            <tr class=columnheading>
                                                <td valign="middle" height="22px" width=2%>&nbsp;</td>
                                                <td valign="middle" height="22px">Bed Night Away:</td>
                                                <td width=82% height="22px" class=itemfont><%=bnastr%></td>
                                                <td>&nbsp;</td>
                                            </tr>	
                                            <tr class=columnheading>
                                            	<td valign="middle" height="22px" width=2%>&nbsp;</td>
												<% if strHQTasking = 1 then %>
                                                    <td valign="middle" height="22px">HQ Task:</td>
                                                    <td width=82% height="22px" class=itemfont>
                                                        <% if rsRecSet("hqTask")=true then%>
                                                            Yes
                                                        <% else %>
                                                            No
                                                        <% end if %> 
                                                    </td> 
                                                <% end if %>	
                                                <td>&nbsp;</td>
    										</tr>	        
                                            <tr>
                                            	<td colspan=5 class=titlearealine  height=1></td> 
                                            </tr>        
    										<% set rsRecSet = rsRecSet.nextrecordset %>    
										</form>
                                        <form  action="" method="post" name="frmPosts">
                                        	<tr>
                                        		<td colspan=5>
                                        			<table width="100%" border=0 cellpadding=0 cellspacing=0>
                                        				<tr class=itemfont>
                                        					<td width=2% height="22px">&nbsp;</td>
                                        					<td colspan=7 align="left" height="22px">Search Results: <Font class=searchheading>records found: <%=rsRecSet.recordcount%></Font></td>
                                        				</tr>
                                        				<tr>
                                        					<td colspan=10 class=titlearealine  height=1></td> 
                                        				</tr>    
                                        				<tr class=columnheading>
                                                            <td valign="middle" height="22px" width=2%></td>
                                                            <td valign="middle" height="22px" width=13% onclick="javascript:SortByCol1 ();" class="mouseHand">Surname<%if sort=1 then%><img src="images/searchUp.jpg"><%end if%><%if sort=2 then%><img src="images/searchDown.jpg"><%end if%></td>
                                                            <td valign="middle" height="22px" width=11% onclick="javascript:SortByCol2 ();" class="mouseHand">Firstname
																<% if sort = 3 then %>
                                                                    <img src="images/searchUp.jpg">
                                                                <% end if %>
                                                                <%if sort = 4 then %>
                                                                    <img src="images/searchDown.jpg">
                                                                <%end if%>
                                                            </td>
                                                            <td valign="middle" height="22px" width=10% onclick="javascript:SortByCol3 ();" class="mouseHand">Service No<%if sort=5 then%><img src="images/searchUp.jpg"><%end if%><%if sort=6 then%><img src="images/searchDown.jpg"><%end if%></td>
                                                            <td valign="middle" height="22px" width=12% align="center" onclick="javascript:SortByCol4 ();" class="mouseHand">Start Date<%if sort=7 then%><img src="images/searchUp.jpg"><%end if%><%if sort=8 then%><img src="images/searchDown.jpg"><%end if%></td>
                                                            <td valign="middle" height="22px" width=9% align="center" onclick="javascript:SortByCol4 ();" class="mouseHand">End Date<%if sort=7 then%><img src="images/searchUp.jpg"><%end if%><%if sort=8 then%><img src="images/searchDown.jpg"><%end if%></td>
                                                            <td width="9%" align="center" valign="middle" height="22px">Post</td>
                                                            <td width="14%" align="center" valign="middle" height="22px">Unit</td>
                                                            <td width="9%" align="center" valign="middle" height="22px"><!--Update/-->Remove</td>
                                                            <td width="11%">&nbsp;</td>
                                                        </tr>
                                                        <tr>
	                                                        <td colspan=10 class=titlearealine height=1></td> 
                                                        </tr>    
														<% if rsRecSet.recordcount > 0 then %>
                                                        	<% if request("page")<>"" then %>
                                                        		<% page = int(request("page")) %>
                                                        	<% else %>
                                                        		<% page = 1 %>
                                                        	<% end if %>
                                        					<% recordsPerPage = 20 %>
                                        					<% num=rsRecSet.recordcount %>
                                        					<% startRecord = (recordsPerPage * page) - recordsPerPage %>
                                        					<% totalPages = (int(num/recordsPerPage)) %>
                                        					<% if int(num - (recordsPerPage * totalPages)) > 0 then totalPages=totalPages + 1 %>
                                        					<% if page = totalPages then recordsPerPage = int(num - startRecord) %>
                                        					<% if rsRecSet.recordcount>0 then rsRecSet.move(startRecord) %>
                                        					<% beginAtPage = 1 %>
                                        					<% increaseAfter = 6 %>
                                        					<% startEndDifference = 9 %>
                                        					<% if page-increaseAfter >1 then %>
                                        						<% beginAtPage=page-increaseAfter %>
                                        					<% end if %>
                                        					<% if totalPages < beginAtPage+startEndDifference then %>
                                        						<% beginAtPage = totalPages-startEndDifference %>
                                        					<% end if %>
                                        					<% endAtPage=beginAtPage+startEndDifference %>
                                        					<% if beginAtPage<1 then beginAtPage = 1 %>
                                        					<% Row = 0 %>
															<% do while Row < recordsPerPage %>
                                                                <tr class=itemfont ID="TableRow<%=rsRecSet ("TaskStaffID")%>" <%if counter=0 then%>style="background-color:<%=color1%>;"<%else%>style="background-color:<%=color2%>;"<%end if%>>
                                                                    <td valign="middle" height="22px">&nbsp;</td>
                                                                    <td valign="middle" height="22px"><%=rsRecSet("Surname")%></td>    
                                                                    <td valign="middle" height="22px"><%=rsRecSet("firstName")%></td>
                                                                    <td valign="middle" height="22px"><%=rsRecSet("serviceNo")%></td>
                                                                    <td valign="middle" height="22px" align="center"><%=rsRecSet("startDate")%></td>
                                                                    <td valign="middle" height="22px" align="center"><%=rsRecSet("endDate")%></td>
                                                                    <td valign="middle" height="22px" align="center"><%=rsRecSet("post")%></td>
                                                                    <td valign="middle" height="22px" align="center"><%=rsRecSet("team")%></td>
                                                                    <td valign="middle" height="22px" align="center"><input type="checkbox" name=StaffID<%=rsRecSet("StaffID")%> id=StaffID<%=rsRecSet("StaffID")%> value="<%=rsRecSet("taskStaffID")%>" <%if Instr(request("currentlyChecked"), "*" & rsRecSet("taskStaffID") & "*" ) >0 then response.write(" checked")%> ></td>    
                                                                    <td>&nbsp;</td>
                                                                </tr>
                                                                <tr>
                                                                	<td colspan=10 class=titlearealine height=1></td> 
                                                                </tr>    
                                                            	<% Row = Row + 1 %>
                                                            	<% rsRecSet.MoveNext %>
                                                            	<% if counter = 0 then %>
                                                            		<% counter = 1 %>
                                                            	<% else %>
                                                            		<% if counter = 1 then counter = 0 %>
                                                            	<% end if %>
                                                            <% loop %>
                                        					<tr>
                                        						<td colspan=10 height="22px">&nbsp;</td>
                                        					</tr>    
                                        					<tr align="center">
                                        						<td colspan=10 height="22px">
                                        							<table border=0 cellpadding=0 cellspacing=0>
                                        								<tr>
                                        									<td class=itemfont>Results Pages: &nbsp;</td>    
                                        									<td class=ItemLink>
																				<% if int(page) > 1 then %>
                                                                                	<a href="javascript:MovetoPage(<%=page-1%>);" class=ItemLink><< Previous</a>
                                                                                <% else %>
                                                                                	<< Previous
                                                                                <% end if %>
                                                                            </td>
                                        									<td class=itemfont>&nbsp;&nbsp;</td>    
                                        									<% pagenumber = beginAtPage %>
																			<% do while pagenumber <= endAtPage %>
                                                                            	<td><a <% if page <> pagenumber then %>
                                                                                    	<%= response.write(" class=ItemLink ") %>
                                                                                        href="javascript:MovetoPage(<%=pagenumber%>);"
                                                                            		<% else %>
                                                                            			<%= response.write (" class=itemfontbold") %>
                                                                            		<% end if %>>
                                                                            		<%= Pagenumber %></a>
																					<%if pagenumber < (endAtPage) then %>
                                                                                    	<font class=itemfont>,</font>
																					<% end if %>
                                                                            	</td>
                                                                            	<% pageNumber = pageNumber + 1 %>
                                                                            <% loop %>
                                        									<td class=itemfont>&nbsp;&nbsp;</td>
                                                                            <td class=ItemLink>
																				<% if int(page) < int(endAtPage) then %>
                                                                                	<a href="javascript:MovetoPage(<%=page+1%>);" class=ItemLink>Next >></a>
                                                                                <% else %>
                                                                                	Next >>
                                                                                <% end if %>
                                                                            </td>
                                                                        </tr>
                                        							</table>
                                        						</td>
                                        					</tr>
                                        				<% else %>
                                                            <tr class=itemfont>
                                                                <td align="left" height="22px" width=2%></td>
                                                                <td class="toolbar" align="left" height="22px" colspan=10>No Personnel have been tasked</td>
                                                            </tr>
                                                            <tr>
                                                            	<td colspan=10 class=titlearealine height=1></td> 
                                                            </tr>
                                        				<%end if%>
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
            </td>
        </tr>
    </table>
</form>

<div id="update" style="width: 400px; height: 200px; position: absolute; z-index: 1; display: none">
    <table align="center" border="0" cellpadding="0" cellspacing="0" width="100%">
        <tr>
            <td height="25px" align="left" background="Images/toolgradp.gif" class="itemfont">&nbsp;Task Details</td>
            <td height="25px" align="right" background="Images/toolgradp.gif"><img align="absmiddle" src="Images/Close.gif" width="19" height="19" alt="Close" onclick="btnClose_onClick();" style="cursor:default;">&nbsp;</td>
        </tr>
        <tr>
            <td>&nbsp;</td>
        </tr>
    </table>
    <table align="center" border="0" cellpadding="4" cellspacing="4" width="95%">
        <tr>
            <td width="27%" class="personalDetails">Start Date:</td>
            <td width="73%"><input name="startDate" type="text" class="pickbox" style="width: 75px" id="startDate" value=""/>
            <img src="Images/cal.gif" alt="From Date" width="16" align="absmiddle" height="16" style="cursor:hand" onClick="calSet(startDate)"></td>
        </tr>
        <tr>
            <td class="personalDetails">End Date:</td>
            <td><input name="endDate" type="text" class="pickbox" style="width: 75px" id="endDate" value=""/>
            <img src="Images/cal.gif" alt="To Date" width="16" align="absmiddle" height="16" style="cursor:hand" onClick="calSet(endDate)"></td>
        </tr>
        <tr>
            <td valign="top" class="personalDetails">Notes:</td>
            <td><textarea name="txtNotes" id="txtNotes" class="pickbox" cols="20" rows="5" id="txtNotes" style="width: 280px"></textarea></td>
        </tr>
    </table>
    <table align="center" border="0" cellpadding="2" cellspacing="2" width="95%">
        <tr>
            <td width="43%" height="50" align="right"><a href="javascript:UpdatePersonnel()" class="itemfontlink"><img src="Images/saveitem.gif" style="border: none"></a></td>
            <td width="57%" height="50" align="left" class="toolbar">Save and Close</td>
      </tr>
    </table>
</div>

</body>
</html>

<SCRIPT LANGUAGE="JavaScript">
function confirmRemove()
{    
	newattached="start";
	stringToCheck = document.frmDetails.currentlyChecked.value
	for (var i = 0; i < document.frmPosts.elements.length; i++)
	{
		currentValue=document.frmPosts.elements[i].value;
		if (document.frmPosts.elements[i].checked==true)
		{
			if(stringToCheck.indexOf(currentValue)<0)
			{
				newattached = newattached + "," + document.frmPosts.elements[i].value;
			}
		}
	}
    document.frmDetails.newattached.value = newattached + document.frmDetails.currentlyChecked.value;
	
	if(document.frmDetails.newattached.value=="start")
	{
	    alert("Select Personnel to remove")
	    return;	  		
    }
	
	yesBox=confirm("Are you sure you want to remove checked personnel?");
	
	if (yesBox==true)
	{
		saveNew();
	}
}

function saveNew(){
    /* now build the section list - if any - to be removed */

    /* now build hidden value with list of Locations to submit so the 
       program writelocations can update database */
	newattached="start";
	stringToCheck = document.frmDetails.currentlyChecked.value
	for (var i = 0; i < document.frmPosts.elements.length; i++){
		currentValue=document.frmPosts.elements[i].value;
		if (document.frmPosts.elements[i].checked==true) {
			if (stringToCheck.indexOf(currentValue)<0){
				newattached = newattached + "," + document.frmPosts.elements[i].value;
			}
		}
	}
    document.frmDetails.newattached.value = newattached + document.frmDetails.currentlyChecked.value;
	
	if(document.frmDetails.newattached.value=="start") {
	    alert("Select at least one post")
	    return;	  		
    } 

    document.frmDetails.action="RemoveTaskPersonnel.asp";
    document.frmDetails.submit();
}

function MovetoPage (PageNo) {
//alert(PageNo);
if (document.frmDetails.criteriaChange.value==1){
	PageNo=1;
	}
	stringToCheck = document.frmDetails.currentlyChecked.value

	for (var i = 0; i < document.frmPosts.elements.length; i++){
		currentValue=document.frmPosts.elements[i].value;
		if (document.frmPosts.elements[i].checked==true ) {
			if (stringToCheck.indexOf(currentValue)<0){
				
				stringToCheck = stringToCheck + "," + document.frmPosts.elements[i].value;
			}
		}else{
			if (stringToCheck.indexOf(currentValue)>=0){
				
				stringToCheck=stringToCheck.replace(","+currentValue,"");
			}
		}
	}

	document.frmDetails.currentlyChecked.value = stringToCheck;
	document.forms["frmDetails"].elements["Page"].value = PageNo;
	document.frmDetails.action = "ManningTaskPersonnel.asp";
	document.forms["frmDetails"].submit();
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

</Script>
