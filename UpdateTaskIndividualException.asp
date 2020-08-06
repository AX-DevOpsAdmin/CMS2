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

Dim objUpload
Dim strFileName
Dim strPath
dim strFiles
dim strList

strRecID = request("RecID")
strGoTo = request("ReturnTo") & "?RecID=" & strRecid

IF Request("newattached") <> "" THEN
	strList = Request("newAttached")
	strNewStations = split(strList, ",")
	
	FOR intCount = 1 TO (UBound(strNewStations))

		'set comcommand=server.createobject("ADODB.command")
		'comcommand.CommandText = "declare @StaffID int set @StaffID= (select staffId from tblStaff where serviceNo = '"& strNewStations(intCount) &"') INSERT  into tbl_TaskStaff select taskID, @StaffID  , startDate,endDate,cancellable from tbl_Task where taskID= '"& strRecID &"'"
		'comcommand.Activeconnection = con
		'comcommand.Execute
		
		objCmd.CommandText = "spTaskPersonnelAdd"	
		objCmd.CommandType = 4
						
		set objPara = objCmd.CreateParameter ("TaskID",3,1,0, request("RecID"))
		objCmd.Parameters.Append objPara
		set objPara = objCmd.CreateParameter ("serviceNo",200,1,50, strNewStations(intCount))
		objCmd.Parameters.Append objPara
		set objPara = objCmd.CreateParameter ("currentUser",3,1,0, session("staffID"))
		objCmd.Parameters.Append objPara
		set objPara = objCmd.CreateParameter ("StartDate",200,1,16, request("startDate"))
		objCmd.Parameters.Append objPara
		set objPara = objCmd.CreateParameter ("EndDate",200,1,16, request("endDate"))
		objCmd.Parameters.Append objPara
		objCmd.Execute	
		
		
		response.write userAddedStatus
		for x = 1 to objCmd.parameters.count
			objCmd.parameters.delete(0)
		next
	NEXT 
END IF
		objCmd.CommandText = "spTaskPersonnelCheck"	
		objCmd.CommandType = 4				
		set objPara = objCmd.CreateParameter ("TaskID",3,1,0, request("RecID"))
		objCmd.Parameters.Append objPara
		set objPara = objCmd.CreateParameter ("currentUser",200,1,50, Request.ServerVariables("LOGON_USER"))
		objCmd.Parameters.Append objPara
		set RSList = objCmd.Execute	
		''response.write RSList.recordCount
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

