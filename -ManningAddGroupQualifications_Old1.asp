<!DOCTYPE HTML >

<!--#include file="Includes/security.inc"--> 
<!--#include file="Connection/Connection.inc"-->

<%
dim strAction
dim strFrom
dim strGoTo
dim typeID

if request("TypeID") <> "" then
	typeID = request("TypeID")
	strSplit = split(typeID, "*")
	typeID = strSplit(0)
	strAuth = strSplit(1)
else
	typeID = 0
	strAuth = "False"
end if

if request("QID") <> "" then
	qID = request("QID")
else
	qID = 0
end if

strFrom=request("fromPage")

if strFrom = "Manning" then
	strGoTo = "ManningTeamDetail.asp"   ' asp page to return to once record is deleted
else
	strGoTo = "AdminTeamDetail.asp"   ' asp page to return to once record is deleted
end if

strAction="Update"

set objCmd = server.CreateObject("ADODB.Command")
set objPara = server.CreateObject("ADODB.Parameter")
objCmd.ActiveConnection = con
objCmd.Activeconnection.cursorlocation = 3

strCommand = "spListQTypes"
objCmd.CommandText = strCommand
objCmd.CommandType = 4		
set rsQTypeList = objCmd.Execute	'Execute CommandText when using "ADODB.Command" object'

for x = 1 to objCmd.parameters.count
	objCmd.parameters.delete(0)
next

set objCmd = server.CreateObject("ADODB.Command")
set objPara = server.CreateObject("ADODB.Parameter")
objCmd.ActiveConnection = con
objCmd.Activeconnection.cursorlocation = 3

strCommand = "spQs"
objCmd.CommandText = strCommand
objCmd.CommandType = 4		
set objPara = objCmd.createparameter("QTypeID",3,1,4, cint(typeID))
objCmd.parameters.append objPara
set rsParentList = objCmd.Execute	'Execute CommandText when using "ADODB.Command" object'

for x = 1 to objCmd.parameters.count
	objCmd.parameters.delete(0)
next

if request("TypeID") <> "" then
	thisTypeID = request("TypeID")
	strSplit = split(thisTypeID, "*")
	thisTypeID=int(strSplit(0))
else
	thisTypeID=1
end if

if request("page")<>"" then
	page=int(request("page"))
else
	page=1
end if

if request("doSearch")=1 then
	strCommand = "spQualificationStaffSearchResults"
	objCmd.CommandText = strCommand
	objCmd.CommandType = 4
	set objPara = objCmd.CreateParameter("surname",200,1,50, request("surname"))
	objCmd.Parameters.Append objPara
	set objPara = objCmd.CreateParameter("firstname",200,1,50, request("firstname"))
	objCmd.Parameters.Append objPara
	set objPara = objCmd.CreateParameter("serviceno",200,1,50, request("serviceno"))
	objCmd.Parameters.Append objPara
	set objPara = objCmd.CreateParameter("TypeID",3,1,0, typeID)
	objCmd.Parameters.Append objPara
	set objPara = objCmd.CreateParameter("QID",3,1,0, request("QID"))
	objCmd.Parameters.Append objPara
	set rsSearchResults = objCmd.Execute

	if request("page")<>"" then
		page=int(request("page"))
	else
		page=1
	end if
	
	recordsPerPage = 16
		
	num=rsSearchResults.recordcount
	startRecord = (recordsPerPage * page) - recordsPerPage
	totalPages = (int(num/recordsPerPage))

	if int(num - (recordsPerPage * totalPages)) > 0 then totalPages=totalPages+1
	if page = totalPages then recordsPerPage = int(num - startRecord)

	if rsSearchResults.recordcount>0 then rsSearchResults.move(startRecord)

	beginAtPage=1
	increaseAfter = 6
	startEndDifference = 9
	if page-increaseAfter >1 then 
		beginAtPage=page-increaseAfter
	end if
	
	if totalPages < beginAtPage+startEndDifference  then
		beginAtPage = totalPages-startEndDifference
	end if
	
	endAtPage=beginAtPage+startEndDifference
	if beginAtPage<1 then beginAtPage=1

end if


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

