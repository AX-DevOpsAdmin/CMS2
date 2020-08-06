<!DOCTYPE HTML >

<!--#include file="Includes/security.inc"--> 
<!--#include file="Connection/Connection.inc"-->

<%
	set objCmd = server.CreateObject("ADODB.Command")
	set objPara = server.CreateObject("ADODB.Parameter")
	objCmd.ActiveConnection = con
	objCmd.Activeconnection.cursorlocation = 3
	objCmd.CommandType = 4		
   
    staffID=session("staffID")
	strdate=  request("startDate")
	
	strCommand = "spPeRsDetailSummary"
	objCmd.CommandText = strCommand
	
	set objPara = objCmd.CreateParameter ("RecID",3,1,5, staffID)
	objCmd.Parameters.Append objPara
	set objPara = objCmd.CreateParameter ("startDate",200,1,20, strdate)
	objCmd.Parameters.Append objPara
	set rsRecSet = objCmd.execute	'Execute CommandText when using "ADODB.Command" object'
	
	for x = 1 to objCmd.parameters.count
		objCmd.parameters.delete(0)
	next
	
	strCommand = "spGetAuthsWaiting"
	objCmd.CommandText = strCommand
	set objPara = objCmd.CreateParameter ("nodeID", 200,1,50, nodeID)
	objCmd.Parameters.Append objPara
	set objPara = objCmd.CreateParameter ("RecID",3,1,0, staffID)
	objCmd.Parameters.Append objPara
	
	set rsAuths = objCmd.Execute
	
     ' use this to determine if any auths exist and open relevant div in the order of
	 ' Pending/Current/History
	authflag=0
	intFlag=0

%>

<script type="text/javascript" src="toggle.js"></script>

