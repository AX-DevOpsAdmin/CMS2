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
objCmd.CommandText = "spFitnessDetail"	'Name of Stored Procedure
objCmd.CommandType = 4				'Code for Stored Procedure

set objPara = objCmd.CreateParameter ("RecID",3,1,5, request("RecID"))
objCmd.Parameters.Append objPara
set rsRecSet = objCmd.Execute	'Execute CommandText when using "ADODB.Command" object

for x = 1 to objCmd.parameters.count
	objCmd.parameters.delete(0)
next

strTable = "tblValPeriod"
strCommand = "spListTable"
objCmd.CommandText = strCommand

set objPara = objCmd.CreateParameter ("nodeID",3,1,5, nodeID)
objCmd.Parameters.Append objPara

set objPara = objCmd.CreateParameter ("TableName",200,1,50, strTable)
objCmd.Parameters.Append objPara
set rsVP = objCmd.Execute	'Execute CommandText when using "ADODB.Command" object
%>

<html>
<head>

<!--#include file="Includes/IECompatability.inc"-->


<title><%= PageTitle %></title>
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
<form action="UpdateFitness.asp?strAction=<%=strAction%>" method="post" name="frmDetails">
<input type="hidden" name="recID" id="recID" value="<%=request("recID")%>">
  <table  height="100%" cellspacing=0 cellPadding=0 width=100% border=0>
    <tr>
      <td>
        <!--#include file="Includes/Header.inc"-->
		<table cellSpacing=0 cellPadding=0 width=100% border=0 >
                    <tr style="font-size:10pt;" height=26px>
                        <td width=10><img style="margin-left:10px;" src="cms_icons/png/24x24/process.png" width="24" height="24"></td>
                        <td class="staticdatamenu"><font class="youAreHere">CMS Admin Menu / <strong>Edit Fitness Detail</strong></font></td>
                    </tr>
  		  <tr>
       		<td colspan=2 class=titlearealine  height=1></td> 
     	  </tr>
  		</table>
  		<table width=100% height='<%=session("heightIs")%>px' border=0 cellpadding=0 cellspacing=0 > 
      	  <tr valign=Top>
            <td class="sidemenuwidth" background="Images/tableback.png"><!--#include file="Includes/datamenu.inc"--></td>
			<td width=16></td>
		    <td align=left >
			  <table border=0 cellpadding=0 cellspacing=0 width=100%>
				<tr height=16 class=SectionHeader>
				  <td>
					<table border=0 cellpadding=0 cellspacing=0 >
						<td class=toolbar width=8></td><td width=20><a  href="javascript:checkThis();"><img class="imagelink" src="images/saveitem.gif"></A></td>					
						<td class=toolbar valign="middle" >Save and Close</td>
                        <td class=titleseparator valign="middle" width=14 align="center">|</td>
						<td class=toolbar valign="middle" ><A class= itemfontlink href="AdminFitnessDetail.asp?recID=<%=request("recID")%>">Back</A></td>											
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
					    <td valign="middle" width=2%>&nbsp;</td>
						<td valign="middle" width=13%>Fitness:</td>
						<td valign="middle" width=85% class=itemfont><INPUT class="itemfont" style="WIDTH: 340px" maxLength="300" name="description" id="description" Value="<%=rsRecSet("description")%>"></td>
					  </tr>
					  <tr class=columnheading height=22>
			            <td valign="middle" width="2%">&nbsp;</td>
						<td valign="middle" width="13%">Validity Period:</td>
						<td valign="middle" width="85%" class=itemfont>
						<Select  class="itemfont" Name="VPID" id="VPID" style="width:80px;">
                        <option value="0">...Select</option>
						<%Do while not rsVP.eof%>
						<option value=<%=rsVP("vpID")%> <%if rsRecSet("vpID")=rsVP("vpID") then response.write (" Selected")%>><%=rsVP("description")%></option>
						<%rsVP.MoveNext
						Loop%>
						</Select>
						</td>
					  </tr>
					  <tr class=columnheading height=22>
					    <td valign="middle" width=2%>&nbsp;</td>
						<td valign="middle" width=13%>Combat Ready:</td>
						<td valign="middle" width=85% class=itemfont><INPUT type="checkbox" name="chkCombat" id="chkCombat" value="1" <% if rsRecSet("Combat") = true then %>checked<% end if %>></td>
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
	  
	var fit = document.frmDetails.description.value;
	fit = fit.killWhiteSpace();
	var vp = document.frmDetails.VPID.value;

	/* make sure they have entered comments for the next stage */
	if(fit == "")
	{
		errMsg += "Fitness\n"
		error = true;
	}

	if(vp == 0)
	{
		errMsg += "Validity Period"
		error = true;
	}

if(error == true)
	{
		alert(errMsg)
		return;	  		
	} 
	
    document.frmDetails.submit();  
}

</Script>
