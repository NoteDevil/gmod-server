AddCSLuaFile()
table.insert(manolis.Hacking.Missions.Missions, {
	uid='pp3',
	reward = math.floor(math.random()*1000)+500,
	sid = '0',
	init = function(self)
		local email = {}
		email.from = 'manolis@manolis.io'
		email.subject = 'Leaked NASA E-Mails'

		email.message = table.Random(manolis.Hacking.Missions.Greetings)..'\n'..'I was looking through a couple of leaked NASA E-Mails earlier and found a couple that contained usernames and passwords to NASA\'s official FTP server (at '..self.ip..').\nYou might be able to find something interesting on there..\n\nI\'ve forwarded you the E-Mails.\n\n'..table.Random(manolis.Hacking.Missions.ByeList)
		local pww = table.Random(manolis.Hacking.Missions.Passwords)
		email.opened = function(self)	
			local nasa = {
				{name="Sophie Symms", username="socat", password="ducksarecool", subject="Cats?", message="Hey baby, I\'m coming over later to deliver those kittens. \nI manged to find a couple of cats too. Do you want them?\n\nP.S - I lost my password to our FTP could you reset it please? My username is 'socat' \n\nThanks! You\'re the best sysadmin ever!"}, 
				{name="Manolis Vrondakis", username="vrondakis", password="alleightinches", subject="RE: Cats?", message="Yeah I\'ll take those cats. How many are there?\n\nI reset your password on the FTP to "..pww..'. \n\nEnjoy!'}, 
			}

			for k,v in pairs(nasa) do
				hackingTerminal:SendMail({from='manolis@manolis.io', subject='FW: '..v.subject, message=v.message})
			end
		end

		hackingTerminal:SendMail(email)

		self:LoadProgram('ftp')


		self.ftp = {}
		self.ftp.username = 'socat'
		self.ftp.password = pww
		self.ftp.files = {}

		manolis.Hacking.PayPal.addAccount('nasa', pww, self.reward_, function()
			self:CompleteMission()
		end)

		local pwc = table.Random(manolis.Hacking.Missions.Passwords)
		table.insert(self.ftp.files, {path='paypal.txt', contents='NASA PayPal details:\n\nUsername: nasa@nasa.com\nPassword:'..pwc..'\n\nPlease do not share these, thanks'})

	 	table.insert(self.ftp.files, {path='spaceships/iis.txt', contents='START CO:{\n	LIFE-SUPPORT:ON,\n	DOCKING-SEQUENCE:table xf19h19\n};'})
	 	table.insert(self.ftp.files, {path='targets/russia.txt', contents='Co-ords of secret base in Russia: (63.9568° N, 93.1931°)'})
	end
})