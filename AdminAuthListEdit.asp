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
	
	strAction="Update"
	
	set objCmd = server.createobject("ADODB.Command")
	set objPara = server.createobject("ADODB.Parameter")
	objCmd.activeconnection = con
	objCmd.commandtext = strCommand
	objCmd.commandtype = 4
	
	strCommand = "spGetAuthDetail"
	
	objCmd.CommandText = strCommand
	set objPara = objCmd.CreateParameter ("RecID",3,1,0, request("authID"))
	objCmd.Parameters.Append objPara
	set rsRecSet = objCmd.execute	'Execute CommandText when using "ADODB.Command" object
	
	strCommand = "spListAuthApprovers"
	set objPara = objCmd.CreateParameter ("atpID",3,1,0, rsRecset("atpID") )  
	objCmd.Parameters.Append objPara

	objCmd.CommandText = strCommand
	set rsApprv = objCmd.execute	'Execute CommandText when using "ADODB.Command" object

	for x = 1 to objCmd.parameters.count
		objCmd.parameters.delete(0)
	next

	strTable = "tblAuthsType"
	strCommand = "spListTable"
	
	if request("atpID") <> "" then
	  strAuthType = request("atpID")
	end if
	
	objCmd.CommandText = strCommand
    set objPara = objCmd.CreateParameter ("nodeID",3,1,0, 0)
	objCmd.Parameters.Append objPara
	set objPara = objCmd.CreateParameter ("TableName",200,1,50, strTable)
	objCmd.Parameters.Append objPara
	set rsAuthTypes = objCmd.Execute	''Execute CommandText when using "ADODB.Command" object

%>

<html>
<head>

<!--<meta http-equiv="X-UA-Compatible" content="IE=7" />-->
<title><%= PageTitle %></title>
<link rel="stylesheet" type="text/css" href="Includes/AMDB.css" media="Screen"/>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">

</head>
<body onLoad="javascript:getAuthTypes(<%=rsRecSet("authID")%>,<%=rsRecSet("apprvID")%>);javascript:getAuthLevels('<%=rsRecSet("authlevel")%>')">

