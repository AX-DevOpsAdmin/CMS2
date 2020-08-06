<!DOCTYPE HTML >

<!--#include file="Includes/security.inc"-->
<!--#include file="Includes/checkadmin.asp"--> 
<!--#include file="Connection/Connection.inc"-->

<%
dim strAction
strAction="Update"

strTable = "tblTask"
strRecid = "taskID"
strGoTo="AdminPsTaDetail.asp"


set objCmd = server.CreateObject("ADODB.Command")
set objPara = server.CreateObject("ADODB.Parameter")
objCmd.ActiveConnection = con
objCmd.CommandType = 4		

set objPara = objCmd.CreateParameter ("nodeID",3,1,0, nodeID)
objCmd.Parameters.Append objPara

' get Task Types
strCommand = "spListTaskTypes"
objCmd.CommandText = strCommand
set rsType = objCmd.Execute

' Get Seperated Service Codes
strCommand = "spListSSC"
objCmd.CommandText = strCommand
set rsSSC = objCmd.Execute

' now find out whether its an HQ Tasking Group - cos if it is then we display HQ Task details
'strCommand = "spCheckHqTask"
'objCmd.CommandText = strCommand
'
'set objPara = objCmd.CreateParameter ("StaffID",3,1,0, session("StaffID"))
'objCmd.Parameters.Append objPara
'set objPara = objCmd.CreateParameter ("HQTasking",3,2)
'objCmd.Parameters.Append objPara
'
'objCmd.Execute	             ' 'Execute CommandText when using "ADODB.Command" object
'strHQTasking   = objCmd.Parameters("HQTasking") 
'objCmd.Parameters.delete ("HQTasking")

' 'Now Delete the parameters
objCmd.Parameters.delete ("nodeID")

strCommand = "sp_TaskDetail"
objCmd.CommandText = strCommand
set objPara = objCmd.CreateParameter ("RecID",3,1,5, request("RecID"))
objCmd.Parameters.Append objPara

set rsRecSet = objCmd.Execute	'Execute CommandText when using "ADODB.Command" object
%>

<html>
<head>

<!--#include file="Includes/IECompatability.inc"-->



<title><%= PageTitle %></title>
<link rel="stylesheet" type="text/css" href="Includes/AMDB.css" media="Screen"/>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">

