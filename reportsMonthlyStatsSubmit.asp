<!DOCTYPE HTML >

<!--#include file="Includes/security.inc"-->
<!--#include file="Connection/Connection.inc"-->

<%
	set objCmd = server.createobject("ADODB.Command")
	set objPara = server.createobject("ADODB.Parameter")
	objCmd.activeconnection = con
	objCmd.activeconnection.cursorlocation = 3
	objCmd.commandtype = 4

	hrcID = request("cbohrc")
	objCmd.commandtext = "spGetHierarchyDetail"
	
	' now  get the unit
	set objPara = objCmd.createparameter ("hrcID",3,1,0, cint(hrcID))
	objCmd.parameters.append objPara
	set rsHrc = objCmd.execute

    'Retrieves the unit name
    strHrc = rsHrc("hrcname")

	for x = 1 to objCmd.parameters.count
		objCmd.parameters.delete(0)
	next

	
	'If an item has been selected in the Rank select box then the code below will be executed
	if request("RankStatus") = 1 then
		strList = request("ranks") & "," 'To be sent to the Stored Proc to return name list of  selected ranks
		
		objCmd.commandtext = "spGetMonthlyRankStats"
		' Now add reporting parameters
		'set objPara = objCmd.createparameter ("@nodeID",3,1,0,nodeID)
		'objCmd.parameters.append objPara
		set objPara = objCmd.createparameter ("@hrcID",3,1,0, cint(hrcID))
		objCmd.parameters.append objPara
		set objPara = objCmd.createparameter ("@List",200,1,500, strList)
		objCmd.parameters.append objPara
		set rsRank = objCmd.execute	'Execute CommandText when using "ADODB.Command" object'
		
		for x = 1 to objCmd.parameters.count
			objCmd.parameters.delete(0)
		next

	end if
	
	'If the check box is checked then the code below will be executed
	if request("QStatus") = 1 then
		if request("enduring") <> "" then
			strEnduring = request("enduring") & "," 'To be sent to the Stored Proc to return the specialist trained personnel figures 
			
			objCmd.commandtext = "spGetMonthlySpecialistEnduringStats"			
			' Now add reporting parameters
			set objPara = objCmd.createparameter ("@hrcID",3,1,0, cint(hrcID))
			objCmd.parameters.append objPara
			set objPara = objCmd.createparameter ("@Enduring",200,1,500, strEnduring)
			objCmd.parameters.append objPara
			set rsEnduring = objCmd.execute	'Execute CommandText when using "ADODB.Command" object'
			
			for x = 1 to objCmd.parameters.count
			   objCmd.parameters.delete(0)
		    next

		end if

		if request("contingent") <> "" then
			strContingent = request("contingent") & "," 'To be sent to the Stored Proc to return the specialist trained personnel figures 
			objCmd.commandtext = "spGetMonthlySpecialistContingentStats"
			' Now add reporting parameters
			set objPara = objCmd.createparameter ("@hrcID",3,1,0, cint(hrcID))
			objCmd.parameters.append objPara
			set objPara = objCmd.createparameter ("@Contingent",200,1,500, strContingent)
			objCmd.parameters.append objPara
			set rsContingent = objCmd.execute	'Execute CommandText when using "ADODB.Command" object'
			
			for x = 1 to objCmd.parameters.count
			   objCmd.parameters.delete(0)
		    next

		end if
	end if
	
	'If the check box is checked then the code below will be executed
	if request("nep") = 1 then
		objCmd.commandtext = "spGetMonthlyNonEffectiveStats"
		' Now add reporting parameters
		set objPara = objCmd.createparameter ("@hrcID",3,1,0, cint(hrcID))
		objCmd.parameters.append objPara
		set rsNEP = objCmd.execute	'Execute CommandText when using "ADODB.Command" object'
		
		for x = 1 to objCmd.parameters.count
			objCmd.parameters.delete(0)
		next
	end if

	'If an item has been selected in the CCS select box then the code below will be executed
	if request("CCSStatus") = 1 then
		if request("ccs") <> "" then
			strSplit = ""
			strCCS = request("ccs")
			strSplit = split(strCCS, ",")
			
			intCCS = strSplit(0)
			strCCS = strSplit(1)
	
			objCmd.commandtext = "spGetMonthlyCCSStats"			
			' now add reporting parameters
			set objPara = objCmd.createparameter ("@hrcID",3,1,0, cint(hrcID))
			objCmd.parameters.append objPara
			set objPara = objCmd.createparameter ("@msID",3,1,0, cint(intCCS))
			objCmd.parameters.append objPara
			set rsCCS = objCmd.execute	'Execute CommandText when using "ADODB.Command" object'
			
			for x = 1 to objCmd.parameters.count
			    objCmd.parameters.delete(0)
		    next

		end if
	end if
	
	'If an item has been selected in the Fitness select box then the code below will be executed
	if request("fitness") = 1 then
		
		strCommand = "spListFitness"
		objCmd.CommandText = strCommand
		set objPara = objCmd.createparameter ("@nodeID",3,1,0,nodeID)
	    objCmd.parameters.append objPara
		set rsFitnessList = objCmd.Execute	'Execute CommandText when using "ADODB.Command" object'
		
		for x = 1 to objCmd.parameters.count
			objCmd.parameters.delete(0)
		next

		if not rsFitnessList.eof then
			do while not rsFitnessList.eof
				strList = strList & rsFitnessList("fitnessID") & ","
				rsFitnessList.movenext
			loop
		end if
		
		objCmd.commandtext = "spGetMonthlyFitnessStats"
		' now add reporting parameters
		set objPara = objCmd.createparameter ("@hrcID",3,1,0, cint(hrcID))
		objCmd.parameters.append objPara
		set objPara = objCmd.createparameter ("@fitnessID",200,1,800, strList)
		objCmd.parameters.append objPara
		set rsFitness = objCmd.execute	'Execute CommandText when using "ADODB.Command" object'
		
		for x = 1 to objCmd.parameters.count
			objCmd.parameters.delete(0)
		next

	end if
	
	'If an item has been selected in the Data Protection select box then the code below will be executed
	if request("DPStatus") = 1 then
		if request("dprotection") <> "" then
			strSplit = ""
			strDP = request("dprotection")
			strSplit = split(strDP, ",")
			
			intDP = strSplit(0)
			strDp = strSplit(1)
			objCmd.commandtext = "spGetMonthlyDataProtectionStats"
			' now add reporting parameters
			set objPara = objCmd.createparameter ("@hrcID",3,1,0, cint(hrcID))
			objCmd.parameters.append objPara
			set objPara = objCmd.createparameter ("@genID",3,1,0, cint(intDP))
			objCmd.parameters.append objPara
			set rsDP = objCmd.execute	'Execute CommandText when using "ADODB.Command" object'
			
			for x = 1 to objCmd.parameters.count
    			objCmd.parameters.delete(0)
	    	next

		end if
	end if
		
	'If an item has been selected in the Equality and Diversity select box then the code below will be executed
	if request("EDStatus") = 1 then
		if request("ed") <> "" then
			strSplit = ""
			strED = request("ed")
			strSplit = split(strED, ",")
			
			intED = strSplit(0)
			strED = strSplit(1)
			objCmd.commandtext = "spGetMonthlyEqualityDiversityStats"
			' now add reporting parameters
			set objPara = objCmd.createparameter ("@hrcID",3,1,0, cint(hrcID))
			objCmd.parameters.append objPara
			set objPara = objCmd.createparameter ("@genID",3,1,0, cint(intED))
			objCmd.parameters.append objPara
			set rsED = objCmd.execute	'Execute CommandText when using "ADODB.Command" object'
			
			for x = 1 to objCmd.parameters.count
	    		objCmd.parameters.delete(0)
    		next

		end if
	end if
