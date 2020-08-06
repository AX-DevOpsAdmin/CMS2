<!DOCTYPE HTML >
<!--#include file="Includes/security.inc"--> 
<!--#include file="Includes/checkadmin.asp"-->
<!--#include file="Connection/Connection.inc"-->

<%
' so the menu include - datamenu.inc knows what page we're on
dim strPage
strPage="Service"

strTable = "tblService"
strCommand = "spListTable"

set objCmd = server.CreateObject("ADODB.Command")
set objPara = server.CreateObject("ADODB.Parameter")
objCmd.ActiveConnection = con
objCmd.CommandText = strCommand
objCmd.CommandType = 4		

set objPara = objCmd.CreateParameter ("TableName",200,1,50, strTable)
objCmd.Parameters.Append objPara
set rsRecSet = objCmd.Execute	'Execute CommandText when using "ADODB.Command" object
%>

<html>

<head> 

<!--#include file="Includes/IECompatability.inc"-->

<title><%= PageTitle %></title>
<link rel="stylesheet" type="text/css" href="Includes/AMDB.css" media="Screen"/>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1"><style type="text/css">
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
<form  action="" method="POST" name="frmDetails">
  <Input name=RecID id="RecID" type=Hidden>

	<table  height="100%" cellspacing=0 cellPadding=0 width=100% border=0>
      <tr>
        <td>
          <!--#include file="Includes/Header.inc"--> 
  		  <table cellSpacing=0 cellPadding=0 width=100% border=0 >
    	    <tr >
      		  <td align="center" class="sidemenuwidth" ><img alt="" src="images/spssites.gif" ></td>
       		  <td  class=titlearea >CMS<BR>
       		    <span class="style1"><Font class=subheading>Services</Font></span></td>
    		</tr>
  			<tr>
       		  <td colspan=2 class=titlearealine  height=1></td> 
     		</tr>
  		  </table>
  		  <table width=100% height='<%=session("heightIs")%>px' border=0 cellpadding=0 cellspacing=0 > 
      		<tr valign=Top>
        	  <td class="sidemenuwidth" background="Images/tableback.png">
			     <!--#include file="Includes/datamenu.inc"-->
				</td> 
				  <td width=16></td>
				  <td align=left >
				    <table border=0 cellpadding=0 cellspacing=0 width=100%>
					  <tr height=16 class=SectionHeader>
					    <td>
						  <table border=0 cellpadding=0 cellspacing=0 >
						    <tr>
							  <td class=toolbar width=8>&nbsp;</td>
							  <td width=20><a class=itemfontlink href="AdminServiceAdd.asp"><img class="imagelink" src="images/newitem.gif"></a></td>
							  <td class=toolbar valign="middle">New Service</td>
							</tr>  
					      </table>
						</td>
					  </tr>
					  <tr>
					    <td>
						  <table width=100% border=0 cellpadding=0 cellspacing=0>
						    <tr class=columnheading height=20>
							  <td valign="middle" width=2%>&nbsp;</td>
							  <td valign="middle" width=20%>Service</td>
							  <td valign="middle" width=40%>Description</td>
							  <td valign="middle" width=38%%>Status</td>
							</tr>
						  	<tr>
       						  <td colspan=4 class=titlearealine  height=1></td> 
     					    </tr>
							<%do while not rsRecSet.eof%>
                                <tr class=itemfont ID="TableRow<%=rsRecSet ("serID")%>" height=20>
                                    <td valign="middle" width=2%>&nbsp;</td>
                                    <td valign="middle" width="20%"><A class=itemfontlink href="javascript: subForm(<%=rsRecSet("serID")%>)"><%=rsRecSet("shortDesc")%></A></td> 
                                    <td valign="middle" width="40%">
									<%if rsRecSet("Description")="" or isnull(rsRecSet("Description")) then%>
                                    	<%response.write("There is currently no description for this service.")%>
                                    <%Else%>
										<%response.write rsRecSet("Description")%>
                                    <%End if%>
                                    </td>
                                    <td valign="middle" width="38%"><%if rsRecSet("Status")=true then response.write("Active") else response.write ("Inactive") End if%></td>
                                    </tr>
                                    <tr>
                                    <td colspan=5 class=titlearealine  height=1></td> 
                                </tr>
								<%rsRecSet.MoveNext
							Loop%>
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
     document.forms.frmDetails.action = "AdminServiceDetail.asp";
	 document.forms.frmDetails.RecID.value = recID;
	 document.forms.frmDetails.submit(); 
}

</Script>
