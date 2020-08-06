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

dim strPage
dim strTable
dim strCommand

strTable = "tblAuths"
strTabID = "authID"              ' key field name for table        
strGoTo = "AdminAuthList.asp"   ' asp page to return to once record is deleted

'strRecID = "aptID"
strCommand = "spGetAuthDetail"

set objCmd = server.CreateObject("ADODB.Command")
set objPara = server.CreateObject("ADODB.Parameter")
objCmd.ActiveConnection = con
objCmd.CommandType = 4		

objCmd.CommandText = strCommand

set objPara = objCmd.CreateParameter ("RecID",3,1,0, cint(request("authID")))
objCmd.Parameters.Append objPara
set rsRecSet = objCmd.execute	'Execute CommandText when using "ADODB.Command" object

'response.write ("Here we are " & rsRecSet("authCode") &  " * " &  request("authID") )

' now see if we can delete it - if it has no children then we can return parameter for Delete check
objCmd.CommandText = "spAuthDel"
set objPara = objCmd.CreateParameter("@DelOK",3,2)
objCmd.Parameters.Append objPara
objCmd.Execute	

strDelOK = objCmd.Parameters("@DelOK")

'response.write ("Level is " & rsRecset("thisLevel") &  " * " &  request("authID") & " ** " & strDelOK)

%>

<html>
<head>
<title><%= PageTitle %></title>
<link rel="stylesheet" type="text/css" href="Includes/AMDB.css" media="Screen"/>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">

