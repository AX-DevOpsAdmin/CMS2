<!--<!DOCTYPE HTML >-->

<!--#include file="Includes/security.inc"-->
<!--#include file="Connection/Connection.inc"-->

<%
if request("persSearch") = "" then
	persSearch = 0
else
	persSearch = 1
end if

' get screen height - use for table height calculation 
'if request("myHeight1") = "" then  
%>
	<script language="JScript" >
		/*var myHeight = screen.availHeight - 235; //document.documentElement.clientHeight - 138;
		window.location = "cms_hierarchy.asp?myHeight1="+myHeight+"&persSearch=<%'= persSearch %>";*/
	</script>
<%
'end if 

if request("teamID")<>"" then
	teamID=request("teamID")
else
	teamID=1
end if

todayDate = formatdatetime(date(),2)
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

if len(splitDate(0)) < 2 then splitDate(0)= "0" & splitDate(0)
}
newTodaydate = formatdatetime(date(),2) 

strPage = "Hierarchy"
'##########################################################################################################################
'a new recordset is declared for every level in the heirarchy and used further down.
'there is a 6 level heirarchy in place for this example
'##########################################################################################################################
set rsQuery1 = server.CreateObject("ADODB.RecordSet")
rsQuery1.ActiveConnection = con
rsQuery1.CursorType = 3
rsQuery1.CursorLocation = 2
rsQuery1.LockType = 1
set rsQuery2 = server.CreateObject("ADODB.RecordSet")
rsQuery2.ActiveConnection = con
rsQuery2.CursorType = 3
rsQuery2.CursorLocation = 2
rsQuery2.LockType = 1
set rsQuery3 = server.CreateObject("ADODB.RecordSet")
rsQuery3.ActiveConnection = con
rsQuery3.CursorType = 3
rsQuery3.CursorLocation = 2
rsQuery3.LockType = 1
set rsQuery4 = server.CreateObject("ADODB.RecordSet")
rsQuery4.ActiveConnection = con
rsQuery4.CursorType = 3
rsQuery4.CursorLocation = 2
rsQuery4.LockType = 1
set rsQuery5 = server.CreateObject("ADODB.RecordSet")
rsQuery5.ActiveConnection = con
rsQuery5.CursorType = 3
rsQuery5.CursorLocation = 2
rsQuery5.LockType = 1
set rsQuery6 = server.CreateObject("ADODB.RecordSet")
rsQuery6.ActiveConnection = con
rsQuery6.CursorType = 3
rsQuery6.CursorLocation = 2
rsQuery6.LockType = 1


set rsChild = server.CreateObject("ADODB.RecordSet")
rsChild.ActiveConnection = con
rsChild.CursorType = 3
rsChild.CursorLocation = 2
rsChild.LockType = 1
%>

<script type="text/javascript" src="calendar.js"></script>



<html>
<head>

<!--#include file="Includes/IECompatability.inc"-->


<title><%=pageTitle%></title>
<link rel="stylesheet" type="text/css" href="Includes/AMDB.css" media="Screen"/>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<style type="text/css">
body
{
	overflow: hidden;
}
</style>

</head>
<body style="margin-left:0;" onclick="checkPage();" onLoad="chk();" onResize="chk();">

<script language="javascript" type="text/javascript">

function mouseClick()
{
	if(event.button == 2)
	{
		alert("you clicked right button");
	}
}
	
function ToggleDisplay(oButton2, oItems2)
{
	if((document.getElementById(oItems2).style.display == "") || (document.getElementById(oItems2).style.display == "none"))
	{
		document.getElementById(oItems2).style.display = "block";
		document.getElementById(oButton2).src = "Images/minus.png";
		var TreeOpen = document.getElementById("openfield").value
		document.getElementById("openfield").value = TreeOpen +"~@-"+oButton2+","+oItems2
	}
	else
	{
		document.getElementById(oItems2).style.display = "none";
		document.getElementById(oButton2).src = "Images/plus2.png";
		var TreeOpen = document.getElementById("openfield").value
		document.getElementById("openfield").value = TreeOpen.replace("~@-"+oButton2+","+oItems2,"")
	}
	return false;
}


function HideDisplay(oItems)
{
	
	document.getElementById(oItems).style.display = "none";
}

