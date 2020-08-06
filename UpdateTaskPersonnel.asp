<!DOCTYPE HTML >
<!--#include file="Includes/security.inc"--> 
<!--#include file="Connection/Connection.inc"-->
<%
color1="#f4f4f4"
color2="#fafafa"
counter=0 
row=0

set objCmd = server.CreateObject("ADODB.Command")
set objPara = server.CreateObject("ADODB.Parameter")
objCmd.ActiveConnection = con
objCmd.Activeconnection.cursorlocation = 3
	
Const Hidden = 2

dim strRecID
dim strTaskThis
dim intCount
dim strNewStations
dim strList

'response.write("Staff List is " & request("newattached"))
'response.End()

strRecID = request("RecID")
strGoTo = request("ReturnTo") & "?RecID=" & strRecid & "&StartDate=" & request("startDate") & "&EndDate=" & request("endDate")
strNewStations = 0

if request("newattached") <> "" then
	strList = request("newAttached")
	strTaskThis = split(strList, ",")
	
	for intCount = 1 to (ubound(strTaskThis))
         strNewStations = split(strTaskThis(intCount), "|")
		 if strNewStations(1)="" then
			strNewStations(1)= "0"
		 end if  
		
		objCmd.CommandText = "spTaskPersonnelAdd"	
		objCmd.CommandType = 4
		set objPara = objCmd.CreateParameter ("nodeID",3,1,0, nodeID)
		objCmd.Parameters.Append objPara
		set objPara = objCmd.CreateParameter ("TaskID",3,1,0, request("RecID"))
		objCmd.Parameters.Append objPara
		'set objPara = objCmd.CreateParameter ("serviceNo",200,1,50, strNewStations(0))
		set objPara = objCmd.CreateParameter ("staffID",3,1,0, strNewStations(0))
		objCmd.Parameters.Append objPara
		set objPara = objCmd.CreateParameter ("ooadays",3,1,0, strNewStations(1))
		objCmd.Parameters.Append objPara
		set objPara = objCmd.CreateParameter ("currentUser",3,1,0, session("staffID"))
		objCmd.Parameters.Append objPara
		set objPara = objCmd.CreateParameter ("StartDate",200,1,16, request("startDate"))
		objCmd.Parameters.Append objPara
		set objPara = objCmd.CreateParameter ("EndDate",200,1,16, request("endDate"))
		objCmd.Parameters.Append objPara
		set objPara = objCmd.CreateParameter ("notes",200,1,2000, request("notes"))
		objCmd.Parameters.Append objPara
		set objPara = objCmd.CreateParameter ("id",3,1,0, 0)
		objCmd.Parameters.Append objPara
		set objPara = objCmd.CreateParameter ("Flag",3,1,0, 0)
		objCmd.Parameters.Append objPara	
		objCmd.Execute
	    
        'response.write("Staff is " & strNewStations(0) & " * " & strNewStations(1))
        ' response.End()
		
		'response.write userAddedStatus
		for x = 1 to objCmd.parameters.count
			objCmd.parameters.delete(0)
		next
	next 
end if

objCmd.CommandText = "spTaskPersonnelCheck"	
objCmd.CommandType = 4				
set objPara = objCmd.CreateParameter ("TaskID",3,1,0, request("RecID"))
objCmd.Parameters.Append objPara
set objPara = objCmd.CreateParameter ("currentUser",200,1,50, session("StaffID"))
objCmd.Parameters.Append objPara
set RSList = objCmd.Execute	

