<!DOCTYPE HTML >
<!--#include file="Includes/security.inc"--> 
<!--#include file="Includes/checkadmin.asp"-->
<!--#include file="Connection/Connection.inc"-->

<%

' This is the Initial Display Page of Task table data

' 'so the menu include - datamenu.inc knows what page we're on
dim strPage
strPage="PsTa"

' 'default to these dates just for backward compatability with stored procedure
''startDate = "01 Jan 2000"
''endDate = "31 Dec 2050"
startDate = " "
endDate = " "
sort = 1

strTable = "tbl_TaskCategory"
' 'strCommand = "spListTasks"

set objCmd = server.CreateObject("ADODB.Command")
set objPara = server.CreateObject("ADODB.Parameter")
objCmd.ActiveConnection = con
objCmd.Activeconnection.cursorlocation = 3
objCmd.CommandType = 4		

' 'first find out whether its an HQ Tasking Group - cos if it is then we display HQ Task details
'strCommand = "spCheckHqTask"
'objCmd.CommandText = strCommand
'objCmd.CommandType = 4		
'
'set objPara = objCmd.CreateParameter ("StaffID",3,1,0, session("StaffID"))
'objCmd.Parameters.Append objPara
'set objPara = objCmd.CreateParameter ("HQTasking",3,2)
'objCmd.Parameters.Append objPara
'objCmd.Execute	             ' 'Execute CommandText when using "ADODB.Command" object
'strHQTasking   = objCmd.Parameters("HQTasking") 
'
'' 'Now Delete the parameters
'objCmd.Parameters.delete ("StaffID")
'objCmd.Parameters.delete ("HQTasking")

'set objPara = objCmd.CreateParameter ("TableName",200,1,50, strTable)
'objCmd.Parameters.Append objPara
' 'set rsRecSet = objCmd.Execute	' 'Execute CommandText when using "ADODB.Command" object

strCommand = "spListTaskTypes"
objCmd.CommandText = strCommand
set objPara = objCmd.CreateParameter ("nodeID",3,1,0, nodeID)
objCmd.Parameters.Append objPara
set rsTaskTypeList = objCmd.Execute	'Execute CommandText when using "ADODB.Command" object'

if request("doSearch")=1 then

   task = request("task")
   ttID = request("ttID")
   

   session("tSearchTask") = request("task")
   session("tSearchttID") = request("ttID")
  '' session("tSearchStartDate") = request ("startDate")
  '' session("tSearchEndDate") = request("endDate")
else

	if session("tSearchTask") <> "" then 
		task = session("tSearchTask")
	else
		task=""
	end if
	if session("tSearchttID") <> "" then 
		ttID = session("tSearchttID")
	else
		ttID=1
	end if
end if

	if cancellable="" then
		cancellable=0
	else
		cancellable=1
	end if

	if startdate="" then 
		startDate = newTodaydate
		session("tSearchStartDate") = startDate
	end if
	
	if endDate="" then
		endDate = "31 Dec 2050"
		session("tSearchEndDate") = endDate
	end if
	strCommand = "spTaskSearchResults"
	objCmd.CommandText = strCommand
	objCmd.CommandType = 4		
	set objPara = objCmd.CreateParameter ("task",200,1,50, task)
	objCmd.Parameters.Append objPara
	set objPara = objCmd.CreateParameter ("ttID",3,1,0, ttID)
	objCmd.Parameters.Append objPara
	set objPara = objCmd.CreateParameter ("startDate",200,1,50, startDate)
	objCmd.Parameters.Append objPara
	set objPara = objCmd.CreateParameter ("endDate",200,1,50, endDate)
	objCmd.Parameters.Append objPara
	set objPara = objCmd.CreateParameter ("sort",3,1,0, sort)
	objCmd.Parameters.Append objPara
	set objPara = objCmd.CreateParameter ("showOOA",3,1,0, 1)
	objCmd.Parameters.Append objPara

	set rsRecSet = objCmd.Execute

for x = 1 to objCmd.parameters.count
	objCmd.parameters.delete(0)
next

	if request("page")<>"" then
		page=int(request("page"))
	else
		page=1
	end if
	recordsPerPage = 20
		
	num=rsRecSet.recordcount
	startRecord = (recordsPerPage * page) - recordsPerPage
	totalPages = (int(num/recordsPerPage))

	if int(num - (recordsPerPage * totalPages)) > 0 then totalPages=totalPages+1
	if page = totalPages then recordsPerPage = int(num - startRecord)

	if rsRecSet.recordcount>0 then rsRecSet.move(startRecord)

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

