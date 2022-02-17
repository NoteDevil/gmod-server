if(!manolis) then manolis = {} end
if(!manolis.Hacking) then manolis.Hacking = {} end


manolis.Hacking.Missions = {}
manolis.Hacking.Missions.Missions = {}


// Put these in an auto-loader, Manolis!

include('darkrp_modules/manolishacking/missions/pp1.lua')
include('darkrp_modules/manolishacking/missions/pp2.lua')
include('darkrp_modules/manolishacking/missions/pp3.lua')
include('darkrp_modules/manolishacking/missions/pp4.lua')
include('darkrp_modules/manolishacking/missions/pp5.lua')
include('darkrp_modules/manolishacking/missions/pp6.lua')
include('darkrp_modules/manolishacking/missions/pp7.lua')
include('darkrp_modules/manolishacking/missions/pp8.lua')
include('darkrp_modules/manolishacking/missions/pp9.lua')
include('darkrp_modules/manolishacking/missions/pp10.lua')

AddCSLuaFile('darkrp_modules/manolishacking/missions/pp1.lua')
AddCSLuaFile('darkrp_modules/manolishacking/missions/pp2.lua')
AddCSLuaFile('darkrp_modules/manolishacking/missions/pp3.lua')
AddCSLuaFile('darkrp_modules/manolishacking/missions/pp4.lua')
AddCSLuaFile('darkrp_modules/manolishacking/missions/pp5.lua')
AddCSLuaFile('darkrp_modules/manolishacking/missions/pp6.lua')
AddCSLuaFile('darkrp_modules/manolishacking/missions/pp7.lua')
AddCSLuaFile('darkrp_modules/manolishacking/missions/pp8.lua')
AddCSLuaFile('darkrp_modules/manolishacking/missions/pp9.lua')
AddCSLuaFile('darkrp_modules/manolishacking/missions/pp10.lua')


AddCSLuaFile('darkrp_modules/manolishacking/programs/mail.lua')
AddCSLuaFile('darkrp_modules/manolishacking/programs/ftp.lua')
AddCSLuaFile('darkrp_modules/manolishacking/programs/mbank.lua')
AddCSLuaFile('darkrp_modules/manolishacking/programs/paypal.lua')
AddCSLuaFile('darkrp_modules/manolishacking/programs/firewall.lua')
AddCSLuaFile('darkrp_modules/manolishacking/programs/ddos.lua')
AddCSLuaFile('darkrp_modules/manolishacking/programs/apache.lua')
AddCSLuaFile('darkrp_modules/manolishacking/programs/loic.lua')
AddCSLuaFile('darkrp_modules/manolishacking/programs/ftp_crack.lua')

AddCSLuaFile('darkrp_modules/manolishacking/banks/mbank.lua')
AddCSLuaFile('darkrp_modules/manolishacking/banks/paypal.lua')

AddCSLuaFile('darkrp_modules/manolishacking/banks.lua')
AddCSLuaFile('darkrp_modules/manolishacking/hackingframe.lua')
AddCSLuaFile('darkrp_modules/manolishacking/hackingterminal.lua')
AddCSLuaFile('darkrp_modules/manolishacking/hackingtext.lua')
AddCSLuaFile('darkrp_modules/manolishacking/hackingtextbox.lua')
AddCSLuaFile('darkrp_modules/manolishacking/host.lua')
AddCSLuaFile('darkrp_modules/manolishacking/mcommand.lua')
AddCSLuaFile('darkrp_modules/manolishacking/missions.lua')
AddCSLuaFile('darkrp_modules/manolishacking/mstring.lua')
AddCSLuaFile('darkrp_modules/manolishacking/programs.lua')



function string.random(length)
	math.randomseed(os.time())
	local str = "";
	for i = 1, length do
		str = str..string.char(math.random(32, 126));
	end
	return str;
end


manolis.Hacking.ServerMissions = {}
function manolis.Hacking:startRandomMission(ply)
	if (!manolis.Hacking.UPR) then return end
  	local mission = table.Random(manolis.Hacking.Missions.Missions)
	manolis.Hacking:startMission(ply,mission)
end



function manolis.Hacking:startMission(ply, mission)
	local si = string.random(25)
	local reward = mission.reward
	table.insert(manolis.Hacking.Server.SIDs, {sid=si, balance=reward})

	net.Start("StartHackingMission")
		net.WriteTable({uid=mission.uid, sid=si, reward=reward})
	net.Send(ply)
end 