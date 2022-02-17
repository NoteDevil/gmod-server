
//This file is mainly used for UI based stuff and controlling the miners.

include("bitminers2_config.lua")

local CloseMaterial = Material("materials/bitminers2/ui/close.png" , "noclamp smooth")
local TerminalBackground = Material("materials/bitminers2/ui/terminal_background.png" , "noclamp smooth")
surface.CreateFont( "BM2ConsoleFont", {
	font = "Ubuntu Mono", 
	extended = false,
	size = 19,
	weight = 500,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false,
} )

//My bad attempt and drop shadows :/
local function DrawDropShadow(x, y, sizex, sizey, strength, distance)
	for i = 1, math.ceil(distance) * 2, 2 do
		draw.RoundedBox(50, x - i, y - i, sizex + (i * 2), sizey + (i * 2), Color(10,10,10,Lerp((i/2) / distance,strength, 0)))
	end
end

local terminalIsOpen = false
//So we can access it later
local consoleDisplay = nil
//Active entity that we are in the terminal for
local activeBitminerEntity = nil
//This will contain a list of all the intructions for the terminal for this entity
local entityInstructions = {}

local lastCommand = ""

//Thanks Lua wiki
function comma_value(amount)
  local formatted = amount
  while true do  
    formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1,%2')
    if (k==0) then
      break
    end
  end
  return formatted
end

function BM2OpenTerminal(entity)
	activeBitminerEntity = entity

	terminalIsOpen = true

	local frame = vgui.Create("DFrame", nil)
	frame:SetTitle("")
	frame:NoClipping(true)
	frame:ShowCloseButton(false)
	frame:SetSize(800,500)
	frame:Center()
	frame.Close = function(s)
		activeBitminerEntity.terminalHistory = consoleDisplay.history
		terminalIsOpen = false
		s:Remove()
	end

	//Draw terminal frame
	frame.Paint = function(s , w , h)
		//Draw shadow
		DrawDropShadow(0,0,w ,h, 20, 40)
		draw.RoundedBoxEx(8, 0, 0, w, h, Color(70, 68, 69, 255), true, true, false, false)
		//Draw background
		draw.RoundedBox(0, 3, 30, w-6, h - 33, Color(48, 10, 36))
		surface.SetMaterial(TerminalBackground)
		surface.SetDrawColor(Color(255,255,255,30))
		surface.DrawTexturedRect(3,3,w-6,h-33)
	end

	local closeButton = vgui.Create("DButton", frame)
	closeButton:SetPos(800 - 20 - 5, 5)
	closeButton:SetSize(20,20)
	closeButton:SetText("")
	closeButton.Paint = function(s , w , h)
		surface.SetMaterial(CloseMaterial)
		surface.SetDrawColor(Color(255,255,255,255))
		surface.DrawTexturedRect(0,0,w,h)
	end
	closeButton.DoClick = function(s)
		frame:Close()
	end

	consoleDisplay = vgui.Create( "RichText", frame)
	consoleDisplay:SetPos( 3, 30)
	consoleDisplay:SetSize( 800 - 6, 500 - 30 - 3 + 10)
	function consoleDisplay:PerformLayout()
		self:SetFontInternal( "BM2ConsoleFont" )
	end
	consoleDisplay:SetVerticalScrollbarEnabled(false)

	consoleDisplay.history = ""

	consoleDisplay.history = consoleDisplay.history.."Found memory (256mb)\n"
	consoleDisplay.history = consoleDisplay.history.."Found OS\n"
	consoleDisplay.history = consoleDisplay.history.."Finished loading OS\n"
	consoleDisplay.history = consoleDisplay.history.."Starting BitOS 1.0\n"
	consoleDisplay.history = consoleDisplay.history.."---------------------------------------\n"
	consoleDisplay.history = consoleDisplay.history.."Welcome to BitOS! For help on how to operate the device please read the documents included with your hardware or type the command 'help' for a list of usefull commands!\n"
	consoleDisplay.history = consoleDisplay.history.."\n\n"

	//Load history if it exists
	if activeBitminerEntity.terminalHistory ~= nil then
		consoleDisplay.history = activeBitminerEntity.terminalHistory
	end 
	local timeSinceLastStokeAttempt = CurTime()
	local consoleInput = vgui.Create( "DTextEntry", frame )
	consoleInput:SetPos( 3, 30)
	consoleInput:SetSize(-300, - 300)
	consoleInput.OnEnter = function( self )
		consoleDisplay.history = consoleDisplay.history.."root@bitminer:~$ "..self:GetText().."\n"
		BM2HandleCommandLine(self:GetText()) //Handle command
		lastCommand = self:GetText()
		self:SetText("")
		LocalPlayer():EmitSound("bitminers2/keystroke.mp3", 75, math.random(96,102), 0.5)
	end 
	consoleInput.OnChange = function(s)
		if CurTime() - timeSinceLastStokeAttempt > 0.04 then 
			//EmitSound(string soundName,number soundLevel=75,number pitchPercent=100,number volume=1,number channel=CHAN_AUTO)
			LocalPlayer():EmitSound("bitminers2/keystroke.mp3", 75, math.random(98,102), 0.3)
		end
		timeSinceLastStokeAttempt = CurTime()
	end
	consoleInput.Think = function(s)
		s:RequestFocus()
		if input.IsKeyDown(KEY_UP) then
			s:SetText(lastCommand)
		end
	end

	consoleDisplay.Think = function(s)
		s:SetText("")
		for k ,v in pairs(string.Explode("\n", s.history.."root@bitminer:~$ "..consoleInput:GetText())) do
			s:AppendText(v.."\n")
		end
		s:GotoTextEnd()
	end

	frame:MakePopup()
