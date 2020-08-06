<!DOCTYPE HTML >

<!--#include file="Includes/security.inc"--> 
<!--#include file="Connection/Connection.inc"-->
<!--#include file="Includes/checkmanager.inc"-->  
<!--#include file="Includes/manageradmin.inc"-->  

<%
Tab=6


set objCmd = server.CreateObject("ADODB.Command")
set objPara = server.CreateObject("ADODB.Parameter")
objCmd.ActiveConnection = con
objCmd.Activeconnection.cursorlocation = 3
objCmd.CommandType = 4		

strCommand = "spPostStaffCurrent"
objCmd.CommandText = strCommand
set objPara = objCmd.CreateParameter ("RecID",3,1,5, request("staffPostID"))
objCmd.Parameters.Append objPara
set rsRecSet = objCmd.Execute	

for x = 1 to objCmd.parameters.count
	objCmd.parameters.delete(0)
next

intHrc= int(request("hrcID"))

%>	
	
<html>
<head>

<!--#include file="Includes/IECompatability.inc"-->


<title>Personnel Details</title>
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
<form action="HierarchyPostStaff.asp" method="get" name="frmDetails">
    <Input name="staffPostID" id="staffPostID" type="Hidden" value=<%=request("staffPostID")%>>
    <Input Type="Hidden" name="startDate" id="startDate" value="<%=rsRecSet("startDate")%>">
    <Input Type="Hidden" name="HiddenDate" id="HiddenDate">
    <input type=hidden name="postID" id="postID" value=<%=request("postID")%>>
    <input type="hidden" name="hrcID" id="hrcID" value=<%=intHrc%>>
    <input name="recID" id="recID" type="hidden" value="<%=request("recID")%>">


    <table border=0 cellpadding=0 cellspacing=0 width=100%>
        <!--#include file="Includes/hierarchyPostDetails.inc"--> 
        <tr height=16 class=SectionHeader>
            <td>
                <table border=0 cellpadding=0 cellspacing=0 >
                    <tr>
                        <td width=8px></td>
                        <td width=20px><img src="images/editgrid.gif" class="imagelink" id="SaveCloseLink" onclick="javascript:saveNew()"></td>
                        <td class=toolbar valign="middle">Save and Close</td>
                    </tr>
                </table>
            </td>
        </tr>
        <tr>
            <td> 
                <p style="color:#F00"><strong> WARNING:</strong> Once Posted Out an Individual can no longer access CMS. <br>
                    If the Posting Date is more than two days in the future you are <strong>STRONGLY</strong> advised to wait <br>
                    until the actual Posting Due Date. Click the <strong>Post</strong> tab to return without Posting Out.
                </p>
                    
                    
                <table border=0 cellpadding=0 cellspacing=0 width=100%>
                    <tr height=16>
                        <td colspan=7></td>
                    </tr>
                    <tr class=columnheading height=22>
                        <td valign="middle" width=2%></td>
                        <td valign="middle" width=13%>Post:</td>
                        <td align=left valign="middle" width=85% class=itemfont  ><%=rsRecSet("description")%></td>
                    </tr>
                    <tr class=columnheading height=22>
                        <td valign="middle"></td>
                        <td valign="middle">Assign No:</td>
                        <td valign="middle" class=itemfont ><%=rsRecSet("assignno")%></td>
                    </tr>
                    <tr class=columnheading height=22>
                        <td valign="middle" ></td>
                        <td valign="middle">Unit:</td>
                        <td valign="middle"  class=itemfont ><%=rsRecSet("hrcname")%></td>
                    </tr>
                    <tr class=columnheading height=22>
                        <td valign="middle"></td>
                        <td valign="middle">Post Holder:</td>
                        <td valign="middle" class=itemfont ><%=rsRecSet("shortdesc")%>&nbsp;<%=rsRecSet("postholder")%>, <%=rsRecSet("FirstName")%></td>
                    </tr>
                    <tr class=columnheading height=22>
                        <td valign="middle"></td>
                        <td valign="middle">Posted In:</td>
                        <td valign="middle" class=itemfont ><%=rsRecSet("startDate")%></td>
                    </tr>
                    <tr class=itemfont  height=22>
                        <td valign="middle" colspan=3></td>
                    </tr>
                    <tr>
                        <td colspan=20 class=titlearealine height=1></td> 
                    </tr>
                    <tr class=itemfont  height=22>
                        <td valign="middle" colspan=3></td>
                    </tr>
                    <tr class=columnheading height=22>
                        <td valign="middle"></td>
                        <td valign="middle">Posted Out:</td>
                        <td valign="middle">
	                        <input name="endDate" type="text" id="endDate" class="itemfont"  style="Width:75px;"  value ="<%=newdate%>" readonly onclick="calSet(this)">
                            &nbsp;<img src="images/cal.gif" alt="Calender" align="absmiddle" onclick="calSet(endDate)" style="cursor:hand;">
                        </td>
                    </tr>    
                </table>
            </td>
        </tr>
        <tr class=itemfont  height=22>
            <td valign="middle"></td>
        </tr>
        <tr>
            <td class=titlearealine  height=1></td> 
        </tr>
    </table>
</form>

<%
con.close
set con=Nothing
%>

</body>
</html>


<script type="text/javascript" src="calendar.js"></script>

<script language="javascript">

var startDateArray = new Array();
var endDateArray = new Array();

var thisDate = window.parent.frmDetails.startDate.value;
var homeString ='javascript:refreshIframeAfterDateSelect("ManningTeamPersonnel.asp");';

window.parent.crumbTrail.innerHTML="<A title='' href='index.asp' class=itemfontlinksmall >Home</A> > <A title='' href='" + homeString + "' class=itemfontlinksmall >Personnel</A> > <font class='youAreHere' >Post Out</font>" 

</script>
<script language="javascript">

document.frmDetails.endDate.value = window.parent.frmDetails.startDate.value;

function saveNew()
{
	var delOK = false 
    
	  var input_box = confirm("WARNING: Once Posted Out then Users CANNOT log on to CMS \n If the Posting date is more than two days in the future you are STRONGLY advised NOT to Post Out now. \n Are you sure you want to Post Out now ? Click Cancel to abandon the Posting")
	  if(input_box==true) {
		    delOK = true;
	        document.frmDetails.action="updatePostOut.asp";
	        document.frmDetails.submit();
	 } 
}

</Script>