function ShowDisplay(oItems)
{
	document.getElementById(oItems).style.display = "block" ;
}

function openBranches()
{
	if(document.getElementById("openfield2").value == "")
	{
	}
	else
	{
		var LoadedNames = document.getElementById("openfield2").value;
		LoadedNames = String(LoadedNames);
		LoadedNames = LoadedNames.split("~@-");
		var set2 = '';
		
		for(var loop=0; loop <LoadedNames.length; loop++)
		{
			if(LoadedNames[loop]!="")
			{
				set2 = LoadedNames[loop];
				set2 = set2.split(",");
				ToggleDisplay(set2[0],set2[1]);
			}
		}
	}
}

function OverBackgroundChange(itemID){
    document.getElementById('itemID').className = 'testTabHover';
}

function OutBackgroundChange(itemID){
	document.getElementById('itemID').className ='testTabUnselected';
}

</Script>

<form  action="" method="POST" name="frmDetails" id="frmDetails" >
	<input name="HiddenDate" type="hidden">
	<input name="teamID" value=<%=teamID%> type="hidden" >
	<input name="thisIframe" type="hidden" value="manningTeamPersonnel.asp">
	<input name="fromSearch" type="hidden" value="0">
    <input id="teamIDStr" name="teamIDStr" type="hidden" value="<%=session("teamIDStr")%>">

	<table cellspacing="0" cellPadding="0" width="100%" border="0">
		<tr>
			<td>
				<!--#include file="Includes/Header.inc"--> 
				<table cellSpacing="0" cellPadding="0" width="100%" border="0" >
					<tr style="font-size:10pt;" height="26px">
						<td colspan="3" style="border-bottom:1px solid #CCC;">
							<table cellSpacing="0" cellPadding="0" border="0" >
								<tr>
	       							<td width="10px">&nbsp;</td><td id="crumbTrail"><A title="" href="index.asp" class="itemfontlinksmall" >Home</A> > <font class="youAreHere"><%if request("persSearch") <> 1 then %>Personnel <% else %> Search <% end if %></font></td>
								</tr>
							</table>
						</td>
					</tr>
      				<tr valign="Top">
          				<td width="224" class="HierarchyWidth">
                        <div id="sideDiv" style=" overflow-y:scroll; overflow-x:auto; background:#efefef; width:224px; padding-left:4px;">
							<table width="202px" border="0" cellpadding="0" cellspacing="0">
								<tr>   
									<td id="iframeStatus"></td>
								</tr>
								<tr>
									<td>
                                    	<table width="202px" border="0"  cellspacing="0">
                                            <tr>
                                            	<td colspan="2">&nbsp;</td>
                                            </tr>                                       
                                        	<tr class="columnheading">
                                            	<td>Search Date:</td>
                                            	<td valign="top">
                                                	<input name="startDate" type="text" id="startDate" class="inputbox itemfont" style="Width:75px;"  value =<%if request("startDate") <>"" then%>"<%=request("startDate")%>"<%else%>"<%=newTodaydate%>"<%end if%> readonly onClick="calSet(this)">&nbsp;
                                                	<img src="Images/cal.gif" alt="Calender" onClick="calSet(startDate)" align="absmiddle" style="cursor: hand;">
                                                </td>
                                        	</tr>
                                        	<tr class="columnheading" >
                                            	<td>Sub teams:</td>
                                            	<td><input type="checkbox" name="allTeams"></td>
                                        	</tr>
                                            <tr>
                                            	<td colspan="2">&nbsp;</td>
                                            </tr>                                       
                                    	</table>
									</td>
								</tr>
								<tr>
									<td align="left" nowrap>
                                    	
		    							<div class="LeftNavZ" >			  
										<%
                                            '###############################################################################################################################
                                            '#												TREEVIEW EXPLANATION														   #
                                            '# Declares the roleID for the present role as the itemID, this guarantees uniqueness for the Item id's value, and ensures     #
                                            '# that when the treeview is built, it will mean that the treebranch's value wont cause other branches to open by accident	   #
                                            '# the itemname is the role, which is the value which will be displayed as the label for the branch							   #
                                            '# rankLevel, since my rank levels are set by user, it uses that ranklevel, and subtracts one to use to select a specific case #
                                            '# from the treeview call, and displays at a certain level, this could just as easily be replaced with 0 for the first, 	   #
                                            '# and 1 for the next branch, and so on.																					   #
                                            '# IsOpn specifies whether the branch level shall be open or not															   #
                                            '# the DO WHILE loop checks where its complete or not, as to display a red or green image for complete, or not				   #
                                            '# MyLink is created while in this loop, which is the destination URL for the treeview heirarchy to get to once clicked		   #
                                            '# isParent, runs a DO WHILE loop and checks to see if the current item has anyone reporting to them on the current form	   #
                                            '# if so it creates a tree branch for them																					   #
                                            '# call treeview, calls the Sub declared at the end of the page to create the structure for the treeview					   #
                                            '# call WRITEFOOT then closes the branch, which can be found further down the page											   #
                                            '###############################################################################################################################
              
											'Declares the first query to run, and selects all records where the reports to value is set to 0 for the particular form
											strSQL = "SELECT tblgroup.grpID, tblgroup.description AS Grp FROM tblGroup"
											'strSQL = "SELECT dbo.tblTeam.teamID, ParentID, dbo.tblTeam.description AS TeamDesc, dbo.tblgroup.description, '0' FROM dbo.tblTeam INNER JOIN dbo.tblgroup ON dbo.tblTeam.ParentID = dbo.tblgroup.grpID WHERE dbo.tblTeam.teamIn = 0"
											rsQuery1.Source = strSQL
											rsQuery1.Open()
											If rsQuery1.RecordCount > 0 Then
												Do While NOT rsQuery1.EOF
													TreeName = "My3TreeView"
													parentID = rsQuery1("grpID")
													ItemName = rsQuery1("Grp")
													itemID = "Grp" & parentID
													Level = "0"
													IsOpn = True
				  
													' first find out if this has a TEAM attached to it - cos if it does we want to be able to CLICK it
													strSql = "SELECT TOP 1 tblTeam.teamID FROM tblTeam where tblTeam.teamIn = '" & 0 & "' AND tblTeam.parentID = '" & parentID & "'"
													rsChild.Source = strSQL
													rsChild.open()
													MyLink = ""
													if rsChild.RecordCount > 0 then
														MyLink = "ManningTeamPersonnel.asp?RecID=" & rsChild("teamID") & "&fromPage=Hierarchy.asp"
														teamID = rsChild("teamID")
													END if
													rsChild.close
				  
													' now check if its a parent ie: it has subordinate hierarchical children eg: Wing/Sqn, Sqn/Flight etc
													strSql = "SELECT TOP 1 tblWing.wingID, tblWing.description as wing FROM tblWing where tblWing.grpID = '" & rsQuery1("grpID") & "'"	
													rsChild.Source = strSQL
													rsChild.open()
													if rsChild.RecordCount > 0 then
														isParent = True
													else
														IsParent = false
													END if
													rsChild.close

													call treeview(Treename,itemID,ItemName,Level,IsParent, IsOpn, teamID)
													
													' now get the wing teams
													ValRoleID = rsQuery1("grpID")
													'rsQuery2.Source = "SELECT tblTeam.teamID, tblTeam.description as wing FROM tblTeam where tblTeam.teamIn = '" & 0 &"' AND tblTeam.parentID = '" & ValRoleID & "'"
													rsQuery2.Source = "SELECT tblWing.wingID, tblWing.description as wing FROM tblWing where tblWing.grpID = '" & ValRoleID & "'"				 
													rsQuery2.Open()
													If rsQuery2.RecordCount > 0 Then
														Do While NOT rsQuery2.EOF
															TreeName = "My3TreeView"
															parentID = rsQuery2("wingID")
															ItemName = rsQuery2("wing")
															itemID = "Wing" & parentID
															level = "1"
															IsOpn = false
															
															' first find out if this has a TEAM attached to it - cos if it does we want to be able to CLICK it
															strSql = "SELECT TOP 1 tblTeam.teamID FROM tblTeam where tblTeam.teamIn = '" & 1 & "' AND tblTeam.parentID = '" & parentID & "'"
															rsChild.Source = strSQL
															rsChild.open()
															MyLink = ""
															if rsChild.RecordCount > 0 then
																MyLink = "ManningTeamPersonnel.asp?RecID=" & rsChild("teamID") & "&fromPage=Hierarchy.asp"
																teamID = rsChild("teamID")
															END if
															rsChild.close
															
															' now check if its a parent ie: it has subordinate hierarchical children eg: Wing/Sqn, Sqn/Flight etc
															strSql = "SELECT TOP 1 tblsquadron.sqnID, tblsquadron.description as sqn FROM tblsquadron where tblsquadron.wingID = '" & rsQuery2("wingID") & "'"	
															rsChild.Source = strSQL
															rsChild.open()
															if rsChild.RecordCount > 0 then
																isParent = True
															else
																IsParent = false
															END if
															rsChild.close
															
															call treeview(Treename,itemID,ItemName,Level,IsParent, IsOpn, teamID)

															' now the squadron teams 
															ValRoleID = rsQuery2("wingID")
															rsQuery3.Source = "SELECT tblsquadron.sqnID, tblsquadron.description as sqn FROM tblsquadron where tblsquadron.wingID = '" & ValRoleID & "'   order by tblsquadron.description "	
															'rsQuery3.Source = "SELECT tblTeam.teamID, tblTeam.description as sqn FROM tblTeam where tblTeam.teamIn = '" & 2 & "' AND tblTeam.parentID = '" & ValRoleID & "'"
															rsQuery3.Open()
															If rsQuery3.RecordCount > 0 Then
																Do While NOT rsQuery3.EOF
																	TreeName = "My3TreeView"
																	parentID = rsQuery3("sqnID")
																	ItemName = rsQuery3("sqn")
																	itemID = "sqn" & parentID
																	level = "2"
																	IsOpn = False
																	
																	' first find out if this has a TEAM attached to it - cos if it does we want to be able to CLICK it
																	strSql = "SELECT TOP 1 tblTeam.teamID FROM tblTeam where tblTeam.teamIn = '" & 2 & "' AND tblTeam.parentID = '" & parentID & "'"
																	rsChild.Source = strSQL
																	rsChild.open()
																	MyLink = ""
																	if rsChild.RecordCount > 0 then
																		MyLink = "ManningTeamPersonnel.asp?RecID=" & rsChild("teamID") & "&fromPage=Hierarchy.asp"
																		teamID = rsChild("teamID")
																	END if
																	rsChild.close
				  
																	' now check if its a parent ie: it has subordinate hierarchical children eg: Wing/Sqn, Sqn/Flight etc
																	strSql = "SELECT TOP 1 tblFlight.fltID, tblFlight.description as flight FROM tblFlight where tblFlight.sqnID ='" & rsQuery3("sqnID") & "'"	
																	rsChild.Source = strSQL
																	rsChild.open()
																	if rsChild.RecordCount > 0 then
																		isParent = True
																	else
																		IsParent = false
																	END if
																	rsChild.close
																	
																	call treeview(Treename,itemID,ItemName,Level,IsParent, IsOpn,teamID)
					 
																	' now the Flight teams 
																	ValRoleID = rsQuery3("sqnID")
																	'rsQuery4.Source = "SELECT tblTeam.teamID, tblTeam.description as flight FROM tblTeam where tblTeam.teamIn = '" & 2 & "' AND tblTeam.parentID = '" & ValRoleID & "'  order by tblTeam.description "
																	rsQuery4.Source = "SELECT tblFlight.fltID, tblFlight.description as flight FROM tblFlight where tblFlight.sqnID = '" & ValRoleID & "'  order by tblFlight.description "	
																	rsQuery4.Open()
																	If rsQuery4.RecordCount > 0 Then
																		Do While NOT rsQuery4.EOF
																			TreeName = "My3TreeView"
																			parentID = rsQuery4("fltID")
																			ItemName = rsQuery4("flight")
																			itemID = "Flt" & parentID
																			level = "3"
																			IsOpn = False
																							 
																			' first find out if this has a TEAM attached to it - cos if it does we want to be able to CLICK it
																			strSql = "SELECT TOP 1 tblTeam.teamID FROM tblTeam where tblTeam.teamIn = '" & 3 & "' AND tblTeam.parentID = '" & parentID & "'"
																			rsChild.Source = strSQL
																			rsChild.open()
																			MyLink = ""
																			if rsChild.RecordCount > 0 then
																				MyLink = "ManningTeamPersonnel.asp?RecID=" & rsChild("teamID") & "&fromPage=Hierarchy.asp"
																				teamID = rsChild("teamID")
																				ValRoleID = rsChild("teamID")
																			END if
																			rsChild.close
				  
																			' now check if its a parent ie: it has subordinate hierarchical children eg: Wing/Sqn, Sqn/Flight etc
																			strSql = "SELECT TOP 1 tblTeam.teamID FROM tblTeam where tblTeam.teamIn = '"& 4 &"' AND tblTeam.parentID ='" & ValRoleID & "'"	
																			rsChild.Source = strSQL
																			rsChild.open()
																			if rsChild.RecordCount > 0 then
																				isParent = True
																			else
																				IsParent = false
																			END if
																			
																			rsChild.close

																			'***************************************************************************************
																			' rsChild.Source = "SELECT tblTeam.teamID, tblTeam.description as Team FROM tblTeam where tblTeam.teamIn = '"& 3 &"' AND tblTeam.parentID = '" & parentID& "'"
																			' rsChild.open()
																			' MyLink=""
																			' if rsChild.RecordCount > 0 then
																			'   isParent = True
																			'   MyLink = "ManningTeamPersonnel.asp?RecID=" & rsChild("teamID") & "&fromPage=Hierarchy.asp"
																			'   ValRoleID = rsChild("teamID")
																			' else
																			'   isParent = false
																			'   ValRoleID = ""
																			' END if
																			' rsChild.close
																			'*********************************************************************************************************
																			
																			call treeview(Treename,itemID,ItemName,Level,IsParent, IsOpn,teamID)
					 
																			' now the Teams of the Flights 
																			'ValRoleID = rsQuery4("fltID")
																			rsQuery5.Source = "SELECT tblTeam.teamID, tblTeam.description as team FROM tblTeam where tblTeam.teamIn = '"& 4 &"' AND tblTeam.parentID = '" & ValRoleID & "' order by tblTeam.description "
																			rsQuery5.Open()
																			If rsQuery5.RecordCount > 0 Then
																				Do While NOT rsQuery5.EOF
																					MyLink = "ManningTeamPersonnel.asp?RecID=" & rsQuery5("teamID") & "&fromPage=Hierarchy.asp"
																					teamID = rsQuery5("teamID")
																					TreeName = "My3TreeView"
																					parentID = rsQuery5("teamID")
																					ItemName = rsQuery5("team")
																					itemID = "team" & parentID
																					level = "4"
																					IsOpn = False
																					rsChild.Source = "SELECT TOP 1 tblTeam.teamID FROM tblTeam where tblTeam.teamIn = '"& 5 &"' AND tblTeam.parentID = '" & parentID& "'"
																					rsChild.open()
																					if rsChild.RecordCount > 0 then
																						isParent = True
																					else
																						isParent = false
																					END if
																					
																					rsChild.close
																					
																					call treeview(Treename,itemID,ItemName,Level,IsParent, IsOpn,teamID)
					 
																					' now the Teams of the Teams 
																					ValRoleID = rsQuery5("teamID")
																					rsQuery6.Source = "SELECT tblTeam.teamID, tblTeam.description as tteam FROM tblTeam where tblTeam.teamIn = '"& 5 &"' AND tblTeam.parentID = '" & ValRoleID & "' order by tblTeam.description "
																					rsQuery6.Open()
																					If rsQuery6.RecordCount > 0 Then
																						Do While NOT rsQuery6.EOF
																							MyLink = "ManningTeamPersonnel.asp?RecID=" & rsQuery6("teamID") & "&fromPage=Hierarchy.asp"    
																							teamID = rsQuery6("teamID") 
																							TreeName = "My3TreeView"
																							parentID = rsQuery6("teamID")
																							ItemName = rsQuery6("tteam")
																							itemID = "tt" & parentID
																							level = "5"
																							IsOpn = False
																							rsChild.Source = "SELECT TOP 1 tblTeam.teamID FROM tblTeam where tblTeam.teamIn = '"& 5 &"' AND tblTeam.parentID = '" & parentID& "'"
																							rsChild.open()
																							if rsChild.RecordCount > 0 then
																								isParent = True
																							else
																								isParent = false
																							END if
																							
																							rsChild.close
																							
																							call treeview(Treename,itemID,ItemName,Level,IsParent, IsOpn,teamID)

																							WRITEFOOT
																							rsQuery6.MoveNext
																						Loop
																					END IF
																					rsQuery6.close()
				
																					WRITEFOOT
																					rsQuery5.MoveNext
																				Loop
																			END IF
																			rsQuery5.close()
				
																			WRITEFOOT
																			rsQuery4.movenext
																		loop
																	END IF
																	rsQuery4.close()
				
																	WRITEFOOT
																	rsQuery3.MoveNext
																Loop
															END IF 'rs4 for rs5
															rsQuery3.close()
				
				
															WRITEFOOT
															rsQuery2.MoveNext
														Loop
													END IF 'rs3 for rs4
													rsQuery2.close()
			   
													WRITEFOOT
													rsQuery1.MoveNext
												Loop
											END IF 'rs2 for rs3
											rsQuery1.close()
										%>
                                        
		    							</div>
                                        
									</td>
                                   
								</tr>
							</table>
                            </div>
                            
						</td>
						
						<td align="left">
							<div id="iframeDiv" style="filter:alpha(opacity=200);">
								<table border="0" cellpadding="0" cellspacing="0">
									<tr>
										<td class="toolbar"><iframe scrolling="yes" frameBorder="0" src="manningTeamPersonnel.asp?RecID=1&persSearch=<%if request("persSearch") then response.write request("persSearch") else response.write "0" end if%>" name="teamIframe" id="teamIframe"></iframe></td>
									</tr>
								</table>
							</div>
						</td>
					</tr>
				</table>
			</td>
		</tr>
	</table>
