<!DOCTYPE HTML >

<!--#include file="Includes/security.inc"--> 
<!--#include file="Includes/checkadmin.asp"-->
<!--#include file="Connection/Connection.inc"-->

<%
	dim strPage
	dim typeID
	strPage="QList"
	
	if request("QTypeID") <> "" then
		session("QType") = request("QTypeID")
	end if
	
	set objCmd = server.createobject("ADODB.Command")
	set objPara = server.createobject("ADODB.Parameter")
	objCmd.activeconnection = con
	objCmd.activeconnection.cursorlocation = 3
	
	objCmd.commandtext = "spListQTypes"
	objCmd.commandtype = 4		
	
	set objPara = objCmd.createparameter("nodeID",3,1,0, nodeID)
	objCmd.parameters.append objPara

	set rsQTypeList = objCmd.execute	''Execute CommandText when using "ADODB.Command" object
	
	for x = 1 to objCmd.parameters.count
		objCmd.parameters.delete(0)
	next
	
	objCmd.commandtext = "spQs"
	objCmd.commandtype = 4
	set objPara = objCmd.createparameter("QTypeID",3,1,4, cint(session("QType")))
	objCmd.parameters.append objPara
	set rsQs = objCmd.execute
                                                                        
	for x = 1 to objCmd.parameters.count
		objCmd.parameters.delete(0)
	next
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
	<input name="QID" id="QID" type="hidden">
	
	<table  height="100%" cellspacing=0 cellPadding=0 width=100% border=0>
		<tr>
			<td>
				<!--#include file="Includes/Header.inc"--> 
  					<table cellSpacing=0 cellPadding=0 width=100% border=0 >
                    <tr style="font-size:10pt;" height=26px>
                        <td width=10><img style="margin-left:10px;" src="cms_icons/png/24x24/process.png" width="24" height="24"></td>
                        <td class="staticdatamenu"><font class="youAreHere">CMS Admin Menu / <strong>Qualifications</strong></font></td>
                    </tr>
                    <tr><td colspan=2 class=titlearealine  height=1></td></tr>
				</table>
          
  		  <table width=100% height='<%=session("heightIs")%>px' border=0 cellpadding=0 cellspacing=0> 
      		<tr valign=Top>
        	  <td class="sidemenuwidth" background="Images/tableback.png"><!--#include file="Includes/datamenu.inc"--></td>
						<td width=16></td>
						<td align=left>
							<table border=0 cellpadding=0 cellspacing=0 width=100%>
								<tr class=SectionHeader>
									<td>
										<table border=0 cellpadding=0 cellspacing=0>
											<tr>
												<td class=toolbar width=8></td>
												<td width=20><a class=itemfontlink href="AdminQListAdd.asp"><img class="imagelink" src="images/newitem.gif"></a></td>
												<td class=toolbar valign="middle">New Qualification</td>
											</tr>  
										</table>
									</td>
								</tr>
                                <tr>
                                	<td colspan="3" height="22px">&nbsp;</td>
                                </tr>
                                <tr>
                                	<td>
                                    	<table width="100%" border="0" cellpadding="0" cellspacing="0">
                                        	<tr class="columnheading">
                                            	<td width="2%" align="left" height="22px">&nbsp;</td>
                                                <td width="13%" align="left" height="22px">Qualification Type:</td>
                                                <td width="85%" align="left" height="22px">
                                                    <select class="itemfont" name="QTypeID" id="QTypeID" onchange="frmDetails.submit();" style="width:140px;">
                                                    <option value=0>Select...</option>
                                                    <% do while not rsQTypeList.eof %>
                                                        <option value="<%= rsQTypeList("QTypeID") %>" <% if cint(session("QType")) = cint(rsQTypeList("QTypeID")) then %> selected <% end if %>><%=rsQTypeList("Type") %></option>                                                     
                                                        <% rsQTypeList.movenext %>
                                                    <% loop %>
                                                    </select>
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                                <tr>
                                	<td colspan="3" height="30px">&nbsp;</td>
                                </tr>
								<tr>
									<td>
                                        <table width=100% border=0 cellpadding=0 cellspacing=0>
                                            <tr class=columnheading>
                                                <td width="2%" align="left" height=22>&nbsp;</td>
                                                <td width="30%" align="left" height=22>Qualification</td>
                                                <td width="10%" align="left" height=22>Validity Period</td>
                                                <td width="15%" align="center" height=22>Amber Period (Days)</td>
                                                <td width="12%" align="center" height=22><% if session("boa") <> 0 then %>Enduring Q<% end if %></td>
                                                <td width="12%" align="center" height=22><% if session("boa") <> 0 then %>Contingent Q<% end if %></td>
                                                <td width="19%" align="center" height=30>&nbsp;</td>
                                            </tr>
                                            <tr>
                                                <td colspan=7 class=titlearealine  height=1></td> 
                                            </tr>
                                            
                                            <% if not rsQs.eof then %>
                                                <% do while not rsQs.eof %>
                                                    <tr class=itemfont>
                                                        <td width="2%" align="left">&nbsp;</td>
                                                        <td width="30%" align="left" height="30px"><a class=itemfontlink href="javascript: subForm(<%= rsQs("QID") %>)"><%= rsQs("Description") %></a></td>
                                                        <td width="10%" align="left" height="30px"><%= rsQs("ValidityPeriod") %></td>
                                                        <td width="15%" align="center" height="30px"><%= rsQs("Amber") %></td>
                                                        <td width="12%" align="center" height="30px"><% if session("boa") <> 0 then %><% if rsQs("enduring") = true then %><img src="Images/yes.gif"><% else %><img src="Images/no.gif"><% end if %><% end if %></td>
                                                        <td width="12%" align="center" height="30px"><% if session("boa") <> 0 then %><% if rsQs("contingent") = true then %><img src="Images/yes.gif"><% else %><img src="Images/no.gif"><% end if %><% end if %></td>
                                                        <td width="19%" align="center" height="30px">&nbsp;</td>
                                                    </tr>
                                                    <tr>
                                                        <td colspan=7 class=titlearealine height=1></td> 
                                                    </tr>
                                                    <% rsQs.movenext %>
                                                <% loop %>
                                            <% else %>
                                                <tr>
                                                    <td width="2%">&nbsp;</td>
                                                    <td width="98%" colspan="6" class="columnheading">No Records Found</td>
                                                </tr>
                                                <tr>
                                                    <td colspan=7 class=titlearealine height=1></td> 
                                                </tr>                                                    
                                                <tr>
                                                    <td colspan="7">&nbsp;</td>
                                                </tr>
                                            <% end if %>
                                            <tr>
                                                <td colspan="7">&nbsp;</td>
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

<script language="javascript">

function subForm(recID)
{
     document.forms.frmDetails.action = "AdminQListDetail.asp";
	 document.forms.frmDetails.QID.value = recID;
	 document.forms.frmDetails.submit(); 
}

</Script>
