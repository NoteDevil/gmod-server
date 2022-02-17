table.insert(manolis.Hacking.Missions.Missions, {
	uid='pp7',
	reward = math.floor(math.random()*500)+300,
	sid = '0',
	init = function(self)
		local email = {}
		email.from = 'DJskully@hotmail.com'
		email.subject = 'Help!'

		email.message = table.Random(manolis.Hacking.Missions.Greetings)..'\n'..'Hello there,\n\n I\'m in need of some urgent help, some guy on the other side of the world is stealing my music and my name (DJ Scully, he can\'t even spell) and claiming it as his own on his site, due to his already existing internet fame for being a pretty boy, he\'s already got a lot of people believing that he\'s making that music. \nWell it\'s mine, and I have worked from the bottom to get to where I am today and I won\'t let him take the credit for it. \nI will pay you $'..string.Comma(self.reward_)..' to take down his website at '..self.ip..'!\nWill that be enough? \nThank you so much man. \n\n'..table.Random(manolis.Hacking.Missions.ByeList)

		local firewall = self:LoadProgram('firewall')

		hackingTerminal:SendMail(email)
		local apache = self:LoadProgram('apache') // fuck nginx 
		apache.onDown = function()
			local email_= {}
			email_.from = 'DJskully@hotmail.com'
			email_.subject = 'Amazing work!'
			email_.message = table.Random(manolis.Hacking.Missions.Greetings)..'\n'..[[I can't thank you enough, he has been revealed as a fraud and my fanbase is growing by the second! \nTake the money, you\'ve more than earned it my friend. \nThe one and only, Skully \n\n]]..table.Random(manolis.Hacking.Missions.ByeList)
			hackingTerminal:SendMail(email_)

			self:CompleteMission()
		end
	end
})