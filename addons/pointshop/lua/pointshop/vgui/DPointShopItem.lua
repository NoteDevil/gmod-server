local PANEL = {}

local adminicon = Material("icon16/shield.png")
local equippedicon = Material("icon16/user_suit.png")
local groupicon = Material("icon16/group.png")

local canbuycolor = Color(0, 0, 0)
local cantbuycolor = Color(150, 150, 150)
local ownedcolor = Color(0, 0, 0)

surface.CreateFont( "PS_ItemName", {
	font = "Arial",
	extended = true,
	size = 18,
	weight = 800,
})

surface.CreateFont( "PS_ItemPrice", {
	font = "Arial",
	extended = true,
	size = 36,
	weight = 800,
})

surface.CreateFont( "PS_ItemFor", {
	font = "Roboto",
	extended = true,
	size = 14,
	weight = system.IsWindows() and 300 or 500,
	antialias = true,
})

function PANEL:Init()
	self.Info = ""
	self.InfoHeight = 14
end

function PANEL:OnMousePressed( mousecode )

	self:MouseCapture( true )
	self.Depressed = true
	self:InvalidateLayout( true )

end

function PANEL:OnMouseReleased( mousecode )

	self:MouseCapture( false )

	if ( !self.Depressed ) then return end

	self.Depressed = nil
	self:InvalidateLayout( true )

	if ( !self.Hovered ) then return end

	if ( mousecode == MOUSE_LEFT ) then
		self:DoClick()
	end

	self.Depressed = nil

end

function PANEL:DoClick()
	local points = PS.Config.CalculateBuyPrice(LocalPlayer(), self.Data)

	if not LocalPlayer():PS_HasItem(self.Data.ID) and not LocalPlayer():PS_HasPoints(points) then
		notification.AddLegacy("У тебя не хватает "..PS.Config.PointsName.." для этого!", NOTIFY_GENERIC, 5)
	end

	local menu = DermaMenu(self)

	if LocalPlayer():PS_HasItem(self.Data.ID) then
		menu:AddOption('Продать', function()
			Derma_Query('Ты уверен, что хочешь продать ' .. self.Data.Name .. '?', 'Продать предмет',
				'Да', function() LocalPlayer():PS_SellItem(self.Data.ID) end,
				'Нет', function() end
			)
		end)
	elseif LocalPlayer():PS_HasPoints(points) then
		menu:AddOption('Купить', function()
			Derma_Query('Ты уверен, что хочешь купить ' .. self.Data.Name .. '?', 'Купить предмет',
				'Да', function() LocalPlayer():PS_BuyItem(self.Data.ID) end,
				'Нет', function() end
			)
		end)
	end

	if LocalPlayer():PS_HasItem(self.Data.ID) then
		menu:AddSpacer()

		if LocalPlayer():PS_HasItemEquipped(self.Data.ID) then
			menu:AddOption('Снять', function()
				LocalPlayer():PS_HolsterItem(self.Data.ID)
			end)
		else
			menu:AddOption('Надеть', function()
				LocalPlayer():PS_EquipItem(self.Data.ID)
			end)
		end

		if LocalPlayer():PS_HasItemEquipped(self.Data.ID) and self.Data.Modify then
			menu:AddSpacer()

			menu:AddOption('Изменить...', function()
				PS.Items[self.Data.ID]:Modify(LocalPlayer().PS_Items[self.Data.ID].Modifiers)
			end)
		end
	end

	menu:Open()
end

function PANEL:SetData(data)
	self.Data = data
	self.Info = data.Name
	self.Price = data.Price
	self.For = data.For

	if data.Model then
		local DModelPanel = vgui.Create('DModelPanel', self)
		DModelPanel:SetModel(data.Model)

		DModelPanel:Dock(TOP)
		DModelPanel:SetTall( 210 )

		if data.Skin then
			DModelPanel.Entity:SetSkin(data.Skin)
		end

		local PrevMins, PrevMaxs = DModelPanel.Entity:GetRenderBounds()
		PrevMaxs.z = PrevMins.z
		local campos = PrevMins:Distance(PrevMaxs) * Vector(2, 2, 2)
		campos.z = campos.z * 0.5
		local CATEGORY = PS:FindCategoryByName( PS.Items[data.ID].Category )
		DModelPanel:SetCamPos(campos)
		local lookAt = (PrevMaxs + PrevMins) / 2
		lookAt.z = lookAt.z * 0.5
		if CATEGORY.CamLookOffset then lookAt = lookAt + CATEGORY.CamLookOffset end
		DModelPanel:SetLookAt(lookAt)
		DModelPanel:SetFOV( CATEGORY.CamFOV or 30 )

		local ang = CATEGORY.ItemAngle or Angle()
		function DModelPanel:LayoutEntity(ent)
			if self:GetParent().Hovered then
				ent:SetAngles(Angle(0, ent:GetAngles().y + 60 * FrameTime(), 0))
			else
				ent:SetAngles(ang)
			end

			local ITEM = PS.Items[data.ID]

			ITEM:ModifyClientsideModel(LocalPlayer(), ent, Vector(), Angle())
		end

		function DModelPanel:DoClick()
			self:GetParent():DoClick()
		end

		function DModelPanel:OnCursorEntered()
			self:GetParent():OnCursorEntered()
		end

		function DModelPanel:OnCursorExited()
			self:GetParent():OnCursorExited()
		end

		local oldDraw = DModelPanel.Paint
		function DModelPanel:Paint( w, h )
			draw.RoundedBox( 0, 0, 0, w, h, Color(200,216,222) )
			for i=1,8 do
				draw.RoundedBox( 0, 0, h-(8-i)*2, w, 2, Color(0,33,46,i*i*2) )
			end
			oldDraw( self, w, h )
		end

	else
		local DImageButton = vgui.Create('DImageButton', self)
		DImageButton:SetMaterial(data.Material)
		DImageButton.m_Image.FrameTime = 0

		DImageButton:Dock(TOP)
		DImageButton:SetTall( 210 )

		function DImageButton:DoClick()
			self:GetParent():DoClick()
		end

		function DImageButton:OnCursorEntered()
			self:GetParent():OnCursorEntered()
		end

		function DImageButton:OnCursorExited()
			self:GetParent():OnCursorExited()
		end

		function DImageButton.m_Image:Paint(w, h)
			draw.RoundedBox( 0, 0, 0, w, h, Color(200,216,222) )

			if not self:GetParent():GetParent().Data.NoScroll and self:GetParent():GetParent().Hovered then
				self.FrameTime = self.FrameTime + 1
			end

			self:PaintAt( 0, self.FrameTime % self:GetTall() - self:GetTall() , self:GetWide(), self:GetTall() )
			self:PaintAt( 0, self.FrameTime % self:GetTall(), 					self:GetWide(), self:GetTall() )

			for i=1,8 do
				draw.RoundedBox( 0, 0, h-(8-i)*2, w, 2, Color(0,33,46,i*i*2) )
			end
		end
	end

	if data.Description then
		self:SetTooltip(data.Description)
	end
