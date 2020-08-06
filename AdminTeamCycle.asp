<!DOCTYPE HTML >
<!--#include file="Includes/security.inc"--> 
<!--#include file="Includes/checkadmin.asp"-->
<!--#include file="Connection/Connection.inc"-->
<%
' sets date to UK format - dmy
session.lcid=2057

' parameters for the Delete Option
strTable = "tblTeam"    ' tablename
strFrom= request("fromPage")
IF strFrom = "Manning" THEN
  strGoTo = "ManningTeamSearch.asp"   ' asp page to return to once record is deleted
ELSE
  strGoTo = "AdminTeamList.asp"   ' asp page to return to once record is deleted
END IF
  
strTabID = "teamID"              ' key field name for table        

' Basic ADO Commands
set objCmd = server.CreateObject("ADODB.Command")
set objPara = server.CreateObject("ADODB.Parameter")
objCmd.ActiveConnection = con
objCmd.CommandType = 4				'Code for Stored Procedure

' First get all the Cycle details
objCmd.CommandText = "spGetAllCycles"	'Name of Stored Procedure
set rsCycle = objCmd.Execute	'Execute CommandText when using "ADODB.Command" object

' now get all the Cycle Stages
objCmd.CommandText = "spGetAllStages"	'Name of Stored Procedure
set rsStage = objCmd.Execute	'Execute CommandText when using "ADODB.Command" object

' first get the Team details
set objPara = objCmd.CreateParameter ("TeamID",3,1,5, request("RecID"))
objCmd.Parameters.Append objPara
objCmd.CommandText = "spTeamDetail"	'Name of Stored Procedure
set rsRecSet = objCmd.Execute	'Execute CommandText when using "ADODB.Command" object

' Now get the Cycle Stage the Team is currently in
objCmd.CommandText = "spTeamCurrStage"	'Name of Stored Procedure
set objPara = objCmd.CreateParameter ("CurrStage",3,2)
objCmd.Parameters.Append objPara
set objPara = objCmd.CreateParameter ("teamCycle",200,2, 20)
objCmd.Parameters.Append objPara
set objPara = objCmd.CreateParameter ("teamStage",200,2, 20)
objCmd.Parameters.Append objPara
set objPara = objCmd.CreateParameter ("endDate",200,2,20)
objCmd.Parameters.Append objPara
objCmd.Execute	'Execute CommandText when using "ADODB.Command" object

strCurrStage = objCmd.Parameters("CurrStage")
strEndDate =   objCmd.Parameters("endDate")

' now see if we can delete it - if it has no children then we can
' return parameter for Delete check
'objCmd.CommandText = "spTeamDel"	'Name of Stored Procedure
'set objPara = objCmd.CreateParameter("@DelOK",3,2)
'objCmd.Parameters.Append objPara
'objCmd.Execute	

'CREATE   PROCEDURE dbo.spGetCyclesAndStages
'SELECT tblCycle.cyID AS cycleID, tblCycle.Description AS Cycle, tblCycleStage.cysID AS stageID, 
'       tblCycleStage.description AS Stage, tblCycleSteps.cytStep AS Step, tblCycleSteps.cyID AS stcyID,
'       tblCycleSteps.cysID AS stcysID, tblCycleSteps.cytID

'strDelOK = objCmd.Parameters("@DelOK")

%>



<html>

<head> 

