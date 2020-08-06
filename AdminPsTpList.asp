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
objCmd.CommandText = strCommand
objCmd.Activeconnection.cursorlocation = 3
objCmd.CommandType = 4		

' 'first find out whether its an HQ Tasking Group - cos if it is then we display HQ Task details
strCommand = "spCheckHqTask"
objCmd.CommandText = strCommand
objCmd.CommandType = 4		

set objPara = objCmd.CreateParameter ("StaffID",3,1,0, session("StaffID"))
objCmd.Parameters.Append objPara
set objPara = objCmd.CreateParameter ("HQTasking",3,2)
objCmd.Parameters.Append objPara
objCmd.Execute	             ' 'Execute CommandText when using "ADODB.Command" object
strHQTasking   = objCmd.Parameters("HQTasking") 

' 'Now Delete the parameters
objCmd.Parameters.delete ("StaffID")
objCmd.Parameters.delete ("HQTasking")

'set objPara = objCmd.CreateParameter ("TableName",200,1,50, strTable)
'objCmd.Parameters.Append objPara
' 'set rsRecSet = objCmd.Execute	' 'Execute CommandText when using "ADODB.Command" object

strCommand = "spListTaskTypes"
objCmd.CommandText = strCommand
objCmd.CommandType = 4		
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
	''if session("tSearchStartDate") <> "" then 
	''	startDate = session("tSearchStartDate")
	''else
	''	startDate=""
	''end if
	''if session("tSearchEndDate") <> "" then 
	''	endDate = session("tSearchEndDate")
	''else
	''	endDate=""
	''end if

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

<head> 

<!--#include file="Includes/IECompatability.inc"-->

<title><%= PageTitle %></title>
<link rel="stylesheet" type="text/css" href="Includes/AMDB.css" media="Screen"/>
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
<form  action="AdminPsTaList.asp" method="POST" name="frmDetails">
<Input name="HiddenDate" id="HiddenDate" type="hidden" >
<Input name="HiddenStartDate" id="HiddenStartDate" type="hidden" >
<Input name="HiddenEndDate"  id="HiddenEndDate" type="hidden" >
<Input name="DoSearch" id="DoSearch" type="Hidden" value=1>
<Input name="Page" id="Page" type="Hidden" value=1>
<Input name="Sort"  id="Sort" type="Hidden" value=<%=sort%>>

	<table  height="100%" cellspacing=0 cellPadding=0 width=100% border=0>
      <tr>
        <td>
          <!--#include file="Includes/Header.inc"--> 
  		  <table cellSpacing=0 cellPadding=0 width=100% border=0 >
    	    <tr >
      		  <td align="center" class="sidemenuwidth" ><img alt="" src="images/spssites.gif" ></td>
       		  <td  class=titlearea >CMS<BR>
       		  <span class="style1"><Font class=subheading>Personnel Task </Font></span></td>
    		</tr>
  			<tr>
       		  <td colspan=2 class=titlearealine  height=1></td> 
     		</tr>
  		  </table>
  		  <table width=100% height='<%=session("heightIs")%>px' border=0 cellpadding=0 cellspacing=0 > 
      		<tr valign=Top>
        	  <td width="200" background="Images/tableback.png" class="sidemenuwidth">
			     <!--#include file="Includes/ptmenu.inc"-->
				</td> 
				  <td width=10></td>
				  <td width="830" align=left >
				    <table border=0 cellpadding=0 cellspacing=0 width=80%>
					  <tr height=16 class=SectionHeader>
					    <td>
						  <table width="203" height="17" border=0 cellpadding=0 cellspacing=0 >
						    <tr>
							  <td class=toolbar width=11></td>
							  <td width=22><a class=itemfontlink href="AdminPsTaAdd.asp"><img class="imagelink" src="images/newitem.gif"></a></td>
							  <td width="153" valign="middle" class=toolbar >New Personnel Task</td>
							  <td class=titleseparator valign="middle" width=17 align="center">|</td>
							</tr>  
					      </table>
						</td>
					  </tr>
                      <tr>
                        <td>
                          <table width=100% border=0 cellpadding=0 cellspacing=0>
                      <tr class=columnheading height=20>
							  <td valign="middle"  width=130px>Task Type:</td>
							  <td width=10px></td>
    						  <td valign="middle"  width=100px>Task:</td>
							  <td width=10px></td>
                      </tr>
                      <tr class=columnheading height=20>
						<td valign="middle"  width=100px><select  class="itemfont " name="ttID"  id="ttID" style="width:120px;" onChange="frmDetails.submit();">
                          <option value=0 >All</option>
                          <%Do while not rsTaskTypeList.eof%>
                          <option value=<%=rsTaskTypeList("ttID")%><%if int(ttID)=int(rsTaskTypeList("ttID")) then response.write " selected "%> > <%=rsTaskTypeList("Description")%> </option>
                          <%rsTaskTypeList.MoveNext
								Loop%>
                        </select></td>
					    <td width=10px></td>
						   <td valign="middle"  width=100px>
							  <Input class="itemfont" style="width:120px;" Name="Task" id="Task" value = <%if Task <>"" then%>"<%=Task%>"<%end if%>>                           </td>
                           							   <td width=20><a class=itemfontlink href="javascript:getSearch();"><img class="imagelink" src="images/icongo01.gif"></a></td>
							   <td class=toolbar valign="middle" >Find</td>
                      </tr>   
                      </table>
                      </td>
                      </tr>  

					  <tr>
					    <td>
						  <table width=100% border=0 cellpadding=0 cellspacing=0>
						    <tr class=columnheading height=20>
							  <td valign="middle" width=1%></td>
							  <td valign="middle" width=26%>Task </td>
							  <td width="16%" align="center" valign="middle" class="mouseHand" onClick="javascript:SortByCol4 ();">Cancellable
                                <%if sort=7 then%>
                              <img src="images/searchUp.jpg">
                              <%end if%>
                              <%if sort=8 then%>
                              <img src="images/searchDown.jpg">
                            <%end if%></td>
                            <td width="18%">Out of Area </td>
							<td width="18%">Bed Night Away </td>
							<% if strHQTasking = 1 then %>
							  <td width="8%">HQ Task </td>
							<% end if %>  
							<td width="3%"> </td>

							  <td valign="middle" width=6%></td>
							  <td valign="middle" width=22%></td>
							</tr>
						  	<tr>
       						  <td colspan=10 class=titlearealine  height=1></td> 
     					    </tr>
                          <%if rsRecSet.recordcount > 0 then%>
                          <%Row=0%>
                          <%do while Row < recordsPerPage%>
                          <tr class=itemfont id="TableRow<%=rsRecSet ("TaskID")%>" height=20 <%if counter=0 then%>style="background-color:<%=color1%>;"<%else%>style="background-color:<%=color2%>;"<%end if%>>
                            <td valign="middle" ></td>
                            <!-- <td valign="middle"><a class=itemfontlink href="ManningTaskPersonnel.asp?RecID=<%=rsRecSet("TaskID")%>"><%=rsRecSet("Task")%></a></td> -->
                            <td valign="middle"><a class=itemfontlink href="AdminPsTaDetail.asp?RecID=<%=rsRecSet("TaskID")%>"><%=rsRecSet("Task")%></a>
                            </td>

                            <td valign="middle" align="center"><%if rsRecSet("cancellable")=true then%>
                                <img src="images/yes.gif">
                                <%Else%>
                                <img src="images/no.gif">
                            <%End if%>							</td>
                            <td valign="middle" align="center"><%if rsRecSet("ooa")=1 then%>
                              <img src="images/yes.gif">
                                <%Else%>
                                <img src="images/no.gif">
                            <%End if%>	
							</td>
							<td valign="middle" align="center"><%if rsRecSet("ooa")=2 then%>
                              <img src="images/yes.gif">
                                <%Else%>
                                <img src="images/no.gif">
                            <%End if%>							
						</td>
							<% if strHQTasking = 1 then %>
                              <td width="8%" align="center" valign="middle">