<form  action="UpdateAuthList.asp?strAction=<%=strAction%>" method="POST" name="frmDetails">
	<input type="hidden" name="RecID" id="RecID" value="<%= request("authID") %>">  
    <input type="hidden" name="authapprv" id="authapprv" value="">  
    <input type="hidden" name="authlevel" id="authlevel" value="">  
    <table  height="100%" cellspacing=0 cellPadding=0 width=100% border=0>
    	<tr>
    		<td>
    			<!--#include file="Includes/Header.inc"--> 
    				<table cellSpacing=0 cellPadding=0 width=100% border=0 >
                    <tr style="font-size:10pt;" height=26px>
                        <td width=10><img style="margin-left:10px;" src="cms_icons/png/24x24/process.png" width="24" height="24"></td>
                        <td class="staticdatamenu"><font class="youAreHere">CMS Admin Menu / <strong>Edit Authorisation Details</strong></font></td>
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
                                                <td class=toolbar valign="middle"><a class= itemfontlink href="AdminAuthListDetail.asp?authID=<%=request("authID")%>">Back</a></td>
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
												<td valign="middle" width=13%>Description:</td>
												<td valign="middle" width=85%><input class="itemfont" style="width: 360px" maxLength=300 name="authCode" id="authCode" type="text" value="<%= rsRecSet("authCode") %>"/></td>
											</tr>
                                            <tr class="columnheading" height="22">
                                            	<td valign="middle" width="2%">&nbsp;</td>
                                                <td valign="middle" width="13%">Authorisation Type:</td>
                                                <td valign="middle" width="85%">
                                                	<!--<select name="cboauthType" id="cboauthType" class="itemfont" style="width: 150px" onChange="Auth(this.value)">-->
                                                    <select class="itemfont" name="atpID" id="atpID" style="width:200px;" onchange="javascript:getAuthTypes(<%=rsRecSet("authID")%>,0)">
                                                        <option value=0>Select...</option>
                                                        <% do while not rsAuthTypes.eof %>
                                                            <option value="<%= rsAuthTypes("atpID") %>" <% if rsAuthTypes("atpID") = rsRecSet("atpID") then %> selected <% end if %>><%=rsAuthTypes("authType") %></option>                                                     
                                                            <% rsAuthTypes.movenext %>
                                                        <% loop %>
                                                    </select>
                                                </td>
                                            </tr>
                                            <tr class="columnheading" height="22px">
												<td align="left" width="2%">&nbsp;</td>
                                                <td align="left" width="13%">Authorisation Level:</td>
                                                <td align="left" width="85%">
                                                 <div id="authlvl"> 
                                                	<select name="authlvlID" id="authlvlID" class="itemfont" style="width:50px">
                                                        <option value="0">Select...</option>
                                                    </Select>
                                                 </div>
                                                </td>
                                            </tr>
                                            <tr class="columnheading" height="22px">
												<td align="left" width="2%">&nbsp;</td>
                                                <td align="left" width="13%">Authorisation Class:</td>
                                                <td valign="middle" width=10%><input class="itemfont" style="width:25px" maxLength=300 name="authclassID" id="authclassID" type="text" value="<%= rsRecSet("authclass") %>"/></td>
                                            </tr>
                                            <tr class="columnheading" height="22px">
												<td align="left" width="2%">&nbsp;</td>
                                                <td align="left" width="13%">Approved By:</td>
                                                <td align="left" width="85%">
                                                 <div id="apprvr"> 
                                                	<select name="apprvID" id="apprvID" class="itemfont" style="width: 150px">
                                                        <option value="0">Self Approve</option>
                                                    </Select>
                                                 </div>
                                                </td>
                                            </tr>
                                            <tr class="columnheading">
                                            	<td height="22" valign="middle" width="2%">&nbsp;</td>
                                                <td height="22" valign="top" width="13%">Task:</td>
                                                <td height="22" valign="middle" width="85%"><textarea name="txtTask" rows="4"  class="itemfont" id="txtTask" style="width: 360px; height: 60px;"><%= rsRecSet("authTask") %></textarea></td>
                                            </tr>
                                            <tr height=16>
                                                <td colspan="3">&nbsp;</td>
                                            </tr>

                                            <tr class="columnheading">
                                            	<td height="22" valign="middle" width="2%">&nbsp;</td>
                                                <td height="22" valign="top" width="13%">Requirements:</td>
                                                <td height="22" valign="middle" width="85%"><textarea name="txtReqs" rows="4"  class="itemfont" id="txtReqs" style="width: 360px; height: 60px;"><%= rsRecSet("authReqs") %></textarea></td>
                                            </tr>
                                            <tr height=16>
                                                <td colspan="3">&nbsp;</td>
                                            </tr>
                                            <tr class="columnheading">
                                            	<td height="22" valign="middle" width="2%">&nbsp;</td>
                                                <td height="22" valign="top" width="13%">Reference:</td>
                                                <td height="22" valign="middle" width="85%"><textarea name="txtRef" rows="4"  class="itemfont" id="txtRef" style="width: 360px; height: 60px;"><%= rsRecSet("authRef") %></textarea></td>
                                            </tr>
                                            <tr height=16>
                                                <td colspan="3">&nbsp;</td>
                                            </tr>
                                            
                                            <% if rsRecSet("thisLevel") < 3 and rsRecSet("topAuth") = 0 then %>
                                            <tr class="columnheading" height="22px">
												<td align="left" width="2%">&nbsp;</td>
                                                <td align="left" width="13%">Class Authorisor:</td>
												<td align="left"><input type="checkbox" name="classauth"  id="classauth" <% if rsRecSet("classauth") = true then %> checked <% end if %><% if rsRecSet("topAuth") = 1 then %> disabled="true" <%end if %>> 
												&nbsp; Tick this for the top level Authorisor ie: Level J or K</td>
                                            </tr>
                                            <% end if %>
                                            
                                            <tr height=16>
                                                <td colspan="3">&nbsp;</td>
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

