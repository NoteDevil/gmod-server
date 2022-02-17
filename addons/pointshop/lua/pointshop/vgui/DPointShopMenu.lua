surface.CreateFont('PS_Heading', { font = 'Arial', extended = true, size = 64, weight = 500 })
surface.CreateFont('PS_Heading2', { font = 'Arial', extended = true, size = 24, weight = 500 })
surface.CreateFont('PS_Heading3', { font = 'Arial', extended = true, size = 21, weight = 500 })

surface.CreateFont( "PS_Default", {
	font = system.IsLinux() and "Arial" or "Tahoma",
	extended = true,
	size = 13, weight = 500, antialias = true,
})

surface.CreateFont( "PS_DefaultBold", {
	font = system.IsLinux() and "Arial" or "Tahoma",
	extended = true,
	size = 13, weight = 800, antialias = true,
})

surface.CreateFont( "PS_Heading1", {
	font = system.IsLinux() and "Arial" or "Tahoma",
	extended = true,
	size = 18, weight = 500, antialias = true,
})

surface.CreateFont( "PS_Heading1Bold", {
	font = system.IsLinux() and "Arial" or "Tahoma",
	extended = true,
	size = 18, weight = 800, antialias = true,
})

surface.CreateFont( "PS_ButtonText1", {
	font = "ARIAL",
	extended = true,
	size = 20, weight = 700, antialias = true,
})

surface.CreateFont( "PS_ItemText", {
	font = system.IsLinux() and "Arial" or "Tahoma",
	extended = true,
	size = 11, weight = 500, antialias = true,
})

surface.CreateFont( "PS_LargeTitle", {
	font = "Roboto",
	extended = true,
	size = 32, weight = 500, antialias = true,
})

local ALL_ITEMS = 1
local OWNED_ITEMS = 2
local UNOWNED_ITEMS = 3

local BGColor1 = Color(120, 120, 120, 255)
local BGColor2 = Color(40, 40, 40)
local BGColor3 = Color(57, 56, 54)

local function BuildItemMenu(menu, ply, itemstype, callback)
	local plyitems = ply:PS_GetItems()

	for category_id, CATEGORY in pairs(PS.Categories) do

		local catmenu = menu:AddSubMenu(CATEGORY.Name)

		table.SortByMember(PS.Items, PS.Config.SortItemsBy, function(a, b) return a > b end)

		for item_id, ITEM in pairs(PS.Items) do
			if ITEM.Category == CATEGORY.Name then
				if itemstype == ALL_ITEMS or (itemstype == OWNED_ITEMS and plyitems[item_id]) or (itemstype == UNOWNED_ITEMS and not plyitems[item_id]) then
					catmenu:AddOption(ITEM.Name, function() callback(item_id) end)
				end
			end
		end
	end
end

local PANEL = {}

local icons = {
	refresh = Material( "icon16/arrow_refresh.png" ),
	give = Material( "icon16/user_go.png" ),
	donate = Material( "icon16/money_add.png" ),
}

