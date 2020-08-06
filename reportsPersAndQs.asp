<!DOCTYPE HTML >

<!--#include file="Includes/Security.inc"-->
<!--#include file="Connection/Connection.inc"-->

<%
' get screen height - use for table height calculation
if request("myHeight1") = "" then  
%>
	<script language="JScript">
		var myHeight = document.documentElement.clientHeight - 138; //(screen.availHeight) ;
		window.location = "reportsPersAndQs.asp?myHeight1="+myHeight;
	</script>
<%
else
   'session.timeout = 60
   session("heightIs") = request("myHeight1") 
end if 

itemsListed=6
location="Reports"
subLocation="16"

set objCmd = server.CreateObject("ADODB.Command")
set objPara = server.CreateObject("ADODB.Parameter")
objCmd.ActiveConnection = con
objCmd.Activeconnection.cursorlocation = 3
objCmd.CommandType = 4

strCommand = "spListQTypes"
objCmd.CommandText = strCommand
	
set objPara = objCmd.CreateParameter ("nodeID",3,1,0, nodeID)
objCmd.Parameters.Append objPara
	
set rsTypeQList = objCmd.Execute	'Execute CommandText when using "ADODB.Command" object'

'for x = 1 to objCmd.parameters.count
'	objCmd.parameters.delete(0)
'next
'

'objCmd.commandtext = "spGetHierarchyDetail"
'' now  get the unit
'set rsHrc = objCmd.execute