<!--#include file="Includes/IECompatability.inc"-->
<title><%= PageTitle %></title>
<link rel="stylesheet" type="text/css" href="Includes/AMDB.css" media="Screen"/>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
</head>
<body>
<div id="overDiv" style="position:absolute; visibility:hidden; z-index:1000;"></div>
<form   action="UpdateTeamCycle.asp?goTo=<%=strGoTo%>" method="post" name="frmDetails" >
  <input type=hidden name=recID value=<%=request("recID")%>>
  <input type=hidden name=currStage value=<%=strCurrStage%>>
  <table  height="100%" cellspacing=0 cellPadding=0 width=100% border=0>
    <tr>
      <td>
        <!--#include file="Includes/Header.inc"-->
		<table cellSpacing=0 cellPadding=0 width=100% border=0 >
                    <tr style="font-size:10pt;" height=26px>
                        <td width=10><img style="margin-left:10px;" src="cms_icons/png/24x24/process.png" width="24" height="24"></td>
                        <td class="staticdatamenu"><font class="youAreHere">CMS Admin Menu / <strong>Team Cycle Details</strong></font></td>
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
						<td width=20><a  href="javascript:checkThis();"><img class="imagelink" src="images/saveitem.gif" width="16" height="16"></A></td>
						<td class=toolbar valign="middle" >Save and Close</td><td class=titleseparator valign="middle" width=14 align="center">|</td>
						<td class=toolbar valign="middle" ><A class= itemfontlink href="<%=strGoTo%>?RecID=<%=request("RecID")%>">Back</A></td>											
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
						<td valign="middle" width="85%" class=itemfont><%=rsRecSet("Description")%></td>
					  </tr>
					  <tr class=columnheading height=22>
			            <td valign="middle" width=2%>&nbsp;</td>
						<td valign="middle" width="13%">Parent Type:</td>
						<td valign="middle" width="85%" class=itemfont ><%=rsRecSet("TeamInName")%></td>
					  </tr>
					  <tr class=columnheading height=22>
			            <td valign="middle" width=2%>&nbsp;</td>
						<td valign="middle" width="13%">Parent:</td>
						<td valign="middle" width="85%" class=itemfont ><%=rsRecSet("ParentDescription")%></td>
					  </tr>
					  <tr class=columnheading height=22>
			            <td valign="middle" width=2>&nbsp;</td>
						<td valign="middle" width="13%">Team Size:</td>
						<td valign="middle" width="85%" class=itemfont ><%=rsRecSet("Teamsize")%></td>
					  </tr>
					  <tr class=columnheading height=22>
			            <td valign="middle" width=2%>&nbsp;</td>
						<td valign="middle" width="13%">Team Weight:</td>
						<td valign="middle" width="85%" class=itemfont ><%=rsRecSet("Weight")%></td>
					  </tr>
					  <tr height=16>
						<td></td>
					  </tr>
    		          <tr class=columnheading height=22>
					    <td valign="middle" width=2%>&nbsp;</td>
						<td valign="middle" width="13%">Team Cycle:</td>
					    <td valign="middle" width=85% class=itemfont>
                               <select name="cmbCycle"   class="pickbox" id="cyID"  onChange="findStages()" >
							     <option value = "" >
                                 <%do while not rsCycle.eof%>
                                 <option value = "<%= rsCycle("cyID") %>"<%if (rsCycle("cyID") = rsRecSet("cycleID")) then Response.Write("SELECTED") : Response.Write("")%>><%= rsCycle("description") %>
                                 </option>
                                 <% rsCycle.movenext
			                     loop%>
                          </select>
                        </td>
					 </tr>	
					 <tr class=columnheading height=22>
			            <td valign="middle" width=2%>&nbsp;</td>
						<td valign="middle" width="13%">Cycle Started:</td>
						<td valign="middle" width="85%"><input name="T1" type="text" class="itemfont" value="<%=rsRecSet("cycleStart")%>" size="20" readonly onclick="calSet(this)" style="width:75px;">&nbsp;<img src="Images/cal.gif" width=16 height=16 border=0 onclick="calSet(T1)"></td>
					  </tr>
					  <tr height=4>
						<td></td>
					  </tr>
					 <tr class=columnheading height=22>
					 	<td valign="middle" width=2%>&nbsp;</td>
						<td valign="middle" width="13%">Current Stage:</td>
						<td valign=middle width=85% class=itemfont>
						  <select name="cmbStage"   class="pickbox" id="cysID" onChange="addAttached()">
			              </select>
						</td>
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
<%
rsRecSet.close
set rsRecSet=Nothing
con.close
set con=Nothing
%>
</body>
<!-- Build the array for the Cycle stages so we don't have to re-submit the form everytime Cycle changes -->
<script language=JScript>
	var dataArray = new Array();
	<%intcount = 0
		While (NOT rsStage.EOF)
		%>
			dataArray[<%=intcount%>] = "<%=rsStage("cyID")%>*<%=rsStage("cysID")%>*<%=rsStage("Stage")%>";
			//alert("data is " + dataArray[<%=intcount%>]);
			<%intcount = intcount + 1
			rsStage.movenext
		wend%>		

</script>

<script type="text/javascript" src="calendar.js"></script>
</html>

<SCRIPT LANGUAGE="JavaScript">
// Now make sure the Cycle Stages are populated or the current cycle - if there is one
if (document.getElementById("cyID").value != "") {
   findStages();
   }
   
function checkDelete(){
     var delOK = false 
    
	  var input_box = confirm("Are you sure you want to delete this Record ?")
	  if(input_box==true) {
		    delOK = true;
	    }
    return delOK;
}

function findStages(){
	var locID=document.getElementById("cyID").value;
	var curstage= document.frmDetails.currStage.value; 
	var strSplit = "";
	
	document.getElementById("cysID").length=0;
	//document.getElementById("cysID").options[0]=new Option("Please select the Cycle","");
	var counter  = 0;
	
	for(i=0;i<dataArray.length;i++)
	{
 		strSplit=dataArray[i].split("*");
		if (strSplit[0]==locID)
		{
			document.frmDetails.cmbStage.options[counter]=new Option(strSplit[2],strSplit[0]+"*"+strSplit[1]);
			// if its the current stage then display it
			if (strSplit[1]==curstage) {
			   //alert ("Stages are " +  dataArray[i] + " ** " + curstage);
			   document.frmDetails.cmbStage.options[counter].selected=true
			   }
			//alert ("Stages are " +  dataArray[i] + " ** " + curstage);
			counter++;
		}
	}
	
}

function checkThis(){

     var txtfnm = document.frmDetails.cmbCycle.value;
	 var txtsnm = document.frmDetails.cmbStage.value; 
	 var txtarr = document.frmDetails.T1.value;
	 
     var errMsg = "";
	  
	/* make sure they have entered all details for the next stage */
    if(!txtfnm.length > 0) {
	   errMsg += "You must Choose a Cycle\n"
	   document.frmDetails.txtfname.focus(); 
	   }
    if(!txtsnm.length > 0) {
	   errMsg += "You must must Choose a Stage n"
	   document.frmDetails.txtsname.focus(); 
	   }

if(!errMsg=="") {
	  alert(errMsg)
	  return;	  		
	} 
	
    document.frmDetails.submit();  
}

</Script>
