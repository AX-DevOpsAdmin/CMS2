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
objCmd.CommandType = 4		

' default to tblRank ndeID=1
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

response.write ("here we are ranks " & request("lvlID"))
response.End()

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


%>

<html>
<head>

<!--#include file="Includes/IECompatability.inc"-->



<title><%= PageTitle %></title>
<link rel="stylesheet" type="text/css" href="Includes/AMDB.css" media="Screen"/>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
</head>
<body>

<form  action="UpdateAuthType.asp?strAction=<%=strAction%>" method="POST" name="frmDetails">
	<input type="hidden" name="RecID" id="RecID" value="<%= request("atpID") %>">  
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
                                                <td class=toolbar valign="middle"><a class= itemfontlink href="AdminAuthTypeDetail.asp?atpID=<%=request("atpID")%>">Back</a></td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <table width=100% border=0 cellpadding=0 cellspacing=0>
                                            <tr height=16>
                                                <td colspan="3">&nbsp;</td>
                                            </tr>
                                            <tr class=columnheading height=22>
                                                <td valign="middle" width=2%>&nbsp;</td>
                                                <td valign="middle" width=14%>Authorisation Level:</td>
                                                <td valign="middle" width="84%">
                                                    <select class="itemfont" name="lvlID" id="lvlID">
                                                        <option value=0>All</option>
                                                        <%do while not rsLvl.eof%>
                                                            <option value=<%=rsLvl("lvlID")%> <%if rsLvl("lvlID")=rsRecset("lvlID")) then response.write " Selected"%>><%=rsLvl("authlevel")%></option>
                                                            <%rsLvl.Movenext
                                                        loop%>
                                                    </select>
                                            </tr>
                                            <tr height=16>
                                                <td colspan="3">&nbsp;</td>
                                            </tr>
                                                                                        <tr class=columnheading height=22>
                                                <td valign="middle" width=2%>&nbsp;</td>
                                                <td valign="middle" width=14%>Authorisation Level Rank:</td>
                                                <td valign="middle" width="84%">
                                                    <select class="itemfont" name="rankID" id="rankID">
                                                        <option value=0>All</option>
                                                        <%do while not RSRank.eof%>
                                                            <option value=<%=RSRank("RankID")%> <%if int(RSRank("RankID"))=int(request("RankID")) then response.write " Selected"%>><%=RSRank("shortDesc")%></option>
                                                            <%RSRank.Movenext
                                                        loop%>
                                                    </select>
                                                </td>
                                            </tr>

                                            <tr>
                                                <td colspan=3 class=titlearealine height=1></td> 
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
	  
	var authType = document.frmDetails.txtDescription.value;
	authType = authType.killWhiteSpace(); 

	/* make sure they have entered comments for the next stage */
	if(authType == "")
	{
		errMsg += "Authorisation Type"
		error = true;
	}

	if(error == true)
	{
		alert(errMsg)
		return;	  		
	} 
	
    document.frmDetails.submit();  
}

</script>