'objCmd.CommandText = "spListTeams"
'objCmd.CommandType = 4		
'set rsHrc = objCmd.Execute

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
<body onLoad="switchObject('Section1','Icon1','Status1',1);">
	<table  height="100%" cellspacing=0 cellPadding=0 width=100% border=0>
    	<tr>    		
			<td> 
				<!--#include file="Includes/Header.inc"-->
				<table cellSpacing=0 cellPadding=0 width=100% border=0 >
                    <tr style="font-size:10pt;" height=26px>
                        <td width=10px>&nbsp;</td>
                        <td><a title="" href="index.asp" class=itemfontlinksmall>Home</a> > <A href='reportsHome.asp' class=itemfontlinksmall >Reports</A> > <font class='youAreHere' >Q Expiry Date</font></td>
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
                        <td width=16px>&nbsp;</td>
                        <td align=left>
                        	<form action="reportsPersAndQsSubmit.asp" method="POST" name="frmDetails" id="frmDetails" target="Report">
                                <input type=hidden name="Status1" id="Status1" value="0">
                                <input type="hidden" name="newattached" id="newattached" value="">

                                <table border=0 cellpadding=0 cellspacing=0 width=100% height=100%>
                                    <tr class=SectionHeader>
                                        <td>
                                            <table width="240px" border=0 cellpadding=0 cellspacing=0>
                                                <tr height=28px>
                                                    <td width=25px align="center"><a class=itemfontlink href="javascript:launchReportWindow();"><img class="imagelink" src="images/report.gif"></a></td>
                                                    <td width=90px class=toolbar align="center">Create Report</td>
                                                    <td width=10px class=titleseparator align="center">|</td>
                                                    <td width=25px align="center"><a class=itemfontlink href="javascript:launchReportWindowExcel();"><img class="imagelink" src="images/excel.gif"></a></td>
                                                    <td width=90px class=toolbar align="center">Create In Excel</td>
                                                </tr>
                                            </table>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align=left valign=top>
                                            <table border=0 cellpadding=0 cellspacing=0 width=100%>
                                                <tr>
                                                    <td>&nbsp;</td>
                                                </tr>
                                                <tr>
                                                    <td>
                                                        <table width="630px" border=0 cellpadding="0" cellspacing="0">
                                                            <tr>
                                                                <td width="100px" align="left" class="subheading" height="22px">Civilian Posts:</td>
                                                                <td width="60px" height="22px" class="subheading"><input type="checkbox" name="civi" id="civi" value=1></td>
                                                                <td width="60px" align="left" class="subheading" height="22px">Gender</td>
                                                                <td width="100px" height="22px" align="left" class="subheading">
                                                                    <select name="gender" id="gender"  class="itemfont">
                                                                        <option value=1 selected>Both</option>
                                                                        <option value=2>Male</option>
                                                                        <option value=3>Female</option>
                                                                    </select>	                                            
                                                                </td>
                                                                <!--
                                                              	<td width="50px" align="left" class="subheading" height="22px">Active</td>
                                                                <td width="60px"><input name="radpersonnel" type="radio" id="radpersonnel_0" value="1" checked></td>
                                                                <td width="60px" align="left" class="subheading" height="22px">Inactive</td>
                                                                <td width="60px"><input type="radio" name="radpersonnel" value="2" id="radpersonnel_1"></td>
                                                                <td width="40px" align="left" class="subheading" height="22px">Both</td>
                                                                <td width="40px"><input type="radio" name="radpersonnel" value="3" id="radpersonnel_2"></td>
                                                                -->
                                                                
                                                            </tr>
                                                        </table>
                                                	</td>
                                                </tr>
                                                <tr>
                                                    <td colspan="2">&nbsp;</td>
                                                </tr>
                                                <tr>
                                                    <td colspan=2 class=titlearealine  height=1></td> 
                                                </tr>
                                                <tr>
                                                    <td colspan="2">&nbsp;</td>
                                                </tr>
											</table>
                    
                                            <!--Begin listing search criteria-->
                                            
                                            <table border=0 cellpadding=0 cellspacing=0 width=100%>
                                                <tr>
                                                    <td>
                                                        <table>
                                                            <tr>
                                                                <td width="15px" align=left onclick="switchObject('Section1','Icon1','Status1',1);"><font ><img id="Icon1" src="images/plus.gif"></font></td>
                                                                <td width="100px" align=left class="subheading">Qualifications</td>
                                                            </tr>
                                                        </table>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td>
                                                        <table border=0 cellpadding=0 cellspacing=0 >
                                                            <tr>
                                                                <td width=16px></td>
                                                                <td>
                                                                    <% i = 0 %>
                                                                    <% j = rsTypeQList.recordcount - 1 %>
                                                                    <% q = 1 %>
                                                                    <% r = 2 %>
                                                                    <div id="Section1" style="display:none;">
                                                                        <% if not rsTypeQList.eof then %>
                                                                            <% do while not rsTypeQList.eof %>
                                                                                <div style="float:left; display: inline;">
                                                                                <table>
                                                                                    <tr class="toolbar">
                                                                                        <td>&nbsp;</td>
                                                                                        <td valign="middle"><u><%= rsTypeQList("Type") %></u></td>
                                                                                    </tr>                                                                
                                                                                    <tr>
                                                                                        <td width="2">&nbsp;</td>
                                                                                        <td width="180" class="ColorBackground">
                                                                                            <% 
																							   objCmd.commandtext = "spListQs" 
                                                                                               set rsQList = objCmd.Execute	
                                                                                            
                                                                                               Counter = 0 
																							%>
                                                                                            
                                                                                            <select name="<%= rsTypeQList("QTypeID") %>Q" id="<%= rsTypeQList("QTypeID") %>Q" size="<%=itemsListed%>" class="pickbox" style="width:180px;" onChange="MaxSelection(this)"> 
                                                                                            <% doSelect = "Y" %>
                                                                                            <% do while not rsQList.eof %>
                                                                                                <% if rsQList("typeID") = rsTypeQList("QTypeID") then %>
                                                                                                    <option value="<%= rsQList("Qid") %>"><%= rsQList("Description") %></option>
                                                                                                    <% doSelect = "N" %>
                                                                                                <% end if %>
                                                                                                <% rsQList.movenext() %>
                                                                                            <% loop %>
                                                                                            </select>
                                                                                      <% rsQList.movefirst() %></td>
                                                                                    </tr>
                                                                                </table>
                                                                                </div>
                                                                                <% rsTypeQList.movenext %>
                                                                            <% loop %>
                                                                        <% end if %>
                                                                    </div>
                                                                </td>
                                                            </tr>
                                                        </table>
                                                    </td>
                                                </tr>
                                            </table>
                                                                                                                                                                                        
                                            <!--End list Search Criteria-->
                                                
											<table border=0 cellpadding=0 cellspacing=0 width=100%>
                                                <tr>
                                                    <td colspan="6" height="22px">&nbsp;</td>
                                                </tr>
                                                <tr>
                                                    <td colspan=6 class=titlearealine  height=1></td> 
                                                </tr>
                                                <tr>
                                                    <td colspan="6" height="22px">&nbsp;</td>
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
    
</body>
</html>


<script language="javascript">

var win = null;

