<!DOCTYPE HTML >
<!--#include file="Includes/security.inc"--> 
<!--#include file="Includes/checkadmin.asp"-->
<!--#include file="Connection/Connection.inc"-->

<%
dim strAction
strAction="Add"
%>

<html>
<head> 

<!--#include file="Includes/IECompatability.inc"-->

<title><%= PageTitle %></title>
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
<form  action="UpdateService.asp?strAction=<%=strAction%>" method="POST" name="frmDetails">
  <input type=hidden name=RankID id="RecID" value=<%=request("RankID")%>>  
  <table  height="100%" cellspacing=0 cellPadding=0 width=100% border=0>
    	<tr>
    		<td>
                <!--#include file="Includes/Header.inc"-->
  				<table cellSpacing=0 cellPadding=0 width=100% border=0 >
    				<tr >
      					<td align="center" width=200 ><img alt="" src="images/spssites.gif" ></td>
       					<td  class=titlearea >Services<BR><span class="style1"><Font class=subheading>New Service Details</Font></span></td>
    				</tr>
   
  					<tr>
       					<td colspan=2 class=titlearealine  height=1></td> 
     				</tr>
  				</table>
  				<table width=100% height='<%=session("heightIs")%>px' border=0 cellpadding=0 cellspacing=0 > 
      				<tr valign=Top>
        				<td width=200 background="Images/tableback.png">
                            <table width=100% border=0 cellpadding=0 cellspacing=0 class=MenuStyleParent>
                              <tr height=22>
                                 <td width=10></td>
                                 <td colspan=3 align=left height=22>Current Location</td>
                              </tr>
                              <tr height=22>
                                 <td></td>
                                 <td width="18" valign=top><img src="images/arrow.gif"></td>
                                 <td width="170" align=Left><A title="" href="index.asp">Home</A></td>
                                 <td width="50" align=Left></td>
                              </tr>
                              <tr height=22>
                                <td ></td>
                                <td valign=top><img src="images/arrow.gif"></td>
                                <td align=Left><A title="" href="AdminHome.asp">Administration</A></td>
                                <td align=Left></td>
                              </tr>
                              <tr height=22>
                                <td></td>
                                <td valign=top><img src="images/arrow.gif"></td>
                                <td align=Left><A title="" href="AdminDataMenu.asp">Static Data</a></td>
                                <td align=Left></td>
                              </tr>
                              <tr height=22>
                                <td></td>
                                <td valign=top><img src="images/arrow.gif"></td>
                                <td align=Left><A title="" href="AdminServiceList.asp">Services</a></td>
                                <td align=Left></td>
                              </tr>
                              <tr height=22>
                                <td></td>
                                <td valign=top></td>
                                <td align=Left bgcolor="#FFFFFF"><Div style="height:18px; width:16em; border:Solid; border-width:1px; border-color:#438BE4; color: #003399;">&bull;&nbsp;New Service</Div></td>
                                <td align=Left  ></td>
                              </tr>
                            </table>
						</td>
						<td width=16></td>
				       	<td align=left >
							<table border=0 cellpadding=0 cellspacing=0 width=100%>
								<tr height=16 class=SectionHeader>
									<td>
										<table border=0 cellpadding=0 cellspacing=0 >
											<td class=toolbar width=8></td><td width=20><a  href="javascript:checkThis();"><img class="imagelink" src="images/saveitem.gif"></A></td>
											
											<td class=toolbar valign="middle">Save and Close</td><td class=titleseparator valign="middle" width=14 align="center">|</td>
											<td class=toolbar valign="middle"><A class= itemfontlink href="AdminServiceList.asp">Back To List</A></td>											
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
												<td valign="middle" width=13%>Service:</td>
												<td valign="middle" width=85%><INPUT name=txtRank class="itemfont" id="txtService" style="WIDTH: 360px" Value="" maxLength=300></td>
											</tr>
											<tr class=columnheading height=22>
												<td valign="middle" width=2%>&nbsp;</td>
												<td valign="middle" width=13%>Description:</td>
												<td valign="middle" width=85%><INPUT name=txtDescription class="itemfont" id="txtDescription" style="WIDTH: 360px" Value="" maxLength=300></td>
											</tr>
											<tr class=columnheading height=22>
												<td valign="middle" width=2%></td>
												<td valign="middle" width=13%>Status:</td>
												<td valign="middle" width=85% class=itemfont>
												<Select  class="itemfont" Name=Status>
												<option value=1 >Active</option>
												<option value=0 >Inactive</option>
												</Select>												
												</td>
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

	document.frmDetails.submit();  
}

</Script>
