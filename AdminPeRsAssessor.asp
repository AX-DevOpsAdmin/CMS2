<!DOCTYPE HTML >

<!--#include file="Includes/security.inc"--> 
<!--#include file="Connection/Connection.inc"-->
<!--include file="Includes/checkmanager.inc"-->  
<!--include file="Includes/manageradmin.inc"-->  
<%

	'If user is not valid Authorisation Administrator then log them off
	If (session("authadmin") =0 or  session("authadmin") > 2 ) then
		Response.redirect("noaccess.asp")
	End If


set objCmd = server.CreateObject("ADODB.Command")
set objPara = server.CreateObject("ADODB.Parameter")
objCmd.ActiveConnection = con
objCmd.Activeconnection.cursorlocation = 3
objCmd.CommandType = 4		

objCmd.CommandText = "spPeRsDetail"
set objPara = objCmd.CreateParameter ("RecID",3,1,5, request("staffID"))
objCmd.Parameters.Append objPara
set rsRecSet = objCmd.Execute	'Execute CommandText when using "ADODB.Command" object'

objCmd.CommandText = "spAdminPersAuthsType"	
set objPara = objCmd.CreateParameter ("atpID",3,1,0, request("atpID"))
objCmd.Parameters.Append objPara
set rsAuths = objCmd.Execute	'Execute CommandText when using "ADODB.Command" object'

%>

<script type="text/javascript" src="calendar.js"></script>

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
-->
</style>

