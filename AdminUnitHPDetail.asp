<!DOCTYPE HTML >

<!--#include file="Includes/security.inc"--> 
<!--#include file="Includes/checkadmin.asp"-->
<!--#include file="Connection/Connection.inc"-->

<%
strTable = "tblUnitHarmonyTarget"
strTabID = "uhpID"              ' key field name for table        

strRecid = "uhpID"

strGoTo = "AdminHPList.asp"   ' asp page to return to once record is deleted
strCommand = "spGetUnitHP"

set objCmd = server.CreateObject("ADODB.Command")
set objPara = server.CreateObject("ADODB.Parameter")
objCmd.ActiveConnection = con
objCmd.CommandText = strCommand
objCmd.CommandType = 4		

'set objPara = objCmd.CreateParameter ("RecID",3,1,5, request("RecID"))
'objCmd.Parameters.Append objPara
'set objPara = objCmd.CreateParameter ("TableID",200,1,50, strRecID)
'objCmd.Parameters.Append objPara
'set objPara = objCmd.CreateParameter ("Tablename",200,1,50, strTable)
'objCmd.Parameters.Append objPara

set objPara = objCmd.CreateParameter ("nodeID",3,1,0, nodeID)
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
<form action="" method="POST" name="frmDetails">
	<table height="100%" cellspacing=0 cellPadding=0 width=100% border=0>
    	<tr>
    		<td>
            	<!--#include file="Includes/Header.inc"-->
				<table cellSpacing=0 cellPadding=0 width=100% border=0 >
                    <tr style="font-size:10pt;" height=26px>
                        <td width=10><img style="margin-left:10px;" src="cms_icons/png/24x24/process.png" width="24" height="24"></td>
                        <td class="staticdatamenu"><font class="youAreHere">CMS Admin Menu / <strong>Unit Harmony Details</strong></font></td>
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
                                            <td width=20><a class=itemfontlink href="AdminUnitHPEdit.asp?RecID=<%=rsRecSet("uhpID")%>"><img class="imagelink" src="images/editgrid.gif"></A></td>
										    <td valign="middle" class=toolbar>Edit Harmony Limits</td>
                                            <!--
											<td class=titleseparator valign="middle" width=14 align="center">|</td>
											<td valign="middle" class=toolbar ><A class=itemfontlink href="AdminUnitHPList.asp">Back To List</A></td>	
                                            -->										
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
                                            <tr class=itemfont height=22>
                                                <td width="4px" valign="middle"></td> 
                                                <td width="140px" valign="middle"><span class="style7"><font color="#006600"><strong>Green Limits: </strong></font> </span></td>
                                                <td width="44px" valign="middle"><%=rsRecSet("ooagrnmin")%>%</td>
                                                <td width="84px" align="center"></td>
                                                <td width="44px" valign="middle"><%=rsRecSet("ooagrnmax")%>%</td>
                                                <td width="84px" valign="middle"></td>
                                            </tr>
                                            <tr class=itemfont height=22>
                                                <td valign="middle"></td> 
                                                <td valign="middle"><span class="style7"><font color="#FFCC00"><strong>Yellow Limits:</strong></font> </span></td>
                                                <td valign="middle"><%=rsRecSet("ooayelmin")%>%</td>
                                                <td align="center"></td>
                                                <td valign="middle"><%=rsRecSet("ooayelmax")%>%</td>
                                                <td valign="middle"></td>
                                            </tr>
                                            <tr class=itemfont height=22>
                                                <td valign="middle" ></td> 
                                                <td valign="middle"><span class="style7"><font color="#FF6600"><strong>Amber Limits:</strong></font> </span></td>
                                                <td valign="middle"><%=rsRecSet("ooaambmin")%>%</td>
                                                <td align="center"></td>
                                                <td valign="middle"><%=rsRecSet("ooaambmax")%>%</td>
                                                <td valign="middle"></td>
                                            </tr>
                                            <tr class=itemfont height=22>
                                                <td valign="middle"></td> 
                                                <td valign="middle"><span class="style7"><font color="#FF0000"><strong>Red Limits:</strong></font> </span></td>
                                                <td valign="middle"><%=rsRecSet("ooared")%>%</td>
                                                <td valign="middle"></td>
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
                                            <tr class=itemfont height=22>
                                                <td width="4px" valign="middle"></td> 
                                                <td width="140px" valign="middle"><span class="style7"><font color="#006600"><strong>Green Limits: </strong></font> </span></td>
                                                <td width="44px" valign="middle"><%=rsRecSet("bnagrnmin")%>%</td>
                                                <td width="84px" align="center"></td>
                                                <td width="44px" valign="middle"><%=rsRecSet("bnagrnmax")%>%</td>
                                                <td width="84px" valign="middle"></td>
                                            </tr>
                                            <tr class=itemfont height=22>
                                                <td valign="middle"></td> 
                                                <td valign="middle"><span class="style7"><font color="#FFCC00"><strong>Yellow Limits:</strong></font> </span></td>
                                                <td valign="middle"><%=rsRecSet("bnayelmin")%>%</td>
                                                <td align="center"></td>
                                                <td valign="middle"><%=rsRecSet("bnayelmax")%>%</td>
                                                <td valign="middle"></td>
                                            </tr>
                                            <tr class=itemfont height=22>
                                                <td valign="middle"></td> 
                                                <td valign="middle"><span class="style7"><font color="#FF6600"><strong>Amber Limits:</strong></font> </span></td>
                                                <td valign="middle"><%=rsRecSet("bnaambmin")%>%</td>
                                                <td align="center"></td>
                                                <td valign="middle"><%=rsRecSet("bnaambmax")%>%</td>
                                                <td valign="middle"></td>
                                            </tr>
                                            <tr class=itemfont height=22>
                                                <td valign="middle"></td> 
                                                <td valign="middle"><span class="style7"><font color="#FF0000"><strong>Red Limits:</strong></font> </span></td>
                                                <td valign="middle"><%=rsRecSet("bnared")%>%</td>
                                                <td valign="middle"></td>
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
<%
rsRecSet.close
set rsRecSet=Nothing
con.close
set con=Nothing
%>
</body>
</html>
<SCRIPT LANGUAGE="JavaScript">
function checkDelete(){
     var delOK = false 
    
	  var input_box = confirm("Are you sure you want to delete this Record ?")
	  if(input_box==true) {
		    delOK = true;
	    }
    return delOK;
}
</Script>
<SCRIPT LANGUAGE="JavaScript">
/**
function OverBackgroundChange(itemID){
    itemID.className='testTabHover';
}

function OutBackgroundChange(itemID){
    itemID.className='testTabUnselected';
}
RowColor=1
function ChangeRowColor(RowID){
	if (RowColor == 1) {
		document.all[RowID].style.backgroundColor= '#eeeeee'
		RowColor=2
	} else {
		document.all[RowID].style.backgroundColor= '#ffffff'
		RowColor=1
	}	
}
function ConfirmRefuse (LoanID, Action) {
	document.forms["Form"].elements["LoanID"].value=LoanID;
	document.forms["Form"].elements["ConfirmOrRefuse"].value=Action;
	document.forms["Form"].submit();
}
**/
</Script>
