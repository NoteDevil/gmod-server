local function JukeboxCommand(ply,cmd,args)
	if not ply:IsSuperAdmin() then
		jukebox.ErrorMsg("You are not superadmin")
		return
	end
	net.Start("JukeboxSpawn")
		net.WriteUInt(1,8)
	net.SendToServer()
end


local function autocomplete(cmd,stringargs)
	stringargs = string.Trim( stringargs )
	stringargs = string.lower( stringargs )
	return {"jukebox_spawn"}
end
concommand.Add("jukebox_spawn",JukeboxCommand,autocomplete,"Add a jukebox spawn at your position and angle")


local function JukeboxCommand2(ply,cmd,args)
	if not ply:IsSuperAdmin() then
		jukebox.ErrorMsg("You are not superadmin")
		return
	end
	net.Start("JukeboxSpawn")
		net.WriteUInt(2,8)
	net.SendToServer()
end


local function autocomplete2(cmd,stringargs)
	stringargs = string.Trim( stringargs )
	stringargs = string.lower( stringargs )
	return {"jukebox_wipe"}
end
concommand.Add("jukebox_wipe",JukeboxCommand2,autocomplete2,"Wipe all jukebox spawns on current map")

local function JukeboxCommand3(ply,cmd,args)
	if not ply:IsSuperAdmin() then
		jukebox.ErrorMsg("You are not superadmin")
		return
	end
	net.Start("JukeboxSpawn")
		net.WriteUInt(3,8)
	net.SendToServer()
end


local function autocomplete3(cmd,stringargs)
	stringargs = string.Trim( stringargs )
	stringargs = string.lower( stringargs )
	return {"jukebox_respawn"}
end
concommand.Add("jukebox_respawn",JukeboxCommand3,autocomplete3,"Respawns all jukeboxes on map")

local function JukeboxCommand4(ply,cmd,args)
	if not ply:IsSuperAdmin() then
		jukebox.ErrorMsg("You are not superadmin")
		return
	end
	local steamid = string.Implode("",args)
	net.Start("JukeBan")
		net.WriteUInt(2,8)
		net.WriteString(steamid)
	net.SendToServer()
end


local function autocomplete4(cmd,stringargs)
	stringargs = string.Trim( stringargs )
	stringargs = string.lower( stringargs )
	return {"jukebox_ban"}
end
concommand.Add("jukebox_ban",JukeboxCommand4,autocomplete4,"Ban steamid from using jukebox")

local function JukeboxCommand5(ply,cmd,args)
	if not ply:IsSuperAdmin() then
		jukebox.ErrorMsg("You are not superadmin")
		return
	end
	local url = string.Implode("",args)
	net.Start("JukeBan")
		net.WriteUInt(1,8)
		net.WriteString(url)
	net.SendToServer()
end


local function autocomplete5(cmd,stringargs)
	stringargs = string.Trim( stringargs )
	stringargs = string.lower( stringargs )
	return {"jukebox_blacklist"}
end
concommand.Add("jukebox_blacklist",JukeboxCommand5,autocomplete5,"Blacklist a url")

local function JukeboxCommand6(ply,cmd,args)
	if not ply:IsSuperAdmin() then
		jukebox.ErrorMsg("You are not superadmin")
		return
	end
	local steamid = string.Implode("",args)
	net.Start("JukeBan")
		net.WriteUInt(3,8)
		net.WriteString(steamid)
	net.SendToServer()
end


local function autocomplete6(cmd,stringargs)
	stringargs = string.Trim( stringargs )
	stringargs = string.lower( stringargs )
	return {"jukebox_unban"}
end
concommand.Add("jukebox_unban",JukeboxCommand6,autocomplete6,"unban steamid from using jukebox")