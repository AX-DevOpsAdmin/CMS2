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
	dim strRetSta
	dim strRetMap
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
                                                <td align="left" width="15%">Reports</td>
                                                <!--<td align="center" width="10%">&nbsp;</td> -->
                                                <td width="58%">&nbsp;</td>
                                            </tr>
											<tr>
       											<td colspan="3" class=titlearealine  height=1></td> 
     					    				</tr>
                                            <tr class=itemfont ID="man" height="22">
                                                <td width=2%>&nbsp;</td>
                                                <td align="left" width="15%">Manning:</td> 
												<td align="left"><input type="checkbox" name="radMan"  id="radMan" <% if rsRecSet("man") = true then %> checked <% end if %>></td>
                                            </tr>
                                            <tr>
                                                <td colspan="3" class=titlearealine  height=1></td> 
                                            </tr>
                                            <tr class=itemfont ID="per" height="22">
                                                <td width=2%>&nbsp;</td>
                                                <td align="left" width="15%">Personnel Harmony:</td> 
												<td align="left"><input type="checkbox" name="radPer"  id="radPer" <% if rsRecSet("per") = true then %> checked <% end if %>></td>
                                            </tr>
                                            <tr>
                                                <td colspan="3" class=titlearealine  height=1></td> 
                                            </tr>
                                            <tr class=itemfont ID="uni" height="22">
                                                <td width=2%>&nbsp;</td>
                                                <td align="left" width="15%">Unit Harmony:</td> 
												<td align="left"><input type="checkbox" name="radUni"  id="radUni" <% if rsRecSet("uni") = true then %> checked <% end if %>></td>
                                            </tr>
                                            <tr>
                                                <td colspan="3" class=titlearealine  height=1></td> 
                                            </tr>
                                            <tr class=itemfont ID="fit" height="22">
                                                <td width=2%>&nbsp;</td>
                                                <td align="left" width="15%">RAF Fitness:</td> 
												<td align="left"><input type="checkbox" name="radFit"  id="radFit" <% if rsRecSet("fit") = true then %> checked <% end if %>></td>
                                            </tr>
                                            <tr>
                                                <td colspan="3" class=titlearealine  height=1></td> 
                                            </tr>
                                           
                                            <tr class=itemfont ID="boa" height="22">
                                                <td width=2%>&nbsp;</td>
                                                <td align="left" width="15%">Management Board:</td> 
												<td align="left"><input type="checkbox" name="radBoa"  id="radBoa" <% if rsRecSet("boa") = true then %> checked <% end if %>></td>
                                            </tr>
                                            <tr>
                                                <td colspan="3" class=titlearealine  height=1></td> 
                                            </tr>
                                            <tr class=itemfont ID="sta" height="22">
                                                <td width=2%>&nbsp;</td>
                                                <td align="left" width="15%">Staff Auth Limits:</td> 
												<td align="left"><input type="checkbox" name="radSta"  id="radSta" <% if rsRecSet("sta") = true then %> checked <% end if %>></td>
                                            </tr>
                                            <tr>
                                                <td colspan="3" class=titlearealine  height=1></td> 
                                            </tr>
                                            <tr class=itemfont ID="map" height="22">
                                                <td width=2%>&nbsp;</td>
                                                <td align="left" width="15%">CAE 4000 - MAP-01:</td> 
												<td align="left"><input type="checkbox" name="radMap"  id="radMap" <% if rsRecSet("map") = true then %> checked <% end if %>></td>
                                            </tr>
                                            <tr>
                                                <td colspan="3" class=titlearealine  height=1></td> 
                                            </tr>
                                            <tr class=itemfont ID="ran" height="22">
                                                <td width=2%>&nbsp;</td>
                                                <td align="left" width="15%">Personnel by Rank:</td> 
												<td align="left"><input type="checkbox" name="radRan" id="radRan" <% if rsRecSet("ran") = true then %> checked <% end if %>></td>
                                            </tr>
                                            <tr>
                                                <td colspan="3" class=titlearealine  height=1></td> 
                                            </tr>
                                            <tr class=itemfont ID="aut" height="22">
                                                <td width=2%>&nbsp;</td>
                                                <td align="left" width="15%">Unit Q Authorisation:</td> 
												<td align="left"><input type="checkbox" name="radAut"  id="radAut" <% if rsRecSet("aut") = true then %> checked <% end if %>></td>
                                            </tr>
                                            <tr>
                                                <td colspan="3" class=titlearealine  height=1></td> 
                                            </tr>
                                            <tr class=itemfont ID="ind" height="22">
                                                <td width=2%>&nbsp;</td>
                                                <td align="left" width="15%">Individual Q Authorisation:</td> 
												<td align="left"><input type="checkbox" name="radInd" id="radInd" <% if rsRecSet("ind") = true then %> checked <% end if %>></td>
                                            </tr>
                                            <tr>
                                                <td colspan="3" class=titlearealine  height=1></td> 
                                            </tr>
                                            <tr class=itemfont ID="rod" height="22">
                                                <td width=2%>&nbsp;</td>
                                                <td align="left" width="15%">Q Expiry Date:</td> 
												<td align="left"><input type="checkbox" name="radRod"  id="radRod" <% if rsRecSet("rod") = true then %> checked <% end if %>></td>
                                            </tr>
                                            <tr>
                                                <td colspan="3" class=titlearealine  height=1></td> 
                                            </tr>
                                            <tr class=itemfont ID="rod" height="22">
                                                <td width=2%>&nbsp;</td>
                                                <td align="left" width="15%">Personnel & Qs:</td> 
												<td align="left"><input type="checkbox" name="radPaq" id="radPaq" <% if rsRecSet("paq") = true then %> checked <% end if %>></td>
                                            </tr>
                                            <tr>
                                                <td colspan="3" class=titlearealine  height=1></td> 
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
	
	//alert ( "Checked is "  + document.getElementById('radMan').checked);
	
	document.frmConfig.submit()
}

</Script>