<html>
<head>
<!--#include file="Includes/IECompatability.inc"-->
<title>Squadron Data</title>
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
 
  <form method="POST" name="frmDetails" action="UpdateAuthorised.asp">
	<input type=hidden name="staffID" id="staffID" value="<%=staffID%>">
    <input type=hidden name="startDate" id="startDate" value="<%=strdate%>">
    <input type=hidden name="enddate" id="enddate" value="">
    <input type=hidden name="authlist" id="authlist" value="">
    <input type=hidden name="apprvlist" id="apprvlist" value="">	
    <input type=hidden name="authnotes" id="authnotes" value="">		
    <input type="hidden" name="noteID" id="noteID" value="">
    
    <table border=0 cellpadding=0 cellspacing=0 width=100%>
        <tr>
            <td >
                <!--#include file="Includes/Header.inc"-->
                <table cellSpacing=0 cellPadding=0 width=100% border=0 >
                    <tr style="font-size:10pt;" height=26px>
                    	<td width=10px>&nbsp;</td>
                    	<td><a title="" href="index.asp" class="itemfontlinksmall">Home</a> > <font class="youAreHere" style="font-size:14px">Authorisations</font></td>
                    </tr>
                    <tr>
                    	<td colspan=2 class=titlearealine  height=1></td> 
                    </tr>
                </table>
                 <table style="height:900px;" width=100% height="328" border=0 cellpadding=0 cellspacing=0> 
                    <tr valign=Top>
                        <td class="sidemenuwidth" background="Images/tableback.png">
                            <table width=100% border=0 cellpadding=0 cellspacing=0 class=MenuStyleParent>
                                <tr height=30>
                                    <td></td>
                                    <td width="9" valign=top></td>
                                    <td width="170" align=left><a href="index.asp">Home</a></td>
                                    <td width="50" align=Left class=rightmenuspace ></td>
                                </tr>
                                <tr height=30>
                                	<td></td>
                                	<td valign=top></td>
                                	<td align=Left class="selected">Authorisations</td>
                                	<td class=rightmenuspace align=Left></td>
                                </tr>
							</table>
                        </td>
              
						<td width=16>&nbsp;</td>
						<td align=left>
                         
                        <table border=0 cellpadding=0 cellspacing=0 >
                            <tr>
                                <td height="25px" class=toolbar width=8></td>
                                <td height="25px" width=20><a  href="javascript:saveNew();"><img class="imagelink" src="images/saveitem.gif"></A></td>
                                <td height="25px" valign="middle" class=toolbar>Save</td>
                                <td height="25px" class=titleseparator valign="middle" width=14 align="center">|</td>
                                <td height="25px" class=toolbar valign="middle"><A class=itemfontlink href="cms_hierarchy3.asp?hrcID=<%=session("hrcID")%>">Back</A></td>											
                            </tr>
                        </table>
                
                        <table border=0 cellpadding=0 cellspacing=0 width=100%>
                            <tr>
                                <td height="22px" colspan=6>&nbsp;</td>
                            </tr>
                            <tr class=columnheading>
                                <td align="left" width="2%" height="22px">&nbsp;</td>
                                <td align="left" width="13%" height="22px">First Name:</td>
                                <td align="left" width="25%" height="22px" class=itemfont><%=rsRecSet("firstname")%></td>
                                <td align="left" width="13%" height="22px">Surname:</td>
                                <td align="left" width="47%" height="22px" class=itemfont><%=rsRecSet("surname")%></td>
                            </tr>
                            <tr class=columnheading height=22>
                                <td align="left" width="2%" height="22px">&nbsp;</td>
                                <td align="left" width="13%" height="22px">Service No:</td>
                                <td align="left" width="25%" height="22px" class=itemfont><%=rsRecSet("serviceno")%></td>
                                <td align="left" width="13%" height="22px">Known as:</td>
                                <td align="left" width="47%" height="22px" class=itemfont><%=rsRecSet("knownas")%></td>
                            </tr>
                            <tr class=columnheading height=22>
                                <td align="left" width="2%" height="22px">&nbsp;</td>
                                <td align="left" width="13%" height="22px">Rank:</td>
                                <td align="left" width="25%" height="22px" class=itemfont><%=rsRecSet("rank")%></td>
                                <td align="left" width="13%" height="22px">Trade:</td>
                                <td align="left" width="47%" height="22px" class=itemfont><%=rsRecSet("trade")%></td>
                            </tr>
                            <tr class=columnheading height=22>
                                <td align="left" width="2%" height="22px">&nbsp;</td>
                                <td align="left" width="13%" height="22px">Post:</td>
                                <td align="left" width="25%" height="22px" class=itemfont><%=rsRecSet("post")%></td>
                                <td align="left" width="13%" height="22px">Unit:</td>
                                <td align="left" width="47%" height="22px" class=itemfont><%=rsRecSet("unit")%></td>
                            </tr>
                            <tr>
                                <td colspan=5 height="22px">&nbsp;</td>
                            </tr>
                            <tr>
                                <!--<td colspan=5 height=1 ></td> -->
                                <td colspan=5 class="titlearealine" height=1 ></td>
                            </tr>
                        </table>
                        <table border=0 cellpadding=0 cellspacing=0 width=100%>
                            <tr class="SectionHeader toolbar">
                                <td width="2%" align="left" height="25px">&nbsp;</td>
                                <td width="100%" align="left" height="25px">Summary of Authorisations</td>
                            </tr>
                            <tr>
                                <td colspan="2">&nbsp;</td>
                            </tr>
                        </table>
                        <div id="containerDiv">
                            
                        <table border="0" cellpadding="0" cellspacing="0" width="98%">
                            <tr class="toolbar">
                                <td height="25px" id="A1Img" align=left onclick="toggle('A1', 'A1Img','containerDiv');">
                                    <img src="images/plus.gif" width="18" id="A1Icon"> 
                                  <b>Awaiting Assessment</b>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                   
                                    <div id="A1" style="display:none; border:0; margin:0; padding:0;">
                                        <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                            
                                            <% strRows=0%>
                                            <% do while not rsAuths.eof %>
                                              <% if rsAuths("authType") = 1 then %>
                                                <% intFlag = 1 %>
                                                
                                                <% strRows=strRows + 1 %>
                                                <% if strRows = 1 then %>     <!-- it's the first record so put the header details on the page  -->
                                                    <% authflag=1%>
                                                    <tr class="toolbar">
                                                    <td width="2%" align="left" height="25px">&nbsp;</td>
                                                    <td width="5%" align="left" height="25px">Authorisation</td>
                                                    <td width="10%" align="left" height="25px">For</td>
                                                    <td width="5%" align="center" height="25px">Valid From</td>
                                                    <td width="5%" align="center" height="25px">Valid To</td>
                                                    <td width="5%" align="center" height="25px">Status</td>
                                                    <td width="5%" align="center" height="25px">Assessed</td>
                                                    <td width="10%" align="center" height="25px">Assessed How</td>
                                                    <td width="10%" align="center" height="25px">Approver</td>
                                                    <td width="5%" align="center" height="25px">Decline</td>
                                                    <td width="15%" align="center" height="25px">Limitation Notes</td>
                                                    </tr>
                                                    <tr>
                                                        <td width="2%" class=titlearealine height=1></td>
                                                        <td colspan=10 class=titlearealine height=1></td> 
                                                    </tr>
                                                <% end if %>
                                                <tr class="toolbar" id="A1row3">
                                                    <td width="2%" align="left" height="40px">&nbsp;
                                                      <img class="imagelink" src="images/info.gif" title="Click here for further details" onClick="javascript:ajaxFunction('GetAuthDetailsAjax.asp','authID=<%=rsAuths("authID")%>','Authorisation Details',100,100,250,600)" >
                                                    </td>
                                                    <td width="5%" align="left" height="40px"><%=rsAuths("authCode")%></td>
                                                    <td width="10%" align="left" height="40px"><%=rsAuths("staffname")%></td>
                                                    <td width="5%" align="center" height="40px" id="FromRon"><%=rsAuths("startdate")%></td>
                                                    <!--<td width="8%" align="center" height="25px"><%=rsAuths("enddate")%></td>-->
                                                    <td valign="middle" height="40px" align="center" width="5%" class="itemfont">
                                                      <input name="DateRon" type="text" id="DateRon" class=" itemfontEdit inputboxEdit"  style="Width:85px;"  value ="<%=rsAuths("enddate")%>" readonly onclick="calSet(this)" >
                                                    </td>

                                                    <td width="5%" align="center" height="40px"><img src="Images/black box.gif" alt="In Date" width="12" height="12"></td>
                                                    <td width="5%" align="center" height="40px"><input value="<%=strRows%>-<%=rsAuths("staID")%>" name="authorised" type="checkbox" id="<%=strRows%>-chkauth" onClick="getApprovers(<%=rsAuths("authID")%>, <%=strRows%>,<%=rsAuths("staffID")%> )"></td>
                                                    <td width="10%" align="center">
                                                        <select name="<%=strRows%>-assessID" id="<%=strRows%>-assessID" class="itemfont" style="width: 150px">
                                                            <option value="0">Select</option>
                                                            <option value="1">Verbal Brief</option>
                                                            <option value="2">Interview</option>
                                                        </Select>
                                                    </td>
                                                    <td width="10%" align="center" height="40px">
                                                    <div id="<%=strRows%>apprvr">  
                                                        <select name="apprvID" id="apprvID" class="itemfont" style="width: 150px">
                                                            <option value="0">None</option>
                                                        </Select>
                                                    </div> 
                                                    </td>
                                                    <td width="5%" align="center" height="40px"><input value="<%=strRows%>-<%=rsAuths("staID")%>" name="declineasses" type="checkbox" id="<%=strRows%>-chknoauth" onClick="declineAssessment(this)"></td>
													<td width="15%" height="40px" align="center">
                                                    	<%if isnull(rsAuths("notes")) then%>
                                                        	-
                                                        <%else%>
                                                        	<img src="images/info.gif">
                                                        <%end if%>
                                                    </td>
                                                </tr>
                                               <%end if %>
                                               <% rsAuths.movenext %>
                                            <% loop %>
                                            <% if rsAuths.recordcount > 0 then %> 
                                                 <% rsAuths.movefirst %>
                                            <%end if%>
                                            <% if intFlag = 0 then %>
                                                <tr>
                                                    <td width="2%">&nbsp;</td>
                                                    <td colspan="10" align="left" height="22px" class="toolbar">No Pending Assessments</td>
                                                </tr>
                                            <%end if%>
                
                                            <tr>
                                                <td colspan="10">&nbsp;</td>
                                            </tr>
                                        </table>
                                    </div>
                                </td>
                            </tr>
                        </table>
                                
                        <table border="0" cellpadding="0" cellspacing="0" width="98%">
                            <tr class="toolbar">
                                <td height="25px" id="A2Img" align=left onclick="toggle('A2', 'A2Img','containerDiv');">
                                    <img src="images/plus.gif" width="18" id="A2Icon"> 
                                  <b>Awaiting Approval</b>
                                </td>
                                
                            </tr>
                            <tr>
                                <td>
                                    <div id="A2" style="display:none; border:0; margin:0; padding:0;">
                                        <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                            <% strRows=0%>
                                            <% do while not rsAuths.eof %>
                                              <% if rsAuths("authType") = 2 then %>
                                                <% intFlag = 1 %>
                                                <% strRows=strRows + 1 %>
                                                <% if strRows = 1 then %>  
                                                  <% if authflag=0 then authflag=2 %>
                                                  <tr class="toolbar">
                                                        <td width="2%" align="left" height="25px">&nbsp;</td>
                                                        <td width="5%" align="left" height="25px">Authorisation</td>
                                                        <td width="10%" align="left" height="25px">For</td>
                                                        <td width="5%" align="center" height="25px">Valid From</td>
                                                        <td width="5%" align="center" height="25px">Valid To</td>
                                                        <td width="5%" align="center" height="25px">Status</td>
                                                        <td width="13%" align="center" height="25px">Assessed By</td>
                                                        <td width="10%" align="center" height="25px">Assessed How</td>
                                                        <td width="5%" align="center" height="25px">Approve</td>
                                                        <td width="5%" align="center" height="25px">Decline</td>
                                                        <td width="15%" align="center" height="25px">Limitation Notes</td>
                                                    </tr>
                                                    <tr>
                                                        <td width="2%" class=titlearealine height=1></td>
                                                        <td colspan=10 class=titlearealine height=1></td> 
                                                    </tr>
                                                <% end if %> 
                                                <tr class="toolbar" id="A2Row3">
                                                    <td width="2%" align="left" height="40px">&nbsp;
                                                      <img class="imagelink" src="images/info.gif" title="Click here for further details" onClick="javascript:ajaxFunction('GetAuthDetailsAjax.asp','authID=<%=rsAuths("authID")%>','Authorisation Details',100,100,250,600)" >
                                                    </td>
                                                    <td width="5%" align="left" height="40px"><%=rsAuths("authCode")%></td>
                                                    <td width="10%" align="left" height="40px"><%=rsAuths("staffname")%></td>
                                                    <td width="5%" align="center" height="40px"><%=rsAuths("startdate")%></td>
                                                    <td width="5%" align="center" height="40px"><%=rsAuths("enddate")%></td>
                                                    <td width="5%" align="center" height="40px"><img src="Images/black box.gif" alt="In Date" width="12" height="12"></td>
                                                    <td width="13%" align="left" height="40px"><%=rsAuths("assessor")%> - <%=rsAuths("assessdate")%></td>
                                                    <td width="10%" align="center" height="25px"><% if cint(rsAuths("how")) = 1 then %>Verbal Brief<%elseif cint(rsAuths("how")) = 2 then %>Interview<% else %>-<% end if %></td>
                                                    <td width="5%" align="center" height="40px"><input value="<%=strRows%>-<%=rsAuths("staID")%>" name="approved" type="checkbox" id="<%=strRows%>-chkapprv" onClick="showlightbox(this, '<%=strRows%>-<%=rsAuths("staID")%>')"></td>
                                                    <td width="5%" align="center" height="40px"><input value="<%=strRows%>-<%=rsAuths("staID")%>" name="declineapprv" type="checkbox" id="<%=strRows%>-chknoapprv" onClick="declineAproval(this)"></td>
													<td width="15%" height="40px">
                                                        <div id="<%=strRows%>-<%=rsAuths("staID")%>" class="LimitBox">
                                                        </div>
                                                    </td>                
                                                </tr>
                                              <%end if %>
                                              <% rsAuths.movenext %>
                                            <% loop %>
                                            <% if rsAuths.recordcount > 0 then %> 
                                                 <% rsAuths.movefirst %>
                                            <%end if%>
                                            <% if intFlag = 0 then %>
                                                <tr>
                                                    <td width="2%">&nbsp;</td>
                                                    <td colspan="9" align="left" height="22px" class="toolbar">No Pending Approvals</td>
                                                </tr>
                                            <%end if%>
                
                                            <tr>
                                                <td colspan="10">&nbsp;</td>
                                            </tr>
                                        </table>
                                    </div>
                                </td>
                            </tr>
                        </table>
                                    
                        <table border="0" cellpadding="0" cellspacing="0" width="98%">
                            <tr class="toolbar">
                                <td height="25px" id="A3Img" align=left onclick="toggle('A3', 'A3Img','containerDiv');">
                                    <img src="images/plus.gif" width="18" id="A3Icon"> 
                                  <b>History</b>
                                </td>
                                
                            </tr>
                            <tr>
                                <td>
                                    <div id="A3" style="display:none; border:0; margin:0; padding:0;">
                                        <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                                <td width="2%" align="left" height="25px">&nbsp;</td>
                                                <td width="5%" align="left" height="25px">Authorisation</td>
                                                <td width="10%" align="left" height="25px">For</td>
                                                <td width="5%" align="center" height="25px">Valid From</td>
                                                <td width="5%" align="center" height="25px">Valid To</td>
                                                <td width="13%" align="left" height="25px">Assessed By </td>
                                                <td width="10%" align="center" height="25px">Assessed How</td>
                                                <td width="13%" align="left" height="25px">Approved By </td>
                                                <td width="15%" align="center" height="25px">Limitation Notes</td>
                                            </tr>
                                            <tr>
                                                <td width="2%" class=titlearealine height=1></td>
                                                <td colspan=10 class=titlearealine height=1></td> 
                                            </tr>
                                            <% do while not rsAuths.eof %>
                                              <% if rsAuths("authType") = 3 then %>
                                                <% intFlag = 1 %>
                                                <% if authflag=0 then authflag=3 %>
                                                <tr class="toolbar">
                                                    <td width="2%" align="left" height="40px">&nbsp;
                                                      <img class="imagelink" src="images/info.gif" title="Click here for further details" onClick="javascript:ajaxFunction('GetAuthDetailsAjax.asp','authID=<%=rsAuths("authID")%>','Authorisation Details',100,100,250,600)" >
                                                    </td>
                                                    <td width="5%" align="left" height="40px"><%=rsAuths("authCode")%></td>
                                                    <td width="10%" align="left" height="40px"><%=rsAuths("staffname")%></td>
                                                    <td width="5%" align="center" height="40px"><%=rsAuths("startdate")%></td>
                                                    <td width="5%" align="center" height="40px"><%=rsAuths("enddate")%></td>
                                                    <td width="13%" align="left" height="40px"><%=rsAuths("assessor")%> - <%=rsAuths("assessdate")%></td>
                                                    <td width="10%" align="center" height="40px"><% if cint(rsAuths("how")) = 1 then %>Verbal Brief<%elseif cint(rsAuths("how")) = 2 then %>Interview<% else %>-<% end if %></td>
                                                    <td width="13%" align="left" height="40px">
                                                        <%=rsAuths("approver")%> 
														<% if rsAuths("approved") = true then %>
                                                          - <%=rsAuths("apprvdate")%>
                                                        <%end if %>
                                                    </td>
													<td width="15%" height="40px" align="center">
                                                    	<%if isnull(rsAuths("notes")) then%>
                                                        	-
                                                        <%else%>
                                                        	<img src="images/info.gif" onClick="showLimitations('<%=rsAuths("notes")%>')">
                                                        <%end if%>
                                                        <!--
                                                        <div class="LimitBox">
                                                        	<%'=rsAuths("notes")%>
                                                        </div>
                                                        -->
                                                    </td>
                                                </tr>
                                               <%end if %>
                                               <% rsAuths.movenext %>
                                            <% loop %>
                                            <% if rsAuths.recordcount > 0 then %> 
                                                 <% rsAuths.movefirst %>
                                            <%end if%>
                                            <% if intFlag = 0 then %>
                                                <tr>
                                                    <td width="2%">&nbsp;</td>
                                                    <td colspan="9" align="left" height="22px" class="toolbar">No Authorisation History</td>
                                                </tr>
                                            <%end if%>
                
                                            <tr>
                                                <td colspan="10">&nbsp;</td>
                                            </tr>
                                        </table>
                                    </div>
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
   
    <form name="frmlimits">
  	<div id="fade" style="display:none;"  class="black_overlay"></div>

    <div id="light" style="display:none;"  class="white_content">
       <div class="lightboxhdr" align="center">Add Auth Limitation Details  </div> 
       <div class="lightboxcontent" align="center">
       	   <textarea name="authlimits" rows="10"  class="itemfont" id="authlimits" style="width:90%; height:220px;"></textarea>
       </div> 
       <div class="lightboxbtn" align="center">
           <Input CLASS="StandardButton" Type=Button id="btnOK"  Value=OK onclick="hidelightbox(0)">
           <Input CLASS="StandardButton" Type=Button  id="btnCancel" Value=Cancel onclick="hidelightbox(1)">
       </div> 
    </div>

    <div id="light-lims" style="display:none;"  class="white_content">
       <div class="lightboxhdr" align="center">Auth Limitation Details</div> 
       <div class="lightboxcontent" align="center">
       	   <textarea name="limits" rows="10"  class="itemfont" id="limits" style="width:90%; height:220px;"></textarea>
       </div> 
       <div class="lightboxbtn" align="center">
           <Input CLASS="StandardButton" Type=Button id="btnOK"  Value=OK onclick="hideLimitations()">
       </div> 
    </div>
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
    
