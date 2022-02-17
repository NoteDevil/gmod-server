if not file.Exists("jukebox","DATA") then
	file.CreateDir("jukebox")
end

if not file.Exists("jukebox/"..game.GetMap()..".txt","DATA") then
	file.Write("jukebox/"..game.GetMap()..".txt","[]")
end

local function SpawnJukeboxes()
	if file.Exists("jukebox/"..game.GetMap()..".txt","DATA") then
		local spawns = util.JSONToTable(file.Read("jukebox/"..game.GetMap()..".txt","DATA"))
		for k,v in pairs(spawns) do
			local offset = Vector(0,0,41)
			offset:Add(v.Ang:Right()*18)
			local jb = ents.Create("jukebox")
			jb:SetPos(v.Pos+offset)
			jb:SetAngles(v.Ang)
			jb:Spawn()
			jb:Activate()
			
			jb:GetPhysicsObject():SetMass(2000)
			jb:SetMoveType(MOVETYPE_NONE)
		end
	end
end
hook.Add("InitPostEntity","SpawnJukebox",SpawnJukeboxes)

hook.Add("PostCleanupMap", "SpawnJukeboxes", SpawnJukeboxes)

util.AddNetworkString("JukeboxSpawn")

net.Receive("JukeboxSpawn",function(len,ply)
	local ctype = net.ReadUInt(8)
	
	if ulx then
		if not (ply:query("ulx jukeboxtool") or ply:query("ulx addspawn")) then msg.ErrorMsg(ply,"You don't have access to this stuff!") return end
	else
		if not (ply:IsSuperAdmin()) then msg.ErrorMsg(ply,"You don't have access to this stuff!") return end
	end
	
	if ctype == 1 then
		local pos,ang = ply:GetPos(), Angle(0,ply:EyeAngles().y,0)
		local spawns = util.JSONToTable(file.Read("jukebox/"..game.GetMap()..".txt","DATA"))
		table.insert(spawns,{Pos=pos,Ang=ang})
		file.Write("jukebox/"..game.GetMap()..".txt",util.TableToJSON(spawns))	
		jukebox.Notify(ply,"Jukebox spawn succesfully added!")
	elseif ctype == 2 then
		file.Write("jukebox/"..game.GetMap()..".txt",util.TableToJSON({}))	
		jukebox.Notify(ply,"Jukebox spawns succesfully wiped!")
	elseif ctype == 3 then
		for k,v in pairs(ents.GetAll()) do
			if v:GetClass() == "jukebox" and not v:GetNWEntity("JukeOwner"):IsPlayer() then
				v:Remove()
			end
		end
		SpawnJukeboxes()
		jukebox.Notify(ply,"Jukeboxe(s) have been respawned!")
	end
end)

