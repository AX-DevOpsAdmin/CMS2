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
<form  action="UpdateValP.asp?strAction=<%=strAction%>" method="POST" name="frmDetails">
  <input type=hidden name=Validity PeriodID value=<%=request("Validity PeriodID")%>>  
  <table  height="100%" cellspacing=0 cellPadding=0 width=100% border=0>
    	<tr>
    		<td>
                <!--#include file="Includes/Header.inc"-->
  				<table cellSpacing=0 cellPadding=0 width=100% border=0 >
                    <tr style="font-size:10pt;" height=26px>
                        <td width=10><img style="margin-left:10px;" src="cms_icons/png/24x24/process.png" width="24" height="24"></td>
                        <td class="staticdatamenu"><font class="youAreHere">CMS Admin Menu / <strong>Add New Validity Period</strong></font></td>
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
											<td class=toolbar width=8></td>
                                            <td width=20><a  href="javascript:checkThis();"><img class="imagelink" src="images/saveitem.gif"></A></td>
											<td class=toolbar valign="middle" >Save and Close</td><td class=titleseparator valign="middle" width=14 align="center">|</td>
											<td class=toolbar valign="middle" ><A class= itemfontlink href="AdminValPList.asp">Back To List</A></td>											
										</table>
									</td>
									
								</tr>
								<tr>
									<td>
										<table width=100% border=0 cellpadding=0 cellspacing=0>
											<tr height=16>
												<td width="1%"></td>
											</tr>
											<tr class=columnheading height=22>
												<td valign="middle" width="2%">&nbsp;</td>
												<td valign="middle" width="13%">Validity Period:</td>
												<td valign="middle" width="85%"><INPUT name=vpLength class="itemfont" size="3" maxLength=3></td>
											</tr>
											<tr class=columnheading height=22>
												<td valign="middle" width="2%">&nbsp;</td>
												<td valign="middle" width="13%">Period Type:</td>
												<td valign="middle" width="85%" class=itemfont>
												<Select  class="itemfont" Name=vpType style="width:80px;">
                                                	<option value="0">...Select</option>
												     <option value=1 >Days</option>
												     <option value=2 >Weeks</option>
													 <option value=3 >Months</option>
													<!-- <option value=4 >Years</option>-->
												</Select>
												</td>
											</tr>
											<tr class=columnheading height=22>
												<td valign="middle" width="2%">&nbsp;</td>
												<td valign="middle" width="13%">Description:</td>
												<td valign="middle" width="85%"><INPUT name=description class="itemfont" id="txtdescription" style="WIDTH: 360px" maxLength=300></td>
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
	
	var vpl = document.frmDetails.vpLength.value;
	vpl = vpl.killWhiteSpace();
	var d = document.frmDetails.description.value;
	d = d.killWhiteSpace();
	var vpt = document.frmDetails.vpType.value;
	var re = /[a-z,A-Z\^,£<>$":;{}\[\]\*\.+\-_=~#@?\\\/%\'!¬`¦&]/g;

	/* make sure they have entered comments for the next stage */
	if(vpl == "")
	{
		errMsg += "Validity Period\n";
		error = true;
	}

	if(re.test(vpl))
	{
		errMsg += "Validity Period - Numeric characters only\n";
		error = true;
	}
	
	if(vpt == 0)
	{
		errMsg += "Period Type\n";
		error = true;
	}	

	if(d == "")
	{
		errMsg += "Description\n";
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
