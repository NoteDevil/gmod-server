
local function InitChessLeaderboard()
	if sql.TableExists("ChessLeaderboard") then
		sql.Begin()
			local query = sql.Query( [[ALTER TABLE ChessLeaderboard ADD DraughtsElo int;]])
		sql.Commit()
		
		if query==false then
			if sql.LastError()~="duplicate column name: DraughtsElo" then --Yeah, sql.Query doesn't like IF
				Error( "Chess: SQL Column insertion failed - Query error. "..sql.LastError().."\n" )
			end
		else
			print( "Chess: Added Draughts column to Elo table" )
		end
		return
	end
	sql.Begin()
		local query = sql.Query( [[CREATE TABLE ChessLeaderboard (SteamID varchar(255), Username varchar(255), Elo int, DraughtsElo int);]] )
	sql.Commit()
	
	if query==false then ErrorNoHalt( "Chess: SQL Table Creation failed." ) else print("Chess: Created Elo table") end
end
InitChessLeaderboard()

function Chess_UpdateElo( ply )
	if not IsValid(ply) then return end
	
	local SelStr = [[SELECT * FROM ChessLeaderboard WHERE SteamID==]].. sql.SQLStr(ply:SteamID()) ..[[;]]
	sql.Begin()
		local Select = sql.Query( SelStr )
	sql.Commit()
	
	local UpdateStr
	if Select==false then
		Error( "Chess: Save failed for player "..ply:Nick().." - Query error. "..sql.LastError().."\n" )
	elseif Select==nil then
		UpdateStr = [[INSERT INTO ChessLeaderboard (SteamID, Username, Elo, DraughtsElo) VALUES (]]..sql.SQLStr(ply:SteamID())..[[,]]..sql.SQLStr(ply:Nick())..[[,]]..sql.SQLStr(ply:GetChessElo())..[[,]]..sql.SQLStr(ply:GetDraughtsElo())..[[);]]
	else
		UpdateStr = [[UPDATE ChessLeaderboard SET Username=]]..sql.SQLStr(ply:GetName())..[[,Elo=]]..sql.SQLStr(ply:GetChessElo())..[[,DraughtsElo=]]..sql.SQLStr(ply:GetDraughtsElo())..[[ WHERE SteamID==]]..sql.SQLStr(ply:SteamID())..[[;]]
	end
	
	sql.Begin()
		local Update = sql.Query( UpdateStr )
	sql.Commit()
	
	if Update==false then
		Error( "Chess: Update failed for player "..ply:Nick().." - Query error. "..sql.LastError().."\n" )
	end
end

util.AddNetworkString( "Chess Top10" )
net.Receive( "Chess Top10", function( len, ply )
	if not IsValid(ply) then return end
	
	local typ = net.ReadString()
	sql.Begin()
		local Top10 = sql.Query( [[SELECT * FROM ChessLeaderboard ORDER BY ]].. (typ=="Draughts" and [[DraughtsElo]] or [[Elo]]) ..[[ DESC LIMIT 10;]] )
	sql.Commit()
	
	if Top10==false then
		Error( "Chess: Top10 retreival failed - Query error. "..sql.LastError().."\n" )
	elseif Top10==nil then
		Error( "Chess: Top10 retreival failed - No data." )
	else
		net.Start( "Chess Top10" )
			net.WriteTable( Top10 )
		net.Send( ply )
	end
end)
