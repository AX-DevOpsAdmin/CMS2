<!DOCTYPE HTML >

<!--#include file="Includes/security.inc"--> 

<%
dim strError
dim objFSO
dim objFolder
dim objFiles

' so the menu include - datamenu.inc knows what page we're on
dim strPage
strPage="Excel"
	
set objFSO = server.createobject("Scripting.FileSystemObject")
set objFolder = objFSO.GetFolder(server.mappath("Documents/"))
%>

<html>
<head>

<!--#include file="Includes/IECompatability.inc"-->


<title><%= PageTitle %></title>
<link rel="stylesheet" type="text/css" href="Includes/AMDB.css" media="Screen"/><meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
</head>
<body>
<form name="frmUpload" method="post">
    <input name="newattached" id="newattached"  type="hidden" value="">
	<table height="100%" cellspacing=0 cellPadding=0 width=100% border=0>
		<tr>
			<td>
				<!--#include file="Includes/Header.inc"--> 
				<table cellSpacing=0 cellPadding=0 width=100% border=0 >
                    <tr style="font-size:10pt;" height=26px>
                        <td width=10><img style="margin-left:10px;" src="cms_icons/png/24x24/process.png" width="24" height="24"></td>
                        <td class="staticdatamenu"><font class="youAreHere">CMS Admin Menu / <strong>View / Upload Detachment Spreadsheet </strong></font></td>
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
									<td class=toolbar valign="middle">
                                    	<table border="0" cellpadding="0" cellspacing="0">
                                        	<tr>
                                            	<td class="toolbar" width="2">&nbsp;</td>
												<td width=20><a class=itemfontlink href="javascript:checkThis()"><img class="imagelink" src="Images/attachup.png"></a></td>
												<td class=toolbar valign="middle">Upload File</td>
												<td class=titleseparator valign="middle" width=14 align="center">|</td>
                                                <td width=20><a class=itemfontlink href="#" onClick="javascript:Delete()"><img class="imagelink" src="Images/delitem.gif"></A></td>
                                                <td class=toolbar valign="middle" >Delete File(s)</td>
                                            </tr>
                                        </table>
                                    </td>
								</tr>
								<tr>
									<td>
										<table width="100%" border="0" cellpadding="0" cellspacing="0">
                                            <tr>
                                            	<td colspan="4" height="22px">&nbsp;</td>
                                            </tr>
                                        	<tr>
                                            	<td width="2%">&nbsp;</td>
                                                <td width="48%" height="22px" class="columnheading">File(s)</td>
                                                <td width="6%" height="22px" class="columnheading" style="text-align:center;">Delete</td>
                                                <td width="34%" height="22px">&nbsp;</td>
                                            </tr>
											<% if objFolder.files.count > 0 then %>
                                                <% for each objFiles in objFolder.files %>
                                                    <tr>
                                                        <td height="20px">&nbsp;</td>
                                                        <td height="20px" align="left"><a href="Documents/<%= objFiles.name %>" class="itemfontlinksmall" target="_blank"><%= objFiles.name %></a></td>
                                                        <td height="20px" align="center"><input name="<%= objFiles.name %>" id="<%= objFiles.name %>" type="checkbox" value="1" id="<%= objFiles.name %>"></td>
                                                        <td height="20px">&nbsp;</td>
                                                    </tr>
                                                <% next %>
                                            <% else %>
                                                <tr class="toolbar">
                                                    <td width="2%" height="20px">&nbsp;</td>
                                                    <td colspan="3" height="20px">No File(s) Found</td>
                                                </tr>
                                            <% end if %>
											<tr>
												<td colspan="4">&nbsp;</td>
											</tr>
                                            <tr>
                                                <td colspan=4 class=titlearealine height=1></td> 
                                            </tr>
										</table>
										<table width="100%" border="0" cellpadding="0" cellspacing="0">
											<tr>
												<td colspan="3">&nbsp;</td>
											</tr>
											<tr class="columnheading">
                                            	<td width="2%">&nbsp;</td>
												<td width="13%" valign="middle">File Name:</td>
												<td width="85%"><input type="file" name="file1" style="width:650px;" id="file1"></td>
											</tr>
											<tr>
												<td colspan="3">&nbsp;</td>
											</tr>
                                            <tr>
                                                <td colspan=3 class=titlearealine height=1></td> 
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

function checkThis()
{
	var txt = document.frmUpload.file1.value; 
	var errMsg = "";
	  
	/* make sure they have entered comments for the next stage */
	if(!txt.length > 0)
	{
		errMsg += "Select a file to Upload";
	}
	  	   
	if(!errMsg == "")
	{
		alert(errMsg)
		return;	  		
	} 
	document.frmUpload.encoding = "multipart/form-data";
	document.frmUpload.action="filesUpload.asp";
    document.frmUpload.submit();  
}

function Delete()
{
	var newattached = "Start";
	var blnDelete = 0;
	
	for (var i = 0; i < document.frmUpload.elements.length; i++)
	{
		if (document.frmUpload.elements[i].checked==true)
		{
				newattached = newattached + "," + document.frmUpload.elements[i].name;
				blnDelete = 1;
		}
	}
	document.frmUpload.newattached.value = newattached;
	
	if(blnDelete == 0)
	{
	    alert("Select File(s) to delete")
	    return;	  		
    }
	
	yesBox=confirm("Are you sure you want to delete the selected file(s)?");
	
	if (yesBox==true)
	{
//		alert(document.frmUpload.newattached.value)
		document.frmUpload.action = "RemoveAttachments.asp";
		document.frmUpload.submit();
	}
}

</script>