%>

<html>

<!--#include file="Includes/IECompatability.inc"-->



<head> <title><%= PageTitle %></title>
<link rel="stylesheet" type="text/css" href="Includes/AMDB.css" media="Screen"/>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
</head>
<body>
<form  action="AdminPsTaList.asp" method="POST" name="frmDetails">
<Input name="HiddenDate" id="HiddenDate" type="hidden" >
<Input name="HiddenStartDate" id="HiddenStartDate" type="hidden" >
<Input name="HiddenEndDate" id="HiddenEndDate" type="hidden" >
<Input name="DoSearch" id="DoSearch" type="Hidden" value="1">
<Input name="Page"  id="Page" type="Hidden" value="1">
<Input name="Sort" id="Sort" type="Hidden" value="<%=sort%>">

    <table  height="100%" cellspacing=0 cellPadding=0 width=100% border=0>
    	<tr>
    		<td>
    			<!--#include file="Includes/Header.inc"--> 
               <table cellSpacing=0 cellPadding=0 width=100% border=0 >
                    <tr style="font-size:10pt;" height=26px>
                        <td width=10><img style="margin-left:10px;" src="cms_icons/png/24x24/process.png" width="24" height="24"></td>
                        <td class="staticdatamenu"><font class="youAreHere">CMS Admin Menu / <strong>Task Details</strong></font></td>
                    </tr>
                    <tr><td colspan=2 class=titlearealine  height=1></td></tr>
				</table>
          
  		  <table width=100% height='<%=session("heightIs")%>px' border=0 cellpadding=0 cellspacing=0> 
      		<tr valign=Top>
        	  <td class="sidemenuwidth" background="Images/tableback.png"><!--#include file="Includes/datamenu.inc"--></td>
                        <td width=10>&nbsp;</td>
                        <td align=left>
                            <table border=0 cellpadding=0 cellspacing=0 width=100%>
                                <tr height=16 class=SectionHeader>
                                    <td>
                                        <table width="203" height="17" border=0 cellpadding=0 cellspacing=0 >
                                            <tr>
                                                <td class=toolbar width=11></td>
                                                <td width=20><a class=itemfontlink href="AdminPsTaAdd.asp"><img class="imagelink" src="images/newitem.gif"></a></td>							  
                                                <td width="153" valign="middle" class=toolbar>New Task</td>
                                            </tr>  
                                        </table>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <table width=100% border=0 cellpadding=0 cellspacing=0>
                                            <tr class=columnheading>
                                                <td colspan="7" height=20>&nbsp;</td>
                                            </tr>
                                            <tr class=columnheading height=20>
                                                <td width="2%">&nbsp;</td>                                
                                                <td width="8%">Task Type:</td>
                                                <td valign="middle" width="15%">
                                                    <select  class="itemfont" name="ttID" id="ttID" style="width:120px;" onChange="frmDetails.submit();">
                                                        <option value=0 selected>All</option>
                                                        <% do while not rsTaskTypeList.eof %>
                                                            <option value=<%=rsTaskTypeList("ttID")%><%if int(ttID)=int(rsTaskTypeList("ttID")) then response.write " selected "%> > <%=rsTaskTypeList("Description")%> </option>
                                                            <% rsTaskTypeList.MoveNext %>
                                                        <% loop %>
                                                    </select>
                                                </td>
                                                <td width=6%>Task:</td>
                                                <td valign="middle" width="12%"><Input class="itemfont" style="width:120px;" Name="Task" id="Task" value = <%if Task <>"" then%>"<%=Task%>"<%end if%>>                           </td>
                                                <td><a class=itemfontlink href="javascript:getSearch();"><img class="imagelink" src="images/icongo01.gif"></a></td>
                                                <td align="left" width="57%" class=toolbar>Find</td>
                                            </tr>   
                                            <tr class=columnheading>
                                                <td colspan="7" height=20>&nbsp;</td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>     
                                <tr>
                                    <td>
                                        <table width=100% border=0 cellpadding=0 cellspacing=0>
                                            <tr class=columnheading height=20>
                                                <td valign="middle" width=2%>&nbsp;</td>
                                                <td valign="middle" width=30%>Task</td>
                                                <td width="17%" align="center">Cancellable</td>
                                                <td width="17%" align="center">Out of Area</td>
                                                <td width="17%" align="center">Bed Night Away</td>
                                                <td width="17%" align="center">
													<% if strHQTasking = 1 then %>
                                                        HQ Task
                                                    <% end if %>
                                                </td>  
                                            </tr>
                                            <tr>
                                                <td colspan=6 class=titlearealine  height=1></td> 
                                            </tr>
                                            <%if rsRecSet.recordcount > 0 then%>
                                                <% Row = 0 %>
                                                <% do while Row < recordsPerPage %>
                                                    <tr class=itemfont id="TableRow<%=rsRecSet ("TaskID")%>" height=30 <%if counter=0 then%>style="background-color:<%=color1%>;"<%else%>style="background-color:<%=color2%>;"<%end if%>>
                                                        <td width="2%">&nbsp;</td>
                                                        <td valign="middle" width="30%"><a class=itemfontlink href="AdminPsTaDetail.asp?RecID=<%=rsRecSet("TaskID")%>"><%=rsRecSet("Task")%></a></td>
                                                        <td valign="middle" align="center" width="17%">
                                                            <% if rsRecSet("cancellable")=true then %>
                                                                <img src="images/yes.gif">
                                                            <% else %>
                                                                <img src="images/no.gif">
                                                            <% end if %>
                                                        </td>
                                                        <td valign="middle" align="center" width="17%">
                                                            <% if rsRecSet("ooa") = 1 then %>
                                                                <img src="images/yes.gif">
                                                            <% else %>
                                                                <img src="images/no.gif">
                                                            <% end if %>	
                                                        </td>
                                                        <td valign="middle" align="center" width="17%">
                                                            <% if rsRecSet("ooa") = 2 then %>
                                                                <img src="images/yes.gif">
                                                            <% else %>
                                                                <img src="images/no.gif">
                                                            <% end if %>							
                                                        </td>
                                                        <td valign="middle" align="center" width="17%">
															<% if strHQTasking = 1 then %>
																<% if rsRecSet("hqTask") = true then %>
                                                                    <img src="images/yes.gif">
                                                                <% else %>
                                                                    <img src="images/no.gif">
                                                                <% end if %>
                                                            <% end if %>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td colspan=6 class=titlearealine  height=1></td>
                                                    </tr>
                                                    <% Row = Row + 1 %>
                                                    <% rsRecSet.MoveNext %>
                                                    <% if counter = 0 then %>
                                                        <% counter = 1 %>
                                                    <% end if %>
                                                    <% if counter = 1 then %>
                                                        <% counter = 0 %>
                                                    <% end if %>                                        
                                                <% loop %>
                                                <tr height=22px>
                                                    <td colspan=6>&nbsp;</td>
                                                </tr>
                                                <tr align="center">
                                                    <td colspan=6>
                                                        <table border=0 cellpadding=0 cellspacing=0>
                                                            <tr>
                                                                <td class=itemfont>Results Pages:&nbsp;</td>
                                                                <td class=ItemLink>
                                                                    <% if int(page) > 1 then %>
                                                                        <a href="javascript:MovetoPage(<%=page-1%>);" class=ItemLink><< Previous</a>
                                                                    <% else %>
                                                                        << Previous
                                                                    <% end if %>
                                                                </td>
                                                                <td class=itemfont>&nbsp;&nbsp;</td>
                                                                <% pagenumber = beginAtPage %>
                                                                    <td>
                                                                <% do while pagenumber <= endAtPage %>
																	<% if page <> pagenumber then %>
                                                                        <a class=ItemLink href="javascript:MovetoPage(<%=pagenumber%>);"><%=Pagenumber%></a><% if pagenumber < (endAtPage) then %><font class=itemfont>,</font><% end if %>
                                                                    <% else %>
                                                                        <a class="itemfontbold"><%=Pagenumber%></a><% if pagenumber < (endAtPage) then %><font class=itemfont>,</font><% end if %>
                                                                    <% end if %>                                                                                                                                                                                                                
                                                                    <% pageNumber = pageNumber + 1 %>
                                                                <% loop %>
                                                                    </td>
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
                                                <tr class=itemfont  height=20>
                                                    <td valign="middle" width=1%>&nbsp;</td>
                                                    <td class=itemfontlink valign="middle" colspan=7>Your search returned no results</td>
                                                </tr>
                                                <tr>
                                                    <td colspan=6 class=titlearealine  height=1></td>
                                                </tr>
                                            <% end if %>
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
<%
rsRecSet.close
set rsRecSet=Nothing
con.close
set con=Nothing
%>
</body>
</html>

<script language="JavaScript">

function MovetoPage (PageNo)
{
	document.forms["frmDetails"].elements["Page"].value = PageNo;
	document.forms["frmDetails"].submit();
}

function getSearch()
{
	 document.frmDetails.submit();
}

</Script>
