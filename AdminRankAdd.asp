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
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
</head>
<body>
<form  action="UpdateRank.asp?strAction=<%=strAction%>" method="POST" name="frmDetails">
  <input type=hidden name=RankID value=<%=request("RankID")%>>  
  <table  height="100%" cellspacing=0 cellPadding=0 width=100% border=0>
    	<tr>
    		<td>
                <!--#include file="Includes/Header.inc"-->
  				<table cellSpacing=0 cellPadding=0 width=100% border=0 >
                    <tr style="font-size:10pt;" height=26px>
                        <td width=10><img style="margin-left:10px;" src="cms_icons/png/24x24/process.png" width="24" height="24"></td>
                        <td class="staticdatamenu"><font class="youAreHere">CMS Admin Menu / <strong>Add New Rank</strong></font></td>
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
											
											<td class=toolbar valign="middle">Save and Close</td><td class=titleseparator valign="middle" width=14 align="center">|</td>
											<td class=toolbar valign="middle"><A class= itemfontlink href="AdminRankList.asp">Back To List</A></td>											
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
												<td valign="middle" width=13%>Rank:</td>
												<td valign="middle" width=85%><INPUT name=txtRank class="inputbox itemfont" id="txtRank" style="WIDTH: 360px" Value="" maxLength=300></td>
											</tr>
											<tr class=columnheading height=22>
												<td valign="middle" width=2%>&nbsp;</td>
												<td valign="middle" width=13%>Description:</td>
												<td valign="middle" width=85%><INPUT name=txtDescription class="inputbox itemfont" id="txtDescription" style="WIDTH: 360px" Value="" maxLength=300></td>
											</tr>
											<tr class=columnheading height=22>
												<td valign="middle" width=2%></td>
												<td valign="middle" width=13%>Status:</td>
												<td valign="middle" width=85% class=itemfont>
												<Select  class="inputbox" Name=Status>
												<option value=1 >Active</option>
												<option value=0 >Inactive</option>
												</Select>												
												</td>
											</tr>
											<tr class=columnheading height=22>
												<td valign="middle" width=2%></td>
												<td valign="middle" width=13%>Weight:</td>
												<td valign="middle" width=85% class=itemfont>
												<Select  class="inputbox" Name=Weight>
												
												<%
												statusCounter=0
												do while statusCounter< 100%>
												<option value=<%=statusCounter%>><%=statusCounter%></option>
												<%statusCounter=statusCounter+1%>
												<%Loop%>
												</Select>
												
												</td>
												<td valign="middle" width=2%></td>
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

     
	 frmDetails.submit();  
}

</Script>