</form>

<div id="statusBar" name="TaskList" style="visibility:hidden;position:absolute;top:424px;left:700px;">
	<div>
        <table border="0" cellpadding="0" cellspacing="0">
            <tr valign="center">
                <td align="center"><img border="0" src="Images/loading...gif"></td>
            </tr>
        </table>
	</div>
</div>

<form name="frmopened" id="frmopened" method="get">
	<input type="hidden" name="openfield" id="openfield" size="100" value=""/>
	<input type="hidden" name="openfield2" id="openfield2" size="100" value="<%=Session("openfield")%>"/>
</form>




<%
sub WRITEFOOT
response.write "</DIV>"
end sub
%>
<%
'*********************************
'TREEVIEW SUBS
'*********************************
Sub treeview(Treename,ItemID,ItemName,Level,IsParent, IsOpn, teamID)

'###############################################################################################################################
'# if further levels are added, further cases must be added to draw out the next tree level down							   #
'# Add 18 to the previous Width, eg. WIDTH=342, next width will be WIDTH=360												   #
'# currently the level is stopped at 20 and set to 20 as we only want there to be 20, but if more are required then set this   #
'# to the largest level, or comment it out completely																		   #
'###############################################################################################################################

	' Set the margin Left of each image to be 15px * its level in the tree.
	mLeft = 10 * level

	'If IsParent then put a plus sign else put a blank space
	If IsParent then

		If IsOpn then
			Response.Write "<img src='Images/minus.png' style='cursor:pointer; margin-left:"&mLeft&"px; margin-right:3px;' width='16' height='10' id='" & TreeName & ItemID & "Btn' onclick='javascript:ToggleDisplay(""" & TreeName & ItemID & "Btn"", """ & TreeName & ItemID & "chlds"");' >"
		Else
			Response.Write "<img src='Images/plus2.png' style='cursor:pointer; margin-left:"&mLeft&"px; margin-right:3px;' width='16' height='10' id='" & TreeName & ItemID & "Btn' onclick='javascript:ToggleDisplay(""" & TreeName & ItemID & "Btn"", """ & TreeName & ItemID & "chlds"");' >"
		End If

	Else
		If Level = 0 then
			Response.Write "<img style='cursor:pointer; margin-left:"&mLeft&"px' SRC='Images/nosign2.png' width='12' height='10' border='0'>"
		Else
			Response.Write "<img style='cursor:pointer; margin-left:"&mLeft&"px' SRC='Images/logo.gif' width='16' height='16' border='0'>"
		End If
	End if
		
	Response.Write "<font>" 
	
	If Level = 0 then 
		Response.Write "<b><span id='span-"&ItemID&"' ><a id='item-"&teamID&"' style='text-decoration:none; ' href=""javascript:passLevels('" & MyLink & "','" & teamID & "')""><font class='menufont' >" & ItemName & "</a></span></b>"
	else 
		Response.Write "<span id='span-"&ItemID&"' ><a id='item-"&teamID&"'  style='text-decoration:none; ' href=""javascript:passLevels('" & MyLink & "','" & teamID & "')""><font class='menufont'>" & ItemName & "</a></span>"
	end if

	Response.Write "</font>"
	Response.Write "<br>"
	
	'Always add DIV because WriteFoot() will close it
	Response.Write "<div id='" & TreeName & ItemID & "chlds'>"
	
	If IsOpn then
		
		Response.Write "<script language='javascript'>ShowDisplay('" & TreeName & ItemID & "chlds');</script>"
	Else
		Response.Write "<script language='javascript'>HideDisplay('" & TreeName & ItemID & "chlds');</script>"
	End If

