<!DOCTYPE HTML >

<!--#include file="Includes/Security.inc"-->
<!--#include file="Connection/Connection.inc"-->

<%
	' get screen height - use for table height calculation
	if request("myHeight1") = "" then  
	%>
		<script language="JScript">
			var myHeight = document.documentElement.clientHeight - 138; //(screen.availHeight) ;
			window.location = "reportsCISAuth.asp?myHeight1="+myHeight;
		</script>
	<%
	else
	   'session.timeout = 60
	   session("heightIs") = request("myHeight1") 
	end if 
	
	itemsListed=6
	location="Reports"
	subLocation="12"

	dim strPage
	strPage="AuthType"
	strTable = "tblAuthsType"
	strCommand = "spListTable"
	
	if request("atpID") <> "" then
	  strAuthType = request("atpID")
	end if


	set objCmd = server.CreateObject("ADODB.Command")
	set objPara = server.CreateObject("ADODB.Parameter")
	objCmd.ActiveConnection = con
	objCmd.Activeconnection.cursorlocation = 3

	objCmd.CommandText = strCommand

    set objPara = objCmd.CreateParameter ("nodeID",3,1,0, 0)
	objCmd.Parameters.Append objPara
	set objPara = objCmd.CreateParameter ("TableName",200,1,50, strTable)
	objCmd.Parameters.Append objPara
	set rsAuthTypes = objCmd.Execute	''Execute CommandText when using "ADODB.Command" object
	
	
		for x = 1 to objCmd.parameters.count
		objCmd.parameters.delete(0)
	next

%>

<html>
<head>

<!--#include file="Includes/IECompatability.inc"-->


<title><%= PageTitle %></title>
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
	<table  height="100%" cellspacing=0 cellPadding=0 width=100% border=0>
    	<tr>    		
			<td> 
				<!--#include file="Includes/Header.inc"-->
				<table cellSpacing=0 cellPadding=0 width=100% border=0 >
                    <tr style="font-size:10pt;" height=26px>
                        <td width=10px>&nbsp;</td>
                        <td><a title="" href="index.asp" class=itemfontlinksmall>Home</a> > <A href='reportsHome.asp' class=itemfontlinksmall >Reports</A> > <font class='youAreHere'>CIS Auth</font></td>
                    </tr>
                    <tr>
                        <td colspan=2 class=titlearealine  height=1></td> 
                    </tr>
				</table>
                <table width=100% height='<%=session("heightIs")%>px' border=0 cellpadding=0 cellspacing=0 > 
                    <tr valign=Top>
                        <td class="sidemenuwidth" background="Images/tableback.png">
							<!--#include file="Includes/reportsSideMenu.inc"-->
                        </td>
                        <td width=16></td>
                        <td align=left>
                            <form action="" method="POST" name="frmDetails" target="Report">
                                <table border=0 cellpadding=0 cellspacing=0 width=100%>	
                                    <tr class=SectionHeader>							
                                        <td>
                                            <table border=0 cellpadding=0 cellspacing=0 width="250px">
                                                <tr height=28px>
                                                    <td width="25px"><a class=itemfontlink href="javascript:launchReportWindow();"><img class="imagelink" src="images/report.gif"></a></td>
                                                    <td width="90px" class=toolbar valign="middle" >Create Report</td>
                                                    <td width="10px" class=titleseparator valign="middle" align="center">|</td>
                                                    <td width="25px"><a class=itemfontlink href="javascript:launchReportWindowExcel();"><img class="imagelink" src="images/excel.gif"></a></td>
                                                    <td width="100px" class=toolbar valign="middle" >Create In Excel </td>
                                                </tr>
                                            </table>
                                        </td>
                                    </tr>
                                    <tr >
                                        <td align=left valign=top >
                                            <table border=0 cellpadding=0 cellspacing=0 width=100%>
                                                <tr height="16">
                                                    <td></td>
                                                </tr>
                                                <tr>
                                                    <td>
                                                        <table width="100%" border="0" cellpadding="0" cellspacing="0">
                                                            <tr class="columnheading">
                                                                <td width="10%" align="left" height="22px">Authorisation Type:</td>
                                                                <td width="90%" align="left" height="22px">
                                                                    <select class="itemfont" name="atpID" id="atpID" onchange="javascript:getAuthTypes()" style="width:140px;">
                                                                        <option value=0>Select...</option>
                                                                        <% do while not rsAuthTypes.eof %>
                                                                            <option value="<%= rsAuthTypes("atpID") %>"><%=rsAuthTypes("authType") %></option>                                                     
                                                                            <% rsAuthTypes.movenext %>
                                                                        <% loop %>
                                                                    </select>
                                                                 </td>
                                                            </tr>
                                                            <tr>
                                                                <td colspan="5">&nbsp;</td>
                                                            </tr>
                                                            <tr class="columnheading" height="22">
                                                               
                                                                <td align="center" width="10%">Approver:</td>
                                                                <td width="90%" align="left" height="22px">
                                                                 <div id="apprvr"> 
                                                                    <select name="apprvID" id="apprvID" class="itemfont" style="width: 100px">
                                                                        <option value="0">None</option>
                                                                    </Select>
                                                                 </div>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td colspan="5">&nbsp;</td>
                                                            </tr>
            
                                                        </table>
                                                    </td>
                                                </tr>
                                            </table>
                                        </td>	
                                    <tr>
                                        <td></td>
                                    </tr>
                                </table>
                            </form>
						</td>
					</tr>
				</table>
			</td>
		</tr>
	</table>
</body>
</html>

<script language="javascript">

var win = null;

function getAuthTypes()
{
	var atp=document.getElementById("atpID").value;
	//document.getElementById("apprvr").style.display="block";
	
	//alert("Auth Type is " + atp);
	var str = 'atpID='+atp+'&authID='+0
	//alert("Auth Type is " + str);
	ajax('ddAuthApprovers.asp',str,'apprvr');
	
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

function launchReportWindow()
{
	if(win)
	{
		win.close();
	}
	
	if(document.frmDetails.apprvID.value == 0)
	{
		alert( "Please select an Authorisation");
		return;
	}

	var x = (screen.width);
	var y = (screen.height);
	
	var authid=document.getElementById("apprvID").value;
	var str="reportsCISAuthSubmit.asp?apprvid="+authid;
	
	//alert("authid is " + authid + " * " + str);
	
	document.frmDetails.action=str;
	win = window.open("","Report","top=0,left=0,width="+x+",height="+y+",toolbar=0,menubar=1,scrollbars=1");
	window.setTimeout("document.frmDetails.submit();",500);	
}

function launchReportWindowExcel()
{
	if (win){
	win.close();
	}
	
	document.frmDetails.action="reportsCISAuthExcel.asp";
	document.frmDetails.submit();
}

</script>