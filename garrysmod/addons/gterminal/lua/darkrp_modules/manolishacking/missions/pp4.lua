AddCSLuaFile()
table.insert(manolis.Hacking.Missions.Missions, {
	uid='pp4',
	reward = math.floor(math.random()*1000)+300,
	sid = '0',
	init = function(self)
		local email = {}
		email.from = 'jamie@scriptfodder.com'
		email.subject = 'Take down website'

		email.message = table.Random(manolis.Hacking.Missions.Greetings)..'\n'..'My name is Jamie. I\'m co-founder of the popular script sharing website: ScriptFodder.\nI\'m looking for a hacker (like yourself) to takedown our prime competitor: Coderflow.\n\nIf you take it down, I\'ll pay you $'..string.Comma(self.reward_)..'.\n\nThe IP of their server is '..self.ip..'. I\'m pretty sure they have a firewall active, so you\'ll need to take that down first.\n\n'..table.Random(manolis.Hacking.Missions.ByeList)


		hackingTerminal:SendMail(email)
		local apache = self:LoadProgram('apache') // fuck nginx 
		local firewall = self:LoadProgram('firewall')
		apache.onDown = function()
			local email_= {}
			email_.from = 'jamie@scriptfodder.com'
			email_.subject = 'Cheers mate!'
			email_.message = table.Random(manolis.Hacking.Missions.Greetings)..'\n'..'Thanks a lot for taking down that site, bro!\n\n I\'ve sent the money!\n\n'..table.Random(manolis.Hacking.Missions.ByeList)
			hackingTerminal:SendMail(email_)

			self:CompleteMission()
		end

	end
})