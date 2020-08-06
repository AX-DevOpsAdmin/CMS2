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
	strGoTo = "ManningTeamSearch.asp"   ' asp page to return to once record is deleted
else
	strGoTo = "AdminTeamList.asp"   ' asp page to return to once record is deleted
end if

strAction="Add"

dim teamsizecounter
teamsizecounter=0

dim TeamIn

set objCmd = server.CreateObject("ADODB.Command")
set objPara = server.CreateObject("ADODB.Parameter")
objCmd.ActiveConnection = con

objCmd.CommandText = "spListParents"	'Name of Stored Procedure'
objCmd.CommandType = 4				'Code for Stored Procedure

set rsParentList = objCmd.Execute	'Execute CommandText when using "ADODB.Command" object

Response.Write(rsparentlist("parentID"))
%>

<html>

<head> 

<!--#include file="Includes/IECompatability.inc"-->

<title><%= PageTitle %></title>
<link rel="stylesheet" type="text/css" href="Includes/AMDB.css" media="Screen"/>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
</head>
<body>
<form action="UpdateTeam.asp?strAction=<%=strAction%>&goTo=<%=strGoTo%>&fromPage=<%=strFrom%>" method="POST" name="frmDetails" >
	<input type=hidden name=recID value=<%=request("recID")%>>
	<table height="100%" cellspacing=0 cellPadding=0 width=100% border=0>
		<tr>
			<td>
				<!--#include file="Includes/Header.inc"-->
				<table cellSpacing=0 cellPadding=0 width=100% border=0 >
                    <tr style="font-size:10pt;" height=26px>
                        <td width=10><img style="margin-left:10px;" src="cms_icons/png/24x24/process.png" width="24" height="24"></td>
                        <td class="staticdatamenu"><font class="youAreHere">CMS Admin Menu / <strong>Add New Team</strong></font></td>
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
                                        	<tr>
												<td class=toolbar width=8></td>
                                                <td width=20><a href="javascript:checkThis();"><img class="imagelink" src="images/saveitem.gif"></A></td>
												<td class=toolbar valign="middle" >Save and Close</td><td class=titleseparator valign="middle" width=14 align="center">|</td>
												<td class=toolbar valign="middle" ><A class= itemfontlink href="<%=strGoTo%>">Back To List</A></td>
											</tr>
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
                                                <td valign="middle" width=2%>&nbsp;</td>
                                                <td valign="middle" width=13%>Unit:</td>
                                                <td valign="middle" width=85% class=itemfont><input class="itemfont" style="WIDTH: 340px" maxLength=300 name="txtDescription" value="<%if request("err") = "True" then%><%= request("description") %><%end if%>"><% if request("err") = "True" then %>&nbsp;<span class="style2">Already exists</span><% end if %></td>
                                            </tr>
                                            <tr class=columnheading height=22>
                                                <td valign="middle" width=2%>&nbsp;</td>
                                                <td valign="middle" width="13%">Parent Type:</td>
                                                <td valign="middle" width="85%" class=itemfont >
                                                    <Select Name=cmbTeamIn class="inputbox" id="cmbTeamIn" onchange="findParent();" style="width:100px;">
                                                    	<option value="">...Select</option>
                                                        <option value=0 <% if request("err") = "True" then %><% if request("tm") = 0 then %>selected<% end if %><% end if %>>Group</option>
                                                        <option value=1 <% if request("err") = "True" then %><% if request("tm") = 1 then %>selected<% end if %><% end if %>>Wing</option>
                                                        <option value=2 <% if request("err") = "True" then %><% if request("tm") = 2 then %>selected<% end if %><% end if %>>Sqn</option>
                                                        <option value=3 <% if request("err") = "True" then %><% if request("tm") = 3 then %>selected<% end if %><% end if %>>Flt</option>
                                                        <option value=4 <% if request("err") = "True" then %><% if request("tm") = 4 then %>selected<% end if %><% end if %>>Flt Team</option>
                                                        <option value=5 <% if request("err") = "True" then %><% if request("tm") = 5 then %>selected<% end if %><% end if %>>Another Team</option>
                                                    </Select>
                                              </td>
                                            </tr>
                                            <tr class=columnheading height=22>
                                                <td valign="middle" width=2%>&nbsp;</td>
                                                <td valign="middle" width="13%">Parent:</td>
                                                <td valign="middle" width="85%" class=itemfont >
                                                    <Select Name="cmbParentID" class="inputbox" id="cmbParentID" style="width:200px;">
                                                    </Select>
                                                    <Script language="Javascript">
                                                        findParent();
                                                    </Script>						
                                              </td>
                                            </tr>
                                            <tr class=columnheading height=22>
                                                <td valign="middle" width=2%>&nbsp;</td>
                                                <td valign="middle" width="13%">Team Size:</td>
                                                <td valign="middle" width="85%" class=itemfont>
                                                    <Select class="inputbox" Name=TeamSize>
                                                        <%do while teamSizeCounter <=50%>
                                                            <option value=<%=teamSizeCounter%> ><%=teamSizeCounter%></option>
                                        `					<%teamSizeCounter=teamSizeCounter+1
                                                        Loop%>
                                                    </Select>												
                                                </td>
                                            </tr>
                                            <tr class=columnheading height=22>
                                                <td valign="middle" width=2%>&nbsp;</td>
                                                <td valign="middle" width="13%">Team Weight:</td>
                                                <td valign="middle" width="85%" class=itemfont><INPUT class="itemfont" style="WIDTH: 25px" maxLength=3 name=Weight value="0" ></td>
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

<SCRIPT LANGUAGE="JavaScript">
var parentListArray = new Array ();

<%
arrayCount=0
do while not rsParentList.eof%>
	parentListArray[<%=arrayCount%>] = "<%=rsParentList("TeamIn")%>*<%=rsParentList("ParentID")%>*<%=rsParentList("Description")%>";
<%
	rsParentList.movenext
	arrayCount=arrayCount +1
Loop%>

function findParent()
{
	var tempcount = parentListArray.length
	var TeamInID = document.getElementById("cmbTeamIn").value;
	var errCheck = '<%=request("err")%>';
	var ty = '<%=request("ty")%>';
	var strSplit = "";
	
	document.getElementById("cmbParentID").length=0;
	document.getElementById("cmbParentID").options[0] = new Option ("...Select","");
	var counter = 1;
	
	for (i=0;i < parentListArray.length;i++)
	{
		strSplit = parentListArray[i].split("*");

		if (strSplit[0]==TeamInID)
		{
			document.getElementById("cmbParentID").options[counter] = new Option (strSplit[2],strSplit[1]);
			if(errCheck)
			{
				if(strSplit[1] == ty)
				{
					document.getElementById("cmbParentID").options[counter].selected = true;
				}
			}
			counter++;
		}
	}
}

function FilterParent()
{
	window.location="AdminTeamEdit.asp?recID=<%=request("recID")%>&Description=<%=Description%>&TeamIn=" + document.frmDetails.cmbTeamIn.value + "&ParentID=<%=cmbParentID%>&TeamSize=<%=TeamSize%>&TeamCP=<%=TeamCP%>&Refresh=1";
}

</Script>
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
