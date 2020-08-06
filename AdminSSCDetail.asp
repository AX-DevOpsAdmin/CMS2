<!DOCTYPE HTML >

<!--#include file="Includes/security.inc"--> 
<!--#include file="Includes/checkadmin.asp"-->
<!--#include file="Connection/Connection.inc"-->

<%
strTable = "tblSSC"
strTabID = "sscID"              ' key field name for table        

strRecid = "sscID"

strGoTo = "AdminSSCList.asp"   ' asp page to return to once record is deleted
strCommand = "spRecDetail"

set objCmd = server.CreateObject("ADODB.Command")
set objPara = server.CreateObject("ADODB.Parameter")
objCmd.ActiveConnection = con
objCmd.CommandText = strCommand
objCmd.CommandType = 4		

set objPara = objCmd.CreateParameter ("RecID",3,1,5, request("RecID"))
objCmd.Parameters.Append objPara
set objPara = objCmd.CreateParameter ("TableID",200,1,50, strRecID)
objCmd.Parameters.Append objPara
set objPara = objCmd.CreateParameter ("Tablename",200,1,50, strTable)
objCmd.Parameters.Append objPara

set rsRecSet = objCmd.Execute	'Execute CommandText when using "ADODB.Command" object

if rsRecSet("ssType")= 0 then 
   strType = "Unit Based" 
elseif rsRecSet("ssType")= 1 then 
   strType = "Operational OOA" 
elseif rsRecSet("ssType")= 2 then
   strType = "Bed Nights Away" 
end if

if rsRecSet("ssCode") < 10 then
  strcode = "0" & rsRecSet("ssCode")
elseif rsRecSet("ssCode") > 9 then
  strcode = rsRecSet("ssCode") 
end if 

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
                        <td class="staticdatamenu"><font class="youAreHere">CMS Admin Menu / <strong>SSC Details</strong></font></td>
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
										<table  border=0 cellpadding=0 cellspacing=0 >
                                        <!--
											<td class=toolbar width=7></td><td width=20><a class=itemfontlink href="AdminSSCAdd.asp"><img class="imagelink" src="images/newitem.gif"></a></td>
											<td  valign="middle" class=toolbar >New SS Code</td>
											<td class=titleseparator valign="middle" width=12 align="center">|</td>
                                         -->
                                            <td width=20><a class=itemfontlink href="AdminSSCEdit.asp?RecID=<%=request("RecID")%>"><img class="imagelink" src="images/editgrid.gif"></A></td>
											<td valign="middle" class=toolbar >Edit SS Code</td>
											<td class=titleseparator valign="middle" width=14 align="center">|</td>
                                            <td width=20><a class=itemfontlink href="DeleteRec.asp?RecID=<%=request("recID")%>&TableName=<%=strTable%>&TabId=<%=strTabID%>&GoTo=<%=strGoTo%>" onClick="javascript:return(checkDelete());"><img class="imagelink" src="images/delitem.gif"></A></td>
											<td class=toolbar valign="middle" >Delete SS Code</td>
											<td class=titleseparator valign="middle" width=12 align="center">|</td>
											<td valign="middle" class=toolbar ><A class=itemfontlink href="AdminSSCList.asp">Back To List</A></td>											
									  </table>
									</td>
									
								</tr>
								<tr>
									<td>
										<table width=100% border=0 cellpadding=0 cellspacing=0>
											<tr height=16>
												<td colspan="3">&nbsp;</td>
											</tr>
											<tr class=columnheading height=22>
												<td valign="middle" width="2%">&nbsp;</td>
												<td valign="middle" width="13%">SS Code:</td>
												<td valign="middle" width="85%" class=itemfont><%=strCode%></td>
											</tr>
											<tr class=columnheading height=22>
												<td valign="middle" width="2%">&nbsp;</td>
												<td valign="middle" width="13%">Description:</td>
												<td valign="middle" width="85%" class=itemfont><%=rsRecSet("description")%></td>
											</tr>
											<tr class=columnheading height=22>
												<td valign="middle" width="2%">&nbsp;</td>
												<td valign=Top width="13%">Notes:</td>
												<td valign="middle" width="85%" class=itemfont><textarea name="txtnotes" rows="5" class="pickbox itemfont" id="txtnotes" readonly><%=rsRecSet("ssNotes")%></textarea></td>
											</tr>
											<tr height=16>
												<td colspan="3">&nbsp;</td>
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