</head>
<body>
<form  action="" method="POST" name="frmDetails">
    <table  height="100%" cellspacing=0 cellPadding=0 width=100% border=0>
	    <tr>
    		<td>
    			<!--#include file="Includes/Header.inc"-->
    				<table cellSpacing=0 cellPadding=0 width=100% border=0 >
                    <tr style="font-size:10pt;" height=26px>
                        <td width=10><img style="margin-left:10px;" src="cms_icons/png/24x24/process.png" width="24" height="24"></td>
                        <td class="staticdatamenu"><font class="youAreHere">CMS Admin Menu / <strong>Authorisation Details</strong></font></td>
                    </tr>
                    <tr><td colspan=2 class=titlearealine  height=1></td></tr>
				</table>
          
            <!--<table width=100% height='<%'=session("heightIs")%>px' border=0 cellpadding=0 cellspacing=0> -->
            <table style="height:900px;" width=100% height="328" border=0 cellpadding=0 cellspacing=0> 
      		<tr valign=Top>
        	  <td class="sidemenuwidth" background="Images/tableback.png"><!--#include file="Includes/authmenu.inc"--></td>
    					<td width=16></td>
    					<td align=left >
    						<table border=0 cellpadding=0 cellspacing=0 width=100%>
    							<tr height=16 class=SectionHeader>
    								<td>
    									<table border=0 cellpadding=0 cellspacing=0>
                                        	<tr>
                                                <td class=toolbar width=8></td>
                                                <!--
                                                <td width=20><a class=itemfontlink href="AdminQListAdd.asp"><img class="imagelink" src="images/newitem.gif"></a></td>
                                                <td class=toolbar valign="middle">New Q</td>
                                                <td class=titleseparator valign="middle" width=14 align="center">|</td>
                                                -->
                                                <td width=20><a class=itemfontlink href="AdminAuthListEdit.asp?authID=<%=request("authID")%>&atpID=<%=rsRecSet("atpID")%>"><img class="imagelink" src="images/editgrid.gif"></A></td>
                                                <td class=toolbar valign="middle">Edit Authorisation</td>
												<% if strDelOK = "0" then %>
                                                	<td class=titleseparator valign="middle" width=14 align="center">|</td>
                                                	<td width=20><a class=itemfontlink href="DeleteRec.asp?RecID=<%=request("authID")%>&TableName=<%=strTable%>&TabId=<%=strTabID%>&GoTo=<%=strGoTo%>" onClick="javascript:return(checkDelete());"><img class="imagelink" src="images/delitem.gif"></A></td>
                                                	<td class=toolbar valign="middle">Delete Authorisation</td>
                                                <% end if %>    
                                                <td class=titleseparator valign="middle" width=14 align="center">|</td>
                                                <td class=toolbar valign="middle"><a class=itemfontlink href="AdminAuthList.asp">Back To List</A></td>											
                                            </tr>
    									</table>
    								</td>
    							</tr>
							    <tr>
    								<td>
    									<table width=100% border=0 cellpadding=0 cellspacing=0>
                                            <tr height=16>
    											<td colspan="3" height=22>&nbsp;</td>
    										</tr>

                                            <tr class=columnheading>
                                                <td height=22 valign="middle" width=2%>&nbsp;</td>
                                                <td height=22 valign="middle" width=13%>Authorisation Type:</td>
                                                <td height=22 valign="middle" width=85% class=itemfont><%=rsRecSet("authType")%></td>
                                            </tr>
    										<tr height=16>
    											<td colspan="3" height=22>&nbsp;</td>
    										</tr>
                                            <tr class=columnheading>
                                                <td height=22 valign="middle" width=2%>&nbsp;</td>
                                                <td height=22 valign="middle" width=13%>Authorisation:</td>
                                                <td height=22 valign="middle" width=85% class=itemfont><%=rsRecSet("authCode")%></td>
                                            </tr>
                                            <tr height=16>
    											<td colspan="3" height=22>&nbsp;</td>
    										</tr>
                                            
                                            <tr class=columnheading>
                                                <td height=22 valign="middle" width=2%>&nbsp;</td>
                                                <td height=22 valign="middle" width=13%>Authorisation Class:</td>
                                                <td height=22 valign="middle" width=85% class=itemfont><%=rsRecSet("authclass")%></td>
                                            </tr>
                                            <tr height=16>
    											<td colspan="3" height=22>&nbsp;</td>
    										</tr>
                                            <tr class=columnheading>
                                                <td height=22 valign="middle" width=2%>&nbsp;</td>
                                                <td height=22 valign="middle" width=13%>Authorisation Level:</td>
                                                <td height=22 valign="middle" width=85% class=itemfont><%=rsRecSet("authlevel")%></td>
                                            </tr>
                                            <tr height=16>
    											<td colspan="3" height=22>&nbsp;</td>
    										</tr>
                                            <tr class=columnheading>
                                                <td height=22 valign="middle" width=2%>&nbsp;</td>
                                                <td height=22 valign="middle" width=13%>Authorisation Approver:</td>
                                                <td height=22 valign="middle" width=85% class=itemfont><%=rsRecSet("apprvCode")%></td>
                                            </tr>
											<tr>
                                            	<td colspan="3" height=22>&nbsp;</td>
                                            </tr>

                                            <tr class=columnheading>
                                                <td height=22 valign="middle" width=2%>&nbsp;</td>
                                                <td width=13% valign="top">Authorisation Task:</td>
                                                <td width=85% valign="middle" class=itemfont><div style=" width:360px; height: 60px; overflow:auto;"><%=rsRecSet("authTask")%></div></td>
                                            </tr>
                                            
                                            <tr class=columnheading>
                                                <td height=22 valign="middle" width=2%>&nbsp;</td>
                                                <td width=13% valign="top">Authorisation Requirement:</td>
                                                <td width=85% valign="middle" class=itemfont><div style=" width:360px; height: 60px; overflow:auto;"><%=rsRecSet("authReqs")%></div></td>
                                            </tr>

                                            <tr class=columnheading>
                                                <td height=22 valign="middle" width=2%>&nbsp;</td>
                                                <td width=13% valign="top">Authorisation Reference:</td>
                                                <td width=85% valign="middle" class=itemfont><div style=" width:360px; height: 60px; overflow:auto;"><%=rsRecSet("authRef")%></div></td>
                                            </tr>

                                            <% if rsRecSet("thisLevel") < 3 and rsRecSet("topAuth") = 0 then %>
                                            <tr class="columnheading" height="22px">
												<td align="left" width="2%">&nbsp;</td>
                                                <td align="left" width="13%">Class Authorisor:</td>
												<td align="left"><input type="checkbox" <% if rsRecSet("classauth") = true then %> checked <% end if %> disabled="true"> 
												&nbsp; When ticked this is a top level Authorisor ie: Level J or K</td>
                                            </tr>
                                            <% end if %>
                                            
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

<%
	rsRecSet.close
	set rsRecSet = Nothing
	con.close
	set con = nothing
%>

</body>
</html>

<script language="JavaScript">

function checkDelete()
{
	var delOK = false
	
	var input_box = confirm("Are you sure you want to delete this Record ?")
	if(input_box==true)
	{
		delOK = true;
	}
    return delOK;
}

</Script>
