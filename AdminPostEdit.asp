<!DOCTYPE HTML >

<!--#include file="Includes/security.inc"--> 
<!--#include file="Includes/checkadmin.asp"-->
<!--#include file="Connection/Connection.inc"-->

<%
dim strAction
strAction="Update"
 
set objCmd = server.CreateObject("ADODB.Command")
set objPara = server.CreateObject("ADODB.Parameter")
objCmd.ActiveConnection = con
objCmd.CommandText = "spPostDetail"	'Name of Stored Procedure
objCmd.CommandType = 4				'Code for Stored Procedure

set objPara = objCmd.CreateParameter ("PostID",3,1,5, request("RecID"))
objCmd.Parameters.Append objPara
set rsRecSet = objCmd.Execute	'Execute CommandText when using "ADODB.Command" object

for x = 1 to objCmd.parameters.count
	objCmd.parameters.delete(0)
next

strCommand = "spGetHierarchyList"
objCmd.CommandText = strCommand

set objPara = objCmd.CreateParameter ("nodeID",3,1,0, nodeID)
objCmd.Parameters.Append objPara
set rsHrcList = objCmd.Execute

strTable = "tblPosition"
strCommand = "spListTable"
objCmd.CommandText = strCommand
objCmd.CommandType = 4		
set objPara = objCmd.CreateParameter ("TableName",200,1,50, strTable)
objCmd.Parameters.Append objPara
set rsPositionList = objCmd.Execute	'Execute CommandText when using "ADODB.Command" object

for x = 1 to objCmd.parameters.count
	objCmd.parameters.delete(0)
next

' default to tblRank ndeID=1
strTable = "tblRank"
strCommand = "spListTable"
objCmd.CommandText = strCommand

set objPara = objCmd.CreateParameter ("nodeID",3,1,0, nodeID)
objCmd.Parameters.Append objPara
set objPara = objCmd.CreateParameter ("TableName",200,1,50, strTable)
objCmd.Parameters.Append objPara
set rsRankList = objCmd.Execute	'Execute CommandText when using "ADODB.Command" object

for x = 1 to objCmd.parameters.count
	objCmd.parameters.delete(0)
next

strTable = "tblTrade"
strCommand = "spListTable"
objCmd.CommandText = strCommand

set objPara = objCmd.CreateParameter ("nodeID",3,1,0, nodeID)
objCmd.Parameters.Append objPara
set objPara = objCmd.CreateParameter ("TableName",200,1,50, strTable)
objCmd.Parameters.Append objPara
set rsTradeList = objCmd.Execute	'Execute CommandText when using "ADODB.Command" object

for x = 1 to objCmd.parameters.count
	objCmd.parameters.delete(0)
next

strTable = "tblRankWeight"
strCommand = "spListTable"
objCmd.CommandText = strCommand

set objPara = objCmd.CreateParameter ("nodeID",3,1,0, nodeID)
objCmd.Parameters.Append objPara
set objPara = objCmd.CreateParameter ("TableName",200,1,50, strTable)
objCmd.Parameters.Append objPara
set rsRankWeightList = objCmd.Execute	'Execute CommandText when using "ADODB.Command" object
%>

<html>
<head>