<%
if isObject(rsRecSet) then 
	rsRecSet.close
	set rsRecSet=Nothing
end if

con.close
set con=Nothing
%>

</body>
</html>

<script type="text/javascript" src="calendar.js"></script>

<script language="JavaScript">
var dispdiv=<%=authflag%>;
checkauthdiv(dispdiv);

function checkauthdiv(dispdiv){
	
	if(dispdiv==1){
		document.getElementById("A1").style.display = 'block';
		document.getElementById('A1Img').innerHTML = '<img src="images/minus.gif" width="18" id="A1Icon"><b>Awaiting Assessment</b>';
	}
	else if(dispdiv==2){
		document.getElementById("A2").style.display = 'block';
		document.getElementById('A2Img').innerHTML = '<img src="images/minus.gif" width="18" id="A2Icon"><b>Awaiting Approval</b>';
	}
	else if(dispdiv==3){
		document.getElementById("A3").style.display = 'block';
		document.getElementById('A3Img').innerHTML = '<img src="images/minus.gif" width="18" id="A3Icon"><b>History</b>';
	}
}

/***
function toggle(showHideDiv, switchImgTag, mainDiv)
{
	alert("toggle " + showHideDiv + " * " + switchImgTag + " * " + mainDiv);
	
	var ele = document.getElementById(showHideDiv);
	var imageEle = document.getElementById(switchImgTag);
	var divs = document.getElementById(mainDiv).getElementsByTagName('DIV')
	
	    document.getElementById("A1").style.display="none";
		document.getElementById("A1Icon").src = 'images/plus.gif';
		document.getElementById("A2").style.display="none";
		document.getElementById("A2Icon").src = 'images/plus.gif';
		document.getElementById("A3").style.display="none";
		document.getElementById("A3Icon").src = 'images/plus.gif';
		
		ele.style.display = "block";
		imageEle.getElementsByTagName('img')[0].src = 'images/minus.gif';
}

**/

