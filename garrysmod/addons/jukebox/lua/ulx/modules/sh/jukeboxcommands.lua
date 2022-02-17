local ULX_CAT = "Jukebox"

local function SpawnJukeboxes()
	if file.Exists("jukebox/"..game.GetMap()..".txt","DATA") then
		local spawns = util.JSONToTable(file.Read("jukebox/"..game.GetMap()..".txt","DATA"))
		for k,v in pairs(spawns) do
			local offset = Vector(0,0,41)
			offset:Add(v.Ang:Right()*19)
			local jb = ents.Create("jukebox")
			jb:SetPos(v.Pos+offset)
			jb:SetAngles(v.Ang)
			jb:Spawn()
			jb:Activate()
			
			jb:SetMoveType(MOVETYPE_NONE)
		end
	end
end
	
function ulx.addspawn(calling_ply)
	local pos,ang = calling_ply:GetPos(), Angle(0,calling_ply:EyeAngles().y,0)
    local spawns = util.JSONToTable(file.Read("jukebox/"..game.GetMap()..".txt","DATA"))
	table.insert(spawns,{Pos=pos,Ang=ang})
	file.Write("jukebox/"..game.GetMap()..".txt",util.TableToJSON(spawns))	
    ulx.fancyLogAdmin( calling_ply, true,"#A added a jukebox spawn")
end
local addspawn = ulx.command(ULX_CAT, "ulx addspawn",ulx.addspawn)
addspawn:defaultAccess( ULib.ACCESS_SUPERADMIN )
addspawn:help( "Add a persistant jukebox at your location and angles" )

function ulx.jbtool(calling_ply)
	calling_ply:Give("jukebox_tool")
end
local jbtool = ulx.command(ULX_CAT, "ulx jbtool",ulx.jbtool)
jbtool:defaultAccess( ULib.ACCESS_SUPERADMIN )
jbtool:help( "Gives you Jukebox tool" )

function ulx.wipespawns(calling_ply)
	file.Write("jukebox/"..game.GetMap()..".txt",util.TableToJSON({}))
    ulx.fancyLogAdmin( calling_ply, true,"#A wiped jukebox spawns")
end
local wipespawns = ulx.command(ULX_CAT, "ulx wipespawns",ulx.wipespawns)
wipespawns:defaultAccess( ULib.ACCESS_SUPERADMIN )
wipespawns:help( "Wipe maps jukebox spawns" )

function ulx.reload(calling_ply)
	for k,v in pairs(ents.GetAll()) do
		if v:GetClass() == "jukebox" and not v:GetNWEntity("JukeOwner"):IsPlayer() then
			v:Remove()
		end
	end
	SpawnJukeboxes()
    ulx.fancyLogAdmin( calling_ply, true,"#A respawned persistant jukeboxes")
end
local reload = ulx.command(ULX_CAT, "ulx reload",ulx.reload)
reload:defaultAccess( ULib.ACCESS_SUPERADMIN )
reload:help( "Respawns persistant jukeboxes" )

function ulx.jukeban(calling_ply, target_ply,should_unban)
	if should_unban then
		target_ply:SetPData("JukeBan","false")
		ulx.fancyLogAdmin( calling_ply, "#A unbanned #T from using jukeboxes",target_ply)	
	else
		target_ply:SetPData("JukeBan","true")
		ulx.fancyLogAdmin( calling_ply, "#A banned #T from using jukeboxes",target_ply)
	end
end
local jukeban = ulx.command(ULX_CAT, "ulx jukeban", ulx.jukeban, "!jukeban",true)
jukeban:addParam{ type=ULib.cmds.PlayerArg }
jukeban:defaultAccess( ULib.ACCESS_ADMIN )
jukeban:addParam{ type=ULib.cmds.BoolArg, invisible=true }
jukeban:help( "Bans a player from using jukeboxes." )
jukeban:setOpposite( "ulx jukeunban", {_,_, true}, "!jukeunban" )

function ulx.jukebanid(calling_ply, steamid,should_unban)
	if should_unban then
		util.SetPData(steamid,"JukeBan","false")
		ulx.fancyLogAdmin( calling_ply, "#A unbanned #s from using jukeboxes",steamid)	
	else
		util.SetPData(steamid,"JukeBan","true")
		ulx.fancyLogAdmin( calling_ply, "#A banned #s from using jukeboxes",steamid)
	end
end
local jukebanid = ulx.command(ULX_CAT, "ulx jukebanid", ulx.jukebanid, "!jukebanid",true)
jukebanid:addParam{ type=ULib.cmds.StringArg, hint="SteamID", ULib.cmds.takeRestOfLine }
jukebanid:defaultAccess( ULib.ACCESS_ADMIN )
jukebanid:addParam{ type=ULib.cmds.BoolArg, invisible=true }
jukebanid:help( "Bans a player from using jukeboxes." )
jukebanid:setOpposite( "ulx jukeunbanid", {_,_, true}, "!jukeunbanid" )

function ulx.blacklist(calling_ply,url)
	file.Append("jukebox/blacklist.txt",url.." \n")
    ulx.fancyLogAdmin( calling_ply, true,"#A blacklisted url: #s",url)
end
local blacklist = ulx.command(ULX_CAT, "ulx blacklist",ulx.blacklist)
blacklist:defaultAccess( ULib.ACCESS_SUPERADMIN )
blacklist:addParam{ type=ULib.cmds.StringArg, hint="url", ULib.cmds.takeRestOfLine }
blacklist:help( "Prevents url from being played on jukebox" )