<!--#include file="Includes/IECompatability.inc"-->
<title><%= PageTitle %></title>
<link rel="stylesheet" type="text/css" href="Includes/AMDB.css" media="Screen"/>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<script type="text/javascript" src="Includes/ajax.js"></script>
</head>
<body>
<form action="UpdatePost.asp?strAction=<%=strAction%>" method="post" name="frmDetails">
	<input type="hidden" name="recID" id="recID" value="<%=request("recID")%>">
	<input type="hidden" name="hiddenGhost" id="hiddenGhost" value="<%= rsRecSet("Ghost") %>">
    <input type="hidden" name="hiddenPostHolder" id="hiddenPostHolder" value="<%= rsRecSet("postHolder") %>">
    <input type="hidden" name="manager" id="manager" value="0">
	<table cellspacing=0 cellPadding=0 width=100% border=0>
    	<tr>
			<td>
				<!--#include file="Includes/Header.inc"-->
                <table cellSpacing=0 cellPadding=0 width=100% border=0 >
                    <tr style="font-size:10pt;" height=26px>
                        <td width=10><img style="margin-left:10px;" src="cms_icons/png/24x24/process.png" width="24" height="24"></td>
                        <td class="staticdatamenu"><font class="youAreHere">CMS Admin Menu / <strong>Edit Post Details</strong></font></td>
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
                                                <td class=toolbar width=8></td><td width=20><a  href="javascript:checkThis();"><img class="imagelink" src="images/saveitem.gif"></A></td>
                                                <td class=toolbar valign="middle" >Save and Close</td><td class=titleseparator valign="middle" width=14 align="center">|</td>
                                                <td class=toolbar valign="middle" ><A class= itemfontlink href="AdminPostDetail.asp?recID=<%=request("recID")%>">Back</A></td>											
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
                                                <td valign="middle"width=2%>&nbsp;</td>
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
                                                <td valign="middle" width=85% class=itemfont><INPUT name="txtDescription" class="inputbox itemfont" id="txtDescription" style="WIDTH: 300px" Value="<%=rsRecSet("Description")%>" maxLength=50></td>
                                            </tr>
                                            <tr class=columnheading height=22>
                                                <td valign="middle" width=2%>&nbsp;</td>
                                                <td valign="middle" width="13%">Assign No:</td>
                                                <td valign="middle" width="85%" class=itemfont><INPUT class="inputbox itemfont" style="WIDTH: 300px" maxLength=50 name="txtassignno" id="txtassignno" Value="<%=rsRecSet("assignno")%>" <%if rsRecSet("Ghost") = True then%>readonly<%end if%>></td>
                                            </tr>
                                            <tr class=columnheading height=22>
                                                <td valign="middle" width=2%>&nbsp;</td>
                                                <td valign="middle" width="13%">Unit:</td>
                                                <td valign="middle" width="85%" class=itemfont>
                                                    <Select class="inputbox" Name="hrcID" id="hrcID">
                                                        <%Do while not rsHrcList.eof%>
                                                            <option value=<%=rsHrcList("hrcID")%> <%if rsRecSet("hrcID")=rsHrcList("hrcID") then response.write (" Selected")%>><%=rsHrcList("hrcname")%>&nbsp;(&nbsp;<%=rsHrcList("parent")%>&nbsp;)</B></option>
                                                            <%rsHrcList.MoveNext
                                                        Loop%>
                                                    </Select>
                                                </td>
                                            </tr>
                                            <tr class=columnheading height=22>
                                                <td valign="middle" width=2%>&nbsp;</td>
                                                <td valign="middle" width="13%">Position:</td>
                                                <td valign="middle" width="85%" class=itemfont><INPUT class="inputbox itemfont" style="WIDTH: 300px" maxLength="50" name="position" id="position" Value="<%=rsRecSet("position")%>"></td>
                                            </tr>
                                            <tr class=columnheading height=22>
                                                <td valign="middle" width=2%>&nbsp;</td>
                                                <td valign="middle" width="13%">Rank:</td>
                                                <td valign="middle" width="85%" class=itemfont>
                                                    <Select class="inputbox" Name="RankID" id="RankID">
                                                        <%Do while not rsRankList.eof%>
                                                            <option value=<%=rsRankList("RankID")%> <%if rsRecSet("RankID")=rsRankList("RankID") then response.write (" Selected")%>><%=rsRankList("shortdesc")%></option>
                                                            <%rsRankList.MoveNext
                                                        Loop%>
                                                    </Select>						
                                                </td>
                                            </tr>
                                            <tr class=columnheading height=22>
                                                <td valign="middle" width=2%>&nbsp;</td>
                                                <td valign="middle" width="13%">Trade:</td>
                                                <td valign="middle" width="85%" class=itemfont>
                                                    <Select class="inputbox" Name="TradeID" id="TradeID">
                                                        <%Do while not rsTradeList.eof%>
                                                            <option value=<%=rsTradeList("TradeID")%> <%if rsRecSet("TradeID")=rsTradeList("TradeID") then response.write (" Selected")%>><%=rsTradeList("description")%></option>
                                                            <%rsTradeList.MoveNext
                                                        Loop%>
                                                    </Select>
                                                </td>
                                            </tr>
                                            <tr class=columnheading height=22>
                                                <td valign="middle" width=2%>&nbsp;</td>
                                                <td valign="middle" width="13%">Rank Weighting:</td>
                                                <td valign="middle" width="85%" class=itemfont>
                                                    <Select class="inputbox" Name="RWID" id="RWID">
                                                        <option value="0"></option>
                                                        <%Do while not rsRankWeightList.eof%>
                                                            <option value=<%=rsRankWeightList("RWID")%> <%if rsRecSet("RWID")=rsRankWeightList("RWID") then response.write (" Selected")%>><%=rsRankWeightList("description")%></option>
                                                            <%rsRankWeightList.MoveNext
                                                        Loop%>
                                                    </Select>						
                                                </td>
                                            </tr>
                                            <tr class=columnheading height=22>
                                                <td valign="middle" width=2%>&nbsp;</td>
                                                <td valign=top width="13%">Notes:</td>
                                                <td valign="middle" width="85%" class=itemfont ><Textarea  Name="Notes" id="Notes" class="itemfon"t rows="3" cols="48" ><%=rsRecSet("Notes")%></textarea></td>
                                            </tr>
                                            <tr class="columnheading" height="22">
                                            	<td valign="middle" width="2%">&nbsp;</td>
                                                <td valign="middle" width="13%">Status:</td>
                                                <td valign="middle" width="85%">
                                                	<select name="Status" id="Status" class="inputbox" style="width:70px;" <% if not isnull(rsRecSet("postHolder")) then %>disabled<% end if %>>
                                                    	<option value="1" <% if rsRecSet("status") = true then %>selected<% end if %>>Active</option>
                                                        <option value="0" <% if rsRecSet("status") = false then %>selected<% end if %>>Inactive</option>
                                                    </select>
												</td>
											</tr>
                                            <tr height=16>
                                            	<td></td>
                                            </tr>
                                            <tr class=columnheading height=22>
                                                <td valign="middle" width=2%>&nbsp;</td>
                                                <td valign="middle" width="13%">Qualification Overide:</td>
                                                <td valign="middle" width="85%" class=itemfont >
                                                    <Select class="inputbox" Name="QOveride" id="QOveride">
                                                        <option value=1 <%if rsRecSet("QOveride")=True then response.write (" Selected")%>>Yes</option>
                                                        <option value=0 <%if rsRecSet("QOveride")=False then response.write (" Selected")%>>No</option>
                                                    </Select>						
                                                </td>
                                            </tr>
                                            <tr class=columnheading height=22>
                                                <td valign="middle" width=2%>&nbsp;</td>
                                                <td valign="middle" width="13%">MS Overide:</td>
                                                <td valign="middle" width="85%" class=itemfont >
                                                    <Select class="inputbox" Name="MSOveride" id="MSOveride">
                                                        <option value=1 <%if rsRecSet("MSOveride")=True then response.write (" Selected")%>>Yes</option>
                                                        <option value=0 <%if rsRecSet("MSOveride")=False then response.write (" Selected")%>>No</option>
                                                    </Select>						
                                                </td>
                                            </tr>
                                            <tr class=columnheading height=22>
                                                <td valign="middle" width=2%>&nbsp;</td>
                                                <td valign="middle" width="13%">Post OverBorne:</td>
                                                <td valign="middle" width="85%" class=itemfont >
                                                    <Select  class="inputbox" Name="overborne" id="overborne">
                                                        <option value=0 <%if rsRecSet("overborne")=False then response.write (" Selected")%>>No</option>
                                                        <option value=1 <%if rsRecSet("overborne")=True then response.write (" Selected")%>>Yes</option>
                                                    </Select>
                                                </td>
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

