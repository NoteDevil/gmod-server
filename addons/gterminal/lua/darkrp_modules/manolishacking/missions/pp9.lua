function string.random(length)
	math.randomseed(os.time())
	local str = "";
	for i = 1, length do
		str = str..string.char(math.Round(math.Round(32, 126)));
	end
	return str;
end


table.insert(manolis.Hacking.Missions.Missions, {
	uid='pp9',
	reward = math.floor(math.random()*50)+100,
	sid = '0',
	init = function(self)
		local email = {}
		email.from = 'camcole1@cantcode.net'
		email.subject = 'hi mate'

		email.message = table.Random(manolis.Hacking.Missions.Greetings)..'\n'..'my name is camcole1 and i am trying to crack into this server at '..self.ip..'. they told me they store their banking details on there and i want them. so can u pls hack into it and give me the details?\npls email the details right back to me\n\n ty\n\n'


		hackingTerminal:SendMail(email)
		self:LoadProgram('ftp')

		self:LoadProgram('firewall')



		local pww = table.Random(manolis.Hacking.Missions.Passwords)
		local pw = table.Random(manolis.Hacking.Missions.Passwords)
		local uuu = table.Random(manolis.Hacking.Missions.Usernames)

		self.ftp = {}
		self.ftp.username = uuu
		self.ftp.password = pww
		self.ftp.files = {}
		self.ftp.isCrackable = true

		manolis.Hacking.mBank.addAccount('IB952185119', pw, self.reward_, function()
			self:CompleteMission()
		end)


		table.insert(self.ftp.files, {path='backup.txt', contents='internet banking mbank:\nIB952185119:'..pw})

	end
})