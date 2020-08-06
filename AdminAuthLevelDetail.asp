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

strTable = "tblAuthsLevel"
strGoTo = "AdminAuthLevelList.asp"   ' asp page to return to once record is deleted
strTabID = "lvlID"              ' key field name for table        

strRecID = "lvlID"
strCommand = "spGetAuthLevel"

set objCmd = server.CreateObject("ADODB.Command")
set objPara = server.CreateObject("ADODB.Parameter")
objCmd.ActiveConnection = con
objCmd.CommandText = strCommand
objCmd.CommandType = 4		

set objPara = objCmd.CreateParameter ("RecID",3,1,1, request("lvlID"))
objCmd.Parameters.Append objPara

set rsRecSet = objCmd.execute	'Execute CommandText when using "ADODB.Command" object

'response.write ("here we are " & request("lvlID"))
'response.End()


' now see if we can delete it - if it has no children then we can return parameter for Delete check
objCmd.CommandText = "spAuthLevelDel"
set objPara = objCmd.CreateParameter("@DelOK",3,2)
objCmd.Parameters.Append objPara
objCmd.Execute	

strDelOK =  objCmd.Parameters("@DelOK")
%>

<html>
<head>

<meta http-equiv="X-UA-Compatible" content="IE=edge" />



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
                        <td class="staticdatamenu"><font class="youAreHere">CMS Admin Menu / <strong>Authorisation Level Details</strong></font></td>
                    </tr>
                    <tr><td colspan=2 class=titlearealine  height=1></td></tr>
				</table>
          
            <!--<table width=100% height='<%'=session("heightIs")%>px' border=0 cellpadding=0 cellspacing=0> -->
            <table style="height:900px;" width=100% height="328" border=0 cellpadding=0 cellspacing=0> 
      		<tr valign=Top>
        	  <td class="sidemenuwidth" background="Images/tableback.png"><!--#include file="Includes/authmenu.inc"--></td>
    					<td align=left >
    						<table border=0 cellpadding=0 cellspacing=0 width=100%>
    							<tr height=16 class=SectionHeader>
    								<td>
    									<table border=0 cellpadding=0 cellspacing=0>
                                        	<tr>
                                                <td class=toolbar width=8></td>
                                                <!--
                                                <td width=20><a class=itemfontlink href="AdminQTypeAdd.asp"><img class="imagelink" src="images/newitem.gif"></a></td>
                                                <td class=toolbar valign="middle">New Q Type</td>
                                                <td class=titleseparator valign="middle" width=14 align="center">|</td>
                                                -->
                                                <td width=20><a class=itemfontlink href="AdminAuthLevelEdit.asp?lvlID=<%=request("lvlID")%>"><img class="imagelink" src="images/editgrid.gif"></A></td>
                                                <td class=toolbar valign="middle">Edit Authorisation Level</td>
						<!--
												<% if strDelOK = "0" then %>
                                                	<td class=titleseparator valign="middle" width=14 align="center">|</td>
                                                	<td width=20><a class=itemfontlink href="DeleteRec.asp?RecID=<%=request("lvlID")%>&TableName=<%=strTable%>&TabId=<%=strTabID%>&GoTo=<%=strGoTo%>" onClick="javascript:return(checkDelete());"><img class="imagelink" src="images/delitem.gif"></A></td>
                                                	<td class=toolbar valign="middle">Delete Authorisation Level</td>
												<% end if %>
						-->
                                                <td class=titleseparator valign="middle" width=14 align="center">|</td>
                                                <td class=toolbar valign="middle"><a class=itemfontlink href="AdminAuthLevelList.asp">Back To List</A></td>											
                                            </tr>
    									</table>
    								</td>
    							</tr>
							    <tr>
    								<td>
    									<table width=100% border=0 cellpadding=0 cellspacing=0>
    										<tr height=16>
    											<td colspan="4">&nbsp;</td>
    										</tr>
                                            <tr class=columnheading height=22>
                                                <td valign="middle" width=1%>&nbsp;</td>
                                                <td valign="middle" width=13%>Authorisation Level:</td>
                                                <td valign="middle" width=7% class=itemfont><%=rsRecSet("authLevel")%></td>
                                                <td >&nbsp;</td>
                                            </tr>
											<tr height=16>
                                            	<td colspan="4">&nbsp;</td>
                                            </tr>
                                            <tr>
                                                <td valign="middle" width=1%>&nbsp;</td>
                                                <td valign="middle" width=13%>Administration Rank:</td>
                                                <td valign="middle" width=7% class=itemfont><%=rsRecSet("rank")%></td>
                                                <td valign="middle" width=79%  style="color:#F00">&nbsp; <strong> NB: This is the MINIMUM rank allowed as an Administrator for this Auth Level</strong></td>
                                            </tr>
                                            <tr height=16>
                                            	<td colspan="4">&nbsp;</td>
                                            </tr>
                                            <tr>
                                                <td valign="middle" width=1%>&nbsp;</td>
                                                <td valign="middle" width=13%>Holding Rank:</td>
                                                <td valign="middle" width=7% class=itemfont><%=rsRecSet("authedRank")%> </td>
                                                <td valign="middle" width=79%  style="color:#F00">&nbsp; <strong> NB: This is the MINIMUM rank allowed to be granted an Authorisation at this Auth Level</strong></td>
                                            </tr>

                                            <tr>
                                            	<td colspan=4 class=titlearealine  height=1></td> 
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