checkedPosts=request("currentlyChecked")
if checkedPosts <> "" then 
	strCheckedPosts = split(checkedPosts, ",")
	whereString=" serviceno='" & strCheckedPosts(1) & "'"
	if UBound(strCheckedPosts)>1 then
		FOR intCount = 2 TO (UBound(strCheckedPosts))
			if strCheckedPosts(intCount) <>"" then whereString=whereString+" or serviceno='" & strCheckedPosts(intCount) & "'"
		Next
	end if
	objCmd.CommandType = 1
	objCmd.CommandText = "select * from tblStaff where " &  whereString & " order by surname"
	set testRS = objCmd.Execute
end if
%>	

<script type="text/javascript" src="calendar.js"></script>

<html>
<head> 

<!--#include file="Includes/IECompatability.inc"-->


<title><%=pageTitle%></title>
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
.style2 {color: #FFFFFF}
.style3 {color: #FF0000}
-->
</style>

</head>
<body>
<form action="" method="post" name="frmDetails">
    <input name="newattached" type="hidden" value="">
    <input name="ReturnTo" type="hidden"  value="ManningAddGroupQualifications.asp">
    <Input name="DoSearch" type="hidden" value=1>
    <Input name="Page" type="hidden" value=1>
    <Input name="HiddenDate" type="hidden" >
    <input name="currentlyChecked" type=hidden value=<%=request("currentlyChecked")%>>
    <input name ="criteriaChange" type=hidden value=0>
    <input name="Auth" type="hidden" value="<%= strAuth %>">

    <table height="100%" cellspacing=0 cellPadding=0 width=100% border=0>
        <tr>
            <td>
            	<!--#include file="Includes/Header.inc"-->
				<table cellSpacing=0 cellPadding=0 width=100% border=0>
    	  			<tr>
      	    			<td align="center" class="sidemenuwidth" ><img alt="" src="images/spssites.gif" ></td>
       					<td class=titlearea >Qualifications<BR><span class="style1"><Font class=subheading>Assign to Many</Font></span></td>
    	  			</tr>
  		  			<tr>
       					<td colspan=2 class=titlearealine  height=1></td> 
     	  			</tr>
  				</table>
                <table width=100% height='<%=session("heightIs")%>px' border=0 cellpadding=0 cellspacing=0 > 
                    <tr valign=Top>
						<td class="sidemenuwidth" background="Images/tableback.png">
			  				<table width=100% border=0 cellpadding=0 cellspacing=0 class=MenuStyleParent>
			    				<tr>
          		  					<td width="10" height=22></td>
									<td colspan=3 align=left height=22>Current Location</td>
			    				</tr>
								<tr>
									<td></td>
									<td width=18 valign=top height=22><img src="images/arrow.gif"></td>
									<td width=170 align=Left height=22><A title="" href="index.asp">Home</A></td>
									<td width=50 align=Left height=22></td>
								</tr>
								<tr>
									<td></td>
									<td valign=top height=22><img src="images/vnavicon.gif"></td>
									<td align=Left bgcolor="#FFFFFF" height=22><Div style="height:18px; width:16em; border:Solid; border-width:1px; border-color:#438BE4; color: #003399;">Assign Qs to Many</Div></td>
									<td class=rightmenuspace align=Left height=22></td>
								</tr>
							</table>
                        </td>
                        <td width="16">&nbsp;</td>
                        <td align=left>
                        	<table border=0 cellpadding=0 cellspacing=0 width=100%>
                            	<tr height=16 class=SectionHeader>
                                	<td>
                                        <table width="100%" border=0 cellpadding=0 cellspacing=0 >
                                            <td width=25 height="25"><img id="SaveCloseLink" class="imagelink" src="images/editgrid.gif" onclick="saveNew();"></td>
                                            <td height="25" class=toolbar valign="middle">Save and Close</td>
                                        </table>
                                    </td>
                                </tr>
       			    			<tr>
                                	<td>
                                        <table width=100% border=0 cellpadding=0 cellspacing=0>
                                            <tr height=16>
                                                <td></td>
                                            </tr>
                                            <tr class=columnheading>
                                                <td valign="middle" height=22 width=16></td>
                                                <td valign="middle"  width=122>Qualification Type:</td>
                                                <td valign="middle"  class=itemfont width=122>
                                                    <Select class="itemfont" Name=TypeID id="TypeID" style="width:120px;" onChange="frmDetails.submit()">
                                                        <option value="">...Select</option>
                                                        <% do while not rsQTypeList.eof %>
                                                            <option value="<%= rsQTypeList("QTypeID") %>*<%= rsQTypeList("Auth") %>" <%if cint(typeID) = rsQTypeList("QTypeID") then %> selected <% end if %>><%= rsQTypeList("Type") %></option>
                                                            <% rsQTypeList.movenext %>
                                                        <% loop %>
                                                    </Select>
                                                </td>
                                                <td width=10></td>
                                                <td valign="middle" width=79>Qualification:</td>
                                                <td valign="middle" width=137 class=itemfont >
                                                    <Select class="itemfont" style="width:185px;" Name=QID onChange="MovetoPage(<%=page%>)">
                                                        <option value="0">...Select</option>
                                                        <% do while not rsParentList.eof %>
                                                            <% if int(rsParentList("QTypeID")) = cint(typeID) then %>
                                                                <option value="<%=int(rsParentList("QID"))%>" <%if cint(rsParentList("QID")) = cint(request("QID")) then %> selected <% end if %>><%=rsParentList("description")%></option>
                                                            <% end if %>
                                                            <% rsParentList.movenext %>
                                                        <% loop %>
                                                    </Select>
                                                </td>
                                                <td width=10></td>
                                                <td valign="middle" width=74>Valid From:</td>
                                                <td valign="middle" width=108 class=itemfont>
                                                    <table border=0 cellpadding=0 cellspacing=0 width=100%>
                                                        <tr>
                                                            <td><input id="DateAttained" class="itemfont" style="Width:75px;" name="DateAttained" value = <%if request("DateAttained") <>"" then%>"<%=request("DateAttained")%>"<%else%>"<%=date%>"<%end if%> readonly onclick="calSet(this)">
                                                            &nbsp;<img src="images/cal.gif" align="absmiddle" onClick="calSet(DateAttained)" style="cursor:hand;"></td>
                                                        </tr>
                                                    </table>                                                    
                                                </td>					
                                                <td width=10></td>
                                                <td valign="middle" width=74>Competent:</td>
                                                <td valign="middle" width=43 class=itemfont>
                                                    <select class="itemfont" name=Competent>
                                                        <option value=A <%if request("Competent")="A" then response.write "Selected"%>>A</option>
                                                        <option value=B <%if request("Competent")="B" then response.write "Selected"%>>B</option>
                                                        <option value=C <%if request("Competent")="C" then response.write "Selected"%>>C</option>
                                                        <option value=N <%if request("Competent")="N" or request("Competent")="" then response.write "Selected"%>>N</option>
                                                    </select>
                                                </td>
                                                <td width="14"></td>
											</tr>
                                            <tr class="columnheading">
                                                <td valign="middle" height=22 width=16></td>
                                                <td valign="middle" width=122>Authorised By:</td>
                                                <td valign="middle" colspan="10" class=itemfont width=122><input type="text" name="txtAuth" id="txtAuth" <% if strAuth = "False" then %>disabled<% end if %> class="itemfont" style="Width:160px; background-color:<% if strAuth = "False" then %>#E1E1E1<% else %>#FFFFFF<% end if %>;" value="<%= request("txtAuth") %>"></td>
                                                <td valign="middle">&nbsp;</td>
                                            </tr>
                                            <tr>
                                            	<td colspan="4">&nbsp;</td>
                                            </tr>
                                        </table>
									</td>
								</tr>
							<tr height=16 class=SectionHeader>
								<td>
									<table width="100%" border=0 cellpadding=0 cellspacing=0>
                                    	<tr>
                                        	<td height="25" align="left">
                                                <table border=0 cellpadding=0 cellspacing=0 >
                                                    <tr>
                                                        <td class=toolbar width=8 height="22px"></td>
                                                        <td class=toolbar valign="middle" height="22px">Assign to: (Personnel Currently assigned Selected Qualification will <B>not</B> be listed)</td>
                                                    </tr>
                                                </table>
                                            </td>
                                        </tr>
									</table>
								</td>
							</tr>
							<tr>
								<td>
									<table width=100% border=0>
										<tr>
											<td width=970>
                                                <table width=100% border=0 cellpadding=0 cellspacing=0>
                                                    <tr>
                                                        <td colspan="11">&nbsp;</td>
                                                    </tr>
                                                    <tr class=searchheading>
                                                        <td valign="middle" width=16 height=22></td>
                                                        <td valign="middle" width=30 height=22>Surname:</td>
                                                        <td valign="middle" width=170 height=22>&nbsp;<input onChange="javascript:document.frmDetails.criteriaChange.value=0;" class="itemfont" style="WIDTH: 150px" maxLength=20 name=surname id="surname" value=<%=request("surname")%>></td>
                                                        <td valign="middle" width="7" height=22></td>
                                                        <td valign="middle" width=60 height=22>Firstname:</td>
                                                        <td valign="middle" width=169 height=22>&nbsp;<input onChange="javascript:document.frmDetails.criteriaChange.value=0;" class="itemfont" style="WIDTH: 150px" maxLength=20 name=firstname id="firstname" value=<%=request("firstname")%>></td>
                                                        <td valign="middle" width="7" height=22></td>
                                                        <td valign="middle" width=80 height=22>Service No:</td>
                                                        <td valign="middle" width=124 height=22>&nbsp;<input onChange="javascript:document.frmDetails.criteriaChange.value=0;" class="itemfont" style="WIDTH: 100px" maxLength=20 name=serviceno id="serviceno" value=<%=request("serviceno")%>></td>
                                                        <td width=27 height=22><a class=itemfontlink href="javascript:<%if request("doSearch")=1 then%>MovetoPage(1)<%else%>btnFind()<%end if%>;"><img class="imagelink" src="images/icongo01.gif"></a></td>
                                                        <td width="97" height=22 valign="middle" class=toolbar>Find</td>
                                                    </tr>
                                                </table>
											</td>
										</tr>
</Form>
										<tr>
											<td>
<form action="" method="post" name="frmPosts" style="position:absolute;top:350px;left:220px;width:85%;">
												<table border=0 width=100% style="border:1px solid;">
													<tr>
														<td valign=top>
															<table width=100% border=0 cellpadding=0 cellspacing=0>
																<tr class=itemfont height=20>
																	<td valign="middle" width=2%></td>
																	<td colspan=4 valign="middle" >Search Results: <%if isObject(rsSearchResults) then%><Font class=searchheading>records found: <%=rsSearchResults.recordcount%><%end if%></Font></td>
																</tr>
																<tr>
																	<td colspan=5 class=titlearealine  height=1></td> 
																</tr>
                                                                <tr class=columnheading>
                                                                    <td width="2%" height=22 valign="middle">&nbsp;</td>
                                                                    <td width="38%" height=22 valign="middle">Surname</td>
                                                                    <td width="38%" height=22 valign="middle">Firstname</td>
                                                                    <td width="14%" height=22 valign="middle">Service No</td>
                                                                    <td width="8%" height=22 align="center" valign="middle">select</td>
                                                                </tr>
																<tr>
																	<td colspan=5 class=titlearealine  height=1></td> 
																</tr>
																<% if isObject(rsSearchResults) then %>
																	<% if rsSearchResults.recordcount > 0 then %>
																		<% Row = 0 %>
																		<% do while Row < recordsPerPage %>
                                                                            <tr id="TableRow<%= Row %>" class=toolbar>
                                                                                <td width="2%" height=22 valign="middle">&nbsp;</td>
                                                                                <td width="38%" height=22 valign="middle"><%= rsSearchResults("surname") %></td>
                                                                                <td width="38%" height=22 valign="middle"><%= rsSearchResults("firstname") %></td>
                                                                                <td width="14%" height=22 valign="middle"><%= rsSearchResults("serviceno") %></td>
                                                                                <td width="8%" height=22 align="center" valign="middle"><input type="checkbox" name=StaffID<%=rsSearchResults("StaffID")%> value=<%=rsSearchResults("serviceno")%><%if Instr(request("currentlyChecked"), rsSearchResults("serviceno") ) >0 then response.write(" checked")%>  onclick="javascript:addRemovePost(this.checked,'<%=rsSearchResults("surname")%>','<%=rsSearchResults("serviceno")%>');"></td>
                                                                            </tr>
                                                                    		<tr>
                                                                        		<td colspan=5 class=titlearealine  height=1></td> 
                                                                    		</tr>
                                                                    		<% row = row + 1 %>
                                                                    		<% rsSearchResults.movenext %>
																		<% loop %>
                                                                        <tr height=22px>
                                                                            <td colspan=5></td>
                                                                        </tr>
                                                                        <tr align="center">
                                                                            <td colspan=5>
                                                                                <table border=0 cellpadding=0 cellspacing=0>
                                                                                    <tr>
                                                                                        <td class=itemfont height=22>Results Pages: &nbsp;</td>
                                                                                        <td class=ItemLink height=22><% if int(page) > 1 then %><a id=previousButton href="javascript:MovetoPage(<%=page-1%>);" class=ItemLink><font style="font-size:16px;">&laquo</font> Previous</a><% else %><font style="font-size:16px;">&laquo;</font> Previous<% end if %></td>
                                                                                        <td class=itemfont height=22>&nbsp;&nbsp;</td>
                                                                                        <% pagenumber = beginAtPage %>
                                                                                        <% do while pagenumber <= endAtPage %>
                                                                                            <td>
                                                                                                <a class="<% if page <> pagenumber then %>ItemLink<% else %>itemfontbold<% end if %>" href="javascript:MovetoPage(<%= pagenumber %>);"><%= Pagenumber %></a>
                                                                                                <%if pagenumber < (endAtPage) then%>
                                                                                                    <font class="itemfont">,</font>
                                                                                                <%end if%>
                                                                                            </td>
                                                                                            <% pageNumber = pageNumber + 1 %>
                                                                                        <% loop %>
                                                                                        <td class=itemfont height=22>&nbsp;&nbsp;</td>
                                                                                        <td class=ItemLink height=22><% if int(page) < int(endAtPage) then %><a id=nextButton href="javascript:MovetoPage(<%= page + 1 %>);" class=ItemLink>Next <font style="font-size:16px;">&raquo;</font></a><% else %>Next <font style="font-size:16px;">&raquo;</font><% end if %></td>
                                                                                    </tr>
                                                                                </table>
                                                                            </td>
                                                                        </tr>
                                                                    <% else %>
                                                                        <tr class=itemfont>
                                                                            <td valign="middle" width=2% height=22></td>
                                                                            <td align="center" valign="middle" colspan=5 height=22>Your search returned no results</td>
                                                                        </tr>
                                                                        <tr>
                                                                            <td colspan=6 class=titlearealine  height=1></td> 
                                                                        </tr>
                                                                    <% end if %>
																</table>
															</td>
													<!--</tr>-->
														<%else%>
                                                            <tr class=itemfont  height=22>
                                                                <td valign="middle"  width=2%></td>
                                                                <td align="center"    valign="middle" colspan=5 >Your search returned no results</td>
                                                            </tr>
                                                            <tr>
                                                                <td colspan=6 class=titlearealine  height=1></td> 
                                                            </tr>
                                                        </table>
                                                    </td>
												<%end if%>
                                                    <td width=40% valign=top>
                                                        <table id=checkedPostsTable align="center" border=0 cellpadding=0 cellspacing=0 width=90%>
                                                            <tr>
                                                                <td align="center" height=22 colspan=3 class=itemfont>Currently Selected Persons:</td>
                                                            </tr>
                                                            <tr>
                                                                <td class=titlearealine height=1 colspan=3></td>
                                                            </tr>
                                                            <tr height=22 class=columnheading >
                                                                <td width=1%></td>
                                                                <td valign="middle" width=14%>Surname</td>
                                                                <td width="8%" valign="middle" >Service No</td>
                                                            </tr>
                                                            <tr>
                                                                <td  class=titlearealine  height=1 colspan=3></td>
                                                            </tr>
                                                            <%if isObject(testRS) then%>
                                                                <%do while not testRS.eof%>
                                                                    <tr id = <%=testRS("serviceno")%> height=20  class=toolbar >
                                                                        <td width=1%></td>
                                                                        <td valign="middle" width=14%><%=testRS("surname")%></td>
                                                                        <td width="8%" valign="middle" ><%=testRS("serviceno")%></td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td colspan=3 class=titlearealine  height=1></td>
                                                                    </tr>
                                                                    <%testRS.movenext%>
                                                                <%loop%>
                                                            <%end if%>
                                                        </table>
                                                    </td>		
												</tr>
											</table>
										</td>
									</tr>
								</table>
							</tr>						
						</table>
					</td>
				</tr>
			</table>
		</td>
	</tr>
</table>


</form>

<script type="text/javascript" src="calendar.js"></script>

<SCRIPT LANGUAGE="JavaScript">
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

function addRemovePost(checked,Post,thisRow){
	//document.getElementById('checkedList').innerHTML = ajaxRequest.responseText;
	
	rowLength = document.getElementById("checkedPostsTable").rows.length; //Get Number of Rows in Table
	var tbody = document.getElementById("checkedPostsTable").tBodies[0]; //Table to be used 
	if (checked==true){//Adding or removing row
	if(!document.getElementById(thisRow)){	
	var row = document.createElement("TR");//Start Row creation
	row.setAttribute("height","22");		
	row.setAttribute("id",thisRow);
	row.setAttribute("className","toolbar")
	var cell1 = document.createElement("TD");//Start cell creation
	var cell2 = document.createElement("TD");
	var cell3 = document.createElement("TD");
	var cell4 = document.createElement("TD");
	
	cell2.innerHTML=Post;//Populate Cells
	cell3.innerHTML=thisRow;

	row.appendChild(cell1);//Add cells to row
	row.appendChild(cell2);
	row.appendChild(cell3);
	row.appendChild(cell4);
	tbody.appendChild(row);//Add row to table
	
	var row2 = document.createElement("TR");//Start Row creation
	row2.setAttribute("height","1");		
	row2.setAttribute("className","titlearealine")
	var cell5 = document.createElement("TD");//Start cell creation
	var cell6 = document.createElement("TD");
	var cell7 = document.createElement("TD");
	var cell8 = document.createElement("TD");

	cell5.setAttribute("colspan",4);

	row2.appendChild(cell5);//Add cells to row
	row2.appendChild(cell6);
	row2.appendChild(cell7);
	row2.appendChild(cell8);
	
	tbody.appendChild(row2);//Add row to table
	
	}
	} else{
	for (i=0;i<tbody.childNodes.length;i++){ //Iterate through rows in table
		if( tbody.childNodes[i].id == thisRow) {//Our row?
			rowID= document.getElementById(thisRow);//Identify row
			document.getElementById('checkedPostsTable').deleteRow(i);
			document.getElementById('checkedPostsTable').deleteRow(i-1);
			break;
			}
		}
	}

}

function saveNew(){
	if(document.frmDetails.TypeID.value == 0)
	{
		alert( "Select a qualification type");
		return;
	}
	
	if(document.frmDetails.QID.value == 0)
	{
		alert( "Select a qualification");
		return;
	}
	
	if(document.getElementById('Auth').value == 'True' && document.getElementById('txtAuth').value == "")
	{
		alert("Enter Authorised By");
		return
	}
	
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
	alert("Select at least one person")
	return;	  		
} 

document.frmDetails.action="UpdateGroupQualification.asp";
document.frmDetails.submit();
}

function changeParent() {
var TypeID = document.getElementById("TypeID").value;
document.getElementById("QID").length=0;
var counter =0;
for (i=0;i<ParentArray.length;i++)
	{
		strSplit = ParentArray[i].split("*");
			if (strSplit[0]==TypeID)
			{
				document.frmDetails.QID.options[counter] = new Option(strSplit[2],strSplit[0] + "*" + strSplit[1]);
				alert(document.frmDetails.QID.value);
				counter=counter+1;
			}
	}
}

function findParent(){
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


//function CheckForm() {
//passed=true;
//if (document.forms["frmDetails"].elements["Description"].value =="") {
//alert("Please enter Team Name");
//passed=false;
//}
//
//if (document.forms["frmDetails"].elements["Weight"].value =="") {
//	alert("Please enter Team Weight");
//	passed=false;
//	}else{
//		var checkOK = "01234567890";
//		var checkStr = document.forms["frmDetails"].elements["Weight"].value;
//		var ch;
//		var NotNumeric=0;
//		for (i=0;i < checkStr.length;i++){
//			ch = checkStr.charAt(i);
//			if (checkOK.indexOf(ch)==-1){passed=false;alert("Please use numerical values only in Team Weight Field");NotNumeric=1}
//			if (NotNumeric==1){break;}
//		}
//	}
//return passed;
//}
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

	str=Calender.value
	document.forms["frmDetails"].elements["HiddenDate"].value = str
	whole = document.forms["frmDetails"].elements["HiddenDate"].value
	day = document.forms["frmDetails"].elements["HiddenDate"].value.substring (8,10)
	day.replace (" ","")
	month = document.forms["frmDetails"].elements["HiddenDate"].value.substring (4,7)
	strlength = document.forms["frmDetails"].elements["HiddenDate"].value.length
	year = document.forms["frmDetails"].elements["HiddenDate"].value.substring (strlength-4,strlength)
	
	document.all.DateAttained.value = day + " " + month + " " + year
	}

function btnFind() {
	if(document.getElementById('surname').value == '' && document.getElementById('firstname').value == '' && document.getElementById('serviceno').value == '') {
		alert('Please enter search criteria');
		return;
	} else {
		document.forms.frmDetails.submit();
	}
}

</Script>
<%response.write testDate%>
</body>
</html>
