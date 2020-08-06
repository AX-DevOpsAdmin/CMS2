<!DOCTYPE HTML >

<!--#include file="Includes/security.inc"--> 
<!--#include file="Connection/Connection.inc"-->

<%
    tab=8
'	strTable = "tblstaff"
'	strGoTo = "AdminPeRsList.asp"   ' asp page to return to once record is deleted
'	strTabID = "staffID"              ' key field name for table        
'	strRecid = "staffID"
	
	if request("goTo")= "Add" then
	  strGoTo="HierarchyPersAuthAdd.asp"
	else
	  strGoTo="HierarchyPersAuthsRemove.asp"
	end if
	
	'checking for Team Manager Status etc'
	strCommand = "spPeRsDetail"
	
	set objCmd = server.CreateObject("ADODB.Command")
	set objPara = server.CreateObject("ADODB.Parameter")
	objCmd.ActiveConnection = con
	objCmd.Activeconnection.cursorlocation = 3
	
	objCmd.CommandText = strCommand
	objCmd.CommandType = 4		
	
	set objPara = objCmd.CreateParameter ("RecID",3,1,5, request("staffID"))
	objCmd.Parameters.Append objPara
	set rsRecSet = objCmd.Execute	'Execute CommandText when using "ADODB.Command" object'

	for x = 1 to objCmd.parameters.count
		objCmd.parameters.delete(0)
	next

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


function convertDate (oldDate)
	todayDate = formatdatetime(oldDate,2)
	splitDate = split (todayDate,"/")
	if splitdate(1)="01" then theMonth="Jan"
	if splitdate(1)="02" then theMonth="Feb"
	if splitdate(1)="03" then theMonth="Mar"
	if splitdate(1)="04" then theMonth="Apr"
	if splitdate(1)="05" then theMonth="May"
	if splitdate(1)="06" then theMonth="Jun"
	if splitdate(1)="07" then theMonth="Jul"
	if splitdate(1)="08" then theMonth="Aug"
	if splitdate(1)="09" then theMonth="Sep"
	if splitdate(1)="10" then theMonth="Oct"
	if splitdate(1)="11" then theMonth="Nov"
	if splitdate(1)="12" then theMonth="Dec"
	
	newDate= splitDate(0) + " " + theMonth + " " + splitDate(2) 
	response.write newDate
end function
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
.style2 {color: #F00000}
-->
</style>

</head>
<body>
<!--<form action="HierarchyPersAuths.asp" method="post" name="frmDetails">-->
<form action=<%= strGoTo %> method="post" name="frmDetails">

	<input type=hidden name="staffID" id="staffID" value=<%=request("staffID")%>>
    <input type=hidden name="datenow" id="datenow" value=<%=request("thisDate")%>>
	<table border=0 cellpadding=0 cellspacing=0 width=100%>
		<!--#include file="Includes/hierarchyStaffDetails.inc"-->
		<tr>
			<td class=titlearealine  height=1></td> 
		</tr>
		<tr class=SectionHeader>
	  		<td>
				<table border=0 cellpadding=0 cellspacing=0 >
                	<tr>
						<td height="25px" class=toolbar width=8>&nbsp;</td>
						<td height="25px" class=toolbar align="left"><A class=itemfontlink href="HierarchyPeRsAuthorise.asp?staffID=<%=request("staffID")%>&thisdate=<%=request("thisDate")%>" > Back to Summary</A></td>											
        			</tr>
				</table>
	  		</td>
		</tr>
		<tr>
	  		<td>
                <table border=0 cellpadding=0 cellspacing=0 width=100%>
                    <tr>
                    	<td height="22px" colspan=6>&nbsp;</td>
                    </tr>
                    <tr class=columnheading>
                        <td align="left" width="2%" height="22px">&nbsp;</td>
                        <td align="left" width="13%" height="22px">First Name:</td>
                        <td align="left" width="25%" height="22px" class=itemfont><%=rsRecSet("firstname")%></td>
                        <td align="left" width="13%" height="22px">Surname:</td>
                        <td align="left" width="25%" height="22px" class=itemfont><%=rsRecSet("surname")%></td>
                        <td align="left" width="22%" height="22px">&nbsp;</td>
                    </tr>
                    <tr class=columnheading height=22>
                        <td align="left" width="2%" height="22px">&nbsp;</td>
                        <td align="left" width="13%" height="22px">Service No:</td>
                        <td align="left" width="25%" height="22px" class=itemfont><%=rsRecSet("serviceno")%></td>
                        <td align="left" width="13%" height="22px">Known as:</td>
                        <td align="left" width="25%" height="22px" class=itemfont><%=rsRecSet("knownas")%></td>
                        <td align="left" width="22%" height="22px">&nbsp;</td>
                    </tr>
                    <tr class=columnheading height=22>
                        <td align="left" width="2%" height="22px">&nbsp;</td>
                        <td align="left" width="13%" height="22px">Rank:</td>
                        <td align="left" width="25%" height="22px" class=itemfont><%=rsRecSet("rank")%></td>
                        <td align="left" width="13%" height="22px">Trade:</td>
                        <td align="left" width="25%" height="22px" class=itemfont><%=rsRecSet("trade")%></td>
                        <td align="left" width="22%" height="22px">&nbsp;</td>
                    </tr>
                    <tr class=columnheading height=22>
                        <td align="left" width="2%" height="22px">&nbsp;</td>
                        <td align="left" width="13%" height="22px">Post:</td>
                        <td align="left" width="25%" height="22px" class=itemfont><%=rsRecSet("post")%></td>
                        <td align="left" width="13%" height="22px">Unit:</td>
                        <td align="left" width="25%" height="22px" class=itemfont><%=rsRecSet("unit")%></td>
                        <td align="left" width="22%" height="22px">&nbsp;</td>
                    </tr>
                    <tr>
                    	<td colspan=6 height="22px">&nbsp;</td>
                    </tr>
                    <tr>
                    	<td colspan=6 class=titlearealine height=1></td> 
                    </tr>
                    <tr>
                    	<td height="22px" colspan="6">&nbsp;</td>
                    </tr>
				</table>
				<table border=0 cellpadding=0 cellspacing=0 width=100%>
					<tr class=columnheading>
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
			</td>
        </tr>
        <tr height=16>
            <td colspan=6>&nbsp;</td>
        </tr>
        <tr>
            <td colspan=6 class=titlearealine  height=1></td> 
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
function checkDelete(){
     var delOK = false 
    
	  var input_box = confirm("Are you sure you want to delete this Record ?")
	  if(input_box==true) {
		    delOK = true;
	    }
    return delOK;
}
</Script>
<SCRIPT LANGUAGE="JavaScript">
/**
function OverBackgroundChange(itemID){
    itemID.className='testTabHover';
}

function OutBackgroundChange(itemID){
    itemID.className='testTabUnselected';
}
RowColor=1
function ChangeRowColor(RowID){
	if (RowColor == 1) {
		document.all[RowID].style.backgroundColor= '#eeeeee'
		RowColor=2
	} else {
		document.all[RowID].style.backgroundColor= '#ffffff'
		RowColor=1
	}	
}
function ConfirmRefuse (LoanID, Action) {
	document.forms["Form"].elements["LoanID"].value=LoanID;
	document.forms["Form"].elements["ConfirmOrRefuse"].value=Action;
	document.forms["Form"].submit();
}
**/
</Script>