end sub

sub writefoot
	Response.Write "</div>" '&vbcrlf
end sub%>

<form name="frmRon2">
    <div id="PopUpwindow2" class="PopUp">
        <table border="0" cellpadding="0" cellspacing="0" width="100%"  >
            <tr height="22">
                <td class="MenuStyleParent" colspan="5" align="center"><div id="Title"></div></td>
            </tr>
            <tr>
                <td colspan="3" height="30px">&nbsp;</td>
            </tr>
            <tr class=columnheading>
                <td valign="middle" height="30px" width="2%">
                <td colspan="2" valign="middle" height="22px" width="98%"><div id="Note"></div></td>
            </tr>
            <tr>
                <td colspan="3" height="22px">&nbsp;</td>
            </tr>
            <tr class=columnheading>
                <td valign="middle" height="30px" width="2%"></td>
                <td valign="middle" height="30px" width="30%">Expiry Date:</td>
                <td valign="middle" height="30px" width="68%" class="itemfont"> 
                    <input name="ExpirtDate" type="text" id="ExpiryDate" class=" itemfontEdit inputboxEdit" style="Width:85px;"  value ="<%=newTodaydate%>" readonly onClick="calSet(this)">&nbsp;
                    <img src="Images/cal.gif" alt="Calender" onClick="calSet(ExpiryDate)" align="absmiddle" style="cursor:hand;">
                </td>
            </tr>
            <tr>
                <td colspan="3" height="22px">&nbsp;</td>
            </tr>
            <tr>
                <td height="30px" align="center" colspan="3"><Input class="StandardButton" Type="Button" style="width:60px;" Value="OK" onClick="javascript:populateDateArray('DateAttained');"></td>
            </tr>
            <tr>
                <td height="30px" colspan="3">&nbsp;</td>
            </tr>
        </table>
    </div>
