DGF4.elements = {
	{
		pos = 1,
		name = DGF4.Translation.exit,
		DontSave = true,
		callBack = function(self)
			self:Close()
		end
	}
}

function DGF4:RegisterButton(data)
	table.insert(DGF4.elements, 1, data)
end

include("cl_tab_scoreboard.lua")
include("cl_tab_donate.lua")
include("cl_tab_commands.lua")
include("cl_tab_inventory.lua")
include("cl_tab_jobs.lua")
include("cl_tab_shop.lua")
include("cl_tab_site.lua")
include("cl_tab_help.lua")
include("cl_tab_code.lua")
include("cl_tab_settings.lua")
include("cl_tab_groups.lua")

function DGF4.BaseElement(self, name, color, wide)
	local x, y, ply = ScrW(), ScrH(), LocalPlayer()
	surface.SetFont("HeaderMenu")
	local text_w, text_h  = surface.GetTextSize(name)
	color = Color(218, 91, 82)
	if IsValid(self["run"]) then self["run"]:Remove() end
	self["run"] = vgui.Create("DFrame", self)
	local s = self["run"]
	s:SetSize(wide, y)
	s:SetPos(200, 0)
	s.Paint = function(self, w, h)
	end
	-- s:MoveTo( 200, 0, 0.2, 0, 1)
	s:SetTitle("")
	s:SetDraggable(false)
	s:ShowCloseButton(false)
	return s
end

local blur = Material("pp/blurscreen")
function DGF4:drawBlur( x, y )
	x = x or 0
	y = y or 0
	-- Intensity of the blur.
	surface.SetDrawColor( 255, 255, 255 )
		surface.SetMaterial( blur )

		for i = 1, 3 do
			blur:SetFloat( "$blur", i * 2 )
			blur:Recompute()

			render.UpdateScreenEffectTexture()
			surface.DrawTexturedRect( -x-1, -y-1, ScrW() + 2, ScrH() + 2 )
		end
end

table.SortByMember(DGF4.elements, "pos")

local FRAME = {}
function FRAME:Init()
	local x, y, ply = ScrW(), ScrH(), LocalPlayer()
	surface.SetFont("ButtonsF4Menu")
	self:SetSize(x, y)
	self:SetPos(0, 0)
	self:MakePopup()
	self:SetTitle("")
	self:SetDraggable(false)
	self:ShowCloseButton(false)
	self["lerp"] = 0

	self.menu = vgui.Create("DPanel", self)
	self.menu:SetSize(200, y)
	self.menu:SetPos(0,0)
	self.menu.Paint = function(self,w,h)
		draw.RoundedBox(0, 0, 0, w, h, Color(45, 45, 45, 0));
	end

	self.submenu = vgui.Create("DPanel", self.menu)
	self.submenu:SetSize(200, #DGF4.elements*55)
	self.submenu:SetPos(0,y/2-(#DGF4.elements*55)/2)
	self.submenu.Paint = function(self,w,h)
	end

	for k,v in pairs(DGF4.elements) do
		local text_w, text_h  = surface.GetTextSize(v["name"])
		self['mbtn'..k] = vgui.Create("DButton", self.submenu)
		self['mbtn'..k]:SetSize(text_w, text_h)
		self['mbtn'..k]:SetPos(20,text_h*(k-1))
		self['mbtn'..k]:SetText("")
		self['mbtn'..k].DoClick = function(slf)
			for k,but in pairs( self.submenu:GetChildren() ) do
				but.Selected = false
			end
			if not v.DontSave then
				LocalPlayer().LastTab = k
			end 
			slf.Selected = true
			 v["callBack"](self)
		end
		self['mbtn'..k].Paint = function(slf, w, h)
			if slf.Selected then
				draw.SimpleText( v["name"], "ButtonsF4Menu_Glow", w/2, h/2, Color(255, 255, 255, 100), 1, 1 )
			elseif slf:IsHovered() then
				draw.SimpleText( v["name"], "ButtonsF4Menu_Glow", w/2, h/2, Color(255,255,255, 50), 1, 1 )
			end
			draw.SimpleText( v["name"], "ButtonsF4Menu", w/2, h/2, Color(255,255,255, 150), 1, 1 )
		end
	end
	if LocalPlayer().LastTab then
		DGF4.elements[LocalPlayer().LastTab]["callBack"](self)
	else
		DGF4.elements[1]["callBack"](self)
	end
end

function FRAME:Paint(w, h)
	self["lerp"] = Lerp( 1 * FrameTime(), self["lerp"] or 0, 2)
	DrawBloom( self["lerp"], 2, 9, 9, 1, 1, 1, 1, 1 )
	DGF4:drawBlur()
	-- Derma_DrawBackgroundBlur(self, 0)
	draw.RoundedBox( 0, 0, 0, w, h, Color( 32,36,40, 220 ) )
end

function FRAME:Think()
	if input.WasKeyPressed( KEY_F4 ) then
		self:Close()
	end
end

vgui.Register('F4MenuFrame', FRAME, 'DFrame')
