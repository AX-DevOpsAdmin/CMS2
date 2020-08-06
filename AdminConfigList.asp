<!DOCTYPE HTML >

<!--#include file="Includes/security.inc"--> 
<!--#include file="Includes/checkadmin.asp"-->
<!--#include file="Connection/Connection.inc"-->

<%

' This is the Initial Display Page of Group table data

' so the menu include - datamenu.inc knows what page we're on
dim strPage
strPage="Config"

strTable = "tblGroup"
strCommand = "spConfigList"

set objCmd = server.CreateObject("ADODB.Command")
set objPara = server.CreateObject("ADODB.Parameter")
objCmd.ActiveConnection = con
objCmd.CommandText = strCommand
objCmd.CommandType = 4		

set objPara = objCmd.CreateParameter ("nodeID",3,1,4, nodeID)
objCmd.Parameters.Append objPara

set rsRecSet = objCmd.execute	'Execute CommandText when using "ADODB.Command" object
%>

<html>
<head>

<!--#include file="Includes/IECompatability.inc"-->


<title><%= PageTitle %></title>
<link rel="stylesheet" type="text/css" href="Includes/AMDB.css" media="Screen"/>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">

</head>
<body>
<form  action="" method="POST" name="frmDetails">
	<Input name="groupID" id="groupID" type="Hidden">
	<!--#include file="Includes/Header.inc"--> 
	<table cellSpacing=0 cellPadding=0 width=100% border=0 >
                    <tr style="font-size:10pt;" height=26px>
                        <td width=10><img style="margin-left:10px;" src="cms_icons/png/24x24/process.png" width="24" height="24"></td>
                        <td class="staticdatamenu"><font class="youAreHere">CMS Admin Menu / <strong>Configuration</strong></font></td>
                    </tr>
                    <tr><td colspan=2 class=titlearealine  height=1></td></tr>
				</table>
          
  		  <table width=100% height='<%=session("heightIs")%>px' border=0 cellpadding=0 cellspacing=0> 
      		<tr valign=Top>
        	  <td class="sidemenuwidth" background="Images/tableback.png"><!--#include file="Includes/datamenu.inc"--></td>



						<td align=left>
							<table border=0 cellpadding=0 cellspacing=0 width=100%>
								<tr height=16 class=SectionHeader>
									<td>
										<table border=0 cellpadding=0 cellspacing=0 >
											<tr>
												<td class=toolbar width=8>&nbsp;</td>
												<td width=20><a class=itemfontlink href="AdminConfigEdit.asp?configID=<%=rsRecSet("configID")%>"><img class="imagelink" src="images/newitem.gif"></a></td>
												<td class=toolbar valign="middle">Edit Configuration</td>
											</tr>  
										</table>
									</td>
								</tr>
								<tr>
									<td>
										<table width=100% border=0 cellpadding=0 cellspacing=0>
                                          <!--
											<tr class=columnheading height="30">
												<td width=2%>&nbsp;</td>
												<td align="left" width=30%>Personnel</td>
                                                <td align="center" width="10%">
                                                	Active
                                                    <table width="100%" border="0" cellpadding="0" cellspacing="0">
                                                    	<tr>
                                                            <td width="35" align="center">Yes</td>
                                                        	<td width="30">&nbsp;</td>
                                                        	<td width="35" align="center">No</td>
                                                        </tr>
                                                    </table>
                                                </td>
                                                <td width="58%">&nbsp;</td>
											</tr>
											<tr>
       											<td colspan="4" class=titlearealine  height=1></td> 
     					    				</tr>
                                            <tr class=itemfont ID="" height="30">
                                                <td width=2%>&nbsp;</td>
                                                <td align="left" width="30%">Unit Planner:</td>
                                                <td align="center" width="10%">
													<table width="100px" border="0" cellpadding="0" cellspacing="0">
														<tr>
															<td align="center"><%' if rsRecSet("pla") = true then %><img src="Images/yes.gif" alt="active"><%' else %><img src="Images/no.gif" alt="disabled"><%' end if %></td>
                                                            <td width="30">&nbsp;</td>
															<td align="center"><%' if rsRecSet("pla") = true then %><img src="Images/no.gif" alt="disabled"><%' else %><img src="Images/yes.gif" alt="active"><%' end if %></td>
														</tr>
													</table>
                                                </td> 
                                                <td width="58%">&nbsp;</td>
                                            </tr>
                                            <tr>
                                                <td colspan="4" class=titlearealine  height=1></td> 
                                            </tr>
                                            <tr>
                                            	<td colspan="4" height="50px">&nbsp;</td>
                                            </tr>
                                            <tr class=columnheading height="30">
                                            	<td width="2%">&nbsp;</td>
                                                <td align="left" width="30%">Tasking</td>
                                                <td align="center" width="10%">&nbsp;</td> 
                                                <td width="58%">&nbsp;</td>
                                            </tr>
											<tr>
       											<td colspan="4" class=titlearealine  height=1></td> 
     					    				</tr>
                                            <tr class=itemfont ID="man" height="30">
                                                <td width=2%>&nbsp;</td>
                                                <td align="left" width="30%">Units:</td> 
                                                <td align="center" width="10%">
													<table width="100px" border="0" cellpadding="0" cellspacing="0">
														<tr>
															<td align="center"><% 'if rsRecSet("tas") = true then %><img src="Images/yes.gif" alt="active"><% 'else %><img src="Images/no.gif" alt="disabled"><%' end if %></td>
                                                            <td width="30">&nbsp;</td>
															<td align="center"><% 'if rsRecSet("tas") = true then %><img src="Images/no.gif" alt="disabled"><% 'else %><img src="Images/yes.gif" alt="active"><%' end if %></td>
														</tr>
													</table>
                                                </td> 
                                                <td width="58%">&nbsp;</td>
                                            </tr>
                                            
                                            <tr>
                                                <td colspan="4" class=titlearealine  height=1></td> 
                                            </tr>
                                           
                                            <tr>
                                            	<td colspan="4" height="50px">&nbsp;</td>
                                            </tr>
                                            -->
                                            <tr class=columnheading height="30">
                                            	<td width="2%">&nbsp;</td>
                                                <td align="left" width="17%">Reports</td>
                                                <td align="center" width="7%">&nbsp;</td> 
                                                <td width="74%">&nbsp;</td>
                                            </tr>
											<tr>
       											<td colspan="4" class=titlearealine  height=1></td> 
     					    				</tr>
                                            <tr class=itemfont ID="man" height="30">
                                                <td width=2%>&nbsp;</td>
                                                <td align="left" width="17%">Manning:</td> 
												<td align="center"><% if rsRecSet("man") = true then %><img src="Images/yes.gif" alt="active"><% else %><img src="Images/no.gif" alt="disabled"><% end if %></td>
                                            </tr>
                                            <tr>
                                                <td colspan="4" class=titlearealine  height=1></td> 
                                            </tr>
                                            <tr class=itemfont ID="per" height="30">
                                                <td width=2%>&nbsp;</td>
                                                <td align="left" width="17%">Personnel Harmony:</td> 
												<td align="center"><% if rsRecSet("per") = true then %><img src="Images/yes.gif" alt="active"><% else %><img src="Images/no.gif" alt="disabled"><% end if %></td>
                                            </tr>
                                            <tr>
                                                <td colspan="4" class=titlearealine  height=1></td> 
                                            </tr>
                                            <tr class=itemfont ID="uni" height="30">
                                                <td width=2%>&nbsp;</td>
                                                <td align="left" width="17%">Unit Harmony:</td> 
												<td align="center"><% if rsRecSet("uni") = true then %><img src="Images/yes.gif" alt="active"><% else %><img src="Images/no.gif" alt="disabled"><% end if %></td>
                                            </tr>
                                            <tr>
                                                <td colspan="4" class=titlearealine  height=1></td> 
                                            </tr>
                                            <tr class=itemfont ID="fit" height="30">
                                                <td width=2%>&nbsp;</td>
                                                <td align="left" width="17%">RAF Fitness:</td> 
												<td align="center"><% if rsRecSet("fit") = true then %><img src="Images/yes.gif" alt="active"><% else %><img src="Images/no.gif" alt="disabled"><% end if %></td>
                                            </tr>
                                            <tr>
                                                <td colspan="4" class=titlearealine  height=1></td> 
                                            </tr>
                                            <tr class=itemfont ID="boa" height="30">
                                                <td width=2%>&nbsp;</td>
                                                <td align="left" width="17%">Management Board:</td> 
												<td align="center"><% if rsRecSet("boa") = true then %><img src="Images/yes.gif" alt="active"><% else %><img src="Images/no.gif" alt="disabled"><% end if %></td>
                                            </tr>
                                            <tr>
                                                <td colspan="4" class=titlearealine  height=1></td> 
                                            </tr>
                                            <tr class=itemfont ID="sta" height="30">
                                                <td width=2%>&nbsp;</td>
                                                <td align="left" width="17%">Staff Auth Limits:</td> 
												<td align="center"><% if rsRecSet("sta") = true then %><img src="Images/yes.gif" alt="active"><% else %><img src="Images/no.gif" alt="disabled"><% end if %></td>
                                            </tr>
                                            <tr>
                                                <td colspan="4" class=titlearealine  height=1></td> 
                                            </tr>
                                            <tr class=itemfont ID="map" height="30">
                                                <td width=2%>&nbsp;</td>
                                                <td align="left" width="17%">CAE 4000 - MAP- 01:</td> 
												<td align="center"><% if rsRecSet("map") = true then %><img src="Images/yes.gif" alt="active"><% else %><img src="Images/no.gif" alt="disabled"><% end if %></td>
                                            </tr>
                                            <tr>
                                                <td colspan="4" class=titlearealine  height=1></td> 
                                            </tr>
                                            <tr class=itemfont ID="ran" height="30">
                                                <td width=2%>&nbsp;</td>
                                                <td align="left" width="17%">Personnel by Rank:</td> 
												<td align="center"><% if rsRecSet("ran") = true then %><img src="Images/yes.gif" alt="active"><% else %><img src="Images/no.gif" alt="disabled"><% end if %></td>
                                            </tr>
                                            <tr>
                                                <td colspan="4" class=titlearealine  height=1></td> 
                                            </tr>
                                            <tr class=itemfont ID="aut" height="30">
                                                <td width=2%>&nbsp;</td>
                                                <td align="left" width="17%">Unit Q Authorisation:</td> 
												<td align="center"><% if rsRecSet("aut") = true then %><img src="Images/yes.gif" alt="active"><% else %><img src="Images/no.gif" alt="disabled"><% end if %></td>
                                            </tr>
                                            <tr>
                                                <td colspan="4" class=titlearealine  height=1></td> 
                                            </tr>
                                            <tr class=itemfont ID="ind" height="30">
                                                <td width=2%>&nbsp;</td>
                                                <td align="left" width="17%"> Individual Q Authorisation:</td> 
												<td align="center"><% if rsRecSet("ind") = true then %><img src="Images/yes.gif" alt="active"><% else %><img src="Images/no.gif" alt="disabled"><% end if %></td>
                                            </tr>
                                            <tr>
                                                <td colspan="4" class=titlearealine  height=1></td> 
                                            </tr>
                                            <tr class=itemfont ID="rod" height="30">
                                                <td width=2%>&nbsp;</td>
                                                <td align="left" width="17%">Q Expiry Date:</td> 
												<td align="center"><% if rsRecSet("rod") = true then %><img src="Images/yes.gif" alt="active"><% else %><img src="Images/no.gif" alt="disabled"><% end if %></td>
                                            </tr>
                                            <tr>
                                                <td colspan="4" class=titlearealine  height=1></td> 
                                            </tr>
                                            <tr class=itemfont ID="rod" height="30">
                                                <td width=2%>&nbsp;</td>
                                                <td align="left" width="17%">Personnel & Qs:</td> 
												<td align="center"><% if rsRecSet("paq") = true then %><img src="Images/yes.gif" alt="active"><% else %><img src="Images/no.gif" alt="disabled"><% end if %></td>
                                                <td width="74%">&nbsp;</td>
                                            </tr>
                                            <tr>
                                                <td colspan="4" class=titlearealine  height=1></td> 
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
'rsRecSet.close
'set rsRecSet=Nothing
'con.close
'set con=Nothing
%>
</body>
</html>

<SCRIPT LANGUAGE="JavaScript">
/**
function subForm(recID){
     document.forms.frmDetails.action = "AdminGroupDetail.asp";
	 document.forms.frmDetails.groupID.value = recID;
	 document.forms.frmDetails.submit(); 
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
