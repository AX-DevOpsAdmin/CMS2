<!DOCTYPE HTML >
<!--#include file="Includes/security.inc"--> 
<!--#include file="Connection/Connection.inc"-->
<!--#include file="Includes/checkmanager.inc"-->  
<!--#include file="Includes/manageradmin.inc"-->  

<%
Tab=1
dim strAction
strAction="Update"
 
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

' now see if we can delete it - if it has no children then we can
' return parameter for Delete check
objCmd.CommandText = "spPostDel"	'Name of Stored Procedure
set objPara = objCmd.CreateParameter ("PostID",3,1,5, rsRecSet("PostID"))
objCmd.Parameters.Append objPara
set objPara = objCmd.CreateParameter("@DelOK",3,2)
objCmd.Parameters.Append objPara
objCmd.Execute	

strDelOK = objCmd.Parameters("@DelOK")
objCmd.Parameters.delete ("@DelOK")


for x = 1 to objCmd.parameters.count
	objCmd.parameters.delete(0)
next

objCmd.CommandText = "spListHierarchyDropDown"	'Name of Stored Procedure
objCmd.CommandType = 4				'Code for Stored Procedure
set objPara = objCmd.CreateParameter ("nodeID",3,1,5, nodeID)
objCmd.Parameters.Append objPara

set rsHrcList = objCmd.Execute	'Execute CommandText when using "ADODB.Command" object

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

strTable = "tblRank"
strCommand = "spListTable"
objCmd.CommandText = strCommand
objCmd.CommandType = 4		
'set objPara = objCmd.CreateParameter ("nodeID",3,1,5, 1)  ' reinstate for CMS2
set objPara = objCmd.CreateParameter ("nodeID",3,1,5, nodeID)
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
objCmd.CommandType = 4	
set objPara = objCmd.CreateParameter ("nodeID",3,1,5, nodeID)
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
objCmd.CommandType = 4		
set objPara = objCmd.CreateParameter ("nodeID",3,1,5, nodeID)
objCmd.Parameters.Append objPara
set objPara = objCmd.CreateParameter ("TableName",200,1,50, strTable)
objCmd.Parameters.Append objPara
set rsRankWeightList = objCmd.Execute	'Execute CommandText when using "ADODB.Command" object

'response.write request("postID") & " * " & request("hrcID")


%>


<html>
<head>

