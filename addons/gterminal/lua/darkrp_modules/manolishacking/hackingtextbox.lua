AddCSLuaFile()
print('gTerminal: Included Hacking Text')
local PANEL = {}
PANEL.History = {}
PANEL.HistoryPos = 0


function PANEL:Init()
	self:SetMultiline(false)
	self:SetSize(ScrW(), 25)
	self:SetPos(0, ScrH() - 25)

	self:SetEditable(true)
	self:SetEnterAllowed( true )
	self:SetDrawBackground(false)
	self:SetTextColor(Color(0,255,0,255))
	self:SetFont("manolisHackingFont")
	self:SetValue('')
	self:SetCursorColor(Color(0,255,0,255))
	self:SetHighlightColor(Color(0,255,0,100))

end



local function doCommand(self, text)
	local command = string.match( text, "^([^%s]+)" )
	if(!command) then
		hackingTerminal:output("")
		return
	end

	local _, endPos = string.find(text, command, 1, true)
	local argString = string.Trim(string.sub(text, endPos+1))

	local argTable = mCommand.parseArgs(argString)
	hackingTerminal:output(text)

	table.insert(self.History, 1, text)

	if(command=='quit') then
		if(hackingTerminal.isProgramRunning) then
			hackingTerminal:quitProgram()
		else
			hackingTerminal:quit()
		end
		
		return
	end

	if not (hackingTerminal.isProgramRunning) then
		if( mCommand.getCommand(command)) then
			mCommand.run(command, argTable, argString)
		else
			hackingTerminal:output("'"..command.."'"..' is not recognized as an internal or external command', true)
		end
	else
		if(command=='q') then return hackingTerminal:quitProgram() end
		hackingTerminal.currentProgram:tick(command, argTable)
	end

end



function PANEL:OnKeyCodeTyped(key)

	if(key==KEY_ENTER and !hackingTerminal.isPrinting) then
		local text = string.Trim(self:GetValue())
		doCommand(self, text)

		if(table.Count(self.History)>100) then 
			table.remove(self.History, table.Count(self.History))
		end
		self:SetText("")
		self:RequestFocus()
	end

	if(key==KEY_UP) then
		self.HistoryPos = self.HistoryPos + 1
		self.HistoryPos = ( (self.HistoryPos) > table.Count(self.History) ) and table.Count(self.History) or self.HistoryPos
	
		self:SetText(self.History[self.HistoryPos] or '')
		self:RequestFocus()

	end

	if(key==KEY_DOWN) then
		self.HistoryPos = self.HistoryPos - 1
		self.HistoryPos = ( (self.HistoryPos) < table.Count(self.History) ) and table.Count(self.History) or self.HistoryPos
	
		self:SetText(self.History[self.HistoryPos])
		self:RequestFocus()
	end
end



vgui.Register("HackingTextBox", PANEL, "DTextEntry")