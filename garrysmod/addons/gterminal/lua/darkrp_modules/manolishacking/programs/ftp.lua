local ftp = {}
ftp.name = 'ftp'
ftp.help = 'File transfer protocol client'
ftp.username = 'ftp'
ftp.password = 'ftp'
ftp.files = {}
ftp.state = 0

ftp.enteredPass = ''
ftp.enteredUser = ''
ftp.ip = ''
ftp.connected = false
ftp.isCrackable = false


local lMission = nil
function ftp:init(args)
	self.ip = args[1]

	for k,v in pairs(manolis.Hacking.Current) do
		if(v.ip == self.ip) then
			if(!v:GetProgram('firewall')) then
				self.connected = true
				lMisison = v

					self.username = v.ftp.username or 'ftp'
					self.password = v.ftp.password or 'password'
					self.files = v.ftp.files or {}
					self.isCrackable = v.ftp.isCrackable or false
			end
		end
	end

	if((!self.connected)) then
		timer.Simple(1, function()
			hackingTerminal:programPrint('Failed to establish a connection to '..self.ip..':21')
			hackingTerminal:quitProgram()
		end)
		return
	end


	self.state = 1
	hackingTerminal:programPrint("Succesfully connected to FTP server on "..self.ip..':21\n\nPlease enter your username:', 'ftp')
end

function ftp:tick(command, args)
	if(command=='q') then hackingTerminal:quitProgram() end
	if(self.state==1) then
		self.enteredUser = command
		hackingTerminal:programPrint("Please enter your password:", 'ftp')
		self.state=2
	elseif (self.state==2) then
		self.enteredPass = command
		if((self.enteredPass != self.password) or (self.enteredUser != self.username)) then
			hackingTerminal:programPrint('Invalid Credentials! Goodbye.','ftp')
			hackingTerminal:quitProgram()
		else
			hackingTerminal:programPrint('Welcome, '..self.username,'ftp')
			hackingTerminal:programPrint('Enter filename to download, ls to view files, run <program> to execute a program or upload <file> to upload a file','ftp')
			self.state=3
		end
	elseif(self.state==3) then
		if(command=='ls') then
			for k,v in pairs(self.files) do
				hackingTerminal:programPrint(k..' - '..v.path,'ftp')
			end
			return
		end

		if(command=='run') then
			if(!args[1]) then 
				hackingTerminal:programPrint('Usage: run <program>','ftp')
				return
			end
			for k,v in pairs(self.files) do
				if(v.path==args[1]) then
					if(v.onRun) then
						v.onRun()
						hackingTerminal:programPrint('Succesfully executed '..args[1])
						return
					else
						hackingTerminal:programPrint('Cannot run '..args[1],'ftp')
					end
					return
				end
			end
		end

		if(command=='upload') then
			if(!args[1]) then 
				hackingTerminal:programPrint('Usage: upload <file>','ftp')
				return
			end	

			for k,v in pairs(hackingTerminal.Files) do
				if(args[1]==v.path) then
					local path = string.match(v.path, "^.+/(.+)$") or v.path
					table.insert(self.files, {path=path, contents=v.contents, onRun=(v.onRun or nil)})
					hackingTerminal:programPrint('File succesfully uploaded')
					return
				end

				hackingTerminal:programPrint('Could not find file \''..args[1]..'\'')
			end
		end


		for k,v in pairs(self.files) do

			if(v.path==command) then
				hackingTerminal:programPrint('Downloading '..v.path..'...','ftp')
				timer.Simple(2, function()
					hackingTerminal:programPrint('Done. \nEnter filename to download or q to quit:', 'ftp')
					hackingTerminal:addFile(v)
					
				end)
				return
			end
		end

		hackingTerminal:programPrint('File not found. Try again or q to quit:', 'ftp')
	end
end


manolis.Hacking.Programs['ftp'] = ftp
mCommand.add('ftp', 'Opens FTP client', function(args,sargs)
	if(!args[1]) then
		hackingTerminal:print('Usage: ftp <ip>')
		return
	end

	hackingTerminal:startProgram(manolis.Hacking.Programs['ftp'], args)
end)
