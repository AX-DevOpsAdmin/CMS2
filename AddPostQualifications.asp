<!DOCTYPE HTML >
<!--#include file="Includes/security.inc"--> 
<!--#include file="Connection/Connection.inc"-->
<%

Const Hidden = 2

Dim objUpload
Dim strFileName
Dim strPath
dim strFiles
dim strList


strQTypeID = request ("QTypeID")
strGoTo = request("ReturnTo") & "?QTypeID=" & strQTypeID 

if request("postID") <>"" then
	strRecID = request("postID")
	strGoTo = strGoTo & "&postID=" & strRecid 
else
	strRecID = request("RecID")
	strGoTo = strGoTo & "&RecID=" & strRecid 
end if

if Request("newattached") <> "" then

	set objCmd = server.CreateObject("ADODB.Command")
    set objPara = server.CreateObject("ADODB.Parameter")
    objCmd.ActiveConnection = con
    objCmd.Activeconnection.cursorlocation = 3

    objCmd.CommandText = "spAddPostQs"	
	objCmd.CommandType = 4				

	strList = Request("newAttached")

   ' response.write "Status is " & Request("newStatusAttached") & " list is " & Request("newAttached") & " Competent is " & Request("newCompetentAttached")
   ' response.end()

	strStatusList = Request("newStatusAttached")
	strCompetentList = Request("newCompetentAttached")
	strNewStations = split(strList, ",")
	strNewStatus = split(strStatusList, ",")
	strNewCompetences = split(strCompetentList, ",")
	
	for intCount = LBound(strNewStations) TO (UBound(strNewStations))
		if strNewcompetences(intCount) = "True" then
			currentCompetence=1
		else
			currentCompetence=0
		end if
		
		'response.write (strRecID & " * " & request("QTypeID") & " * " & strNewStations(intCount) & "<br>")
		'response.write (strRecID & " * " & request("QTypeID") & " * " & strNewStatus(intCount) & "<br>")
		'response.write (strRecID & " * " & request("QTypeID") & " * " & currentCompetence & "<br> <br>")
		
		set objPara = objCmd.CreateParameter ("PostID",3,1,0, strRecID)
		objCmd.Parameters.Append objPara
		set objPara = objCmd.CreateParameter ("TypeID",3,1,0, request("QTypeID"))
		objCmd.Parameters.Append objPara		
		set objPara = objCmd.CreateParameter ("QID",3,1,0, strNewStations(intCount))
		objCmd.Parameters.Append objPara
		set objPara = objCmd.CreateParameter ("Status",200,1,20, strNewStatus(intCount))
		objCmd.Parameters.Append objPara
                set objPara = objCmd.CreateParameter ("Competent",200,1,20, currentCompetence)
		objCmd.Parameters.Append objPara
				
		objCmd.Execute

		Set comcommand = Nothing

		for x = 1 to objCmd.parameters.count
			objCmd.parameters.delete(0)
		next
	next 
end if

response.Redirect strGoTo
%>