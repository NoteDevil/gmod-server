local mbank = {}
mbank.name = 'mbank'
mbank.help = "The Peoples Bank!"
mbank.state = 0

mbank.password = 'catsarecool'
mbank.username = 'mano'
mbank.balance = 0

mbank.enteredUsername = ''
mbank.enteredPassword = ''
mbank.curAccount=0
function mbank:init()
	hackingTerminal:print('mBank - The Peoples Bank')
	hackingTerminal:print('Please enter your internet banking ID:')
	self.state = 1
end

function mbank:callback()

end

function mbank:tick(command, argTable)
	if(self.state==1) then
		self.enteredUsername = command
		hackingTerminal:print('Please enter your password:')
		self.state = 2
	elseif(self.state==2) then
		self.enteredPassword = command
		for k,v in pairs(manolis.Hacking.mBank.accounts) do
			if((v.username==self.enteredUsername) and (v.password==self.enteredPassword)) then
				self.username = v.username
				self.password = v.password
				self.balance = v.balance
				self.curAccount = k
				self.callback = v.callback or function() end
			end
		end

		if(self.balance > 0) then
			self.state = 3
			hackingTerminal:programPrint('Logged in as: '..self.username, 'mbank')
			hackingTerminal:programPrint('Your balance is $'..string.Comma(self.balance), 'mbank')
			hackingTerminal:programPrint('\nHow much money would you like to withdraw?', 'mbank')
		else
			hackingTerminal:programPrint('Invalid Credentials! Goodbye.', 'mbank')
			hackingTerminal:quitProgram()
		end


	elseif(self.state==3) then
		if(not tonumber(command) or (tonumber(command)<0)  or (tonumber(command)>self.balance)) then
			hackingTerminal:programPrint('Invalid Amount! Please try again!', 'mbank')
		else
			self.balance = self.balance - tonumber(command)
			hackingTerminal:programPrint('You withdrew '..string.Comma(command)..'$. Your new balance is '..self.balance..'$', 'mbank')

			if(self.balance > 0) then
			hackingTerminal:programPrint('\nHow much money would you like to withdraw?', 'mbank')
		else
			hackingTerminal:programPrint('You cannot withdraw anymore. Goodbye.', 'mbank')

			self:callback()

			hackingTerminal:quitProgram()
			end
		end
	end

end


manolis.Hacking.Programs['mbank'] = mbank

mCommand.add('mbank', 'Opens mBank Internet Banking', function(args,sargs)
	hackingTerminal:startProgram(manolis.Hacking.Programs['mbank'], args)
end)