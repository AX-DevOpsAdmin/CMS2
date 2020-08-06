<!DOCTYPE HTML >

<!--#include file="Includes/security.inc"-->
<!--#include file="Connection/Connection.inc"-->

<%
	response.ContentType = "application/vnd.ms-excel"
	response.addHeader "content-disposition","attachment;filename=newReport.xls"
	
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
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">

<style type="text/css">
<!--
body {
	background-image: url();
	margin-left: 0pt;
	margin-top: 0pt;
	margin-right: 0pt;
	margin-bottom: 0pt;
}
.style1 {color: #0000FF}

.xl27
	{mso-style-parent:style0;
	border-top:.5pt solid windowtext;
	border-right:none;
	border-bottom:.5pt solid windowtext;
	border-left:none;
	white-space:normal;}
	
.xl29
	{mso-style-parent:style0;
	mso-number-format:"\@";
	border-top:.5pt solid windowtext;
	border-right:none;
	border-bottom:.5pt solid windowtext;
	border-left:none;
	white-space:normal;}
-->
</style>

</head>
<body topmargin="0" leftmargin="0">
	<table border="0" cellpadding="0" cellspacing="0">
		<tr class="titlearea">
			<td colspan="6" align="center" style="font-size:14pt;"><U>Management Board Report</U></td>
		</tr>
		<tr>
			<td colspan="6">&nbsp;</td>
		</tr>
		<tr>
			<td colspan="6" class="itemfont">Unit:&nbsp;<font color="#0033FF" size="2"><strong><%=strTeam%></strong></font></td>
		</tr>
		<tr>
			<td colspan="6">&nbsp;</td>
		</tr>
		<% if request("RankStatus") = 1 then %>				 
			<% if request("ranks") <> "" then %>				 
                <tr>
                    <td colspan="6"><strong>Personnel</strong></td>
                </tr>
                <tr> 
                    <td width="200" align="left" class="xl27"><strong>Rank</strong></td>
                    <td width="150" align="center" class="xl27"><strong>Established</strong></td>
                    <td width="150" align="center" class="xl27"><strong>Strength</strong></td>										
                    <td width="150" align="center" class="xl27"><strong>Combat Ready</strong></td>										
                    <td width="150" align="center" class="xl27"><strong>FEAR</strong></td>
                    <td width="150" class="xl27">&nbsp;</td>										
                </tr>
                <% if not rsRank.eof then %>
                    <% do while not rsRank.eof %>
                        <tr> 
                            <td width="200" align="left" class="xl27"><%= rsRank("Rank")%></td>
                            <td width="150" align="center" class="xl27"><%= rsRank("Established")%></td>
                            <td width="150" align="center" class="xl27"><%= rsRank("Strength") %></td>
                            <td width="150" align="center" class="xl27"><%= rsRank("CombatReady") %></td>
                            <td width="150" align="center" class="xl27"><%= rsRank("FEAR") %></td>
		                    <td width="150" class="xl27">&nbsp;</td>										
                        </tr>
                        <% rsRank.movenext %>
                    <% loop %>
                <% end if %>
			<% end if %>
		<% end if %>
        
		<% if (request("enduring") <> "" or request("contingent") <> "") and request("ranks") <> "" then %>
            <tr>
                <td colspan="6">&nbsp;</td>
            </tr>
            <tr>
                <td colspan="6">&nbsp;</td>
            </tr>
        <% end if %>
		
		<% if request("QStatus") = 1 then %>				 
			<% if request("enduring") <> "" then %>	
                <tr>
                    <td colspan=6><strong>Specialist Trained Personnel - Enduring</strong></td>
                </tr>
                <tr>
                    <td width="200" align="left" class="xl27"><strong>Enduring %Qs held (per post)</strong></td>
                    <td width="150" align="center" class="xl27"><strong>0-25%</strong></td>
                    <td width="150" align="center" class="xl27"><strong>25-50%</strong></td>
                    <td width="150" align="center" class="xl27"><strong>50-75%</strong></td>
                    <td width="150" align="center" class="xl27"><strong>75-100%</strong></td>
                    <td width="150" class="xl27">&nbsp;</td>										
                </tr>
                <tr>
                    <td width="200" align="left" style="color:#808080;" class="xl27"><strong>No. of people</strong></td>
                    <td width="150" align="center" class="xl27"><%= rsEnduring("firstquater") %></td>
                    <td width="150" align="center" class="xl27"><%= rsEnduring("secondquater") %></td>
                    <td width="150" align="center" class="xl27"><%= rsEnduring("thirdquater") %></td>
                    <td width="150" align="center" class="xl27"><%= rsEnduring("fourthquater") %></td>
                    <td width="150" class="xl27">&nbsp;</td>										
                </tr>
                
                <% Set rsEnduring = rsEnduring.NextRecordset %>
                
                <tr>
                    <td colspan="5">&nbsp;</td>
                </tr>
                <tr>
                    <td width="200" class="xl27">&nbsp;</td>
                    <td width="150" colspan="2" align="center" class="xl27"><strong>Requirement</strong></td>
                    <td width="150" colspan="2" align="center" class="xl27"><strong>Current</strong></td>
                    <td width="150" class="xl27">&nbsp;</td>										
                </tr>
                
                <% if not rsEnduring.eof then %>
                    <% do while not rsEnduring.eof %>
                        <tr>
                            <td width="200" align="left" class="xl27"><%= rsEnduring("hrcname") %></td>
                            <td width="150" colspan="2" align="center" class="xl27"><%= rsEnduring("Requirement") %></td>
                            <td width="150" colspan="2" align="center" class="xl27"><%= rsEnduring("Current") %></td>
		                    <td width="150" class="xl27">&nbsp;</td>										
                        </tr>
                        <% rsEnduring.movenext %>
                    <% loop %>
                <% end if %>
			<% end if %>
                
			<% if request("enduring") <> "" and request("contingent") <> "" then %>        
                <tr>
                    <td colspan="6">&nbsp;</td>
                </tr>
                <tr>
                    <td colspan="6">&nbsp;</td>
                </tr>
            <% end if %>
                
			<% if request("contingent") <> "" then %>				
                <tr height="20px">
                    <td colspan=6><strong>Specialist Trained Personnel - Contingent</strong></td>
                </tr>
                <tr>
                    <td width="200" align="left" class="xl27"><strong>Contingent %Qs held (per post)</strong></td>
                    <td width="150" align="center" class="xl27"><strong>0-25%</strong></td>
                    <td width="150" align="center" class="xl27"><strong>25-50%</strong></td>
                    <td width="150" align="center" class="xl27"><strong>50-75%</strong></td>
                    <td width="150" align="center" class="xl27"><strong>75-100%</strong></td>
                    <td width="150" class="xl27">&nbsp;</td>										
                </tr>
                <tr>
                    <td width="200" align="left" style="color:#808080;" class="xl27"><strong>No. of people</strong></td>
                    <td width="150" align="center" class="xl27"><%= rsContingent("firstquater") %></td>
                    <td width="150" align="center" class="xl27"><%= rsContingent("secondquater") %></td>
                    <td width="150" align="center" class="xl27"><%= rsContingent("thirdquater") %></td>
                    <td width="150" align="center" class="xl27"><%= rsContingent("fourthquater") %></td>
                    <td width="150" class="xl27">&nbsp;</td>										
                </tr>
                
                <% Set rsContingent = rsContingent.NextRecordset %>
                
                <tr>
                    <td colspan="6">&nbsp;</td>
                </tr>
                <tr>
                    <td width="200" class="xl27">&nbsp;</td>
                    <td width="150" colspan="2" align="center" class="xl27"><strong>Requirement</strong></td>
                    <td width="150" colspan="2" align="center" class="xl27"><strong>Current</strong></td>
                    <td width="150" class="xl27">&nbsp;</td>										
                </tr>
                
                <% if not rsContingent.eof then %>
                    <% do while not rsContingent.eof %>
                        <tr>
                            <td width="200" align="left" class="xl27"><%= rsContingent("hrcname") %></td>
                            <td width="150" colspan="2" align="center" class="xl27"><%= rsContingent("Requirement") %></td>
                            <td width="150" colspan="2" align="center" class="xl27"><%= rsContingent("Current") %></td>
		                    <td width="150" class="xl27">&nbsp;</td>										
                        </tr>
                        <% rsContingent.movenext %>
                    <% loop %>
                <% end if %>
            <% end if %>
		<% end if %>
        
		<% if request("nep") = 1 then %>
            <tr>
                <td colspan="6">&nbsp;</td>
            </tr>
            <tr>
                <td colspan="6">&nbsp;</td>
            </tr>
        <% end if %>

		<% if request("nep") = 1 then %>				 
            <tr>
                <td colspan="6"><strong>Non-Effective</strong></td>
            </tr>
            <tr>
                <td width="150" align="center" class="xl27"><strong>Posted within 28 days</strong></td>
                <td width="150" align="center" class="xl27"><strong>Gapped post < 28 days</strong></td>
                <td width="150" align="center" class="xl27"><strong>Gapped post > 28 days</strong></td>										
                <td width="150" align="center" class="xl27"><strong>Non-Deployable</strong></td>										
                <td width="150" align="center" class="xl27"><strong>Permanent Downgrade</strong></td>										
                <td width="150" align="center" class="xl27"><strong>Temp Downgrade</strong></td>										
            </tr>
    
            <% if not rsNEP.eof then %>
                <% do while not rsNEP.eof %>
                    <tr>
                        <td width="150" align="center" class="xl27"><%= rsNEP("Posted")%></td>
                        <td width="150" align="center" class="xl27"><%= rsNEP("LessThan")%></td>
                        <td width="150" align="center" class="xl27"><%= rsNEP("GreaterThan") %></td>
                        <td width="150" align="center" class="xl27"><%= rsNEP("Deployable") %></td>
                        <td width="150" align="center" class="xl27"><%= rsNEP("Permanent") %></td>
                        <td width="150" align="center" class="xl27"><%= rsNEP("Temp") %></td>
                    </tr>
                    <% rsNEP.movenext %>
                <% loop %>
            <% end if %>
		<% end if %>
		
		<% if request("ccs") <> "" then %>
            <tr>
                <td colspan="6">&nbsp;</td>
            </tr>
            <tr>
                <td colspan="6">&nbsp;</td>
            </tr>
        <% end if %>

		<% if request("CCSStatus") = 1 then %>				 
			<% if request("ccs") <> "" then %>				 
                <tr>
                    <td colspan="6"><strong><%= strCCS %></strong></td>
                </tr>
                <tr> 
                    <td width="150" align="center" class="xl27"><strong>Pass</strong></td>
                    <td width="150" align="center" class="xl27"><strong>Exempt</strong></td>
                    <td width="150" align="center" class="xl27"><strong>Untrained</strong></td>
                    <td width="150" class="xl27">&nbsp;</td>
					<td width="150" class="xl27">&nbsp;</td>
					<td width="150" class="xl27">&nbsp;</td>
                </tr>
                
                <% if not rsCCS.eof then %>
                    <tr> 
                        <td width="150" align="center" class="xl27"><%= rsCCS("Passed")%></td>
                        <td width="150" align="center" class="xl27"><%= rsCCS("Exempt") %></td>
                        <td width="150" align="center" class="xl27"><%= rsCCS("Untrained") %></td>
                        <td width="150" class="xl27">&nbsp;</td>
                        <td width="150" class="xl27">&nbsp;</td>
                        <td width="150" class="xl27">&nbsp;</td>
                    </tr>
                <% end if %>
			<% end if %>
		<% end if %>
		
		<% if request("fitness") <> "" then %>
                <tr>
                    <td colspan="6">&nbsp;</td>
                </tr>
                <tr>
                    <td colspan="6">&nbsp;</td>
                </tr>
        <% end if %>
				
		<% if request("fitness") <> "" then %>				 
            <tr>
                <td colspan="6"><strong>Fitness</strong></td>
            </tr>
            <tr> 
                <td width="150" align="center" class="xl27"><strong>Pass</strong></td>
                <td width="150" align="center" class="xl27"><strong>Remedial</strong></td>
                <td width="150" align="center" class="xl27"><strong>Exempt</strong></td>
                <td width="150" align="center" class="xl27"><strong>Untested</strong></td>
                <td width="150" class="xl27">&nbsp;</td>
                <td width="150" class="xl27">&nbsp;</td>
            </tr>

            <% if not rsFitness.eof then %>
                <tr> 
                    <td width="150" align="center" class="xl27"><%= rsFitness("Passed")%></td>
                    <td width="150" align="center" class="xl27"><%= rsFitness("Remedial") %></td>
                    <td width="150" align="center" class="xl27"><%= rsFitness("Exempt") %></td>
                    <td width="150" align="center" class="xl27"><%= rsFitness("Untested") %></td>
                    <td width="150" class="xl27">&nbsp;</td>
                    <td width="150" class="xl27">&nbsp;</td>
                </tr>
            <% end if %>
        <% end if %>
        
		<% if request("dprotection") <> "" then %>
            <tr>
                <td colspan="6">&nbsp;</td>
            </tr>
            <tr>
                <td colspan="6">&nbsp;</td>
            </tr>
        <% end if %>
		
		<% if request("DPStatus") = 1 then %>
			<% if request("dprotection") <> "" then %>				 
                <tr>
                    <td colspan="6"><strong><%= strDP %></strong></td>
                </tr>
                <tr> 
                    <td width="150" align="center" class="xl27"><strong>Pass</strong></td>
                    <td width="150" align="center" class="xl27"><strong>Untrained</strong></td>
                    <td width="150" class="xl27">&nbsp;</td>
                    <td width="150" class="xl27">&nbsp;</td>
                    <td width="150" class="xl27">&nbsp;</td>
                    <td width="150" class="xl27">&nbsp;</td>
                </tr>
                
                <% if not rsDP.eof then %>
                    <tr> 
                        <td width="150" align="center" class="xl27"><%= rsDP("Passed")%></td>
                        <td width="150" align="center" class="xl27"><%= rsDP("Untrained") %></td>
                        <td width="150" class="xl27">&nbsp;</td>
                        <td width="150" class="xl27">&nbsp;</td>
                        <td width="150" class="xl27">&nbsp;</td>
                        <td width="150" class="xl27">&nbsp;</td>
                    </tr>
                <% end if %>
			<% end if %>
		<% end if %>
		
		<% if request("ed") <> "" then %>
            <tr>
                <td colspan="6">&nbsp;</td>
            </tr>
            <tr>
                <td colspan="6">&nbsp;</td>
            </tr>
        <% end if %>
		
		<% if request("EDStatus") = 1 then %>
			<% if request("ed") <> "" then %>				 
                    <tr>
                        <td colspan="6"><strong><%= strED %></strong></td>
                    </tr>
                    <tr> 
                        <td width="150" align="center" class="xl27"><strong>Pass</strong></td>
                        <td width="150" align="center" class="xl27"><strong>Untrained</strong></td>
                        <td width="150" class="xl27">&nbsp;</td>
                        <td width="150" class="xl27">&nbsp;</td>
                        <td width="150" class="xl27">&nbsp;</td>
                        <td width="150" class="xl27">&nbsp;</td>
                    </tr>

                    <% if not rsED.eof then %>
                        <tr> 
                            <td width="150" align="center" class="xl27"><%= rsED("Passed")%></td>
                            <td width="150" align="center" class="xl27"><%= rsED("Untrained") %></td>
                            <td width="150" class="xl27">&nbsp;</td>
                            <td width="150" class="xl27">&nbsp;</td>
                            <td width="150" class="xl27">&nbsp;</td>
                            <td width="150" class="xl27">&nbsp;</td>
                        </tr>
                    <% end if %>
                </table>
			<% end if %>
		<% end if %>
	</table>
	
</body>
</html>

<script language="JavaScript">

function winClose()
{
	window.close()
}

</script>