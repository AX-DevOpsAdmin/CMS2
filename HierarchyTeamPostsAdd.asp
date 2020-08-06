<!DOCTYPE HTML >
<!--#include file="Includes/security.inc"--> 
<!--#include file="Connection/Connection.inc"-->
<%
tab=3
strTable = "tblTeam"    
strGoTo = "hierarchyTeamDetail.asp"   
strTabID = "teamID"                      

set objCmd = server.CreateObject("ADODB.Command")
set objPara = server.CreateObject("ADODB.Parameter")
objCmd.ActiveConnection = con
objCmd.Activeconnection.cursorlocation = 3

if request("dosearch")=1 then
	description = request("Description")
	assignNo = request("Assignno")
else
	description = "9999"
	assignNo = "9999"
end if

objCmd.CommandText = "spTeamPostAvailableToAdd"	
objCmd.CommandType = 4				
set objPara = objCmd.CreateParameter ("TeamID",3,1,5, request("RecID"))
objCmd.Parameters.Append objPara
set objPara = objCmd.CreateParameter ("Description",200,1,50, description)
objCmd.Parameters.Append objPara
set objPara = objCmd.CreateParameter ("Assignno",200,1,50, assignNo)
objCmd.Parameters.Append objPara
set rsRecSet = objCmd.Execute	

checkedPosts=request("currentlyChecked")
if checkedPosts <> "" then 
	strCheckedPosts = split(checkedPosts, ",")
	whereString=" postID=" & strCheckedPosts(1)
	if UBound(strCheckedPosts)>1 then
		FOR intCount = 2 TO (UBound(strCheckedPosts))
			if strCheckedPosts(intCount) <>"" then whereString=whereString+" or postID=" & strCheckedPosts(intCount)
		Next
	end if
	objCmd.CommandType = 1
	objCmd.CommandText = "select * from tblPost where " &  whereString & " order by description"
	set testRS = objCmd.Execute
end if
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
<form  action="" method="post" name="frmDetails">
<Input name=RecID type=Hidden value=<%=request("RecID")%>>
<Input name=DoSearch type=Hidden value=1>
<Input name=Page type=Hidden value=1>
<input name="currentlyChecked" type=hidden value=<%=request("currentlyChecked")%>>

						<table border=0 cellpadding=0 cellspacing=0 width=100%>
				<!--#include file="Includes/hierarchyTeamDetails.inc"-->				
							<tr height=16 class=SectionHeader>
								<td colspan=2>
									<table border=0 cellpadding=0 cellspacing=0 >
										<td class=toolbar width=8><td width=20><img id="SaveCloseLink" class="imagelink" src="images/editgrid.gif" onclick="saveNew();"></td>
										<td class=toolbar valign="middle" >Save and Close</td>
										<td class=titleseparator valign="middle" width=14 align="center">|</td>
										<td class=toolbar valign="middle" ><A class=itemfontlink href="HierarchyTeamPosts.asp?RecID=<%=request("RecID")%>">Back</A></td>											
									</table>
				  				</td>
							</tr>
							<tr>
				  				<td colspan=2>
									<table width=100% border=0 cellpadding=0 cellspacing=0>
										<tr height=16>
										<td></td>
										</tr>
										<tr class=columnheading height=22>
											<td valign="middle" width=2%></td>
											<td valign="middle" width=18%>Unit:</td>
											<td valign="middle" width=76% class=itemfont><%=rsRecSet("Description")%></td>
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
<%set rsRecSet=rsRecSet.nextrecordset
if request("page")<>"" then
	page=int(request("page"))
else
	page=1
end if

%>
							<tr height=16 class=SectionHeader>
				  				<td colspan=2>
									<table border=0 cellpadding=0 cellspacing=0 >
										<tr>
					  						<td class=toolbar width=8></td>
					    					<td class=toolbar valign="middle" >Posts Available to Assigned to this Unit:</td>
										</tr>
									</table>
				  				</td>
							</tr>
							<tr>
								<td colspan=2>
									<table width=64% border=0 cellpadding=0 cellspacing=0>
										<tr height=16>
											<td></td>
										</tr>
										<tr class=searchheading height=22>
											<td valign="middle" width=2%></td>
											<td valign="middle" width=15%>Description:</td>
											<td valign="middle" width=32%>
											<INPUT class="itemfont" style="WIDTH: 150px" maxLength=20 name=description value=<%=request("description")%>></td>
											<td valign="middle" width=2%></td>
											<td valign="middle" width=15%>Assign No:</td>
											<td valign="middle" width=32% >
											<INPUT class="itemfont" style="WIDTH: 150px" maxLength=20 name=assignno value=<%=request("assignno")%>> 
											</td>
											<td valign="middle" ></td>
											<td width=20><a class=itemfontlink href="javascript:goFind();"><img class="imagelink" src="images/icongo01.gif"></a></td>
											<td class=toolbar valign="middle" >Find</td>
										</tr>
										<tr colspan=7 height=16>
											<td></td>
										</tr>
									</table>
								</td>
							</tr>
</form>

