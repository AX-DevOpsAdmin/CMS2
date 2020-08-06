<!--DOCTYPE HTML-->

<!--#include file="Includes/security.inc"-->
<!--#include file="Connection/Connection.inc"-->

<%

'response.write ("Search is " & request("persSearch"))

if request("persSearch") = "" then
	persSearch = 0
else
	persSearch = request("persSearch")
end if
'
'response.write ("Search here is " &  request("persSearch"))

' get screen height - use for table height calculation 
'if request("myHeight1") = "" then  
%>
	<script language="JScript" >
		/*var myHeight = screen.availHeight - 235; //document.documentElement.clientHeight - 138;
		window.location = "cms_hierarchy.asp?myHeight1="+myHeight+"&persSearch=<%'= persSearch %>";*/
	</script>
<%
'end if 


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

myhrc= int (session("hrcID"))
' This is the record of the hierarchy we want to see - from tblHierarchy
' it is EITHER the one for the CURRENT user OR we have clicked an element in the Hierarchy menu
if request("hrcID")="" then
  intHrc=1
else
  intHrc= int(request("hrcID"))
end if
'response.write("HRC ID is " &intHRC & " * " & myhrc)

set objCmd = server.CreateObject("ADODB.Command")
set objPara = server.CreateObject("ADODB.Parameter")
objCmd.ActiveConnection = con
objCmd.CommandType = 4		

set objPara = objCmd.CreateParameter ("nodeID",3,1,5, nodeID)
objCmd.Parameters.Append objPara
set objPara = objCmd.CreateParameter ("hrcID",3,1,5, intHrc)
objCmd.Parameters.Append objPara
objCmd.CommandText = "spGetHierarchy3"
set rsHrc = objCmd.Execute	'Execute CommandText when using "ADODB.Command" object

appCount=0

if  session("authorisor") = 1 then
    
	for x = 1 to objCmd.parameters.count
		objCmd.parameters.delete(0)
	next

	ObjCmd.CommandText = "spGetAuthCount"
	ObjCmd.Parameters.Append ObjCmd.CreateParameter("@staffID", 3,1,0, session("staffID"))
	ObjCmd.Parameters.Append ObjCmd.CreateParameter("@rtn", 3,2,0)
	ObjCmd.Parameters.Append ObjCmd.CreateParameter("@hist", 3,2,0)
	ObjCmd.execute
	
	appCount = ObjCmd.Parameters("@rtn")
	histCount= ObjCmd.Parameters("@hist")
	
'	approveCnt = 0
'	if isNull(ObjCmd.Parameters("@rtn")) = false then
'		appCount = ObjCmd.Parameters("@rtn")
'	end if
end if

' temp till we get rid of teams
'objCmd.CommandText = "spGetTeamID"
'set objPara = objCmd.CreateParameter ("@teamID",3,2,4)
'objCmd.Parameters.Append objPara
'objCmd.Execute	
'teamID=objCmd.Parameters("@teamID")

%>