function getApprovers(authID, rownum, staffID)
{
	var str = 'authID='+authID +"&staffID=" + staffID;
	var strdiv=rownum+'apprvr';
	
	document.getElementById(rownum+'-chknoauth').checked = false;
	//alert("approvers for " + str + " * " + strdiv);
	ajax('ddStaffApprovers.asp',str,strdiv);
}

function declineAssessment(obj) {
	var chkno=obj.checked;
	var id = obj.value;
	var delOK = false
	
	var rowno = id.split("-")[0];
	
	if (chkno==true){
		var input_box = confirm("Are you sure you want to decline this Record?")
		if(input_box==true)
		{
			delOK = true;
		}
		
		if (delOK==false){
			obj.checked=false;
		} else {
			document.getElementById(rowno+'-chkauth').checked = false;
			document.getElementById(rowno+'-assessID').selectedIndex = 0;
			document.getElementById(rowno+'apprvr').innerHTML = '<select name="apprvID" id="apprvID" class="itemfont" style="width: 150px"><option value="0">None</option></Select>';		
		}
	}
}

function declineAproval(obj)
{
	var chkno=obj.checked;
	var id = obj.value;
	var delOK = false
	
	var rowno = id.split("-")[0];
	
	if (chkno==true){
		var input_box = confirm("Are you sure you want to decline this Record?")
		if(input_box==true)
		{
			delOK = true;
		}
		
		if (delOK==false){
			obj.checked=false;
		} else {
			document.getElementById(rowno+'-chkapprv').checked = false;
			document.getElementById(id).innerHTML = '';
		}
	}
}


