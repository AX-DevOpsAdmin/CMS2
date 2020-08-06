<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<!--#include file="Includes/security.inc"--> 
<!--#include file="Connection/Connection.inc"-->

<%

set objCmd = server.CreateObject("ADODB.Command")
set objPara = server.CreateObject("ADODB.Parameter")
objCmd.ActiveConnection = con
objCmd.Activeconnection.cursorlocation = 3
objCmd.CommandType = 4				

squareSize=18
tab=2
' teamID=request("recID")
hrcID=request("recID")
allTeams = request ("allTeams")

Response.CacheControl = "no-cache"
Response.AddHeader "Pragma", "no-cache"
Response.Expires = -1

response.ContentType = "application/vnd.ms-excel"
response.addHeader "content-disposition","attachment;filename=TeamPlanner.xls"



'Set up variables containing dates and put in correct Format
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

newTodaydate= splitDate(0) + " " + theMonth + " " + splitDate(2) 

if request ("thisDate") <>"" then
	thisDate = request ("thisDate")
else
	thisDate = newTodaydate
end if

previousMonth = DateAdd("m",-1,thisDate)
nextMonth = DateAdd("m",1,thisDate)

manipulateDate=formatdatetime(thisDate,1)
splitDate = split (manipulateDate," ")
newMonthYear= splitDate(1)+ " " + splitDate(2)

startOfMonth = "1" & " " & newMonthYear
startOfNextMonth = formatdatetime(dateAdd("m",1,startOfMonth))
startOfNextMonth = formatdatetime(startOfNextMonth,2)
daysCount= DateDiff("d",startOfMonth,startOfNextMonth)
endOfMonth= daysCount & " " & newMonthYear
'***********************************************************

strGoTo = request("fromPage")    

'Get Task Types from Database
objCmd.CommandText = "spListTaskTypesForTasking"
set objPara = objCmd.CreateParameter ("nodeID",3,1,5, nodeID)
objCmd.Parameters.Append objPara
set rsTaskTypes = objCmd.Execute	

for x = 1 to objCmd.parameters.count
	objCmd.parameters.delete(0)
next

' get the chosen Hierrachy name 
objCmd.CommandText = "spGetHierarchyDetail"

set objPara = objCmd.CreateParameter ("hrcID",3,1,5, hrcID)
objCmd.Parameters.Append objPara
set rsHRC = objCmd.Execute	

'Get RecordSet of Unit Memberss for the chosen Hierrachy
objCmd.CommandText = "spGetHierarchyStaff"

'set objPara = objCmd.CreateParameter ("hrcID",3,1,5, hrcID)
'objCmd.Parameters.Append objPara
set objPara = objCmd.CreateParameter ("allTeams",3,1,5, int(allTeams))
objCmd.Parameters.Append objPara
set objPara = objCmd.CreateParameter ("thisDate",200,1,16, thisDate)
objCmd.Parameters.Append objPara
set rsRecSet = objCmd.Execute	

for x = 1 to objCmd.parameters.count
	objCmd.parameters.delete(0)
next



' make sure we set the levelID to EITHER the parent if its Wing/Sqn/Flt or if its a TEAM then the actual teamID
'tmLevel = rsRecSet("teamIn")
'if tmLevel < 4 then
'	tmLevelID = rsRecSet("ParentID")
'else
'	tmLevelID = request("RecID")
'end if

'thisTeam = "Unit: " & rsRecSet("ParentDescription") & " > " & rsRecSet("Description")
thisMonth = " " & (newMonthYear)
intMonth = month(thisDate)
'************************************************

'Set up the date cells with number of days in the month
counter=1

'response.Write("hrcID is " & hrcID & " * " & thisDate & " * " & allteams)
'response.End()

%>


    
    
<style type="text/css">
.style0
	{mso-number-format:General;
	text-align:general;
	vertical-align:bottom;
	white-space:nowrap;
	mso-rotate:0;
	mso-background-source:auto;
	mso-pattern:auto;
	color:windowtext;
	font-size:10.0pt;
	font-weight:400;
	font-style:normal;
	text-decoration:none;
	font-family:Arial;
	mso-generic-font-family:auto;
	mso-font-charset:0;
	border:none;
	mso-protection:locked visible;
	mso-style-name:Normal;
	mso-style-id:0;}
	
.xl25
	{mso-style-parent:style0;
	border-top:none;
	border-right:.5pt solid black;
	border-bottom:.5pt solid black;
	border-left:none;
	white-space:normal;}
	
.xl26
	{mso-style-parent:style0;
	border-top:.5pt solid black;
	border-right:.5pt solid black;
	border-bottom:.5pt solid black;
	border-left:none;
	white-space:normal;}
	
.xl27
	{mso-style-parent:style0;
	border-top:.5pt solid black;
	border-right:.5pt solid black;
	border-bottom:none;
	border-left:none;
	white-space:normal;}
	
.xl28
	{mso-style-parent:style0;
	border-top:.5pt solid black;
	border-left:.5pt solid black;
	border-right:.5pt solid black;
	border-bottom:.5pt solid black;
	white-space:normal;}
	