<script type="text/javascript" src="calendar.js"></script>
<html>
  <head>
    
    <!--<meta http-equiv="X-UA-Compatible" content="IE=7" />-->
    
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
  
  <body style="margin-left:0;" onLoad="chk();  <%if session("authorisor") = 1 and persSearch = 0 then%> loadApproved(<%=appCount%>,<%=histCount%>, <%=session("staffID")%>); <%end if%>;" onResize="chk();">

    <form  action="" method="POST" name="frmDetails" id="frmDetails" >
        <input name="HiddenDate" id="HiddenDate" type="hidden">
       <!-- <input name="teamID" value=<%'=teamID%> type="hidden" >-->
        <input name="hrcID" id="hrcID" value=<%=intHrc%> type="hidden" >
         <input id="persSearch" name="persSearch" value=<%=persSearch%> type="hidden" >
        <input name="thisIframe" id="thisIframe" type="hidden" value="">
        <input name="fromSearch" id="fromSearch" type="hidden" value="0">
        <!--<input id="teamIDStr" name="teamIDStr" type="hidden" value="<%'=session("teamIDStr")%>">-->
    
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
                                                    <td>Sub Units:</td>
                                                    <td><input type="checkbox" name="allTeams" id="allTeams"></td>
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
                                                ' This loop goes through the tblHierarchy records and puts them in the relevant order and state on the
                                                ' Hierarchy side menu. Initially it will open up the tree branch down to the element that current logged-on
                                                ' user belongs to. All other branches will be open to the FIRST LEVEL only. The user can then open/close
                                                ' the branches by clicking the + or - icons. Clicking on the element name will display the details of all
                                                ' posts/personnel in that element in the calendat tasking view
                                                lastlevel= 0
                                                do while not rsHrc.eof 
												'response.write ("level is ") & " " & rsHrc("hrclevel") & " " & rsHrc("lastlevel")
                                                mLeft = 10 * rsHrc("hrclevel")
                                                 if rsHrc("hrcopen") = true then   ' This is the OPEN branch of the treeview
                                                    if rsHrc("hrcChildren")= false then  ' here we are at the bottom level
                                                      hrcimg="src='Images/logo.gif'"
                                                      childlink="false"
                                                     else
													   if rsHrc("hrclevel") = rsHrc("lastlevel") then  ' we're at the bottom of the chosen level so don't open levels below
													     hrcImg="src='Images/plus2.png'"	
													   else
                                                         hrcImg="src='Images/minus.png'"   ' here we're still working down the treeview
													   end if 
                                                       childlink="true"	
                                                     end if	
                                                     'imgopen="true"
													 if rsHrc("hrclevel")> rsHrc("lastlevel") then  ' we're at the bottom of the chosen level so don't open levels below
													   imgclass="imgclosed"
													 else
                                                       imgclass="imgopen"
													 end if
													 	
                                                    if rsHrc("hrclevel") = 1  then  ' parent level for treeview
                                                      lvl1id = rsHrc("hrcid")
                                                    end if
                                                    parentid=rsHrc("hrcid")								 
                                                 elseif rsHrc("hrcChildren")= true then  ' This has children but is not on the open branch
                                                    hrcImg="src='Images/plus2.png'"	
                                                    childlink="true"
                                                    'imgopen="false"
                                                    'response.write ("parent is " & rsHrc("hrcparentid"))
                                                    if rsHrc("hrclevel")> 1  then
                                                       if rsHrc("hrclevel")< rsHrc("lastlevel") and (rsHrc("hrcparentid") = lvl1id or  rsHrc("hrcparentid") = parentid)  then
                                                          imgclass="imgopen"	
                                                        else	
                                                          imgclass="imgclosed"
                                                        end if							 
                                                     else
													  'response.write ("image open ")
                                                        imgclass="imgopen"
                                                     end if
                                                 else	' this has no children 
                                                    hrcimg="src='Images/logo.gif'"   ' here we are at the bottom of the treeview 
                                                    'imgopen="false"
													'response.write ("HRC is " & rsHRC("hrcname"))
                                                    childlink="false"
													'we are either at the first level OR in the open branch but ABOVE the target branch
                                                    if rsHrc("hrclevel") = 1 or (rsHrc("hrcparentid") = parentid and rsHrc("hrclevel")< rsHrc("lastlevel")) then
													'if rsHrc("hrclevel")< rsHrc("lastlevel") then
                                                        imgclass="imgopen"	
                                                     else
                                                        imgclass="imgclosed"
                                                     end if
                                                  end if
                                                  
                                                  MyLink = "HierarchyTaskingView.asp?hrcID="& rsHRC("hrcID") 

                                                  ' Here we have started a new level so close all the divs
                                                  ' from the previous level
                                                  if rsHrc("hrclevel") < lastlevel then
                                                     do while lastlevel > rsHrc("hrclevel") %>
                                                       </div>
                                                  <%   lastlevel=lastlevel - 1
                                                       Loop
                                                  end if
                                                  %>
                                             
                                                  <div class="menufont, <%=imgclass%>" id="<%=rsHRC("hrcID")%>-<%=rsHRC("hrcparentid")%>" >
                                                   <img <%=hrcImg%> class="imgstyle" style='margin-left:<%=mLeft%>px;'  onClick="javascript:ToggleDisplay(this,<%=childlink%>)";>
                                                   <%' if IsNull(rsHrc("hrcTeamID")) then %>
                                                    <!--<a href="#" style="text-decoration:none;"> <%'=rsHrc("hrcName")%> </a>-->
                                                   <%' else %>
                                                     <a id="a-<%=rsHrc("hrcID")%>" href="javascript:passLevels('<%=MyLink%>','<%=rsHrc("hrcID")%>',0, this)" style="text-decoration:none; <% if rsHrc("hrcID")=intHrc then %> font-weight:bold; <%end if%> <% if rsHrc("hrcID")=myHrc then %> background-color:#FFF; color:#009;<%end if%>" ><%=rsHrc("hrcName")%> </a>
                                                   <%'end if %> 
                                                 <% if childlink="false" then %>
                                                     </div>
                                                 <%end if
                                                   lastlevel= rsHrc("hrclevel")
                                                  %>
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
                                          <!--  <td class="toolbar"><iframe scrolling="yes" frameBorder="0" src="manningTeamPersonnel.asp?RecID=1&persSearch=<%'if request("persSearch") then response.write request("persSearch") else response.write "0" end if%>" name="teamIframe" id="teamIframe"></iframe></td>-->
                                             <td class="toolbar"><iframe scrolling="yes" frameBorder="0" src="" name="teamIframe" id="teamIframe"></iframe></td>                                       
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
    
    <!-- This is the Calendar Date pop up form -->
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

  </body>
