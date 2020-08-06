<!DOCTYPE HTML >

<!--#include file="Includes/security.inc"--> 
<!--#include file="Connection/Connection.inc"-->
<!--#include file="Includes/checkmanager.inc"-->  
<!--#include file="Includes/manageradmin.inc"-->  

<%
Tab=1
strTable = "tblpost"
strGoTo = "ManningPostList.asp"   ' asp page to return to once record is deleted
strTabID = "postID"              ' key field name for table        

set objCmd = server.CreateObject("ADODB.Command")
set objPara = server.CreateObject("ADODB.Parameter")
objCmd.ActiveConnection = con
objCmd.CommandText = "spPostDetail"	'Name of Stored Procedure
objCmd.CommandType = 4				'Code for Stored Procedure
set objPara = objCmd.CreateParameter ("PostID",3,1,5, request("PostID"))
objCmd.Parameters.Append objPara
set rsRecSet = objCmd.Execute	'Execute CommandText when using "ADODB.Command" object

for x = 1 to objCmd.parameters.count
	objCmd.parameters.delete(0)
next

' now see if we can delete it - if it has no children then we can return parameter for Delete check
objCmd.CommandText = "spPostDel"	'Name of Stored Procedure
set objPara = objCmd.CreateParameter ("PostID",3,1,5, rsRecSet("PostID"))
objCmd.Parameters.Append objPara
set objPara = objCmd.CreateParameter("@DelOK",3,2)
objCmd.Parameters.Append objPara
objCmd.Execute	

strDelOK = objCmd.Parameters("@DelOK")
objCmd.Parameters.delete ("@DelOK")

' now check to see if they are in a team
strTeamOK = "0"   ' set to No Team
intHrc= int(request("hrcID"))

'strManager =  session("Manager")
'response.write session("Administrator") & " * " & session("UserStatus") & " * " & strTeamOK & " * " & strManager & " * " & intHrc
%>

<html>
<head>

<!--#include file="Includes/IECompatability.inc"-->


