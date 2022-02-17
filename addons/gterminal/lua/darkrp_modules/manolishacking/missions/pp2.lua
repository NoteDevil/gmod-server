AddCSLuaFile()

table.insert(manolis.Hacking.Missions.Missions, {
	uid='pp2',
	reward = math.floor(math.random()*500)+100,
	sid = '0',
	init = function(self)
		local email = {}
		email.from = 'manolis@manolis.io'
		email.subject = 'Easy ScriptFodder Hack'
		local pw = table.Random(manolis.Hacking.Missions.Passwords)
		local pwb = table.Random(manolis.Hacking.Missions.Passwords)
		email.message = table.Random(manolis.Hacking.Missions.Greetings)..'\n'..'I manged to acquire the root username and password for ScriptFodder\'s FTP server, a popular script sharing website. I checked earlier and found that they actually back-up their banking username and password in a file called banking_backup.txt\nThe only problem is that you\'ll need to DDOS their firewall before you can gain access. Remember that the port for firewalls is 1234.\n\nAnyway, here are the FTP details:\n\nHost:'..self.ip..'\nUsername:scriptfodder\nPassword:'..pw..'\n\n'..table.Random(manolis.Hacking.Missions.ByeList)

		hackingTerminal:SendMail(email)

		self:LoadProgram('ftp')

		self:LoadProgram('firewall')

		self.ftp = {}
		self.ftp.username = 'scriptfodder'
		self.ftp.password = pw
		self.ftp.files = {}

		manolis.Hacking.mBank.addAccount('IB817758736', pw,self.reward_, function()
			self:CompleteMission()
		end)


	 	table.insert(self.ftp.files, {path='banking_backup.txt', contents='Yo jamie,\n\nI changed our internet banking password to \''..pw..'\'\n\nRemember our username is IB817758736\n\nDon\'t loose it again you silly baffoon!\n\n'..table.Random(manolis.Hacking.Missions.ByeList)})
	 	table.insert(self.ftp.files, {path='public/index.php', contents='<?php\necho("<h1>scriptfodder is currently down for maintenance</h1>\n\n<br><br>\n\n<footer>copyright matt and jamie <3</footer>");'})

	 	table.insert(self.ftp.files, {path='public/scripts/vxdonation.zip', contents='VñÑÞ-wÔæZ®RÜ_¾6öü%[äðºÙcø`G6Ë9ìM$ŸyÿôðÄÓVñÑÞ-wÔæZ®RÜ_¾6öü%[äðºÙcø`G6Ë9ìM$ŸyÿôðÄÓ¤ÚjmE±{{user_id}}dÇÁõ`¬ÅµÌ˜ä²KR–Ðô¿gf—ï¤^2ûùÍÄRw«ºîª>ý·ÃålYœQÃ¤nE;šL¨çÕ'})
	end,
})