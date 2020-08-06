<!DOCTYPE HTML >

<!--#include file="Includes/security.inc"--> 
<!--#include file="Connection/Connection.inc"-->
<!--#include file="Includes/checkmanager.inc"-->  
<!--include file="Includes/manageradmin.inc"-->  

<%
'if session("postID") ="" then 
session("postID") = request("postID")
tab=1
strTable = "tblstaff"
strGoTo = "AdminPeRsList.asp"   ' asp page to return to once record is deleted
strTabID = "staffID"              ' key field name for table        

strRecid = "staffID"
strCommand = "spPeRsDetail"

set objCmd = server.CreateObject("ADODB.Command")
set objPara = server.CreateObject("ADODB.Parameter")
objCmd.ActiveConnection = con
objCmd.CommandText = strCommand
objCmd.CommandType = 4		

set objPara = objCmd.CreateParameter ("RecID",3,1,5, request("StaffID"))
objCmd.Parameters.Append objPara

set rsRecSet = objCmd.Execute	'Execute CommandText when using "ADODB.Command" object

' now see if we can delete it - if it has no children then we can return parameter for Delete check
objCmd.CommandText = "spPersDel"	'Name of Stored Procedure
set objPara = objCmd.CreateParameter("@DelOK",3,2)
objCmd.Parameters.Append objPara
objCmd.Execute	

' Only show ALL personnel details if the person looking is the person they clicked on
if request("StaffID")=session("staffid") then
  strSeeAll=1
else
  strSeeAll=0
end if

strDelOK = objCmd.Parameters("@DelOK")
objCmd.Parameters.delete ("@DelOK")

intHrc= int(rsRecSet("hrcID"))

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


<title>Personnel Details</title>
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
    <input name="staffID" id="staffID" type="hidden" value="<%=request("StaffID")%>">
    <input name="seeall" id="seeall" type="hidden" value="<%=strSeeAll%>">
    <table border="0" cellpadding="0" cellspacing="0" width="100%">
        <!--#include file="Includes/hierarchyStaffDetails.inc"--> 
        <tr>
            <td colspan="10" class="titlearealine" height="1"><img height="1" alt="" src="Images/blank.gif"></td> 
        </tr>
    </table>

    <table border="0" cellpadding="0" cellspacing="0" width="100%">
        <tr height="5px"class="SectionHeader">
            <td>
                <table border="0" cellpadding="0" cellspacing=0 >
					<% if strManager = "1" then %>
                        <td class="toolbar" width="8">&nbsp;</td>
                        <td width="20px"><a class="itemfontlink" href="javascript:gotoEdit();"><img class="imagelink" src="images/editgrid.gif"></a></td>
                        <td class="toolbar" valign="middle">Edit Personnel</td>
                        <% if strDelOK = "0" then %>
                            <td class="titleseparator" valign="middle" width="14" align="center">|</td>
                            <td class="toolbar" width="8">&nbsp;</td>
                            <td width="20"><a class="itemfontlink" href="DeleteRec.asp?RecID=<%=request("recID")%>&TableName=<%=strTable%>&TabId=<%=strTabID%>&GoTo=<%=strGoTo%>" onClick="javascript:return(checkDelete());"><img class="imagelink" src="images/delitem.gif"></a></td>
                            <td class="toolbar" valign="middle">Delete</td>
                            <td class="titleseparator" valign="middle" width="14" align="center">|</td>
                        <% end if %>  
                    <% end if %>	
                </table>
            </td>
        </tr>
        <tr height="20px">
            <td>&nbsp;</td>
        </tr>
		<tr>
            <td>
                <table border="0" cellpadding="0" cellspacing="0" width="100%">
                	<tr valign="top">
                        <td width="8px">&nbsp;</td>
                        <td width=400px>
                        	<table border="0" cellpadding="0" cellspacing="0" width="100%">
                                <tr valign="top">
                                    <td width="9">&nbsp;</td>
                                    <td width="79">Service No:</td>
                                    <td width="163">
                                       <div class="borderArea" style="width:160px; float:left; "><%=rsRecSet("serviceno")%></div>
                                    </td>
                                    
                                    <td width="79">First Name:</td>
                                    <td width="174">
                                       <div class="borderArea" style="width:160px; float:left; "><%=rsRecSet("firstname")%></div>
                                    </td>
                                    <td width="80">Surname:</td>
                                    <td width="728">
                                       <div class="borderArea" style="width:160px; float:left; "><%=rsRecSet("surname")%></div>
                                    </td>
                                </tr>
                                <tr height="5px">
                                    <td colspan="8">&nbsp;</td>
                                </tr>
                                <tr valign="top">
                                    <td width="9">&nbsp;</td>
                                    <td width="79">Rank:</td>
                                    <td width="163">
                                       <div class="borderArea" style="width:160px; float:left; "><%=rsRecSet("rank")%></div>
                                    </td>
                                    
                                    <td width="79">Trade:</td>
                                    <td width="174">
                                       <div class="borderArea" style="width:160px; float:left; "><%=rsRecSet("trade")%></div>
                                    </td>
                                    
                                    <td width="80">Known As:</td>
                                    <td width="728">
                                       <div class="borderArea" style="width:160px; float:left; "><%=rsRecSet("knownas")%></div>
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


<script language="javascript">

var thisDate = window.parent.frmDetails.startDate.value;
var homeString ='javascript:refreshIframeAfterDateSelect("ManningTeamPersonnel.asp");'
window.parent.crumbTrail.innerHTML="<A href='index.asp' class=itemfontlinksmall >Home</A> > <A title='' href='" + homeString + "' class=itemfontlinksmall >Personnel</A> > <font class='youAreHere' >Personnel Details</font>"

</script>
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

function gotoEdit(){
	//alert (ttID + "," + description)
	document.frmDetails.action="HierarchyPeRsEdit.asp";
	//alert(document.frmDetails.action);
	document.frmDetails.submit();
}


</Script>