end

function PANEL:Paint( w, h )

	-- if self:IsHovered() or self:IsChildHovered() then
	-- 	draw.RoundedBox( 0, 0, 0, w, h, Color(200,200,200, 255) )
	-- else
		draw.RoundedBox( 0, 0, 0, w, h, Color(235,235,235, 255) )
	-- end

end

local icons = {
	have = Material( "icon16/tick.png" ),
}

function PANEL:PaintOver()
	if self.Data.AdminOnly then
		surface.SetMaterial(adminicon)
		surface.SetDrawColor(Color(255, 255, 255, 255))
		surface.DrawTexturedRect(5, 5, 16, 16)
	end

	if LocalPlayer():PS_HasItemEquipped(self.Data.ID) then
		surface.SetMaterial(equippedicon)
		surface.SetDrawColor(Color(255, 255, 255, 255))
		surface.DrawTexturedRect(self:GetWide() - 5 - 16, 5, 16, 16)
	end

	if self.Data.AllowedUserGroups and #self.Data.AllowedUserGroups > 0 then
		surface.SetMaterial(groupicon)
		surface.SetDrawColor(Color(255, 255, 255, 255))
		surface.DrawTexturedRect(5, self:GetTall() - self.InfoHeight - 5 - 16, 16, 16)
	end

	local points = PS.Config.CalculateBuyPrice(LocalPlayer(), self.Data)

	if LocalPlayer():PS_HasPoints(points) then
		self.BarColor = canbuycolor
	else
		self.BarColor = cantbuycolor
	end

	if LocalPlayer():PS_HasItem(self.Data.ID) then
		self.BarColor = canbuycolor
		surface.SetMaterial( icons.have )
		surface.SetDrawColor( Color(255,255,255) )
		surface.DrawTexturedRect( self:GetWide() - 26, self:GetTall() - 26, 16, 16 )
	end

	local tcol = Color( self.BarColor.r, self.BarColor.g, self.BarColor.b, 255 )
	if self:IsHovered() or self:IsChildHovered() then
		-- tcol.a = 255
	end

	-- surface.SetDrawColor(self.BarColor)
	-- surface.DrawRect(0, self:GetTall() - self.InfoHeight, self:GetWide(), self.InfoHeight)

	-- if self.For then
	-- 	draw.SimpleText(self.Info, "PS_ItemName", 10, 225, tcol, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
	-- 	draw.SimpleText(self.For, "PS_ItemFor", 70, self:GetTall() / 2 + 8, tcol, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
	-- else
		draw.SimpleText(self.Info, "PS_ItemName", 10, 225, tcol, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
		draw.SimpleText(self.Price .. PS.Config.PointsName, "PS_ItemPrice", 10, 255, tcol, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
	-- end

	if LocalPlayer().PS_Items and LocalPlayer().PS_Items[self.Data.ID] and LocalPlayer().PS_Items[self.Data.ID].Modifiers and LocalPlayer().PS_Items[self.Data.ID].Modifiers.color then
		surface.SetDrawColor(LocalPlayer().PS_Items[self.Data.ID].Modifiers.color)
		surface.DrawRect(self:GetWide() - 5 - 16, 26, 16, 16)
	end
end

local function IsAvailableItem(item, ply)
	item = PS.Items[item]
	if item and item.Slots then
		for k,v in pairs(item.Slots) do
			for slot, id in pairs(ply.PS_Slots) do
				if v == slot then
					if id == "_job" then return false end
				end
			end
		end
	end
	return true
end

function PANEL:OnCursorEntered()
	self.Hovered = true

	-- if LocalPlayer():PS_HasItem(self.Data.ID) then
	-- 	self.Price = '+' .. PS.Config.CalculateSellPrice(LocalPlayer(), self.Data)
	-- else
	-- 	self.Price = '-' .. PS.Config.CalculateBuyPrice(LocalPlayer(), self.Data)
	-- end
	self.For = nil

	if IsAvailableItem(self.Data.ID, LocalPlayer()) then
		PS:SetHoverItem(self.Data.ID)
	end
end

function PANEL:OnCursorExited()
	self.Hovered = false
	-- self.Price = self.Data.Price
	self.For = self.Data.For

	PS:RemoveHoverItem()
end

vgui.Register('DPointShopItem', PANEL, 'DPanel')
