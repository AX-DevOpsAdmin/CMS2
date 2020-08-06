<!DOCTYPE HTML >

<!--#include file="Includes/security.inc"--> 
<!--include file="Includes/checkadmin.asp"-->
<!--#include file="Connection/Connection.inc"-->

<%

	'If user is not valid Authorisation Administrator then log them off
	If (session("authadmin") =0 AND  strAuth > 2 ) then
		Response.redirect("noaccess.asp")
	End If

color1="#f4f4f4"
color2="#fafafa"
counter=0

dim strPage
strPage="PeRs"

' 'Check to see if they are managers - set at Log-On - 1 = Manager  0 = User
'if session("Administrator") = "1" then
'  strManager = "1"
'else
'  strManager = session("UserStatus")
'end if  

'strpage="PersonnelSearch"
'if request("sort")="" then
'	sort = 5
'else
'	sort = request("sort")
'end if
'	
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
	objCmd.CommandType = 4		
    set objPara = objCmd.CreateParameter ("nodeID",3,1,0, 0)
	objCmd.Parameters.Append objPara
	set objPara = objCmd.CreateParameter ("TableName",200,1,50, strTable)
	objCmd.Parameters.Append objPara
	set rsAuthTypes = objCmd.Execute	''Execute CommandText when using "ADODB.Command" object

	for x = 1 to objCmd.parameters.count
		objCmd.parameters.delete(0)
	next


	strCommand = "spGetAuthList"
	
	set objCmd = server.CreateObject("ADODB.Command")
	set objPara = server.CreateObject("ADODB.Parameter")
	objCmd.ActiveConnection = con
	objCmd.CommandText = strCommand
	objCmd.CommandType = 4		
	
	set objPara = objCmd.CreateParameter ("authType",3,1,0, cint(strAuthType))
	objCmd.Parameters.Append objPara

	set objPara = objCmd.CreateParameter ("nodeID",3,1,0, 0)
	objCmd.Parameters.Append objPara
	
	set rsAuths = objCmd.Execute	'Execute CommandText when using "ADODB.Command" object

	for x = 1 to objCmd.parameters.count
		objCmd.parameters.delete(0)
	next

    
'	if request("doSearch") = 1 then
'		firstname = replace(request("firstName"),"'","''")
'		surname = replace(request("surName"),"'","''")
'		serviceno = replace(request("ServiceNo"),"'","''")
'		authID = request("authID")
'	
'		strCommand = "spPersonnelSearchList"
'		objCmd.CommandText = strCommand
'		objCmd.CommandType = 4		
'		set objPara = objCmd.CreateParameter ("firstName",200,1,50, firstname)
'		objCmd.Parameters.Append objPara
'		set objPara = objCmd.CreateParameter ("surname",200,1,50, surname)
'		objCmd.Parameters.Append objPara
'		set objPara = objCmd.CreateParameter ("serviceno",200,1,50, serviceno)
'		objCmd.Parameters.Append objPara
'		set objPara = objCmd.CreateParameter ("authID",3,1,0, authID)
'		objCmd.Parameters.Append objPara
'		set objPara = objCmd.CreateParameter ("Active",3,1,0,1)
'		objCmd.Parameters.Append objPara
'		set objPara = objCmd.CreateParameter ("sort",3,1,0, sort)
'		objCmd.Parameters.Append objPara
'		set rsRecSet = objCmd.Execute
'	
'		if request("page")<>"" then
'			page=int(request("page"))
'		else
'			page=1
'		end if
'		recordsPerPage = 20
'			
'		num=rsRecSet.recordcount
'		startRecord = (recordsPerPage * page) - recordsPerPage
'		totalPages = (int(num/recordsPerPage))	
'		
'		if int(num - (recordsPerPage * totalPages)) > 0 then totalPages=totalPages+1
'		if page = totalPages then recordsPerPage = int(num - startRecord)
'	
'		if rsRecSet.recordcount>0 then rsRecSet.move(startRecord)
'	
'		beginAtPage=1
'		increaseAfter = 6
'		startEndDifference = 9
'		if page-increaseAfter >1 then 
'			beginAtPage=page-increaseAfter
'		end if
'		
'		if totalPages < beginAtPage+startEndDifference  then
'			beginAtPage = totalPages-startEndDifference
'		end if
'		
'		endAtPage=beginAtPage+startEndDifference
'		if beginAtPage<1 then beginAtPage=1
'	else
'		firstname = ""
'		surname = ""
'		serviceno = ""
'		authID = 0
'		tradeID = 0
'		strActive = 1
'		page=0
'	end if
	
	
%>
<html>
<head>

<!--#include file="Includes/IECompatability.inc"-->