<title>Post Details</title>
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
<form action="" method="POST" name="frmDetails">
	<input type="hidden" name="delOK" id="delOK" value="<%=strDelOK%>">
	<input type="hidden" name="postID" id="postID" value=<%=request("postID")%>>
    <input type="hidden" name="hrcID" id="hrcID" value=<%=intHrc%>>
     <input type="hidden" name="staffPostID" id="staffPostID"value=<%=rsRecSet("staffPostID")%>>
	<table border=0 cellpadding=0 cellspacing=0 width=100%>
		<!--#include file="Includes/hierarchyPostDetails.inc"--> 
		<tr>
			<td colspan=10 class=titlearealine  height=1></td> 
		</tr>
		<tr height=16 class=SectionHeader>
			<td>
				<table border=0 cellpadding=0 cellspacing=0 >
					<% 'if strManager = 1 then %>
						<% if session("administrator") = 1 then %>
							<td class=toolbar width=8></td>
							<td width=20><a class=itemfontlink href="HierarchyPostAdd.asp"><img class="imagelink" src="images/newitem.gif"></a></td>
							<td class=toolbar valign="middle">New Post</td>
							<td class=titleseparator valign="middle" width=14 align="center">|</td>
                            <td class=toolbar width=8></td>
                        <!--<td width=20><a  href="javascript:frmDetails.submit();" ><img class="imagelink" src="images/saveitem.gif"></A></td>
						<td class=toolbar valign="middle" >Save and Close</td> -->
						<% end if %>
                        <td width=20><a class=itemfontlink href="HierarchyPostEdit.asp?postID=<%=request("PostID")%>&hrcID=<%=intHrc%>"><img class="imagelink" src="images/editgrid.gif"></A></td>
						<td class=toolbar valign="middle">Edit Post</td>
						<% if 1 > 2 then %>
							<% if session("administrator") = 1 then %>
								<td class=titleseparator valign="middle" width=14 align="center">|</td>
								<td width=20><a class=itemfontlink href="DeletePost.asp?RecID=<%=request("recID")%>&TableName=<%=strTable%>&TabId=<%=strTabID%>&GoTo=<%=strGoTo%>&delOK=<%=strDelOK%>" onClick="javascript:return(checkDelete());"><img class="imagelink" src="images/delitem.gif"></A></td>
								<td class=toolbar valign="middle">Delete Post</td>
							<% end if %>
						<% end if %>
  					<% 'end if %>	
                        <td class=titleseparator valign="middle" width=14 align="center">|</td>
						<td class=toolbar valign="middle" ><A class= itemfontlink href="javascript:window.parent.refreshIframeAfterDateSelect('HierarchyTaskingView.asp')">Back</A></td>		

				</table>
			</td>
		</tr>
		<tr>
			<td>
				<table width=100% border=0 cellpadding=0 cellspacing=0>
					<tr>
						<td height="22px" colspan=3>&nbsp;</td>
					</tr>
                    <tr class=columnheading>
						<td width="2%" valign="middle" height="22px">&nbsp;</td>
						<td width="13%" valign="middle" height="22px">Post Holder:</td>
						<td width="85%" valign="middle" height="22px" class=itemfont><%=rsRecSet("postholder")%></td>
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
					<tr class=columnheading>
						<td width="2%" valign="middle" height="22px">&nbsp;</td>
						<td width="13%" valign="middle" height="22px">Hierarchy:</td>
						<td width="85%" valign="middle" height="22px" class=itemfont><%=rsRecSet("team")%></td>
					</tr>
					<tr class=columnheading>
						<td width="2%" valign="middle" height="22px">&nbsp;</td>
						<td width="13%" valign="middle" height="22px">Position:</td>
						<td width="85%" valign="middle" height="22px" class=itemfont ><%=rsRecSet("position")%></td>
					</tr>
                    <!--<tr class=columnheading height=22>
                        <td valign="middle" width=2%></td>
                        <td valign="middle" width="13%">Service:</td>
                        <td valign="middle" width="85%" class=itemfont ><%'=rsRecSet("PostService")%></td>
                    </tr>-->
                    <tr class=columnheading height=22>
                        <td valign="middle" width=2%></td>
                        <td valign="middle" width="13%">Rank:</td>
                        <td valign="middle" width="85%" class=itemfont ><%=rsRecSet("rank")%></td>
                    </tr>
                    
					<tr class=columnheading>
						<td width="2%" valign="middle" height="22px">&nbsp;</td>
						<td width="13%" valign="middle" height="22px">Trade:</td>
						<td width="85%" valign="middle" height="22px" class=itemfont ><%=rsRecSet("trade")%></td>
					</tr>
                    
					<tr class=columnheading>
						<td width="2%" valign="middle" height="22px">&nbsp;</td>
						<td width="13%" valign="middle" height="22px">Rank Weighting:</td>
						<td width="85%" valign="middle" height="22px" class=itemfont ><%=rsRecSet("RankWeight")%></td>
					</tr>
					<tr class=columnheading>
						<td width="2%" valign="middle" height="22px">&nbsp;</td>
						<td width="13%" valign=Top height="22px">Notes:</td>
						<td width="85%" valign="middle" height="22px" class=itemfont ><Textarea  readonly name="Notes" id="Notes" class=itemfont rows=3 cols=48 ><%=rsRecSet("Notes")%></TextArea></td>
					</tr>
                    <!--  We might use these in future so just comment them out for now - CMS2 -->
                    <!--
					<tr class=columnheading>
						<td width="2%" valign="middle" height="22px">&nbsp;</td>
						<td width="13%" valign="middle" height="22px">Qualification Overide:</td>
						<td width="85%" valign="middle" height="22px" class=itemfont><%'if rsRecSet("QOveride")=true then response.write ("Yes") else response.write ("No") End if%></td>
					</tr>
					<tr class=columnheading>
						<td width="2%" valign="middle" height="22px">&nbsp;</td>
						<td width="13%" valign="middle" height="22px">MS Overide:</td>
						<td width="85%" valign="middle" height="22px" class=itemfont ><%'if rsRecSet("MSOveride")=true then response.write ("Yes") else response.write ("No") End if%></td>
					</tr>
					<tr class=columnheading>
						<td width="2%" valign="middle" height="22px">&nbsp;</td>
						<td width="13%" valign="middle" height="22px">Post OverBorne:</td>
						<td width="85%" valign="middle" height="22px" class=itemfont> <%'if rsRecSet("overborne")=true then response.write ("Yes") else response.write ("No") End if%> </td>
					</tr>  
                    -->
                    <tr class=columnheading>
			            <td valign="middle" height="22px" width=2%></td>
						<td valign="middle" height="22px">Manager:</td>
						<td valign="middle" height="22px" class=itemfont>
						  <%if isNull(rsRecSet("Manager")) then response.write "No" else response.write "Yes" end if %> 
						</td>
					  </tr>  
					<tr height=16>
						<td colspan="3">&nbsp;</td>
					</tr>
					<tr>
       					<td colspan=3 class=titlearealine height=1></td> 
     				</tr>
				</table>	
				  </td> 
				</tr> 
			</table>
		</td>
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

<script language="javascript">

function checkDelete()
{
	var delOK = false
	var delMess = "Are you sure you want to delete this Record ?"
	var delPost = document.frmDetails.delOK.value
	 	 
	if(delPost == 1)
	{
		delMess = "This Post has Personnel Assigned - Are you sure you want to delete this Record ?";
	}

	var input_box = confirm(delMess)
	if(input_box == true)
	{
		delOK = true;
	}
    return delOK;
}

</Script>