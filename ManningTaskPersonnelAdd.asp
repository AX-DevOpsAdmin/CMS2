<!DOCTYPE HTML >

<!--#include file="Includes/security.inc"--> 
<!--#include file="Connection/Connection.inc"-->

<%
' sets date to UK format - dmy
session.lcid=2057

dim strAction
dim strFrom
dim strGoTo
dim strOOA
dim strtoday

strtoday=Date()
strAction="Update"

set objCmd = server.CreateObject("ADODB.Command")
set objPara = server.CreateObject("ADODB.Parameter")
objCmd.ActiveConnection = con
objCmd.Activeconnection.cursorlocation = 3

'now get the maximum Out of Area days allowed before a flag is raised for Harmony Guidelines
objCmd.CommandText = "spGetHarmonyLimits"	'Name of Stored Procedure'
set rsOOA = objCmd.Execute	'Execute CommandText when using "ADODB.Command" object'

strooared =rsOOA("ooared")
strssared =rsOOA("ssared")
strssbred =rsOOA("ssbred")
strooaamber =rsOOA("ooaamber")
strssaamber =rsOOA("ssaamber")
strssbamber =rsOOA("ssbamber")

set objPara = objCmd.CreateParameter ("nodeID",3,1,0, nodeID)
objCmd.Parameters.Append objPara

' Get the Team List
objCmd.CommandText = "spListHierarchyDropDown"
objCmd.CommandType = 4		
set rsHrcList = objCmd.Execute

' Get the Q List
strTable = "tblQs"
strCommand = "spListQs"
objCmd.CommandText = strCommand
objCmd.CommandType = 4		
set rsQs = objCmd.Execute	'Execute CommandText when using "ADODB.Command" object

	for x = 1 to objCmd.parameters.count
		objCmd.parameters.delete(0)
	next

set objPara = objCmd.CreateParameter ("TaskID",3,1,5, request("RecID"))
objCmd.Parameters.Append objPara
objCmd.CommandText = "sp_TaskDetail"	'Name of Stored Procedure'
set rsRecSet = objCmd.Execute	'Execute CommandText when using "ADODB.Command" object'

' This for Out of Area/Bed Night Away Tasks 
strOOA = rsRecSet("ooa")
 
' RAFP - If its HQTASK (RAFP log-on ) and OOA then prompt for Task Slot
if rsRecSet("HQTask") = true and strOOA = 1 then
	strSlot = 1
else
	strSlot = 0
end if    
 
if request("newdays") <> "" then
	strnewdays = request("newdays")
else
	strnewdays=0
end if   
 
if request("page") <>"" then
	page = int(request("page"))
else
	page = 1
end if

strDoSearch = request("doSearch")

if strDoSearch = "" then
	strDoSearch = 0
end if
 
if strDoSearch = 1 then
	surname = replace(request("surName"),"'","''")
	firstname = replace(request("firstName"),"'","''")
	serviceno = replace(request("ServiceNo"),"'","''")
	'taskID = request("RecID")
	hrcID = request("hrcID")
	q1 = request("Q1")
	q2 = request("Q2")
	q3 = request("Q3")

	for x = 1 to objCmd.parameters.count
		objCmd.parameters.delete(0)
	next
'response.write("A Page is " & page)
	
	strCommand = "spPersonnelToTaskSearchResults"
	objCmd.CommandText = strCommand
	objCmd.CommandType = 4		
	set objPara = objCmd.CreateParameter ("nodeID",3,1,0, nodeID)
    objCmd.Parameters.Append objPara
	set objPara = objCmd.CreateParameter ("surname",200,1,50, surname)
	objCmd.Parameters.Append objPara
	set objPara = objCmd.CreateParameter ("firstname",200,1,50, firstname)
	objCmd.Parameters.Append objPara
	set objPara = objCmd.CreateParameter ("serviceno",200,1,50, serviceno)
	objCmd.Parameters.Append objPara
	'set objPara = objCmd.CreateParameter ("TaskID",3,1,0, taskID)
	'objCmd.Parameters.Append objPara
	set objPara = objCmd.CreateParameter ("hrcID",3,1,0, hrcID)
	objCmd.Parameters.Append objPara
	set objPara = objCmd.CreateParameter ("Q1",3,1,0, q1)
	objCmd.Parameters.Append objPara
	set objPara = objCmd.CreateParameter ("Q2",3,1,0, q2)
	objCmd.Parameters.Append objPara
	set objPara = objCmd.CreateParameter ("Q3",3,1,0, q3)
	objCmd.Parameters.Append objPara
	set rsSearchResults = objCmd.Execute
	
	if request("page")<>"" then
		page = int(request("page"))
	else
		page = 1
	end if
	
'	response.write("B Page is " & page)

	recordsPerPage = 16	
	num = rsSearchResults.recordcount
	startRecord = (recordsPerPage * page) - recordsPerPage
	totalPages = (int(num/recordsPerPage))
	
	if int(num - (recordsPerPage * totalPages)) > 0 then totalPages=totalPages+1
	if page = totalPages then recordsPerPage = int(num - startRecord)
	if rsSearchResults.recordcount>0 then rsSearchResults.move(startRecord)
	
	beginAtPage=1
	increaseAfter = 6
	startEndDifference = 9
	
	if page - increaseAfter > 1 then 
		beginAtPage = page - increaseAfter
	end if
	
	if totalPages < beginAtPage + startEndDifference then
		beginAtPage = totalPages - startEndDifference
	end if
	
	endAtPage = beginAtPage + startEndDifference
	if beginAtPage < 1 then beginAtPage = 1

	checkedPosts = request("currentlyChecked")
	
	'response.write("C Page is " & page)
	
	if checkedPosts <> "" then 
		strCheckedPosts = split(checkedPosts, ",")
		'response.write strCheckedPosts(1) & " ** "
		whereString=" serviceno='" & strCheckedPosts(1) & "'"
		if ubound(strCheckedPosts) > 1 then
			for intCount = 2 to (ubound(strCheckedPosts))
				if strCheckedPosts(intCount) <> "" then whereString = whereString + " or serviceno='" & strCheckedPosts(intCount) & "'"
			next
		end if
		
		' delete existing parameters
		for x = 1 to objCmd.parameters.count
		  objCmd.parameters.delete(0)
		next
		
		set objPara = objCmd.CreateParameter ("whereclause",200,1,500, whereString)
		objCmd.Parameters.Append objPara
		
		'objCmd.CommandType = 1
		objCmd.CommandText = "spGetSelectedStaff"
		set testRS = objCmd.Execute
		
		'response.write("D Page is " & page)
	
	end if
else
	surname = ""
	firstname = ""
	serviceno = ""
	'taskID = 0
	hrcID = 0
	q1 = 0
	q2 = 0
	q3 = 0
end if


function convertDate (oldDate)
	todayDate = formatdatetime(oldDate,2)
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
	
	newDate= splitDate(0) + " " + theMonth + " " + splitDate(2) 
	response.write newDate
