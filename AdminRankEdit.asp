<!DOCTYPE HTML >

<!--#include file="Includes/security.inc"--> 
<!--#include file="Includes/checkadmin.asp"-->
<!--#include file="Connection/Connection.inc"-->

<%
dim strAction
strAction="Update"
strTable = "tblRank"
strRecid = "rankID"
strCommand = "spRecDetail"

set objCmd = server.CreateObject("ADODB.Command")
set objPara = server.CreateObject("ADODB.Parameter")
objCmd.ActiveConnection = con
objCmd.CommandText = strCommand
objCmd.CommandType = 4		

set objPara = objCmd.CreateParameter ("RecID",3,1,5, request("RecID"))
objCmd.Parameters.Append objPara
set objPara = objCmd.CreateParameter ("TableID",200,1,50, strRecID)
objCmd.Parameters.Append objPara
set objPara = objCmd.CreateParameter ("Tablename",200,1,50, strTable)
objCmd.Parameters.Append objPara

set rsRecSet = objCmd.Execute	'Execute CommandText when using "ADODB.Command" object

for x = 1 to objCmd.parameters.count
	objCmd.parameters.delete(0)
next

strTable = "tblRankWeight"
strCommand = "spListTable"
objCmd.CommandText = strCommand
objCmd.CommandType = 4	

' default nodeID to 1 cos we this will be the same table across all nodes
set objPara = objCmd.CreateParameter ("nodeID",3,1,0, 1)
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
<form  action="UpdateRank.asp?strAction=<%=strAction%>" method="POST" name="frmDetails">
  <input type=hidden name=recID id="recID" value=<%=request("recID")%>>  
  <table  height="100%" cellspacing=0 cellPadding=0 width=100% border=0>
    	<tr>
    		<td>
                <!--#include file="Includes/Header.inc"--> 
  				<table cellSpacing=0 cellPadding=0 width=100% border=0 >
                    <tr style="font-size:10pt;" height=26px>
                        <td width=10><img style="margin-left:10px;" src="cms_icons/png/24x24/process.png" width="24" height="24"></td>
                        <td class="staticdatamenu"><font class="youAreHere">CMS Admin Menu / <strong>Edit Rank</strong></font></td>
                    </tr>
                    <tr><td colspan=2 class=titlearealine  height=1></td></tr>
				</table>
          
  		  <table width=100% height='<%=session("heightIs")%>px' border=0 cellpadding=0 cellspacing=0> 
      		<tr valign=Top>
        	  <td class="sidemenuwidth" background="Images/tableback.png"><!--#include file="Includes/datamenu.inc"--></td>



						<td width=16></td>
				       	<td align=left >
							<table border=0 cellpadding=0 cellspacing=0 width=100%>
								<tr height=16 class=SectionHeader>
									<td>
										<table border=0 cellpadding=0 cellspacing=0 >
											<td class=toolbar width=8></td><td width=20><a  href="javascript:checkThis();"><img class="imagelink" src="images/saveitem.gif"></A></td>
											
											<td class=toolbar valign="middle" >Save and Close</td><td class=titleseparator valign="middle" width=14 align="center">|</td>
											<td class=toolbar valign="middle" ><A class= itemfontlink href="AdminRankDetail.asp?recID=<%=request("recID")%>">Back</A></td>											
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
												<td valign="middle" width=13%>Rank:</td>
												<td valign="middle" width=85%><INPUT name=txtRank class="inputbox itemfont" id="txtRank" style="WIDTH: 360px" Value="<%=rsRecSet("shortDesc")%>" maxLength=300></td>
											</tr>
											<tr class=columnheading height=22>
												<td valign="middle" width=2%>&nbsp;</td>
												<td valign="middle" width=13%>Description:</td>
												<td valign="middle" width=85%><INPUT name=txtDescription class="inputbox itemfont" id="txtDescription" style="WIDTH: 360px" 
												Value="<%if rsRecSet("Description")="" or isnull(rsRecSet("Description")) then%>
												<%response.write("There is currently no description for this rank.")%>
												<%Else response.write rsRecSet("Description")%>
												<%End if%>" maxLength=300></td>
											</tr>
											<tr class=columnheading height=22>
												<td valign="middle" width=2%>&nbsp;</td>
												<td valign="middle" width=13%>Status:</td>
												<td valign="middle" width=85% class=itemfont>
                                                <Select  class="inputbox" Name=Status id="Status">
												<option value=1 <%if rsRecSet("Status")=true then response.write (" Selected")%>>Active</option>
												<option value=0 <%if rsRecSet("Status")=false then response.write (" Selected")%>>Inactive</option>
												</Select>												
												</td>
											</tr>
											<tr class=columnheading height=22>
												<td valign="middle" width=2%>&nbsp;</td>
												<td valign="middle" width=13%>Weight:</td>
												<td valign="middle" width=85% class=itemfont>
												<Select  class="inputbox"  Name=Weight id="Weight">												
												<%
												statusCounter=0
												do while statusCounter < 100%>
												<option value=<%=statusCounter%> <%if rsRecSet("Weight")=statusCounter then response.write (" Selected")%>><%=statusCounter%></option>
												<%statusCounter=statusCounter+1%>
												<%Loop%>
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

	var errMsg = "Please provide/correct the following:\n\n";
	var error = false;
	  
	var Rank = document.frmDetails.txtRank.value;
	Rank = Rank.killWhiteSpace(); 
	var Description = document.frmDetails.txtDescription.value;
	Description = Description.killWhiteSpace();

	/* make sure they have entered comments for the next stage */
	if(Rank == "")
	{
		errMsg += "Rank\n"
		error = true;
	}

	if(Description == "")
	{
		errMsg += "Description"
		error = true;
	}   

	if(error == true)
	{
		alert(errMsg)
		return;	  		
	} 

	frmDetails.submit();  
}

</Script>
