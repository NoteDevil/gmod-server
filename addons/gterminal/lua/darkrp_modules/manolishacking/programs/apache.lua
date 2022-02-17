local apache = {}
apache.name = 'apache'
apache.help = 'Apache web server'

apache.active = true
function apache:init(args)
	hackingTerminal:programPrint('Access Denied.', 'Apache')
end

function apache:attack()
	self.active = false
	self.onDown()
end
manolis.Hacking.Programs['apache'] = apache

apache.onDown = function()
end