<!--#include file="Includes/IECompatability.inc"-->
<title>Flight Details</title>
<link rel="stylesheet" type="text/css" href="Includes/AMDB.css" media="Screen"/>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<script type="text/javascript" src="Includes/ajax.js"></script>

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
.style2 {color: #FF0000}
-->
</style>

</head>
<body>
<form action="UpdatePost.asp?strAction=<%=strAction%>" method="post" name="frmDetails">
	<input type="hidden" name="postID" id="postID" value=<%=request("postID")%>>
    <input name="hrcold"   id="hrcold" type="hidden"  value=<%=request("hrcID")%>>
    <Input name="strGoto" id="strGoto" type="hidden" value="hierarchyPostDetail.asp">
    <input name="Status" id="Status" type="hidden" value="<%if rsRecSet("Status") = True then%>1<%else%>0<%end if%>">
    <input name="hiddenGhost" id="hiddenGhost" type="hidden" value="<%=rsRecSet("Ghost")%>">


			  <table border=0 cellpadding=0 cellspacing=0 width=100%>
                <!--#include file="Includes/hierarchyPostDetails.inc"-->
				<tr>
					<td colspan=10 class=titlearealine  height=1></td> 
				</tr>

				<tr height=16 class=SectionHeader>
				  <td>
					<table border=0 cellpadding=0 cellspacing=0 >
						<td class=toolbar width=8></td>
                        <td width=20><a href="javascript:checkThis();"><img class="imagelink" src="images/saveitem.gif"></A></td>
						<td class=toolbar valign="middle" >Save and Close</td>
                        <td class=titleseparator valign="middle" width=14 align="center">|</td>
						<td class=toolbar valign="middle" ><A class= itemfontlink href="hierarchyPostDetail.asp?postID=<%=request("postID")%>">Back</A></td>											
					</table>
				  </td>
				</tr>
				<tr>
				  <td>
					<table width=100% border=0 cellpadding=0 cellspacing=0>
					  <tr>
						<td height=22pxpx colspan="3">&nbsp;</td>
					  </tr>
					  <tr class=columnheading>
					    <td width=2% valign="middle" height=22px>&nbsp;</td>
						<td width=13% valign="middle" height=22px>Post:</td>
						<td width=85% valign="middle" height=22px class=itemfont><INPUT class="inputbox itemfont" style="WIDTH: 300px" maxLength=50 name="txtDescription" id="txtDescription" Value="<%=rsRecSet("Description")%>"></td>
					  </tr>
					  <tr class=columnheading>
			            <td width=2% valign="middle" height=22px>&nbsp;</td>
						<td width=13% valign="middle" height=22px>Assignment Number:</td>
						<td width=85% valign="middle" height=22px class=itemfont><INPUT class="inputbox itemfont" style="WIDTH: 300px" maxLength=50 name="txtassignno" id="txtassignno" Value="<%=rsRecSet("assignno")%>"></td>
					  </tr>
					  <%if session("administrator")=1 then%>
					  <tr class=columnheading>
			            <td valign="middle" width=2% height=22px>&nbsp;</td>
						<td valign="middle" height=22px>Unit:</td>
						<td valign="middle" height=22px class=itemfont >
						<Select  class="inputbox" Name="hrcID" id="hrcID">
						<%Do while not rsHrcList.eof%>
						<option value=<%=rsHrcList("hrcID")%> <%if rsRecSet("hrcID")=rsHrcList("hrcID") then response.write (" Selected")%>><%=rsHrcList("hrcname")%></B></option>
						<%rsHrcList.MoveNext
						Loop%>
						</Select>
						</td>
					  </tr>
					  <%else%>
					    <input type=hidden name="hrcID" id="hrcID" value = <%=rsRecSet("hrcID")%>>
					  <%end if%>
					  <tr class=columnheading>
			            <td valign="middle" height=22px width=2%>&nbsp;</td>
						<td valign="middle" height=22px>Position:</td>
						<td valign="middle" height=22px class=itemfont><INPUT class="inputbox itemfont" style="WIDTH: 300px" maxLength=50 name="position" id="position" Value="<%=rsRecSet("position")%>"></td>
					  </tr>
					  <tr class=columnheading>
			            <td valign="middle" height=22px width=2%>&nbsp;</td>
						<td valign="middle" height=22px>Rank:</td>
						<td valign="middle" height=22px class=itemfont >
						<Select  class="inputbox" name="RankID" id="RankID">
						<%Do while not rsRankList.eof%>
						<option value=<%=rsRankList("RankID")%> <%if rsRecSet("RankID")=rsRankList("RankID") then response.write (" Selected")%>><%=rsRankList("shortdesc")%></option>
						<%rsRankList.MoveNext
						Loop%>
						</Select>
						</td>
					  </tr>
					  <tr class=columnheading>
			            <td valign="middle" width=2% height=22px>&nbsp;</td>
						<td valign="middle" height=22px>Trade:</td>
						<td valign="middle" height=22px class=itemfont >
						<Select  class="inputbox" name="TradeID" id="TradeID">
						<%Do while not rsTradeList.eof%>
						<option value=<%=rsTradeList("TradeID")%> <%if rsRecSet("TradeID")=rsTradeList("TradeID") then response.write (" Selected")%>><%=rsTradeList("description")%></option>
						<%rsTradeList.MoveNext
						Loop%>
						</Select>
						</td>
					  </tr>
					  <tr class=columnheading>
			            <td valign="middle" width=2% height=22px>&nbsp;</td>
						<td valign="middle" height=22px>Rank Weighting:</td>
						<td valign="middle" height=22px class=itemfont >
                            <Select  class="inputbox" Name="RWID" id="RWID">
                                 <option value="0"> </option>
                                <%Do while not rsRankWeightList.eof%>
                                <option value=<%=rsRankWeightList("RWID")%> <%if rsRecSet("RWID")=rsRankWeightList("RWID") then response.write (" Selected")%>><%=rsRankWeightList("description")%></option>
                                <%rsRankWeightList.MoveNext
                                Loop%>
                            </Select> 
						  <!--<span class="style2">WARNING This affects Capability - Only Assign to Established Posts</span> -->
                         </td>
					  </tr>
					  <tr class=columnheading>
			            <td valign="middle" width=2%>&nbsp;</td>
						<td valign=top>Notes:</td>
						<td valign="middle" class=itemfont ><Textarea  Name="Notes" id="Notes" class=itemfont rows=3 cols=48 ><%=rsRecSet("Notes")%></textarea></td>
					  </tr>
                      <!--  We might use these in future so just comment them out for now - CMS2 -->
                      <!--
					  <tr class=columnheading>
			            <td valign="middle" width=2% height=22px>&nbsp;</td>
						<td valign="middle" height=22px>Qualification Overide:</td>
						<td valign="middle" height=22px class=itemfont >
						<Select  class="inputbox" Name="QOveride" id="QOveride">
						<option value=1 <%'if rsRecSet("QOveride")=True then response.write (" Selected")%>>Yes</option>
						<option value=0 <%'if rsRecSet("QOveride")=False then response.write (" Selected")%>>No</option>
						</Select>
						</td>
					  </tr>
					  <tr class=columnheading>
			            <td valign="middle" width=2% height=22px>&nbsp;</td>
						<td valign="middle" height=22px>MS Overide:</td>
						<td valign="middle" height=22px class=itemfont >
						<Select  class="inputbox" Name=MSOveride id="MSOveride">
						<option value=1 <%'if rsRecSet("MSOveride")=True then response.write (" Selected")%>>Yes</option>
						<option value=0 <%'if rsRecSet("MSOveride")=False then response.write (" Selected")%>>No</option>
						</Select>
						</td>
					  </tr>
                      <tr class=columnheading>
			            <td valign="middle" width=2% height=22px>&nbsp;</td>
						<td valign="middle" height=22px>Post OverBorne:</td>
						<td valign="middle" height=22px class=itemfont >
						<Select  class="inputbox" Name=overborne id="overborne">
						<option value=0 <%'if rsRecSet("overborne")=False then response.write (" Selected")%>>No</option>
						<option value=1 <%'if rsRecSet("overborne")=True then response.write (" Selected")%>>Yes</option>
						</Select>
						</td>
					  </tr>    
                      -->
                      <tr class=columnheading>
			            <td valign="middle" height="22px" width=2%></td>
						<td valign="middle" height="22px">Manager:</td>
						<td valign="middle" height="22px" class=itemfont>
						<Select  class="inputbox" Name=Manager id="Manager">
						<option value=0 <%if rsRecSet("Manager") = "NULL" then response.write (" Selected")%>>No</option>
						<option value=1 <%if rsRecSet("Manager") <> "NULL" then response.write (" Selected")%>>Yes</option>
						</Select>
						</td>
					  </tr>  
     
					  <tr>
						<td colspan="3" height=22px>&nbsp;</td>
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

function checkThis()
{
	//This function renoves any leading or trailing spaces from a string
	String.prototype.killWhiteSpace = function()
	{
		return this.replace(/\s/g, '');
	};

    // if they changed units make sure they are NOT managers
    var hrcID=document.frmDetails.hrcID.value;
	var hrcold=document.frmDetails.hrcold.value;
	if(hrcID != hrcold){
		document.frmDetails.Manager.value=0;
	}
    
	var errMsg = "Please provide/correct the following:\n\n";
	var error = false;
	  
	var Post = document.frmDetails.txtDescription.value;
	Post = Post.killWhiteSpace(); 
	var AssignNo = document.frmDetails.txtassignno.value;
	AssignNo = AssignNo.killWhiteSpace();

   // alert("Check This " + hrcID + " * " +  document.frmDetails.txtDescription.value);
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