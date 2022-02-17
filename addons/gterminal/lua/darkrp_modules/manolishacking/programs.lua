AddCSLuaFile()
print('gTerminal: Included programs')
if(!manolis) then manolis = {} end
if(!manolis.Hacking) then manolis.Hacking = {} end

manolis.Hacking.Programs = {}
manolis.Hacking.Current = {}
program = {}
program.name = 'Program Name'
program.help = 'Program Help'
program.state = 1
function program:init()

end

function program:tick(command, argTable)

end

function program:quit(command, argTable)

end


manolis.Hacking.BaseProgram = program

include('programs/mail.lua')
include('programs/ftp.lua')
include('programs/mbank.lua')
include('programs/paypal.lua')
include('programs/firewall.lua')
include('programs/ddos.lua')
include('programs/apache.lua')
include('programs/loic.lua')
include('programs/ftp_crack.lua')

//76561198050532576