</body>
</html>


<Script Language="Javascript">

function CheckForm() {
	var passed=true;
	
	if (document.forms["frmDetails"].elements["Description"].value =="") {
		alert("Please enter Post Description");
		passed=false;
	}

	if (document.forms["frmDetails"].elements["assignno"].value =="") {
		alert("Please enter Assignment Number");
		passed=false;
	}

	return passed;
}

</Script>
<SCRIPT LANGUAGE="JavaScript">

function checkThis()
{
	//This function renoves any leading or trailing spaces from a string
	String.prototype.killWhiteSpace = function()
	{
		return this.replace(/\s/g, '');
	};

	var errMsg = "Please provide/correct the following:\n\n";
	var error = false;
	  
	var Post = document.frmDetails.txtDescription.value;
	Post = Post.killWhiteSpace(); 
	var AssignNo = document.frmDetails.txtassignno.value;
	AssignNo = AssignNo.killWhiteSpace();

	/* make sure they have entered comments for the next stage */
	if(Post == "")
	{
		errMsg += "Post\n"
		error = true;
	}

	if(AssignNo == "")
	{
		errMsg += "Assign No"
		error = true;
	}   

	if(error == true)
	{
		alert(errMsg)
		return;	  		
	} 

	document.frmDetails.submit();  
}

function getRanks(serID) {
	ajax('ddPostRanks.asp','serID='+serID,'rnkdiv');
}

</Script>
