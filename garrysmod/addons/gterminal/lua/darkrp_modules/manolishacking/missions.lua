AddCSLuaFile()
print('gTerminal: Included Missions')
if(!manolis) then manolis = {} end
if(!manolis.Hacking) then manolis.Hacking = {} end

manolis.Hacking.Missions = {}

manolis.Hacking.Missions.Greetings = {'Hey Bud!', 'Hey Bro,', 'Hey', 'Hi there', 'Uhm hello', 'Okay, so', 'Hey man!', 'Yo', 'Wassup', 'Heeeey', 'Hello!?', 'Hey buddy', 'Sup..', 'Hi dude'}
manolis.Hacking.Missions.BuyingList = {'KFC Club Cards', 'the source to Coderflow', 'VXDonation'}
manolis.Hacking.Missions.ByeList = {'Peace!', 'Good Luck!', 'Thanks!', 'Thank you so much', 'Thanks, bye!', 'Okay, see you', 'See you later', 'Laters', 'Later man', 'Don\'t mess up, good luck', 'Chow', 'Catch you later', 'Thanks Bro', 'Thanks man', 'See you in hell!', 'Take care', 'Thanks, stay cool', 'Cheers', 'Thanks dude', 'Bye man'}

manolis.Hacking.Missions.Passwords = {'abcd', 'apple', 'orange', 'cats', 'catsrcwl', 'skids', 'iamaskid', 'convict','badboy', 'shady', 'peach', 'kitten'}

manolis.Hacking.Missions.Usernames = {'matt','jamie','neth', 'jimmy21', 'kendallQT', 'xXroryXx', 'Hu_bot36', 'frank420', 'princekay', 'alex18', 'kylegreen', 'AlyRosse94', 'yellowjello', 'tommy46', 'bevlee3', 'harry_34', 'mariorossi', 'dcnathan', 'sanjay65', 'vondee754'}

manolis.Hacking.Missions.Missions = {}

manolis.Hacking.Missions.baseServer = {
	ip = hackingTerminal:randomIP(),
	programs = {},
	init = function()

	end,

	GetProgram = function(self, programName)
		return self.programs[programName] or nil
	end,

	RemoveProgram = function(self, programName)
		if(self.programs[programName]) then
			self.programs[programName] = nil
		end
	
	end,

	LoadProgram = function(self, programName)
		local program = table.Copy(manolis.Hacking.Programs[programName])
		if(!program) then error('Invalid program added: '..programName) end
		program.host = self


		self.programs[programName] = program // God bless Lua associative arrays

		return program
	end,

	CompleteMission = function(self)
		net.Start('hackingMissionCompleted')

			net.WriteString(self.sid)
		net.SendToServer()

		hackingTerminal:programPrint(string.Comma(self.reward_)..'$ has been credited to your account.', 'SYSTEM')
	end
}

net.Receive('StartHackingMission', function()
	local mission = net.ReadTable()
	local rm = nil
	for k,v in pairs(manolis.Hacking.Missions.Missions) do
		if(mission.uid == v.uid) then
			rm = v
		end
	
	end
	if(!rm) then 
		print('Mission not found')
	else
		rm.sid = mission.sid
		rm.reward = mission.reward
		rm.reward_ = mission.reward
		hackingTerminal:addMission(rm)
	end
end)

include('missions/pp1.lua')
include('missions/pp2.lua')
include('missions/pp3.lua')
include('missions/pp4.lua')
include('missions/pp5.lua')

include('missions/pp6.lua')

include('missions/pp7.lua')

include('missions/pp8.lua')

include('missions/pp9.lua')

include('missions/pp10.lua')

