local ddos = {}
ddos.name = 'ddos'
ddos.help = 'DDOS a target host process'
ddos.state = 0

ddos.ip = ''
ddos.process = ''


ddos.connected = false
ddos.secret = ''
ddos.lMission = {}
ddos.puzzles = {}
ddos.puzzles.temp = {}
ddos.puzzles.temp.user = {}

function ddos:init(args)

	self.ip = args[1]
	self.process = args[2]

	for k,v in pairs(manolis.Hacking.Current) do
		if(v.ip == self.ip) then
			math.randomseed(os.time())
			if(self.process=='1234') then
				if(v:GetProgram('firewall')) then
					self.connected = true
					ddos.lMission = v
				end
			end
		end
	end

	if(!self.connected) then
		timer.Simple(1, function()
			hackingTerminal:programPrint('Failed to establish a connection to '..self.ip..':'..self.process, 'ddos')
			hackingTerminal:quitProgram()	
		end)
		return
	end


	self.state = 1
	hackingTerminal:programPrint("Establishing connection to manolis.io BotNet..",'ddos')
	hackingTerminal:programPrint("Connection established.",'ddos')
	hackingTerminal:programPrint("Begin attack on "..self.ip..':'..self.process..'? (y/n)','ddos')

	self.secret = {math.floor(math.random()*999) , math.floor(math.random()*999) , math.floor(math.random()*999) , math.floor(math.random()*999)}

end

function DEC_HEX(IN)
    local B,K,OUT,I,D=16,"0123456789ABCDEF","",0
    while IN>0 do
        I=I+1
        IN,D=math.floor(IN/B),math.mod(IN,B)+1
        OUT=string.sub(K,D,D)..OUT
    end
    return OUT
end

function ddos:tick(command)
	if(command=='q') then hackingTerminal:quitProgram() end
	if(self.state==1) then
		if(command!='y') then
			hackingTerminal:programPrint('Quitting..','ddos')
			hackingTerminal:quitProgram();
			return 
		end

		hackingTerminal:programPrint("CloudFlare hex-protection detected. Dumping CloudFlare RealIPProtection™ Encryption Key:\n")

		local str = ''
		for k,v in pairs(self.secret) do
			str = str..DEC_HEX(tonumber(v))..'.'
		end

		str:sub(1, #str -1)
		hackingTerminal:programPrint(str.."\nPlease enter decimal IP:", 'ddos')


		self.state=2

	elseif (self.state==2) then
		if(command!=(tonumber(self.secret[1])..'.'..tonumber(self.secret[2])..'.'..tonumber(self.secret[3])..'.'..tonumber(self.secret[4]))) then
			timer.Simple(1.5, function()
				hackingTerminal:programPrint("Could not establish a connection to "..command..'\nPlease try again or q to quit', 'ddos')	
			end)
			return
			
		else
			self.state=3
			self:tick()
		end

		
	elseif(self.state==3) then
		hackingTerminal:programPrint('DDoS successful. '..self.ip..'\'s firewall is offline.', 'ddos')
		self.lMission:RemoveProgram('firewall')
		hackingTerminal:quitProgram();
	end

end


manolis.Hacking.Programs['ddos'] = ddos
mCommand.add('ddos', 'Opens ddos utility', function(args,sargs)
	if((!args[1]) or (!args[2])) then
		hackingTerminal:programPrint('Usage: ddos <ip> <port>', 'ddos')
		return
	end

	hackingTerminal:startProgram(manolis.Hacking.Programs['ddos'], args)
end)