function PANEL:Init()
	self:SetSize( math.min( 1024, ScrW() ), math.min( 768, ScrH() ) )
	self:SetPos((ScrW() / 2) - (self:GetWide() / 2), (ScrH() / 2) - (self:GetTall() / 2))

	-- close button
	local closeButton = vgui.Create('DButton', self)
	closeButton:SetFont('marlett')
	closeButton:SetText('r')
	closeButton:SetColor(Color(255, 255, 255))
	closeButton:SetSize(32, 32)
	closeButton:SetPos(self:GetWide() - 40, 8)
	closeButton.DoClick = function()
		PS:ToggleMenu()
	end
	closeButton.Paint = function( self, w, h )
		if self.Hovered then
			draw.RoundedBoxEx( 4, 0, 0, w, h, Color( 103,82,74 ), false, true, false, true )
		else
			draw.RoundedBoxEx( 4, 0, 0, w, h, Color( 32,36,40 ), false, true, false, true )
		end
	end

	-- refresh button
	local refreshButton = vgui.Create('DButton', self)
	refreshButton:SetText('')
	-- refreshButton:SetImage('icon16/arrow_refresh.png')
	refreshButton:SetTextInset( 0, 0 )
	refreshButton:SetColor(Color(255, 255, 255))
	refreshButton:SetSize(125, 32)
	refreshButton:SetPos(self:GetWide() - 385, 8)
	refreshButton.DoClick = function( self )
		RunConsoleCommand( "ps_reload" )
	end
	refreshButton.Paint = function( self, w, h )
		if self.Hovered then
			draw.RoundedBoxEx( 4, 0, 0, w, h, Color(43,62,66), true, false, true, false )
		else
			draw.RoundedBoxEx( 4, 0, 0, w, h, Color(32,36,40), true, false, true, false )
		end
		draw.RoundedBox( 0, w-1, 0, 1, h, Color(43,62,66, 150) )

		surface.SetMaterial( icons.refresh )
		surface.SetDrawColor( Color(255,255,255) )
		surface.DrawTexturedRect( h/2 - 8, h/2 - 8, 16, 16 )

		draw.SimpleText( "Обновить", "PS_ButtonText1", h, h/2, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
	end
	refreshButton.UpdateColours = function(pnl)
		if pnl.Hovered then return pnl:SetTextColor(Color(255, 255, 255, 255)) end
		pnl:SetTextColor(Color(150, 150, 150, 255))
	end

	-- donate button
	local giveButton = vgui.Create('DButton', self)
	giveButton:SetText('')
	-- giveButton:SetImage('icon16/money_add.png')
	giveButton:SetTextInset( 0, 0 )
	giveButton:SetColor(Color(255, 255, 255))
	giveButton:SetSize(120, 32)
	giveButton:SetPos(self:GetWide() - 260, 8)
	giveButton.DoClick = function( self )
		vgui.Create('DPointShopGivePoints')
	end
	giveButton.Paint = function( self, w, h )
		if self.Hovered then
			draw.RoundedBox( 0, 0, 0, w, h, Color(43,62,66) )
		else
			draw.RoundedBox( 0, 0, 0, w, h, Color(32,36,40) )
		end
		draw.RoundedBox( 0, w-1, 0, 1, h, Color(43,62,66, 150) )

		surface.SetMaterial( icons.give )
		surface.SetDrawColor( Color(255,255,255) )
		surface.DrawTexturedRect( h/2 - 8, h/2 - 8, 16, 16 )

		draw.SimpleText( "Передать", "PS_ButtonText1", h, h/2, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
	end
	giveButton.UpdateColours = function(pnl)
		if pnl.Hovered then return pnl:SetTextColor(Color(255, 255, 255, 255)) end
		pnl:SetTextColor(Color(150, 150, 150, 255))
	end

	-- donate button
	local donateButton = vgui.Create('DButton', self)
	donateButton:SetText('')
	-- donateButton:SetImage('icon16/money_add.png')
	donateButton:SetTextInset( 0, 0 )
	donateButton:SetColor(Color(255, 255, 255))
	donateButton:SetSize(100, 32)
	donateButton:SetPos(self:GetWide() - 140, 8)
	donateButton.DoClick = function( self )
		PS.Config.DonateButtonPressed()
	end
	donateButton.Paint = function( self, w, h )
		if self.Hovered then
			draw.RoundedBox( 0, 0, 0, w, h, Color(43,62,66) )
		else
			draw.RoundedBox( 0, 0, 0, w, h, Color(32,36,40) )
		end
		draw.RoundedBox( 0, w-1, 0, 1, h, Color(43,62,66, 150) )

		surface.SetMaterial( icons.donate )
		surface.SetDrawColor( Color(255,255,255) )
		surface.DrawTexturedRect( h/2 - 8, h/2 - 8, 16, 16 )

		draw.SimpleText( "Купить", "PS_ButtonText1", h, h/2, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
	end
	donateButton.UpdateColours = function(pnl)
		if pnl.Hovered then return pnl:SetTextColor(Color(255, 255, 255, 255)) end
		pnl:SetTextColor(Color(150, 150, 150, 255))
	end

	local buttonContainer = vgui.Create("DPanel", self)
	buttonContainer:SetTall(28)
	buttonContainer:Dock(TOP)
	buttonContainer:DockMargin(0, 48, 0, 0)
	buttonContainer.Paint = function( self, w, h )
		draw.RoundedBox( 0, 0, 0, w, h, Color(83,104,112) )
	end

	local container = vgui.Create("DPanel", self)

	if PS.Config.DisplayPreviewInMenu then
		container:DockMargin(0, 0, 320, 0)
	else
		container:DockMargin(0, 0, 0, 0)
	end
	container:Dock(FILL)

	container:SetSize(self:GetWide() - 60, self:GetTall() - 150)
	container:SetPos((self:GetWide() / 2) - (container:GetWide() / 2), 120)
	container.Paint = function( self, w, h ) end

	local btns = {}
	local firstBtn = true
	local function createBtn(text, material, panel, align, description, angle, pos)
		panel:SetParent(container)
		panel:Dock(FILL)
		panel.Paint = function(pnl, w, h)
			-- draw.RoundedBox( 0, 0, 0, w, h, Color( 120,120,120, 20 ) )
		end

		if firstBtn then
			panel:SetZPos(100)
			panel:SetVisible(true)
		else
			panel:SetZPos(1)
			panel:SetVisible(false)
		end

		local btn = vgui.Create("DButton", buttonContainer)
		btn:Dock(align or LEFT)
		btn:SetText(text)
		btn:SetFont("DermaDefault")
		btn:SetImage(material)
		if description and description ~= '' then
			btn:SetToolTip(description)
		end

		btn.Paint = function(pnl, w, h)
			if pnl:GetActive() then
				draw.RoundedBox( 0, 0, 0, w, h, Color(32,36,40) )
			-- elseif pnl:IsHovered() then
			-- 	draw.RoundedBox( 0, 0, 0, w, h, Color(43,62,66) )
			end
		end
		btn.UpdateColours = function(pnl)
			if pnl:GetActive() then return pnl:SetTextColor(Color(255, 255, 255)) end
			if pnl.Hovered then return pnl:SetTextColor(Color(255, 255, 255)) end
			pnl:SetTextColor(Color(220, 220, 220))
		end
		btn.PerformLayout = function(pnl)
			pnl:SizeToContents() pnl:SetWide(pnl:GetWide() + 12) pnl:SetTall( pnl:GetParent():GetTall() ) DLabel.PerformLayout(pnl)

			pnl.m_Image:SetSize(16, 16)
			pnl.m_Image:SetPos( 8, (pnl:GetTall() - pnl.m_Image:GetTall()) * 0.5 )
			pnl:SetContentAlignment(4)
			pnl:SetTextInset( pnl.m_Image:GetWide() + 16, 0 )
		end

		btn.GetActive = function(pnl) return pnl.Active or false end
		btn.SetActive = function(pnl, state) pnl.Active = state end

		if firstBtn then
			firstBtn = false;
			btn:SetActive(true)
			PS.customAngle = angle
			PS.customPos = pos
			PS.curCategory = text
		end

		btn.DoClick = function(pnl)
			for k, v in pairs(btns) do v:SetActive(false) v:OnDeactivate() end
			pnl:SetActive(true) pnl:OnActivate()
			PS.customAngle = angle
			PS.customPos = pos
			PS.curCategory = text
		end

		btn.OnDeactivate = function()
			panel:SetVisible(false)
			panel:SetZPos(1)
		end
		btn.OnActivate = function()
			panel:SetVisible(true)
			panel:SetZPos(100)
		end

		table.insert(btns, btn)

		return btn
	end

	-- sorting
	local categories = {}

	for _, i in pairs(PS.Categories) do
		table.insert(categories, i)
	end

	table.sort(categories, function(a, b)
		if a.Order == b.Order then
			return a.Name < b.Name
		else
			return a.Order < b.Order
		end
	end)

	local items = {}

	for _, i in pairs(PS.Items) do
		table.insert(items, i)
	end

	table.SortByMember(items, PS.Config.SortItemsBy, function(a, b) return a > b end)

	-- ready for the worst sorting ever??

	local tbl1 = {}
	local tbl2 = {}
	local tbl3 = {}

	for _, i in pairs(items) do
		local points = PS.Config.CalculateBuyPrice(LocalPlayer(), i)
		if i.Hidden and not LocalPlayer():PS_HasItem(i.ID) then continue end
		if 		( LocalPlayer():PS_HasItem(i.ID) ) then table.insert(tbl1, i)
		elseif	( LocalPlayer():PS_HasPoints(points) ) then table.insert(tbl2, i)
		else	table.insert(tbl3, i) end
	end

	items = {}

	for _, i in pairs(tbl1) do table.insert(items, i) end
	for _, i in pairs(tbl2) do table.insert(items, i) end
	for _, i in pairs(tbl3) do table.insert(items, i) end

	-- items
	for _, CATEGORY in pairs(categories) do
		if CATEGORY.AllowedUserGroups and #CATEGORY.AllowedUserGroups > 0 then
			if not table.HasValue(CATEGORY.AllowedUserGroups, LocalPlayer():PS_GetUsergroup()) then
				continue
			end
		end

		if CATEGORY.CanPlayerSee then
			if not CATEGORY:CanPlayerSee(LocalPlayer()) then
				continue
			end
		end

		--Allow addons to create custom Category display types
 		local ShopCategoryTab = hook.Run( "PS_CustomCategoryTab", CATEGORY )
		if IsValid( ShopCategoryTab ) then
			createBtn(CATEGORY.Name, 'icon16/' .. CATEGORY.Icon .. '.png', ShopCategoryTab, nil, CATEGORY.Description, CATEGORY.CustomAngle, CATEGORY.CustomPos)
			continue
		else
			ShopCategoryTab = vgui.Create('DPanel')
			ShopCategoryTab.Paint = function( self, w, h ) end
		end

		local DScrollPanel = vgui.Create('DScrollPanel', ShopCategoryTab)
		DScrollPanel:Dock( FILL )

		local ShopCategoryTabLayout = vgui.Create('DIconLayout', DScrollPanel)
		ShopCategoryTabLayout:Dock(FILL)
		ShopCategoryTabLayout:SetBorder(8)
		ShopCategoryTabLayout:SetSpaceX(15)
		ShopCategoryTabLayout:SetSpaceY(15)

		local oldLayout = ShopCategoryTabLayout.PerformLayout
		function ShopCategoryTabLayout.PerformLayout( self )
			oldLayout( self )
			self:SetTall( self:GetTall() + self:GetBorder() )
		end

		DScrollPanel:AddItem(ShopCategoryTabLayout)

		for _, ITEM in pairs(items) do
			if ITEM.Category == CATEGORY.Name then
				local model = vgui.Create('DPointShopItem')
				model:SetData(ITEM)
				model:SetSize( 210, 280 )

				ShopCategoryTabLayout:Add(model)
			end
		end

		local vbar = DScrollPanel:GetVBar()
		vbar.Paint = function( self, w, h )
			-- draw.RoundedBox( 0, 0, 0, w, h, Color( 120,120,120, 20 ) )
		end
		vbar.btnGrip.Paint = function( self, w, h )
			local extend = vbar:IsChildHovered() or self.Depressed
			draw.RoundedBox( extend and 4 or 2, extend and 0 or w/2-2, 0, extend and w or 4, h, Color(83,104,112) )
		end
		vbar.btnUp.Paint = function( self, w, h )
			-- local extend = vbar:IsChildHovered()
			-- draw.RoundedBox( 0, extend and 0 or w/2-1, 0, extend and w or 2, h, Color( 120,120,120, 30 ) )
		end
		vbar.btnDown.Paint = function( self, w, h )
			-- local extend = vbar:IsChildHovered()
			-- draw.RoundedBox( 0, extend and 0 or w/2-1, 0, extend and w or 2, h, Color( 120,120,120, 30 ) )
		end

		if CATEGORY.ModifyTab then
			CATEGORY:ModifyTab(ShopCategoryTab)
		end

		createBtn(CATEGORY.Name, 'icon16/' .. CATEGORY.Icon .. '.png', ShopCategoryTab, nil, CATEGORY.Description, CATEGORY.CustomAngle, CATEGORY.CustomPos)
	end

	if (PS.Config.AdminCanAccessAdminTab and LocalPlayer():IsAdmin()) or (PS.Config.SuperAdminCanAccessAdminTab and LocalPlayer():IsSuperAdmin()) then
		-- admin tab
		local AdminTab = vgui.Create('DPanel')
		AdminTab.Paint = function( self, w, h ) end

		local ClientsList = vgui.Create('DListView', AdminTab)
		ClientsList:DockMargin(10, 10, 10, 10)
		ClientsList:Dock(FILL)

		ClientsList:SetMultiSelect(false)
		ClientsList:AddColumn('Name')
		ClientsList:AddColumn('Points'):SetFixedWidth(60)
		ClientsList:AddColumn('Items'):SetFixedWidth(60)

		ClientsList.OnClickLine = function(parent, line, selected)
			local ply = line.Player

			local menu = DermaMenu()

			menu:AddOption('Установить '..PS.Config.PointsName..'...', function()
				Derma_StringRequest(
					"Установить "..PS.Config.PointsName.." для " .. ply:GetName(),
					"Установить "..PS.Config.PointsName.." на...",
					"",
					function(str)
						if not str or not tonumber(str) then return end

						net.Start('PS_SetPoints')
							net.WriteEntity(ply)
							net.WriteInt(tonumber(str), 32)
						net.SendToServer()
					end
				)
			end)

			menu:AddOption('Дать '..PS.Config.PointsName..'...', function()
				Derma_StringRequest(
					"Дать "..PS.Config.PointsName.. ply:GetName(),
					"Дать "..PS.Config.PointsName.."...",
					"",
					function(str)
						if not str or not tonumber(str) then return end

						net.Start('PS_GivePoints')
							net.WriteEntity(ply)
							net.WriteInt(tonumber(str), 32)
						net.SendToServer()
					end
				)
			end)

			menu:AddOption('Забрать '..PS.Config.PointsName..'...', function()
				Derma_StringRequest(
					"Забрать "..PS.Config.PointsName.." у " .. ply:GetName(),
					"Забрать "..PS.Config.PointsName.."...",
					"",
					function(str)
						if not str or not tonumber(str) then return end

						net.Start('PS_TakePoints')
							net.WriteEntity(ply)
							net.WriteInt(tonumber(str), 32)
						net.SendToServer()
					end
				)
			end)

			menu:AddSpacer()

			BuildItemMenu(menu:AddSubMenu('Дать предмет'), ply, UNOWNED_ITEMS, function(item_id)
				net.Start('PS_GiveItem')
					net.WriteEntity(ply)
					net.WriteString(item_id)
				net.SendToServer()
			end)

			BuildItemMenu(menu:AddSubMenu('Забрать предмет'), ply, OWNED_ITEMS, function(item_id)
				net.Start('PS_TakeItem')
					net.WriteEntity(ply)
					net.WriteString(item_id)
				net.SendToServer()
			end)

			menu:Open()
		end

		self.ClientsList = ClientsList

		createBtn("Admin", 'icon16/shield.png', AdminTab, RIGHT)
	end

	-- preview panel

	local preview
	if PS.Config.DisplayPreviewInMenu then
		preview = vgui.Create('DPanel', self)
		preview.Paint = function( self, w, h ) end

		preview:DockMargin(self:GetWide() - 320, 0, 0, 0)
		preview:Dock(FILL)

		local previewpanel = vgui.Create('DPointShopPreview', preview)
		previewpanel:Dock(FILL)

		--- Drag Rotate
		previewpanel.Angles = Angle( 0, 0, 0 )
		previewpanel.Pos = Vector( 0, 0, -10 )

		function previewpanel:DragMousePress()
			self.PressX, self.PressY = gui.MousePos()
			self.Pressed = true
		end

		function previewpanel:DragMouseRelease()
			self.Pressed = false
			self.lastPressed = RealTime()
		end

		function previewpanel:LayoutEntity( thisEntity )
			if ( self.bAnimated ) then self:RunAnimation() end

			if ( self.Pressed ) then
				local mx, my = gui.MousePos()
				self.Angles = self.Angles - Angle( 0, ( self.PressX or mx ) - mx, 0 )
				self.Pos = self.Pos + Vector( 0, 0, ((self.PressY or my) - my) / 10 )
				self.PressX, self.PressY = gui.MousePos()
			end

			if PS.customPos then
				thisEntity:SetPos( PS.customPos )
			else
				thisEntity:SetPos( Vector() )
			end

			if PS.HoverModel then
				local ITEM = PS.Items[PS.HoverModel]
				if ITEM.CustomPos then
					thisEntity:SetPos( ITEM.CustomPos )
				end
			end

			-- if ( RealTime() - ( self.lastPressed or 0 ) ) < 4 or self.Pressed then
				thisEntity:SetAngles( self.Angles )
				thisEntity:SetPos( self.Pos )
			-- else
			-- 	if PS.customAngle then
			-- 		self.Angles.y = PS.customAngle
			-- 	else
			-- 		self.Angles.y = math.NormalizeAngle(self.Angles.y + (RealFrameTime() * 21))
			-- 	end
			-- 	thisEntity:SetAngles( Angle( 0, self.Angles.y ,  0) )
			-- end

		end

	end

	-- give points button

	-- if PS.Config.CanPlayersGivePoints then
	-- 	local givebutton = vgui.Create('DButton', preview or self)
	-- 	givebutton:SetText("Передать "..PS.Config.PointsName)
	-- 	givebutton:SetImage('icon16/user_go.png')
	-- 	givebutton:SetSize( 100, 30 )
	-- 	if PS.Config.DisplayPreviewInMenu then
	-- 		givebutton:DockMargin(8, 8, 8, 8)
	-- 	else
	-- 		givebutton:DockMargin(8, 0, 8, 8)
	-- 	end
	-- 	function givebutton:PerformLayout()
	-- 		givebutton:AlignBottom()
	-- 		givebutton:CenterHorizontal()
	-- 	end
	-- 	givebutton.DoClick = function()
	-- 		vgui.Create('DPointShopGivePoints')
	-- 	end
	-- 	givebutton.Paint = function(pnl, w, h)
	-- 		if pnl:IsHovered() then
	-- 			draw.RoundedBox( 0, 0, 0, w, h, Color(120,120,120, 30) )
	-- 		end
	-- 	end
	-- 	givebutton.UpdateColours = function(pnl)
	-- 		if pnl.Hovered then return pnl:SetTextColor(Color(255, 255, 255, 255)) end
	-- 		pnl:SetTextColor(Color(220, 220, 220, 255))
	-- 	end
	-- end
end

function PANEL:Think()
	if self.ClientsList then
		local lines = self.ClientsList:GetLines()

		for _, ply in pairs(player.GetAll()) do
			local found = false

			for _, line in pairs(lines) do
				if line.Player == ply then
					found = true
				end
			end

			if not found then
				self.ClientsList:AddLine(ply:GetName(), ply:PS_GetPoints(), table.Count(ply:PS_GetItems())).Player = ply
			end
		end

		for i, line in pairs(lines) do
			if IsValid(line.Player) then
				local ply = line.Player

				line:SetValue(1, ply:GetName())
				line:SetValue(2, ply:PS_GetPoints())
				line:SetValue(3, table.Count(ply:PS_GetItems()))
			else
				self.ClientsList:RemoveLine(i)
			end
		end
	end
end

local logo = Material( "school666/logo-transparent-512.png", "unlitgeneric noclamp smooth" )
function PANEL:Paint(w, h)
	surface.DisableClipping( true )
		local x, y = self:ScreenToLocal(0,0)
		draw.RoundedBox( 4, x-1, y-1, ScrW()+2, ScrH()+2, Color(32,36,40, 220) )

		draw.RoundedBox( 4, -1, -1, w+2, h+2, Color(83,104,112) )
		draw.RoundedBox( 4, 0, 0, w, h, Color(32,36,40) )
	surface.DisableClipping( false )

	draw.RoundedBoxEx( 4, -1, -1, w+2, 49, Color(83,104,112) )

	if PS.Config.CommunityName then
		surface.SetDrawColor(255,255,255)
		surface.SetMaterial(logo)
		surface.DrawTexturedRect( 140, -25, 96, 96 )
		draw.SimpleText(PS.Config.CommunityName, 'PS_LargeTitle', 15, 8, color_white)
	else
		draw.SimpleText("PointShop", 'PS_LargeTitle', 55, 8, color_white)
	end

	draw.SimpleText('У тебя есть ' .. LocalPlayer():PS_GetPoints() .. PS.Config.PointsName, 'PS_Heading3', self:GetWide() - 398, 24, color_white, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)

end

vgui.Register('DPointShopMenu', PANEL)
