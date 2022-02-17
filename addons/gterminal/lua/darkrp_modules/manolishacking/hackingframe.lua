AddCSLuaFile()

print('gTerminal:: Included Hacking Frame')
local PANEL = {}
function PANEL:Init()
	self:SetSize(ScrW(), ScrH())
	self:SetPos(0,0)
	print('Hacking Frame created')

end

function PANEL:Paint(w,h)
	surface.SetDrawColor(0, 0, 0, 255)
	surface.DrawRect(0,0, w, h)
end

vgui.Register("HackingFrame", PANEL, "EditablePanel")