<%if rsRecSet("hqTask")=true then%>
                                       <img src="images/yes.gif">
                                   <%Else%>
                                       <img src="images/no.gif">
                            <%End if%>						    </td>
							<% end if %>
							<td width="3%"  valign="middle" ></td>
                            <td width="6%"  valign="middle" ></td>
                          </tr>
                          <tr>
                            <td colspan=10 class=titlearealine  height=1></td>
                          </tr>
                          <%
							Row=Row+1
							rsRecSet.MoveNext
									if counter=0 then
										counter=1
										else
											if counter=1 then counter=0
										end if

							Loop%>
                                                      <tr height=22px>
                            <td colspan=8></td>
                          </tr>
                          <tr align="center">
                            <td colspan=8><table  border=0 cellpadding=0 cellspacing=0>
                                <tr>
                                  <td class=itemfont>Results Pages: &nbsp;</td>
                                  <td class=ItemLink><%if int(page) > 1 then%>
                                    <a href="javascript:MovetoPage(<%=page-1%>);" class=ItemLink><< Previous</a></td>
                                  <%else%>
                                  << Previous
                                  <%end if%>
                                  <td class=itemfont>&nbsp;&nbsp;</td>
                                  <%pagenumber=beginAtPage%>
                                  <%do while pagenumber <= endAtPage%>
                                  <td ><a<%if page <> pagenumber then 
															response.write (" class=ItemLink ")%>
															href="javascript:MovetoPage(<%=pagenumber%>);"
															<%else
															response.write (" class=itemfontbold")
															end if%>> <%=Pagenumber%></a>
              <%if pagenumber < (endAtPage) then%>
                                    <font class=itemfont>,</font>
                                    <%end if%></td>
                                  <%pageNumber=pageNumber+1
															loop%>
                                  <td class=itemfont>&nbsp;&nbsp;</td>
                                  <td class=ItemLink><%if int(page) < int(endAtPage) then%>
              <a href="javascript:MovetoPage(<%=page+1%>);" class=ItemLink>Next >></a>
              <%else%>
                                    Next >>
                                    <%end if%>                                  </td>
                                </tr>
                            </table></td>
                          </tr>
                          <%else%>
                          <tr class=itemfont  height=20>
                            <td valign="middle"  width=1%></td>
                            <td class=itemfontlink valign="middle" colspan=7>Your search returned no results</td>
                          </tr>
                          <tr>
                            <td colspan=8 class=titlearealine  height=1></td>
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
</form>
<%
rsRecSet.close
set rsRecSet=Nothing
con.close
set con=Nothing
%>
</body>
</html>

<SCRIPT LANGUAGE="JavaScript">
function MovetoPage (PageNo) {
	document.forms["frmDetails"].elements["Page"].value = PageNo;
	document.forms["frmDetails"].submit();
}

function getSearch(){
	 
	 //changeDate();
	 	 
	 document.frmDetails.submit();
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
