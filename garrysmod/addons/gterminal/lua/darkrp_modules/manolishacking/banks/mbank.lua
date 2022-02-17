if(!manolis) then manolis = {} end
if(!manolis.Hacking) then manolis.Hacking = {} end


manolis.Hacking.mBank = {
	accounts = {},
	addAccount = function(username,password,balance, callback)
		table.insert(manolis.Hacking.mBank.accounts, {username=username,password=password,balance=balance, callback=callback})
	end
}