</head>
<body>
<form action="" method="POST" name="frmDetails">
	<input type=hidden name="staffID" id="staffID" value=<%=request("staffID")%>>
    <input type="hidden" name="ReturnTo" value="AdminPersAssessor.asp">
	
	<table border=0 cellpadding=0 cellspacing=0 width=100%>
      	<tr>
        	<td>
				<!--#include file="Includes/Header.inc"--> 
                <table cellSpacing=0 cellPadding=0 width=100% border=0 >
                    <tr style="font-size:10pt;" height=26px>
                        <td width=10><img style="margin-left:10px;" src="cms_icons/png/24x24/process.png" width="24" height="24"></td>
                        <td class="staticdatamenu"><font class="youAreHere">CMS Admin Menu / <strong>Authorisations</strong></font></td>
                    </tr>
                    <tr>
                    	<td colspan=2 class=titlearealine  height=1></td>
                    </tr>
                </table>
          
                  <!--<table width=100% height='<%'=session("heightIs")%>px' border=0 cellpadding=0 cellspacing=0> -->
                  <table style="height:900px;" width=100% height="328" border=0 cellpadding=0 cellspacing=0>       		   		
                     <tr valign=Top>
        	      		<td class="sidemenuwidth" background="Images/tableback.png"><!--#include file="Includes/authmenu.inc"--></td>
                    	<td width=16></td>
				  		<td align=left >
                        	<table border=0 cellpadding=0 cellspacing=0 width=100%>
                                <tr class=SectionHeader>
                                    <td>
                                        <%' if strManager = "1" then %>
                                            <table border=0 cellpadding=0 cellspacing=0 >
                                                <tr>
                                                    <td height="25px" class=toolbar width=7></td><td width=19><a class=itemfontlink  href="AdminPersAssessAdd.asp?staffID=<%=request("staffID")%>&atpID=<%=request("atpID")%>"><img class="imagelink" src="images/editgrid.gif"></A></td>
                                                    <td width="123" height="25px" valign="middle" class=toolbar >Add Assessment</td>
                                                    <td height="25px" class=titleseparator valign="middle" width=12 align="center">|</td>
                                                    
                                                    <td height="25px" width=19><a class=itemfontlink  href="AdminPersAuthRemove.asp?staffID=<%=request("staffID")%>&atpID=<%=request("atpID")%>&lvl=2"><img class="imagelink" src="images/delitem.gif"></A></td>
                                                    <td width="162" height="25px" valign="middle" class=toolbar >Remove Assessment</td>
                                                    <td height="25px" class=titleseparator valign="middle" width=10 align="center">|</td>
                                                    
                                                    <td height="25px" class=toolbar width=7></td><td width=26><a class=itemfontlink  href="AdminPersAuthLimitAdd.asp?staffID=<%=request("staffID")%>&atpID=<%=request("atpID")%>"><img class="imagelink" src="images/editgrid.gif"></A></td>
                                                    <td width="86" height="25px" valign="middle" class=toolbar >Add  Limits</td>
                                                    <td height="25px" class=titleseparator valign="middle" width=10 align="center">|</td>

                                                    <td height="25px" width=23><a class=itemfontlink  href="AdminPersAuthLimitDel.asp?staffID=<%=request("staffID")%>&atpID=<%=request("atpID")%>"><img class="imagelink" src="images/delitem.gif"></A></td>
                                                    <td width="116" height="25px" valign="middle" class=toolbar >Remove  Limits</td>
                                                    <td height="25px" class=titleseparator valign="middle" width=10 align="center">|</td>

                                                  <td height="25px" width=671><a class=itemfontlink  href="AdminPersAssessSelect.asp?staffID=<%=request("staffID")%>">Back </a></td>
                                                   
                                                </tr>
                                            </table>
                                        <%' end if %>
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
                                        </table>
                                        <table border=0 cellpadding=0 cellspacing=0 width=100%>
                            				<tr class=SectionHeader>
                                                <td width="2%" align="left" height="25px">&nbsp;</td>
                                                <td width="98%" align="left" height="25px" colspan=5>
                                                    <table border=0 cellpadding=0 cellspacing=0 width=100%>
                                                        <tr class="SectionHeader toolbar">
                                                            <td width="17%" align="left" height="25px">Summary of Assessments</td>
                                                            <td width="10%" align="center" height="25px">Valid From</td>
                                                            <td width="12%" align="center" height="25px">Valid To</td>
                                                            <td width="16%" align="center" height="25px">Authorisor</td>
                                                            <td width="7%" align="center" height="25px">Status</td>
                                                            <td width="7%" align="center" height="25px">Limitations</td>
                                                            <td width="26%" align="center" height="25px">&nbsp;</td>
                                                        </tr>
                                                        <tr>
                                                            <td colspan=8 height="22px">&nbsp;</td>
                                                        </tr>
														<% if rsAuths.recordcount > 0 then %>
                                                            <% do while not rsAuths.eof %>
                                                               <tr>
                                                                <% strAuthCode = rsAuths("authCode") %>
                                                                <% strValidFrom = rsAuths("startdate") %>
                                                                <% strValidTo = rsAuths("enddate") %>
                                                                <% strAuthorisor = rsAuths("Authorisor") %>
                                                                <%strAmberDate=strValidTo - 14 %>
                                                                <!-- Now check whether it's in still current 1=Out of Date 2=Amber 3=Current  -->
                                                                <% if date > strValidTo then strCurrent = 1 else if date >= strAmberDate and date <= strValidTo then strCurrent = 2  else if date >= strValidFrom and date < strAmberDate then strCurrent=3 else strCurrent=0 end if %>
                                                                <!-- Check for limitations but only on CURRENT/AMBER auths -->
                                                                <% strlim=0 %>
                                                                 <!-- Check to see if this Auth has limitations set and if so set the marker on the page so they can see it does  -->
                                                                <% if not IsNull(rsAuths("limit")) and strCurrent > 1 then strlim =1 end if %>
                                                                                   
                                                                <%'strAmberDate=strValidTo - 14 %>
                                                              
                                                                    <% if rsAuths("authCode") <> "" then %>
                                                                        <!--
                                                                        <%if strlim = 1 then %>                                                                        
                                                                            <td align="left" height="22px" class="toolbar" onClick="showlims(this, <%=rsRecSet("staffID")%>,<%=rsAuths("authID")%>);"><a class="itemfontlink" ><%=rsAuths("authCode")%></a></td>
                                                                         <% else %>
                                                                            <td align="left" height="22px" class=toolbar><%=strAuthCode%></td>
                                                                         <%end if %>
                                                                        -->
                                                                        <td align="left" height="22px" class=toolbar><%=strAuthCode%></td>
                                                                        <td align="center" height="22px" class=toolbar><%=formatDateTime(strValidFrom,2) %></td>
                                                                        <td align="center" height="22px" class=toolbar><%=formatDateTime(strValidTo,2) %></td>
                                                                        <td align="center" height="22px" class=toolbar><%=strAuthorisor%></td>
                                                                        <td align="center" height="22px">
                                                                            <%' if date > strValidTo then %>
                                                                            <% if strCurrent=1 then %>
                                                                                <img src="Images/red box.gif" alt="Out of Date" width="12" height="12">
                                                                            <%' elseif date >= strAmberDate and date <= strValidTo then %>
                                                                            <% elseif strCurrent=2 then %>
                                                                                <img src="Images/yellow box.gif" alt="Almost out of Date" width="12" height="12">
                                                                            <%' elseif date >= strValidFrom and date < strAmberDate then %>
                                                                            <% elseif strCurrent=3 then %>
                                                                                <img src="Images/green box.gif" alt="In Date" width="12" height="12">
                                                                            <% else %>
                                                                                &nbsp;
                                                                            <% end if %>
                                                                        </td>
                                                                         <% if strlim=1 then %>
                                                                           <td align="center" height="22px"><img src="Images/yes.gif" alt="Limitations" width="12" height="12"></td>
                                                                         <% else %>
                                                                            &nbsp;
                                                                         <% end if %>
                                                                         
                                                                    <%end if %>
                                        
                                                                    <% rsAuths.movenext %>
                                                                 
                                                                </tr>
                                                            <% loop %>
                                                        <% else %>
                                                            <tr>
                                                                <td colspan="8" height="22px" class=toolbar>None Held</td>
                                                            </tr>
                                                        <% end if %>
                                                        <tr>
                                                            <td colspan="8" height="22px">&nbsp;</td>
                                                        </tr>
                                                    </table>
                                				</td>
                            				</tr>
                            				<tr>
                                				<td colspan=7 class=titlearealine  height=1></td> 
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
windowWidth=200
windowHeight=200%>

