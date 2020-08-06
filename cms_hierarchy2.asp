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


'
'if request("teamID")<>"" then
'	teamID=request("teamID")
'else
'	teamID=1
'end if
'teamID=session("teamID")


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
'strCommand = "spGetHierarchy2"

if request("hrcID")="" then
  intHrc=1
else
  intHrc= int(request("hrcID"))
end if

set objCmd = server.CreateObject("ADODB.Command")
set objPara = server.CreateObject("ADODB.Parameter")
objCmd.ActiveConnection = con
objCmd.CommandType = 4		

set objPara = objCmd.CreateParameter ("hrcID",3,1,5, intHrc)
objCmd.Parameters.Append objPara
objCmd.CommandText = "spGetHierarchy3"
set rsHrc = objCmd.Execute	'Execute CommandText when using "ADODB.Command" object

' temp till we get rid of teams
objCmd.CommandText = "spGetTeamID"
'ObjCmd.Parameters.Append ObjCmd.CreateParameter("@teamID", adInteger, adParamOutput, 4)
set objPara = objCmd.CreateParameter ("@teamID",3,2,4)
objCmd.Parameters.Append objPara
objCmd.Execute	
teamID=objCmd.Parameters("@teamID")

'response.write("HRC ID is " &intHRC & " * " & teamID)

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

.imgplus
{
    background-image:url("Images/plus2.png");
}

.imgminus
{
  background-image:url("Images/minus.png");	
}
.imgchild
{
  background-image:url("Images/logo.gif");
}

.imgstyle
{
	cursor:pointer;
	margin-right:3px;
	width:16px;
	height:10px;
}

.imgopen
{
	display:block;
}

.imgclosed
{
	display:none;
}

.menufont{color:#333;font-size:12px; text-decoration:none; }

</style>

</head>
<body style="margin-left:0;" onclick="checkPage();" onLoad="chk();" onResize="chk();">

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
										    do while not rsHrc.eof 
							                mLeft = 10 * rsHrc("hrclevel")
											'response.write ("Name is " & rsHrc("hrcName"))
											 'parentid=0
											 if rsHrc("hrcopen") = true then   ' This is the OPEN branch of the treeview
												if rsHrc("hrcChildren")= false then  ' here we are at the bottom level
												  hrcimg="src='Images/logo.gif'"
												  childlink="false"
												 else
											       hrcImg="src='Images/minus.png'"   ' here we're still working down the treeview
												   childlink="true"	
												 end if	
												imgopen="true"
												imgclass="imgopen"	
												if rsHrc("hrclevel") = 1  then  ' parent level for treeview
												  lvl1id = rsHrc("hrcid")
												end if
												parentid=rsHrc("hrcid")								 
											  elseif rsHrc("hrcChildren")= true then  ' This has children but is not on the open branch
											    hrcImg="src='Images/plus2.png'"	
												childlink="true"
												imgopen="false"
												' response.write ("parent is " & rsHrc("hrcparentid"))
												if rsHrc("hrclevel")> 1  then
												   if rsHrc("hrcparentid") = lvl1id or  rsHrc("hrcparentid") = parentid  then
												 	  imgclass="imgopen"	
													else	
													  imgclass="imgclosed"
													end if							 
												 else
												    imgclass="imgopen"
											     end if
											  else	
											    hrcimg="src='Images/logo.gif'"   ' here we are at the bottom of the treeview BUT not the open branch
												imgopen="false"
												childlink="false"
												if rsHrc("hrcparentid") = parentid then
												  	imgclass="imgopen"	
													'response.write("image open")
												 else
												    imgclass="imgclosed"
													'response.write("image closed")
											     end if
											  end if
											  
											  MyLink = "ManningTeamPersonnel.asp?RecID=" & rsHrc("hrcID") & "&fromPage=Hierarchy.asp"
											 %>
											<div class="menufont, <%=imgclass%>" id="<%=rsHRC("hrcID")%>-<%=rsHRC("hrcparentid")%>">
											   <img <%=hrcImg%> class="imgstyle" style='margin-left:<%=mLeft%>px;'  onClick="javascript:ToggleDisplay(this,<%=imgopen%>,<%=childlink%>)";>
                                              <a href="javascript:passLevels(<%=MyLink%>, 355 )" style="text-decoration:none; <% if rsHrc("hrcID")=intHrc then %> font-weight:bold; <%end if%>"> <%=rsHrc("hrcName")%> </a>
											</div>
							                <%rsHrc.MoveNext    
											   Loop%>
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
	mLeft = 15 * level

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

<script language="javascript" type="text/javascript">

function mouseClick()
{
	if(event.button == 2)
	{
		alert("you clicked right button");
	}
}

function ToggleDisplay(obj,imgopen,childlink)
{
	var img=obj;
	parObj=img.parentNode;
	src=img.src;
	hrckids=Boolean(childlink);
	hrcopen=Boolean(imgopen);
	
	//alert(hrckids + " * " + hrcopen);
	parid=parObj.id.split('-')[1];
	if(!hrckids){
		alert("No Kids - No Action " + parid);
		return;
	}
	else{
		if(hrcopen){
			alert("change image to plus");
			
		}
		else {
			alert("change image to minus");
		}
	}
	
	//document.getElementById(hrcID).style.display='block';
	parObj.nextSibling.style.display='block';
	
	/**
	document.getElementById("teamID").value=hrcID;
	document.frmDetails.action="cms_hierarchy2.asp?hrcID="+hrcID;
	alert("action is " + document.frmDetails.action);
	
	document.frmDetails.submit(); 
	**/
}
/**	
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
**/

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

   // alert("params are xoom=" + xoom + " * "  + valY + " * " + fromSearch + " * " + teamID);
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

    var teamID = document.getElementById('teamID').value;
    /**
	var strUserTree = document.getElementById('teamIDStr').value;
	var strUserTree = strUserTree.replace(strUserTree.split(',')[0]+',', '');
	var userTreeArr = strUserTree.split(',');
	var spanID = null;
	var btnID = null;
	**/
	// chk();
	//passLevels("HierarchyTeamTaskingOverview.asp?RecID="+userTreeArr[userTreeArr.length-1]+"&fromPage=Hierarchy.asp", userTreeArr[userTreeArr.length-1]);
	passLevels("HierarchyTeamTaskingOverview.asp?RecID="+teamID+"&fromPage=Hierarchy.asp");

    /**
	for(x = 0; x < userTreeArr.length-1; x++){
		spanID = document.getElementById("item-"+userTreeArr[x]).parentNode.id;
		btnID = spanID.replace('span-',"");
		//ToggleDisplay("My3TreeView"+btnID+"Btn", "My3TreeView"+btnID+"chlds");
	}
	**/
}

initOpen();


</script>

</body>
</html>