end

//Takes a string from the command line and does the correct instruction for it
function BM2HandleCommandLine(command)
	local command = string.Explode(" ", string.lower(command))
	if entityInstructions[command[1]] then
		entityInstructions[command[1]].action(command[2], command[3], entityInstructions, activeBitminerEntity, consoleDisplay)
		return true
	else
		consoleDisplay.history = consoleDisplay.history.."The command you entered is not recognized as a command, type 'help' for more infomation.\n"
		return false
	end
end

//This is a list of default instructions that get merged with custom ones.
//They can of course be overriden aswell.
local BM2DefaultIntructions = {
	clear = { //Clears the screen
		command = "CLEAR",
		description = "Clears the screen.",
		action = function(arg1, arg2, instructionTable, ent, consoleDisplay)
			consoleDisplay.history = ""
		end
	},
	help = { //Prints help instructions
		command = "HELP",
		description = "Outputs a list of command available.",
		action = function(arg1, arg2, instructionTable, ent, consoleDisplay)
			consoleDisplay.history = consoleDisplay.history.."\n-------------------HELP-------------------\n"
			for k ,v in pairs(instructionTable) do
				consoleDisplay.history = consoleDisplay.history..string.upper(k).." - "..v.description.."\n"
			end
			consoleDisplay.history = consoleDisplay.history.."------------------------------------------\n\n"
		end
	}
}

//Receives a request to open a terminal for this entity, so set it up
net.Receive("BM2.OpenTerminal", function()
	local e = net.ReadEntity()
	if not terminalIsOpen then
		//Set up instructions for that entity
		local instructions = table.Copy(BM2DefaultIntructions)
		if e.customInstructions ~= nil then
			table.Merge(instructions, e.customInstructions)
		end
		entityInstructions = instructions

		BM2OpenTerminal(e)
	end
end)

net.Receive("BM2.Client.TerminalPrint", function()
	local str = net.ReadString()
	if terminalIsOpen then
		consoleDisplay.history = consoleDisplay.history..str.."\n"
	end
end)

net.Receive("BM2.CloseTerminal", function()
	if net.ReadEntity() == activeBitminerEntity then
		//BM2CloseTerminal
	end
end)
