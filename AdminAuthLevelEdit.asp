<!DOCTYPE HTML >

<!--#include file="Includes/security.inc"--> 
<!--include file="Includes/checkadmin.asp"-->
<!--#include file="Connection/Connection.inc"-->
<!--#include file="Includes/authsecurity.inc"-->

<%
'
''If user is not valid Authorisation Administrator then log them off
'If session("authadmin") <> 1 then
'	Response.redirect("noaccess.asp")
'End If

dim strAction
dim strTable

'strAction="Update"
'strTable = "tblAuthsType"
'strRecID = "atpID"
'strCommand = "spRecDetail"
'

set objCmd = server.CreateObject("ADODB.Command")
set objPara = server.CreateObject("ADODB.Parameter")
objCmd.ActiveConnection = con
objCmd.Activeconnection.cursorlocation = 3
objCmd.CommandType = 4		

' default to tblRank ndeID=1
strAction="Update"
strTable = "tblRank" 
strCommand = "spListTable"

objCmd.CommandText = strCommand
set objPara = objCmd.CreateParameter ("nodeID",3,1,0, 1)
objCmd.Parameters.Append objPara	
set objPara = objCmd.CreateParameter ("TableName",200,1,50, strTable)
objCmd.Parameters.Append objPara

set rsRank = objCmd.Execute	

for x = 1 to objCmd.parameters.count
	objCmd.parameters.delete(0)
next

'response.write ("here we are ranks " & request("lvlID"))
'response.End()

' default to tblRank ndeID=1
strTable = "tblAuthsLevel" 
strCommand = "spListTable"

objCmd.CommandText = strCommand
set objPara = objCmd.CreateParameter ("nodeID",3,1,0, 1)
objCmd.Parameters.Append objPara	
set objPara = objCmd.CreateParameter ("TableName",200,1,50, strTable)
objCmd.Parameters.Append objPara

set rsLvl = objCmd.Execute	

for x = 1 to objCmd.parameters.count
	objCmd.parameters.delete(0)
next

strCommand = "spGetAuthLevel"

objCmd.CommandText = strCommand
set objPara = objCmd.CreateParameter ("RecID",3,1,1, request("lvlID"))
objCmd.Parameters.Append objPara

set rsRecSet = objCmd.execute	'Execute CommandText when using "ADODB.Command" object

'response.write( rsRank("shortdesc") & " * "  & rsLvl("authlevel") & " * " & rsRecset("authlevel"))

%>

<html>
<head>

<!--#include file="Includes/IECompatability.inc"-->



<title><%= PageTitle %></title>
<link rel="stylesheet" type="text/css" href="Includes/AMDB.css" media="Screen"/>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
</head>
<body>

