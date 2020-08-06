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
<form action="UpdateUnitHP.asp?strAction=<%=strAction%>" method="POST" name="frmDetails">
	<input type=hidden name=Harmony PeriodID value=<%=request("Harmony PeriodID")%>>  
	<table height="100%" cellspacing=0 cellPadding=0 width=100% border=0>
    	<tr>
    		<td>
            	<!--#include file="Includes/Header.inc"-->
  				<table cellSpacing=0 cellPadding=0 width=100% border=0 >
                    <tr style="font-size:10pt;" height=26px>
                        <td width=10><img style="margin-left:10px;" src="cms_icons/png/24x24/process.png" width="24" height="24"></td>
                        <td class="staticdatamenu"><font class="youAreHere">CMS Admin Menu / <strong>Add New Unit Harmony</strong></font></td>
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
											<td class=toolbar valign="middle" ><A class= itemfontlink href="AdminHPList.asp">Back To List</A></td>											
										</table>
									</td>
								</tr>
							</table>
                            <table width="100%" border="0" cellpadding="0" cellspacing="0">
                                <tr>
                                    <td height=22>&nbsp;</td>
                                </tr>
								<tr>
                                	<td width="2%"></td>
									<td width="98%">
                                        <table width="500px" border="0" cellpadding="0" cellspacing="0">
                                            <tr class=columnheading>
                                                <td height=22>&nbsp;</td>
                                                <td colspan="6" height=22><span class="style10">NB: All Unit Harmony Targets are Minumum and Maximum Percentages.</span></td>
                                            </tr>
                                            <tr class=columnheading>
                                                <td colspan="7" height=22>&nbsp;</td>
                                            </tr>
                                            <tr class=columnheading>
                                                <td valign="middle" height=22></td>
                                                <td colspan="6" valign="middle" height=22><span class="style7"><strong>Out of Area (OOA) Unit Harmony Targets</strong></span></td>
                                            </tr>
                                            <tr class=columnheading>
                                                <td valign="middle" height=22></td>
                                                <td height=22 valign="middle"></td>
                                                <td height=22 valign="middle">Minimum</td>
                                                <td height=22 valign="middle"></td>
                                                <td colspan="3" valign="middle" height=22>Maximum</td>
                                            </tr>
                                            <tr class=columnheading height=22>
                                                <td width="4px" valign="middle"></td> 
                                                <td width="140px" valign="middle"><span class="style7"><font color="#006600"><strong>Green Limits: </strong></font> </span></td>
                                                <td width="44px" valign="middle"><INPUT name=ooagrnmin class="itemfont" size="10" value="" maxLength=10></td>
                                                <td width="84px" valign="middle">%</td>
                                                <td width="44px" valign="middle"><INPUT name=ooagrnmax class="itemfont" size="10" value="" maxLength=10></td>
                                                <td width="84px" valign="middle">%</td>
                                            </tr>
                                            <tr class=columnheading height=22>
                                                <td valign="middle"></td> 
                                                <td valign="middle"><span class="style7"><font color="#FFCC00"><strong>Yellow Limits:</strong></font> </span></td>
                                                <td valign="middle"><INPUT name=ooayelmin class="itemfont" size="10" value="" maxLength=10></td>
                                                <td valign="middle">%</td>
                                                <td valign="middle"><INPUT name=ooayelmax class="itemfont" size="10" value="" maxLength=10></td>
                                                <td valign="middle">%</td>
                                            </tr>
                                            <tr class=columnheading height=22>
                                                <td valign="middle" ></td> 
                                                <td valign="middle"><span class="style7"><font color="#FF6600"><strong>Amber Limits:</strong></font> </span></td>
                                                <td valign="middle"><INPUT name=ooaambmin class="itemfont" size="10" value="" maxLength=10></td>
                                                <td valign="middle">%</td>
                                                <td valign="middle"><INPUT name=ooaambmax class="itemfont" size="10" value="" maxLength=10></td>
                                                <td valign="middle">%</td>
                                            </tr>
                                            <tr class=columnheading height=22>
                                                <td valign="middle"></td> 
                                                <td valign="middle"><span class="style7"><font color="#FF0000"><strong>Red Limits:</strong></font> </span></td>
                                                <td valign="middle"><INPUT name=ooared class="itemfont" size="10" value="" maxLength=10></td>
                                                <td valign="middle">%</td>
                                                <td colspan="2" valign="middle"></td>
                                            </tr>
                                            <tr height=16>
                                                <td colspan="6"></td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="2" class=titlearealine height=1></td> 
                                </tr>
                                <tr>
                                	<td width="2%"></td>
                                    <td width="98%">
                                        <table width="500px" border="0" cellpadding="0" cellspacing="0">
                                            <tr class=columnheading>
                                                <td colspan="7" height=22>&nbsp;</td>
                                            </tr>
                                            <tr class=columnheading>
                                                <td valign="middle" height=22></td>
                                                <td colspan="6" valign="middle" height=22><span class="style7"><strong>Bed Nights Away (BNA) Unit Harmony Targets</strong></span></td>
                                            </tr>
                                            <tr class=columnheading>
                                                <td valign="middle" height=22></td>
                                                <td height=22 valign="middle"></td>
                                                <td height=22 valign="middle">Minimum</td>
                                                <td height=22 valign="middle"></td>
                                                <td colspan="3" valign="middle" height=22>Maximum</td>
                                            </tr>
                                            <tr class=columnheading height=22>
                                                <td width="4px" valign="middle"></td> 
                                                <td width="140px" valign="middle"><span class="style7"><font color="#006600"><strong>Green Limits: </strong></font> </span></td>
                                                <td width="44px" valign="middle"><INPUT name=bnagrnmin class="itemfont" size="10" value="" maxLength=10></td>
                                                <td width="84px" valign="middle">%</td>
                                                <td width="44px" valign="middle"><INPUT name=bnagrnmax class="itemfont" size="10" value="" maxLength=10></td>
                                                <td width="84px" valign="middle">%</td>
                                            </tr>
                                            <tr class=columnheading height=22>
                                                <td valign="middle"></td> 
                                                <td valign="middle"><span class="style7"><font color="#FFCC00"><strong>Yellow Limits:</strong></font> </span></td>
                                                <td valign="middle"><INPUT name=bnayelmin class="itemfont" size="10" value="" maxLength=10></td>
                                                <td valign="middle">%</td>
                                                <td valign="middle"><INPUT name=bnayelmax class="itemfont" size="10" value="" maxLength=10></td>
                                                <td valign="middle">%</td>
                                            </tr>
                                            <tr class=columnheading height=22>
                                                <td valign="middle" ></td> 
                                                <td valign="middle"><span class="style7"><font color="#FF6600"><strong>Amber Limits:</strong></font> </span></td>
                                                <td valign="middle"><INPUT name=bnaambmin class="itemfont" size="10" value="" maxLength=10></td>
                                                <td valign="middle">%</td>
                                                <td valign="middle"><INPUT name=bnaambmax class="itemfont" size="10" value="" maxLength=10></td>
                                                <td valign="middle">%</td>
                                            </tr>
                                            <tr class=columnheading height=22>
                                                <td valign="middle"></td> 
                                                <td valign="middle"><span class="style7"><font color="#FF0000"><strong>Red Limits:</strong></font> </span></td>
                                                <td valign="middle"><INPUT name=bnared class="itemfont" size="10" value="" maxLength=10></td>
                                                <td valign="middle">%</td>
                                                <td colspan="2" valign="middle"></td>
                                            </tr>
                                            <tr height=16>
                                                <td colspan="6"></td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="2" class=titlearealine  height=1></td> 
                                </tr>
                                <tr class=columnheading height=22> 
                                    <td colspan="2" valign="middle" ><div align="center"></div></td>
                                </tr>
                                <tr class=columnheading height=22> 
                                    <td colspan="2" align="center" style="color:#000066; font-weight:bold;">
                                        The Percentage of Unit Personnel breaking Harmony Status determines the Unit Harmony Status<br><br>
                                        eg: OOA % = 3.75 Unit OOA Status is <font color="#336600">GREEN</font> BNA % = 4.05 Unit BNA Status is <font color="#FF6600">AMBER</font>
                                    </td>
                                </tr>
                                <tr class=columnheading height=22>
                                    <td colspan="2" valign="middle" >&nbsp;</td>
                                </tr>
                                <tr> 
                                    <td colspan="2" class=titlearealine height=1></td>
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
	
	// OOA Targets
	var ogn = document.frmDetails.ooagrnmin.value;
	ogn = ogn.killWhiteSpace();
	var ogx = document.frmDetails.ooagrnmax.value;
	ogx = ogx.killWhiteSpace();
	
	var oyn = document.frmDetails.ooayelmin.value;
	oyn = oyn.killWhiteSpace();
	var oyx = document.frmDetails.ooayelmax.value;
	oyx = oyx.killWhiteSpace();
	
	var oan = document.frmDetails.ooaambmin.value;
	oan = oan.killWhiteSpace();
	var oax = document.frmDetails.ooaambmax.value;
	oax = oax.killWhiteSpace();
	
	var orx = document.frmDetails.ooared.value;
	orx = orx.killWhiteSpace();
	
	// BNA Targets
	var bgn = document.frmDetails.bnagrnmin.value;
	bgn = bgn.killWhiteSpace();
	var bgx = document.frmDetails.bnagrnmax.value;
	bgx = bgx.killWhiteSpace();
	
	var byn = document.frmDetails.bnayelmin.value;
	byn = byn.killWhiteSpace();
	var byx = document.frmDetails.bnayelmax.value;
	byx = byx.killWhiteSpace();
	
	var ban = document.frmDetails.bnaambmin.value;
	ban = ban.killWhiteSpace();
	var bax = document.frmDetails.bnaambmax.value;
	bax = bax.killWhiteSpace();
	
	var brx = document.frmDetails.bnared.value;
	brx = brx.killWhiteSpace();

	var re = /[a-z,A-Z\^,£<>$":;{}\[\]\*\+\-_=~#@?\\\/%\'!¬`¦&]/g;

	/* make sure they entered OOA Target details */
	if(ogn == "") {
	   errMsg += "OOA Green Minimum Limit\n"
	   error = true;
	   }
		
	if(re.test(ogn))
	{
		errMsg += "OOA Green Minimum Limit - Numeric characters only\n";
		error = true;
	}
	   
	if(ogx == "") {
	   errMsg += "OOA Green Maximum Limit\n"
	   error = true;
	   }
		
	if(re.test(ogx))
	{
		errMsg += "OOA Green Maximum Limit - Numeric characters only\n";
		error = true;
	}

	if(oyn == "") {
	   errMsg += "OOA Yellow Minimum Limit\n"
	   error = true;
	   }
		
	if(re.test(oyn))
	{
		errMsg += "OOA Yellow Minimum Limit - Numeric characters only\n";
		error = true;
	}
	   
	if(oyx == "") {
	   errMsg += "OOA Yellow Maximum Limit\n"
	   error = true;
	   }
		
	if(re.test(oyx))
	{
		errMsg += "OOA Yellow Maximum Limit - Numeric characters only\n";
		error = true;
	}

	if(oan == "") {
	   errMsg += "OOA Amber Minimum Limit\n"
	   error = true;
	   }
		
	if(re.test(oan))
	{
		errMsg += "OOA Amber Minimum Limit - Numeric characters only\n";
		error = true;
	}
	   
	if(oax == "") {
	   errMsg += "OOA Amber Maximum Limit\n"
	   error = true;
	   }
		
	if(re.test(oax))
	{
		errMsg += "OOA Amber Maximum Limit - Numeric characters only\n";
		error = true;
	}

	if(orx == "") {
	   errMsg += "OOA Red Limit\n"
	   error = true;
	   }
		
	if(re.test(orx))
	{
		errMsg += "OOA Red Limit - Numeric characters only\n";
		error = true;
	}

//-------------------------------------------------------------------------------------------------------------------------------------

	/* make sure they entered BNA Target details */
	if(bgn == "") {
	   errMsg += "BNA Green Minimum Limit\n"
	   error = true;
	   }
		
	if(re.test(bgn))
	{
		errMsg += "BNA Green Minimum Limit - Numeric characters only\n";
		error = true;
	}
	   
	if(bgx == "") {
	   errMsg += "BNA Green Maximum Limit\n"
	   error = true;
	   }
		
	if(re.test(bgx))
	{
		errMsg += "BNA Green Maximum Limit - Numeric characters only\n";
		error = true;
	}

	if(byn == "") {
	   errMsg += "BNA Yellow Minimum Limit\n"
	   error = true;
	   }
		
	if(re.test(byn))
	{
		errMsg += "BNA Yellow Minimum Limit - Numeric characters only\n";
		error = true;
	}

	if(byx == "") {
	   errMsg += "BNA Yellow Maximum Limit\n"
	   error = true;
	   }
		
	if(re.test(byx))
	{
		errMsg += "BNA Yellow Maximum Limit - Numeric characters only\n";
		error = true;
	}

	if(ban == "") {
	   errMsg += "BNA Amber Minimum Limit\n"
	   error = true;
	   }
		
	if(re.test(ban))
	{
		errMsg += "BNA Amber Minimum Limit - Numeric characters only\n";
		error = true;
	}
	   
	if(bax == "") {
	   errMsg += "BNA Amber Maximum Limit\n"
	   error = true;
	   }
		
	if(re.test(bax))
	{
		errMsg += "BNA Amber Maximum Limit - Numeric characters only\n";
		error = true;
	}

	if(brx == "") {
	   errMsg += "BNA Red Limit\n"
	   error = true;
	   }
		
	if(re.test(brx))
	{
		errMsg += "BNA Red Limit - Numeric characters only\n";
		error = true;
	}
	  
// Now make sure they are in the right order
	if(ogn > ogx) {
		errMsg += "OOA Green Minimum Limit cannot be greater then the OOA Green Maximum Limit\n"
		error = true;
	   }

	if(oyn > oyx) {
		errMsg += "OOA Yellow Minimum Limit cannot be greater then the OOA Yellow Maximum Limit\n"
		error = true;
	   }

	if(oan > oax) {
		errMsg += "OOA Amber Minimum Limit cannot be greater then the OOA Amber Maximum Limit\n"
		error = true;
	   }

	if(bgn > bgx) {
		errMsg += "BNA Green Minimum Limit cannot be greater then the BNA Green Maximum Limit\n"
		error = true;
	   }

	if(byn > byx) {
		errMsg += "BNA Yellow Minimum Limit cannot be greater then the BNA Yellow Maximum Limit\n"
		error = true;
	   }

	if(ban > bax) {
		errMsg += "BNA Amber Minimum Limit cannot be greater then the BNA Amber Maximum Limit\n"
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
