<!DOCTYPE HTML >

<!--#include file="Includes/security.inc"-->
<!--#include file="Connection/Connection.inc"-->

<%
	response.ContentType = "application/vnd.ms-excel"
	response.addHeader "content-disposition","attachment;filename=Nominal Role.xls"
	
	location="Reports"
	subLocation="10"
	counter=0

	dim tmID
	
	if request("cboTeam") <> "" then
		tmID = request("cboTeam")
	else
		tmID = 0
	end if

	set objCmd = server.CreateObject("ADODB.Command")
	set objPara = server.CreateObject("ADODB.Parameter")
	objCmd.ActiveConnection = con
	objCmd.Activeconnection.cursorlocation = 3
	objCmd.CommandText = "spNominalRoleList"
	objCmd.CommandType = 4
	
	set objPara = objCmd.CreateParameter ("tmID", 3, 1, 0, tmID)
	objCmd.Parameters.Append objPara
	
	set rsRecSet = objCmd.execute	'Execute CommandText when using "ADODB.Command" object'
	
	intRecords = rsRecSet.recordcount	

	for x = 1 to objCmd.parameters.count
		objCmd.parameters.delete(0)
	next
%>

<HTML>
<HEAD>

<!--#include file="Includes/IECompatability.inc"-->


<title><%= PageTitle %></title>
<link rel="stylesheet" type="text/css" href="Includes/AMDB.css" media="Screen"/>
	<style type="text/css">
<!--
body
{
	background-image: url();
	margin-left: 0px;
	margin-top: 0px;
	margin-right: 0px;
	margin-bottom: 0px;
}

.style1
{
	color: #0000FF
}

.xlTop
{
	border-bottom:.5pt solid black;
}

.xlBottom
{
	mso-style-parent:style0;
	vertical-align:middle;
	text-align:left;
	border-left:.5 solid black;
	border-right:.5pt solid black;
	border-bottom:.5pt solid black;
	white-space:normal;
}

-->
</style>	

</HEAD>

<BODY>

    <table width=100%>
        <tr>
            <td colspan="10">&nbsp;</td>
        </tr>
        <tr>
            <td colspan="10" align="center"><U>CMS - Nominal Role</U></td>
        </tr>
        <tr>
            <td colspan="10">&nbsp;</td>
        </tr>
        <tr>
        	<td colspan="10">Records Found:&nbsp;<%= intRecords %></td>
        </tr>
        <tr>
            <td colspan="10">&nbsp;</td>
        </tr>
        <tr>
            <td style="width: 95pt" class="xlTop"><strong>Service No</strong></td>
            <td style="width: 200pt" class="xlTop"><strong>Name</strong></td>
            <td style="width: 100pt" class="xlTop"><strong>Arrival Date</strong></td>
            <td style="width: 160pt" class="xlTop"><strong>Post</strong></td>
            <td style="width: 100pt" class="xlTop"><strong>Place of Birth</strong></td>
            <td style="widows:100pt" class="xlTop"><strong>Date of Birth</strong></td>
            <td style="width: 130pt" class="xlTop"><strong>Private Address</strong></td>
            <td style="width: 120pt" class="xlTop"><strong>POC</strong></td>
            <td colspan="2" style="width: 90pt" class="xlTop"><strong>Contact No's</strong></td>
        </tr>
        <%do while not rsRecSet.eof%>
            <% strServiceNo = rsRecSet("ServiceNo") %>
            <% if rsRecSet("firstname") <> "" then %> 
                <% strName = rsRecSet("Rank") & " " & rsRecSet("surname") & ", " & rsRecSet("firstname") %>
            <% else %>
                <% strName = rsRecSet("Rank") & " " & rsRecSet("surname") %>
            <% end if %>
            <% strArrDate = rsRecSet("arrivaldate") %>
            <% strPost = rsRecSet("post") %>
            <% strPoB = rsRecSet("pob") %>
            <% strDoB = rsRecSet("dob") %>
            <% strNotes = rsRecSet("Notes") %>
            <% strHome = rsRecSet("homephone") %>
            <% strMobile = rsRecSet("mobileno") %>
            <% strPOC = rsRecSet("poc") %>
            <% strWishes = rsRecSet("welfarewishes") %>
            
            <tr>
                <td rowspan="2" class="xlBottom" style="width: 95pt; height: 34pt; font-size: 12px"><%= strServiceNo %></td>
                <td rowspan="2" class="xlBottom" style="width: 200pt; height: 34pt; font-size: 12px"><%= strName %></td>
                <td rowspan="2" class="xlBottom" style="width: 100pt; height: 34pt; font-size: 12px"><%= strArrDate %></td>
                <td rowspan="2" class="xlBottom" style="width: 160pt; height: 34pt; font-size: 12px"><%= strPost %></td>
                <td rowspan="2" class="xlBottom" style="width: 100pt; height: 34pt; font-size: 12px"><%= strPoB %></td>
                <td rowspan="2" class="xlBottom" style="width: 100pt; height: 34pt; font-size: 12px"><%= strDoB %></td>
                <td rowspan="2" class="xlBottom" style="width: 130pt; height: 34pt; font-size: 12px"><%= strNotes %></td>
                <td rowspan="2" class="xlBottom" style="width: 120pt; height: 34pt; font-size: 12px"><%= strPOC %></td>
                <td style="width: 10pt; height: 17pt; font-size: 12px" class="xlBottom">Home:</td>
                <td style="width: 80pt; height: 17pt; font-size: 12px" class="xlBottom"><%= strHome %></td>
            </tr>
            <tr>
                <td style="width: 10pt; height: 17pt; font-size: 12px" class="xlBottom">Mobile:</td>
                <td style="width: 80pt; height: 17pt; font-size: 12px" class="xlBottom"><%= strMobile %></td>
            </tr>
            <% rsRecSet.movenext %>
        <% loop %>
    </table>

</body>
</html>
