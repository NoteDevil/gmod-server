local mail = {}
mail = table.Copy(manolis.Hacking.BaseProgram)
mail.name = 'mail'
mail.help = 'View and Send E-Mails'
mail.state = 0
mail.rmid = 0

function mail:init()
	if(#hackingTerminal.mail > 0) then
		for k,v in pairs(hackingTerminal.mail) do
			hackingTerminal:programPrint(k .. '. '..v.from .. ' - '..v.subject, self.name)
		end

		hackingTerminal:programPrint('Please select an item: (or rm to remove)', self.name)
		mail.state = 2
	else
		hackingTerminal:programPrint('Your mailbox is empty. Goodbye!', self.name)
		hackingTerminal:quitProgram()
	end
end

function mail:tick(command, args)
	if(command=='q') then hackingTerminal:quitProgram() end
	if(command=='rm') then 
		mail.state=3
		hackingTerminal:programPrint('Select item to remove:',self.name)
		return
	end

	if(mail.state==3) then
		if(hackingTerminal.mail[tonumber(command)]) then
			hackingTerminal:programPrint('Remove Mail ID '..command..'? (y/n)',self.name)
			mail.state=4
			mail.rmid = command
			return
		else
			hackingTerminal:programPrint('Mail not found. Try again (or q to quit)',self.name)
			return
		end
	end

	if(mail.state==4) then
		if(command=='y') then
			hackingTerminal:programPrint('Deleted.',self.name)
			table.remove(hackingTerminal.mail, mail.rmid)
			self:init()
			return
		else
			self:init()
			return
		end
	end
	if(mail.state==2) then
		if((!command) or (!tonumber(command)) or (#hackingTerminal.mail<tonumber(command)) or (tonumber(command) < 1)) then 
			hackingTerminal:programPrint('Invalid Input. Please try again:', self.name)
			return
		end

		if(hackingTerminal.mail[tonumber(command)].opened) then hackingTerminal.mail[tonumber(command)].opened() end
		hackingTerminal:programPrint('\nFrom:'..hackingTerminal.mail[tonumber(command)].from..'\n'..'Subject: '..hackingTerminal.mail[tonumber(command)].subject..'\n\n'..hackingTerminal.mail[tonumber(command)].message, self.name)
		hackingTerminal:quitProgram()
	end
end

manolis.Hacking.Programs['mail'] = mail
mCommand.add('mail', 'Opens mailbox', function(args,sargs)
	hackingTerminal:startProgram(manolis.Hacking.Programs['mail'])
end)