function saveNew()
{	
	    var strauths="";
		var authid;
		var authval;
		
		var assessid;

		var strapprvs="";
		var apprvid;
		var apprvval;
		
		var strnotes="";
		//var noteid;
		var noteval;
		
	    var endt;
		var staid;
		var errMsg = "";
		
	    // first get the ones being Authorised - A1 Div
		
	    var a1 = document.getElementById("A1");
		var trarr=a1.getElementsByTagName("tr");
		
		//alert(trarr.length);
		
		if(trarr.length > 2){
			for(var x = 2; x < trarr.length - 1; x++){  
			  
				//alert(chkbox.length);
				// input is the DECLINE checkbox so set up string to show this 
				if(trarr[x].getElementsByTagName("input")[2].checked==true){
					//alert ("decline this ");
					
					authval = trarr[x].getElementsByTagName("input")[1].value.split("-");
					 staid=(authval[1]);
					 
					 authid=0;
					 
					 // OK if we get to here so add to string that will go the stored procedure
					 strauths=strauths + staid +"|" + authid + "|" + 0 + "|" + 0 + "," ;
				}
				else
				if(trarr[x].getElementsByTagName("input")[1].checked==true){
					
					 // select is the Approver picked from the drop down box - and we must have picked one					 
					 if(trarr[x].getElementsByTagName("select")[0].value==0){
						 errMsg += "Please correct or provide an Assessed How\n";
					 }
					 
					 if(trarr[x].getElementsByTagName("select")[1].value==0){
						 errMsg += "Please correct or provide an Approver\n";
					 }
					 
					 authval = trarr[x].getElementsByTagName("input")[1].value.split("-");
					 staid=(authval[1]);
					 
					 assessid=trarr[x].getElementsByTagName("select")[0].value;
					 authid=trarr[x].getElementsByTagName("select")[1].value;
					 
					 //alert(assessid);
					 //return;
					 
					 // this is the end date
					 endt=trarr[x].getElementsByTagName("input")[0].value;
					 // OK if we get to here so add to string that will go the stored procedure
					 strauths=strauths + staid + "|" + authid  + "|" + endt + "|" + assessid + "," ;
					 //strauths=strauths + staid + "|" + authid  + "|" + endt + "," ;
					 /**
					 if(strauths==""){
						 strauths=staid+"|"+authid;
					 }
					 else{
						 strauths=strauths + "," + staid +"|" + authid;
					 }
					 **/
				}
			} 
		}
		
		// now get any Approved
		var a2 = document.getElementById("A2");
		var trarr2=a2.getElementsByTagName("tr");
		
		//alert(trarr2.length);
		  for(var x = 2; x < trarr2.length - 1; x++){  
		  
			//alert(trarr2[x].getElementsByTagName("input")[0].id + " * "  + trarr2[x].getElementsByTagName("input")[1].id);
			
			// input is the checkbox and 
			// input is the DECLINE checkbox so set up string to show this 
			if(trarr2[x].getElementsByTagName("input")[1].checked==true){
				//alert ("decline this ");
				
				apprvval = trarr2[x].getElementsByTagName("input")[1].value.split("-");
				 staid=(apprvval[1]);
				 
				 // OK if we get to here so add to string that will go the stored procedure
				 
				 if(strapprvs==""){
					 //strapprvs=staid+"|"+authid;
					  strapprvs=staid +"|" + 0 + "|" + 0 + "|" + 0 + "," ;
				 }
				 else{
					// strapprvs=strapprvs + "," + staid +"|" + authid;
					 strapprvs=strapprvs + "," + staid +"|" + 0 + "|" + 0 + "|" + 0 + ",";
				 }
				 				 
			}
			else
			if(trarr2[x].getElementsByTagName("input")[0].checked==true){
				
				 // select is the Approver picked from the drop down box - and we must have picked one
				// if(trarr[x].getElementsByTagName("select")[0].value==0){
				//	 errMsg += "You Must Select an Approver for every Authorisation You Authorise\n";
				//	 break;
				 //}
				 
				 apprvval = trarr2[x].getElementsByTagName("input")[0].value.split("-");
				 staid=(apprvval[1]);
				 
				 //authid=trarr[x].getElementsByTagName("select")[0].value;
                 
				 // this is the end date
			     endt=trarr2[x].getElementsByTagName("td")[4].innerHTML;
				 
				 //noteval = trarr2[x].getElementsByTagName("input")[2].value.split("-");
				 noteval = trarr2[x].getElementsByTagName("div")[0].innerHTML;
				 //noteid = (noteval[1]);
				 
				 //alert(noteval);

				 // OK if we get to here so add to string that will go the stored procedure
				 if(strapprvs==""){
					  strapprvs=staid + "|" + 1 + "|" + endt + "|" + noteval + "," ;
					  //strnotes=staid + "|" + noteval + "," ;
				 }
				 else{
					 strapprvs=strapprvs + staid + "|" + 1 + "|" + endt + "|" + noteval + "," ;
					 //strnotes=strnotes + staid + "|" + noteval + "," ;
				 }
			}
		} 
		
		/* not picked any so ignore submit */		
		if (strauths== "" && strapprvs=="")
		{
			errMsg += "No Authorisations have been Authorised or Approved";
		}
	
		if(!errMsg=="")
		{
			alert(errMsg)
			return;	  		
		} 
	
	    //strnotes=document.frmlimits.authlimits.value; 
	    //alert("Authorised " + strauths + " * " + strapprvs); // + " * " + strnotes 
		document.frmDetails.authlist.value =strauths;
		document.frmDetails.apprvlist.value =strapprvs;
		//document.frmDetails.authnotes.value =strnotes;
		
		document.frmDetails.submit();  

}