%>

<html>
<head>

<!--#include file="Includes/IECompatability.inc"-->


<title><%= PageTitle %></title>
<link rel="stylesheet" type="text/css" href="Includes/AMDB.css" />
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1"><style type="text/css">
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

<body topmargin="0" leftmargin="0">

	<table width="100%" border="0" cellpadding="0" cellspacing="0">
		<tr class="titlearea">
			<td align="center" height="50px"><U>Management Board Report</U></td>
		</tr>
		<tr>
			<td>&nbsp;</td>
		</tr>
		<tr>
			<td>
                <table width="500px" border=0 cellpadding=0 cellspacing=0 >
                    <tr class="itemfont" height="20px">
                        <td width="10px">&nbsp;</td>
                        <td width="490px" class="itemfont">Unit:&nbsp;<font size="2"><%=strlabel%></font><font color="#0033FF" size="3"><strong><%=strHrc%></strong></font></td>
                    </tr>
                </table>
			</td>
		</tr>
		<% if request("RankStatus") = 1 then %>
			<% if request("ranks") <> "" then %>				 
                <table border="0" cellpadding="0" cellspacing="0" width="100%">
                    <tr height="20px">
                    	<td width="2">&nbsp;</td>
                        <td colspan="5" class="itemfontbold">Personnel</td>
                    </tr>
					<tr>
						<td colspan=6 class=titlearealine  height=1></td> 
					</tr>
                    <tr class="columnheading" height="20px"> 
                    	<td width="2">&nbsp;</td>
                        <td width="200" align="left">Rank</td>
                        <td width="150" align="center">Established</td>
                        <td width="150" align="center">Strength</td>										
                        <td width="150" align="center">Combat Ready</td>										
                        <td width="150" align="center">FEAR</td>										
                    </tr>
					<tr>
						<td colspan=6 class=titlearealine  height=1></td> 
					</tr>
                    <% if not rsRank.eof then %>
                        <% do while not rsRank.eof %>
                            <tr class="itemfont" height="20px">
                            	<td width="2">&nbsp;</td>
                                <td width="200" align="left"><%= rsRank("Rank")%></td>
                                <td width="150" align="center"><%= rsRank("Established")%></td>
                                <td width="150" align="center"><%= rsRank("Strength") %></td>
                                <td width="150" align="center"><%= rsRank("CombatReady") %></td>
                                <td width="150" align="center"><%= rsRank("FEAR") %></td>
                            </tr>
                            <tr>
                                <td colspan=6 class=titlearealine  height=1></td> 
                            </tr>
                            <% rsRank.movenext %>
                        <% loop %>
                    <% end if %>
                </table>
			<% end if %>
		<% end if %>
        
		<% if (request("enduring") <> "" or request("contingent") <> "") and request("ranks") <> "" then %>
            <table border="0" cellpadding="0" cellspacing="0" width="100%">
                <tr>
                    <td>&nbsp;</td>
                </tr>
                <tr>
                    <td>&nbsp;</td>
                </tr>
            </table>
        <% end if %>
		
		<% if request("QStatus") = 1 then %>
			<% if request("enduring") <> "" then %>
                <table border="0" cellpadding="0" cellspacing="0" width="100%">
                    <tr height="20px">
                        <td width="2">&nbsp;</td>
                        <td colspan=5 class="itemfontbold">Specialist Trained Personnel - Enduring</td>
                    </tr>
                    <tr>
                        <td colspan=6 class=titlearealine  height=1></td> 
                    </tr>
                    <tr class="columnheading" height="20px">
                        <td width="2">&nbsp;</td>
                        <td width="200" align="left">Enduring %Qs held (per post)</td>
                        <td width="150" align="center">0-25%</td>
                        <td width="150" align="center">25-50%</td>
                        <td width="150" align="center">50-75%</td>
                        <td width="150" align="center">75-100%</td>
                    </tr>
                    <tr>
                        <td colspan=6 class=titlearealine  height=1></td> 
                    </tr>
                    <tr height="20px">
                        <td width="2">&nbsp;</td>
                        <td width="200" align="left"r class="columnheading">No. of people</td>
                        <td width="150" align="center" class="itemfont"><%= rsEnduring("firstquater") %></td>
                        <td width="150" align="center" class="itemfont"><%= rsEnduring("secondquater") %></td>
                        <td width="150" align="center" class="itemfont"><%= rsEnduring("thirdquater") %></td>
                        <td width="150" align="center" class="itemfont"><%= rsEnduring("fourthquater") %></td>
                    </tr>
                    <tr>
                        <td colspan=6 class=titlearealine  height=1></td> 
                    </tr>
                    
                    <% Set rsEnduring = rsEnduring.NextRecordset %>
                    
                    <tr>
                        <td colspan="6">&nbsp;</td>
                    </tr>
                    <tr class="itemfont" style="color:#808080;">
                        <td>&nbsp;</td>
                        <td width="200">&nbsp;</td>
                        <td width="150" colspan="2" align="center">Requirement</td>
                        <td width="150" colspan="2" align="center">Current</td>
                    </tr>
                    <tr>
                        <td colspan=6 class=titlearealine  height=1></td> 
                    </tr>
                    
                    <% if not rsEnduring.eof then %>
                    	<% do while not rsEnduring.eof %>
                        	<tr class="itemfont" height="20px">
                        		<td>&nbsp;</td> 
                            	<td width="200" align="left" style="color:#808080;"><%= rsEnduring("hrcname") %></td>
                                <td width="150" colspan="2" align="center"><%= rsEnduring("Requirement") %></td>
                                <td width="150" colspan="2" align="center"><%= rsEnduring("Current") %></td>
                            </tr>
                            <tr>
                                <td colspan=6 class=titlearealine  height=1></td> 
                            </tr>
                            <% rsEnduring.movenext %>
						<% loop %>
                    <% end if %>
                </table>
			<% end if %>
                                    
			<% if request("enduring") <> "" and request("contingent") <> "" then %>
                <table border="0" cellpadding="0" cellspacing="0" width="100%">
                    <tr>
                        <td colspan="10">&nbsp;</td>
                    </tr>
                    <tr>
                        <td colspan="10">&nbsp;</td>
                    </tr>
                </table>
            <% end if %>
                                    
			<% if request("contingent") <> "" then %>
                <table border="0" cellpadding="0" cellspacing="0" width="100%">
                    <tr height="20px">
                        <td width="2">&nbsp;</td>
                        <td colspan=5 class="itemfontbold">Specialist Trained Personnel - Contingent</td>
                    </tr>
                    <tr>
                        <td colspan=6 class=titlearealine  height=1></td> 
                    </tr>
                    <tr class="columnheading" height="20px">
                        <td width="2">&nbsp;</td>
                        <td width="200" align="left">Contingent %Qs held (per post)</td>
                        <td width="150" align="center">0-25%</td>
                        <td width="150" align="center">25-50%</td>
                        <td width="150" align="center">50-75%</td>
                        <td width="150" align="center">75-100%</td>
                    </tr>
                    <tr>
                        <td colspan=6 class=titlearealine  height=1></td> 
                    </tr>
                    <tr height="20px">
                        <td width="2">&nbsp;</td>
                        <td width="200" align="left"r class="columnheading">No. of people</td>
                        <td width="150" align="center" class="itemfont"><%= rsContingent("firstquater") %></td>
                        <td width="150" align="center" class="itemfont"><%= rsContingent("secondquater") %></td>
                        <td width="150" align="center" class="itemfont"><%= rsContingent("thirdquater") %></td>
                        <td width="150" align="center" class="itemfont"><%= rsContingent("fourthquater") %></td>
                    </tr>
                    <tr>
                        <td colspan=6 class=titlearealine  height=1></td> 
                    </tr>
                    
                    <% Set rsContingent = rsContingent.NextRecordset %>
                    
                    <tr>
                        <td colspan="6">&nbsp;</td>
                    </tr>
                    <tr class="itemfont" style="color:#808080;">
                        <td>&nbsp;</td>
                        <td width="200">&nbsp;</td>
                        <td width="150" colspan="2" align="center">Requirement</td>
                        <td width="150" colspan="2" align="center">Current</td>
                    </tr>
                    <tr>
                        <td colspan=6 class=titlearealine  height=1></td> 
                    </tr>
                    
                    <% if not rsContingent.eof then %>
                    	<% do while not rsContingent.eof %>
                        	<tr class="itemfont" height="20px">
                        		<td>&nbsp;</td> 
                            	<td width="200" align="left" style="color:#808080;"><%= rsContingent("hrcname") %></td>
                                <td width="150" colspan="2" align="center"><%= rsContingent("Requirement") %></td>
                                <td width="150" colspan="2" align="center"><%= rsContingent("Current") %></td>
                            </tr>
                            <tr>
                                <td colspan=6 class=titlearealine  height=1></td> 
                            </tr>
                            <% rsContingent.movenext %>
						<% loop %>
                    <% end if %>
                </table>
			<% end if %>
		<% end if %>
        
		<% if request("nep") = 1 then %>
            <table border="0" cellpadding="0" cellspacing="0" width="100%">
                <tr>
                    <td colspan="10">&nbsp;</td>
                </tr>
                <tr>
                    <td colspan="10">&nbsp;</td>
                </tr>
            </table>
        <% end if %>
		
		<% if request("nep") = 1 then %>
            <table border="0" cellpadding="0" cellspacing="0" width="100%">
                <tr height="20px">
                    <td width="2">&nbsp;</td>
                    <td class="itemfontbold">Non-Effective</td>
                </tr>
                <tr>
                    <td colspan=2 class=titlearealine  height=1></td> 
                </tr>
			</table>
            <table border="0" cellpadding="0" cellspacing="0" width="100%">
                <tr class="itemfont" style="color:#808080;" height="20px">
                    <td width="150" align="center">Posted within 28 days</td>
                    <td width="150" align="center">Gapped post < 28 days</td>
                    <td width="150" align="center">Gapped post > 28 days</td>										
                    <td width="150" align="center">Non-Deployable</td>										
                    <td width="150" align="center">Permanent Downgrade</td>										
                    <td width="150" align="center">Temp Downgrade</td>										
                </tr>
                <tr>
                    <td colspan=6 class=titlearealine  height=1></td> 
                </tr>
                <% if not rsNEP.eof then %>
                    <% do while not rsNEP.eof %>
                        <tr class="itemfont" height="20px">
                            <td width="150" align="center"><%= rsNEP("Posted")%></td>
                            <td width="150" align="center"><%= rsNEP("LessThan")%></td>
                            <td width="150" align="center"><%= rsNEP("GreaterThan") %></td>
                            <td width="150" align="center"><%= rsNEP("Deployable") %></td>
                            <td width="150" align="center"><%= rsNEP("Permanent") %></td>
                            <td width="150" align="center"><%= rsNEP("Temp") %></td>
                        </tr>
                        <% rsNEP.movenext %>
                    <% loop %>
                <% end if %>
                <tr>
                    <td colspan=6 class=titlearealine  height=1></td> 
                </tr>
            </table>
		<% end if %>
		
		<% if request("ccs") <> "" then %>
            <table border="0" cellpadding="0" cellspacing="0" width="100%">
                <tr>
                    <td colspan="10">&nbsp;</td>
                </tr>
                <tr>
                    <td colspan="10">&nbsp;</td>
                </tr>
            </table>
        <% end if %>
        
		<% if request("CCSStatus") = 1 then %>
			<% if request("ccs") <> "" then %>				 
                <table border="0" cellpadding="0" cellspacing="0" width="100%">
                    <tr height="20px">
                        <td width="2">&nbsp;</td>
                        <td class="itemfontbold"><%= strCCS %></td>
                    </tr>
                    <tr>
                        <td colspan=2 class=titlearealine  height=1></td> 
                    </tr>
                </table>
                <table border="0" cellpadding="0" cellspacing="0" width="100%">
                    <tr class="columnheading" height="20px"> 
                        <td width="150" align="center">Pass</td>
                        <td width="150" align="center">Exempt</td>
                        <td width="150" align="center">Untrained</td>
                    </tr>
                    <tr>
                        <td colspan=3 class=titlearealine  height=1></td> 
                    </tr>
                    <% if not rsCCS.eof then %>
                        <tr class="itemfont" height="20px"> 
                            <td width="150" align="center"><%= rsCCS("Passed")%></td>
                            <td width="150" align="center"><%= rsCCS("Exempt") %></td>
                            <td width="150" align="center"><%= rsCCS("Untrained") %></td>
                        </tr>
                    <% end if %>
                    <tr>
                        <td colspan=3 class=titlearealine  height=1></td> 
                    </tr>
                </table>
			<% end if %>
		<% end if %>
		
		<% if request("fitness") <> "" then %>
            <table border="0" cellpadding="0" cellspacing="0" width="100%">
                <tr>
                    <td colspan="10">&nbsp;</td>
                </tr>
                <tr>
                    <td colspan="10">&nbsp;</td>
                </tr>
            </table>
        <% end if %>
		
		<% if request("fitness") <> "" then %>				 
            <table border="0" cellpadding="0" cellspacing="0" width="450px">
                <tr height="20px">
                    <td width="2">&nbsp;</td>
                    <td class="itemfontbold">Fitness</td>
                </tr>
            </table>
            <table border="0" cellpadding="0" cellspacing="0" width="100%">
                <tr>
                    <td colspan=4 class=titlearealine  height=1></td> 
                </tr>
                <tr class="columnheading" height="20px"> 
                    <td width="150" align="center">Pass</td>
                    <td width="150" align="center">Remedial</td>
                    <td width="150" align="center">Exempt</td>
                    <td width="150" align="center">Untested</td>
                </tr>
                <tr>
                    <td colspan=4 class=titlearealine  height=1></td> 
                </tr>
                <% if not rsFitness.eof then %>
                    <tr class="itemfont" height="20px"> 
                        <td width="150" align="center"><%= rsFitness("Passed")%></td>
                        <td width="150" align="center"><%= rsFitness("Remedial") %></td>
                        <td width="150" align="center"><%= rsFitness("Exempt") %></td>
                        <td width="150" align="center"><%= rsFitness("Untested") %></td>
                    </tr>
                <% end if %>
                <tr>
                    <td colspan=4 class=titlearealine  height=1></td> 
                </tr>
            </table>
        <% end if %>
		
		<% if request("dprotection") <> "" then %>
            <table border="0" cellpadding="0" cellspacing="0" width="100%">
                <tr>
                    <td colspan="10">&nbsp;</td>
                </tr>
                <tr>
                    <td colspan="10">&nbsp;</td>
                </tr>
            </table>
        <% end if %>
		
		<% if request("DPStatus") = 1 then %>
			<% if request("dprotection") <> "" then %>				 
                <table border="0" cellpadding="0" cellspacing="0" width="100%">
                    <tr height="20px">
                        <td width="2">&nbsp;</td>
                        <td class="itemfontbold"><%= strDP %></td>
                    </tr>
                </table>
                <table border="0" cellpadding="0" cellspacing="0" width="100%">
                    <tr>
                        <td colspan=2 class=titlearealine  height=1></td> 
                    </tr>
                    <tr class="columnheading" height="20px"> 
                        <td width="150" align="center">Pass</td>
                        <td width="150" align="center">Untrained</td>
                    </tr>
                    <tr>
                        <td colspan=2 class=titlearealine  height=1></td> 
                    </tr>
                    <% if not rsDP.eof then %>
                        <tr class="itemfont" height="20px"> 
                            <td width="150" align="center"><%= rsDP("Passed")%></td>
                            <td width="150" align="center"><%= rsDP("Untrained") %></td>
                        </tr>
                    <% end if %>
                    <tr>
                        <td colspan=2 class=titlearealine  height=1></td> 
                    </tr>
                </table>
			<% end if %>
		<% end if %>
		
		<% if request("ed") <> "" then %>
            <table border="0" cellpadding="0" cellspacing="0" width="100%">
                <tr>
                    <td colspan="10">&nbsp;</td>
                </tr>
                <tr>
                    <td colspan="10">&nbsp;</td>
                </tr>
            </table>
        <% end if %>
		
		<% if request("EDStatus") = 1 then %>
			<% if request("ed") <> "" then %>				 
                <table border="0" cellpadding="0" cellspacing="0" width="100%">
                    <tr height="20px">
                        <td width="2">&nbsp;</td>
                        <td class="itemfontbold"><%= strED %></td>
                    </tr>
                </table>
                <table border="0" cellpadding="0" cellspacing="0" width="100%">
                    <tr>
                        <td colspan=2 class=titlearealine  height=1></td> 
                    </tr>
                    <tr class="columnheading" height="20px"> 
                        <td width="150" align="center">Pass</td>
                        <td width="150" align="center">Untrained</td>
                    </tr>
                    <tr>
                        <td colspan=2 class=titlearealine  height=1></td> 
                    </tr>
                    <% if not rsED.eof then %>
                        <tr class="itemfont" height="20px"> 
                            <td width="150" align="center"><%= rsED("Passed")%></td>
                            <td width="150" align="center"><%= rsED("Untrained") %></td>
                        </tr>
                    <% end if %>
                    <tr>
                        <td colspan=2 class=titlearealine  height=1></td> 
                    </tr>
                </table>
			<% end if %>
		<% end if %>
	</table>
	
</body>
</html>