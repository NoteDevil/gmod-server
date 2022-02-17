local ftp_crack = {}
ftp_crack.name = 'ftp_crack'
ftp_crack.help = 'FTP Cracker'
ftp_crack.state = 0

ftp_crack.ip = ''
ftp_crack.process = ''


ftp_crack.connected = false
ftp_crack.secret = ''
ftp_crack.lMission = {}
ftp_crack.puzzle = 0
ftp_crack.puzzles = {}
ftp_crack.puzzles.temp = {}
ftp_crack.puzzles.temp.user = {}

ftp_crack.username = ''
ftp_crack.password = ''
ftp_crack.crackable = false

function ftp_crack:init(args)

	self.ip = args[1]
	self.process = args[2]

	for k,v in pairs(manolis.Hacking.Current) do
		if(v.ip == self.ip) then
			math.randomseed(os.time())
			if(self.process=='21') then
				if(v:GetProgram('firewall')) then
					timer.Simple(1, function()
						hackingTerminal:programPrint('Failed to establish a connection. Is a firewall active?')
						hackingTerminal:quitProgram()
					end)
					return
				end
				if(v:GetProgram('ftp')) then
					self.connected = true
					self.password = v.ftp.password
					self.username = v.ftp.username
					self.crackable = v.ftp.isCrackable
					ftp_crack.lMission = v
				end

				if(!self.crackable) then
					self.connected = false
					timer.Simple(1, function()
						hackingTerminal:programPrint('An internal server error occured')
						hackingTerminal:quitProgram()
					end)
					return
				end
			end
		end
	end

	if(!self.connected) then
		timer.Simple(1, function()
			hackingTerminal:programPrint('Failed to establish a connection to '..self.ip..':'..self.process, 'ftp_crack')
			hackingTerminal:quitProgram()	
		end)
		return
	end


	self.state = 1
	hackingTerminal:programPrint("Begin cracking FTP server at "..self.ip..':'..self.process..'? (y/n)','ftp_crack')
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



function ftp_crack:tick(command)
	if(command=='q') then hackingTerminal:quitProgram() end
	if(self.state==1) then
		if(command!='y') then
			hackingTerminal:programPrint('Quitting..','ftp_crack')
			hackingTerminal:quitProgram();
			return 
		end
	



		hackingTerminal:programPrint("Attempting to crack FTP details..\n",'ftp_crack')
		hackingTerminal:programPrint("Found username: "..self.username, 'ftp_crack')

		local pw = self.password
		hackingTerminal:programPrint('Unable to decode password. Dumping data:','ftp_crack')

		local letters = {'#','%','^','"','!','*','º','i','x','>','.','&','•','─','÷','○','%','•'}
		local lines = {}
		local every = math.floor((5*40)/string.len(pw))+5
		local letterCount = 0
		local p = 1
		local g = ''
		for l=1,5 do
			for x=1,50 do
				letterCount = letterCount+1
				if(letterCount==every) then
					g=g..string.upper(pw[p])
					letterCount = 0
					p=p+1
				else
					g=g..table.Random(letters)
				end
			end

			g=g..'\n'
		end

		hackingTerminal:programPrint(g..'\n\nPlease enter password:','ftp_crack')

		self.state=2


	elseif(self.state==2) then
		if(string.lower(command)!=self.password) then
			hackingTerminal:programPrint('Incorrect. Please try again:','ftp_crack')
			return
		else
			hackingTerminal:programPrint('Decode successful. \n\nUsername: '..self.username..'\nPassword: '..self.password, 'ftp_crack')
			hackingTerminal:quitProgram()
			return

		end
	end
end


manolis.Hacking.Programs['ftp_crack'] = ftp_crack
mCommand.add('ftp_crack', 'Opens FTP cracking utility', function(args,sargs)
	if((!args[1]) or (!args[2])) then
		hackingTerminal:programPrint('Usage: ftp_crack <ip> <port>', 'ftp_crack')
		return
	end

	hackingTerminal:startProgram(manolis.Hacking.Programs['ftp_crack'], args)
end)
