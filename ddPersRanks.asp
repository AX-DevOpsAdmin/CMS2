<!--#include file="Connection/Connection.inc" -->
<!--#include file="Includes/adovbs.inc" -->

<%
if request.form("serID") <> "" then
	set objCmd = Server.CreateObject("ADODB.Command")
	set objCmd.ActiveConnection = con
	ObjCmd.ActiveConnection.cursorlocation = 3
	ObjCmd.CommandType = AdCmdStoredProc
	ObjCmd.CommandText = "spListServiceRanks"
	ObjCmd.Parameters.Append ObjCmd.CreateParameter("@serID", adInteger, adParamInput, 4, request.form("serID"))
	set rsRank = ObjCmd.execute
	%>
	
	<select name="cmbRank" id="cmbRank" class="itemfont" style="width:80px;">
		<option value="">...Select...</option>
		<%if not rsRank.eof then
			while not rsRank.eof%>
				<option value="<%=rsRank("RankID")%>"><%=server.HTMLEncode(rsRank("shortDesc"))%></option>
				<%rsRank.movenext
			wend
		end if%>
	</select>&nbsp;<span class="style2">*</span>
<%else%>
	<select name="cmbRank" id="cmbRank" class="itemfont" style="width:80px;">
		<option value="">...Select...</option>
	</select>&nbsp;<span class="style2">*</span>
<%end if%>