function showlightbox(obj, id)
    {
		var rowno = id.split("-")[0];
		
		if(obj.checked==true){
			document.getElementById("fade").style.display = "block";
			document.getElementById("light").style.display = "block";
			document.getElementById("authlimits").value="Off A/C Only";
			document.getElementById('noteID').value = id;
		} else {
			document.getElementById("fade").style.display = "none";
			document.getElementById("light").style.display = "none";
			document.getElementById("authlimits").value="";
			document.getElementById(id).innerHTML = "";
			document.getElementById('noteID').value = '';
		}
		document.getElementById(rowno+'-chknoapprv').checked = false;
    }
	
function hidelightbox(flag)
    {
		if(flag == 0) {
			var id = document.getElementById('noteID').value;

			//alert(flag);
			document.getElementById(id).innerHTML = document.getElementById("authlimits").value;
			document.getElementById("authlimits").value="";
		} else if(flag == 1) {
        	document.getElementById("authlimits").value="";
		}
		
		document.getElementById("fade").style.display = "none";
		document.getElementById("light").style.display = "none";
		//alert(document.getElementById("authlimits").value);
		
    }
	


//----------------standard ajax function with option for secondary function----------------
function ajax(url,strMessage,div,func,loading){
     //prompt('',url+'?'+strMessage + '?'+div+'?'+func+'?'+loading)
  
    //var str = 'pagesize='+pagesize+'&filSearch='+crsenum+' &orderBy='+orderBy+'&dir='+dir + ' &searchby=number ';
	//prompt("",'userlist.asp?'+str)
	//ajax('courselist.asp',str,'List');
  
   //alert("into ajax " + url + " * " + strMessage + " * " + div);
  
	if(loading){
		//document.getElementById(div).innerHTML = '<div align="center" style="width:100%; margin-top:250px;"><img src="images/loading1.gif"/><div style="margin-bottom:10px; color:#999;">Loading</div> <div>'
		//document.getElementById("loading").style.display = 'block';
		loadingImg(loading);
	}
	var timeoutcounter = 0;	//Count ajax call as being active, reset the countdown counter.
	var xhr;  
	if (typeof XMLHttpRequest !== 'undefined') {
		xhr = new XMLHttpRequest(); 
	}
	else{  
		var versions = ["MSXML2.XmlHttp.6.0",
						"MSXML2.XmlHttp.5.0",
						"MSXML2.XmlHttp.4.0",
						"MSXML2.XmlHttp.3.0",
						"MSXML2.XmlHttp.2.0",
						"Microsoft.XmlHttp"];
		for(var i = 0; i < versions.length; i++){  
			try{  
				xhr = new ActiveXObject(versions[i]);
				break;  
			}  
			catch(e){}  
		} 
	}  
	xhr.onreadystatechange = function(){ 
		if ((xhr.readyState === 4) && (xhr.status === 200)){
			
			   //alert(xhr.responseText);
				//if there is a div specified then place the response text inside.
				if (div !== ''){
					document.getElementById(div).innerHTML = xhr.responseText;
				
				}
				//alert(document.getElementById(div).innerHTML)
				//If there is a function (func) specified then run it.
				if (func){
					//alert("into func " + xhr.responseText);
					eval(func);
				}
				if(loading){
					document.getElementById("loading").style.display = 'none';
				}
				//alert("Yep")
		}
		else if ((xhr.readyState === 4) && (xhr.status !== 200)){
			window.open("error.asp?code="+xhr.responseText)
			//prompt("",xhr.responseText)
		}
		else{
			return;
		}
	}  
	xhr.open("post",url,true);
	xhr.setRequestHeader("Content-type","application/x-www-form-urlencoded");
	
	//alert("out of ajax");
	xhr.send(strMessage);
	//xhr.send(encodeURI(strMessage)); 
}

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
	ajaxRequest.onreadystatechange = function(){
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

function dateCheck(toDate, datefrom) {
	
	//alert("DateCheck");
		
	var dateStr=datefrom ;
	var datetoStr=toDate;
	
	
    if(dateStr != "" && datetoStr != "")
	 {
		var intSDate = parseInt(dateStr.split("/")[2] + dateStr.split("/")[1] + dateStr.split("/")[0])
		var intEDate = parseInt(datetoStr.split("/")[2] + datetoStr.split("/")[1] + datetoStr.split("/")[0])
		
		//alert("dates are " + dateStr + " & " + datetoStr + " & " + intSDate + " & " + intEDate);
		
		if(intEDate < intSDate)
		{
			alert( "End date can not be earlier than start date\n");
			return false;
		}
		else
		{return true;}
	 }
	
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
	
	document.getElementById('detailWindowTitleBar').style.width = xWidth - 16 + "px";
}

function closeThisWindow(thisWindow)
{
	document.getElementById(thisWindow).style.visibility = "hidden";
}

function showLimitations(notes)
{
	document.getElementById('limits').innerHTML = '';
	document.getElementById("fade").style.display = "block";
	document.getElementById("light-lims").style.display = "block";
	document.getElementById('limits').innerHTML = notes;
}
	
function hideLimitations()
{
	document.getElementById("fade").style.display = "none";
	document.getElementById("light-lims").style.display = "none";
}

</Script>