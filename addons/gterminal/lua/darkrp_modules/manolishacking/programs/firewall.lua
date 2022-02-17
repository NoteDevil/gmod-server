local firewall = {}
firewall.name = "firewall"
firewall.port = 1234
firewall.active = true

function firewall:open()
	hackingTerminal:programPrint('Access Denied.', 'FIREWALL')
end

function firewall:attack()
	self.active = false
end

manolis.Hacking.Programs['firewall'] = firewall