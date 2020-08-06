<!DOCTYPE HTML >

<!--#include file="Includes/security.inc"--> 
<!--#include file="Includes/checkadmin.asp"-->
<!--#include file="Connection/Connection.inc"-->

<%
dim strPage
dim strTable
dim strCommand

strTable = "tblQs"
strGoTo = "AdminQList.asp"   ' asp page to return to once record is deleted
strTabID = "QID"              ' key field name for table        

strRecID = "QID"
strCommand = "spQDetail"

set objCmd = server.CreateObject("ADODB.Command")
set objPara = server.CreateObject("ADODB.Parameter")
objCmd.ActiveConnection = con
objCmd.CommandText = strCommand
objCmd.CommandType = 4		

set objPara = objCmd.CreateParameter ("RecID",3,1,5, request("QID"))
objCmd.Parameters.Append objPara
set objPara = objCmd.CreateParameter ("TableID",200,1,50, strRecID)
objCmd.Parameters.Append objPara
set objPara = objCmd.CreateParameter ("Tablename",200,1,50, strTable)
objCmd.Parameters.Append objPara
set rsRecSet = objCmd.execute	'Execute CommandText when using "ADODB.Command" object

' We don't want these in check for Delete
objCmd.Parameters.delete ("TableID")
objCmd.Parameters.delete ("Tablename")

' now see if we can delete it - if it has no children then we can return parameter for Delete check
objCmd.CommandText = "spQDel"
set objPara = objCmd.CreateParameter("@DelOK",3,2)
objCmd.Parameters.Append objPara
objCmd.Execute	

strDelOK = objCmd.Parameters("@DelOK")

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
    <table  height="100%" cellspacing=0 cellPadding=0 width=100% border=0>
	    <tr>
    		<td>
    			<!--#include file="Includes/Header.inc"-->
    				<table cellSpacing=0 cellPadding=0 width=100% border=0 >
                    <tr style="font-size:10pt;" height=26px>
                        <td width=10><img style="margin-left:10px;" src="cms_icons/png/24x24/process.png" width="24" height="24"></td>
                        <td class="staticdatamenu"><font class="youAreHere">CMS Admin Menu / <strong>Qualification Details</strong></font></td>
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
    									<table border=0 cellpadding=0 cellspacing=0>
                                        	<tr>
                                                <td class=toolbar width=8></td>
                                                <!--
                                                <td width=20><a class=itemfontlink href="AdminQListAdd.asp"><img class="imagelink" src="images/newitem.gif"></a></td>
                                                <td class=toolbar valign="middle">New Q</td>
                                                <td class=titleseparator valign="middle" width=14 align="center">|</td>
                                                -->
                                                <td width=20><a class=itemfontlink href="AdminQListEdit.asp?QID=<%=request("QID")%>"><img class="imagelink" src="images/editgrid.gif"></A></td>
                                                <td class=toolbar valign="middle">Edit Q</td>
												<% if strDelOK = "0" then %>
                                                	<td class=titleseparator valign="middle" width=14 align="center">|</td>
                                                	<td width=20><a class=itemfontlink href="DeleteRec.asp?RecID=<%=request("QID")%>&TableName=<%=strTable%>&TabId=<%=strTabID%>&GoTo=<%=strGoTo%>" onClick="javascript:return(checkDelete());"><img class="imagelink" src="images/delitem.gif"></A></td>
                                                	<td class=toolbar valign="middle">Delete Q</td>
                                                <% end if %>    
                                                <td class=titleseparator valign="middle" width=14 align="center">|</td>
                                                <td class=toolbar valign="middle"><a class=itemfontlink href="AdminQList.asp">Back To List</A></td>											
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
                                                <td height=22 valign="middle" width=13%>Qualification:</td>
                                                <td height=22 valign="middle" width=85% class=itemfont><%=rsRecSet("Description")%></td>
                                            </tr>
                                            <tr class=columnheading>
                                                <td height=22 valign="middle" width=2%>&nbsp;</td>
                                                <td height=22 valign="middle" width=13%>Q Type:</td>
                                                <td height=22 valign="middle" width=85% class=itemfont><%=rsRecSet("QType")%></td>
                                            </tr>
                                           
                                            <tr class=columnheading>
                                                <td height=22 valign="middle" width=2%>&nbsp;</td>
                                                <td width=13% valign="top">Description:</td>
                                                <td width=85% valign="middle" class=itemfont><div style=" width:360px; height: 60px; overflow:auto;"><%=rsRecSet("LongDesc")%></div></td>
                                            </tr>
                                     
                                            <tr class=columnheading>
                                                <td height=22 valign="middle" width=2%>&nbsp;</td>
                                                <td height=22 valign="middle" width=13%>Validity Period:</td>
                                                <td height=22 valign="middle" width=85% class=itemfont><%=rsRecSet("ValidityPeriod")%></td>
                                            </tr>
                                            <tr class=columnheading>
                                                <td height=22 valign="middle" width=2%>&nbsp;</td>
                                                <td height=22 valign="middle" width=13%>Amber Period:</td>
                                                <td height=22 valign="middle" width=85% class=itemfont><%=rsRecSet("Amber")%></td>
                                            </tr>
                                            <% if session("boa") <> 0 then %>                                            
                                                <tr class=columnheading>
                                                    <td height=22 valign="middle" width=2%>&nbsp;</td>
                                                    <td height=22 valign="middle" width=13%>Enduring Q:</td>
                                                    <td height=22 valign="middle" width=85% class=itemfont><% if rsRecSet("Enduring") = true then %><img src="Images/checked.gif" width="13" height="13"><% else %><img src="Images/unchecked.gif" width="13" height="13"><% end if %></td>
                                                </tr>
                                                <tr class=columnheading>
                                                    <td height=22 valign="middle" width=2%>&nbsp;</td>
                                                    <td height=22 valign="middle" width=13%>Contingent Q:</td>
                                                    <td height=22 valign="middle" width=85% class=itemfont><% if rsRecSet("Contingent") = true then %><img src="Images/checked.gif" width="13" height="13"><% else %><img src="Images/unchecked.gif" width="13" height="13"><% end if %></td>
                                                </tr>
                                            <% end if %>
											<tr>
                                            	<td colspan="3" height=22>&nbsp;</td>
                                            </tr>
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
