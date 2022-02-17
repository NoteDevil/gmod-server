AddCSLuaFile()

function string.random(length)
	math.randomseed(os.time())
	local str = "";
	for i = 1, length do
		str = str..string.char(math.random(32, 126));
	end
	return str;
end


table.insert(manolis.Hacking.Missions.Missions, {
	uid='pp6',
	reward = math.floor(math.random()*5000)+1000,
	sid = '0',
	init = function(self)
		local email = {}
		email.from = 'john@temp-emails.com'
		email.subject = 'Virus'

		email.message = table.Random(manolis.Hacking.Missions.Greetings)..'\n'..'I need you to download the virus from here ( 131.273.69.1/virus.exe ) and upload it to the FTP server here: '..self.ip..', and then you run the virus with the run FTP command\n\nYou\'ll need to hack into the FTP server to get the login details. I\'ll give you $'..string.Comma(self.reward_)..' when the virus runs.\n\n'..table.Random(manolis.Hacking.Missions.ByeList)


		local pww = table.Random(manolis.Hacking.Missions.Passwords)
		local uuu = table.Random(manolis.Hacking.Missions.Usernames)


		hackingTerminal:addHTTPFile({name='131.273.69.1/virus.exe',contents=string.random(500), onRun=function()
			self:CompleteMission()
		end})

		hackingTerminal:SendMail(email)


		self:LoadProgram('ftp')


		self.ftp = {}
		self.ftp.username = uuu
		self.ftp.password = pww
		self.ftp.isCrackable = true
		self.ftp.files = {}

		table.insert(self.ftp.files, {path='isis.txt', contents='How to JOIN ISIS:\n\nSELECT * FROM members LEFT JOIN SELECT * FROM isis'})

	end
})