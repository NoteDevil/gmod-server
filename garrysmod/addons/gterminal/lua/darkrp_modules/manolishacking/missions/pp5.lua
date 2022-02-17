table.insert(manolis.Hacking.Missions.Missions, {
	uid='pp5',
	reward = math.floor(math.random()*500)+300,
	sid = '0',
	init = function(self)
		local email = {}
		email.from = 'jspag39@blacksnakemafia.com'
		email.subject = 'Destroy competitors drug site'

		email.message = table.Random(manolis.Hacking.Missions.Greetings)..'\n'..'The name is John-Spaghetti. I\'m the Social Media Manager and Head Drug Dealer from Black Snake Mafia. \nRecently, the mafia has taken it’s drug business online, it’s booming, but this has encouraged our street drug rivals to do the same, they’re stealing our customers with the clever use of Heather’s Animations, and since I can’t break legs over the internet...\nI\'m looking for someone to take them down, so the customers have to throw their money at our business, thinking all the black market drug sites are being shut down.\nIf you manage to do this, there’ll be a large reward for you. The boss will pay you $'..string.Comma(self.reward_)..'.\n\nThe IP of their server is '..self.ip..'.\n\n'..table.Random(manolis.Hacking.Missions.ByeList)


		hackingTerminal:SendMail(email)
		local apache = self:LoadProgram('apache') // fuck nginx 
		apache.onDown = function()
			local email_= {}
			email_.from = 'jspag39@blacksnakemafia.com'
			email_.subject = 'The boss sends his regards'
			email_.message = table.Random(manolis.Hacking.Missions.Greetings)..'\n'..'We’re rolling in cash already, the boss is sending the money as we speak, thank you, speak of this to nobody, or I will find you.\n\n'..table.Random(manolis.Hacking.Missions.ByeList)
			hackingTerminal:SendMail(email_)

			self:CompleteMission()
		end

	end
})
