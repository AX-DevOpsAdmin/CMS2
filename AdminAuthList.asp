<!DOCTYPE HTML >

<!--#include file="Includes/security.inc"-->
<!--include file="Includes/checkadmin.asp"--> 
<!--#include file="Connection/Connection.inc"-->
<!--#include file="Includes/authsecurity.inc"-->

<%
'
''If user is not valid Authorisation Administrator then log them off
'If session("authadmin") <> 1 then
'	Response.redirect("noaccess.asp")
'End If

' This is the Initial Display Page of Group table data

' so the menu include - datamenu.inc knows what page we're on
	dim strPage
	strPage="AuthType"
	strTable = "tblAuthsType"
	strCommand = "spListTable"
	
	if request("atpID") <> "" then
	  strAuthType = request("atpID")
	end if
	
	set objCmd = server.CreateObject("ADODB.Command")
	set objPara = server.CreateObject("ADODB.Parameter")
	objCmd.ActiveConnection = con
	objCmd.Activeconnection.cursorlocation = 3
	
	objCmd.CommandText = strCommand
	objCmd.CommandType = 4		
    set objPara = objCmd.CreateParameter ("nodeID",3,1,0, 0)
	objCmd.Parameters.Append objPara
	set objPara = objCmd.CreateParameter ("TableName",200,1,50, strTable)
	objCmd.Parameters.Append objPara
	set rsAuthTypes = objCmd.Execute	''Execute CommandText when using "ADODB.Command" object

    ' response.Write(nodeID & " * " & strTable & " * " & rsAuthTypes.recordcount)
	'response.write(cint(strAuthType))
	
	for x = 1 to objCmd.parameters.count
		objCmd.parameters.delete(0)
	next

	strCommand = "spGetAuthList"
	
	set objCmd = server.CreateObject("ADODB.Command")
	set objPara = server.CreateObject("ADODB.Parameter")
	objCmd.ActiveConnection = con
	objCmd.CommandText = strCommand
	objCmd.CommandType = 4		
	
	set objPara = objCmd.CreateParameter ("authType",3,1,0, cint(strAuthType))
	objCmd.Parameters.Append objPara

	set objPara = objCmd.CreateParameter ("nodeID",3,1,0, 0)
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
<form  action="" method="POST" name="frmDetails">
  <Input name="authID" id="authID" type="Hidden">
  
	<table  height="100%" cellspacing=0 cellPadding=0 width=100% border=0>
      <tr>
        <td>
          <!--#include file="Includes/Header.inc"--> 
  		  
           <table cellSpacing=0 cellPadding=0 width=100% border=0 >
                    <tr style="font-size:10pt;" height=26px>
                        <td width=10><img style="margin-left:10px;" src="cms_icons/png/24x24/process.png" width="24" height="24"></td>
                        <td class="staticdatamenu"><font class="youAreHere">CMS Admin Menu / <strong>Authorisations</strong></font></td>
                    </tr>
                    <tr><td colspan=2 class=titlearealine  height=1></td></tr>
				</table>
          
           <!--<table width=100% height='<%'=session("heightIs")%>px' border=0 cellpadding=0 cellspacing=0> -->
           <table style="height:900px;" width=100% height="328" border=0 cellpadding=0 cellspacing=0>       		   		
      		<tr valign=Top>
        	  <td class="sidemenuwidth" background="Images/tableback.png"><!--#include file="Includes/authmenu.inc"--></td> 
				  <td width=16></td>
				  <td align=left>
				    <table border=0 cellpadding=0 cellspacing=0 width=100%>
					  <tr height=16 class=SectionHeader>
					    <td>
						  <table border=0 cellpadding=0 cellspacing=0 >
						    <tr>
							  <td class=toolbar width=8>&nbsp;</td>
							  <td width=20><a class=itemfontlink href="AdminAuthListAdd.asp"><img class="imagelink" src="images/newitem.gif"></a></td>
							  <td class=toolbar valign="middle">Add Authorisation</td>
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
                                    <td width="13%" align="left" height="22px">Authorisation Type:</td>
                                    <td width="85%" align="left" height="22px">
                                        <select class="itemfont" name="atpID" id="atpID" onchange="frmDetails.submit();" style="width:140px;">
                                        <option value=0>Select...</option>
                                        <% do while not rsAuthTypes.eof %>
                                            <option value="<%= rsAuthTypes("atpID") %>" <% if strAuthType = cint(rsAuthTypes("atpID")) then %> selected <% end if %>><%=rsAuthTypes("authType") %></option>                                                     
                                            <% rsAuthTypes.movenext %>
                                        <% loop %>
                                        </select>
                                     </td>
                                </tr>
                            </table>

						  <table width=100% border=0 cellpadding=0 cellspacing=0>
						    <tr class=columnheading>
							  <td valign="middle" width=0% height=30></td>
							  <td valign="middle" width=9% height=30></td>
							</tr>
						  	<tr>
       						  <td colspan=5 class=titlearealine  height=1></td> 
     					    </tr>
                            <tr class=itemfont  height=30>
								<td valign="middle" width=0%>&nbsp;</td>
				                <td valign="middle" width="9%">Name</A></td> 
                                <td valign="middle" width="7%">Auth Class</A></td> 
                                <td valign="middle" width="8%">Auth Level</A></td>
                                <td valign="middle" width="76%">Parent</A></td> 
						      </tr>
                            <% if not rsRecSet.eof then %>
								<%do while not rsRecSet.eof%>
                                  <tr class=itemfont ID="TableRow<%=rsRecSet ("authID")%>" height=30>
                                    <td valign="middle" width=0%>&nbsp;</td>
                                    <td valign="middle" width="9%"><A class=itemfontlink href="javascript: subForm(<%=rsRecSet("authID")%>)"><%=rsRecSet("authcode")%></A></td> 
                                    <td valign="middle" width="7%"><%=rsRecSet("authclass")%></A></td>
                                    <td valign="middle" width="8%"><%=rsRecSet("authlevel")%></A></td>
                                    <td valign="middle" width="76%"><%=rsRecSet("parent")%></A></td> 
                                  </tr>
                                  <tr>
                                    <td colspan=5 class=titlearealine  height=1></td> 
                                  </tr>
                                <%rsRecSet.MoveNext
                                Loop%>
                            <% else %>
                                <tr>
                                    <td width="0%">&nbsp;</td>
                                    <td colspan="6" class="columnheading">No Records Found</td>
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
<%
rsRecSet.close
set rsRecSet=Nothing
con.close
set con=Nothing
%>
</body>
</html>

<SCRIPT LANGUAGE="JavaScript">
function subForm(recID){
	
	 
     document.forms.frmDetails.action = "AdminAuthListDetail.asp";
	 document.forms.frmDetails.authID.value = recID;
	 
	// alert ("rec id is " + recID + " * " + document.forms.frmDetails.authID.value);
	 
	 document.forms.frmDetails.submit(); 
}

</Script>
