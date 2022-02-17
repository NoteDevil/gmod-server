local loic = {}
loic.name = 'loic'
loic.help = 'Low Orbit Ion Cannon'
loic.state = 0

loic.ip = ''
loic.process = ''


loic.connected = false
loic.secret = ''
loic.lMission = {}
loic.puzzle = 0
loic.puzzles = {}
loic.puzzles.temp = {}
loic.puzzles.temp.user = {}

function loic:init(args)

	self.ip = args[1]
	self.process = args[2]

	for k,v in pairs(manolis.Hacking.Current) do
		if(v.ip == self.ip) then
			math.randomseed(os.time())
			if(self.process=='80') then
				if(v:GetProgram('firewall')) then
					timer.Simple(1, function()
						hackingTerminal:programPrint('Failed to flood network. Is a firewall active?', 'loic')
						hackingTerminal:quitProgram()
					end)
					return false
				end
				if(v:GetProgram('apache')) then
					self.connected = true
					loic.lMission = v
				end
			end
		end
	end

	if(!self.connected) then
		timer.Simple(1, function()
			hackingTerminal:programPrint('Failed to establish a connection to '..self.ip..':'..self.process, 'loic')
			hackingTerminal:quitProgram()	
		end)
		return
	end


	self.state = 1
	hackingTerminal:programPrint("Begin HTTP flood at "..self.ip..':'..self.process..'? (y/n)','loic')

	self.secret = {math.floor(math.random()*999) , math.floor(math.random()*999) , math.floor(math.random()*999) , math.floor(math.random()*999)}

end


function loic:tick(command)
	if(command=='q') then hackingTerminal:quitProgram() end
	if(self.state==1) then
		if(command!='y') then
			hackingTerminal:programPrint('Quitting..','loic')
			hackingTerminal:quitProgram();
			return 
		end


	
		hackingTerminal:programPrint("Host using 24-bit encyryption table. Please enter 5 decoded values:")
		local lines = {}
		for l=1, 5 do
			lines[l] = {}
			lines[l].result = 0
			lines[l].line = {}
 			for k=1, 5 do
 				local val = math.Round(math.random()*9)
 				lines[l].line[k] = val
 					lines[l].result = lines[l].result+val
			end
		end

		for k,v in pairs(lines) do
			local str = ''
			for k2,v2 in pairs(v.line) do
				str = str..' | '..v2
			end
			hackingTerminal:programPrint(str,'loic')
		end

		self.puzzles.temp.lines = lines
		self.puzzles.temp.user = {}
		self.state = 2


	elseif(self.state==2) then
		table.insert(self.puzzles.temp.user, tonumber(command))
		if(#self.puzzles.temp.user>4) then
			for k,v in pairs(self.puzzles.temp.user) do
				if(v!=self.puzzles.temp.lines[k].result) then
					hackingTerminal:programPrint('Decoding failed. Quitting.', 'loic')
					hackingTerminal:quitProgram()
					return
				end
			end

			self.state=3
			self:tick()
			return
		end

	elseif(self.state==3) then
		local str = ''
		for a=1, math.floor(math.random()*50) do
			str = str..a..' - Sent '..self.ip..':80 1024 byte packet\n'
		end
		str=str..'No response from '..self.ip..':80. Server is offline. Flooding completed'
		hackingTerminal:programPrint(str, 'loic')
		timer.Simple(3,function()
			self.lMission:GetProgram('apache'):attack()
			hackingTerminal:quitProgram();
			return
		end)

		self.state=10

	end

end


manolis.Hacking.Programs['loic'] = loic
mCommand.add('loic', 'Opens Low Orbit Ion Cannon', function(args,sargs)
	if((!args[1]) or (!args[2])) then
		hackingTerminal:programPrint('Usage: loic <ip> <port>', 'loic')
		return
	end

	hackingTerminal:startProgram(manolis.Hacking.Programs['loic'], args)
end)
