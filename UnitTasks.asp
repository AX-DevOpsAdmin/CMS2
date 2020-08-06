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
strCommand = "spCheckHqTask"
objCmd.CommandText = strCommand
set objPara = objCmd.CreateParameter ("StaffID",3,1,0, session("StaffID"))
objCmd.Parameters.Append objPara
set objPara = objCmd.CreateParameter ("HQTasking",3,2)
objCmd.Parameters.Append objPara
objCmd.Execute	             'Execute CommandText when using "ADODB.Command" object
strHQTasking   = objCmd.Parameters("HQTasking") 
' Now Delete the parameters
objCmd.Parameters.delete ("StaffID")
objCmd.Parameters.delete ("HQTasking")

' now get the task units
set objPara = objCmd.CreateParameter ("TaskID",3,1,5, request("RecID"))
objCmd.Parameters.Append objPara

objCmd.CommandText = "sp_TaskUnitsSummary"	'Name of Stored Procedure'
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
</style>
</head>
<body>
<form  action="ManningTaskPersonnel.asp" method="POST" name="frmDetails">
    <Input name="RecID" type="hidden" value=<%=request("RecID")%>>
    <input name="newattached" type="hidden" value="">
    <input name="ReturnTo" type="hidden"  value="UnitTasks.asp">
    <Input name="DoSearch" type="hidden" value=1>
    <Input name="Page" type="hidden" value=1>
    <Input name="HiddenDate" type="hidden" >
    <input name="currentlyChecked" type=hidden value=<%=request("currentlyChecked")%>>
    <input name ="criteriaChange" type=hidden value=0>
    <table  height="100%" cellspacing=0 cellPadding=0 width=100% border=0>
    	<tr>
    		<td>
    			<!--#include file="Includes/Header.inc"-->
                <table cellSpacing=0 cellPadding=0 width=100% border=0 >
                    <tr style="font-size:10pt;" height=26px>
    	                <td width=10px>&nbsp;</td>
	                    <td><A title="" href="index.asp" class=itemfontlinksmall >Home</A> > <A title="" href="ManningTaskSearch.asp?dosearch=1&task=&ttID=1&startdate=&endDate=" class=itemfontlinksmall >Tasking</A> > <a href="ManningTask.asp?RecID=<%=request("RecID")%>" class="itemfontlinksmall">Task</a> > <font class="youAreHere" >Tasked Units</font></td>
                    </tr>
                    <tr>
                    	<td colspan=2 class=titlearealine  height=1></td> 
                    </tr>
                </table>
                <table width=100% height='<%=session("heightIs")%>px' border=0 cellpadding=0 cellspacing=0 > 
                    <tr valign=Top>
                        <td class="sidemenuwidth" background="Images/tableback.png">
                            <table width=100% border=0 cellpadding=0 cellspacing=0 class=MenuStyleParent>
                                <tr height=22>
    	                            <td>&nbsp;</td>
	                                <td colspan=3 align=left height=20>Current Location</td>
                                </tr>
                                <tr height=22>
                                    <td width=10>&nbsp;</td>
                                    <td width=18 valign=top><img src="images/arrow.gif"></td>
                                    <td width=170 align=Left><A title="" href="index.asp">Home</A></td>
                                    <td width=50 align=Left>&nbsp;</td>
                                </tr>
                                <tr height=22>
                                    <td>&nbsp;</td>
                                    <td valign=top><img src="images/arrow.gif"></td>
                                    <td align=Left><A title="" href="ManningTaskSearch.asp?dosearch=1&task=&ttID=1&startdate=&endDate=">Tasking</a></td>
                                    <td align=Left>&nbsp;</td>
                                </tr>
                                <tr height=22>
                                    <td>&nbsp;</td>
                                    <td valign=top><img src="images/arrow.gif"></td>
                                    <td align=Left><A title="" href="ManningTask.asp?RecID=<%=request("RecID")%>">Task</a></td>
                                    <td align=Left>&nbsp;</td>
                                </tr>
                                <tr height=22>
                                    <td>&nbsp;</td>
                                    <td valign=top><img src="images/vnavicon.gif"></td>
                                    <td align=Left><a href="ManningTaskPersonnel.asp?RecID=<%=request("RecID")%>">Tasked Personnel</a></td>
                                    <td class=rightmenuspace align=Left ></td>
                                </tr>    
                                <tr height=22>
                                    <td>&nbsp;</td>
                                    <td valign=top><img src="images/vnavicon.gif"></td>
                                    <td align=Left bgcolor="#FFFFFF"><Div style="height:18px; width:16em; border:Solid; border-width:1px; border-color:#438BE4; color: #003399;">Tasked Units</Div></td>
                                    <td class=rightmenuspace align=Left ></td>
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
                                				<td width=20><a class=itemfontlink href="UnitTasksAdd.asp?RecID=<%=request("RecID")%>"><img class="imagelink" src="images/newitem.gif"></A></td>
                                				<td class=toolbar valign="middle" >Add Unit</td>
                                				<td class=titleseparator valign="middle" width=14 align="center">|</td>
                                				<td width=20><a class=itemfontlink  href="javascript:confirmRemove();"><img class="imagelink" src="images/delitem.gif"></A></td>
                                				<td class=toolbar valign="middle" >Remove Unit</td>        
												<% if strDelOK = "0" then %>
                                                    <td class=titleseparator valign="middle" width=14 align="center">|</td>
                                                    <td class=toolbar width=8></td><td width=20><a class=itemfontlink href="DeleteRec.asp?RecID=<%=request("recID")%>&TableName=<%=strTable%>&TabId=<%=strTabID%>&GoTo=<%=strGoTo%>" onClick="javascript:return(checkDelete());"><img class="imagelink" src="images/delitem.gif"></A></td>
                                                    <td class=toolbar valign="middle" >Delete Task</td>
                                                <% end if %>
                                				<td class=titleseparator valign="middle" width=14 align="center">|</td>    
                                				<td class=toolbar valign="middle" ><A class=itemfontlink href="ManningTask.asp?RecID=<%=request("RecID")%>">Back</A></td>
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
                                                <td valign="middle" height="22px" width=12%>Task:</td>
                                                <td valign="middle" height="22px" width=83% class=itemfont><%=rsRecSet("Task")%></td>
                                                <td>&nbsp;</td>
                                            </tr>    
                                            <tr class=columnheading>
                                                <td valign="middle" height="22px" width=2%>&nbsp;</td>
                                                <td valign="middle" height="22px">Task Type:</td>
                                                <td valign="middle" height="22px" class=itemfont ><%=rsRecSet("Type")%></td>
                                                <td>&nbsp;</td>
                                            </tr>
                                            <tr class=columnheading>
                                                <td valign="middle" height="22px" width=2%>&nbsp;</td>
                                                <td valign="middle" height="22px">Start Date:</td>
                                                <td valign="middle" height="22px" class=itemfont ><%=session("tSearchStartDate")%></td>
                                                <td>&nbsp;</td>
                                            </tr>
                                            <tr class=columnheading>
                                                <td valign="middle" height="22px" width=2%>&nbsp;</td>
                                                <td valign="middle" height="22px">End Date:</td>
                                                <td valign="middle" height="22px" class=itemfont ><%=session("tSearchEndDate")%></td>
                                                <td>&nbsp;</td>
                                            </tr>    
                                            <tr class=columnheading>
                                                <td valign="middle" height="22px" width=2%>&nbsp;</td>
                                                <td valign="middle" height="22px">Cancellable:</td>
                                                <td  width=83% height="22px" class=itemfont>
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
                                        <form  action="" method="post" name="frmUnits">
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
                                                            <td valign="middle" height="22px" width=13% onclick="javascript:SortByCol1 ();" class="mouseHand">Unit<%if sort=1 then%><img src="images/searchUp.jpg"><%end if%><%if sort=2 then%><img src="images/searchDown.jpg"><%end if%></td>
           													<td valign="middle" height="22px" width=12% align="center" onclick="javascript:SortByCol4 ();" class="mouseHand">Start Date<%if sort=7 then%><img src="images/searchUp.jpg"><%end if%><%if sort=8 then%><img src="images/searchDown.jpg"><%end if%></td>
                                                            <td valign="middle" height="22px" width=9% align="center" onclick="javascript:SortByCol4 ();" class="mouseHand">End Date<%if sort=7 then%><img src="images/searchUp.jpg"><%end if%><%if sort=8 then%><img src="images/searchDown.jpg"><%end if%></td>
                                                            <td width="9%" align="center" valign="middle" height="22px">Remove<!--/Update--></td>
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
                                                                <tr class=itemfont ID="TableRow<%=rsRecSet ("TaskunitID")%>" <%if counter=0 then%>style="background-color:<%=color1%>;"<%else%>style="background-color:<%=color2%>;"<%end if%>>
                                                                    <td valign="middle" height="22px">&nbsp;</td>
                                                                    <td valign="middle" height="22px"><%=rsRecSet("team")%></td>    
                                                                    <td valign="middle" height="22px" align="center"><%=rsRecSet("startDate")%></td>
                                                                    <td valign="middle" height="22px" align="center"><%=rsRecSet("endDate")%></td>
                                                                    <td valign="middle" height="22px" align="center"><input type="checkbox" name=StaffID<%=rsRecSet("TeamID")%> value="<%=rsRecSet("taskunitID")%>" <%if Instr(request("currentlyChecked"), rsRecSet("taskunitID")) >0 then response.write(" checked")%> ></td>    
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
                                                                <td class="toolbar" align="left" height="22px" colspan=10>No Units have been tasked</td>
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
            <td height="25px" align="left" background="Images/toolgradp.gif" class="itemfont">&nbsp;Personnel Task Details</td>
            <td height="25px" align="right" background="Images/toolgradp.gif"><img align="absmiddle" src="Images/Close.gif" width="19" height="19" alt="Close" onclick="btnClose_onClick();" style="cursor:default;">&nbsp;</td>
        </tr>
        <tr>
            <td>&nbsp;</td>
        </tr>
    </table>
    <table align="center" border="0" cellpadding="4" cellspacing="4" width="95%">
        <tr>
            <td width="27%" class="personalDetails">From:</td>
            <td width="73%"><input name="startDate" type="text" class="pickbox" style="width: 75px" id="startDate" value=""/>&nbsp;
            <img src="Images/cal.gif" alt="From Date" width="16" align="absmiddle" height="16" style="cursor:hand" onClick="calSet(startDate)"></td>
        </tr>
        <tr>
            <td class="personalDetails">To:</td>
            <td><input name="endDate" type="text" class="pickbox" style="width: 75px" id="endDate" value=""/>&nbsp;
            <img src="Images/cal.gif" alt="To Date" width="16" align="absmiddle" height="16" style="cursor:hand" onClick="calSet(endDate)"></td>
        </tr>
        <tr>
            <td valign="top" class="personalDetails">Notes:</td>
            <td><textarea name="txtNotes" class="pickbox" cols="20" rows="5" id="txtNotes" style="width: 280px"></textarea></td>
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
	for(var i = 0; i < document.frmUnits.elements.length; i++)
	{
		currentValue=document.frmUnits.elements[i].value;
		if(document.frmUnits.elements[i].checked==true)
		{
			if(stringToCheck.indexOf(currentValue)<0)
			{
				newattached = newattached + "," + document.frmUnits.elements[i].value;
			}
		}
	}
    document.frmDetails.newattached.value = newattached + document.frmDetails.currentlyChecked.value;
	
	if(document.frmDetails.newattached.value=="start")
	{
	    alert("Select at least one unit")
	    return;	  		
    }
	
	yesBox=confirm("Are you sure you want to remove checked unit(s)?");
	
	if (yesBox==true)
	{
		//alert(newattached)
		saveNew();
	}
}

function saveNew()
{
    document.frmDetails.action="RemoveTaskUnit.asp";
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
	document.forms["frmDetails"].submit();
}

function checkDelete(){
     var delOK = false 
    
	  input_box = confirm("Are you sure you want to delete this Record ?")
	  if(input_box==true) {
		    delOK = true;
	    }
    return delOK;
}

function Update()
{
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
	    alert("Select Personnel to update")
	    return;	  		
    } 

	var t = (document.documentElement.clientHeight - 350) / 2;
	var l = (document.documentElement.clientWidth - 400) / 2;
	
	grayOut(true,{'bgcolor':'#0066FF','opacity':'40'},'update',t,l)
//	alert(document.frmDetails.newattached.value)
}

function UpdatePersonnel()
{
	alert(document.frmDetails.newattached.value)	
}

function btnClose_onClick()
{
	grayOut(false,'','update');
	document.getElementById('startDate').value = "";
	document.getElementById('endDate').value = "";
	document.getElementById('txtNotes').value = "";
}

</Script>
