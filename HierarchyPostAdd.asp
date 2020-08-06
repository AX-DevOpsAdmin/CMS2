<!DOCTYPE HTML >

<!--#include file="Includes/security.inc"--> 
<!--#include file="Connection/Connection.inc"-->
<!--#include file="Includes/checkmanager.inc"-->  
<!--#include file="Includes/manageradmin.inc"-->  
<%
Tab=10
dim strAction
strAction="Add"
 
set objCmd = server.CreateObject("ADODB.Command")
set objPara = server.CreateObject("ADODB.Parameter")
objCmd.ActiveConnection = con

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
set objPara = objCmd.CreateParameter ("nodeID",3,1,5, 1)
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
-->
</style>

</head>
<body>
<form action="UpdatePost.asp?strAction=<%=strAction%>" method="post" name="frmDetails">
<input type=hidden name=recID id="RecID" value=<%=request("recID")%>>
<Input name="strGoto" id="strGoTo" type="hidden" value="hierarchyPostDetail.asp">
<Input name="Manager" id="Manager" type="hidden" value=0>
<input name="Status" id="Status" type="hidden" value=1>
			  <table border=0 cellpadding=0 cellspacing=0 width=100%>
<!--#include file="Includes/hierarchyPostDetails.inc"-->
				<tr height=16 class=SectionHeader>
				  <td>
					<table border=0 cellpadding=0 cellspacing=0 >
						<td class=toolbar width=8></td>
                        <td width=20><a href="javascript:frmDetails.submit();" onClick="javascript:return(CheckForm());"><img class="imagelink" src="images/saveitem.gif"></A></td>
						<td class=toolbar valign="middle" >Save and Close</td>
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
					    <td valign="middle" width=2% height="22px">&nbsp;</td>
						<td valign="middle" width=13% height="22px">Post:</td>
						<td valign="middle" width=85% height="22px" class=itemfont><INPUT class="inputbox itemfont" style="WIDTH: 300px" maxLength=300 name="txtDescription" id="txtDescription"></td>
					  </tr>
					  <tr class=columnheading>
			            <td valign="middle" width=2% height="22px">&nbsp;</td>
						<td valign="middle" height="22px">Assignment Number:</td>
						<td valign="middle" height="22px" class=itemfont><INPUT class="inputbox itemfont" style="WIDTH: 300px" maxLength=50 name="txtassignno" id="txtassignno"></td>
					  </tr>
					  <tr class=columnheading>
			            <td valign="middle" width=2% height="22px">&nbsp;</td>
						<td valign="middle" height="22px">Unit:</td>
						<td valign="middle" height="22px" class=itemfont >
						<Select  class="inputbox" Name="hrcID" id="hrcID">
						<%Do while not rsHrcList.eof%>
						   <option value=<%=rsHrcList("hrcID")%> ><%=rsHrcList("hrcname")%></option>
						<%rsHrcList.MoveNext
						Loop%>
						</Select>
						</td>
					  </tr>
					  <tr class=columnheading>
			            <td valign="middle" width=2% height="22px">&nbsp;</td>
						<td valign="middle" height="22px">Position:</td>
						<td valign="middle" height="22px" class=itemfont><INPUT class="inputbox itemfont" style="WIDTH: 300px" maxLength=50 name="position" id="position"></td>
					  </tr>
					  <tr class=columnheading>
			            <td valign="middle" width=2% height="22px">&nbsp;</td>
						<td valign="middle" height="22px">Rank:</td>
						<td valign="middle" height="22px" class=itemfont >
						<Select  class="inputbox" Name="RankID" id="RankID">
						<%Do while not rsRankList.eof%>
						   <option value=<%=rsRankList("RankID")%> ><%=rsRankList("shortdesc")%></option>
						<%rsRankList.MoveNext
						Loop%>
						</Select>
						</td>
					  </tr>
					  <tr class=columnheading>
			            <td valign="middle" width=2% height="22px">&nbsp;</td>
						<td valign="middle" height="22px">Trade:</td>
						<td valign="middle" height="22px" class=itemfont >
						<Select  class="inputbox" Name="TradeID" id="TradeID">
						<%Do while not rsTradeList.eof%>
						   <option value=<%=rsTradeList("TradeID")%> ><%=rsTradeList("description")%></option>
						<%rsTradeList.MoveNext
						Loop%>
						</Select>
						</td>
					  </tr>
					  <tr class=columnheading>
			            <td valign="middle" width=2% height="22px">&nbsp;</td>
						<td valign="middle" height="22px">Rank Weighting:</td>
						<td valign="middle" height="22px" class=itemfont >
						<Select  class="inputbox" Name="RWID" id="RWID">
						<%Do while not rsRankWeightList.eof%>
						<option value=<%=rsRankWeightList("RWID")%> ><%=rsRankWeightList("description")%></option>
						<%rsRankWeightList.MoveNext
						Loop%>
						</Select>
						</td>
					  </tr>
					  <tr class=columnheading>
			            <td valign="middle" width=2%>&nbsp;</td>
						<td valign=top>Notes:</td>
						<td valign="middle" class=itemfont><Textarea  name="Notes" id="Notes" class=itemfont Rows=3 cols=48 ></textarea></td>
					  </tr>
					  <tr class=columnheading>
			            <td valign="middle" width=2% height="22px">&nbsp;</td>
						<td valign="middle" height="22px">Qualification Overide:</td>
						<td valign="middle" height="22px" class=itemfont >
						<Select  class="inputbox" Name="QOveride" id="QOveride">
						<option value=0 >No</option>
						<option value=1 >Yes</option>
						</Select>
						</td>
					  </tr>
					  <tr class=columnheading>
			            <td valign="middle" width=2% height="22px">&nbsp;</td>
						<td valign="middle" height="22px">MS Overide:</td>
						<td valign="middle" height="22px" class=itemfont >
						<Select  class="inputbox" Name=MSOveride id="MSOveride">
						<option value=0 >No</option>
						<option value=1 >Yes</option>
						</Select>
						</td>
					  </tr>
                      <tr class=columnheading>
			            <td valign="middle" width=2% height="22px">&nbsp;</td>
						<td valign="middle" height="22px">Post OverBorne:</td>
						<td valign="middle" height="22px" class=itemfont >
						<Select  class="inputbox" Name="overborne" id="overborne">
						<option value=0 >No</option>
						<option value=1 >Yes</option>
						</Select>
						</td>
					  </tr>   
					  <tr>
						<td colspan="3" height="22px">&nbsp;</td>
					  </tr>
					  <tr>
       					<td colspan=3 class=titlearealine height=1></td> 
     				  </tr>
					</table>
				  </td>
				</tr>
			  </table>
	</form>
<%

con.close
set con=Nothing
%>
</body>
</html>


<Script Language="Javascript">

function CheckForm() {
	var passed=true;
	if (document.forms["frmDetails"].elements["txtDescription"].value =="") {
	alert("Please enter Post Description");
	passed=false;
	}
	
	if (document.forms["frmDetails"].elements["txtassignno"].value =="") {
	alert("Please enter Assignment Number");
	passed=false;
	}
	
	return passed;
}

function getRanks(serID) {
	ajax('ddPostRanks.asp','serID='+serID,'rnkdiv');
}

</Script>