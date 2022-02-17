
local PLAYER = FindMetaTable( "Player" )
if not PLAYER then return end

function PLAYER:GetChessElo()
	return self:GetNWInt( "ChessElo", 1400 ) or 1400
end
function PLAYER:GetDraughtsElo()
	return self:GetNWInt( "DraughtsElo", 1400 ) or 1400
end
if CLIENT then return end
function PLAYER:SetChessElo( num )
	self:SetNWInt( "ChessElo", num or self:GetPData( "ChessElo", 1400) or 1400 )
	self:SetPData( "ChessElo", self:GetChessElo() )
end
function PLAYER:SetDraughtsElo( num )
	self:SetNWInt( "DraughtsElo", num or self:GetPData( "DraughtsElo", 1400) or 1400 )
	self:SetPData( "DraughtsElo", self:GetDraughtsElo() )
end
hook.Add( "PlayerInitialSpawn", "Chess InitialSpawn InitElo", function(ply)
	ply:SetChessElo(ply:GetPData( "ChessElo", 1400) or 1400)
	ply:SetDraughtsElo(ply:GetPData( "DraughtsElo", 1400) or 1400)
end)

function PLAYER:ExpectedChessWin( against )
	return (1/ (1+( 10^( (against:GetChessElo() - self:GetChessElo())/400 ) )) )
end
function PLAYER:ExpectedDraughtsWin( against )
	return (1/ (1+( 10^( (against:GetDraughtsElo() - self:GetDraughtsElo())/400 ) )) )
end

function PLAYER:GetChessKFactor() --Imitating FIDE's K-factor ranges
	local games = self:GetPData( "ChessGamesPlayed", 0 )
	if games<30 then
		self:SetPData( "ChessEloKFactor", 15 )
		return 30
	end
	local k = self:GetChessElo()>=2400 and 10 or self:GetPData( "ChessEloKFactor", 15 ) or 15
	self:SetPData( "ChessEloKFactor", k )
	return k
end
function PLAYER:GetDraughtsKFactor() --Imitating FIDE's K-factor ranges
	local games = self:GetPData( "DraughtsGamesPlayed", 0 )
	if games<30 then
		self:SetPData( "DraughtsEloKFactor", 15 )
		return 30
	end
	local k = self:GetDraughtsElo()>=2400 and 10 or self:GetPData( "DraughtsEloKFactor", 15 ) or 15
	self:SetPData( "DraughtsEloKFactor", k )
	return k
end

function PLAYER:DoChessElo( score, expected )
	local K = self:GetChessKFactor()
	local NewRank = math.floor( self:GetChessElo() + (K*(score-expected)) )
	
	self:ChatPrint( "Your chess Elo rating changed by "..tostring(NewRank-self:GetChessElo()).." to "..tostring(NewRank).."!" )
	self:SetChessElo( NewRank )
	
	Chess_UpdateElo( self )
end
function PLAYER:ChessWin( against ) self:DoChessElo(1, self:ExpectedChessWin(against)) end
function PLAYER:ChessDraw( against ) self:DoChessElo(0.5, self:ExpectedChessWin(against)) end
function PLAYER:ChessLose( against ) self:DoChessElo(0, self:ExpectedChessWin(against)) end

function PLAYER:DoDraughtsElo( score, expected )
	local K = self:GetDraughtsKFactor()
	local NewRank = math.floor( self:GetDraughtsElo() + (K*(score-expected)) )
	
	self:ChatPrint( "Your draughts Elo rating changed by "..tostring(NewRank-self:GetDraughtsElo()).." to "..tostring(NewRank).."!" )
	self:SetDraughtsElo( NewRank )
	
	Chess_UpdateElo( self )
end
function PLAYER:DraughtsWin( against ) self:DoDraughtsElo(1, self:ExpectedDraughtsWin(against)) end
function PLAYER:DraughtsDraw( against ) self:DoDraughtsElo(0.5, self:ExpectedDraughtsWin(against)) end
function PLAYER:DraughtsLose( against ) self:DoDraughtsElo(0, self:ExpectedDraughtsWin(against)) end
