<!DOCTYPE HTML >

<!--#include file="Includes/security.inc"--> 
<!--#include file="Includes/checkadmin.asp"-->
<!--#include file="Connection/Connection.inc"-->

<%
dim strAction
dim strFrom
dim strGoTo

strFrom=request("fromPage")
if strFrom = "Manning" then
	strGoTo = "ManningTeamDetail.asp"   ' asp page to return to once record is deleted
else
	strGoTo = "AdminTeamDetail.asp"   ' asp page to return to once record is deleted
end if

strAction="Update"

set objCmd = server.CreateObject("ADODB.Command")
set objPara = server.CreateObject("ADODB.Parameter")
objCmd.ActiveConnection = con
objCmd.CommandText = "spTeamDetail"	'Name of Stored Procedure
objCmd.CommandType = 4				'Code for Stored Procedure
set objPara = objCmd.CreateParameter ("TeamID",3,1,5, request("RecID"))
objCmd.Parameters.Append objPara
set rsRecSet = objCmd.Execute	'Execute CommandText when using "ADODB.Command" object

for x = 1 to objCmd.parameters.count
	objCmd.parameters.delete(0)
next

strCommand = "spListParents"
objCmd.CommandText = strCommand
objCmd.CommandType = 4		
set rsParentList = objCmd.Execute	'Execute CommandText when using "ADODB.Command" object
%>

<SCRIPT LANGUAGE="JavaScript">

var ParentArray = new Array();
<%
Counter=0
do while not rsParentList.eof%>
ParentArray[<%=Counter%>] = "<%=rsParentList("TeamIn")%>*<%=rsParentList("ParentID")%>*<%=rsParentList("Description")%>";
<%
Counter=Counter+1
rsParentList.movenext
loop
rsParentList.movefirst
%>

function changeParent() {
	var TeamIn = document.getElementById("cmbTeamIn").value;
	document.getElementById("cmbParentID").length=0;
	var counter =0;
	var strSplit = "";
	
	for (i=0;i<ParentArray.length;i++){
		strSplit = ParentArray[i].split("*");
		if (strSplit[0]==TeamIn)
		{
			document.frmDetails.ParentID.options[counter] = new Option(strSplit[2],strSplit[0] + "*" + strSplit[1]);
			alert(document.frmDetails.ParentID.value);
			counter=counter+1;
		}
	}
}

function findParent(){
	var TeamInID = document.getElementById("cmbTeamIn").value;
	
	document.getElementById("cmbParentID").length=0;
	document.getElementById("cmbParentID").options[0] = new Option ("...Select","");
	var counter = 1;
	var strSplit = "";
	
	for (i=0;i < ParentArray.length;i++)
	{
		strSplit = ParentArray[i].split("*");
		if (strSplit[0]==TeamInID)
		{
			document.getElementById("cmbParentID").options[counter] = new Option (strSplit[2],strSplit[1]);
			counter++;
		}
	}
}

</Script>

<html>

<head>

<!--#include file="Includes/IECompatability.inc"-->
 <title><%= PageTitle %></title>
<link rel="stylesheet" type="text/css" href="Includes/AMDB.css" media="Screen"/>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">