<head> <title>Task Details</title>
<link rel="stylesheet" type="text/css" href="Includes/AMDB.css" media="Screen"/>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1"><style type="text/css">
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
</style></head>
<body>
<form   action="" method="post" name="frmDetails" onSubmit="javascript:return(CheckForm());">
    <Input name="RecID" id="RecID" type="hidden" value=<%=request("RecID")%>>
    <input name="newattached" id="newattached"  type="hidden" value="">
    <input name="ReturnTo" id="ReturnTo"  type="hidden"  value="ManningTaskPersonnel.asp">
    <Input name="DoSearch" id="DoSearch" type="hidden" value=1>
    <Input name="Page"  id="Page" type="hidden" value=1>
    <Input name="HiddenDate"  id="HiddenDate" type="hidden" >
    <input name="currentlyChecked"  id="currentlyChecked"  type=hidden value=<%=request("currentlyChecked")%>>
    <input name ="criteriaChange" id="criteriaChange" type=hidden value=0>
    <Input name="StartDate" id="StartDate" type="hidden" value="<%=request("startDate")%>">
    <Input name="EndDate" id="EndDate" type="hidden" value="<%=request("endDate")%>">

  	<table  height="100%" cellspacing=0 cellPadding=0 width=100% border=0>
        <tr>
          <td>
            <!--#include file="Includes/Header.inc"-->
            <table cellSpacing=0 cellPadding=0 width=100% border=0 >
              <tr >
                <td align="center" class="sidemenuwidth" ><img alt="" src="images/spssites.gif" ></td>
                <td  class=titlearea >Tasking<BR><span class="style1"><Font class=subheading>Task Details</Font></span></td>
              </tr>
              <tr>
                <td colspan=2 class=titlearealine  height=1></td> 
              </tr>
            </table>
            <table width=100% height='<%=session("heightIs")%>px' border=0 cellpadding=0 cellspacing=0 > 
              <tr valign=Top>
                <td class="sidemenuwidth" background="Images/tableback.png">
                  <table  border=0 cellpadding=0 cellspacing=0 class=MenuStyleParent>
                    <tr height=20>
                      <td ></td><td colspan=3 align=left height=20>Current Location</td>
                    </tr>
                    <tr height=20>
                      <td width=10></td>
                      <td width=18 valign=top><img src="images/arrow.gif"></td>
                      <td width=170 align=Left  ><A title="" href="index.asp">Home</A></td>
                      <td width=50 align=Left  ></td>
                    </tr>
                    <tr height=20>
                      <td  ></td>
                      <td valign=top><img src="images/arrow.gif"></td>
                      <td align=Left  ><A title="" href="ManningDataMenu.asp">Manning</A></td>
                      <td align=Left  ></td>
                    </tr>
                    <tr height=20>
                      <td ></td>
                      <td valign=top><img src="images/arrow.gif"></td>
                      <td align=Left  ><A title="" href="ManningTaskSearch.asp">Tasking</a></td>
                      <td align=Left  ></td>
                    </tr>
                    <tr height=20>
                      <td ></td>
                      <td valign=top><img src="images/vnavicon.gif"></td>
                      <td align=Left bgcolor="#FFFFFF"><Div style="height:18px; border:Solid; border-width:1px; border-color:#438BE4; color: #003399;">Task Details</Div></td>
                      <td class=rightmenuspace align=Left ></td>
                    </tr>
                    <tr height=20>
                      <td ></td>
                      <td valign=top><img src="images/vnavicon.gif"></td>
                      <td align=Left  ><A title="" href="ManningTaskEdit.asp?RecID=<%=request("RecID")%>&fromPage=<%="Manning"%>">Edit Task</A></td>
                      <td align=Left  ></td>
                    </tr>
                    <tr height=20>
                      <td ></td>
                      <td valign=top><img src="images/vnavicon.gif"></td>
                      <td align=Left  ><A title="" href="ManningNewTask.asp?fromPage=<%=strFrom%>">Create Task</A></td>
                      <td align=Left  ></td>
                    </tr>
                    <tr height=20>
                      <td ></td>
                      <td valign=top><img src="images/vnavicon.gif"></td>
                      <td align=Left  ><A title="" href="ManningTaskPersonnel.asp?RecID=<%=request("RecID")%>">Tasked Personnel</A></td>
                      <td align=Left  ></td>
                    </tr>
                  </table>
                </td>
                <td width=16px></td>
                <td align=left >
                  <table border=0 cellpadding=0 cellspacing=0 width=100%>
                    <tr height=16 class=SectionHeader>
                      <td>
                        <table border=0 cellpadding=0 cellspacing=0 >
                            <td class=toolbar width=8></td>
                            <% IF strManager = "1" THEN %>          
                            <td class=toolbar width=8></td><td width=20><a class=itemfontlink href="ManningTaskEdit.asp?RecID=<%=request("RecID")%>&fromPage=<%=strFrom%>"><img class="imagelink" src="images/editgrid.gif"></A></td>
                            <td class=toolbar valign="middle" >Edit Task</td>
                            <td class=titleseparator valign="middle" width=14 align="center">|</td>
                            <td class=toolbar width=8></td><td width=20><a class=itemfontlink href="ManningTaskPersonnel.asp?RecID=<%=request("RecID")%>"><img class="imagelink" src="images/editgrid.gif"></A></td>
                            <td class=toolbar valign="middle" >Personnel</td>
                            <% IF strDelOK = "0" THEN %>
                            <td class=titleseparator valign="middle" width=14 align="center">|</td>
                            <td class=toolbar width=8></td><td width=20><a class=itemfontlink href="DeleteRec.asp?RecID=<%=request("recID")%>&TableName=<%=strTable%>&TabId=<%=strTabID%>&GoTo=<%=strGoTo%>" onClick="javascript:return(checkDelete());"><img class="imagelink" src="images/delitem.gif"></A></td>
                            <td class=toolbar valign="middle" >Delete Task</td>
                            <%END IF %>
                            <td class=titleseparator valign="middle" width=14 align="center">|</td>
                            <%END IF%>
                            <td class=toolbar valign="middle" ><A class=itemfontlink href="ManningTaskSearch.asp">Back To List</A></td>											
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
                            <td valign="middle" width=12%>Task:</td>
                            <td valign="middle" width=83% class=itemfont><%=rsRecSet("Task")%></td>
                            <td valign="middle" width=3%></td>
                          </tr>
                          <tr class=columnheading height=22>
                            <td valign="middle" width=2%></td>
                            <td valign="middle"  >Task Type:</td>
                            <td valign="middle"  class=itemfont ><%=rsRecSet("Type")%></td>
                            <td></td>
                          </tr>
                          <tr class=columnheading height=22>
                            <td valign="middle" width=2%></td>
                            <td valign="middle"  >Start Date:</td>
                            <td valign="middle"  class=itemfont ><%=request("startDate")%></td>
                            <td></td>
                          </tr>
                          <tr class=columnheading height=22>
                            <td valign="middle" width=2%></td>
                            <td valign="middle"  >End Date:</td>
                            <td valign="middle"  class=itemfont ><%=request("endDate")%></td>
                            <td></td>
                          </tr>
                          <tr class=columnheading height=22>
                            <td valign="middle" width=2%></td>
                            <td valign="middle">Cancellable:</td>
                            <td  width=83% class=itemfont>
                            <%if rsRecSet("cancellable")=true then%>
                                         Yes
                                         <%Else%>
                                         No
                                         <%End if%> 
                            </td>
                         </tr>	
                          
                          <tr height=16>
                            <td></td>
                          </tr>
                          <tr>
                            <td colspan=5 class=titlearealine  height=1></td> 
                          </tr>
                </Form>
                <form  action="" method="post" name="frmPosts">
                        <tr height=16 class=SectionHeader>
                          <td colspan=5>
                            <table border=0 cellpadding=0 cellspacing=0 >
                                <tr>
                                    <td class=toolbar width=8></td>
                                    <td class=toolbar valign="middle" ><font color=#ff0000>!! Warning !! </font>The Personnel below are already assigned to the listed tasks:</td>
                                </tr>
                            </table>
                          </td>
                        </tr>
    
                        <tr height=16 >
                          <td colspan=5>
                          </td>
                        </tr>
    
    
                          <tr>
                            <td colspan=5 >
                                <table  width=900px border=0 cellpadding=0 cellspacing=0 border=0>
                                <tr class=columnheading height=20>
                                  <td valign="middle" align="center" width=8%>Overwrite</td>
    
                                  <td valign="middle" width=2%></td>
                                  <td valign="middle" width=15%>Surname</td>
                                  <td valign="middle"  width=15%>Firstname</td>
                                  <td valign="middle"  width=15%>Service No</td>
                                  <td width=2%></td>
                                  <td valign="middle" width=13%>Existing Task</td>
                                  <td valign="middle" align="center" width=8%>Start Date</td>
                                  <td valign="middle" align="center" width=8%>End Date</td>
                                  
    
                                <td width="5%"></td>
                                </tr>
                                  <tr>
                                    <td colspan=10 class=titlearealine  height=1></td> 
                                  </tr>
                                <%tempServiceNo =""%>
                                <%do while not RSList.eof%>
                                    <%if tempServiceNo<>RSList("serviceno") then%>
                                        <%if counter=0 then
                                            counter=1
                                            else
                                                if counter=1 then counter=0
                                            end if%>
                                    <%end if%>
                                <%if tempServiceNo<>RSList("serviceno") and tempServiceNo<> "" then%>
                                  <tr>
                                    <td colspan=10   height=10></td> 
                                  </tr>
                                  <tr>
                                    <td colspan=10 class=titlearealine  height=1></td> 
                                  </tr>
    
                                 <%end if%>
                                
                                <tr class=itemfont  height=20 <%if counter=0 then%>style="background-color:<%=color1%>;"<%else%>style="background-color:<%=color2%>;"<%end if%>>
                                    <td valign="middle" align="center" <%if tempServiceNo=RSList("serviceno")  then%>style="background-color:#ffffff"<%end if%>><%if tempServiceNo<>RSList("serviceno")  then%><input type="checkbox"  name=StaffID<%=RSList("StaffID")%> value=<%=RSList("serviceno")%>><%end if%></td>
    
                                    <td valign="middle" <%if tempServiceNo=RSList("serviceno")  then%>style="background-color:#ffffff"<%end if%>></td>
                                    <td <%if tempServiceNo=RSList("serviceno")  then%>style="background-color:#ffffff"<%end if%>><%if tempServiceNo<>RSList("serviceno") then response.write RSList("surname")%></td>
                                    <td <%if tempServiceNo=RSList("serviceno")  then%>style="background-color:#ffffff"<%end if%>><%if tempServiceNo<>RSList("serviceno") then response.write  RSList("firstname")%></td>
                                    <td <%if tempServiceNo=RSList("serviceno")  then%>style="background-color:#ffffff"<%end if%>><%if tempServiceNo<>RSList("serviceno") then response.write RSList("serviceno")%></td>
                                    <td width=2%></td>
                                    <td><%=RSList("description")%></td>
                                    <td align="center"><%=RSList("startDate")%></td><td align="center"><%=RSList("endDate")%></td>
    
                                    <td valign="middle" ></td>
                                </tr>
    
                                  <tr>
                                    <%if tempServiceNo<>RSList("serviceno")  then%>
                                        <td colspan=10 class=titlearealine  height=1></td> 
                                    <%else%>
                                        <td colspan=5></td><td colspan=6 class=titlearealine  height=1></td> 
                                    
                                    <%end if%>
                                  </tr>
                                  
                                <%
                                Row=Row+1
                                tempServiceNo=RSList("serviceno")
                                RSList.movenext
    
                                loop%>
                            <tr height=16 >
                          <td colspan=10>
                          </td>
                        </tr>
                          <tr>
                            <td colspan=10 align="center">
                                <table  width=200px border=0 cellpadding=0 cellspacing=0 >
                                <tr height=20 class=SectionHeader>
                                  <td class=toolbar valign="middle" align="center"><A class=itemfontlink href="javascript:saveNew();">Continue</A></td>
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
         </td>
        </tr>
  </table>
</Form>
</Body>
</html>
<SCRIPT LANGUAGE="JavaScript">
function saveNew(){
    /* now build the section list - if any - to be removed */

/* now build hidden value with list of Locations to submit so the 
program writelocations can update database */
	newattached="start";
	stringToCheck = document.frmDetails.currentlyChecked.value
	for (var i = 0; i < document.frmPosts.elements.length; i++){
		currentValue=document.frmPosts.elements[i].value;
		if (document.frmPosts.elements[i].checked==true) {
			if (stringToCheck.indexOf(currentValue)<0){
				newattached = newattached + "," + document.frmPosts.elements[i].value;
			}
		}
	}
    document.frmDetails.newattached.value = newattached + document.frmDetails.currentlyChecked.value;
	
	if(document.frmDetails.newattached.value=="start") {
	alert("Select at least one post")
	return;	  		
} 

document.frmDetails.action="UpdateTaskPersonnelConfirmed.asp";
//alert(document.frmDetails.action);
document.frmDetails.submit();
}
</Script>

		<%else%>
			<%response.Redirect strGoTo%>
		<%end if%>