<form  action="UpdateAuthLevel.asp?strAction=<%=strAction%>" method="POST" name="frmDetails">
	<input type="hidden" name="RecID" id="RecID" value="<%= request("lvlID") %>"> 
    <input type="hidden" name="lvlRankID" id="lvlRankID" value="<%=rsRecset("lvlRankID")%>"> 
    <input type="hidden" name="authlevel" id="authlevel" value="<%=rsRecset("authlevel")%>">
    <input type="hidden" name="speciallevel" id="speciallevel" value="<%=rsRecset("splvlID")%>">
     
    <table  height="100%" cellspacing=0 cellPadding=0 width=100% border=0>
    	<tr>
    		<td>
    			<!--#include file="Includes/Header.inc"--> 
    				<table cellSpacing=0 cellPadding=0 width=100% border=0 >
                    <tr style="font-size:10pt;" height=26px>
                        <td width=10><img style="margin-left:10px;" src="cms_icons/png/24x24/process.png" width="24" height="24"></td>
                        <td class="staticdatamenu"><font class="youAreHere">CMS Admin Menu / <strong>Edit Authorisation Level</strong></font></td>
                    </tr>
                    <tr><td colspan=2 class=titlearealine  height=1></td></tr>
				</table>
          
            <!--<table width=100% height='<%'=session("heightIs")%>px' border=0 cellpadding=0 cellspacing=0> -->
            <table style="height:900px;" width=100% height="328" border=0 cellpadding=0 cellspacing=0> 
      		<tr valign=Top>
        	  <td class="sidemenuwidth" background="Images/tableback.png"><!--#include file="Includes/authmenu.inc"--></td>
                        <td width=16></td>
                        <td align=left>
                            <table border=0 cellpadding=0 cellspacing=0 width=100%>
                                <tr height=16 class=SectionHeader>
                                    <td>
                                        <table border=0 cellpadding=0 cellspacing=0>
                                            <tr>
                                                <td class=toolbar width=8></td>
                                                <td width=20><a href="javascript:checkThis();"><img class="imagelink" src="images/saveitem.gif"></A></td>
                                                <td class=toolbar valign="middle">Save and Close</td>
                                                <td class=titleseparator valign="middle" width=14 align="center">|</td>
                                                <td class=toolbar valign="middle"><a class= itemfontlink href="AdminAuthLevelDetail.asp?lvlID=<%=request("lvlID")%>">Back</a></td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <table width=100% border=0 cellpadding=0 cellspacing=0>
                                            <tr height=16>
                                                <td colspan="4">&nbsp;</td>
                                            </tr>
                                            <tr class=columnheading height=22>
                                                <td valign="middle" width=1%>&nbsp;</td>
                                                <td valign="middle" width=16%>Authorisation Level:</td>
                                                <td valign="middle" width="13%">
                                                    <select class="itemfont" name="lvlID" id="lvlID">
                                                       <option value=0>All</option>
                                                       <%do while not rsLvl.eof%>
                                                            <option value=<%=rsLvl("lvlID")%> <% if int(rsLvl("lvlID"))=int(rsRecset("lvlID")) then%> selected <%end if %>><%=rsLvl("authlevel")%></option>
                                                            <%rsLvl.Movenext %>
                                                       <% loop%>
                                                    </select>
                                                 </td>   
                                                 <td >&nbsp;</td>
                                            </tr>
                                            <tr height=16>
                                                <td colspan="4">&nbsp;</td>
                                            </tr>
                                            <%rsLvl.movefirst%>
                                            <tr class=columnheading height=22>
                                                <td valign="middle" width=0%>&nbsp;</td>
                                                <td valign="middle" width=14%>Special Authorisation Level:</td>
                                                <td valign="middle" width="9%">
                                                    <select class="itemfont" name="splvlID" id="splvlID">
                                                       <option value=0>All</option>
                                                       <%do while not rsLvl.eof%>
                                                            <option value=<%=rsLvl("lvlID")%> <% if int(rsLvl("lvlID"))=int(rsRecset("splvlID")) then%> selected <%end if %>><%=rsLvl("authlevel")%></option>
                                                            <%rsLvl.Movenext %>
                                                       <% loop%>
                                                    </select>
                                                 </td>  
                                                 <%if request("err") = "True" then%>
												   <td><%= request("description") %>&nbsp;<span class="style2">Already exists</span></td>
												 <% end if %>  
                                            </tr>
                                            <tr height=16>
                                                <td colspan="4">&nbsp;</td>
                                            </tr>
                                            <tr class=columnheading height=22>
                                                <td valign="middle" width=1%>&nbsp;</td>
                                                <td valign="middle" width=16%>Administration Level Rank:</td>
                                                <td valign="middle" width="13%">
                                                    
                                                    <select class="itemfont" name="rankID" id="rankID">
                                                        <option value=0>All</option>
                                                        <%do while not rsRank.eof%>
                                                            <option value=<%=rsRank("RankID")%> <%if int(rsRank("rankID"))=int(rsRecset("lvlRankID")) then%> selected <%end if%>><%=rsRank("shortDesc")%></option>
                                                            <%rsRank.Movenext%>
                                                        <%loop%>
                                                    </select>
                                                </td>
                                                <td valign="middle" width=79%  style="color:#F00">&nbsp; <strong> NB: This is the MINIMUM rank allowed as an Administrator for this Auth Level</strong></td>
                                            </tr>
                                            <tr height=16>
                                                <td colspan="4">&nbsp;</td>
                                            </tr>
                                            
                                            <tr class=columnheading height=22>
                                                <td valign="middle" width=1%>&nbsp;</td>
                                                <td valign="middle" width=16%>Holding Level Rank:</td>
                                                <td valign="middle" width="13%">
                                                    <%rsRank.Movefirst %>
                                                    <select class="itemfont" name="authedrankID" id="authedrankID">
                                                        <option value=0>All</option>
                                                        <%do while not rsRank.eof%>
                                                            <option value=<%=rsRank("RankID")%> <%if int(rsRank("rankID"))=int(rsRecset("authedRankID")) then%> selected <%end if%>><%=rsRank("shortDesc")%></option>
                                                            <%rsRank.Movenext%>
                                                        <%loop%>
                                                    </select>
                                                </td>
                                                <td valign="middle" width=70%  style="color:#F00">&nbsp; <strong> NB: This is the MINIMUM rank allowed to be granted this Authorisation</strong></td>

                                            </tr>

                                            <tr>
                                                <td colspan=4 class=titlearealine height=1></td> 
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
	set rsRecSet = nothing
	con.close
	set con = nothing
%>

</body>
</html>

<script language="javascript">

function checkThis()
{
	//This function renoves any leading or trailing spaces from a string
	String.prototype.killWhiteSpace = function()
	{
		return this.replace(/\s/g, '');
	};

	var errMsg = "Please provide/correct the following:\n\n";
	var error = false;
	  
	var lvlID = document.frmDetails.lvlID.value;
	var splvlID = document.frmDetails.splvlID.value;
	var rnkID = document.frmDetails.rankID.value;
	
	//alert(splvlID);
	//return;

	/* make sure they have entered comments for the next stage */
	if(lvlID == 0)
	{
		errMsg += "You Must Choose a Level \n"
		error = true;
	}
	
    if(rnkID == 0)
	{
		errMsg += "You Must Choose a Rank"
		error = true;
	}



	if(error == true)
	{
		alert(errMsg)
		return;	  		
	} 
	
	var sli = document.frmDetails.elements["lvlID"].selectedIndex;
	var authlevel = document.frmDetails.elements["lvlID"].options[sli].text;
	var speciallevel = document.frmDetails.elements['splvlID'].value;
	
	document.frmDetails.authlevel.value=authlevel;
	document.frmDetails.speciallevel.value = speciallevel;
	document.frmDetails.lvlRankID.value=rnkID;
	
	//alert( sli + " * " + authlevel + " * " + document.frmDetails.lvlRankID.value);

    document.frmDetails.submit();  
}

</script>
