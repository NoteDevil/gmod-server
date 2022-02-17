if(!manolis) then manolis = {} end
manolis.Hacking = {}

include('mcommand.lua')
include('hackingframe.lua')
include('hackingtext.lua')
include('hackingtextbox.lua')

include('banks.lua')
include('programs.lua')


include('hackingterminal.lua')
include('missions.lua')


surface.CreateFont("manolisHackingFont", {
	font = "Courier New",
	size = 14,
	weight = 500,
	antialias = true
})
// 76561198063406120
hackingPanel = nil


local function InitTerminal()
	hackingTerminal:output('logging in to manolis.io as '..LocalPlayer():Name(), true)
	hackingTerminal:print('Successfully logged in to manolis.io', 0.04, true)


	hackingTerminal:print([[

	                                   ___                                 
	                                  /\_ \    __             __           
	  ___ ___      __      ___     ___\//\ \  /\_\    ____   /\_\    ___   
	/' __` __`\  /'__`\  /' _ `\  / __`\\ \ \ \/\ \  /',__\  \/\ \  / __`\ 
	/\ \/\ \/\ \/\ \L\.\_/\ \/\ \/\ \L\ \\_\ \_\ \ \/\__, `\__\ \ \/\ \L\ \
	\ \_\ \_\ \_\ \__/.\_\ \_\ \_\ \____//\____\\ \_\/\____/\_\\ \_\ \____/
	 \/_/\/_/\/_/\/__/\/_/\/_/\/_/\/___/ \/____/ \/_/\/___/\/_/ \/_/\/___/ 
	 																									roni_sl was here :D
	                     

	mounting /dev/root
	Root mount waiting for: mbus2 mbus1 mbus
	ugen0.3: <MANOLISIO> at mbus0
	Loading kernal modules....................................Done
	Loading peripheral devices................................Done
	Loading core modules......................................Done
	Loading mScripts..........................................Done
	loading gTerminal.........................................Done

	Welcome to gTerminal/1.0
	Type 'help' for a list of commands
	Type 'web' to view a detailed hacking tutorial
	Type 'quit' to quit

	]], .05, true)
end

net.Receive('manolisHackingUse', function(len)
	local ent = net.ReadEntity()
	if(ent) then 
		ent:UseCam()
	end
end)



local function CreatePanel()
	if ((not hackingPanel) or (not hackingPanel:IsValid())) then
		hackingPanel = vgui.Create('HackingFrame')
		hackingText = vgui.Create('HackingText', hackingPanel)

		hackingInput = vgui.Create('HackingTextBox', hackingPanel)

		hackingPanel.OnMousePressed = function()
			hackingInput:RequestFocus()
		end


		hackingPanel:MakePopup()
		hackingInput:RequestFocus()


		InitTerminal()
	end

end


mCommand.add('web', 'Open tutorial', function(args, sargs)
	gui.OpenURL('http://manolis.io/hacking/tutorial')
end)

mCommand.add('print', 'Print something', function(args, sargs)
	if(sargs=='') then
		hackingTerminal:print('Usage: print ...')
		return
	end
	local argString = args[1]
	for k,v in pairs(args) do
		if(k!=1) then
			argString = argString.."\n"..v
		end
	end
	hackingTerminal:print(argString, .05, true)
end)

mCommand.add('help', 'For real?', function(args, sargs)
	if(args[1]) then
		local cmd = mCommand.getCommand(args[1])
		if(cmd) then
			hackingTerminal:print(cmd.name .. ' - '..cmd.help..'\n')
		end
	else
		local helpString = 'Programs:\n\n'

		for k,v in pairs(manolis.Hacking.Programs) do
			if(v.help) then
				helpString=helpString..v.name..' - '..v.help..'\n'
			end
		end

		helpString=helpString..'\nCommands:\n\n'

		for k,v in pairs(mCommand.commands) do
			if(v.help) then
				helpString=helpString..v.name..' - '..v.name..'\n'
			end
		end





		hackingTerminal:print(helpString)
	end
end)

mCommand.add('clear', 'Clears the terminal', function(args,sargs)
	hackingText:SetValue('')
end)

mCommand.add('manolis', '', function()
	hackingTerminal:print('{{ user_steamid }}')
end)

mCommand.add('credits', 'Shows Credits', function(args, sargs)
	hackingTerminal:print([[
		gTerminal 1.0 - Copyright Manolis Vrondakis 2015+
		http://manolisvrondakis.com/
	]])
end)


local function manolisHackingOpen(entity)
	CreatePanel()
end

net.Receive('manolisHackOpen', function(len)
	manolisHackingOpen(net.ReadEntity())
end)