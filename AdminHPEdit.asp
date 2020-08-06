<!DOCTYPE HTML >

<!--#include file="Includes/security.inc"--> 
<!--#include file="Includes/checkadmin.asp"-->
<!--#include file="Connection/Connection.inc"-->

<%
dim strAction
strAction="Update"

strTable = "tblHarmonyPeriod"
strTabID = "hpID"              ' key field name for table        

strRecid = "hpID"

strGoTo = "AdminHPList.asp"   ' asp page to return to once record is deleted
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

%>

<html>
<head>

<!--#include file="Includes/IECompatability.inc"-->


<title><%= PageTitle %></title>
<link rel="stylesheet" type="text/css" href="Includes/AMDB.css" media="Screen"/>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
</head>
<body>
<form action="UpdateHP.asp?strAction=<%=strAction%>" method="POST" name="frmDetails">
	<input type="hidden" name="recID" id="recID" value="<%=request("recID")%>">  
	<table height="100%" cellspacing=0 cellPadding=0 width=100% border=0>
    	<tr>
    		<td>
                <!--#include file="Includes/Header.inc"-->
  				<table cellSpacing=0 cellPadding=0 width=100% border=0 >
                    <tr style="font-size:10pt;" height=26px>
                        <td width=10><img style="margin-left:10px;" src="cms_icons/png/24x24/process.png" width="24" height="24"></td>
                        <td class="staticdatamenu"><font class="youAreHere">CMS Admin Menu / <strong>Edit Harmony Periods</strong></font></td>
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
											<td class=toolbar width=8></td><td width=20><a href="javascript:checkThis();"><img class="imagelink" src="images/saveitem.gif"></A></td>
											<td class=toolbar valign="middle" >Save and Close</td><td class=titleseparator valign="middle" width=14 align="center">|</td>
											<td class=toolbar valign="middle" ><A class= itemfontlink href="AdminHPDetail.asp?RecID=<%=request("RecID")%>">Back </A></td>											
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
                                        <table width=770px border=0 cellpadding=0 cellspacing=0>
                                            <tr class=columnheading>
                                                <td height=22>&nbsp;</td>
                                                <td colspan="3"><span class="style10">NB: All Harmony Periods are Rolling Periods in Months ie: 20 = 20 Months</span></td>
                                            </tr>
                                            <tr>
                                                <td colspan="4" height=22>&nbsp;</td>
                                            </tr>
                                            <tr class=columnheading>
                                                <td valign="middle" height=22></td>
                                                <td colspan="3" valign="middle" height=22><span class="style7"><strong>Out of Area (OOA) Harmony Period Limits</strong></span></td>
                                            </tr>
                                            <tr class=columnheading height=22>
                                                <td valign="middle"></td>
                                                <td valign="middle">OOA Harmony Period:</td>
                                                <td colspan="2" valign="middle"><INPUT name="ooaper" id="ooaper" class="itemfont" size="3" maxLength="3" value="<%=rsRecSet("ooaperiod")%>"></td>
                                            </tr>
                                            <tr class=columnheading height=22>
                                                <td width="4px" valign="middle"></td>
                                                <td width="150px" valign="middle">Red Days:</td>
                                                <td width="40px" valign="middle"><INPUT name="ooared" id="ooared" class="itemfont" size="3" maxLength=3 value="<%=rsRecSet("ooared")%>"></td>
                                                <td width="600px" valign="middle"><span class="style7">The number of Operational Days Away in a Rolling Period before the Harmony Status is</span><span class="style10"> RED</span></td>
                                            </tr>
                                            <tr class=columnheading height=22>
                                                <td valign="middle"></td>
                                                <td valign="middle">Amber Days:</td>
                                                <td valign="middle"><INPUT name="ooaamber" id="ooaamber" class="itemfont" size="3" maxLength=3 value="<%=rsRecSet("ooaamber")%>"></td>
                                                <td valign="middle"><span class="style7">The number of Operational Days Away in a Rolling Period before the Harmony Status is</span> <span class="style12"> AMBER</span></td>
                                            </tr>
                                            <tr>
                                                <td colspan="4" height=22>&nbsp;</td>
                                            </tr>
                                            <tr class=columnheading>
                                                <td valign="middle" height=22></td>
                                                <td colspan="3" valign="middle"><span class="style7"><strong>SSC A Harmony Period Limits</strong></span></td>
                                            </tr>
                                            <tr class=columnheading height=22>
                                                <td valign="middle"></td>
                                                <td valign="middle">SSC A Harmony Period:</td>
                                                <td colspan="2" valign="middle"><INPUT name="ssaper" id="ssaper" class="itemfont" size="3" maxLength=3 value="<%=rsRecSet("ssaperiod")%>"></td>
                                            </tr>
                                            <tr class=columnheading height=22>
                                                <td valign="middle"></td>
                                                <td valign="middle">Red Days:</td>
                                                <td valign="middle"><INPUT name="ssared"  id="ssared" class="itemfont" size="3" maxLength=3 value="<%=rsRecSet("ssared")%>"></td>
                                                <td valign="middle"><span class="style7">The number of Seperated Service (A) Days in a Rolling Period before the Harmony Status is </span><span class="style10"> RED</span></td>
                                            </tr>
                                            <tr class=columnheading height=22>
                                                <td valign="middle"></td>
                                                <td valign="middle">Amber Days:</td>
                                                <td valign="middle"><INPUT name="ssaamber" id="ssaamber" class="itemfont" size="3" maxLength=3 value="<%=rsRecSet("ssaamber")%>"></td>
                                                <td valign="middle"><span class="style7">The number of Seperated Service (A) Days in a Rolling Period before the Harmony Status is</span> <span class="style12"> AMBER</span></td>
                                            </tr>
                                            <tr>
                                                <td colspan="4" height=22>&nbsp;</td>
                                            </tr>
                                            <tr class=columnheading height=22>
                                                <td valign="middle"></td>
                                                <td colspan="3" valign="middle"><span class="style7"><strong>SSC B Harmony Period Limits</strong></span></td>
                                            </tr>
                                            <tr class=columnheading height=22>
                                                <td valign="middle"></td>
                                                <td valign="middle">SSC B Harmony Period:</td>
                                                <td colspan="2" valign="middle"><INPUT name="ssbper" id="ssbper" class="itemfont" size="3" maxLength=3 value="<%=rsRecSet("ssbperiod")%>"></td>
                                            </tr>
                                            <tr class=columnheading height=22>
                                                <td valign="middle"></td>
                                                <td valign="middle">Red Days:</td>
                                                <td valign="middle"><INPUT name="ssbred" id="ssbred" class="itemfont" size="3" maxLength=3 value="<%=rsRecSet("ssbred")%>"></td>
                                                <td valign="middle"><span class="style7">The number of Seperated Service (B) Days in a Rolling Period before the Harmony Status is </span><span class="style10"> RED</span></td>
                                            </tr>
                                            <tr class=columnheading height=22>
                                                <td valign="middle"></td>
                                                <td valign="middle">Amber Days:</td>
                                                <td valign="middle"><INPUT name="ssbamber" id="ssbamber" class="itemfont" size="3" maxLength=3 value="<%=rsRecSet("ssbamber")%>"></td>
                                                <td valign="middle"><span class="style7">The number of Seperated Service (B) Days in a Rolling Period before the Harmony Status is</span> <span class="style12"> AMBER</span></td>
                                            </tr>
                                            <tr>
                                                <td colspan="4" height=22>&nbsp;</td>
                                            </tr>
                                        </table>
                                    </td>
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
	
	// OOA Period
	var ooa = document.frmDetails.ooaper.value;
	ooa = ooa.killWhiteSpace();
	var ore = document.frmDetails.ooared.value;
	ore = ore.killWhiteSpace();
	var oam = document.frmDetails.ooaamber.value;
	oam = oam.killWhiteSpace();
	 
	//SSC A Period
	var ssa = document.frmDetails.ssaper.value;
	ssa = ssa.killWhiteSpace();
	
	var sar = document.frmDetails.ssared.value;
	sar = sar.killWhiteSpace();
	var saa = document.frmDetails.ssaamber.value;
	saa = saa.killWhiteSpace();

	//SSC B Period
	var ssb = document.frmDetails.ssbper.value;
	ssb = ssb.killWhiteSpace();
	var sbr = document.frmDetails.ssbred.value;
	sbr = sbr.killWhiteSpace();
	var sba = document.frmDetails.ssbamber.value;
	sba = sba.killWhiteSpace();
	
	var re = /[a-z,A-Z\^,£<>$":;{}\[\]\*\.+\-_=~#@?\\\/%\'!¬`¦&]/g;
	
	/* make sure they have entered comments for the next stage */
	if(ooa == "")
	{
		errMsg += "OOA Harmony Period\n";
		error = true;
	}
		
	if(re.test(ooa))
	{
		errMsg += "OOA Harmony Period - Numeric characters only\n";
		error = true;
	}

	if(ore == "")
	{
		errMsg += "OOA Red Days\n";
		error = true;
	}
		
	if(re.test(ore))
	{
		errMsg += "OOA Red Days - Numeric characters only\n";
		error = true;
	}

	if(oam == "")
	{
		errMsg += "OOA Amber Days\n";
		error = true;
	}
		
	if(re.test(oam))
	{
		errMsg += "OOA Amber Days - Numeric characters only\n";
		error = true;
	}
	
//-------------------------------------------------------------------------------------------------------------------------------------

	if(ssa == "")
	{
		errMsg += "SSC A Harmony Period\n";
		error = true;
	}
		
	if(re.test(ssa))
	{
		errMsg += "SSC A Harmony Period - Numeric characters only\n";
		error = true;
	}

	if(sar == "")
	{
		errMsg += "SSC A Red Days\n";
		error = true;
	}
		
	if(re.test(sar))
	{
		errMsg += "SSC A Red Days - Numeric characters only\n";
		error = true;
	}

	if(saa == "")
	{
		errMsg += "SSC A Amber Days\n";
		error = true;
	}
		
	if(re.test(saa))
	{
		errMsg += "SSC A Amber Days - Numeric characters only\n";
		error = true;
	}
	
//-------------------------------------------------------------------------------------------------------------------------------------

	if(ssb == "")
	{
		errMsg += "SSC B Harmony Period\n";
		error = true;
	}
		
	if(re.test(ssb))
	{
		errMsg += "SSC B Harmony Period - Numeric characters only\n";
		error = true;
	}

	if(sbr == "")
	{
		errMsg += "SSC B Red Days\n";
		error = true;
	}
		
	if(re.test(sbr))
	{
		errMsg += "SSC B Red Days - Numeric characters only\n";
		error = true;
	}

	if(sba == "")
	{
		errMsg += "SSC B Amber Days\n";
		error = true;
	}
		
	if(re.test(sba))
	{
		errMsg += "SSC B Amber Days - Numeric characters only\n";
		error = true;
	}
	
//-------------------------------------------------------------------------------------------------------------------------------------

	if(error == true)
	{
		alert(errMsg)
		return;	  		
	} 

	document.frmDetails.submit();  
}

</Script>
