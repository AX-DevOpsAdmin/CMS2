<!DOCTYPE HTML >

<!--#include file="Includes/security.inc"--> 
<!--#include file="Connection/Connection.inc"-->
<!--#include file="Includes/checkmanager.inc"-->  
<!--#include file="Includes/manageradmin.inc"-->  

<%
tab=1
' sets date to UK format - dmy
session.lcid=2057

dim strAction
dim strTable
dim strSQL
dim strGoTo

strAction="Update"
strGoTo="HierarchyPersDetail.asp"

set objCmd = server.CreateObject("ADODB.Command")
set objPara = server.CreateObject("ADODB.Parameter")
objCmd.ActiveConnection = con
objCmd.CommandType = 4		

' get the default rank 
strCommand = "spListRanks"

objCmd.CommandText = strCommand
set objPara = objCmd.CreateParameter ("nodeID", 3,1,0, nodeID)
objCmd.Parameters.Append objPara
set rsRank = objCmd.Execute	'Execute CommandText when using "ADODB.Command" object

strCommand = "spListTable"
objCmd.CommandText = strCommand

' now get the MES details
strTable = "tblMES"
set objPara = objCmd.CreateParameter ("TableName",200,1,50, strTable)
objCmd.Parameters.Append objPara
set rsMES = objCmd.Execute	'Execute CommandText when using "ADODB.Command" object

for x = 1 to objCmd.parameters.count
	objCmd.parameters.delete(0)
next

' now get the trades
objCmd.CommandText = "spListTrades"	'Name of Stored Procedure
'objCmd.CommandType = 4				'Code for Stored Procedure
set objPara = objCmd.CreateParameter ("nodeID", 200,1,50, nodeID)
objCmd.Parameters.Append objPara
set rsTrade = objCmd.Execute	'Execute CommandText when using "ADODB.Command" object

for x = 1 to objCmd.parameters.count
	objCmd.parameters.delete(0)
next

'' now get the staff details we just clicked on
strTable = "tblstaff"
strRecid = "staffID"
strCommand = "spPeRsDetail"
objCmd.CommandText = strCommand
set objPara = objCmd.CreateParameter ("RecID",3,1,5, request("staffID"))
objCmd.Parameters.Append objPara

set rsRecSet = objCmd.Execute	''Execute CommandText when using "ADODB.Command" object

if rsRecSet("administrator")=True then 
  stradmin=1 
else 
  stradmin=0 
end if

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
	
	newTodaydate = formatdatetime(date(),2)
end function
	
%>
<html>
<head>

<!--#include file="Includes/IECompatability.inc"-->
<title>Personnel Details</title>
<link rel="stylesheet" type="text/css" href="Includes/AMDB.css" media="Screen"/>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<script type="text/javascript" src="Includes/ajax.js"></script>

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

