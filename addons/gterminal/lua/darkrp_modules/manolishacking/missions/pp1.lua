AddCSLuaFile()
table.insert(manolis.Hacking.Missions.Missions, {
	uid='pp1',
	reward = math.floor(math.random()*100)+100,
	init = function(self)
		local email = {}
		email.from = 'manolis@manolis.io'
		email.subject = 'Phished PayPal Passwords'
		email.message = table.Random(manolis.Hacking.Missions.Greetings)..'\n'..'I managed to phish a PayPal password from some idiot that thought he was buying '..table.Random(manolis.Hacking.Missions.BuyingList)..'. \nI uploaded it to my FTP server in a file called passwords.txt at '..self.ip..'. \nYou can log in with username: manolis and password: catsarecool\n\nThere\'s not much cash on it so you can have it all. \n\n'..table.Random(manolis.Hacking.Missions.ByeList)

		hackingTerminal:SendMail(email)

		self:LoadProgram('ftp')

		self.ftp = {}
		self.ftp.username = 'manolis'
		self.ftp.password = 'catsarecool'
		self.ftp.files = {}

		local uname = table.Random(manolis.Hacking.Missions.Usernames)
		local pw = table.Random(manolis.Hacking.Missions.Passwords)

		manolis.Hacking.PayPal.addAccount(uname,pw, math.floor(self.reward_), function()
			self:CompleteMission()
		end)
		

	 	local pwfile = uname..':'..pw
	 	table.insert(self.ftp.files, {path='passwords.txt', contents=pwfile})

	end
})