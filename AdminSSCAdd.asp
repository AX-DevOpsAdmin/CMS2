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
<form action="UpdateSSC.asp?strAction=<%=strAction%>" method="POST" name="frmDetails">
  <input type=hidden name=sscType id="sscType" value=<%=0%>>  
  <table height="100%" cellspacing=0 cellPadding=0 width=100% border=0>
    	<tr>
    		<td>
                <!--#include file="Includes/Header.inc"-->
  				<table cellSpacing=0 cellPadding=0 width=100% border=0 >
                    <tr style="font-size:10pt;" height=26px>
                        <td width=10><img style="margin-left:10px;" src="cms_icons/png/24x24/process.png" width="24" height="24"></td>
                        <td class="staticdatamenu"><font class="youAreHere">CMS Admin Menu / <strong>Add SSC</strong></font></td>
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
											<td class=toolbar valign="middle" ><A class= itemfontlink href="AdminSSCList.asp">Back To List</A></td>											
										</table>
									</td>
									
								</tr>
								<tr>
									<td>
										<table width=100% border=0 cellpadding=0 cellspacing=0>
											<tr height=16>
												<td colspan="3">&nbsp;</td>
											</tr>
											<tr class=columnheading height=22>
												<td valign="middle" width="2%">&nbsp;</td>
												<td valign="middle" width="13%">SS Code:</td>
												<td valign="middle" width="85%"><INPUT name=sscode id="sscode" class="itemfont" size="3" maxLength=3></td>
											</tr>
											<tr class=columnheading height=22>
												<td valign="middle" width="2%">&nbsp;</td>
												<td valign="middle" width="13%">Description:</td>
												<td valign="middle" width="85%"><INPUT name=description class="itemfont" id="txtdescription" style="WIDTH: 360px" maxLength=300></td>
											</tr>
											<tr class=columnheading height=22>
												<td valign="middle" width="2%">&nbsp;</td>
												<td valign=top width="13%">Notes:</td>
												<td valign="middle" width="85%"><textarea name="txtnotes" rows="5" class="pickbox" id="txtnotes" ></textarea></td>
											</tr>
											<tr height=16>
												<td colspan="3">&nbsp;</td>
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
	
	var ssc = document.frmDetails.sscode.value;
	ssc = ssc.killWhiteSpace();
	var d = document.frmDetails.txtdescription.value;
	d = d.killWhiteSpace();
	var re = /[a-z,A-Z\^,�<>$":;{}\[\]\*\.+\-_=~#@?\\\/%\'!�`�&]/g;

	/* make sure they have entered comments for the next stage */
	if(ssc == "")
	{
		errMsg += "SS Code\n"
		error = true;
	}

	if(re.test(ssc))
	{
		errMsg += "SS Code - Numeric characters only\n";
		error = true;
	}

	if(d == "")
	{
		errMsg += "Description\n"
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