<form  action="" method="POST" name="frmDetails">
<input name="staffID" id="staffID" type="hidden" value="<%=request("StaffID")%>">
<Input name="HiddenDate" id="HiddenDate" type="hidden" >
<input type=hidden name="Administrator" id="Administrator" value=<%=stradmin%>>
<Input name="strAction" id="strAction" type="hidden" value="<%=strAction%>">
<Input name="strGoto" id="strGoto" type="hidden" value="<%=strGoTo%>">
	<table border=0 cellpadding=0 cellspacing=0 width=100%>
		<!--#include file="Includes/hierarchyStaffDetails.inc"--> 
        <tr>
            <td colspan="10" class="titlearealine"  height="1"><img height="1" alt="" src="Images/blank.gif"></td> 
        </tr>
        <tr height="16" class="SectionHeader">
            <td>
                <table border="0" cellpadding="0" cellspacing="0">
                    <tr>
                        <td class="toolbar" width="8">&nbsp;</td>
                        <td width="20"><a href="javascript:checkThis();"><img class="imagelink" src="images/saveitem.gif"></a></td>
                        <td class="toolbar" valign="middle">Save and Close</td>
                        <td class="titleseparator" valign="middle" width="14" align="center">|</td>
                        <td class="toolbar" valign="middle"><a class="itemfontlink" href="javascript:gotoView();">Back</a></td>
                    </tr>
                </table>
            </td>
        </tr>
        <tr height="20px">
            <td>&nbsp;</td>
        </tr>
        <tr height="16">
            <td class="itemfont" height="20px"><font class="style2">* Mandatory Fields</font></td>
        </tr>
        <tr height="20px">
            <td>&nbsp;</td>
        </tr>
        <tr>
            <td>
                <table border="0" cellpadding="0" cellspacing="0" width="100%">
                    <tr valign="top">
                        <td width="8px">&nbsp;</td>
                        <td width="400px">
                        	<table border="0" cellpadding="0" cellspacing="0" width="100%">
                                <tr valign="top">
                                    <td width="8px">&nbsp;</td>
                                    <td width="400px">
                                        <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                            <tr class="personalDetails">
                                                <td width="96">Service No:</td>
                                                <td class="itemfont" width="1175"><input style="width:90px;" name="txtserviceno" type="text" class="inputbox itemfont" id="txtserviceno" value="<%=rsrecset("serviceno")%>">&nbsp;<span class="style2">*</span></td>
                                            </tr>
                                            <tr height="5px">
                                                <td colspan="2">&nbsp;</td>
                                            </tr>

                                            <tr class="personalDetails">
                                                <td width="96">First Name:</td>
                                                <td class="itemfont" width="1175"><input name="txtfirstname" type="text" style="width:160px;" class="inputbox itemfont" id="txtfirstname" value="<%=rsrecset("firstname")%>">&nbsp;<span class="style2">*</span></td>
                                            </tr>
                                            <tr height="5px">
                                                <td colspan="2">&nbsp;</td>
                                            </tr>
                                            
                                            <tr class="personalDetails">
                                                <td width="96">Surname:</td>
                                                <td class="itemfont" width="1175"><input name="txtsurname" type="text" style="width:160px;" class="inputbox itemfont" id="txtsname2" value="<%=rsrecset("surname")%>">&nbsp;<span class="style2">*</span></td>
                                            </tr>
                                            <tr height="5px">
                                                <td colspan="2">&nbsp;</td>
                                            </tr>

                                            <tr class="personalDetails">
                                                <td width="96">Rank:</td>
                                                <td class="itemfont" width="1175">
                                                    <select  name="cmbRank" id="cmbRank" class="inputbox itemfont" style="width:80px;">
                                                        <option value="">...Select...</option>
                                                            <%do while not rsRank.eof %>
                                                                <option value = "<%= rsRank("rankid") %>" <%if (rsRank("rankID") = rsRecSet("rankID")) then Response.Write("SELECTED") : Response.Write("")%> ><%= rsRank("shortDesc") %></option>
                                                            <% 
                                                            rsRank.movenext
                                                        loop%>
                                                    </select>&nbsp;<span class="style2">*</span>
                                                </td>
                                            </tr>
                                            <tr height="5px">
                                                <td colspan="2">&nbsp;</td>
                                            </tr>
                                            <tr class="personalDetails">
                                                <td width="96">Trade:</td>
                                                <td class="itemfont" width="1175">
                                                    <select name="cmbTrade" id="cmbTrade" class="itemfont itemfont" style="width:185px;">
                                                        <option value="">...Select...</option>
                                                        <%do while not rsTrade.eof %>
                                                            <option value = "<%= rsTrade("tradeid") %>" <%if (rsTrade("tradeID") = rsRecSet("TradeID")) then Response.Write("SELECTED") : Response.Write("")%> ><%= rsTrade("description") %></option>
                                                            <% rsTrade.movenext
                                                        loop%>
                                                    </select>&nbsp;<span class="style2">*</span>
                                                </td>
                                            </tr>
                                            <tr height="5px">
                                                <td colspan="2">&nbsp;</td>
                                            </tr>

                                            <tr class="personalDetails">
                                                <td width="96">Known As:</td>
                                                <td class="itemfont" width="1175"><input name="txtknownas" type="text" style="width:120px;" class="inputbox itemfont" id="txtknownas2" value="<%=rsrecset("knownas")%>"></td>
                                            </tr>
                                            <tr height="5px">
                                                <td colspan="2">&nbsp;</td>
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


<script type="text/javascript" src="calendar.js"></script>

<script language="javascript">

