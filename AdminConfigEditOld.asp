<!DOCTYPE HTML >

<!--#include file="Includes/security.inc"--> 
<!--#include file="Includes/checkadmin.asp"-->
<!--#include file="Connection/Connection.inc"-->
<!--#include file="Includes/adovbs.inc"-->

<%
  	dim cmdEditConfig
	dim strRetPla
	dim strRetMan
	dim strRetPer
	dim strRetUni
	dim strRetCap
	dim strRetPre
	dim strRetFit
	dim strRetBoa
	dim strRetSch
	dim strRetNom
	dim strRetRan
	dim strRetAut
	dim strRetInd
	dim strRetPos
	dim strRetRod
	
	'response.write ("Config ID is " & request("configID"))
	
	set objCmd = server.CreateObject("ADODB.Command")
	set objPara = server.CreateObject("ADODB.Parameter")
	objCmd.ActiveConnection = con
	objCmd.commandtext = "spConfigSelect"
	objCmd.commandtype = adCmdStoredProc
	
	'Input Parameters
	set objPara = objCmd.CreateParameter ("@configID", 3, 1, 0, request("configID"))
	objCmd.Parameters.Append objPara
	
	set rsRecSet = objCmd.Execute	'Execute CommandText when using "ADODB.Command" object
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
<form action="UpdateConfig.asp" method="POST" name="frmConfig">
    <Input name="configID" id="configID" value="<%=rsRecSet("configID")%>" type="Hidden">
    
	<table width="100%" cellspacing=0 cellPadding=0 border=0>
		<tr>
			<td>
				<!--#include file="Includes/Header.inc"--> 
				<table cellSpacing=0 cellPadding=0 width=100% border=0 >
					<tr>
                    <tr style="font-size:10pt;" height=26px>
                        <td width=10><img style="margin-left:10px;" src="cms_icons/png/24x24/process.png" width="24" height="24"></td>
                        <td class="staticdatamenu"><font class="youAreHere">CMS Admin Menu / <strong>Edit Configuration</strong></font></td>
                    </tr>
					</tr>
					<tr>
						<td colspan=2 class=titlearealine  height=1></td> 
					</tr>
				</table>
				<table width=100% height='<%=session("heightIs")%>px' border=0 cellpadding=0 cellspacing=0 > 
					<tr valign=Top>
        	            <td class="sidemenuwidth" background="Images/tableback.png"><!--#include file="Includes/datamenu.inc"--></td>
						<td width=16></td>
						<td align=left>
							<table border=0 cellpadding=0 cellspacing=0 width=100%>
								<tr height=16 class=SectionHeader>
									<td>
										<table border=0 cellpadding=0 cellspacing=0>
                                        	<tr>
                                                <td class=toolbar width=8></td>
                                                <td width=20><a href="javascript:btnSave_onClick();"><img class="imagelink" src="images/saveitem.gif"></A></td>
                                                <td class=toolbar valign="middle">Save and Close</td>
                                                <td class=titleseparator valign="middle" width=14 align="center">|</td>
                                                <td class=toolbar valign="middle"><A class= itemfontlink href="AdminConfigList.asp">Back</A></td>											
											</tr>
										</table>
									</td>
								</tr>
								<tr>
									<td>
										<table width=100% border=0 cellpadding=0 cellspacing=0>
                                            <!--
											<tr class=columnheading height="22">
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
                                            <tr class=itemfont ID="pla" height="22">
                                                <td width=2%>&nbsp;</td>
                                                <td align="left" width="30%">Unit Planner:</td>
                                                <td align="center" width="10%">
													<table width="100px" border="0" cellpadding="0" cellspacing="0">
														<tr>
															<td align="center"><input type="radio" name="radPla" value="1" id="radPla_1" <%' if rsRecSet("pla") = true then %> checked <%' end if %>></td>
                                                            <td width="30">&nbsp;</td>
															<td align="center"><input type="radio" name="radPla" value="0" id="radPla_0" <% 'if rsRecSet("pla") = false then %> checked <%' end if %>></td>
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
                                            <tr class=columnheading height="22px">
                                            	<td width="2%">&nbsp;</td>
                                                <td align="left" width="30%">Tasking</td>
                                                <td align="center" width="10%">&nbsp;</td> 
                                                <td width="58%">&nbsp;</td>
                                            </tr>
											<tr>
       											<td colspan="4" class=titlearealine  height=1></td> 
     					    				</tr>
                                            <tr class=itemfont ID="man" height="22">
                                                <td width=2%>&nbsp;</td>
                                                <td align="left" width="30%">Units:</td> 
                                                <td align="center" width="10%">
													<table width="100px" border="0" cellpadding="0" cellspacing="0">
														<tr>
															<td align="center"><input type="radio" name="radTas" value="1" id="radTas_1" <%' if rsRecSet("tas") = true then %> checked <%' end if %>></td>
                                                            <td width="30">&nbsp;</td>
															<td align="center"><input type="radio" name="radTas" value="0" id="radTas_0" <% 'if rsRecSet("tas") = false then %> checked <%' end if %>></td>
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
                                            <tr class=columnheading height="22">
                                            	<td width="2%">&nbsp;</td>
                                                <td align="left" width="30%">Reports</td>
                                                <td align="center" width="10%">&nbsp;</td> 
                                                <td width="58%">&nbsp;</td>
                                            </tr>
											<tr>
       											<td colspan="4" class=titlearealine  height=1></td> 
     					    				</tr>
                                            <tr class=itemfont ID="man" height="22">
                                                <td width=2%>&nbsp;</td>
                                                <td align="left" width="30%">Manning:</td> 
                                                <td align="center" width="10%">
													<table width="100px" border="0" cellpadding="0" cellspacing="0">
														<tr>
															<td align="center"><input type="radio" name="radMan" value="1" id="radMan_1" <% if rsRecSet("man") = true then %> checked <% end if %>></td>
                                                            <td width="30">&nbsp;</td>
															<td align="center"><input type="radio" name="radMan" value="0" id="radMan_0" <% if rsRecSet("man") = false then %> checked <% end if %>></td>
														</tr>
													</table>
                                                </td> 
                                                <td width="58%">&nbsp;</td>
                                            </tr>
                                            <tr>
                                                <td colspan="4" class=titlearealine  height=1></td> 
                                            </tr>
                                            <tr class=itemfont ID="per" height="22">
                                                <td width=2%>&nbsp;</td>
                                                <td align="left" width="30%">Personnel Harmony:</td> 
                                                <td align="center" width="10%">
													<table width="100px" border="0" cellpadding="0" cellspacing="0">
														<tr>
															<td align="center"><input type="radio" name="radPer" value="1" id="radPer_1" <% if rsRecSet("per") = true then %> checked <% end if %>></td>
                                                            <td width="30">&nbsp;</td>
															<td align="center"><input type="radio" name="radPer" value="0" id="radPer_0" <% if rsRecSet("per") = false then %> checked <% end if %>></td>
														</tr>
													</table>
                                                </td> 
                                                <td width="58%">&nbsp;</td>
                                            </tr>
                                            <tr>
                                                <td colspan="4" class=titlearealine  height=1></td> 
                                            </tr>
                                            <tr class=itemfont ID="uni" height="22">
                                                <td width=2%>&nbsp;</td>
                                                <td align="left" width="30%">Unit Harmony:</td> 
                                                <td align="center" width="10%">
													<table width="100px" border="0" cellpadding="0" cellspacing="0">
														<tr>
															<td align="center"><input type="radio" name="radUni" value="1" id="radUni_1" <% if rsRecSet("uni") = true then %> checked <% end if %>></td>
                                                            <td width="30">&nbsp;</td>
															<td align="center"><input type="radio" name="radUni" value="0" id="radUni_0" <% if rsRecSet("uni") = false then %> checked <% end if %>></td>
														</tr>
													</table>
                                                </td> 
                                                <td width="58%">&nbsp;</td>
                                            </tr>
                                            <tr>
                                                <td colspan="4" class=titlearealine  height=1></td> 
                                            </tr>
                                            <!--
                                            <tr class=itemfont ID="cap" height="22">
                                                <td width=2%>&nbsp;</td>
                                                <td align="left" width="30%">Capability:</td> 
                                                <td align="center" width="10%">
													<table width="100px" border="0" cellpadding="0" cellspacing="0">
														<tr>
															<td align="center"><input type="radio" name="radCap" value="1" id="radCap_1" <%' if rsRecSet("cap") = true then %> checked <%' end if %>></td>
                                                            <td width="30">&nbsp;</td>
															<td align="center"><input type="radio" name="radCap" value="0" id="radCap_0" <%' if rsRecSet("cap") = false then %> checked <%' end if %>></td>
														</tr>
													</table>
                                                </td> 
                                                <td width="58%">&nbsp;</td>
                                            </tr>
                                            <tr>
                                                <td colspan="4" class=titlearealine  height=1></td> 
                                            </tr>
                                           
                                            <tr class=itemfont ID="pre" height="22">
                                                <td width=2%>&nbsp;</td>
                                                <td align="left" width="30%">Present/Absent:</td> 
                                                <td align="center" width="10%">
													<table width="100px" border="0" cellpadding="0" cellspacing="0">
														<tr>
															<td align="center"><input type="radio" name="radPre" value="1" id="radPre_1" <%' if rsRecSet("pre") = true then %> checked <%' end if %>></td>
                                                            <td width="30">&nbsp;</td>
															<td align="center"><input type="radio" name="radPre" value="0" id="radPre_0" <%' if rsRecSet("pre") = false then %> checked <%' end if %>></td>
														</tr>
													</table>
                                                </td> 
                                                <td width="58%">&nbsp;</td>
                                            </tr>
                                            <tr>
                                                <td colspan="4" class=titlearealine  height=1></td> 
                                            </tr>
                                             -->
                                            <tr class=itemfont ID="fit" height="22">
                                                <td width=2%>&nbsp;</td>
                                                <td align="left" width="30%">RAF Fitness:</td> 
                                                <td align="center" width="10%">
													<table width="100px" border="0" cellpadding="0" cellspacing="0">
														<tr>
															<td align="center"><input type="radio" name="radFit" value="1" id="radFit_1" <% if rsRecSet("fit") = true then %> checked <% end if %>></td>
                                                            <td width="30">&nbsp;</td>
															<td align="center"><input type="radio" name="radFit" value="0" id="radFit_0" <% if rsRecSet("fit") = false then %> checked <% end if %>></td>
														</tr>
													</table>
                                                </td> 
                                                <td width="58%">&nbsp;</td>
                                            </tr>
                                            <tr>
                                                <td colspan="4" class=titlearealine  height=1></td> 
                                            </tr>
                                           
                                            <tr class=itemfont ID="boa" height="22">
                                                <td width=2%>&nbsp;</td>
                                                <td align="left" width="30%">Management Board:</td> 
                                                <td align="center" width="10%">
													<table width="100px" border="0" cellpadding="0" cellspacing="0">
														<tr>
															<td align="center"><input type="radio" name="radBoa" value="1" id="radBoa_1" <% 'if rsRecSet("boa") = true then %> checked <%' end if %>></td>
                                                            <td width="30">&nbsp;</td>
															<td align="center"><input type="radio" name="radBoa" value="0" id="radBoa_0" <%' if rsRecSet("boa") = false then %> checked <%' end if %>></td>
														</tr>
													</table>
                                                </td> 
                                                <td width="58%">&nbsp;</td>
                                            </tr>
                                            <tr>
                                                <td colspan="4" class=titlearealine  height=1></td> 
                                            </tr>
                                             <!--
                                            <tr class=itemfont ID="sch" height="22">
                                                <td width=2%>&nbsp;</td>
                                                <td align="left" width="30%">Tasking Schedule:</td> 
                                                <td align="center" width="10%">
													<table width="100px" border="0" cellpadding="0" cellspacing="0">
														<tr>
															<td align="center"><input type="radio" name="radSch" value="1" id="radSch_1" <%' if rsRecSet("sch") = true then %> checked <%' end if %>></td>
                                                            <td width="30">&nbsp;</td>
															<td align="center"><input type="radio" name="radSch" value="0" id="radSch_0" <%' if rsRecSet("sch") = false then %> checked <%' end if %>></td>
														</tr>
													</table>
                                                </td> 
                                                <td width="58%">&nbsp;</td>
                                            </tr>
                                            <tr>
                                                <td colspan="4" class=titlearealine  height=1></td> 
                                            </tr>
                                        
                                            <tr class=itemfont ID="nom" height="22">
                                                <td width=2%>&nbsp;</td>
                                                <td align="left" width="30%">Nominal Role:</td> 
                                                <td align="center" width="10%">
													<table width="100px" border="0" cellpadding="0" cellspacing="0">
														<tr>
															<td align="center"><input type="radio" name="radNom" value="1" id="radNom_1" <%' if rsRecSet("nom") = true then %> checked <%' end if %>></td>
                                                            <td width="30">&nbsp;</td>
															<td align="center"><input type="radio" name="radNom" value="0" id="radNom_0" <%' if rsRecSet("nom") = false then %> checked <%' end if %>></td>
														</tr>
													</table>
                                                </td> 
                                                <td width="58%">&nbsp;</td>
                                            </tr>
                                            <tr>
                                                <td colspan="4" class=titlearealine  height=1></td> 
                                            </tr>
                                                -->
                                            <tr class=itemfont ID="ran" height="22">
                                                <td width=2%>&nbsp;</td>
                                                <td align="left" width="30%">Personnel by Rank:</td> 
                                                <td align="center" width="10%">
													<table width="100px" border="0" cellpadding="0" cellspacing="0">
														<tr>
															<td align="center"><input type="radio" name="radRan" value="1" id="radRan_1" <% if rsRecSet("ran") = true then %> checked <% end if %>></td>
                                                            <td width="30">&nbsp;</td>
															<td align="center"><input type="radio" name="radRan" value="0" id="radRan_0" <% if rsRecSet("ran") = false then %> checked <% end if %>></td>
														</tr>
													</table>
                                                </td> 
                                                <td width="58%">&nbsp;</td>
                                            </tr>
                                            <tr>
                                                <td colspan="4" class=titlearealine  height=1></td> 
                                            </tr>
                                            <!--
                                            <tr class=itemfont ID="pos" height="22">
                                                <td width=2%>&nbsp;</td>
                                                <td align="left" width="30%">Personnel by Post:</td> 
                                                <td align="center" width="10%">
													<table width="100px" border="0" cellpadding="0" cellspacing="0">
														<tr>
															<td align="center"><input type="radio" name="radPos" value="1" id="radPos_1" <%' if rsRecSet("pos") = true then %> checked <%' end if %>></td>
                                                            <td width="30">&nbsp;</td>
															<td align="center"><input type="radio" name="radPos" value="0" id="radPos_0" <%' if rsRecSet("pos") = false then %> checked <% 'end if %>></td>
														</tr>
													</table>
                                                </td> 
                                                <td width="58%">&nbsp;</td>
                                            </tr>
                                            <tr>
                                                <td colspan="4" class=titlearealine  height=1></td> 
                                            </tr>
                                            -->
                                            <tr class=itemfont ID="aut" height="22">
                                                <td width=2%>&nbsp;</td>
                                                <td align="left" width="30%">Unit Q Authorisation:</td> 
                                                <td align="center" width="10%">
													<table width="100px" border="0" cellpadding="0" cellspacing="0">
														<tr>
															<td align="center"><input type="radio" name="radAut" value="1" id="radAut_1" <% if rsRecSet("aut") = true then %> checked <% end if %>></td>
                                                            <td width="30">&nbsp;</td>
															<td align="center"><input type="radio" name="radAut" value="0" id="radAut_0" <% if rsRecSet("aut") = false then %> checked <% end if %>></td>
														</tr>
													</table>
                                                </td> 
                                                <td width="58%">&nbsp;</td>
                                            </tr>
                                            <tr>
                                                <td colspan="4" class=titlearealine  height=1></td> 
                                            </tr>
                                            <tr class=itemfont ID="ind" height="22">
                                                <td width=2%>&nbsp;</td>
                                                <td align="left" width="30%">Individual Q Authorisation:</td> 
                                                <td align="center" width="10%">
													<table width="100px" border="0" cellpadding="0" cellspacing="0">
														<tr>
															<td align="center"><input type="radio" name="radInd" value="1" id="radInd_1" <% if rsRecSet("ind") = true then %> checked <% end if %>></td>
                                                            <td width="30">&nbsp;</td>
															<td align="center"><input type="radio" name="radInd" value="0" id="radInd_0" <% if rsRecSet("ind") = false then %> checked <% end if %>></td>
														</tr>
													</table>
                                                </td> 
                                                <td width="58%">&nbsp;</td>
                                            </tr>
                                            <tr>
                                                <td colspan="4" class=titlearealine  height=1></td> 
                                            </tr>
                                            <tr class=itemfont ID="rod" height="22">
                                                <td width=2%>&nbsp;</td>
                                                <td align="left" width="30%">Q Expiry Date:</td> 
                                                <td align="center" width="10%">
													<table width="100px" border="0" cellpadding="0" cellspacing="0">
														<tr>
															<td align="center"><input type="radio" name="radRod" value="1" id="radRod_1" <% if rsRecSet("rod") = true then %> checked <% end if %>></td>
                                                            <td width="30">&nbsp;</td>
															<td align="center"><input type="radio" name="radRod" value="0" id="radRod_0" <% if rsRecSet("rod") = false then %> checked <% end if %>></td>
														</tr>
													</table>
                                                </td> 
                                                <td width="58%">&nbsp;</td>
                                            </tr>
                                            <tr>
                                                <td colspan="4" class=titlearealine  height=1></td> 
                                            </tr>
                                            <tr class=itemfont ID="rod" height="22">
                                                <td width=2%>&nbsp;</td>
                                                <td align="left" width="30%">Personnel & Qs:</td> 
                                                <td align="center" width="10%">
													<table width="100px" border="0" cellpadding="0" cellspacing="0">
														<tr>
															<td align="center"><input type="radio" name="radPaq" value="1" id="radPaq_1" <% if rsRecSet("paq") = true then %> checked <% end if %>></td>
                                                            <td width="30">&nbsp;</td>
															<td align="center"><input type="radio" name="radPaq" value="0" id="radPaq_0" <% if rsRecSet("paq") = false then %> checked <% end if %>></td>
														</tr>
													</table>
                                                </td> 
                                                <td width="58%">&nbsp;</td>
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
con.close
set con=Nothing
%>
</body>
</html>

<SCRIPT LANGUAGE="JavaScript">

function btnSave_onClick()
{
	document.frmConfig.submit()
}

</Script>
