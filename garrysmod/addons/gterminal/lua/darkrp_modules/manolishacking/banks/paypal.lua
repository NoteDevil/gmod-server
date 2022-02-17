if(!manolis) then manolis = {} end
if(!manolis.Hacking) then manolis.Hacking = {} end


manolis.Hacking.PayPal = {
	accounts = {},
	addAccount = function(username,password,balance,callback)
		table.insert(manolis.Hacking.PayPal.accounts, {username=username,password=password,balance=balance,callback=callback})
	end
}