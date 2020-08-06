<!DOCTYPE HTML >

<!--#include file="Includes/security.inc"--> 
<!--#include file="Includes/checkadmin.asp"-->
<!--#include file="Connection/Connection.inc"-->

<%
dim strAction
dim strTable
dim strSQL
dim strGoTo

strAction="Update"
strGoTo="AdminPersDetail.asp"

' get the rank list - Only ACTIVE Ranks
strCommand = "spListRanks"

set objCmd = server.CreateObject("ADODB.Command")
set objPara = server.CreateObject("ADODB.Parameter")
objCmd.ActiveConnection = con
objCmd.CommandType = 4	

objCmd.CommandText = strCommand
set objPara = objCmd.CreateParameter ("nodeID",200,1,50, nodeID)
objCmd.Parameters.Append objPara 

set rsRank = objCmd.Execute	'Execute CommandText when using "ADODB.Command" object
'	for x = 1 to objCmd.parameters.count
'		objCmd.parameters.delete(0)
'	next

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

' now get the Trades
objCmd.CommandText = "spListTrades"	'Name of Stored Procedure
set objPara = objCmd.CreateParameter ("nodeID",200,1,50, session("nodeID"))
objCmd.Parameters.Append objPara 
set rsTrade = objCmd.Execute		'Execute CommandText when using "ADODB.Command" object
	for x = 1 to objCmd.parameters.count
		objCmd.parameters.delete(0)
	next

' now get the staff details we just clicked on
strTable = "tblstaff"
strRecid = "staffID"
strCommand = "spPeRsDetail"
objCmd.CommandText = strCommand
set objPara = objCmd.CreateParameter ("staffID",3,1,0, request("staffID"))
objCmd.Parameters.Append objPara

set rsRecSet = objCmd.Execute	'Execute CommandText when using "ADODB.Command" object

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

<script type="text/javascript" src="calendar.js"></script>

<html>
<head>

<!--#include file="Includes/IECompatability.inc"-->
<title><%= PageTitle %></title>
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
<div id="overDiv" style="position:absolute; visibility:hidden; z-index:1000;"></div>