function switchObject(showHideDiv, switchImgTag, status, whichBox)
{
	var ele = document.getElementById(showHideDiv);
	var imageEle = document.getElementById(switchImgTag);
	var stat = document.getElementById(status);
	
	var divs = new Array ('Section1');
	var imgs = new Array ('Icon1');
	var sta = new Array ('Status1');
	var wb = new Array (1)
	
	if(ele.style.display == "block")
	{
		ele.style.display = "none";
		imageEle.src = "images/plus.gif";
		stat.value = 0;
		deselectBox (whichBox);
	}
	else
	{
		for(var x = 0; x < divs.length; x++)
		{
			divObj = document.getElementById(divs[x])
			imgObj = document.getElementById(imgs[x])
			staObj = document.getElementById(sta[x])
			wbObj = wb[x]
						
			if(divObj.id !== ele.id)
			{
				divObj.style.display = 'none';
				imgObj.src = "images/plus.gif";
				staObj.value = 0;
				deselectBox (wbObj);
			}
		}
				
		ele.style.display = "block";
		imageEle.src = "images/minus.gif";
		stat.value = 1;
	}
	document.getElementById('newattached').value = "";
}

</Script>
<script language="JavaScript">

function deselectBox (whichBox)
{
	switch(whichBox)
	{
		case 1:
			var len = document.frmDetails.elements.length;
			var obj;
			var objlen;
			
			for(var i = 0; i < len; i++)
			{
				
				if(document.frmDetails.elements[i].type == 'select-one')
				{
					obj = document.frmDetails.elements[i].name;
					objlen = obj.substring((obj.length)-1,obj.length);
				
					if(objlen == 'Q')
					{
						document.forms["frmDetails"].elements[obj].selectedIndex = -1;	
					}
				}
			}
		break
	}	
}

function launchReportWindow()
{
	if(win)
	{
		win.close();
	}
	
	if(document.getElementById('newattached').value == "") 
	{
		alert("No items selected");
		return;
	}
	
	qid=document.getElementById('newattached').id;
	//alert("Q is " + qid + " * " + document.getElementById('newattached').value);
	
	var x = (screen.width);
	var y = (screen.height);
	
	document.frmDetails.action="reportsPersAndQsSubmit.asp";
	win = window.open("","Report","top=0,left=0,width="+x+",height="+y+",toolbar=0,menubar=1,scrollbars=1");
	window.setTimeout("document.frmDetails.submit();",500);
}

function launchReportWindowExcel()
{
	if(win)
	{
		win.close();
	}
	
	if(document.getElementById('newattached').value == "") 
	{
		alert("No items selected");
		return;
	}
	
	document.frmDetails.action="reportsPersAndQsExcel.asp";
	document.frmDetails.submit();
}

function MaxSelection(sellobj)
{
	var len = document.frmDetails.elements.length;
	var obj;
	var name = sellobj.name;
	
	for(var i = 0; i < len; i++)
	{
		obj = document.frmDetails.elements[i].name;
		//alert("selected " + name + " * " + obj);
		if(document.frmDetails.elements[i].type == 'select-one' && obj !== 'cboTeam' && obj !== 'gender')
		{
			for(var j = 0; j < len; j++)
			{
				if(name != obj)
				{
					document.getElementById(obj).selectedIndex = -1;
				}
			}
		}
	}
	document.getElementById('newattached').value = document.getElementById(name).value;

//	var len = document.frmDetails.elements.length;
//	var obj;
//	var count = 0;
//	var limit = 20;
//	var newobj = '';
//	var newoptions = '';
//	var newattached = '';
//	
//	for(var i = 0; i < len; i++)
//	{
//		if(document.frmDetails.elements[i].type == 'select-multiple')
//		{
//			obj = document.frmDetails.elements[i].name;
//			for(var j = 0; j < document.getElementById(obj).options.length; j++)
//			{
//				if(document.getElementById(obj)[j].selected)
//				{
//					newobj = newobj + "," + obj;
//					newoptions = newoptions + "," + document.getElementById(obj)[j].index;
//					newattached = newattached + "," + document.getElementById(obj)[j].value;
//					
//					count++
//				}
//			}
//			
//			if(count > limit)
//			{
//				alert("You have exceeded the maximum criteria allowed." + "\nMaximum criteria allowed is " + limit + " options")
//
//				var newobjArray = newobj.split(",");
//				var newoptionsArray = newoptions.split(",");
//
//				for(var k = newobjArray.length - 1; k > limit; k--)
//				{
//					count--
//					document.getElementById(newobjArray[k])[newoptionsArray[k]].selected = false;
//				}
//			}
//			
//			document.getElementById('newattached').value = newattached;
//		}
//	}
}

</script>