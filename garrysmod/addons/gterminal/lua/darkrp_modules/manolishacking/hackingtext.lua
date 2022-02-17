AddCSLuaFile()
print('gTerminal: Included Hacking Text')
local PANEL = {}
local TextSize = 16

function PANEL:Init()
	self:SetMultiline(true)
	self:SetSize(ScrW(), ScrH()-25)
	self:SetPos(0,0)
	self:SetEditable(false)
	self:SetDrawBackground(false)
	self:SetTextColor(Color(0,255,0,255))

	self:SetFont("manolisHackingFont")
end

function PANEL:OnMousePressed()
	self:RequestFocus() -- Always focus?
end

function PANEL:GetRaw(text)
	local val = string.Explode('\n', text)
	local m = math.floor(ScrH()/TextSize)-3
	local newVal = table.concat(val, '\n', #val-m, #val)

	return newVal
end

function PANEL:AddText(text)
	local curText = self:GetValue()..text
	local lines = string.Explode('\n', curText)
	if(table.Count(lines)+3 > (math.floor(ScrH()/TextSize))) then -- (2=HackingTextBoxHeight)
		curText = self:GetRaw(curText)
	end

	self:SetText(curText)

end

vgui.Register("HackingText", PANEL, "DTextEntry")