</head>
<body>
<form action="UpdateTask.asp?GoTo=<%=strGoTo%>" method="post" name="frmDetails">
  <input type="hidden" name="RecID" id="RecID" value="<%=request("RecID")%>"> 
  <Input name="HiddenDate" id="HiddenDate" type="hidden"  >
  <Input name="ooaTask" id="ooaTask" type="hidden" value="0" >
  <Input name="hqTask" id="hqTask" type="hidden" value="0" >
  <input name="strAction" id="strAction" value="<%=strAction%>" type="hidden">

  <table  height="100%" cellspacing=0 cellPadding=0 width=100% border=0>
    <tr>
      <td>
        <!--#include file="Includes/Header.inc"--> 
  		 <table cellSpacing=0 cellPadding=0 width=100% border=0 >
                    <tr style="font-size:10pt;" height=26px>
                        <td width=10><img style="margin-left:10px;" src="cms_icons/png/24x24/process.png" width="24" height="24"></td>
                        <td class="staticdatamenu"><font class="youAreHere">CMS Admin Menu / <strong>Edit Task Details</strong></font></td>
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
					    <td class=toolbar width=8></td>
						<td width=20><a  href="javascript:checkThis();"><img class="imagelink" src="images/saveitem.gif"></A></td>
						<td class=toolbar valign="middle" >Save and Close</td>
                        <td class=titleseparator valign="middle" width=14 align="center">|</td>
						<td class=toolbar valign="middle" ><A class= itemfontlink href="AdminPsTaDetail.asp?RecID=<%=request("RecID")%>">Back</A></td>											
					 </table>
					</td>
			      </tr>
				  <tr>
					<td>
					  <table width=100% border=0 cellpadding=0 cellspacing=0>
						<tr height=16>
						  <td>&nbsp;</td>
						</tr>
						<tr class=columnheading height=22>
						  <td valign="middle" width=2%>&nbsp;</td>
						  <td valign="middle" width=13%>Task:</td>
						  <td valign="middle" width=85%><INPUT class="itemfont" style="WIDTH: 300px" maxLength="200" name="task" id="task" Value="<%=rsRecSet("task")%>"></td>
						</tr>
						<tr class=columnheading height=22>
						  <td valign="middle" width="2%">&nbsp;</td>
						  <td valign="middle" width="13%">Task Type:</td>
						  <td valign="middle" width="85%">                         
						    <select name="TypeID" id="TypeID" class="itemfont">
                              <option value="">...Select...</option>
                               <%do while not rsType.eof %>
                                <option value = "<%= rsType("ttid") %>" <%if (rsType("ttid") = rsRecSet("ttID")) then Response.Write("SELECTED") : Response.Write("")%>  ><%= rsType("description") %></option>
                               <% rsType.movenext
			                   loop%>
                            </select>
                            </td>
					    </tr>
						
						<tr class=columnheading height=22>
						  <td valign="middle" width="2%">&nbsp;</td>
						  <td valign="middle" width="13%">Task SSC:</td>
						  <td valign="middle" width="85%">
						    <select name="sscID" id="sscID" class="itemfont">
                              <option value="0">None</option>
                               <%do while not rsSSC.eof 
							    if int(rsSSC("ssCode")) < 10 then
								     strSSCode= "0" & rsSSC("ssCode")
							    else
								     strSSCode = rsSSC("ssCode")
								end if	 		 
							   %>
                                <option value = "<%= rsSSC("sscid") %>" <%if (rsSSC("sscID") = rsRecSet("sscID")) then Response.Write("SELECTED") : Response.Write("")%>  ><%= strSSCode & "  -  " & rsSSC("description") %></option>
                               <% rsSSC.movenext
			                   loop%>
                            </select>
                            </td>
					    </tr>
					 <tr class=columnheading height=22>
					    <td valign="middle" width=2%>&nbsp;</td>
						<td valign=top width="13%">Task Harmony:</td>
						<td valign="middle" width="85%"><p>
						  <label>
						    <input type="radio" name="rdCond" onClick="checkRadio()" value="0" 
							       <%if rsRecSet("ooa")=0 then%>checked<%End if%> >
						    None
							</label>
						  <br>
						  <label>
						    <input type="radio" name="rdCond" onClick="checkRadio()" value="1" 
							       <%if rsRecSet("ooa")=1 then%>checked<%End if%> >
						    Out Of Area</label>
						  <br>
						  <label>
						    <input type="radio" name="rdCond"   onClick="checkRadio()" value="2"
							   <%if rsRecSet("ooa")=2 then%>checked<%End if%> >
						    Bed Night Away</label>
						  <br>
					    </p></td>
					 </tr>	
					 <tr class=columnheading height=22>
					    <td valign="middle" width=2%></td>
						<td valign="middle" width="13%">Cancellable:</td>
					    <td valign="middle" width="85%" class=itemfont><input type="checkbox" name="cancellable" id="cancellable" value= "1" <% if rsRecSet("cancellable") = true then %>checked<% end if %>></td>
					 </tr>	
					  <tr class=columnheading height=22>
					    <td valign="middle" width=2%>&nbsp;</td>
						<% if strHQTasking = 1 then %>
						  <td valign="middle" width="13%">HQ Task:</td>
					      <td valign="middle" width="85%" class=itemfont><input type="checkbox" name="hq" id="hq" <% if rsRecSet("hqTask") = true then %>checked<% end if %>></td>
						<% end if %>
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
	  
	var tt = document.frmDetails.TypeID.value;
	var t = document.frmDetails.task.value;
	t = t.killWhiteSpace(); 

	/* make sure they have entered comments for the next stage */
	if(tt == 0)
	{
		errMsg += "Task Type\n"
		error = true;
	}

	if(t == "")
	{
		errMsg += "Task"
		error = true;
	}
	
	// Check for HQ Task
	if(document.forms["frmDetails"].elements["hq"] == null)
	{
	}
	else
	{
		if(document.frmDetails.hq.checked == true)
		{
			document.frmDetails.hqTask.value = "1";
		}
	}
	
	if(error == true)
	{
		alert(errMsg)
		return;	  		
	} 
	
    document.frmDetails.submit();  
}

function checkRadio()
{
	var rdo = window.event.srcElement.value
	
	document.frmDetails.ooaTask.value = rdo;
}

</Script>
