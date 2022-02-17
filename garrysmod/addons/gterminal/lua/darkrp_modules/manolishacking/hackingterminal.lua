AddCSLuaFile()

print('gTerminal:: Included Hacking Terminal')
hackingTerminal = {}
hackingTerminal.isPrinting = false
hackingTerminal.mail = {}
hackingTerminal.fFiles = {}

hackingTerminal.missions = {}

hackingTerminal.currentProgram = nil
hackingTerminal.isProgramRunning = false
hackingTerminal.Files = {}

local printQue = 0

function hackingTerminal:output(text, login, program)
	if(login) then
		text = "> "..text.."\n"
	elseif(program) then
		text = program.."> "..text.."\n"
	elseif(self.isProgramRunning) then
		text = "> "..text.."\n"
	else
		text = "> ".. LocalPlayer():Name() .. "@".."manolis.io:~$ " .. text .. "\n"
	end
	hackingText:AddText(text)
end

function hackingTerminal:print(text, time, login, program)
	if(!time) then time = 0.05 end
	local t = string.Explode('\n', text)
	hackingTerminal.isPrinting = true

	for k,v in pairs(t) do
		printQue = printQue + 1
		timer.Simple(time * k, function()
			if(printQue==1) then
				hackingTerminal.isPrinting = false
			end
			printQue = printQue - 1
			self:output(t[k], login, program)
		end)
	end
end

function hackingTerminal:programPrint(text,program)
	self:print(text, 0.04, false, program)
end


function hackingTerminal:startProgram(program, args)
	self.currentProgram = program
	self.isProgramRunning = true
	self.currentProgram:init(args)
end

function hackingTerminal:SendMail(mail)
	local rmail = {}
	rmail.from = mail.from or ''
	rmail.subject = mail.subject or ''
	rmail.message = mail.message or ''
	rmail.opened = mail.opened or function() end
	
	timer.Simple(3, function() // lol smtp 
		table.insert(self.mail, mail)
		self:programPrint('You have new mail!', 'gTerminal')
	end)
	
end

function hackingTerminal:quitProgram()
	self.currentProgram = nil
	self.isProgramRunning = false
end

function hackingTerminal:randomIP()
	local ip = math.floor(1+math.random()*998) ..'.'..1+math.floor(math.random()*998)..'.'..1+math.floor(math.random()*998)..'.'..1+math.floor(math.random()*998)
	return ip
end

// 76561198050532576

function hackingTerminal:addHTTPFile(file)
	table.insert(self.fFiles, file)
end

function hackingTerminal:addFile(file)
	file.path = string.match(file.path, "^.+/(.+)$") or file.path
	table.insert(self.Files, file)
end

function hackingTerminal:viewFile(fileName)
	for k,v in pairs(self.Files) do
		if(fileName==v.path) then
			self:programPrint(v.contents, 'cat')
			return
		end
	end
	self:programPrint('File not found.', 'cat')	
end

function hackingTerminal:removeFile(fileName)
	for k,v in pairs(self.Files) do
		if(fileName==v.path) then
			table.remove(self.Files, k)
			return
		end
	end
	self:programPrint('File not found.', 'rm')
end

function hackingTerminal:quit()
	self:programPrint('Broadcast message from '..LocalPlayer():Name()..'@manolis.io\n(dev/pts/0) at '..os.date("*t").hour..':'..os.date('*t').min, 'gTerminal')
	self:programPrint('The system is going down for shutdown NOW!','gTerminal');
	timer.Simple(2, function()
		self:forceQuit()
	end)
end


function hackingTerminal:forceQuit()
	if(hackingPanel) then
		hackingPanel:Remove()
	end
	
	net.Start('manolisHackingQuit')
	net.SendToServer()
end

net.Receive('ManolisKickFromTerminal', function()
	hackingTerminal:forceQuit()
end)

function hackingTerminal:addMission(mission, reward)

	local real = table.Copy(mission)
	local base = table.Copy(manolis.Hacking.Missions.baseServer)
	setmetatable(base, {__index = base }) // New meta
	setmetatable(real, {__index = base})

	real.reward = reward


	table.insert(manolis.Hacking.Current, real)
	real:init()
end

mCommand.add('ls', 'Lists all local files', function(args,sargs)
	for k,v in pairs(hackingTerminal.Files) do
		hackingTerminal:programPrint(k..' - '..v.path,'ls')
	end
end)

mCommand.add('cat', 'Opens a local file (cat <filename>)', function(args,sargs)
	if(!args[1]) then
		hackingTerminal:print('Usage: cat <filename>')
		return 
	else
		hackingTerminal:viewFile(args[1])
	end
end)

mCommand.add('rm', 'Removes a local file (rm <filename>)', function(args,sargs)
	if(!args[1]) then
		hackingTerminal:print('Usage: rm <filename>')
		return 
	else
		hackingTerminal:removeFile(args[1])
	end
end)

mCommand.add('http', 'Retreive a HTTP file (http url)', function(args,sargs)
	if(!args[1]) then
		hackingTerminal:print('Usage: http <url>')
		return
	else
		for k,v in pairs(hackingTerminal.fFiles) do
			if(v.name==args[1]) then
				timer.Simple(1, function()
					local path = string.match(v.name, "^.+/(.+)$") or v.name
					hackingTerminal:programPrint('File: '..path..' downloaded.', 'http')
					
					hackingTerminal:addFile({path=path, contents=v.contents, onRun=v.onRun})
				end)
				return
			end
		end

		timer.Simple(2,function()
			hackingTerminal:programPrint('HTTP Timeout', 'http')
		end)
	end

end)

function hackingTerminal:NewMail(from, subject, message)
	local mail = {}
	mail.from = from
	mail.subject = subject
	mail.message = message

	self:SendMail(mail)
end
timer.Simple(10, function()	
	--hackingTerminal:startProgram(manolis.Hacking.Programs[1])

end)