function getAuthTypes(authID,apprvID)
{
	var atp=document.getElementById("atpID").value;
	//document.getElementById("apprvr").style.display="block";
	
	//alert("Auth Type is " + atp);
	var str = 'atpID='+atp+'&authID='+authID+'&apprvID='+apprvID
	
	//alert("Auth Type is " + str);
	
	ajax('ddAuthApprovers.asp',str,'apprvr');
	
}

function getAuthLevels(authlevel)
{	

    //alert( "levels for " + authlevel);

    var str = 'authlevel='+ authlevel ;

	ajax('ddAuthLevels.asp',str,'authlvl');
	
	
	
}


//----------------standard ajax function with option for secondary function----------------
function ajax(url,strMessage,div,func,loading){
    // prompt('',url+'?'+strMessage + '?'+div+'?'+func+'?'+loading)
  
    //var str = 'pagesize='+pagesize+'&filSearch='+crsenum+' &orderBy='+orderBy+'&dir='+dir + ' &searchby=number ';
	//prompt("",'userlist.asp?'+str)
	//ajax('courselist.asp',str,'List');
  
  
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
	
	//alert("out of ajax " + strMessage);
	xhr.send(strMessage);
	//xhr.send(encodeURI(strMessage)); 
}

function checkThis()
{
	//This function renoves any leading or trailing spaces from a string
	String.prototype.killWhiteSpace = function()
	{
		return this.replace(/\s/g, '');
	};

	var errMsg = "Please provide/correct the following:\n\n";
	var error = false;
	  
	var q = document.frmDetails.authCode.value;
	q = q.killWhiteSpace();
	var qt = document.frmDetails.atpID.value;
	var apprv = document.frmDetails.apprvID.value;
	var acl = document.frmDetails.authclassID.value;
	//var cla = document.frmDetails.classauth.checked;
	
	var e = document.getElementById("apprvID");
	var ea = e.options[e.selectedIndex].text;

    var d = document.getElementById("authLvlID");
    var aby = d.options[d.selectedIndex].text;
	//var vp = document.frmDetails.cboVPeriod.value;
	//var a = document.frmDetails.txtAmberDays.value;
	var re = /[a-z,A-Z\^,£<>$":;{}\[\]\*\.+\-_=~#@?\\\/%\'!¬`¦&]/g;

	/* make sure they have entered comments for the next stage */
	if(q == "")
	{
		errMsg += "Authorisation Code\n"
		error = true;
	}
	
	if(qt == 0)
	{
		errMsg += "Authorisation Type \n"
		error = true;
	}
	
	if(apprv == 0)
	{
		errMsg += "Approver \n"
		error = true;
	}
	
	// check if they self authorised - only allowed to do this at top levl
	// so Class Authorisor MUST be ticked
	if (document.frmDetails.RecID.value == document.frmDetails.apprvID.value)
		{
		   if (! document.frmDetails.classauth.checked)
		   {
			   errMsg += "Only a Class Authorisor can Self Approve \n"
		       error = true;
		   }
		}

	if(aby == "0")
	{
		errMsg += "Authorisation Level\n"
		error = true;
	}

	if(acl == "")
	{
		errMsg += "Authorisation Class\n"
		error = true;
	}
	
	if(error == true)
	{
		alert(errMsg)
		return;	  		
	} 
	
	document.frmDetails.authapprv.value=ea;
	document.frmDetails.authlevel.value=aby;
	
	//alert("level is " + aby + " * " + acl + " * " + ea + " * " );

    document.frmDetails.submit();  
}

/*function QAuth(val)
{
	var strSplit = val.split("*");
	if(strSplit[1] == 'True')
	{
		document.getElementById('txtLongDesc').style.backgroundColor='#FFFFFF';
		document.getElementById('txtLongDesc').disabled = false;
		document.getElementById('txtLongDesc').focus();
	}
	else
	{
		document.getElementById('txtLongDesc').style.backgroundColor='#E1E1E1';
		document.getElementById('txtLongDesc').disabled = true;
		document.getElementById('txtLongDesc').value = "";
	}
}

*/</script>
