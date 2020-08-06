<!DOCTYPE HTML >

<!--#include file="Includes/security.inc"--> 

<%
' so the menu include - datamenu.inc knows what page we're on
dim strPage
strPage="StaticData"

' This is the CMS Administrator - would be 90SUIXT
' They can add top level Hierarchy and generic data ie: Ranks, Fitness, Dental, Vaccinations
strCMSAdmin = session("CMSAdministrator") 

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

-->
</style>

</head>
<body>
<form action="" method="POST" name="frmDetails">
	<table  height="100%" cellspacing=0 cellPadding=0 width=100% border=0>
    	<tr>
    		<td>
            	<!--#include file="Includes/Header.inc"-->                 
                <table cellSpacing=0 cellPadding=0 width=100% border=0 >
                    <tr style="font-size:10pt;" height=26px>
                        <td width=10><img style="margin-left:10px;" src="cms_icons/png/24x24/process.png" width="24" height="24"></td>
                        <td class="staticdatamenu"><font class="youAreHere">CMS Administrator Menu </font></td>
                    </tr>
                    <tr><td colspan=2 class=titlearealine  height=1></td></tr>
				</table>
               
  				<table width=100% height='<%=session("heightIs")%>px' border=0 cellpadding=0 cellspacing=0>
      				<tr valign=Top>
						<td align="left" class="sidemenuwidth"  background="Images/tableback.png"><!--#include file="Includes/datamenu.inc"--></td>
						<td width=16></td>
						<td align=left>
							
							<table width="100%" height="100%" cellpadding="0" cellspacing="0" class=MenuStyleParent>
                                <tr>
                                    <td width="5%" align="center" height="30">&nbsp;</td>
                                    <td width="10%" align="center" height="30">&nbsp;</td>
                                    <td width="10%" align="center" height="30">&nbsp;</td>
                                    <td width="10%" align="center" height="30">&nbsp;</td>
                                    <td width="10%" align="center" height="30">&nbsp;</td>
                                    <td width="10%" align="center" height="30">&nbsp;</td>
                                    <td width="10%" align="center" height="30">&nbsp;</td>
                                    <td width="10%" align="center" height="30">&nbsp;</td>
                                    <td width="10%" align="center" height="30">&nbsp;</td>
                                    <td width="10%" align="center" height="30">&nbsp;</td>
                                    <td width="5%" align="center" height="30">&nbsp;</td>
                                </tr>
                                <tr>
                                    <td width="5%" align="center" height="30">&nbsp;</td>
                                    <!--
                                    <td width="10%" align="center" height="30"><a title="" href="AdminGroupList.asp">Groups</a></td>
                                    <td width="10%" align="center" height="30"><a title="" href="AdminWingList.asp">Wings</a></td>
                                    <td width="10%" align="center" height="30"><a title="" href="AdminSquadronList.asp">Squadrons</a></td>
                                    <td width="10%" align="center" height="30"><a title="" href="AdminFlightList.asp">Flights</a></td>
                                    <td width="10%" align="center" height="30"><a title="" href="AdminCycleList.asp">Cycles</a></td>
                                    -->
                                    <td width="10%" align="center" height="30"><a title="" href="AdminHierarchyList.asp">Hierarchy</a></td>
                                    <!-- <td width="10%" align="center" height="30"><a title="" href="AdminRanks.asp">Ranks</a></td>-->
                                    <td width="10%" align="center" height="30"><a href="AdminTradeGroupList.asp">Trade Groups</a></td>
                                    <td width="10%" align="center" height="30"><a href="AdminTradeList.asp">Trades </a></td>
                                    <td width="10%" align="center" height="30"><a href="AdminQTypeList.asp">Qualification Types</a></td>
                                    <td width="10%" align="center" height="30"><a href="AdminQList.asp">Qualifications</a></td>
                                    <!--<td width="10%" align="center" height="30"><a href="AdminQWtList.asp">Q Weight</a></td>-->
                                    <td width="10%" align="center" height="30"><a title="" href="AdminPsTyList.asp">Task Type</a></td>

                                	<td width="5%" align="center" height="30">&nbsp;</td>
                                </tr>
                                <tr>
                                    <td width="5%" align="center" height="30">&nbsp;</td>
                                    <td width="10%" align="center" height="30">&nbsp;</td>
                                    <td width="10%" align="center" height="30">&nbsp;</td>
                                    <td width="10%" align="center" height="30">&nbsp;</td>
                                    <td width="10%" align="center" height="30">&nbsp;</td>
                                    <td width="10%" align="center" height="30">&nbsp;</td>
                                    <td width="10%" align="center" height="30">&nbsp;</td>
                                    <td width="10%" align="center" height="30">&nbsp;</td>
                                    <td width="10%" align="center" height="30">&nbsp;</td>
                                    <td width="10%" align="center" height="30">&nbsp;</td>
                                    <td width="5%" align="center" height="30">&nbsp;</td>
                                </tr>

                                <tr>
                                    <td width="5%" align="center" height="30">&nbsp;</td>
                                    
                                    <td width="10%" align="center" height="30"><a title="" href="AdminPsTaList.asp">Task Details</a></td>
                                    
                                    <td width="10%" align="center" height="30"><a title="" href="AdminMSList.asp">Military Skills</a></td>
                                    <!--<td width="10%" align="center" height="30"><a title="" href="AdminMSWeightingList.asp">Skills Weighting</a></td>-->
                                    <td width="10%" align="center" height="30"><a title="" href="AdminValPList.asp">Validity Periods</a></td>
                                    <td width="10%" align="center" height="30"><a title="" href="AdminPostList.asp">Posts</a></td>
                                    <td width="10%" align="center" height="30"><a title="" href="AdminPeRsList.asp">Personnel</a></td>
                                    <td width="10%" align="center" height="30"><a href="AdminHPDetail.asp">Personnel Harmony </a></td>
                                    <!--
                                    <td width="10%" align="center" height="30"><a title="" href="AdminFitnessList.asp">Fitness</a></td>
                                    <td width="10%" align="center" height="30"><a title="" href="AdminVaccinationsList.asp">Vaccinations</a></td>
                                    <td width="10%" align="center" height="30"><a title="" href="AdminDentalList.asp">Dental</a></td>
                                    -->
                                	<td width="5%" align="center" height="30">&nbsp;</td>
                                </tr>
                                <tr>
                                    <td width="5%" align="center" height="30">&nbsp;</td>
                                    <td width="10%" align="center" height="30">&nbsp;</td>
                                    <td width="10%" align="center" height="30">&nbsp;</td>
                                    <td width="10%" align="center" height="30">&nbsp;</td>
                                    <td width="10%" align="center" height="30">&nbsp;</td>
                                    <td width="10%" align="center" height="30">&nbsp;</td>
                                    <td width="10%" align="center" height="30">&nbsp;</td>
                                    <td width="10%" align="center" height="30">&nbsp;</td>
                                    <td width="10%" align="center" height="30">&nbsp;</td>
                                    <td width="10%" align="center" height="30">&nbsp;</td>
                                    <td width="5%" align="center" height="30">&nbsp;</td>
                                </tr>
                                <tr>
                                    <td width="5%" align="center" height="30">&nbsp;</td>
                                    
                                    
                                    
                                    <td width="10%" align="center" height="30"><a href="AdminUnitHPDetail.asp">Unit Harmony </a></td>
                                   
                                    <td width="10%" align="center" height="30"><a title="" href="AdminMESList.asp">MES</a></td>
                                    <td width="10%" align="center" height="30"><a title="" href="AdminSSCList.asp">Separated Service Codes</a></td>
                                    <!--<td width="10%" align="center" height="30"><a title="" href="AdminCondFList.asp">Conditional Formats</a></td>-->
                                    <td width="10%" align="center" height="30"><a title="" href="AdminContactList.asp">Contact</a></td>
                                    <td width="10%" align="center" height="30"><a title="" href="AdminConfigList.asp">Configuration</a></td>
                                    <!--
                                    <td width="10%" align="center" height="30"><a href="AdminooadList.asp">OOA Max Days</a></td>
                                    <td width="10%" align="center" height="30"><a title="" href="AdminHmGlList.asp">Harmony Guidelines</a></td>
                                    -->
                                	<td width="5%" align="center" height="30">&nbsp;</td>
                                </tr>
                                <tr>
                                    <td width="5%" align="center" height="30">&nbsp;</td>
                                    <td width="10%" align="center" height="30">&nbsp;</td>
                                    <td width="10%" align="center" height="30">&nbsp;</td>
                                    <td width="10%" align="center" height="30">&nbsp;</td>
                                    <td width="10%" align="center" height="30">&nbsp;</td>
                                    <td width="10%" align="center" height="30">&nbsp;</td>
                                    <td width="10%" align="center" height="30">&nbsp;</td>
                                    <td width="10%" align="center" height="30">&nbsp;</td>
                                    <td width="10%" align="center" height="30">&nbsp;</td>
                                    <td width="10%" align="center" height="30">&nbsp;</td>
                                    <td width="5%" align="center" height="30">&nbsp;</td>
                                </tr>

                                <tr>
                                    
                                    <!--<td width="10%" align="center" height="30"><a title="" href="AdminGenPW.asp">Change Default Password</a></td>
                                    <%' if session("RAFP") = 1 then %><td width="10%" align="center" height="30"><a title="" href="UploadExcel.asp">View/Upload Spreadsheet</a></td><%' end if %>-->
                                    <td width="5%" align="center" height="30">&nbsp;</td>
                                    
                                    
                                    <td width="10%" align="center" height="30"><!--<a title="" href="encryptPW.asp">Encrypt Passwords</a>--></td>
                                    <td width="10%" align="center" height="30">&nbsp;</td>
                                	<td width="5%" align="center" height="30">&nbsp;</td>
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
/**
function OverBackgroundChange(itemID){
    itemID.className='testTabHover';
}

function OutBackgroundChange(itemID){
    itemID.className='testTabUnselected';
}
**/
</Script>
