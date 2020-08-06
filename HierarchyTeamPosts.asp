<!DOCTYPE HTML >
<!--#include file="Includes/security.inc"--> 
<!--#include file="Connection/Connection.inc"-->
<%
tab=3
noPlannerTab="1"
if Session("openfield") = "" or request("openfield") <> "" then
  Session("openfield") = request("openfield")
end if

strTable = "tblTeam"    
strGoTo = "HierarchyTeamDetail.asp"    
strTabID = "teamID"                      

'response.write strGoTo
'response.End()

set objCmd = server.CreateObject("ADODB.Command")
set objPara = server.CreateObject("ADODB.Parameter")
objCmd.ActiveConnection = con
objCmd.Activeconnection.cursorlocation = 3
objCmd.CommandText = "spTeamPostSummary"	
objCmd.CommandType = 4				
set objPara = objCmd.CreateParameter ("TeamID",3,1,5, request("RecID"))
objCmd.Parameters.Append objPara
set rsRecSet = objCmd.Execute	

' make sure we set the levelID to EITHER the parent if its Wing/Sqn/Flt
' OR if its a TEAM then the actual teamID
tmLevel = rsRecSet("teamIn")
IF tmLevel < 4 THEN
  tmLevelID = rsRecSet("ParentID")
ELSE
  tmLevelID = request("RecID")
  tmLevel=5
END IF  
%>

<html>

<head>  

<!--#include file="Includes/IECompatability.inc"-->
<title>Flight Details</title>
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
</style></head>
<body>
<form  action="" method="POST" name="frmDetails">
<Input name=RecID type=Hidden value=<%=request("RecID")%>>

<Input name=Page type=Hidden value=1>
			  <table border=0 cellpadding=0 cellspacing=0 width=100%>
<!--#include file="Includes/hierarchyTeamDetails.inc"-->
				<tr height=16 class=SectionHeader>
				  <td>
					<table border=0 cellpadding=0 cellspacing=0 >
<%if session ("administrator")=1 then%>
						<td class=toolbar width=8></td><td width=20><a class=itemfontlink href="HierarchyTeamPostsAdd.asp?RecID=<%=request("RecID")%>"><img class="imagelink" src="images/editgrid.gif"></A></td>
						<td class=toolbar valign="middle" >Add Posts</td>
						<td class=titleseparator valign="middle" width=14 align="center">|</td>
						<td class=toolbar width=8></td><td width=20><a class=itemfontlink href="HierarchyTeamPostsRemove.asp?RecID=<%=request("RecID")%>"><img class="imagelink" src="images/editgrid.gif"></A></td>
						<td class=toolbar valign="middle" >Remove Posts</td>
<%end if%>
						<td class=titleseparator valign="middle" width=14 align="center">|</td>
						<!--<td class=toolbar valign="middle" ><A class=itemfontlink href="ManningTeamDetail.asp?RecID=<%''=request("RecID")%>">Back</A></td>	-->
						<td class=toolbar valign="middle" ><A class=itemfontlink href="<%=strGoTo & "?RecID=" & request("RecID")%>">Back</A></td>																					
					</table>
				  </td>
				</tr>
				<tr>
				  <td>
					<table width=100% border=0 cellpadding=0 cellspacing=0>
					  <tr height=16>
						<td></td>
					  </tr>
					  <tr class=columnheading height=22>
					    <td valign="middle" width=2%></td>
						<td valign="middle" width=12%>Unit:</td>
						<td valign="middle" width=83% class=itemfont><%=rsRecSet("Description")%></td>
						<td valign="middle" width=2%></td>
					  </tr>
					  <tr class=columnheading height=22>
			            <td valign="middle" width=2%></td>
						<td valign="middle"  >Parent Type:</td>
						<td valign="middle"  class=itemfont ><%=rsRecSet("TeamInName")%></td>
						<td></td>
					  </tr>
					  <tr class=columnheading height=22>
			            <td valign="middle" width=2%></td>
						<td valign="middle"  >Parent:</td>
						<td valign="middle"  class=itemfont ><%=rsRecSet("ParentDescription")%></td>
						<td></td>
					  </tr>
					  <tr class=columnheading height=22>
			            <td valign="middle" width=2%></td>
						<td valign="middle"  >Team Size:</td>
						<td valign="middle"  class=itemfont ><%=rsRecSet("Teamsize")%></td>
						<td></td>
					  </tr>
					  <!--
					  <tr class=columnheading height=22>
			            <td valign="middle" width=2%></td>
						<td valign="middle"  >Control Post:</td>
						<td valign="middle"  class=itemfont ><%if rsRecSet("TeamCP")=true then response.write "Yes" else response.write "No" end if%></td>
						<td></td>
					  </tr>
					  -->
					  <tr class=columnheading height=22>
			            <td valign="middle" width=2%></td>
						<td valign="middle"  >Team Weight:</td>
						<td valign="middle"  class=itemfont ><%=rsRecSet("Weight")%></td>
						<td></td>
					  </tr>
					  
					  
					  <tr height=16>
						<td></td>
					  </tr>
					  <tr>
       					<td colspan=5 class=titlearealine  height=1></td> 
     				  </tr>




					</table>
				  </td>
				</tr>
				<tr height=16 class=SectionHeader>
				  <td>
					<table border=0 cellpadding=0 cellspacing=0 >
					  <td class=toolbar width=8></td>
					    <td class=toolbar valign="middle" >Current Posts Assigned to this Unit:</td>
					</table>
				  </td>
				</tr>
				<tr>
					<td>
						<table width=64% border=0 cellpadding=0 cellspacing=0>
							<tr height=16>
								<td></td>
							</tr>
							<tr colspan=7 height=16>
								<td></td>
							</tr>

					</table>
					</td>
				</tr>

