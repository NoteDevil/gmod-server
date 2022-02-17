util.AddNetworkString("manolisHackOpen")
util.AddNetworkString("startedUsingHackingTerminal")
util.AddNetworkString("StartHackingMission")
util.AddNetworkString("hackingMissionCompleted")
util.AddNetworkString("manolisHackingUse")
util.AddNetworkString("manolisHackingQuit")
util.AddNetworkString("manolisHackingUse")
util.AddNetworkString("ManolisKickFromTerminal")
if(!manolis) then manolis = {} end
if(!manolis.Hacking) then manolis.Hacking = {} end
if(!manolis.Hacking.PUEnts) then manolis.Hacking.PUEnts = {} end

if(!manolis.Hacking.Server) then manolis.Hacking.Server = {} end
if(!manolis.Hacking.Server.SIDs) then manolis.Hacking.Server.SIDs = {} end
manolis.Hacking.UPR = true


net.Receive('startedUsingHackingTerminal', function(len,ply)
	local ent = net.ReadEntity()

	if(ent:Getowning_ent() != ply) or (!manolis.Hacking.UPR) then
		DarkRP.notify(ply,0,4,"This terminal isn\'t yours!")
		return
	end
	if(ply:GetPos():Distance(ent:GetPos())>250) then
		DarkRP.notify(ply,0,4,"You are too far away from this termianl")
		ply:DrawViewModel(true)
	else
		ply:Freeze(true)
		net.Start('manolisHackOpen')
			net.WriteEntity(ent)
		net.Send(ply)

		table.insert(manolis.Hacking.PUEnts, {ent=ent, player=ply})

		if(!ply.hasBeenGivenFMission) then
			manolis.Hacking:startRandomMission(ply)
			ply.hasBeenGivenFMission = true		
		end

		timer.Create('hackingMailTimer'..ply:EntIndex(),manolis.Hacking.Config.waitTime, 0, function()
			if(manolis.Hacking.UPR) then
				manolis.Hacking:startRandomMission(ply)
			end
		end)
	end
end)


net.Receive("manolisHackingQuit", function(len,ply)
	for k,v in pairs(manolis.Hacking.PUEnts) do
		if(v.player==ply) then
			table.remove(manolis.Hacking.PUEnts, k)
		end

		ply:Freeze(false)
	end

	timer.Remove('hackingMailTimer'..ply:EntIndex())
	ply:DrawViewModel(true)
end)

net.Receive('hackingMissionCompleted', function(len,ply)
	local sid = net.ReadString()
	for k,v in pairs(manolis.Hacking.Server.SIDs) do
		if(sid==v.sid) then
			local isValida = false

			for k,v in pairs(manolis.Hacking.PUEnts) do
				if(v.player==ply) then
					if((v.ent:GetPos():Distance(ply:GetPos())>250)) then
						DarkRP.notify(ply,0,4,"You are too far away from this hacking terminal.")
					else
						isValida = true
					end
				end
			end

			if(!manolis.Hacking.C) then
				DarkRP.notify(ply,0,4,"An internal hacking error occured")
				return
			end

			if(!isValida) then return false end
			
			DarkRP.notify(ply,0,4,"You got $"..string.Comma(v.balance).." from hacking.")	

			ply:addMoney(v.balance)
			table.remove(manolis.Hacking.Server.SIDs, k)
		end
	end
end)

if(SERVER) then
	hook.Add('PlayerDeath', 'manolis:MVHacking:Die', function(ply)
		net.Start('ManolisKickFromTerminal')
		net.Send(ply)
	end)

	hook.Add('playerArrested', 'manolis:MVHacking:arrest', function(ply)
		net.Start('ManolisKickFromTerminal')
		net.Send(ply)	
	end)
end

hook.Add('PlayerInitialSpawn', 'manolishackterminal', function(ply)
	ply.hasBeenGivenFMission = false
end)