<form action="UpdatePeRs.asp?strAction=<%=strAction%>&strGoto=<%=strGoTo%>" method="post" name="frmDetails">
	<input type="hidden" name="staffID" id="staffID" value="<%=rsRecSet("staffID")%>">
	<input type="hidden" name="administrator" id="administrator" value="<%=rsRecSet("administrator")%>">   
    <table height="100%" cellspacing="0" cellpadding="0" width="100%" border="0">
        <tr>
            <td>
				<!--#include file="Includes/Header.inc"-->
                <table cellSpacing=0 cellPadding=0 width=100% border=0 >
                    <tr style="font-size:10pt;" height=26px>
                        <td width=10><img style="margin-left:10px;" src="cms_icons/png/24x24/process.png" width="24" height="24"></td>
                        <td class="staticdatamenu"><font class="youAreHere">CMS Admin Menu / <strong>Edit Personnel Details</strong></font></td>
                    </tr>
                    <tr><td colspan=2 class=titlearealine  height=1></td></tr>
				</table>
          
  		  <table width=100% height='<%=session("heightIs")%>px' border=0 cellpadding=0 cellspacing=0> 
      		<tr valign=Top>
        	  <td class="sidemenuwidth" background="Images/tableback.png"><!--#include file="Includes/datamenu.inc"--></td>



                        <td width="16">&nbsp;</td>
                        <td align="left">
                            <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                <tr height="25" class="SectionHeader">
                                    <td>
                                        <table border="0" cellpadding="0" cellspacing="0">
                                            <tr>
                                                <td class="toolbar" width="8">&nbsp;</td>
                                                <td width="20"><a href="javascript:checkThis();"><img class="imagelink" src="images/saveitem.gif"></a></td>
                                                <td class="toolbar" valign="middle">Save and Close</td>
                                                <td class="titleseparator" valign="middle" width="14" align="center">|</td>
                                                <td width="20"><a class=itemfontlink href="resetpw.asp?staffID=<%=request("staffID")%>&GoTo=<%=strGoTo%>" onClick="javascript:return(resetPW());"><img class="imagelink" src="Images/reset.gif"></a></td>
                                                <td class="toolbar" valign="middle">Reset Password</td>
                                                <td class="titleseparator" valign="middle" width="14" align="center">|</td>
                                                <td class="toolbar" valign="middle"><a class= itemfontlink href="AdminPeRsDetail.asp?staffID=<%=rsRecSet("staffID")%>">Back</a></td>
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
                                                        <tr class="personalDetails">
                                                            <td width="160px">First Name:</td>
                                                            <td class="itemfont" width="200px"><input name="txtfirstname" type="text" style="width:160px;" class="inputbox itemfont" id="txtfirstname" value="<%=rsrecset("firstname")%>">&nbsp;<span class="style2">*</span></td>
                                                        </tr>
                                                        <tr height="5px">
                                                            <td colspan="2">&nbsp;</td>
                                                        </tr>
                                                        <tr class="personalDetails">
                                                            <td width="160px">Service No:</td>
                                                            <td class="itemfont" width="200px"><input style="width:90px;" name="txtserviceno" type="text" class="inputbox itemfont" id="txtserviceno" value="<%=rsrecset("serviceno")%>">&nbsp;<span class="style2">*</span></td>
                                                        </tr>
                                                        <tr height="5px">
                                                            <td colspan="2">&nbsp;</td>
                                                        </tr>
                                                        <tr class="personalDetails">
                                                            <td width="160px">Rank:</td>
                                                            <td class="itemfont" width="200px">
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
                                                            <td width="160px">Gender:</td>
                                                            <td class="itemfont" width="200px">
                                                                <select class="inputbox itemfont" name="cmbGender" id="cmbGender" style="width:70px;">
                                                                    <option value=""></option>
                                                                    <option value="M" <%if rsRecSet("sex")="M" then response.write (" Selected")%>>Male</option>
                                                                    <option value="F" <%if rsRecSet("sex")="F" then response.write (" Selected")%>>Female</option>
                                                                </select>&nbsp;<span class="style2">*</span>
                                                            </td>
                                                        </tr>
                                                        <tr height="5px">
                                                            <td colspan="2">&nbsp;</td>
                                                        </tr>
                                                        <tr class="personalDetails" >
                                                            <td width="160px">Arrival Date:</td>
                                                            <td class="itemfont" width="200px">
                                                                <input name="txtarrival" type="text" id="txtarrival" class=" itemfont inputboxEdit"  style="Width:85px;" value ="<%=rsRecSet("ArrivalDate")%>" readonly onclick="calSet(this)">
                                                                &nbsp;<img src="images/cal.gif" alt="Calender" onclick="calSet(txtarrival)" style="cursor:hand;">&nbsp;<span class="style2">*</span>
                                                            </td>
                                                        </tr>
                                                        <tr height="5px">
                                                            <td colspan="2">&nbsp;</td>
                                                        </tr>
                                                        <tr class="personalDetails">
                                                            <td width="160px">Last OOA Date:</td>
                                                            <td class="itemfont" width="200px">
                                                                <input name="txtooa" type="text" id="txtooa" class=" itemfont inputboxEdit"  style="Width:85px;"  value ="<%=rsRecSet("lastOOA")%>" readonly onclick="calSet(this)">
                                                                &nbsp;<img src="images/cal.gif" alt="Calender" onclick="calSet(txtooa)" style="cursor:hand;">
                                                            </td>
                                                        </tr>
                                                        <tr height="5px">
                                                            <td colspan="2">&nbsp;</td>
                                                        </tr>
                                                        <tr class="personalDetails">
                                                            <td width="160px">Home Phone:</td>
                                                            <td class="itemfont" width="200px"><input style="width:125px;" name="txthphone" type="text" class="inputbox itemfont" id="txthphone" value="<%=rsrecset("homephone")%>"></td>
                                                        </tr>
                                                        <tr height="5px">
                                                            <td colspan="2">&nbsp;</td>
                                                        </tr>
                                                        <tr class="personalDetails">
                                                            <td width="160px">Town of Birth:</td>
                                                            <td class="itemfont" width="200px"><input style="width:125px;" name="txtpob" type="text" class="inputbox itemfont" id="txtpob" value="<%=rsrecset("pob")%>"></td>
                                                        </tr>
                                                        <tr height="5px">
                                                            <td colspan="2">&nbsp;</td>
                                                        </tr>
                                                        <tr class="personalDetails">
                                                            <td width="160px">Passport Issued By:</td>
                                                            <td class="itemfont" width="200px"><input style="width:125px;"  name="txtissueby" type="text" class="inputbox itemfont" id="txtissueby" value="<%=rsrecset("issueoffice")%>"></td>
                                                        </tr>
                                                        <tr height="5px">
                                                            <td colspan="2">&nbsp;</td>
                                                        </tr>
                                                        <tr class="personalDetails">
                                                            <td width="160px">Administrator:</td>
                                                            <td class="itemfont" width="200px">
																<%'if session("Administrator")=1 then%>
                                                                    <Select  class="inputbox itemfont" name="cbadmin" id="cbadmin" style="width:50px;">
                                                                        <option value=0 <%if rsRecSet("administrator")=False then response.write (" Selected")%>>No</option>
                                                                        <option value=1 <%if rsRecSet("administrator")=True then response.write (" Selected")%>>Yes</option>
                                                                    </Select>
                                                                <%'else%>
                                                                <!--
                                                                    <input name="txtadmin" type="text" class="inputbox itemfont" style="width:50px;" readonly value="<%'if rsRecSet("administrator")=True then %>Yes<%' else %>No<%' end if %>">
                                                                    <input name="cbadmin" type="hidden" value="<%'if rsRecSet("administrator")=True then response.write "1" else response.write "0" end if%>">
                                                                 -->
                                                                <%'end if%>
                                                            </td>
                                                    </tr>
                                                        <tr height="5px">
                                                            <td colspan="2">&nbsp;</td>
                                                        </tr>
                                                        <tr class="personalDetails">
                                                            <td width="160px">Welfare POC:</td>
                                                            <td class="itemfont" width="200px"><input style="width:160px;"  name="txtpoc" type="text" class="inputbox itemfont" id="txtpoc" value="<%=rsrecset("poc")%>"></td>
                                                        </tr>
                                                        <tr height="5px">
                                                            <td colspan="2">&nbsp;</td>
                                                        </tr>
                                                        <tr class="personalDetails">
                                                            <td width="160px" valign="top">Welfare Wishes:</td>
                                                            <td class="itemfont" width="200px"><textarea name="txtwwishes" rows="5" class="pickbox itemfont" id="txtwwishes" ><%=rsRecSet("welfarewishes")%></textarea></td>
                                                        </tr>
                                                        <tr height="5px">
                                                            <td colspan="2">&nbsp;</td>
                                                        </tr>
                                                        <tr class="personalDetails">
                                                            <td width="160px" valign="top">Notes:</td>
                                                            <td class="itemfont" width="200px"><textarea name="txtNotes" rows="5" class="pickbox itemfont" id="txtNotes" ><%=rsRecSet("notes")%></textarea></td>
                                                        </tr>
                                                        <tr height="5px">
                                                            <td colspan="2">&nbsp;</td>
                                                        </tr>
                                                        <tr class="personalDetails">
                                                            <td width="160px">Weapon No:</td>
                                                            <td class="itemfont" width="200px"><input name="txtWeaponNo" type="text" id="txtWeaponNo" style="width:160px" class="inputbox itemfont" value="<%= rsRecSet("weaponNo") %>"\></td>
                                                        </tr>
                                                        <tr height="5px">
                                                            <td colspan="2">&nbsp;</td>
                                                        </tr>
                                                        <tr class="personalDetails">
                                                            <td width="160px">Susat Required:</td>
                                                            <td class="itemfont" width="200px"><input name="chkSusat" type="checkbox" id="chkSusat" value="1" <% if rsRecSet("susat") = true then %>checked<% end if %>></td>
                                                        </tr>
                                                        <tr height="5px">
                                                            <td colspan="2">&nbsp;</td>
                                                        </tr>
                                                    </table>
                                                </td>
                                                
                                                <td class="toolbar" width="30px">&nbsp;</td>
                                                
                                                <td width="400px">
                                                    <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                                        <tr class="personalDetails">
                                                            <td width="160px">Surname:</td>
                                                            <td class="itemfont" width="200px"><input name="txtsurname" type="text" style="width:160px;" class="inputbox itemfont" id="txtsname2" value="<%=rsrecset("surname")%>">&nbsp;<span class="style2">*</span></td>
                                                        </tr>
                                                        <tr height="5px">
                                                            <td colspan="2">&nbsp;</td>
                                                        </tr>
                                                        <tr class="personalDetails">
                                                            <td width="160px">Known As:</td>
                                                            <td class="itemfont" width="200px"><input name="txtknownas" type="text" style="width:120px;" class="inputbox itemfont" id="txtknownas2" value="<%=rsrecset("knownas")%>"></td>
                                                        </tr>
                                                        <tr height="5px">
                                                            <td colspan="2">&nbsp;</td>
                                                        </tr>
                                                        <tr class="personalDetails">
                                                            <td width="160px">Trade:</td>
                                                            <td class="itemfont" width="200px">
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
                                                            <td width="160px">MES:</td>
                                                            <td class="itemfont" width="200px">
                                                                <select name="cmbmes" id="cmbmes" class="itemfont itemfont" style="width:90px;">
                                                                    <option value="">...Select...</option>
                                                                    <%do while not rsMES.eof %>
                                                                        <option value = "<%= rsMES("mesid") %>" <%if (rsMES("mesid") = rsRecSet("mesid")) then Response.Write("SELECTED") : Response.Write("")%> ><%= rsMES("description") %></option>
                                                                        <% rsMES.movenext
                                                                    loop%>
                                                                </select>
                                                            </td>
                                                        </tr>
                                                        <tr height="5px">
                                                            <td colspan="2">&nbsp;</td>
                                                        </tr>
                                                        <tr class="personalDetails">
                                                            <td width="160px">Posting Due Date:</td>
                                                            <td class="itemfont" width="200px">
                                                                <input name="txtposting" type="text" id="txtposting" class=" itemfont inputboxEdit"  style="Width:85px;"  value ="<%=rsRecSet("postingduedate")%>" readonly onclick="calSet(this)">	
                                                                &nbsp;<img src="images/cal.gif" alt="Calender" onclick="calSet(txtposting)" style="cursor:hand;">
                                                            </td>
                                                        </tr>
                                                        <tr height="5px">
                                                            <td colspan="2">&nbsp;</td>
                                                        </tr>
                                                        <tr class="personalDetails">
                                                            <td width="160px">Discharge Date:</td>
                                                            <td class="itemfont" width="200px">
                                                            	<input name="txtdischarge" type="text" id="txtdischarge" class=" itemfont inputboxEdit"  style="Width:85px;"  value ="<%=rsRecSet("dischargedate")%>" readonly onClick="calSet(this)">
                                                                &nbsp;<img src="images/cal.gif" alt="Calender" onclick="calSet(txtdischarge)" style="cursor:hand;">
                                                            </td>
                                                        </tr>
                                                        <tr height="5px">
                                                            <td colspan="2">&nbsp;</td>
                                                        </tr>
                                                        <tr class="personalDetails">
                                                            <td width="160px">Mobile:</td>
                                                            <td class="itemfont" width="200px"><input  style="width:125px;" name="txtmobile" type="text" class="inputbox itemfont" id="txtmobile2" value="<%=rsrecset("mobileno")%>"></td>
                                                        </tr>
                                                        <tr height="5px">
                                                            <td colspan="2">&nbsp;</td>
                                                        </tr>
                                                        <tr class="personalDetails">
                                                            <td width="160px">Work Phone:</td>
                                                            <td class="itemfont" width="200px"><input  style="width:125px;" name="txtWorkPhone" type="text" class="inputbox itemfont" id="txtWorkPhone" value="<%=rsrecset("workPhone")%>"></td>
                                                        </tr>
                                                        <tr height="5px">
                                                            <td colspan="2">&nbsp;</td>
                                                        </tr>
                                                        <tr class="personalDetails">
                                                            <td width="160px">Passport No:</td>
                                                            <td class="itemfont" width="200px"><input style="width:125px;"  name="txtpptno" type="text" class="inputbox itemfont" id="txtpptno" value="<%=rsrecset("passportno")%>"></td>
                                                        </tr>
                                                        <tr height="5px">
                                                            <td colspan="2">&nbsp;</td>
                                                        </tr>
                                                        <tr class="personalDetails">
                                                            <td width="160px">Passport Expiry Date:</td>
                                                            <td class="itemfont" width="200px">
                                                            	<input name="txtexpiry" type="text" id="txtexpiry" class=" itemfont inputboxEdit" style="Width:85px;" value="<%=rsRecSet("passportexpiry")%>" readonly onClick="calSet(this)">
                                                            	&nbsp;<img src="images/cal.gif" alt="Calender" onclick="calSet(txtexpiry)" style="cursor:hand;">
                                                            </td>
                                                        </tr>
                                                        <tr height="5px">
                                                            <td colspan="2">&nbsp;</td>
                                                        </tr>
                                                        <tr class="personalDetails">
                                                            <td width="160px">Welfare Handbook Issued:</td>
                                                            <td class="itemfont" width="200px">
                                                                <input name="txthandbook" type="text" id="txthandbook" class=" itemfont inputboxEdit"  style="Width:85px;"  value ="<%=rsRecSet("handbookissued")%>" readonly onclick="calSet(this)">	
                                                                &nbsp;<img src="images/cal.gif" alt="Calender" onclick="calSet(txthandbook)" style="cursor:hand;">
                                                            </td>
                                                        </tr>
                                                        <tr height="5px">
                                                            <td colspan="2">&nbsp;</td>
                                                        </tr>
                                                        <tr class="personalDetails">
                                                            <td width="160px">Date of Birth:</td>
                                                            <td class="itemfont" width="200px">
                                                                <input name="txtdob" type="text" id="txtdob" class=" itemfont inputboxEdit"  style="Width:85px;"  value ="<%= rsRecSet("dob")%>" readonly onClick="calSet(this)">
                                                                &nbsp;<img src="images/cal.gif" alt="Calender" onclick="calSet(txtdob)" style="cursor:hand;"><!--&nbsp;<span class="style2">*</span>-->
                                                            </td>
                                                        </tr>
                                                        <tr height="5px">
                                                            <td colspan="2">&nbsp;</td>
                                                        </tr>
                                                        <tr class="personalDetails">
                                                            <td valign=top>Photograph:</td>
                                                            <td height="200px" valign="top">
                                                                <%if cint(session("Administrator")) =1 then%>
                                                                    <input type = button value = "Upload Photo" onclick="javascript:win = window.open('heirarchyEditUploadedPhoto.asp?staffID=<%=rsRecSet.fields("staffID")%>','Upload_Photo','top=0,left=100,width=700,height=120,toolbar=0,menubar=0,scrollbars=0');" >
                                                                <%else%>
                                                                    Admin permissions required<br>to amend or upload image.
                                                                <%end if%>
                                                            </td>
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
			</td>
		</tr>
	</table>
