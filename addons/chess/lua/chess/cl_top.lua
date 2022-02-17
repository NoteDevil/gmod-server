
local Top10
local function ChessTop10()
	if IsValid(Top10) then Top10:Remove() end
	
	Top10 = vgui.Create( "DFrame" )
	Top10:SetSize( 300, 200 )
	Top10:SetPos( (ScrW()/2)-150, (ScrH()/2)-100 )
	Top10:SetTitle( "Top 10 Chess Elo ratings" )
	Top10:MakePopup()
	Top10.Column = "Elo"
	
	Top10.List = vgui.Create( "DListView", Top10 )
	local List = Top10.List
	List:Dock( FILL )
	List:AddColumn( "Name" )
	List:AddColumn( "SteamID" )
	List:AddColumn( "Elo" )
	
	List:AddLine( "Loading..." )
	
	net.Start( "Chess Top10" ) net.WriteString( "Chess" ) net.SendToServer()
end
local function DraughtsTop10()
	if IsValid(Top10) then Top10:Remove() end
	
	Top10 = vgui.Create( "DFrame" )
	Top10:SetSize( 300, 200 )
	Top10:SetPos( (ScrW()/2)-150, (ScrH()/2)-100 )
	Top10:SetTitle( "Top 10 Draughts/Checkers Elo ratings" )
	Top10:MakePopup()
	Top10.Column = "DraughtsElo"
	
	Top10.List = vgui.Create( "DListView", Top10 )
	local List = Top10.List
	List:Dock( FILL )
	List:AddColumn( "Name" )
	List:AddColumn( "SteamID" )
	List:AddColumn( "Elo" )
	
	List:AddLine( "Loading..." )
	
	net.Start( "Chess Top10" ) net.WriteString( "Draughts" ) net.SendToServer()
end
concommand.Add( "chess_top", function( p,c,a ) ChessTop10() end)

local ChatCommands = {
	["!chess"]=ChessTop10,	["!chesstop"]=ChessTop10,	["!topchess"]=ChessTop10,
	["/chess"]=ChessTop10,	["/chesstop"]=ChessTop10,	["/topchess"]=ChessTop10,
	
	["!draughts"]=DraughtsTop10,	["!draughtstop"]=DraughtsTop10,	["!topdraughts"]=DraughtsTop10,
	["/draughts"]=DraughtsTop10,	["/draughtstop"]=DraughtsTop10,	["/topdraughts"]=DraughtsTop10,
	
	["!checkers"]=DraughtsTop10,	["!checkerstop"]=DraughtsTop10,	["!topcheckers"]=DraughtsTop10,
	["/checkers"]=DraughtsTop10,	["/checkerstop"]=DraughtsTop10,	["/topcheckers"]=DraughtsTop10,
}
hook.Add( "OnPlayerChat", "Chess Top10 PlayerChat", function( ply, str, tm, dead )
	if ChatCommands[str:lower()] then
		if ply==LocalPlayer() then
			ChatCommands[str:lower()]()
		end
		return true
	end
end)

net.Receive( "Chess Top10", function()
	if not (IsValid(Top10) and IsValid(Top10.List)) then return end
	
	Top10.List:Clear()
	
	local tbl = net.ReadTable()
	if not tbl then return end
	
	for i=1,#tbl do
		Top10.List:AddLine( tbl[i].Username, tbl[i].SteamID, tbl[i][ Top10.Column or "Elo" ] )
	end
end)