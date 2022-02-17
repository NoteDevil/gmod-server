local paypal = {}
paypal.name = 'paypal'
paypal.help = "PayPal United Kingdom: Pay, Send Money & Accept Payments securely!"
paypal.state = 0

paypal.password = 'catsarecool'
paypal.username = 'mano'
paypal.balance = 0

paypal.enteredUsername = ''
paypal.enteredPassword = ''
function paypal:init()
	hackingTerminal:print('PayPal United Kingdom: Pay, Send Money & Accept Payments securely!')
	hackingTerminal:print('Please enter your username:')
	self.state = 1
end
// 76561198050532576

function paypal:callback()

end

function paypal:tick(command, argTable)
	if(self.state==1) then
		self.enteredUsername = command
		hackingTerminal:print('Please enter your password:')
		self.state = 2
	elseif(self.state==2) then
		self.enteredPassword = command
		for k,v in pairs(manolis.Hacking.PayPal.accounts) do
			if((v.username==self.enteredUsername) and (v.password==self.enteredPassword)) then
				self.username = v.username
				self.password = v.password
				self.balance = v.balance
				self.callback = v.callback or function() end

			end
			

		end

		if(self.balance > 0) then
			self.state = 3
			hackingTerminal:programPrint('Welcome to PayPal, '..self.username..'. The most secure payment service on the planet!', 'paypal')
			hackingTerminal:programPrint('Your balance is $'..string.Comma(self.balance), 'paypal')
			hackingTerminal:programPrint('\nHow much money would you like to withdraw?', 'paypal')
		else
			hackingTerminal:programPrint('Invalid Credentials! Goodbye.', 'paypal')
			hackingTerminal:quitProgram()
		end


	elseif(self.state==3) then
		if(not tonumber(command) or (tonumber(command)<0)  or (tonumber(command)>self.balance)) then
			hackingTerminal:programPrint('Invalid Amount! Please try again!', 'paypal')
		else
			self.balance = self.balance - tonumber(command)
			hackingTerminal:programPrint('You withdrew '..string.Comma(command)..'$. Your new balance is '..self.balance..'$', 'paypal')


			if(self.balance==0) then
				hackingTerminal:programPrint('We no longer value you as a customer. Goodbye!', 'paypal')
				self:callback()
				hackingTerminal:quitProgram()
			else
				hackingTerminal:programPrint('\nHow much money would you like to withdraw?', 'paypal')
			end
		end
	end

end

manolis.Hacking.Programs['paypal'] = paypal

mCommand.add('paypal', 'Opens PayPal.co.uk', function(args,sargs)
	hackingTerminal:startProgram(manolis.Hacking.Programs['paypal'], args)
end)