</form>

</body>
</html>

<SCRIPT LANGUAGE="JavaScript">
function resetPW(){

      var delOK = false 
    
	  input_box = confirm("This will Reset the Staff Password to the Default setting\nDo you wish to continue?")
	  if(input_box==true) {
		    delOK = true;
	    }
    return delOK;


}
function checkThis()
{
	var txtfnm = document.frmDetails.txtfirstname.value;
	var txtsnm = document.frmDetails.txtsurname.value; 
	var txtsvn = document.frmDetails.txtserviceno.value;
	var txtkas = document.frmDetails.txtknownas.value;
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
    if (document.frmDetails.cmbRank.value == ""){
		errMsg += "Rank\n"
		error = true
		}   
	if(document.frmDetails.cmbGender.value == "") {
		errMsg += "Gender\n"
		error = true
		}  
	if(!txtarr.length > 0) {
		errMsg += "Arrival Date\n"
		error = true
		} 
    if(!txtsnm.length > 0) {
		errMsg += "Surname\n"
		error = true
		}
    if (document.frmDetails.cmbTrade.value == "") {
		errMsg += "Trade\n"
		error = true
		}
	/**
	if (document.frmDetails.txtdob.value == "") {
		errMsg += "Date of Birth\n"
		error = true
		}
	**/
	/* now check the dates are in order */
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
	  	   
	if(error == true)
	{
		alert(errMsg)
		return;	  		
	} 
	
	document.frmDetails.administrator.value=document.frmDetails.cbadmin.value;
    document.frmDetails.submit();  
}

</Script>