</html>

<script language="javascript" type="text/javascript">

function mouseClick()
{
	if(event.button == 2)
	{
		alert("you clicked right button");
	}
}

// This function Opens and Closes the Menu Branch options
function ToggleDisplay(obj,childlink)
{
	  
	  
	var img=obj;
	var parObj=img.parentNode;
	var src=img.src;
	var hrckids=Boolean(childlink);
	var parimg=src.substr(src.lastIndexOf('/') + 1);
	var hrcopen=Boolean(parimg=="minus.png");
	
	var nodes = parObj.childNodes;

    //alert("toggle display " + parimg );
	
	if(!hrckids){     // Its a childnode so do nothing
		return;
	}
	else{
		if(hrcopen){  // it's an open menu branch so close it
			img.src="Images/plus2.png";
	        for (i=0; i<nodes.length; i++){
				if (nodes[i].tagName=='DIV'){
				 nodes[i].style.display='none';
				 }
			}
		}
		else {    // it's a closed menu branch so open it
			img.src="Images/minus.png";
	        for (i=0; i<nodes.length; i++){
				if (nodes[i].tagName=='DIV'){
				 nodes[i].style.display='block';
				 }
		    }
	    }
	}
}

var imgobj=null;
function passLevels(xoom, hrcID, persSearch)
{
    //alert("URL is " + xoom + " * " + persSearch);
	var currobj= document.getElementById("a-"+hrcID);
	var frmDetails = document.getElementById('frmDetails');
	frmDetails.persSearch.value=persSearch;
	
	if(imgobj != null){
		//alert ("old object is" + imgobj);
		imgobj.style.fontWeight="normal";
	}

	if(currobj){
	  //alert ("new object is" + currobj.id);
	  imgobj=currobj;
	  imgobj.style.fontWeight="bold";
	}
	
	frmDetails.hrcID.value = hrcID;
	//var persSearch=frmDetails.persSearch.value
	
	var thisDate = frmDetails.startDate.value;
	 
	var allTeams = 0;
	if(frmDetails.allTeams.checked == true)
	{
		allTeams = 1;
	}
	
	//alert("here we are " + persSearch + " * " + xoom);
	var fromSearch= frmDetails.fromSearch.value;
	frames["teamIframe"].location.href = xoom+"&thisDate="+thisDate + "&fromSearch=" + fromSearch + "&allTeams=" + allTeams +"&persSearch="+persSearch;

	startTimer();
}

function refreshIframeAfterDateSelect(thisIframe)
{
	var frmDetails = document.getElementById('frmDetails');
	//var teamID = frmDetails.teamID.value;
	var hrcID = frmDetails.hrcID.value;
	var thisDate = frmDetails.startDate.value;
   // alert("hrc is " + hrcID + " * " + frmDetails.name + " * " + thisIframe );
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
	frames["teamIframe"].location.href = thisIframe + "?hrcID=" + hrcID + "&fromSearch=" + fromSearch + "&thisDate="+ thisDate + "&allTeams=" + allTeams;

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

function initOpen(persSearch){
	
	//alert("Open " + persSearch);
    var hrcID = document.getElementById('hrcID').value;
    passLevels("HierarchyTaskingView.asp?hrcID="+hrcID, hrcID,persSearch);
	/**
	alert("Open");
	if(persSearch)==0{
		passLevels("HierarchyPersonnelSearch.asp");
	}
	else
	{
	  passLevels("HierarchyTaskingView.asp?hrcID="+hrcID, hrcID);
	{
		**/
}

function loadApproved(appCount, histCount, staffID){
	
	//alert("Auth count is " + appCount + " History count is " + histCount);
	if(parseInt(appCount) > 0){
		var s = ""

		if(appCount > 1){
			s = "'s";
		}
		var notification = document.getElementById('notification');
		var notifCount = document.getElementById('notifCount');
		
		/**		
		notification.onmouseover = function(){notification.title='You have '+appCount+' Authorisations awaiting.'; }
		notification.onclick = function(){window.location = 'authorise.asp';}
        **/
		notification.style.display = 'inline';
		notifCount.innerHTML = appCount;	
		notifCount.onmouseover = function(){notifCount.title='You have '+appCount+' Authorisation' + s + ' awaiting.';}
		//notifCount.onclick = function(){window.location = 'cms_hierarchy3.asp?persSearch=2'}
	}
	else if(parseInt(histCount) > 0){
		var notification = document.getElementById('notification');
		var notifCount = document.getElementById('notifCount');
		notification.style.display = 'inline';
		notifCount.style.display = 'none';
	}
}



initOpen(<%=persSearch%>);


</script>

