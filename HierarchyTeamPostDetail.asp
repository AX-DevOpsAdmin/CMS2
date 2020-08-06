<!DOCTYPE HTML >

<!--#include file="Includes/security.inc"--> 
<!--#include file="Connection/Connection.inc"-->

<%
tab=3
noPlannerTab="1"
strTable = "tblpost"
strGoTo = "ManningPostList.asp"   ' asp page to return to once record is deleted
strTabID = "postID"              ' key field name for table        
TeamID=request("TeamID")
set objCmd = server.CreateObject("ADODB.Command")
set objPara = server.CreateObject("ADODB.Parameter")
objCmd.ActiveConnection = con

objCmd.CommandText = "spTeamPostSummary"	
objCmd.CommandType = 4				
set objPara = objCmd.CreateParameter ("TeamID",3,1,5, request("TeamID"))
objCmd.Parameters.Append objPara
set rsTeamDetail = objCmd.Execute	

for x = 1 to objCmd.parameters.count
	objCmd.parameters.delete(0)
next

tmLevel = rsTeamDetail("teamIn")
IF tmLevel < 4 THEN
  tmLevelID = rsTeamDetail("ParentID")
ELSE
  tmLevelID = request("teamID")
  tmLevel=5
END IF  

objCmd.CommandText = "spPostDetail"	'Name of Stored Procedure
objCmd.CommandType = 4				'Code for Stored Procedure
set objPara = objCmd.CreateParameter ("PostID",3,1,5, request("RecID"))
objCmd.Parameters.Append objPara
set rsRecSet = objCmd.Execute	'Execute CommandText when using "ADODB.Command" object

' make sure we set the levelID to EITHER the parent if its Wing/Sqn/Flt OR if its a TEAM then the actual teamID
' now see if we can delete it - if it has no children then we can return parameter for Delete check
objCmd.CommandText = "spPostDel"	'Name of Stored Procedure
set objPara = objCmd.CreateParameter("@DelOK",3,2)
objCmd.Parameters.Append objPara
objCmd.Execute	

strDelOK = objCmd.Parameters("@DelOK")
%>

<html>

<head>  

