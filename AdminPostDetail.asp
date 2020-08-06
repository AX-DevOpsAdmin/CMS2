<!DOCTYPE HTML >

<!--#include file="Includes/security.inc"--> 
<!--#include file="Includes/checkadmin.asp"-->
<!--#include file="Connection/Connection.inc"-->

<%
strTable = "tblpost"
strGoTo = "AdminPostList.asp"   ' asp page to return to once record is deleted
strTabID = "postID"              ' key field name for table        

set objCmd = server.CreateObject("ADODB.Command")
set objPara = server.CreateObject("ADODB.Parameter")
objCmd.ActiveConnection = con
objCmd.CommandText = "spPostDetail"	'Name of Stored Procedure
objCmd.CommandType = 4				'Code for Stored Procedure

set objPara = objCmd.CreateParameter ("PostID",3,1,5, request("RecID"))
objCmd.Parameters.Append objPara
set rsRecSet = objCmd.Execute	'Execute CommandText when using "ADODB.Command" object

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


<title><%= PageTitle %></title>
<link rel="stylesheet" type="text/css" href="Includes/AMDB.css" media="Screen"/>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">

</head>
<body>
<form action="" method="POST" name="frmDetails">
	<input type="hidden" name="delOK" id="delOK" value="<%=strDelOK%>">
	<table  height="100%" cellspacing=0 cellPadding=0 width=100% border=0>
		<tr>
			<td> 
				<!--#include file="Includes/Header.inc"-->
                <table cellSpacing=0 cellPadding=0 width=100% border=0 >
                    <tr style="font-size:10pt;" height=26px>
                        <td width=10><img style="margin-left:10px;" src="cms_icons/png/24x24/process.png" width="24" height="24"></td>
                        <td class="staticdatamenu"><font class="youAreHere">CMS Admin Menu / <strong>Post Details</strong></font></td>
                    </tr>
                    <tr><td colspan=2 class=titlearealine  height=1></td></tr>
				</table>
          
  		  <table width=100% height='<%=session("heightIs")%>px' border=0 cellpadding=0 cellspacing=0> 
      		<tr valign=Top>
        	  <td class="sidemenuwidth" background="Images/tableback.png"><!--#include file="Includes/datamenu.inc"--></td>
						<td width=16></td>
						<td align=left>
							<table border=0 cellpadding=0 cellspacing=0 width=100%>
								<tr height=16 class=SectionHeader>
									<td>
                                        <table border=0 cellpadding=0 cellspacing=0>
                                        	<tr>
                                                <td width=20><a class=itemfontlink href="AdminPostAdd.asp"><img class="imagelink" src="images/newitem.gif"></a></td>
                                                <td class=toolbar valign="middle" >New Post</td>
                                                <td class=titleseparator valign="middle" width=14 align="center">|</td>
                                                <td width=20><a class=itemfontlink href="AdminPostEdit.asp?RecID=<%=request("RecID")%>"><img class="imagelink" src="images/editgrid.gif"></A></td>
                                                <td class=toolbar valign="middle" >Edit Post</td>
                                                <td class=titleseparator valign="middle" width=14 align="center">|</td>
                                                <% if strDelOK = "0" then %>
                                                	<td width=20><a class=itemfontlink href="DeletePost.asp?RecID=<%=request("recID")%>&TableName=<%=strTable%>&TabId=<%=strTabID%>&GoTo=<%=strGoTo%>&delOK=<%=strDelOK%>" onClick="javascript:return(checkDelete());"><img class="imagelink" src="images/delitem.gif"></A></td>
                                                	<td class=toolbar valign="middle" >Delete Post</td>
                                                	<td class=titleseparator valign="middle" width=14 align="center">|</td>
                                                <% end if %>
                                                <td class=toolbar valign="middle" ><A class=itemfontlink href="AdminPostList.asp">Back To List</A></td>											
                                            </tr>
                                        </table>
									</td>
								</tr>
								<tr>
									<td>
										<table width=100% border=0 cellpadding=0 cellspacing=0>
											<tr height=16>
												<td></td>
											</tr>
                                            <!--
                                            <tr class=columnheading height=22>
                                                <td valign="middle" width=2%></td>
                                                <td valign="middle" width=13%>Ghost Post:</td>
                                                <td valign="middle" width=85%>
													<%' if rsRecSet("Ghost") = true then %>
                                                        <img src="Images/checked.gif" width="13" height="13">
                                                    <%' else %>
                                                        <img src="Images/unchecked.gif" width="13" height="13">
                                                    <%' end if %>
                                                </td>
                                            </tr>
                                            -->
                                            <tr class=columnheading height=22>
                                                <td valign="middle" width=2%></td>
                                                <td valign="middle" width=13%>Post:</td>
                                                <td valign="middle" width=85% class=itemfont><%=rsRecSet("Description")%></td>
                                            </tr>
                                            <tr class=columnheading height=22>
                                                <td valign="middle" width=2%></td>
                                                <td valign="middle" width="13%">Assign No:</td>
                                                <td valign="middle" width="85%" class=itemfont ><%=rsRecSet("assignno")%></td>
                                            </tr>
                                            <tr class=columnheading height=22>
                                                <td valign="middle" width=2%></td>
                                                <td valign="middle" width="13%">Unit:</td>
                                                <td valign="middle" width="85%" class=itemfont ><%=rsRecSet("Team")%></td>
                                            </tr>
                                            <tr class=columnheading height=22>
                                                <td valign="middle" width=2%></td>
                                                <td valign="middle" width="13%">Position:</td>
                                                <td valign="middle" width="85%" class=itemfont ><%=rsRecSet("position")%></td>
                                            </tr>

                                            <tr class=columnheading height=22>
                                                <td valign="middle" width=2%></td>
                                                <td valign="middle" width="13%">Rank:</td>
                                                <td valign="middle" width="85%" class=itemfont ><%=rsRecSet("rank")%></td>
                                            </tr>
                                            <tr class=columnheading height=22>
                                                <td valign="middle" width=2%></td>
                                                <td valign="middle" width="13%">Trade:</td>
                                                <td valign="middle" width="85%" class=itemfont ><%=rsRecSet("trade")%></td>
                                            </tr>
                                            <tr class=columnheading height=22>
                                                <td valign="middle" width=2%></td>
                                                <td valign="middle" width="13%">Rank Weighting:</td>
                                                <td valign="middle" width="85%" class=itemfont ><%=rsRecSet("RankWeight")%></td>
                                            </tr>
                                            <tr class=columnheading height=22>
                                                <td valign="middle" width=2%></td>
                                                <td valign=Top width="13%" >Notes:</td>
                                                <td valign="middle" width="85%" class=itemfont ><Textarea  readonly Name="Notes" id="Notes" class="itemfont" rows="3" cols="48" ><%=rsRecSet("Notes")%></TextArea></td>
                                            </tr>
                                            <tr class="columnheading" height="22">
                                            	<td valign="middle" width="2%">&nbsp;</td>
                                                <td valign="middle" width="13%">Status:</td>
                                                <td valign="middle" width="85%" class="itemfont"><% if rsRecSet("status") = true then %>Active<% else %>Inactive<% end if %></td>
											</tr>
                                            <tr height=16>
                                            	<td></td>
                                            </tr>
                                            <tr class=columnheading height=22>
                                                <td valign="middle" width=2%></td>
                                                <td valign="middle" width="13%">Qualification Overide:</td>
                                                <td valign="middle" width="85%" class=itemfont ><%if rsRecSet("QOveride")=true then response.write ("Yes") else response.write ("No") End if%></td>
                                            </tr>
                                            <tr class=columnheading height=22>
                                                <td valign="middle" width=2%></td>
                                                <td valign="middle" width="13%">MS Overide:</td>
                                                <td valign="middle" width="85%" class=itemfont ><%if rsRecSet("MSOveride")=true then response.write ("Yes") else response.write ("No") End if%></td>
                                            </tr>
                                            <tr class=columnheading height=22>
                                                <td valign="middle" width=2%></td>
                                                <td valign="middle" width="13%">Post OverBorne:</td>
                                                <td valign="middle" width="85%" class=itemfont> <%if rsRecSet("overborne")=true then response.write ("Yes") else response.write ("No") End if%> </td>
                                            </tr>  					      					  
                                            <tr height=16>
                                            	<td></td>
                                            </tr>
                                            <tr>
                                            	<td colspan=3 class=titlearealine  height=1></td> 
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
	var delMess = "Are you sure you want to delete this Record?"

	var input_box = confirm(delMess)
	if(input_box==true)
	{
		delOK = true;
	}
    return delOK;
}

</Script>