</style>

 
<table border="0" cellpadding="0" cellspacing="0">
	<tr>
    	<td colspan="34"></td>
    </tr>
	<tr>
    	<td colspan="34"></td>
    </tr>
    <tr>
    	<td>&nbsp;</td>
    	<td colspan="<%=daysCount%>" align="center" style="font:bold; color:#0000FF"><%=rsHRC("hrcname")%> &nbsp; <%=monthname(intMonth)%>&nbsp;<%=year(thisDate)%></td>
    </tr>
	<tr>
    	<td colspan="34">&nbsp;</td>
    </tr>
    <tr height="20">
        <td width="250" class="xl25">&nbsp;</td>
        <% counter = 1 %>
        <% do while counter <= daysCount %>
            <% tempDate = counter & " " & newMonthYear %>
            <td width="21" align="center" class="xl26" style="width:16pt;"
                <% if weekday(tempDate) = 1 or weekday(tempDate) = 7 then %>
                    <% colour = "#666666" %>
                <% else %>
                    <% colour = "#CCCCCC" %>
                <% end if %>
                bgcolor="<%= colour %>"><%= counter %>
                <% counter = counter + 1 %>
            </td>
        <% loop %>
        <td>&nbsp;</td>
        <td colspan="2"><u>Key:</u></td>
    </tr>
   
    <% set rsRecSet = rsRecSet.nextrecordset %>
    <% intCount = 0 %>
    <% do while not rsRecSet.eof
        objCmd.CommandText = "spStaffTaskDetails"	
        objCmd.CommandType = 4				
        set objPara = objCmd.CreateParameter ("startDate",200,1,30, startOfMonth)
        objCmd.Parameters.Append objPara
        set objPara = objCmd.CreateParameter ("endDate",200,1,30,endOfMonth)
        objCmd.Parameters.Append objPara
    
        set objPara = objCmd.CreateParameter ("staffID",3,1,0,rsRecSet("staffID"))
        objCmd.Parameters.Append objPara
        set rsBusyDates = objCmd.Execute
    
        for x = 1 to objCmd.parameters.count
            objCmd.parameters.delete(0)
        next %>

        
        <tr height="20">
            <% if rsBusyDates.recordcount < 1 then %>
            
                <td width="250" class="xl25"><%= (rsRecSet("personnel")) %></td>
                <% counter = 1
                do while counter <= daysCount %>
                    <td width="20" class="xl26" bgcolor="#CBE9D1">&nbsp;</td>
                    <% counter = counter + 1 %>
                <% loop %>
            <% else %>
           
                <td width="250" class="xl25"><%= (rsRecSet("personnel")) %></td>
				<% counter = 1
                datecount = 0
                occurences = rsBusyDates.recordCount - 1
                do while counter <= daysCount
                    tempDate = counter & " " & newMonthYear %>
                    <td width="20" class="xl26" 
                        <% if cdate(formatdatetime(tempDate,2)) >=  cdate(formatdatetime(rsBusyDates("startDate"),2)) and cdate(formatdatetime(tempDate,2)) <=  cdate(formatdatetime(rsBusyDates("endDate"),2)) then %>
                            <% colour = rsBusyDates("taskcolor") %>
                        <% else %>
                            <% colour = "#CBE9D1" %>
                        <% end if %>
                        bgcolor="<%= colour %>">
                        <% if datecount < occurences then
                            if formatdatetime(tempDate,2) = formatdatetime(rsBusyDates("endDate"),2) then
                            	rsBusyDates.movenext
                                datecount = datecount + 1
                            end if
                        end if
                        counter = counter + 1 %>
          			</td>
                <% loop %>
            <% end if 	%>
            
             
            <td width="20">&nbsp;</td>
            
            <% if not rsTaskTypes.eof then %>
                <td bgcolor="<%=rsTaskTypes("taskcolor")%>" width="20" class="xl28">&nbsp;</td>
                <td><%=rsTaskTypes("description")%></td>
                <%rsTaskTypes.movenext%>
            <% elseif rsTaskTypes.eof and intCount < 1 then %>
            	<td bgcolor="#FFF" width="20" class="xl28">&nbsp;</td>
                <td>Posted</td>
               	<% intCount = intCount + 1 %>
            <% end if %>
          
        </tr>
         <% rsRecSet.movenext %>
    <% loop %>
    <tr height="20">
        <td width="250" class="xl27">&nbsp;</td>
        <% counter = 1 %>
        <% do while counter <= daysCount %>
            <% tempDate = counter & " " & newMonthYear %>
            <td width="20" align="center" class="xl26"
                <% if weekday(tempDate) = 1 or weekday(tempDate) = 7 then %>
                    <% colour = "#666666" %>
                <% else %>
                    <% colour = "#CCCCCC" %>
                <% end if %>
                bgcolor="<%= colour %>"><%= counter %>
                <% counter = counter + 1 %>
            </td>
        <% loop %>
        <td width="20">&nbsp;</td>
        <% if rsRecset.recordcount < rsTaskTypes.recordcount then %>
            <td bgcolor="<%= rsTaskTypes("taskcolor")%>" class="xl28">&nbsp;</td>
            <td><%=rsTaskTypes("description")%></td>
            <% rsTaskTypes.movenext %>
        <% end if %>
    </tr>
	<% if rsRecset.recordcount < rsTaskTypes.recordcount then %>
		<% while not rsTaskTypes.eof %>
            <tr height="20">
                <td>&nbsp;</td>
                <td colspan="<%=daysCount%>">&nbsp;</td>
                <td>&nbsp;</td>
                <td bgcolor="<%=rsTaskTypes("taskcolor")%>" class="xl28">&nbsp;</td>
                <td><%=rsTaskTypes("description")%></td>
            </tr>
            <% rsTaskTypes.movenext %>
        <% wend %>
        <tr height="20">
            <td>&nbsp;</td>
            <td colspan="<%=daysCount%>">&nbsp;</td>
            <td>&nbsp;</td>
            <td bgcolor="#FFFFFF" class="xl28">&nbsp;</td>
            <td>Posted</td>
        </tr>
    <% end if %>    
</table>