<!--#include file="Includes/IECompatability.inc"-->
<title>Flight Details</title>
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
<form  action="UpdateHierarchyTeamPostDetail.asp" method="POST" name="frmDetails">
  <input type=hidden name=recID value=<%=request("recID")%>>
  <input type="hidden" name=tmLevelID value="<%=tmLevelID%>">
  <input type="hidden" name=tmLevel value="<%=tmLevel%>">
  <input type="hidden" name=TeamID value="<%=TeamID%>">
  <input name="thisDate" type="hidden" value="<%=request("thisDate")%>">

			  <table border=0 cellpadding=0 cellspacing=0 width=100%>
				<!--#include file="Includes/hierarchyTeamDetails.inc"-->				

				<tr height=16 class=SectionHeader>
				  <td>
					<table border=0 cellpadding=0 cellspacing=0 >
						<td class=toolbar width=8></td>
                        <td width=20><a  href="javascript:frmDetails.submit();" ><img class="imagelink" src="images/saveitem.gif"></A></td>
						<td class=toolbar valign="middle" >Save and Close</td>
                        <td class=titleseparator valign="middle" width=14 align="center">|</td>
						<td class=toolbar valign="middle" ><A class= itemfontlink href="javascript:window.parent.refreshIframeAfterDateSelect('ManningTeamPersonnel.asp');">Back</A></td>											

					</table>
				  </td>
				</tr>
				<tr>
				  <td>
				  
					<table width=100% border=0 cellpadding=0 cellspacing=0>
					  <tr>
						<td colspan="3" height="22px">&nbsp;</td>
					  </tr>
					  <tr class=columnheading>
					    <td valign="middle" height="22px" width=2%>&nbsp;</td>
						<td valign="middle" height="22px" width=13%>Post:</td>
						<td valign="middle" height="22px" width=85% class=itemfont><%=rsRecSet("Description")%></td>
					  </tr>
					  <tr class=columnheading>
			            <td valign="middle" height="22px" width=2%>&nbsp;</td>
						<td valign="middle" height="22px">Assignment Number:</td>
						<td valign="middle" height="22px" class=itemfont ><%=rsRecSet("assignno")%></td>
					  </tr>
					  <tr class=columnheading>
			            <td valign="middle" height="22px" width=2%>&nbsp;</td>
						<td valign="middle" height="22px">Unit:</td>
						<td valign="middle" height="22px" class=itemfont ><%=rsRecSet("Team")%></td>
					  </tr>
					  <tr class=columnheading>
			            <td valign="middle" height="22px" width=2%>&nbsp;</td>
						<td valign="middle" height="22px">Position:</td>
						<td valign="middle" height="22px" class=itemfont ><%=rsRecSet("position")%></td>
					  </tr>
					  <tr class=columnheading>
			            <td valign="middle" height="22px" width=2%>&nbsp;</td>
						<td valign="middle" height="22px">Rank:</td>
						<td valign="middle" height="22px" class=itemfont ><%=rsRecSet("rank")%></td>
					  </tr>
					  <tr class=columnheading>
			            <td valign="middle" height="22px" width=2%>&nbsp;</td>
						<td valign="middle" height="22px">Trade:</td>
						<td valign="middle" height="22px" class=itemfont ><%=rsRecSet("trade")%></td>
					  </tr>
					  <tr class=columnheading>
			            <td valign="middle" height="22px" width=2%>&nbsp;</td>
						<td valign="middle" height="22px">Rank Weighting:</td>
						<td valign="middle" height="22px" class=itemfont ><%=rsRecSet("RankWeight")%></td>
					  </tr>
					  <tr class=columnheading>
			            <td valign="middle" width=2%>&nbsp;</td>
						<td valign=Top>Notes:</td>
						<td valign="middle" class=itemfont ><Textarea  readonly Name = Notes class=itemfont rows=3 cols=48 ><%=rsRecSet("Notes")%></TextArea></td>
					  </tr>
					  <tr class=columnheading>
			            <td valign="middle" height="22px" width=2%>&nbsp;</td>
						<td valign="middle" height="22px">Qualification Overide:</td>
						<td valign="middle" height="22px" class=itemfont ><%if rsRecSet("QOveride")=true then response.write ("Yes") else response.write ("No") End if%></td>
					  </tr>
					  <tr class=columnheading>
			            <td valign="middle" height="22px" width=2%>&nbsp;</td>
						<td valign="middle" height="22px">MS Overide:</td>
						<td valign="middle" height="22px" class=itemfont ><%if rsRecSet("MSOveride")=true then response.write ("Yes") else response.write ("No") End if%></td>
					  </tr>
					  
                      <tr class=columnheading>
			            <td valign="middle" height="22px" width=2%>&nbsp;</td>
						<td valign="middle" height="22px">Post OverBorne:</td>
						<td valign="middle" height="22px" class=itemfont> <%if rsRecSet("overborne")=true then response.write ("Yes") else response.write ("No") End if%> </td>
					  </tr>  
                      <tr class=columnheading>
			            <td valign="middle" height="22px" width=2%></td>
						<td valign="middle" height="22px">Manager:</td>
						<td valign="middle" height="22px" class=itemfont>
						<Select  class="inputbox" Name=Manager>
						<option value=0 <%if rsRecSet("Manager") = "NULL" then response.write (" Selected")%>>No</option>
						<option value=1 <%if rsRecSet("Manager") <> "NULL" then response.write (" Selected")%>>Yes</option>
						</Select>
						</td>
					  </tr>  
					      					  
					  <tr>
						<td colspan="3" height="22px">&nbsp;</td>
					  </tr>
					  <tr>
       					<td colspan=3 class=titlearealine  height=1></td> 
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
function checkDelete(){
     var delOK = false
	 var delMess = "Are you sure you want to delete this Record ?"
	 var delPost = document.frmDetails.delOK.value
	 	 
	 if(delPost == 1){
	    delMess = "This Post has Personnel Assigned - Are you sure you want to delete this Record ?";
		}

	  //input_box = confirm("Are you sure you want to delete this Record ?")
      var input_box = confirm(delMess)
	  if(input_box==true) {
		    delOK = true;
	    }
    return delOK;
}
</Script>
