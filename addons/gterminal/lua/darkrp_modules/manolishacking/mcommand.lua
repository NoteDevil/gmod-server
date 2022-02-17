AddCSLuaFile()
print('gTerminal: Inclided mCommand')
include('mstring.lua')

mCommand = {}
local commands = {}
mCommand.commands = commands
function mCommand.parseArgs(s)
	local t      = {}
	local i      = 1
	local length = string.len(s)
	while ( i <= length ) do
		if ( string.utf8sub( s, i, i ) == "\"" ) then
			local char = string.find( s, "\"", i + 1 )
			if ( char ) then
				table.insert( t, string.utf8sub( s, i + 1, char - 1 ) )
				local _, endPos = string.find( s, "%s*.", char + 1 )
				i = endPos or char + 1
			else
				char = string.find( s, "%s", i + 1 )
				if ( char ) then
					table.insert( t, string.utf8sub( s, i + 1, char - 1 ) )
					local _, endPos = string.find( s, "%s*.", char + 1 )
					i = endPos or char + 1
				else
					table.insert( t, string.utf8sub( s, i + 1 ) )
					i = length + 1
				end
			end
		else
			local char = string.find( s, "%s", i + 1 )
			if ( char ) then
				table.insert( t, string.utf8sub( s, i, char - 1 ) )
				local _, endPos = string.find( s, "%s*.", char + 1 )
				i = endPos or char + 1
			else
				table.insert( t, string.utf8sub( s, i ) )
				i = length + 1
			end
		end
	end

	return t
end

function mCommand.getCommand(command)
	return mCommand.commands[command]
end

function mCommand.run(command, args, sargs)
	if(mCommand.commands[command]) then
		mCommand.commands[command].callback(args, sargs)
	end
end

function mCommand.add(name,help,callback)
	local command = {}
	command.name = name
	command.help = help
	command.callback = callback
	mCommand.commands[name] = command
end