</form>

<script language="javascript">

function passLevels(xoom,teamID)
{
	var frmDetails = document.getElementById('frmDetails');
	var valY = document.getElementById("openfield").value;
	var thisDate = frmDetails.startDate.value;
	var allTeams = 0;
	if(frmDetails.allTeams.checked == true)
	{
		allTeams = 1;
	}
	
	var fromSearch= frmDetails.fromSearch.value;
	frmDetails.teamID.value = teamID;

	frames["teamIframe"].location.href = xoom+"&openfield="+valY+"&thisDate="+thisDate + "&fromSearch=" + fromSearch + "&allTeams=" + allTeams;

	startTimer();
}

function refreshIframeAfterDateSelect(thisIframe)
{
	var frmDetails = document.getElementById('frmDetails');
	var teamID = frmDetails.teamID.value;
	var thisDate = frmDetails.startDate.value;
   
	if(frmDetails.allTeams.checked == true)
	{
		allTeams = 1
	}
	else
	{
		allTeams = 0
	}
	var fromSearch = frmDetails.fromSearch.value;
	frmDetails.fromSearch.value = 0;
	frames["teamIframe"].location.href = thisIframe + "?RecID=" + teamID + "&fromSearch=" + fromSearch + "&thisDate="+ thisDate + "&allTeams=" + allTeams;

	startTimer();
}