<Div id="detailWindow" style="background-color:#f4f4f4;visibility:hidden;">
    <table border="0" cellpadding="0" cellspacing="0" align="right" width="100%">
        <tr class="SectionHeader">
            <td>
                <div id="detailWindowTitleBar" style="position:relative;left:7px;top:0px;width:100%;border-color:#7f9db9;"> 
                    <table border="0" cellpadding="0" cellspacing="0" align="right" width="100%">
                        <tr> 
                            <td id="windowName" class="itemfont"></td>
                            <td align="right" ><img src="images/windowCloseIcon.png" style="cursor:pointer;" onClick="javascript:closeThisWindow('detailWindow');"></td>
                        </tr>
                    </table>
                </div>
            </td>
        </tr>
        <tr>
            <td class="titlearealine" height="1"><img height="1" src="Images/blank.gif"></td> 
        </tr>            
        <tr>
            <td align="left" class="itemfont">
                <div id="innerDetailWindow" style="Overflow:auto;background-color:#f4f4f4;color:#000000;position:relative;height:100%;width:100%"> 
                    <table border="0" cellpadding="0" cellspacing="0" align="right" width="100%">
                        <tr class="itemfont"> 
                            <td>&nbsp;</td>
                        </tr>
                    </table>
                </div>
            </td>
        </tr>
    </table>
</Div>

</body>
</html>

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

function showlims(obj, staffID, authID)
{
	//alert(staffID + " * " + authID);
	var strvars='staffID=' + staffID+ '&' + 'authID='+authID;
	ajaxFunction('adminPersAuthLimsAjax.asp',strvars,'Authorisation Limititations',100,10,642,678);
}

function ajaxFunction(ajaxFile,vars,name,xPos,yPos,xHeight,xWidth,type,task)
{
	 //alert(ajaxFile + " * " + vars + " * " + type + " * " + task + " * "  + name + " * "  + " * " + xPos + " * " + yPos + " * " + xHeight + " * " + xWidth)
	var ajaxRequest;  // The variable that makes Ajax possible!
	vars = encodeURI(vars + '&' + type + '&' + task);   
	try
	{
        // Opera 8.0+, Firefox, Safari
        ajaxRequest = new XMLHttpRequest();
    }
	catch(e)
	{
    	// Internet Explorer Browsers
        try
		{
        	ajaxRequest = new ActiveXObject("Msxml2.XMLHTTP");
        }
		catch(e)
		{
        	try
			{
            	ajaxRequest = new ActiveXObject("Microsoft.XMLHTTP");
            }
			catch(e)
			{
            	// Something went wrong
            	alert("Your browser broke!");
            	return false;
            }
        }
    }
	
	xPos = (screen.width - xWidth) / 2 - 250
	yPos = (screen.height - xHeight) / 2 - 200 
	
    // Create a function that will receive data sent from the server
	ajaxRequest.onreadystatechange = function()
	{
		if(ajaxRequest.readyState == 4)
		{
			//alert("window is " + name + " * " + ajaxRequest.responseText + " * " + screen.height + " * " + xPos + " * " + yPos + " * " + xHeight + " * " + xWidth)
			populateDetailsWindow(name,ajaxRequest.responseText,xPos,yPos,xHeight,xWidth);
		}
	}
    ajaxRequest.open("POST", ajaxFile, true);
    ajaxRequest.setRequestHeader("Content-type","application/x-www-form-urlencoded");
    ajaxRequest.send(vars); 
}

function populateDetailsWindow(name,text,xPos,yPos,xHeight,xWidth)
{
	document.getElementById('windowName').innerHTML = name;
	document.getElementById('innerDetailWindow').innerHTML = text;
	
	
	var detailWindow = document.getElementById('detailWindow');
	detailWindow.style.visibility = "visible";
	detailWindow.style.width = xWidth + "px";

	//detailWindow.style.width = '400px';
	detailWindow.style.top = (document.body.parentNode.scrollTop+80)+'px';
	detailWindow.style.left = (document.body.parentNode.scrollLeft)+'px';
	//alert(document.getElementById('unitPlanner').scrollTop)
	
	//alert(document.body.parentNode.scrollTop)
	
	
	/*var detailWindow = document.getElementById('detailWindow');
	detailWindow.style.visibility = "visible";
	detailWindow.style.position = "absolute";
	detailWindow.style.left = xPos + "px";
	detailWindow.style.top = 0 + "px";
	detailWindow.style.height = xHeight + "px";
	detailWindow.style.width = xWidth + "px";
	detailWindow.style.zIndex = "100"*/
	//alert("Pos is " + xPos + " * " + yPos);
	
	document.getElementById('detailWindowTitleBar').style.width = xWidth - 16 + "px";
}

function closeThisWindow(thisWindow)
{
	document.getElementById(thisWindow).style.visibility = "hidden";
}

</Script>
