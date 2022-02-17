function string.random(length)
	math.randomseed(os.time())
	local str = "";
	for i = 1, length do
		str = str..string.char(math.Round(math.random(32, 126)));
	end
	return str;
end


table.insert(manolis.Hacking.Missions.Missions, {
	uid='pp8',
	reward = math.floor(math.random()*3000)+1000,
	sid = '0',
	init = function(self)
		local email = {}
		email.from = 'manolis@manolis.io'
		email.subject = 'rat.exe'

		email.message = table.Random(manolis.Hacking.Missions.Greetings)..'\n'..'I just need you to do a little job for me. Download 46.101.48.147/notARAT.exe and run it on the FTP server here: '..self.ip..'\nI\'ll give you $'..string.Comma(self.reward_)..' when the file runs.\n\n'..table.Random(manolis.Hacking.Missions.ByeList)


		local pww = table.Random(manolis.Hacking.Missions.Passwords)
		local uuu = table.Random(manolis.Hacking.Missions.Usernames)


		hackingTerminal:addHTTPFile({name='46.101.48.147/notARAT.exe',contents=string.random(500), onRun=function()
			self:CompleteMission()
		end})

		hackingTerminal:SendMail(email)


		self:LoadProgram('ftp')
		self:LoadProgram('firewall')


		self.ftp = {}
		self.ftp.username = uuu
		self.ftp.password = pww
		self.ftp.isCrackable = true
		self.ftp.files = {}

		table.insert(self.ftp.files, {path='meow.txt', contents='Cats are so cute. Just a note.'})

	end
})