' start of the big IF statement - means we have selected personnel who already tasked for the chosen dates		
if RSList.recordCount>0 then

	for x = 1 to objCmd.parameters.count
		objCmd.parameters.delete(0)
	next
	
	set objPara = objCmd.CreateParameter ("TaskID",3,1,5, request("RecID"))
	objCmd.Parameters.Append objPara
	objCmd.CommandText = "sp_TaskDetail"	'Name of Stored Procedure'
	set rsRecSet = objCmd.Execute	'Execute CommandText when using "ADODB.Command" object'		
	%>
	
    <html>
    <head>
    
    <title>Task Details</title>
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
        <table height="100%" cellspacing=0 cellPadding=0 width=100% border=0>
            <tr>
                <td>
                    <!--#include file="Includes/Header.inc"-->
                    <table cellSpacing=0 cellPadding=0 width=100% border=0 >
                        <tr style="font-size:10pt;" height=26px>
                            <td width=10px>&nbsp;</td>
                            <td><a title="" href="index.asp" class=itemfontlinksmall >Home</A> > <A title="" href="ManningTaskSearch.asp" class=itemfontlinksmall >Tasking</A> > <A title="" href="ManningTaskSearch.asp" class=itemfontlinksmall >Task</A> > <A title="" href="ManningTaskPersonnel.asp?RecID=<%=request("RecID")%>" class=itemfontlinksmall>Tasked Personnel</a> > <font class="youAreHere" >Add Personnel</font></td>
                        </tr>
                        <tr>
                            <td colspan=2 class=titlearealine  height=1></td> 
                        </tr>
                    </table>
                    <table width=100% height='<%=session("heightIs")%>px' border=0 cellpadding=0 cellspacing=0 > 
                        <tr valign=Top>
                            <td class="sidemenuwidth" background="Images/tableback.png">
                                <table border=0 cellpadding=0 cellspacing=0 class=MenuStyleParent>
                                    <tr height=22>
                                        <td></td>
                                        <td colspan=3 align=left height=20>Current Location</td>
                                    </tr>
                                    <tr height=22>
                                        <td width=10></td>
                                        <td width=18 valign=top><img src="images/arrow.gif"></td>
                                        <td width=170 align=Left><A title="" href="index.asp">Home</A></td>
                                        <td width=50 align=Left></td>
                                    </tr>
                                    <tr height=22>
                                        <td ></td>
                                        <td valign=top><img src="images/arrow.gif"></td>
                                        <td align=Left><A title="" href="ManningTaskSearch.asp">Tasking</a></td>
                                        <td align=Left></td>
                                    </tr>
                                    <tr height=22>
                                        <td ></td>
                                        <td valign=top><img src="images/vnavicon.gif"></td>
                                        <td align=Left><A title="" href="ManningTaskPersonnel.asp?RecID=<%=request("RecID")%>">Task</A></td>
                                        <td class=rightmenuspace align=Left ></td>
                                    </tr>
                                    <tr height=22>
                                      <td>&nbsp;</td>
                                      <td valign=top><img src="images/vnavicon.gif"></td>
                                      <td align=Left><a href="ManningTaskPersonnel.asp?RecID=<%=request("RecID")%>">Tasked Personnel</a></td>
                                      <td class=rightmenuspace align=Left ></td>
                                    </tr>
                                    <tr height=22>
                                      <td>&nbsp;</td>
                                      <td valign=top><img src="images/vnavicon.gif"></td>
                                      <td align=Left bgcolor="#FFFFFF"><Div style="height:18px; border:Solid; width:16em; border-width:1px; border-color:#438BE4; color: #003399;">Add Personnel</Div></td>
                                      <td class=rightmenuspace align=Left ></td>
                                    </tr>
                                </table>
                            </td>
                            <td width=16px></td>
                            <td align=left>
                                <form action="" method="post" name="frmDetails" onSubmit="javascript:return(CheckForm());">
                                    <Input name="RecID" id="RecID" type="hidden" value=<%=request("RecID")%>>
                                    <input name="newattached" id="newattached" type="hidden" value="">
                                    <input name="ReturnTo" id="ReturnTo" type="hidden"  value="ManningTaskPersonnel.asp">
                                    <Input name="DoSearch" id="DoSearch" type="hidden" value=1>
                                    <Input name="Page" id="Page" type="hidden" value=1>
                                    <Input name="HiddenDate" id="HiddenDate" type="hidden" >
                                    <input name="currentlyChecked" id="currentlyChecked" type=hidden value=<%=request("currentlyChecked")%>>
                                    <input name ="criteriaChange" id="criteriaChange" type=hidden value=0>
                                    <Input name="StartDate" id="StartDate" type="hidden" value="<%=request("startDate")%>">
                                    <Input name="EndDate" id="EndDate" type="hidden" value="<%=request("endDate")%>">
                                    <Input name="notes" id="notes" type="hidden" value="<%=request("notes")%>">
                                
                                    <table border=0 cellpadding=0 cellspacing=0 width=100%>
                                        <tr height=16 class=SectionHeader>
                                            <td>
                                                <table border=0 cellpadding=0 cellspacing=0 >
                                                    <tr>
                                                        <td class=toolbar width=8>&nbsp;</td>
                                                    </tr>
                                                </table>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <table width=100% border=0 cellpadding=0 cellspacing=0>
                                                    <tr>
                                                        <td height=22>&nbsp;</td>
                                                    </tr>
                                                    <tr class=columnheading>
                                                        <td valign="middle" width=2% height=22>&nbsp;</td>
                                                        <td valign="middle" width=13% height=22>Task:</td>
                                                        <td valign="middle" width=85% height=22 class=itemfont><%=rsRecSet("Task")%></td>
                                                    </tr>
                                                    <tr class=columnheading>
                                                        <td valign="middle" width=2% height=22>&nbsp;</td>
                                                        <td valign="middle" height=22>Task Type:</td>
                                                        <td valign="middle" height=22 class=itemfont ><%=rsRecSet("Type")%></td>
                                                    </tr>
                                                    <tr class=columnheading>
                                                        <td valign="middle" width=2% height=22>&nbsp;</td>
                                                        <td valign="middle" height=22>Start Date:</td>
                                                        <td valign="middle" height=22 class=itemfont ><%=request("startDate")%></td>
                                                    </tr>
                                                    <tr class=columnheading>
                                                        <td valign="middle" width=2% height=22>&nbsp;</td>
                                                        <td valign="middle" height=22>End Date:</td>
                                                        <td valign="middle" height=22 class=itemfont ><%=request("endDate")%></td>
                                                    </tr>
                                                    <tr class=columnheading>
                                                        <td valign="middle" width=2% height=22>&nbsp;</td>
                                                        <td valign="middle" width="13%" height=22>Cancellable:</td>
                                                        <td width=85% height=22 class=itemfont>
                                                            <% if rsRecSet("cancellable") = true then %>
                                                                Yes
                                                            <% else %>
                                                                No
                                                            <% end if %> 
                                                        </td>
                                                    </tr>
                                                </table>
                                            </td>
                                        </tr>
                                    </table>
                                </form>
                                <form action="" method="post" name="frmPosts">
                                    <table border=0 cellpadding=0 cellspacing=0 width=100%>
                                        <tr>
                                            <td colspan=5 class=titlearealine height=1></td> 
                                        </tr>
                                        <tr height=16 class=SectionHeader>
                                            <td colspan=5 height="22">
                                                <table border=0 cellpadding=0 cellspacing=0 >
                                                    <tr>
                                                        <td width="1%" class=toolbar></td>
                                                        <td width="99%" class=toolbar valign="middle" ><font color=#ff0000>!! Warning !! </font>The Personnel listed below are already assigned to the listed tasks:</td>
                                                    </tr>
                                                </table>
                                            </td>
                                        </tr>
                                        <tr height=16 >
                                            <td colspan=5></td>
                                        </tr>
                                        <tr>
                                            <td colspan=5>
                                                <table width=100% border=0 cellpadding=0 cellspacing=0>
                                                    <tr class=columnheading>
                                                        <td valign="middle" align="center" width=8% height=22>Overwrite</td>
                                                        <td valign="middle" width=2% height=22>&nbsp;</td>
                                                        <td valign="middle" width=15% height=22>Surname</td>
                                                        <td valign="middle"  width=15% height=22>Firstname</td>
                                                        <td valign="middle"  width=15% height=22>Service No</td>
                                                        <td width=2% height=22>&nbsp;</td>
                                                        <td valign="middle" width=13% height=22>Existing Task</td>
                                                        <td valign="middle" align="center" width=8% height=22>Start Date</td>
                                                        <td valign="middle" align="center" width=8% height=22>End Date</td>
                                                        <td width="5%" height=22>&nbsp;</td>
                                                    </tr>
                                                    <tr>
                                                        <td colspan=10 class=titlearealine  height=1></td> 
                                                    </tr>
                                                    <% tempServiceNo = "" %>
                                                    <% do while not RSList.eof %>
                                                        <% if tempServiceNo <> RSList("serviceno") then %>
                                                            <% if counter = 0 then %>
                                                                <% counter = 1 %>
                                                            <% else %>
                                                                <% if counter = 1 then counter = 0 %>
                                                            <% end if %>
                                                        <% end if %>
                                                        <% if tempServiceNo <> RSList("serviceno") and tempServiceNo <> "" then %>
                                                            <tr>
                                                                <td colspan=10 height=10></td> 
                                                            </tr>
                                                            <tr>
                                                                <td colspan=10 class=titlearealine  height=1></td> 
                                                            </tr>
                                                        <% end if %>							
                                                        <tr class=itemfont <%if counter=0 then%>style="background-color:<%=color1%>;"<%else%>style="background-color:<%=color2%>;"<%end if%>>
                                                            <td valign="middle" align="center" height=22 <%if tempServiceNo=RSList("serviceno")  then%>style="background-color:#ffffff"<%end if%>><%if tempServiceNo<>RSList("serviceno")  then%><input type="checkbox"  name=StaffID<%=RSList("StaffID")%> value=<%=RSList("staffID")%>><%end if%></td>
                                                            <td valign="middle" height=22 <%if tempServiceNo=RSList("serviceno")  then%>style="background-color:#ffffff"<%end if%>></td>
                                                            <td height=22 <%if tempServiceNo=RSList("serviceno")  then%>style="background-color:#ffffff"<%end if%>><%if tempServiceNo<>RSList("serviceno") then response.write RSList("surname")%></td>
                                                            <td height=22 <%if tempServiceNo=RSList("serviceno")  then%>style="background-color:#ffffff"<%end if%>><%if tempServiceNo<>RSList("serviceno") then response.write  RSList("firstname")%></td>
                                                            <td height=22 <%if tempServiceNo=RSList("serviceno")  then%>style="background-color:#ffffff"<%end if%>><%if tempServiceNo<>RSList("serviceno") then response.write RSList("serviceno")%></td>
                                                            <td height=22 width=2%></td>
                                                            <td height=22><%=RSList("description")%></td>
                                                            <td height=22 align="center"><%=RSList("startDate")%></td><td align="center"><%=RSList("endDate")%></td>
                                                            <td height=22 valign="middle" ></td>
                                                        </tr>
                                                        <tr>
                                                            <td colspan=10 class=titlearealine  height=1></td> 
                                                        </tr>
                                                        <% Row = Row + 1 %>
                                                        <% tempServiceNo = RSList("serviceno") %>
                                                        <% RSList.movenext %>
                                                    <% loop %>
                                                    <tr height=16>
                                                        <td colspan=10></td>
                                                    </tr>
                                                    <tr>
                                                        <td colspan=10 align="center">
                                                            <table width=400px border=0 cellpadding=0 cellspacing=0>
                                                                <tr>
                                                                    <td colspan=5 align="center" class=toolbar height="22">Clicking OK will overwrite the above task(s) with the new task.</td>
                                                                </tr>
                                                                <tr>
                                                                    <td height=22 colspan=5>&nbsp;</td>
                                                                </tr>
                                                                <tr>
                                                                    <td width=115px>&nbsp;</td>
                                                                    <td style="cursor:hand;" width=80px middle align="center"><img width="76px" src="images/OK.gif" onclick="javascript:saveNew();"></td>
                                                                    <td>&nbsp;</td>
                                                                    <td style="cursor:hand;" width=80px valign="middle" align="center"><img width="76px" src="images/cancel.gif" onClick="window.location='ManningTaskSearch.asp';"></td>
                                                                    <td width=115px>&nbsp;</td>
                                                                </tr>
                                                            </table>
                                                        </td>
                                                    </tr>
                                                </table>                                        
                                            </td>
                                        </tr>
                                    </table>
                                </form>
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
        </table>
    </Body>
    </html>
	<SCRIPT LANGUAGE="JavaScript">
    function saveNew()
    {
        newattached="start";
        stringToCheck = document.frmDetails.currentlyChecked.value
        
        for(var i = 0; i < document.frmPosts.elements.length; i++)
        {
            currentValue=document.frmPosts.elements[i].value;
            
            if(document.frmPosts.elements[i].checked==true)
            {
                if(stringToCheck.indexOf(currentValue) < 0)
                {
                    newattached = newattached + "," + document.frmPosts.elements[i].value;
                }
            }
        }
        
		 //alert("staffId list " + document.frmDetails.newattached.value)
		 
        //document.frmDetails.newattached.value = newattached + document.frmDetails.currentlyChecked.value;
        document.frmDetails.newattached.value = newattached;
       
        
        if(document.frmDetails.newattached.value=="start")
        {
            alert("Select at least one person")
            return;	  		
        } 
        //alert("Tasking these " + newattached);
        document.frmDetails.action="UpdateTaskPersonnelConfirmed.asp";
        document.frmDetails.submit();
    }
    
    </Script>

<%else%>
	<%response.Redirect strGoTo%>
<%end if%>