end function

for x = 1 to objCmd.parameters.count
	objCmd.parameters.delete(0)
next

%>	
	
<html>
<head> 

	<!--#include file="Includes/IECompatability.inc"--> 
    
    <title><%=pageTitle%></title>
    <link rel="stylesheet" type="text/css" href="Includes/AMDB.css" media="Screen"/>
    <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
    
    <style type="text/css">
    
        body {
            background-image: url();
            margin-left: 0px;
            margin-top: 0px;
            margin-right: 0px;
            margin-bottom: 0px;
        }
        .style2 {color: #FFFFFF}
        .style3 {color: #FF0000}
    
    </style>

</head>
<body onLoad="chk();" onResize="chk();">

   
<table height="100%" cellspacing="0" cellPadding="0" width="100%" border="0">
    <tr>
        <td>   
        
        
        	<!--#include file="Includes/Header.inc"-->
            <table cellSpacing="0" cellPadding="0" width="100%" border="0" >
                <tr style="font-size:10pt;" height="26px">
                    <td width="10px">&nbsp;</td>
                    <td><a title="" href="index.asp" class="itemfontlinksmall" >Home</A> > <A title="" href="ManningTaskSearch.asp" class="itemfontlinksmall" >Tasking</A> > <A title="" href="ManningTaskSearch.asp" class="itemfontlinksmall" >Task</A> > <A title="" href="ManningTaskPersonnel.asp?RecID=<%=request("RecID")%>" class="itemfontlinksmall">Tasked Personnel</a> > <font class="youAreHere" >Add Personnel</font></td>
                </tr>
                <tr>
                    <td colspan="2" class="titlearealine"  height="1"></td> 
                </tr>
            </table>
            <!-- START CONTAINER -->
            <table id="mainArea" style="height:900px;" width="100%" border="0" cellpadding="0" cellspacing="0" > 
            	<tr valign="Top">
                	<!-- START SIDE MENU -->
                    <td class="sidemenuwidth" background="Images/tableback.png" >
                        <table width="100%" border="0" cellpadding="0" cellspacing="0" class="MenuStyleParent">
                            <tr height="22">
                                <td width="10">&nbsp;</td>
                                <td colspan="3" align="left" height="22">Current Location <%=session("heightIs")%></td>
                            </tr>
                            <tr height="22">
                                <td>&nbsp;</td>
                                <td width="18" valign="top"><img src="images/arrow.gif"></td>
                                <td width="170" align="Left"  ><A title="" href="index.asp">Home</A></td>
                                <td width="50" align="Left"></td>
                            </tr>
                            <tr height="22">
                                <td>&nbsp;</td>
                                <td valign="top"><img src="images/arrow.gif"></td>
                                <td align="Left"><a title="" href="ManningTaskSearch.asp?dosearch=1&task=&ttID=1&startdate=&endDate=">Tasking</a></td>
                                <td align="Left"></td>
                            </tr>
                            <tr height="22">
                                <td>&nbsp;</td>
                                <td valign="top"><img src="images/arrow.gif"></td>
                                <td align="Left"><A title="" href="ManningTask.asp?RecID=<%=request("RecID")%>">Task</a></td>
                                <td align="Left">&nbsp;</td>
                            </tr>
                            <tr height=22>
                              <td>&nbsp;</td>
                              <td valign="top"><img src="images/arrow.gif"></td>
                              <td align="Left"><a href="ManningTaskPersonnel.asp?RecID=<%=request("RecID")%>">Tasked Personnel</a></td>
                              <td class="rightmenuspace" align="Left" ></td>
                            </tr>
                            <tr height="22">
                              <td>&nbsp;</td>
                              <td valign="top"><img src="images/vnavicon.gif"></td>
                              <td align="Left" bgcolor="#FFFFFF"><Div style="height:18px; border:Solid; width:16em; border-width:1px; border-color:#438BE4; color: #003399;">Add Personnel</Div></td>
                              <td class="rightmenuspace" align="Left" ></td>
                            </tr>
                        </table>
                    </td>
                    <!-- END SIDE MENU -->
                    <!-- START GAP -->
                    <td width="16"></td>
                    <!-- END GAP -->
                    <!-- START MAIN CONTENT -->
                    <td align="left">
                        <table border="0" cellpadding="0" cellspacing="0" width="100%" >
                        	
                            <!-- START OPTIONS -->
                         	<tr height="16" class="SectionHeader">
                                <td colspan="2">
                                    <table border="0" cellpadding="0" cellspacing="0" >
                                        <td height="25" width="20"><img src="images/editgrid.gif" width="17" class="imagelink" id="SaveCloseLink" onclick="saveNew();"></td>
                                        <td height="25" class="toolbar" valign="middle">Save and Close</td>
                                        <td class="titleseparator" valign="middle" width="14" align="center">|</td>
                                        <td height="25" class="toolbar" valign="middle"><A class=itemfontlink href="ManningTaskPersonnel.asp?RecID=<%=request("recID")%>">Back</A></td>
                                    </table>
                                </td>
                            </tr>
                        
                        	<!-- END OPTIONS -->
                            
                            <!-- START TASK DETAILS -->
                            
                            <form action="" method="post" name="frmDetails">
                            <Input name="RecID" id="RecID"  type="hidden" value="<%=request("RecID")%>">
                            <input name="newattached" id="newattached" type="hidden" value="">
                            <input name="ReturnTo" id="ReturnTo" type="hidden"  value="ManningTaskPersonnel.asp">
                            <Input name="DoSearch" id="DoSearch" type="hidden" value="<%=strDoSearch%>">
                            <Input name="Page" id="Page" type="hidden" value="1">
                            <Input name="HiddenDate" id="HiddenDate" type="hidden" >
                            <input name="currentlyChecked" id="currentlyChecked"  type="hidden" value="<%=request("currentlyChecked")%>">
                            <input name="criteriaChange" id="criteriaChange" type="hidden" value="0">
                            <input name="ooatask" id="ooatask" type="hidden" value="<%=strOOA%>">
                            <input name="maxdays" id="maxdays" type="hidden" value="<%=strmaxdays%>">
                            <input name="ambdays" id="ambdays" type="hidden" value="<%=strambdays%>">
                            <input name="ooared" id="ooared" type="hidden" value="<%=strooared%>">
                            <input name="ooaamb" id="ooaamb" type="hidden" value="<%=strooaamber%>">
                            <input name="ssared" id="ssared" type="hidden" value="<%=strssared%>">
                            <input name="ssaamb" id="ssaamb" type="hidden" value="<%=strssaamber%>">
                            <input name="ssbred" id="ssbred" type="hidden" value="<%=strssbred%>">
                            <input name="ssbamb" id="ssbamb" type="hidden" value="<%=strssbamber%>">
                            <input name="newdays" id="newdays" type="hidden" value="<%=strnewdays%>">
                            <input name="curdate" id="curdate" type="hidden" value="<%=strtoday%>">
                            <Input name="toTaskList" id="toTaskList" type="hidden" value="">
                            <tr>
                                <td colspan="2">
                                    <table width="100%" border="0" cellpadding="0" cellspacing="0">
                                		<tr height="16">
                                        	<td colspan="4">&nbsp;</td>
                                      	</tr>
                                      	<tr class="columnheading">
                                        	<td height="22" valign="middle" width="2%">&nbsp;</td>
                                        	<td height="22" valign="middle" width="13%">Task<span class="style2">:</span></td>
                                        	<td height="22" valign="middle" width="30%" class="itemfont"><%=rsRecSet("Task")%></td>
                                        	<td rowspan="4">
                                        		<table width="100%" border="0" cellpadding="0" cellspacing="0">
                                	    			<tr>
                                	        			<td width="245" class="columnheading"><span style="color:#F00;font-weight: bold;font-size:12px">NOTES: Enter Task Details Here</span></td>
                              	        			</tr>
                                	    			<tr>
                                	    				<td><textarea cols="20" rows="5" name="notes" id="notes" class="itemfont" style="width:210px;"><%=request("notes")%></textarea></td>
                              	        			</tr>
                              	      			</table>
                                        	</td>
                                      	</tr>
                                      	<tr class="columnheading">
                                        	<td height="22" valign="middle" width="2%"></td>
                                        	<td height="22" valign="middle">Task Type:</td>
                                        	<td height="22" valign="middle" class="itemfont" ><%=rsRecSet("Type")%></td>
                                      	</tr>
                                      	<tr class="columnheading">
                                        	<td height="22" valign="middle" width="2%"></td>
                                        	<td height="22" valign="middle">Cancellable:</td>
                                        	<td height="22" class="itemfont">
												<% if rsRecSet("cancellable") = true then %>
                                        			Yes
                                        		<% else %>
                                        			No
                                        		<% end if %>
											</td>
                                    	</tr>
                                    	<tr class="columnheading">
                                        	<td height="22" valign="middle" width="2%"></td>
                                        	<td height="22" valign="middle">Specify Dates:</td>
                                        	<td height="22" valign="middle" class="itemfont">
                                            	<table border="0" cellpadding="0" cellspacing="0" >
                                        			<tr>
                                            			<td valign="top">
                                                        	<input name="startDate" type="text" id="startDate" class="itemfont"  style="Width:75px;"  value ="<%=request("startDate")%>" readonly  onClick="getStart(this)">
                                            				&nbsp;<img src="images/cal.gif" alt="Calender" align="absmiddle" onClick="getStart(startDate)" style="cursor:hand;">
														</td>
                                            			<td width="10px"></td>
                                            			<td valign="top">
                                                        	<input name="endDate" type="text" id="endDate" class="itemfont"  style="Width:75px;"  value ="<%=request("endDate")%>" readonly onClick="calSet(this)">
															&nbsp;<img src="images/cal.gif" alt="Calender" align="absmiddle" onClick="calSet(endDate)" style="cursor:hand;">
														</td>
                                        			</tr>
                                        		</table>
											</td>
                                    	</tr>
                                    	<tr height="16">
                                        	<td colspan="4">&nbsp;</td>
                                      	</tr>
                                      	<tr>
                                        	<td colspan="4" class="titlearealine"  height="1"></td>
                                      	</tr>
                      				</table>
								</td>
							</tr>
                        	<!-- END TASK DETAILS -->
                            
                            <!-- START PERSONNEL SEARCH FORM -->
                        	<tr height="16" class="SectionHeader">
								<td colspan="2">
									<table width="100%" border=0 cellpadding=0 cellspacing=0>
                                    	<tr>
                                        	<td height="25" align="left">
                                                <table width="100%" border="0" cellpadding="0" cellspacing="0">
                                                	<tr>
                                                    	<td height="25" width="2%">&nbsp;</td>
                                                    	<td height="25" width="52%" align="left" class="toolbar">Personnel to Task</td>
                                                        <td height="25" width="12%"><a class=itemfontlink href="javascript:<%if request("doSearch")=1 then%>MovetoPage(1)<%else%>setSearch()<%end if%>;"><img class="imagelink" src="images/icongo01.gif"></a></td>
                                                        <td height="25" width="34%" valign="middle" class="toolbar">Find</td>
                                                    </tr>
                                                </table>
                                            </td>
                                            <td height="25"><span class="toolbar style3">To narrow the search enter any combination of Personnel/Team details and up to 3 General Qualifications</span></td>
                                        </tr>
									</table>
							  	</td>
							</tr>
                            
                            <tr>
                            	<td colspan="2">
                                	<table width="100%" border="0" cellpadding="0" cellspacing="0">
                                        <tr height="16">
                                            <td></td>
                                        </tr>
                                        <tr class="searchheading" height="22">
                                            <td valign="middle" width="2%"></td>
                                            <td align="right">Surname:</td>
                                            <td valign="middle"><input onChange="javascript:document.frmDetails.criteriaChange.value=0;" class="itemfont" style="WIDTH: 100px" maxLength="20" name="surname" id="surname" value="<%=request("surname")%>"></td>
                                            <td valign="middle" width=""></td>
                                            <td align="right">Firstname:</td>
                                            <td valign="middle"><input onChange="javascript:document.frmDetails.criteriaChange.value=0;" class="itemfont" style="WIDTH: 100px" maxlength="20" name=firstname id="firstname" value="<%=request("firstname")%>"></td>
                                            <td valign="middle" width=></td>
                                            <td align="right">Service No:</td>
                                            <td valign="middle"><input onChange="javascript:document.frmDetails.criteriaChange.value=0;" class="itemfont" style="WIDTH: 70px" maxLength=20 name="serviceno" id="serviceno" value="<%=request("serviceno")%>">														</td>
                                            <td valign="middle"></td>
                                            <td align="right">Select Unit:</td>
                                            <td align="left" class="subHeading">
                                                <select name="hrcID" id="hrcID" class="pickbox" style="width:120px;" >
                                                    <option value="0" selected>All</option>
                                                    <% do while not rsHrcList.eof %>
                                                        <option value="<%=rsHrcList("hrcID")%>" <% if cint(request("hrcID")) = cint(rsHrcList("hrcID")) then %> selected <% end if %>><%= rsHrcList("hrcname") %></option>
                                                        <% rsHrcList.movenext %>
                                                    <% loop %>
                                                </select>
                                            </td>
                                            <td valign="middle" ></td>
                                            <td valign="middle" ></td>
                                        </tr>
                                        <tr>
                                        	<td colspan="14" height="3px"></td>
                                        </tr>
                                        <tr class="searchheading" height="22">
                                            <td valign="middle" width="2%"></td>
                                            <td align="right">Q1:</td>
                                            <td valign="middle">
                                                <select name="Q1" id="Q1" class="pickbox" style="width:120px;" >
                                                    <option value="0" selected></option>
                                                    <% do while not rsQs.eof %>
                                                        <option value="<%=rsQs("QID")%>" <% if cint(request("Q1")) = cint(rsQs("QID")) then %> selected <% end if %>><%= rsQs("description") %></option>
                                                        <% rsQs.movenext %>
                                                    <% loop %>
                                                </select>
                                            </td>
                                            <td valign="middle" width=""></td>
                                            <td align="right">Q2:</td>
                                            <td valign="middle" >
                                                <select name="Q2" id="Q2" class="pickbox" style="width:120px;" >
                                                    <option value="0" selected></option>
                                                    <% rsQs.movefirst %>
                                                    <% do while not rsQs.eof %>
                                                        <option value="<%=rsQs("QID")%>" <% if cint(request("Q2")) = cint(rsQs("QID")) then %> selected <% end if %>><%= rsQs("description") %></option>
                                                        <% rsQs.movenext %>
                                                    <% loop %>
                                                </select>													  
                                            <td valign="middle" width=""></td>
                                            <td align="right">Q3:</td>
                                            <td valign="middle">
                                                <select name="Q3" id="Q3" class="pickbox" style="width:120px;" >
                                                    <option value="0" selected></option>
                                                    <% rsQs.movefirst %>
                                                    <% do while not rsQs.eof %>
                                                        <option value="<%=rsQs("QID")%>" <% if cint(request("Q3")) = cint(rsQs("QID")) then %> selected <% end if %>><%= rsQs("description") %></option>
                                                        <% rsQs.movenext %>
                                                    <% loop %>
                                                </select>
                                            </td>
                                            <td valign="middle" ></td>
                                        </tr>
                                        <tr colspan="8" height="16">
                                            <td></td>
                                        </tr>
                                    </table>
                            	</td>
                            </tr>
                            
                            </form>
                            
                        	<!-- END  PERSONNEL SEARCH FORM -->
                            
                            <!-- START PERSONNEL SEARCH RESULTS -->
                            <form  action="" method="post" name="frmPosts">
                            <tr>
                            	<td width="60%">
                                    <table width="98%" border="0" cellpadding="0" cellspacing="0">
                                        <tr class="itemfont" height="20">
                                            <td valign="middle" width="2%"></td>
                                            <td colspan="4" valign="middle" >Search Results: <%if isObject(rsSearchResults) then%><Font class=searchheading>records found: <%=rsSearchResults.recordcount%><%end if%></Font>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td colspan="6" class="titlearealine"  height="1"></td> 
                                        </tr>
                                        <tr class="columnheading">
                                            <td width="2%" height="22" valign="middle">&nbsp;</td>
                                            <td width="33%" height="22" valign="middle">Surname</td>
                                            <td width="33%" height="22" valign="middle">Firstname</td>
                                            <td width="12%" height="22" valign="middle">Service No</td>
                                            <td width="12%" height="22" valign="middle">Last OOA</td>
                                            <td width="8%" valign="middle" align="center">Select</td>
                                        </tr>
                                        <tr>
                                            <td colspan="6" class="titlearealine"  height="1"></td> 
                                        </tr>
                                        <% if isObject(rsSearchResults) then 
                                        
                                        if rsSearchResults.recordcount > 0 then
                                        
                                        Row = 0 
                                        do while Row < recordsPerPage %>
                                        <tr id="TableRow<%=Row%>" class="toolbar">
                                            <td width="2%" height="22" valign="middle">&nbsp;</td>
                                            <td width="33%" height="22" valign="middle"><%=rsSearchResults("surname")%></td>
                                            <td width="33%" height="22" valign="middle"><%=rsSearchResults("firstname")%></td>
                                            <td width="12%" height="22" valign="middle"><%=rsSearchResults("serviceno")%></td>
                                            <td width="12%" height="22" valign="middle"><%=rsSearchResults("lastOOA")%></td>
                                            <td width="8%" height="22" valign="middle" align="center">
                                                <input type="checkbox" name="StaffID<%=rsSearchResults("staffID")%>" id="StaffID<%=rsSearchResults("staffID")%>"  value="<%=rsSearchResults("serviceno")%>" <%if Instr(request("currentlyChecked"), rsSearchResults("serviceno") ) >0 then response.write(" checked")%> onclick="javascript:addRemovePost(this.checked,'<%=replace(rsSearchResults("surname"), "'","")%>','<%=rsSearchResults("staffID")%>','<%=rsSearchResults("serviceNo")%>','<%=rsSearchResults("ooadays")%>','<%=rsSearchResults("ssadays")%>','<%=rsSearchResults("ssbdays")%>','<%=rsSearchResults("startReset")%>','<%=strtoday%>','<%=strslot%>');">
                                                
                                                
                                            </td> 
                                            
                                                                         									
                                        </tr>
                                        <tr>
                                            <td colspan="6" class="titlearealine"  height="1"></td> 
                                        </tr>
                                        <% row = row + 1 
                                        rsSearchResults.movenext
                                        loop %>
                                        <tr height="22px">
                                            <td colspan="6"></td>
                                        </tr>
                                        <tr align="center">
                                            <td colspan="6">
                                                <table border="0" cellpadding="0" cellspacing="0">
                                                    <tr>
                                                        <td class="itemfont" height="22">Results Pages: &nbsp;</td>
                                                        <td class="ItemLink" height="22">
                                                            <% if int(page) > 1 then %>
                                                            <a id="previousButton" href="javascript:MovetoPage(<%=page-1%>);" class="ItemLink" /> &lt;&lt; Previous </a>
                                                            <% else %> 
                                                            &lt;&lt; Previous 
                                                            <% end if %> 
                                                        
                                                        </td>
                                                        <td class="itemfont" height="22">&nbsp;&nbsp;</td>
                                                        <% pagenumber = beginAtPage %>
                                                        <% do while pagenumber <= endAtPage %>
                                                        <td>
                                                            <a class="<% if page <> pagenumber then %>ItemLink<% else %>itemfontbold<% end if %>" href="javascript:MovetoPage(<%= pagenumber %>);"><%= Pagenumber %></a>
                                                            <%if pagenumber < (endAtPage) then%>
                                                            <font class="itemfont">,</font>
                                                            <%end if%>
                                                        </td>
                                                        <% pageNumber = pageNumber + 1
                                                        loop %>
                                                        <td class="itemfont" height="22">&nbsp;&nbsp;</td>
                                                        <td class="ItemLink" height="22">
                                                        <% if int(page) < int(endAtPage) then %>
                                                            <a id="nextButton" href="javascript:MovetoPage(<%= page + 1 %>);" class="ItemLink">Next >></a>
                                                        <% else %>
                                                            Next >>
                                                        <% end if %>
                                                        </td>
                                                    </tr>
                                                </table>
                                            </td>
                                        </tr>
                                        <% else %>
                                        <tr class="itemfont"  height="22">
                                            <td valign="middle" width="2%">&nbsp;</td>
                                            <td align="center" valign="middle" colspan="5">Your search returned no results</td>
                                        </tr>
                                        <tr>
                                            <td colspan="6" class="titlearealine"  height="1"></td> 
                                        </tr>
                                        <%end if%>
                                        <%else%>
                                        <tr class="itemfont" height="22">
                                            <td valign="middle" width="2%"></td>
                                            <td align="center" valign="middle" colspan="5" >Your search returned no results</td>
                                        </tr>
                                        <tr>
                                            <td colspan="6" class="titlearealine"  height="1"></td> 
                                        </tr>
                                        <%end if%>
                                    </table>
                                </td>
                                <td width="40%">
                                    <table id="checkedPostsTable" align="center" border="0" cellpadding="0" cellspacing="0" width="98%">
                                        <tr>
                                        	<td align="center" height="22" colspan="9" class="itemfont">Currently Selected Persons:</td>
                                        </tr>
                                        <tr>
                                        	<td  class="titlearealine" height="1" colspan="9"></td>
                                        </tr>
                                        <tr  class="columnheading" >
                                            <td width="1%"></td>
                                            <td valign="middle" width="14%">Surname</td>
                                            <td width="8%" valign="middle" >Service No</td>
                                            <% if strOOA <> 0 then 
                                            strhs = "Harmony Status"
                                            else
                                            strhs=""
                                            end if %>
                                            <td width="9%" colspan="3" align="center"   valign="middle" ><%=strhs%></td>
                                        </tr>
                                        <tr height="20"  class="columnheading" >
                                            <td width="1%"></td>
                                            <td valign="middle" width="14%"></td>
                                            <td width="8%" valign="middle" ></td>
                                            <% if strOOA = 1 then%>
                                            <td width="3%">OOA</td>
                                            <td width="3%">SSA</td>
                                            <td width="3%">SSB</td>
                                            <% elseif strOOA = 2 then%>
                                            <td width="3%">SSA</td>
                                            <td width="3%">SSB</td>
                                            <td width="3%"></td>
                                            <%else%>
                                            <td width="9%" colspan="3"></td>
                                            <%end if %>
                                        </tr>
                                        <tr>
                                        	<td  class="titlearealine"  height="1" colspan="9"></td>
                                        </tr>
                                        <%if isObject(testRS) then%>
                                        <%do while not testRS.eof%>									    
                                        <tr id="<%=testRS("staffid")%>" height="20"  class="toolbar" >
                                            <td width="1%"></td>
                                            <td valign="middle" width="10%"><%=testRS("surname")%></td>
                                            <td width="12%" valign="middle" ><%=testRS("serviceno")%>/<%=testRS("staffID")%></td>
                                            <% ' first check if its out of area task
                                            
                                            strooadays=0
                                            strssadays=0
                                            strssbdays=0
                                            strtdID = testRS("serviceno")&"ooa" 
                                            if strOOA <> 0 then 
                                            strooadays=testRS("ooadays")
                                            strssadays=testRS("ssadays")
                                            strssbdays=testRS("ssbdays")
                                            if strOOA = 1 then   ' its Out of Area
                                            
                                            if (strooadays >= rsOOA("ooared")) then
                                            strooabg="#FF0000"
                                            elseif (strooadays >= rsOOA("ooaamber")) then
                                            strooabg="#FFCC33"
                                            else
                                            strooabg="#eeeeee"
                                            end if
                                            
                                            if (strssadays >= rsOOA("ssared")) then
                                            strssabg="#FF0000"
                                            elseif (strssadays >= rsOOA("ssaamber")) then
                                            strssabg="#FFCC33"
                                            else
                                            strssabg="#eeeeee"
                                            end if
                                            
                                            if (strssbdays >= rsOOA("ssbred")) then
                                            strssbbg="#FF0000"
                                            elseif (strssbdays >= rsOOA("ssbamber")) then
                                            strssbbg="#FFCC33"
                                            else
                                            strssbbg="#eeeeee"
                                            end if %>
                                            <td bgcolor="<%=strooabg%>" align="center"><%=strooadays%></td>
                                            <td bgcolor="<%=strssabg%>" align="center"><%=strssadays%></td>
                                            <td bgcolor="<%=strssbbg%>" align="center"><%=strssbdays%></td>
                                            <%end if %>
                                            <% if strOOA = 2 then   ' its Bed Night Away
                                            
                                            if (strssadays >= rsOOA("ssared")) then
                                            strssabg="#FF0000"
                                            elseif (strssadays >= rsOOA("ssaamber")) then
                                            strssabg="#FFCC33"
                                            else
                                            strssabg="#eeeeee"
                                            end if
                                            
                                            if (strssbdays >= rsOOA("ssbred")) then
                                            strssbbg="#FF0000"
                                            elseif (strssbdays >= rsOOA("ssbamber")) then
                                            strssbbg="#FFCC33"
                                            else
                                            strssbbg="#eeeeee"
                                            end if %>
                                            <td bgcolor="<%=strssabg%>" align="center"><%=strssadays%></td>
                                            <td bgcolor="<%=strssbbg%>" align="center"><%=strssbdays%></td>
                                            <td></td>
                                            <%end if %>
                                            <%end if%>
                                        </tr>
                                        <tr>
                                        	<td colspan="6" class="titlearealine"  height="1"></td>
                                        </tr>
                                        <%testRS.movenext%>
                                        <%loop%>
                                        <%end if%>
                                    </table>
                            	</td>
                            </tr>
                            </form>
                            <!-- END  PERSONNEL SEARCH RESULTS -->
                            
                    	</table>
                    </td>
                    <!-- END MAIN CONTENT -->
            	</tr>
            </table>
            <!-- END CONTAINER -->
            
        
        </td>
    </tr>
</table>


<script type="text/javascript" src="calendar.js"></script>

<script language="javascript">

function InsertCalenderDate(Calender,SelectedDate)
{
	var stDate = document.all.startDate.value
	var enDate = document.all.endDate.value
	
	var intSTDate = parseInt(stDate.split("/")[2] + stDate.split("/")[1] + stDate.split("/")[0])
	var intENDate = parseInt(enDate.split("/")[2] + enDate.split("/")[1] + enDate.split("/")[0])

	var startDate = new Date
	var endDate = new Date
	var tDate= new Date

	var stDays = startDate.getTime();
	var enDays = endDate.getTime();
	var numdays = 0;
	
	var dsr = document.frmDetails.DoSearch.value
	
	startDate = dateConv(document.all.startDate.value);
	endDate = dateConv(document.all.endDate.value);
	tDate = dateConv(Calender);

	dateOK=1
	str=Calender
	
	document.forms["frmDetails"].elements["HiddenDate"].value = str
	whole = document.forms["frmDetails"].elements["HiddenDate"].value
	day = document.forms["frmDetails"].elements["HiddenDate"].value.substring (8,10)
	day.replace (" ","")
	month = document.forms["frmDetails"].elements["HiddenDate"].value.substring (4,7)
	month.replace (" ","")
	strlength = document.forms["frmDetails"].elements["HiddenDate"].value.length
	year = document.forms["frmDetails"].elements["HiddenDate"].value.substring (strlength-4,strlength)
	
	if (day < 10)
	{
		day = "0" + day
	}
	
	if (day >= 10)
	{
		day = day + " "
	}
	
	var convertedDate = new Date((day + month + " " + year ))
	var todayDate = new Date()
	todayDate.getDate()

    // Now see if we input both days then find the number of days between them
	var oneday=1000*60*60*24     // one day in miliseconds
	
	if (SelectedDate == document.all.startDate.id)
	{
		if(!document.all.endDate.value=="")
		{
			if(intENDate < intSTDate)
			{
				alert("Start date can not be later than end date")
				document.all.startDate.value="";
				document.all.startDate.focus;
				dateOK=0;
				return;
			}
			
			if(dateOK == 1)
			{
				numdays = Math.ceil((endDate.getTime() - tDate.getTime())/(oneday))
			}  
		}
	}
	
	if(SelectedDate == document.all.endDate.id)
	{
		if(!document.all.startDate.value == "")
		{
			if(intENDate < intSTDate)
			{
				alert("End date can not be earlier than start date")
				document.all.endDate.value="";
				document.all.endDate.focus;
				dateOK=0;
				return;
			}
			
			if(dateOK==1)
			{
				numdays=Math.ceil((tDate.getTime()-startDate.getTime())/(oneday))
			}
		} 
	}
	
	if(dateOK == 1)
	{
		SelectedDate.value = day + month + " " + year
	}
	
	//here we have the total days for the new task - so store them and add to any currently selected - but we will need to subtract any already added so make sure we store them
	if(!numdays == 0)
	{
		document.frmDetails.newdays.value = numdays

		if(dsr == 1)
		{
	    	if(document.frmDetails.DoSearch.value == 1)
			{
				MovetoPage(1)
			}
			else
			{
				document.frmDetails.submit();
			}	
		}
	}
}
	
function dateConv(dteVar)
{
	var dteVal= new Date;	
	var dteVarStr = dteVar.split("/");
	
	dteVal.setDate(dteVarStr[0]);
	dteVal.setMonth(dteVarStr[1]-1);
	dteVal.setFullYear(dteVarStr[2]);
	
	return (dteVal);
}

function dateSplit(dteVal,dteVar)
{
	var dteVarStr = dteVar.split("/");
	
	dteVal.setDate(dteVarStr[0]);
	dteVal.setMonth(dteVarStr[1]-1);
	dteVal.setFullYear(dteVarStr[2]);
	
	return (dteVar);
}

function CalenderScript(CalImg)
{
	CalImg.style.visibility = "Visible";
}

function CloseCalender(CalImg)
{
	CalImg.style.visibility = "Hidden";
}

</script>

<%

con.close
set con=Nothing
%>


<SCRIPT LANGUAGE="JavaScript">

function checkDates(srch){

 // make sure they have Start/End dates so we can add days
 if(document.frmDetails.startDate.value == "" && document.frmDetails.endDate.value == ""){
    alert (" You Must Enter Task Start/End Dates");
	return;
 }
 if (srch==1){
    MovetoPage(1)
  }	
 else {
   setSearch()
   }

}


function getStart(inputID){

  calSet(inputID);
  
 // starttime(5000);
  
  //alert ("timer out");
    
  //gsTimer()

     //document.frmDetails.startDate.onchange;
   //alert("date is now " + document.frmDetails.startDate.value);
   //InsertCalenderDate(document.frmDetails.startDate.value,document.frmDetails.startDate.value)
   

}

// to check Start date
function gsTimer()
{
  var stDate = (document.all.startDate.value);
  var chDate = (document.all.startDate.value);
  var tmo;
  //var enDate = new Date(document.all.endDate.value);

   // if date is complete then check days
  //alert("Start is " + stDate + " Check is " + chDate); 
  //chkDate(stDate);
  
  starttime(3000);
  //alert ("timer out");
  var i=1;
  while (stDate==chDate){	
     i++;
     //alert("Start is " + stDate + " Check is " + chDate + " * " + i);
     chDate = (document.all.startDate.value);
	 
	 //timer=setTimeout("starttime()",2000);
	 starttime(3000);
	 
	 
	 //if (i==10) break;
	 
   }	
   
   stoptimer() 
      
}

function starttime(millis){
  //alert ("timer in");
  var dt = new Date();
  while((new Date()) - dt <= millis) { /* do nothing - just pause */ }
  
}

function stoptimer(){

  //clearTimeout(timer);
  //alert ("timer stopped");
}



function MovetoPage (PageNo) {

if (document.frmDetails.criteriaChange.value==1){
	alert(PageNo);
	PageNo=1;
	}
	stringToCheck = document.frmDetails.currentlyChecked.value

    //alert("Move to Page " + PageNo);
	for (var i = 0; i < document.frmPosts.elements.length; i++){
		currentValue=document.frmPosts.elements[i].value;
		
		//alert("Move Page Value " + currentValue);
		
		if (document.frmPosts.elements[i].checked==true ) 
		{
			if (stringToCheck.indexOf(currentValue)<0)
			{
				
				stringToCheck = stringToCheck + "," + document.frmPosts.elements[i].value;
			}
		}
		else
		{
			if (stringToCheck.indexOf(currentValue)>=0)
			{
				
				stringToCheck=stringToCheck.replace(","+currentValue,"");
			}
		}
	}
   // alert("String to Check is " + stringToCheck);
	
	document.frmDetails.currentlyChecked.value = stringToCheck;
	document.forms["frmDetails"].elements["Page"].value = PageNo;
	document.forms["frmDetails"].submit();
}

function addRemovePost(checked,Post,staffID, thisRow,ooadays,ssadays,ssbdays,dsgDate,rsDate,curdate){
	
	
	    // addRemovePost(checked,surname,staffID,serviceNo,ooadays,ssadays,ssbdays,startReset,strtoday,strslot)
	//alert( "Checked Staff " + checked + " * " + Post + " * " + staffID + " * "  + thisRow + " * " + ooadays + " * " + ssadays + " * " + ssbdays + " * " + dsgDate + " * " + rsDate + " * " + curdate);

    var maxdays = document.frmDetails.ooared.value;
	var ambdays=  document.frmDetails.ooaamb.value;
	
	var ooamax = document.frmDetails.ooared.value;
	var ooaamb=  document.frmDetails.ooaamb.value;
    var ssamax = document.frmDetails.ssared.value;
	var ssaamb=  document.frmDetails.ssaamb.value;
    var ssbmax = document.frmDetails.ssbred.value;
	var ssbamb=  document.frmDetails.ssbamb.value;

	var newdays=  <%=strnewdays%>;
	var curdate= document.frmDetails.curdate.value;
	
	var cstr;
	
	//alert("OOA is " + document.frmDetails.ooatask.value);
	
	
	
	var dsg= new Date(dsgDate) ;
	var std = new Date(rsDate);
	var chkdate= new Date(curdate)
	
	

	// use these to store dates as numbers to compare against
	var dms;
	var sms;
	var tms;
	
	var cid=thisRow+"ooa";
	var numdays;
	var lastyear;
	
	//document.getElementById('checkedList').innerHTML = ajaxRequest.responseText;
	var oad=ooadays;
	if (oad==''){
	   oad = 0;
	}
	
	var sad=ssadays;
	if (sad==''){
	   sad = 0;
	}

	var sbd=ssbdays;
	if (sbd==''){
	   sbd = 0;
	}

	
	// now make sure they are converted to numbers for correct comparison
	oad=oad*1;
	maxdays=maxdays*1 ;
	ambdays=ambdays*1;
	
	ooamax=ooamax*1 ;
	ooaamb=ooaamb*1;
	ssamax=ssamax*1 ;
	ssaamb=ssaamb*1;
	ssbmax=ssbmax*1 ;
	ssbamb=ssbamb*1;

	newdays=newdays*1;
	
	// now make sure the days are correct - ie: current days(ooadays) + newdays
	//oad=oad + newdays;
	   
	rowLength = document.getElementById("checkedPostsTable").rows.length; //Get Number of Rows in Table
	var tbody = document.getElementById("checkedPostsTable").tBodies[0]; //Table to be used 
		
		//alert ("rowlength is " + rowLength);
		
	if (checked==true){//Adding or removing row
	
	 // alert("Add Row ");
	 // first get discharge date and check they are NOT in last 12 months of service
	 // cos if they are they can't go OOA without an OK

	 //dsg= dsgDate;
	// if(!dsg==''){
	    
		
	//	dms=dsg.getTime();
	//	sms=std.getTime();
	//	tms=chkdate.getTime();
		
	//	var startDate = new Date(document.frmDetails.startDate.value)
	//	var endDate = new Date(document.frmDetails.endDate.value)
	//	stDate = startDate.getTime();
	//	edDate = endDate.getTime();
		 
		//if(tms <= dms && tms >=sms) 
		//alert('Start Date = '+ stDate + ' | End Date = ' + edDate + ' | Discharge Date = ' + dms)
		
	//	if (edDate >= dms){	
		
	//	  var tOK=confirm("Selected personnel is in Resettlement Period " + "\n" + "Please confirm OOA Tasking")
	//	  if(!tOK==true) {
	//	    return;
	//	  }	
	//	}
	  	  
	// }

	 if(!document.getElementById(thisRow)){	
	 
	  // alert("Add Remove Post " + thisRow);
	   
	   var row = document.createElement("TR");//Start Row creation
	   row.setAttribute("height","22");		
	   row.setAttribute("id",staffID);
	   row.setAttribute("className","toolbar")
	   var cell1 = document.createElement("TD");//Start cell creation
	   var cell2 = document.createElement("TD");
	   var cell3 = document.createElement("TD");
	   var cell4 = document.createElement("TD");
	   
	   var cell5 = document.createElement("TD");
	   var cell6 = document.createElement("TD");
	   
	   //var cell5 = document.createElement("TD");
	   

	   cell2.innerHTML=Post;//Populate Cells
	   cell3.innerHTML=thisRow;
	   //cell4.innerHTML=ooadays;
	   //cell4.setAttribute("id", "ooa");
	   
	   if(document.frmDetails.ooatask.value == '1'){    // its an OOA Task so show current days of the selected bod
		  //cell4.innerHTML=oad;
		  cstr=oad+'/'+sad+'/'+sbd;
		  cell4.innerHTML=oad;
	      cell4.setAttribute("align", "center");
	      cell4.setAttribute("id", cid);
		  
		  cell5.innerHTML=sad;
	      cell5.setAttribute("align", "center");
	      cell5.setAttribute("id", cid);


		  cell6.innerHTML=sbd;
	      cell6.setAttribute("align", "center");
	      cell6.setAttribute("id", cid);

		  //cell5.innerHTML=slt;
	   
	      // they bust the OOA days limit - go RED
	      if (oad >= ooamax ){
		    cell4.setAttribute("bgColor", "#FF0000");
		  }
		  else {  // They are within n days of limit  - GO AMBER 
		    if (oad >= ambdays ){
		      cell4.setAttribute("bgColor", "#FFCC33");
			}
		  }
		  
		  // they bust the SSC A days limit - go RED
	      if (sad >= ssamax ){
		    cell5.setAttribute("bgColor", "#FF0000");
		  }
		  else {  // They are within n days of limit  - GO AMBER 
		    if (sad >= ssaamb ){
		      cell5.setAttribute("bgColor", "#FFCC33");
			}
		  }

		  // they bust the SSC B days limit - go RED
	      if (sbd >= ssbmax ){
		    cell6.setAttribute("bgColor", "#FF0000");
		  }
		  else {  // They are within n days of limit  - GO AMBER 
		    if (sbd >= ssbamb ){
		      cell6.setAttribute("bgColor", "#FFCC33");
			}
		  }
	   }
	   
	   if(document.frmDetails.ooatask.value == '2'){    // its an OOA Task so show current days of the selected bod
		  //cell4.innerHTML=oad;
		  cstr=sad+'/'+sbd;
		  cell4.innerHTML=sad;
	      cell4.setAttribute("align", "center");
	      cell4.setAttribute("id", cid);
		  
		  cell5.innerHTML=sbd;
	      cell5.setAttribute("align", "center");
	      cell5.setAttribute("id", cid);
	   
		  // they bust the SSC A days limit - go RED
	      if (sad >= ssamax ){
		    cell4.setAttribute("bgColor", "#FF0000");
		  }
		  else {  // They are within n days of limit  - GO AMBER 
		    if (sad >= ssaamb ){
		      cell4.setAttribute("bgColor", "#FFCC33");
			}
		  }

		  // they bust the SSC B days limit - go RED
	      if (sbd >= ssbmax ){
		    cell5.setAttribute("bgColor", "#FF0000");
		  }
		  else {  // They are within n days of limit  - GO AMBER 
		    if (sbd >= ssbamb ){
		      cell5.setAttribute("bgColor", "#FFCC33");
			}
		  }
	   }

	
	   // alert ("row details  " + cell2.innerHTML + "  " + cell3.innerHTML);

	   row.appendChild(cell1);//Add cells to row
	   row.appendChild(cell2);
	   row.appendChild(cell3);
	   row.appendChild(cell4);
	   
	   row.appendChild(cell5);
	   row.appendChild(cell6);
	   
	   tbody.appendChild(row);//Add row to table

	  /* var row2 = document.createElement("TR");//Start Row creation
	   row2.setAttribute("height","1");		
	   row2.setAttribute("className","titlearealine")
	   //row.setAttribute("id","");
	   var cell7 = document.createElement("TD");//Start cell creation
	   var cell8 = document.createElement("TD");
	   var cell9 = document.createElement("TD");
	   var cell10 = document.createElement("TD");
	   var cell11 = document.createElement("TD");
	   var cell12 = document.createElement("TD");

	   row2.appendChild(cell7);//Add cells to row
	   row2.appendChild(cell8);
	   row2.appendChild(cell9);
	   row2.appendChild(cell10);
	   row2.appendChild(cell11);
	   row2.appendChild(cell12);

	   tbody.appendChild(row2);//Add row to table
	   */
	 }
	} 
	else{
		
		//alert(document.getElementById('checkedPostsTable').innerHTML)
	//alert("remove row" + " " + document.getElementById('checkedPostsTable').innerHTML);
	  for (i=0;i < tbody.childNodes.length;i++){ //Iterate through rows in table
	      //alert("Child is " + tbody.childNodes[i].type  + staffID);
		 if( tbody.childNodes[i].id == staffID) {//Our row?
		// alert(tbody.childNodes[i].tagName)
		//` alert(tbody.childNodes[i].id +' == '+ staffID )
			//tbody.removeChild(5);
			//alert("rowid:" + tbody.childNodes[i].id + " * " + i + " * " + staffID );
			//rowID= document.getElementById(staffID);//Identify row
			//alert("rowid:" + tbody.childNodes[i].id + " * " + i + " * " + staffID );
			tbody.childNodes[i].parentNode.removeChild(tbody.childNodes[i]);
			//document.getElementById('checkedPostsTable').deleteRow(i);
			//document.getElementById('checkedPostsTable').removeChild(tbody.childNodes[i]);
			//alert ("row 1 deleted " + thisRow + " * " + i);
			//document.getElementById('checkedPostsTable').deleteRow(i-1);
			//document.getElementById('checkedPostsTable').removeChild(tbody.childNodes[i-1]);
			//alert ("row 2 deleted " + thisRow + " * " + (i-1));
			//Remove the row
			break;
		 }
	  }
	}

}

// so we don't refresh the screen when changing dates with no personnel selected
function setSearch(){
  
   document.frmDetails.DoSearch.value=1;
   document.frmDetails.submit();
}


// this takes the current OOA days for selected personnel and applies the days
// selected by the start/end dates - making sure to subtract any previous days if the dates changed
function getcurrent(curdays,olddays,newdays){

  //alert ( "into getcurrent");
  // now make sure they are converted to numbers for correct comparison
  var cdy=curdays*1;
  var ody=olddays*1;
  var ndy=newdays*1;
  
  //alert( "days are - current " + cdy + " old " + ody + " new " + ndy );

}

// this is the list passed to the update program so we can add the OOA days to the selected personnels
// current OOA total - its stored in the form hidden toTaskList
function setToTaskList()
{
	var rid;
	var cbody;
	var tlist="start";
	var clist;

	rowLength = document.getElementById("checkedPostsTable").rows.length; //Get Number of Rows in Table
	var tbody = document.getElementById("checkedPostsTable").tBodies[0]; //Table to be used 
  
   // alert("Table is " + rowLength);
	
  	for(i=0;i<tbody.childNodes.length;i++) //Iterate through rows in table - 1st 4 are tbl headers    
	{
		// id is not blank - so we want this ROW
		if(!tbody.childNodes[i].id=="")
		{		  
			rid=tbody.childNodes[i].id
			
			//alert("Child Node is " + rid);
			
			// set current list element to default - then if its not OOA task this will get added
			clist=","+rid+"|"+0
			cbody=document.getElementById(rid).childNodes; 	
		
			for (n=0;n<cbody.length;n++)
			{		
				// id is not blank so we want this CELL - should be the ooa days 
				if(!cbody[n].id=="")
				{
					// set the current element to be added to the list - this will overwrite the default set above
					clist=","+rid+"|"+cbody[n].innerHTML;
				}	
			}
			// now add current element to list
			tlist=tlist+ clist
		}
	}
	return(tlist);
}

// here we are adding the days for the current task - diff of start/end dates
// to any currently selected people
function addnewdays(numdays){

  	rowLength = document.getElementById("checkedPostsTable").rows.length; //Get Number of Rows in Table
	var tbody = document.getElementById("checkedPostsTable").tBodies[0]; //Table to be used 
}

function saveNew()
{
	//This function renoves any leading or trailing spaces from a string
	String.prototype.killWhiteSpace = function()
	{
		return this.replace(/\s/g, '');
	};

	var errMsg = "Please provide/correct the following:\n\n";
	var error = false;

	var newattached = setToTaskList();
	var sd = document.getElementById('startDate').value;
	sd = sd.killWhiteSpace();
	var ed = document.getElementById('endDate').value;	
	ed = ed.killWhiteSpace();
	
	var note = document.getElementById('notes').value;	
	
	document.frmDetails.newattached.value = newattached;
	
	//alert("staff list is " + newattached);
	
	if(sd == "" || ed == "")
	{
		errMsg += "Specify Dates\n"
		error = true;
	}
	
	if (note=="" ){
		
		errMsg += "You Must Enter Task Details in the Notes\n"
		error = true;
	}
	
	if( note.length < 3 ){
		errMsg += "You Must Enter at least 3 characters in the Notes\n"
		error = true;
	}
	
	if(newattached == 'start')
	{
		errMsg += "Select personnel\n"
		error = true;	
    } 

	if(error == true)
	{
		alert(errMsg)
		return;	  		
	}

	document.frmDetails.action="UpdateTaskPersonnel.asp";
	//alert(document.frmDetails.newattached.value)
	document.frmDetails.submit();
}

function changeParent()
{
	var TypeID = document.getElementById("TypeID").value;
	document.getElementById("QID").length=0;
	var counter =0;
	
	for(i=0;i<ParentArray.length;i++)
	{
		strSplit = ParentArray[i].split("*");
		if (strSplit[0]==TypeID)
		{
			document.frmDetails.QID.options[counter] = new Option(strSplit[2],strSplit[0] + "*" + strSplit[1]);
			//alert(document.frmDetails.QID.value);
			counter=counter+1;
		}
	}
}

function findParent()
{
	var TypeID = document.getElementById("TypeID").value;
	document.getElementById("QID").length=0;
	var counter = 0;
	
	for (i=0;i < ParentArray.length;i++)
	{
		strSplit = ParentArray[i].split("*");
		if (strSplit[0]==TypeID)
		{
			document.getElementById("QID").options[counter] = new Option (strSplit[2],strSplit[1]);
			counter++;
		}
	}
}



function chk()
{
	var width=window.innerWidth || document.documentElement.clientWidth || document.body.clientWidth;
	var height=window.innerHeight || document.documentElement.clientHeight || document.body.clientHeight;
	//Works out what the height of the side menu has to be
	var side_div = document.getElementById("mainArea");
	side_div.style.height = (height - 170) + "px";
	
	//Works out what the height and width of the main area has to be
	//var main_div = document.getElementById("teamIframe");
	//main_div.style.height = (height - elemPosition(main_div).top) + "px";
	//main_div.style.width = (width - elemPosition(main_div).left) + "px";
}

</Script>
<%response.write testDate%>
</body>
</html>