</head>
<body>
<form   action="UpdateTeam.asp?strAction=<%=strAction%>&goTo=<%=strGoTo%>" method="post" name="frmDetails" onSubmit="javascript:return(CheckForm());">
<input type=hidden name=recID value=<%=request("recID")%>>
  <table  height="100%" cellspacing=0 cellPadding=0 width=100% border=0>
    <tr>
      <td>
        <!--#include file="Includes/Header.inc"-->
		<table cellSpacing=0 cellPadding=0 width=100% border=0 >
                    <tr style="font-size:10pt;" height=26px>
                        <td width=10><img style="margin-left:10px;" src="cms_icons/png/24x24/process.png" width="24" height="24"></td>
                        <td class="staticdatamenu"><font class="youAreHere">CMS Admin Menu / <strong>Edit Team</strong></font></td>
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
					<table border=0 cellpadding=0 cellspacing=0 >
						<td class=toolbar width=8></td><td width=20><a href="javascript:checkThis();"><img class="imagelink" src="images/saveitem.gif"></A></td>
						<td class=toolbar valign="middle" >Save and Close</td><td class=titleseparator valign="middle" width=14 align="center">|</td>
						<td class=toolbar valign="middle" ><A class= itemfontlink href="AdminTeamDetail.asp?recID=<%=request("recID")%>">Back</A></td>											
					</table>
				  </td>
				</tr>
				<tr>
				  <td>
					<table width=100% border=0 cellpadding=0 cellspacing=0>
					  <tr height=16>
						<td></td>
					  </tr>
					  <tr class=columnheading height=22>
					    <td valign="middle" width=2%></td>
						<td valign="middle" width=13%>Unit:</td>
						<td valign="middle" width=85% class=itemfont><input class="itemfont" style="WIDTH: 340px" maxLength=300 name=txtDescription Value="<%=rsRecSet("Description")%>"></td>
					  </tr>
					  <tr class=columnheading height=22>
			            <td valign="middle" width=2%></td>
						<td valign="middle" width="13%">Parent Type:</td>
						<td valign="middle" width="85%" class=itemfont >
						<Select class="inputbox" Name=cmbTeamIn onchange="findParent()" style="width:100px;">
                            <option value="">...Select</option>
                            <option value=0 <%if rsRecSet("TeamIn")=0 then %>selected<%end if%>>Group</option>
                            <option value=1 <%if rsRecSet("TeamIn")=1 then %>selected<%end if%>>Wing</option>
                            <option value=2 <%if rsRecSet("TeamIn")=2 then %>selected<%end if%>>Squadron</option>
                            <option value=3 <%if rsRecSet("TeamIn")=3 then %>selected<%end if%>>Flight</option>
                            <option value=4 <%if rsRecSet("TeamIn")=4 then %>selected<%end if%>>Flight Team</option>
                            <option value=5 <%if rsRecSet("TeamIn")=5 then %>selected<%end if%>>Team</option>
						</Select>
						</td>
					  </tr>
					  <tr class=columnheading height=22>
			            <td valign="middle" width=2%></td>
						<td valign="middle" width="13%">Parent:</td>
						<td valign="middle" width="85%" class=itemfont>
						<Select  class="inputbox" Name=cmbParentID style="width:200px;">
                        <option value="">...Select</option>
						<%Do while not rsParentList.eof%>
						<%if rsParentList("TeamIn") = rsRecSet("TeamIn") then%>
						<option value=<%=rsParentList("ParentID")%> <%if rsRecSet("ParentID")=rsParentList("ParentID") then response.write (" Selected")%>><%=rsParentList("description")%></option>
						<%End if%>
						<%rsParentList.MoveNext
						Loop%>
						</Select>
						</td>
					  </tr>
					  <tr class=columnheading height=22>
			            <td valign="middle" width=2%></td>
						<td valign="middle" width="13%">Team Size:</td>
						<td valign="middle" width="85%" class=itemfont>
						<Select  class="inputbox" Name=TeamSize>
						<%counter=0
						Do while counter <=50%>						
						<option value=<%=counter%> <%if int(rsRecSet("TeamSize"))=int(counter) then response.write (" Selected")%>><%=counter%></option>						
						<%counter=counter+1
						Loop%>
						</Select>												
						</td>
					  </tr>
					  <tr class=columnheading height=22>
			            <td valign="middle" width=2%></td>
						<td valign="middle" width="13%">Team Weight:</td>
						<td valign="middle" width="85%" class=itemfont ><INPUT class="itemfont" style="WIDTH: 25px" maxLength=3 name=Weight Value="<%=rsRecSet("Weight")%>"></td>
					  </tr>					  
					  <tr height=16>
						<td></td>
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

function checkThis()
{
	//This function renoves any leading or trailing spaces from a string
	String.prototype.killWhiteSpace = function()
	{
		return this.replace(/\s/g, '');
	};

	var errMsg = "Please provide/correct the following:\n\n";
	var error = false;
	  
	var Team = document.frmDetails.txtDescription.value;
	Team = Team.killWhiteSpace(); 
	var Type = document.frmDetails.cmbTeamIn.value;
	Type = Type.killWhiteSpace(); 
	var Parent = document.frmDetails.cmbParentID.value;
	Parent = Parent.killWhiteSpace(); 
	var Weight = document.frmDetails.Weight.value;
	var re = /[a-z,A-Z\^,£<>$":;{}\[\]\*\.+\_=~#@?\\\/%\'!¬`¦&]/g;
	
	/* make sure they have entered comments for the next stage */
	if(Team == "")
	{
		errMsg += "Team\n"
		error = true;
	}

	if(Type == "")
	{
		errMsg += "Parent Type\n"
		error = true;
	}
	
	if(Parent == "")
	{
		errMsg += "Parent\n"
		error = true;
	}
	
	if(Weight == "")
	{
		errMsg += "Team Weight\n"
		error = true;
	}
	
	if(re.test(Weight))
	{
		errMsg += "Team Weight - Numeric characters only";
		error = true;
	}

	if(error == true)
	{
		alert(errMsg)
		return;	  		
	} 
	
    document.frmDetails.submit();  
}

</Script>