var thisDate = window.parent.frmDetails.startDate.value;
var homeString ='javascript:refreshIframeAfterDateSelect("ManningTeamPersonnel.asp");';
window.parent.crumbTrail.innerHTML="<A href='index.asp' class=itemfontlinksmall >Home</A> > <A title='' href='" + homeString + "' class=itemfontlinksmall >Team Hierarchy</A> > <font class='youAreHere' >Personnel Details</font>"

</script>
<script language="javascript">

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

function checkThis()
{
	var txtsvn = document.frmDetails.txtserviceno.value;
	var txtfnm = document.frmDetails.txtfirstname.value;
	var txtsnm = document.frmDetails.txtsurname.value; 
	var txtkas = document.frmDetails.txtknownas.value;
	    
	if (document.frmDetails.cmbRank.value == ""){
		errMsg += "Rank\n"
		error = true
		}   
    if (document.frmDetails.cmbTrade.value == "") {
		errMsg += "Trade\n"
		error = true
		}

	/*******
	var txthph = document.frmDetails.txthphone.value;
	var txtmob = document.frmDetails.txtmobile.value;
	var txtpob = document.frmDetails.txtpob.value;
	var txtppn = document.frmDetails.txtpptno.value;
	var txtiss = document.frmDetails.txtissueby.value;
	var txtpoc = document.frmDetails.txtpoc.value;
	var txtwfw = document.frmDetails.txtwwishes.value;
	var txtarr = document.frmDetails.txtarrival.value;
	var txtpst = document.frmDetails.txtposting.value;
	var txtppp = document.frmDetails.txtexpiry.value;
	var txtwlf = document.frmDetails.txthandbook.value;
    */
	var errMsg = "Please provide/correct the following:\n\n";
	var error = false;
	  
	/* make sure they have entered all details for the next stage */
    if(!txtfnm.length > 0) {
		errMsg += "First Name\n"
		error = true
		}
    if(!txtsvn.length > 0) {
		errMsg += "Service No.\n"
		error = true
		}
	
    if(!txtsnm.length > 0) {
		errMsg += "Surname\n"
		error = true
		}

	/**
	if(document.frmDetails.cmbGender.value == "") {
		errMsg += "Gender\n"
		error = true
		}  
	if(!txtarr.length > 0) {
		errMsg += "Arrival Date\n"
		error = true
		} 
	if (document.frmDetails.txtdob.value == "") {
		errMsg += "Date of Birth\n"
		error = true
		}
	**/
	/* now check the dates are in order 
	if(txtarr.length > 0 && txtpst.length > 0)
	{
		var dst = parseInt(txtarr.substring(0,2),10);
		var mst = parseInt(txtarr.substring(3,5),10);
		var yst = parseInt(txtarr.substring(6,10),10);
		var den = parseInt(txtpst.substring(0,2),10);
		var men = parseInt(txtpst.substring(3,5),10);
		var yen = parseInt(txtpst.substring(6,10),10);

		days0 = txtarr.substring(0,2);
		months0 = txtarr.substring(3,5)-1;
		year0 = txtarr.substring(6,10);

		days1 = txtpst.substring(0,2);
		months1 = txtpst.substring(3,5)-1;
		year1 = txtpst.substring(6,10);

		dateStartedX = new Date();
		dateStartedX.setDate(1);

		dateStartedX.setYear(year0);
		dateStartedX.setMonth(months0);
		dateStartedX.setDate(days0);

		dateEndedX = new Date();
		dateEndedX.setDate(1);

		dateEndedX.setYear(year1);
		dateEndedX.setMonth(months1);
		dateEndedX.setDate(days1);

		if(dateStartedX > dateEndedX)
		{
			errMsg += "Posting Due Date must be greater than the Arrival Date"
		}
		
	}
	*/
	  	   	  	   
	if(error == true)
	{
		alert(errMsg)
		return;	  		
	} 
	
	document.frmDetails.action="UpdatePers.asp";	
    document.frmDetails.submit();  
}

function gotoView()
{
	document.frmDetails.action="HierarchyPeRsDetail.asp";
	document.frmDetails.submit();
}

function getRanks(serID) {
	ajax('ddPersRanks.asp','serID='+serID,'rnkdiv');
}

</script>