<title><%= PageTitle %></title>
<link rel="stylesheet" type="text/css" href="Includes/AMDB.css" media="Screen"/>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
</head>
    <body>
        <form action="" method="post" name="frmDetails">
            <Input name="DoSearch" id="dosearch" type="Hidden" value="1">
            <Input name="Page" id="Page" type="Hidden" value="1">
            <!--<Input name="active" id="active" type="Hidden" value="0">-->
            <Input name="Sort" id="Sort" type="Hidden" value="<%=sort%>">
            <Input name="checkChange" id="checkChange" type="Hidden" value="0">
            <table  height="100%" cellspacing=0 cellPadding=0 width=100% border=0>
                <tr>
                    <td>
                          <!--#include file="Includes/Header.inc"--> 
                          <table cellSpacing=0 cellPadding=0 width=100% border=0 >
                            <tr style="font-size:10pt;" height=26px>
                                <td width=10><img style="margin-left:10px;" src="cms_icons/png/24x24/process.png" width="24" height="24"></td>
                                <td class="staticdatamenu"><font class="youAreHere">CMS Admin Menu / <strong>Authorisation Audit History</strong></font></td>
                            </tr>
                            <tr><td colspan=2 class=titlearealine  height=1></td></tr>
                          </table>
                  
                          <!--<table width=100% height='<%'=session("heightIs")%>px' border=0 cellpadding=0 cellspacing=0> -->
                          <table style="height:900px;" width=100% height="328" border=0 cellpadding=0 cellspacing=0> 
                            <tr valign=Top>
                              <td class="sidemenuwidth" background="Images/tableback.png"><!--#include file="Includes/authmenu.inc"--></td>
                                <td width=16></td>
                                <td align=left >
                                    <table border=0 cellpadding=0 cellspacing=0 width=100%>
                                        <tr height=16 class=SectionHeader>
                                            <td>
                                                <table width="159" border=0 cellpadding=0 cellspacing=0 >
                                                    <tr> 
                                                        <td width=12 class=toolbar></td>											   
                                                        <td width=26><a class=itemfontlink href="javascript:saveForm();"><img class="imagelink" src="images/icongo01.gif"></a></td>
                                                        <td width=37 align="center" class=toolbar>Find</td>
                                                        <td width=11 align="center" class=titleseparator>|</td>
                                                        <td width=29 align="center"><a class=itemfontlink href="javascript:Reset();"><img class="imagelink" src="Images/reset.gif"></a></td>
                                                        <td width=44 class=toolbar align="center">Reset</td>
                                                    </tr>  
                                                </table>
                                            </td>
                                        </tr>
                                         
                                        <tr>
                                            <td>
                                                 <table width="100%" border="0" cellpadding="0" cellspacing="0">
                                                    <tr class="searchheading" height="30">
                                                        <td width="10%" align="left" height="22px">Authorisation Type:</td>
                                                        <td width="13%" align="left" height="22px">
                                                            <select class="itemfont" name="atpID" id="atpID" onchange="javascript:listAuths(this)" style="width:140px;">
                                                            <option value=0>Select...</option>
                                                            <% do while not rsAuthTypes.eof %>
                                                                <option value="<%= rsAuthTypes("atpID") %>" <% if cint(strAuthType) = cint(rsAuthTypes("atpID")) then %> selected <% end if %>><%=rsAuthTypes("authType") %></option>                                                     
                                                                <% rsAuthTypes.movenext %>
                                                            <% loop %>
                                                            </select>
                                                        </td>
                                                        <td valign="middle" width="10%">Authorisation Code</td>
                                                        <td valign="middle" width="67%">
                                                          <div id="authlist">
                                                                <select  name="authID" id="authID" class="itemfont">
                                                                    <option value=0>All</option>
                                                                </select>
                                                           </div>
                                                        </td>
                                                        
                                                    </tr>
                                                    <tr>
                                                        <td colspan="6">&nbsp;</td>
                                                    </tr>
                                                    <tr>
                                                        <td colspan="6" class="titlearealine" height="1"></td>
                                                    </tr>
                                                </table>
                                            </td>
                                        </tr>
                                        <tr>
                                          <td>
                                             <div id="authHistory" style="display:none"></div>
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


<script language="javascript">

function CheckForm() {
  
	var authID=document.getElementById("authID").options[selectedIndex].text;
	var str = 'authID='+authID;
	
	alert("Auth Audit Trail for " + str);
	//ajax('ddGetAuthCodeAudit.asp',str,'authHistory');
	
}

function saveForm(){
	
	//alert("save form");
  
	var errMsg;
	var error = false;
	
	var str;
	
	var authID=document.getElementById("authID").value;
    if (authID == 0){
		errMsg = "Please Select an Authorisation Code"
		error = true;
	}
	
	//alert("Auth Audit Trail for " + str);
	
	if(error == true)
	{
		alert(errMsg)
		return;	  		
	} 

	var obj=document.getElementById("authID");
	var authcode=obj.options[obj.selectedIndex].text;
    
	str = 'authcode='+authcode;
	
	//alert("search on " + str);
	document.getElementById("authHistory").style.display="block";
	ajax('ddGetAuthCodeAudit.asp',str,'authHistory');
	
}


function listAuths(obj){
	
	var atp=obj.value;
	//document.getElementById("apprvr").style.display="block";
	
	var str = 'atpID='+atp
	
	//alert("Auth Type is " + str);
	ajax('ddGetAuthList.asp',str,'authlist');
	
}

//----------------standard ajax function with option for secondary function----------------
function ajax(url,strMessage,div,func,loading){
     //prompt('',url+'?'+strMessage + '?'+div+'?'+func+'?'+loading)
  
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
			
			  // alert(xhr.responseText);
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



function MovetoPage (PageNo) {
	var checkChange = document.forms["frmDetails"].elements["checkChange"].value;
	if (checkChange==0){
		document.forms["frmDetails"].elements["Page"].value = PageNo;
		}else{
		document.forms["frmDetails"].elements["Page"].value = 1;
		}
	// document.forms["frmDetails"].submit();
	   CheckForm();
}

function newSearch() {
	document.forms["frmDetails"].elements["checkChange"].value = 1;

}

function Reset()
{
	document.getElementById('authID').selectedIndex = 0;
	document.getElementById('atpID').selectedIndex = 0;
	
	document.getElementById("authHistory").style.display="none";

	document.frmDetails.submit();
}

</script>