var timer = 0;

function startTimer()
{
	
	document.getElementById('iframeDiv').style.visibility = "Hidden";

	document.getElementById('statusBar').style.visibility="Visible";

	
	timer = setTimeout("startTimer()",1);

	if(window.teamIframe.document.readyState == "complete")
	{
		stoptimer();
	}
}


function stoptimer()
{
	document.getElementById('iframeDiv').style.visibility = "Visible";
	document.getElementById('statusBar').style.visibility="Hidden";
	clearTimeout(timer);
}


function checkPage()
{
	if(window.teamIframe.TaskList)
	{
		var taskListState = window.teamIframe.TaskList.style.visibility;
		
		if(taskListState == "visible" && window.teamIframe.justOpened == 0)
		{
			window.teamIframe.TaskList.style.visibility="Hidden";
		}
	}	
	var justOpened = 0;
}

function chk()
{
	var viewportHeight; // Variable for Height of viewable window in browser
	var viewportWidth; // Variable for Width of viewable window in browser
	
	if(typeof window.innerHeight != 'undefined'){ 
		// Populate vieport Heights and Widths for non ie browsers
		viewportHeight = window.innerHeight;
		viewportWidth = window.innerWidth;
	}
	else{
		// Populate vieport Heights and Widths for ie8+ browsers 
		viewportHeight = Math.max(document.body.offsetHeight, document.body.clientHeight)
		viewportWidth = Math.max(document.body.offsetWidth, document.body.clientWidth)
	}
	
	//Works out what the height of the side menu has to be
	var side_div = document.getElementById("sideDiv");
	side_div.style.height = (viewportHeight - elemPosition(side_div).top) + "px";

	//Works out what the height and width of the main area has to be
	var main_div = document.getElementById("teamIframe");
	main_div.style.height = (viewportHeight - elemPosition(main_div).top) + "px";
	main_div.style.width = (viewportWidth - elemPosition(main_div).left) + "px";
}