</form>
<%set rsRecSet=rsRecSet.nextrecordset%>
<%if  isObject(rsRecSet) then%>
<form  action="UpdateStaffPost.asp" method="POST" name="frmPosts">
<Input name=RecID type=Hidden value=<%=request("RecID")%>>

				<tr>
					<td>
						<table width=64% border=0 cellpadding=0 cellspacing=0>
							<tr class=itemfont height=20>
								<td valign="middle" width=2%></td>
								<td colspan=5 valign="middle" >Search Results: <Font class=searchheading>records found: <%=rsRecSet.recordcount%></Font></td>
							</tr>
							<tr>
								<td colspan=6 class=titlearealine  height=1></td> 
							</tr>
							<tr class=columnheading height=20>
							  <td valign="middle" width=2%></td>
							  <td valign="middle" width=33%>Post</td>
							  <td valign="middle" align="center" width=20%>Assign No</td>
							  <td valign="middle" align="center" width=20%>Team</td>
							  <td valign="middle" align="center" width=>Manager</td>
							  

							  
							</tr>
							<tr>
							  <td colspan=6 class=titlearealine  height=1></td> 
							</tr>
<%if rsRecSet.recordcount > 0 then%>
<%	if request("page")<>"" then
		page=int(request("page"))
	else
		page=1
	end if
	recordsPerPage = 10
		
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
							<%Row=0%>
							<%do while Row < recordsPerPage%>
							

							<tr  ID="TableRow<%=Row%>" class=toolbar height=20>
								<td valign="middle" width=2%></td>

								<td valign="middle">
<%if session("administrator") then%>
								<A class=itemfontlink href="HierarchyTeamPostDetail.asp?RecID=<%=rsRecSet("PostID")%>&TeamID=<%=request("RecID")%>&tmLevelID=<%=tmLevelID%>&tmLevel=<%=tmLevel%>">
								<%=rsRecSet("description")%></A>
<%else%>								
<%=rsRecSet("description")%>
								</td>
<%end if%>
								<td valign="middle" align="center"><%=rsRecSet("assignno")%></td>
								<td valign="middle" align="center"><%=rsRecSet("team")%></td>
								<td valign="middle" align="center">
								<%if rsRecSet("manager")=true then%>
									 <img src="images/yes.gif">
									 <%Else%>
									 <img src="images/no.gif">
									 <%End if%> 
								</td>
			
								
							</tr>
							<tr>
								<td colspan=6 class=titlearealine  height=1></td> 
							</tr>
							<%row=row+1%>
							<%rsRecSet.MoveNext
							Loop%>

							<tr height=22px>
								<td colspan=6></td>
							</tr>
							
							<tr align="center">
								<td colspan=6>
									<table  border=0 cellpadding=0 cellspacing=0>
										<tr>
											<td class=itemfont>Results Pages: &nbsp;</td>
											
											<td class=ItemLink>
											<%if int(page) > 1 then%>
											<A href="javascript:MovetoPage(<%=page-1%>);" class=ItemLink><< Previous</td>
											<%else%>
											<< Previous
											<%end if%>
											<td class=itemfont>&nbsp;&nbsp;</td>
											
											<%pagenumber=beginAtPage%>
											<%do while pagenumber <= endAtPage%>
											<td ><A<%if page <> pagenumber then 
											response.write (" class=ItemLink ")%>
											href="javascript:MovetoPage(<%=pagenumber%>);"
											<%else
											response.write (" class=itemfontbold")
											end if%>>
											<%=Pagenumber%></A><%if pagenumber < (endAtPage) then%><font class=itemfont>,</font><%end if%></td>
											<%pageNumber=pageNumber+1
											loop%>
											<td class=itemfont>&nbsp;&nbsp;</td><td class=ItemLink>
											<%if int(page) < int(endAtPage) then%>
											<A href="javascript:MovetoPage(<%=page+1%>);" class=ItemLink>Next >></A>
											<%else%>
											Next >>
											<%end if%>
											</td>
										</tr>
									</table>
								</td>
							</tr>
<%else%>
							<tr class=itemfont  height=22>
								<td valign="middle"  width=2%></td>
								<td align="center"    valign="middle" colspan=5 >Your search returned no results</td>
							</tr>
							<tr>
								<td colspan=6 class=titlearealine  height=1></td> 
							</tr>
<%end if%>
						</table>
					</td>
				</tr>
</form>
<%End if%>		      

			  </table>

<%
rsRecSet.close
set rsRecSet=Nothing
con.close
set con=Nothing
%>
</body>
</html>

<SCRIPT LANGUAGE="JavaScript">
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