<%if  isObject(rsRecSet) then%>
<form  action="UpdateTeamPost.asp" method="post" name="frmPostDetails">
<Input name=RecID type=Hidden value=<%=request("RecID")%>>
<input name="newattached" type="hidden" value="">
<input type="hidden" name="ReturnTo" value="HierarchyTeamPosts.asp"/>
</form>
<form  action="UpdateTeamPost.asp" method="post" name="frmPosts">
							<tr>
								<td valign=top>
									<table width=100% border=0 cellpadding=0 cellspacing=0>
										<tr class=itemfont height=20>
											<td valign="middle" width=2%></td>
											<td colspan=4 valign="middle" >Search Results: <Font class=searchheading>records found: <%=rsRecSet.recordcount%></Font></td>
										</tr>
										<tr>
											<td colspan=5 class=titlearealine  height=1></td> 
										</tr>
										<tr class=columnheading height=20>
											<td valign="middle" width=2%></td>
											<td valign="middle" width=33%>Post</td>
											<td valign="middle" align="center" width=20%>Assign No</td>
											<td valign="middle"  width=>Team</td>
											<td valign="middle" width=15% align="center">select</td>
										</tr>
										<tr>
											<td colspan=5 class=titlearealine  height=1></td> 
										</tr>
	<%if rsRecSet.recordcount > 0 then%>
	<%	if request("page")<>"" then
			page=int(request("page"))
		else
			page=1
		end if
		recordsPerPage = 15
			
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
											<td valign="middle"><%=rsRecSet("description")%></td>
											<td valign="middle" align="center"><%=rsRecSet("assignno")%></td>
											<td valign="middle"><%=rsRecSet("team")%></td>
											<td valign="middle" align="center" ><input type="checkbox" name=PostID<%=rsRecSet("PostID")%> value=<%=rsRecSet("PostID")%><%if Instr(request("currentlyChecked"),rsRecSet("PostID")) >0 then response.write(" checked")%>  onclick="javascript:addRemovePost(this.checked,'<%=rsRecSet("description")%>','<%=rsRecSet("assignno")%>');"></td>								
										</tr>
										<tr>
											<td colspan=5 class=titlearealine  height=1></td> 
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
<%selectedColspan=4%>
								<td valign=Top width=40%>
									<table  id=checkedPostsTable align="center" border=0 bgcolor=#eeeeee cellpadding=0 cellspacing=0 width=90%>
										<tr>
											<td align="center" height=20 colspan=<%=selectedColspan%> class=itemfont>Currently Selected Posts:</td>
										</tr>
										<tr>
										  <td  class=titlearealine  height=1 colspan=<%=selectedColspan%>></td> 
										</tr>
			
										<tr height=20  class=columnheading >
											<td width=2%></td><td width=60%>Post</td><td >Assign No</td><td width=2%></td>
										</tr>
										<tr>
										  <td  class=titlearealine  height=1 colspan=<%=selectedColspan%>></td> 
										</tr>
	<%if isObject(testRS) then%>
							<%do while not testRS.eof%>
										<tr id = <%=testRS("Assignno")%> height=20  class=toolbar >
											<td width=2%></td><td ><%=testRS("Description")%></td><td><%=testRS("Assignno")%></td><td width=2%></td>
										</tr>
										<tr>
										  <td colspan=<%=selectedColspan%> class=titlearealine  height=1></td> 
										</tr>
							<%testRS.movenext%>
							<%loop%>
	<%else%>
										<!--<tr height=20  class=itemfont>
											<td align="center" colspan=<%=selectedColspan%>>No Posts Currently Selected</td>
										</tr>
										<tr>
										  <td colspan=<%=selectedColspan%> class=titlearealine  height=1></td> 
										</tr>-->
	<%end if%>
									</table>
								</td>	
							</tr>
</form>
<%end if%>		      
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


/* clicked the SUBMIT button - so write the changes to the database  via writeGroups.asp */
var currentlyChecked="Start";


function addRemovePost(checked,Post,thisRow){
	//document.getElementById('checkedList').innerHTML = ajaxRequest.responseText;
	
	var rowLength = document.getElementById("checkedPostsTable").rows.length; //Get Number of Rows in Table
	var tbody = document.getElementById("checkedPostsTable").tBodies[0]; //Table to be used 
	if (checked==true){//Adding or removing row
	if(!document.getElementById(thisRow)){	
	var row = document.createElement("TR");//Start Row creation
	row.setAttribute("height","20");		
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


	//rowID= document.getElementById(thisRow);
	//alert("rowid" + rowID.childNodes[2].innerHTML);
	//alert("rowid" + tbody.childNodes.length);
	//alert("rowid" + tbody.childNodes[5].id);
	}
	} else{
	for (i=0;i<tbody.childNodes.length;i++){ //Iterate through rows in table
		if( tbody.childNodes[i].id == thisRow) {//Our row?
			//tbody.removeChild(5);
			//alert("rowid:" + tbody.childNodes[i].id + "," + i);
			rowID= document.getElementById(thisRow);//Identify row
			//tbody.removeChild(rowID);
			document.getElementById('checkedPostsTable').deleteRow(i);
			document.getElementById('checkedPostsTable').deleteRow(i-1);
			//Remove the row
			break;
			}
		}
	}

}

function saveNew(){
    /* now build the section list - if any - to be removed */

/* now build hidden value with list of Locations to submit so the 
program writelocations can update database */
	var newattached="start";
	var stringToCheck = document.frmDetails.currentlyChecked.value
	for (var i = 0; i < document.frmPosts.elements.length; i++){
		currentValue=document.frmPosts.elements[i].value;
		if (document.frmPosts.elements[i].checked==true) {
			if (stringToCheck.indexOf(currentValue)<0){
				newattached = newattached + "," + document.frmPosts.elements[i].value;
			}
		}
	}
    document.frmPostDetails.newattached.value = newattached + document.frmDetails.currentlyChecked.value;
	
	if(document.frmPostDetails.newattached.value=="start") {
		alert("Select at least one post")
		return;	  		
	} 

	document.frmPostDetails.submit();
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


	var stringToCheck = document.frmDetails.currentlyChecked.value

	for (var i = 0; i < document.frmPosts.elements.length; i++){
		var currentValue=document.frmPosts.elements[i].value;
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

function goFind() {
 
MovetoPage (<%=1%>);
/*document.frmDetails.currentlyChecked.value="";
frmDetails.submit()*/

}

</Script>