function elemPosition(elem){
	
	var parentNodeObj = "";
	var elemLeft = 0;
	var elemTop = 0;
	var elemRight = 0;
	var elemBottom = 0;
	if(typeof(elem) == "object"){
		//This is an object
		parentNodeObj = elem;
		parentNodeObj2 = elem;		
	} 
	else if(typeof(elem) == "string"){
		//This is a string so assume id
		parentNodeObj = document.getElementById(elem);
		parentNodeObj2 = document.getElementById(elem);
	}
	while (parentNodeObj){
		elemLeft += parentNodeObj.offsetLeft;
		elemTop += parentNodeObj.offsetTop;
		parentNodeObj = parentNodeObj.offsetParent;
	}
	elemRight = elemLeft + parentNodeObj2.offsetWidth;
	elemBottom = elemTop + parentNodeObj2.offsetHeight;	
	return{
		top:elemTop,
		right:elemRight,
		bottom:elemBottom,
		left:elemLeft		
	};
}

function initOpen(){

	var strUserTree = document.getElementById('teamIDStr').value;
	
	//alert(strUserTree);
	
	var strUserTree = strUserTree.replace(strUserTree.split(',')[0]+',', '');
	var userTreeArr = strUserTree.split(',');
	var spanID = null;
	var btnID = null;
	chk();
	passLevels("HierarchyTeamTaskingOverview.asp?RecID="+userTreeArr[userTreeArr.length-1]+"&fromPage=Hierarchy.asp",userTreeArr[userTreeArr.length-1]);

	for(x = 0; x < userTreeArr.length-1; x++){
		spanID = document.getElementById("item-"+userTreeArr[x]).parentNode.id;
		btnID = spanID.replace('span-',"");
		
		//alert("span is " + spanID + " button is " + btnID + " * " + x);
		
		ToggleDisplay("My3TreeView"+btnID+"Btn", "My3TreeView"+btnID+"chlds");
	}
}

initOpen();


</script>

</body>
</html>