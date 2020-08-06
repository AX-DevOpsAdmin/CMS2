<!DOCTYPE HTML >

<!--#include file="Includes/security.inc"--> 
<!--#include file="Includes/checkadmin.asp"-->
<!--#include file="Connection/Connection.inc"-->

<%

	'If user is not valid Authorisation Administrator then log them off
	If (session("authadmin") =0 AND  strAuth > 2 ) then
		Response.redirect("noaccess.asp")
	End If

strTable = "tblstaff"
strGoTo = "AdminPeRsList.asp"   ' asp page to return to once record is deleted
strTabID = "staffID"              ' key field name for table        

strCommand = "spPeRsDetail"

randomWord = ""
if request("randomWord") <> "" then
	randomWord = request("randomWord")
end if

set objCmd = server.CreateObject("ADODB.Command")
set objPara = server.CreateObject("ADODB.Parameter")
objCmd.ActiveConnection = con
objCmd.CommandText = strCommand
objCmd.CommandType = 4		

set objPara = objCmd.CreateParameter ("staffID",3,1,5, request("staffID"))
objCmd.Parameters.Append objPara
set rsRecSet = objCmd.Execute	'Execute CommandText when using "ADODB.Command" object

' now see if we can delete it - if it has no children then we can return parameter for Delete check
objCmd.CommandText = "spPersDel"	'Name of Stored Procedure
set objPara = objCmd.CreateParameter("@DelOK",3,2)
objCmd.Parameters.Append objPara
objCmd.Execute	

strDelOK = objCmd.Parameters("@DelOK")

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
<form action="" method="POST" name="frmDetails">
    <table height="100%" cellspacing="0" cellpadding="0" width="100%" border="0">
	    <tr>
    		<td>
				<!--#include file="Includes/Header.inc"-->
               <table cellSpacing=0 cellPadding=0 width=100% border=0 >
                    <tr style="font-size:10pt;" height=26px>
                        <td width=10><img style="margin-left:10px;" src="cms_icons/png/24x24/process.png" width="24" height="24"></td>
                        <td class="staticdatamenu"><font class="youAreHere">CMS Admin Menu / <strong>Personnel Details</strong></font></td>
                    </tr>
                    <tr><td colspan=2 class=titlearealine  height=1></td></tr>
				</table>
          
                  <table width=100% height='<%=session("heightIs")%>px' border=0 cellpadding=0 cellspacing=0> 
                    <tr valign=Top>
                      <td class="sidemenuwidth" background="Images/tableback.png"><!--#include file="Includes/datamenu.inc"--></td>
                        <td align="left">
                            <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                <tr height="25" class="SectionHeader">
                                    <td>
                                        <table border="0" cellpadding="0" cellspacing="0">
                                            <tr>
                                                <td width="20"><a class=itemfontlink href="AdminPeRsEdit.asp?staffID=<%=rsRecset("staffID")%>"><img class="imagelink" src="images/editgrid.gif"></a></td>
                                                <td class="toolbar" valign="middle">Edit Personnel</td>
                                                <td class="titleseparator" valign="middle" width="14" align="center">|</td>
                                                <td class="toolbar" valign="middle" ><a class=itemfontlink href="AdminPeRsAuthList.asp">Back To List</a></td>											
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                                <tr height="5"></tr>
                                <tr>
                                    <td width=400px>
                                        <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                            <tr class="personalDetails">
                                                <td width="150">Name:</td>
                                                <td class="itemfont"><%=rsRecSet("Rank")%> &nbsp; <%=rsRecSet("firstname")%> &nbsp; <%=rsRecSet("surname")%></td>
                                            </tr>
                                            <tr class="personalDetails">
                                                <td width="150">Service No:</td>
                                                <td class="itemfont"><%=rsRecSet("serviceno")%></td>
                                            </tr>
                                            <tr class="personalDetails">
                                                <td width="150">Trade:</td>
                                                <td class="itemfont"><%=rsRecSet("trade")%></td>
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
