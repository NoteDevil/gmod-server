if !DGF4.RegisterButton then return end

local base
local x, y = ScrW(), ScrH()

local function canBuyFood(food)

    if (food.requiresCook == nil or food.requiresCook == true) and not LocalPlayer():isCook() then return false end
    if food.customCheck and not food.customCheck(LocalPlayer()) then return false end

    return true
end

local function IsAllowed(item)
	if istable(item.allowed) and
		not table.HasValue(item.allowed, LocalPlayer():Team()) then return false end

	return true
end

local function IsCustomCheck(item)
	if isfunction(item.customCheck) and not item.customCheck(LocalPlayer()) then return false end
	return true
end

local function IsEmptyCategory(items)
	for k,v in pairs(items) do
		if IsAllowed(v) then
			return false
		end
	end
	return true
end

local function IsEmptyTab(categories)
	for k,v in pairs(categories) do
		if not IsEmptyCategory(v.members) then
			return false
		end
	end
	return true
end

local function IsEmptyFoodTab(foods)
	for k,v in pairs(foods) do
		if canBuyFood(v) then
			return false
		end
	end
	return true
end

local function ShowTab(type_)
	if ValidPanel(base["entsScrollPanel"]) then base["entsScrollPanel"]:Remove() end
	if ValidPanel(base["foodScrollPanel"]) then base["foodScrollPanel"]:Remove() end
	base["entsScrollPanel"] = vgui.Create( "DScrollPanel", base )
	base["entsScrollPanel"]:SetSize( base:GetWide(), y - 70 )
	base["entsScrollPanel"]:SetPos( 5, 60 )

	local vbar = base["entsScrollPanel"]:GetVBar()
	vbar.Paint = function( self, w, h )	end
	vbar.btnGrip.Paint = function( self, w, h )
		local extend = vbar:IsChildHovered() or self.Depressed
		draw.RoundedBox( extend and 4 or 2, extend and 0 or w/2-2, 0, extend and w or 4, h, Color(83,104,112) )
	end
	vbar.btnUp.Paint = function( self, w, h )	end
	vbar.btnDown.Paint = function( self, w, h )	end

	base["entsLayout"] = vgui.Create( "DIconLayout", base["entsScrollPanel"] )
	base["entsLayout"]:SetSize(base["entsScrollPanel"]:GetWide(), base["entsScrollPanel"]:GetTall() )
	base["entsLayout"]:SetPos( 0, 0 )
	base["entsLayout"]:SetSpaceY( 5 )
	base["entsLayout"]:SetSpaceX( 5 )

	local tbl
	if type_ == "ents" then
		tbl = DarkRP.getCategories().entities
	elseif type_ == "weapons" then
		tbl = DarkRP.getCategories().weapons
	elseif type_ == "shipments" then
		tbl = DarkRP.getCategories().shipments
	elseif type_ == "ammo" then
		tbl = DarkRP.getCategories().ammo
	else
		tbl = DarkRP.getCategories().entities
	end

	for k,v in pairs(tbl) do
		if table.Count(v.members) == 0 then continue end
		if IsEmptyCategory(v.members) then continue end
		base["entsCatPanel"] = base["entsLayout"]:Add("DPanel")
		base["entsCatPanel"]:SetSize(base["entsLayout"]:GetWide() - 11, 60)
		base["entsCatPanel"].Paint = function(self, w, h)
			-- draw.RoundedBox( 2, 0, 0, w - 2, h - 2, Color( 0, 0, 0, 150 ) )
			local color = Color(v.color.r+70, v.color.g+70, v.color.b+70, v.color.a)
			draw.ShadowText(v.name, "EntPriceF4Menu", 10, h/2, color, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
		end
		for j,z in pairs(v.members) do
			if not IsAllowed(z) then continue end
			local price
			if type_ == "ents" then
				price = z.price
			elseif type_ == "weapons" then
				price = z.pricesep
			elseif type_ == "shipments" then
				price = z.price
			elseif type_ == "ammo" then
				price = z.price
			else
				price = z.price
			end

			base["entPanel"] = base["entsLayout"]:Add("DButton")
			base["entPanel"]:SetSize( base["entsLayout"]:GetWide() /2 - 7.5, 70 )
			base["entPanel"]:SetText("")
			base["entPanel"].Paint = function(self, w, h)
				draw.SimpleText(z.name, "JobsTitleF4Menu", 6, 3, Color(0,0,0), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
				if not IsCustomCheck(z) then
					draw.RoundedBox(3, 0, 0, w, h, Color(0, 0, 0, 100))
					draw.SimpleText(z.name, "JobsTitleF4Menu", 5, 2, Color(100, 100, 100), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
					draw.SimpleText(DGF4.Translation.unavailable, "EntPriceF4Menu", 5, h-5, Color(100, 100, 100), TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM)
				else
					if LocalPlayer():canAfford(price) then
						if self:IsHovered() then
							draw.RoundedBox(3, 0, 0, w, h, Color(75, 75, 75, 180))
						else
							draw.RoundedBox(3, 0, 0, w, h, Color(25, 25, 25, 180))
						end
						draw.SimpleText(z.name, "JobsTitleF4Menu", 5, 2, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
						draw.SimpleText(DarkRP.formatMoney(price), "EntPriceF4Menu_Glow", 5, h, Color(0, 133, 0, 200), TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM)
						draw.SimpleText(DarkRP.formatMoney(price), "EntPriceF4Menu", 5, h, Color(200, 200, 200), TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM)
					else
						draw.RoundedBox(3, 0, 0, w, h, Color(0, 0, 0, 100))
						draw.SimpleText(z.name, "JobsTitleF4Menu", 5, 2, Color(100, 100, 100), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
						draw.SimpleText(DarkRP.formatMoney(price), "EntPriceF4Menu", 5, h, Color(100, 100, 100), TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM)
					end
				end
			end
			base["entPanel"].DoClick = function()
				local orly = vgui.Create("UPMenu", self)
				orly:AddOption(DGF4.Translation.buy,function()
					if type_ == "ents" then
						RunConsoleCommand("DarkRP", z.cmd)
					elseif type_ == "weapons" then
						RunConsoleCommand("DarkRP", "buy", z.name)
					elseif type_ == "shipments" then
						RunConsoleCommand("DarkRP", "buyshipment", z.name)
					elseif type_ == "ammo" then
						RunConsoleCommand("DarkRP", "buyammo", z.ammoType)
					else
						RunConsoleCommand("DarkRP", z.cmd)
					end
					orly:Remove()
				end)
				orly:AddOption(DGF4.Translation.cancel,function()
					orly:Remove()
				end)
				orly:Open()
			end

			base["entModelPanel"] = vgui.Create( "DModelPanel", base["entPanel"] )
			base["entModelPanel"]:SetModel( z.model )
			base["entModelPanel"]:SetSize(70,70)
			base["entModelPanel"]:SetPos(base["entPanel"]:GetWide() -70,0)
			base["entModelPanel"]:SetFOV(30)
			base["entModelPanel"]:SetLookAt(Vector(0, 0, 5))
		end
	end
end

local function ShowFoodTab()
	if ValidPanel(base["entsScrollPanel"]) then base["entsScrollPanel"]:Remove() end
	if ValidPanel(base["foodScrollPanel"]) then base["foodScrollPanel"]:Remove() end
	base["foodScrollPanel"] = vgui.Create( "DScrollPanel", base )
	base["foodScrollPanel"]:SetSize( base:GetWide(), y - 65 )
	base["foodScrollPanel"]:SetPos( 5, 60 )
	base["foodScrollPanel"].VBar:SetWide(0)

	base["foodLayout"] = vgui.Create( "DIconLayout", base["foodScrollPanel"] )
	base["foodLayout"]:SetSize(base["foodScrollPanel"]:GetWide(), base["foodScrollPanel"]:GetTall() )
	base["foodLayout"]:SetPos( 0, 0 )
	base["foodLayout"]:SetSpaceY( 5 )
	base["foodLayout"]:SetSpaceX( 5 )

	for k,v in pairs(FoodItems) do
		if not canBuyFood(v) then continue end

		base["entPanel"] = base["foodLayout"]:Add("DButton")
		base["entPanel"]:SetSize( base["foodLayout"]:GetWide() /2 - 7.5, 70 )
		base["entPanel"]:SetText("")
		base["entPanel"].Paint = function(self, w, h)
			draw.SimpleText(v.name, "JobsTitleF4Menu", 6, 3, Color(0,0,0), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
				if LocalPlayer():canAfford(v.price) then
					if self:IsHovered() then
						draw.RoundedBox(3, 0, 0, w, h, Color(75, 75, 75, 180))
					else
						draw.RoundedBox(3, 0, 0, w, h, Color(0, 0, 0, 180))
					end
					draw.SimpleText(v.name.."(+"..v.energy..")", "JobsTitleF4Menu", 5, 2, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
					draw.SimpleText(DarkRP.formatMoney(v.price), "EntPriceF4Menu_Glow", 5, h, Color(0, 133, 0, 200), TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM)
					draw.SimpleText(DarkRP.formatMoney(v.price), "EntPriceF4Menu", 5, h, Color(200, 200, 200), TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM)
				else
					draw.RoundedBox(3, 0, 0, w, h, Color(0, 0, 0, 100))
					draw.SimpleText(v.name.."(+"..v.energy..")", "JobsTitleF4Menu", 5, 2, Color(100, 100, 100), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
					draw.SimpleText(DarkRP.formatMoney(v.price), "EntPriceF4Menu", 5, h, Color(100, 100, 100), TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM)
				end
		end
		base["entPanel"].DoClick = function()
			local orly = vgui.Create("UPMenu", self)
			orly:AddOption(DGF4.Translation.buy,function()
				RunConsoleCommand("darkrp", "buyfood", v.name)
				orly:Remove()
			end)
			orly:AddOption(DGF4.Translation.cancel,function()
				orly:Remove()
			end)
			orly:Open()
		end

		base["entModelPanel"] = vgui.Create( "DModelPanel", base["entPanel"] )
		base["entModelPanel"]:SetModel( v.model )
		base["entModelPanel"]:SetSize(70,70)
		base["entModelPanel"]:SetPos(base["entPanel"]:GetWide() -70,0)
		base["entModelPanel"]:SetFOV(30)
		base["entModelPanel"]:SetLookAt(Vector(0, 0, 5))
	end
end

local shop = {}
shop.pos = 28
shop.name = DGF4.Translation.shop
shop.col = Color(255,36,0)
shop.wide = ScrW() - 400
shop.callBack = function(self)
	base = DGF4.BaseElement(self, shop.name, shop.col, shop.wide)

	base["listShopBtn"] = vgui.Create( "DIconLayout", base )
	base["listShopBtn"]:SetSize(shop.wide, 50 )
	base["listShopBtn"]:SetPos( 5, 5 )
	base["listShopBtn"]:SetSpaceY( 0 )
	base["listShopBtn"]:SetSpaceX( 5 )

	base["entsShopBtn"] = base["listShopBtn"]:Add("DButton")
	base["entsShopBtn"]:SetSize(base["listShopBtn"]:GetWide()/5 -6, 50)
	base["entsShopBtn"]:SetText("")
	base["entsShopBtn"].Paint = function(self, w, h)
		if self:GetDisabled() then
			draw.SimpleText( DGF4.Translation.entities, "ShopNavF4Menu", w/2, h/2, Color(150,150,150, 150), 1, 1 )
		else
			if self.Selected then
				draw.SimpleText( DGF4.Translation.entities, "ShopNavF4Menu_Glow", w/2, h/2, Color(100,150,255, 200), 1, 1 )
			elseif self:IsHovered() then
				draw.SimpleText( DGF4.Translation.entities, "ShopNavF4Menu_Glow", w/2, h/2, Color(255,255,255, 50), 1, 1 )
			end
			draw.SimpleText( DGF4.Translation.entities, "ShopNavF4Menu", w/2, h/2, Color(255,255,255, 150), 1, 1 )
		end
	end
	if IsEmptyTab(DarkRP.getCategories().entities) then
		base["entsShopBtn"]:SetDisabled(true)
	end
	base["entsShopBtn"].DoClick = function(self)
		for k,but in pairs( base["listShopBtn"]:GetChildren() ) do
			but.Selected = false
		end
		self.Selected = true
		ShowTab("entities")
	end
	base["entsShopBtn"].Selected = true
	ShowTab()

	base["weaponsShopBtn"] = base["listShopBtn"]:Add("DButton")
	base["weaponsShopBtn"]:SetSize(base["listShopBtn"]:GetWide()/5 -6, 50)
	base["weaponsShopBtn"]:SetText("")
	base["weaponsShopBtn"].Paint = function(self, w, h)
		if self:GetDisabled() then
			draw.SimpleText( DGF4.Translation.weapons, "ShopNavF4Menu", w/2, h/2, Color(150,150,150, 150), 1, 1 )
		else
			if self.Selected then
				draw.SimpleText( DGF4.Translation.weapons, "ShopNavF4Menu_Glow", w/2, h/2, Color(100,150,255, 200), 1, 1 )
			elseif self:IsHovered() then
				draw.SimpleText( DGF4.Translation.weapons, "ShopNavF4Menu_Glow", w/2, h/2, Color(255,255,255, 50), 1, 1 )
			end
			draw.SimpleText( DGF4.Translation.weapons, "ShopNavF4Menu", w/2, h/2, Color(255,255,255, 150), 1, 1 )
		end
	end
	if IsEmptyTab(DarkRP.getCategories().weapons) then
		base["weaponsShopBtn"]:SetDisabled(true)
	end
	base["weaponsShopBtn"].DoClick = function(self)
		for k,but in pairs( base["listShopBtn"]:GetChildren() ) do
			but.Selected = false
		end
		self.Selected = true
		ShowTab("weapons")
	end

	base["shipShopBtn"] = base["listShopBtn"]:Add("DButton")
	base["shipShopBtn"]:SetSize(base["listShopBtn"]:GetWide()/5 -6, 50)
	base["shipShopBtn"]:SetText("")
	base["shipShopBtn"].Paint = function(self, w, h)
		if self:GetDisabled() then
			draw.SimpleText( DGF4.Translation.shipments, "ShopNavF4Menu", w/2, h/2, Color(150,150,150, 150), 1, 1 )
		else
			if self.Selected then
				draw.SimpleText( DGF4.Translation.shipments, "ShopNavF4Menu_Glow", w/2, h/2, Color(100,150,255, 200), 1, 1 )
			elseif self:IsHovered() then
				draw.SimpleText( DGF4.Translation.shipments, "ShopNavF4Menu_Glow", w/2, h/2, Color(255,255,255, 50), 1, 1 )
			end
			draw.SimpleText( DGF4.Translation.shipments, "ShopNavF4Menu", w/2, h/2, Color(255,255,255, 150), 1, 1 )
		end
	end
	if IsEmptyTab(DarkRP.getCategories().shipments) then
		base["shipShopBtn"]:SetDisabled(true)
	end
	base["shipShopBtn"].DoClick = function(self)
		for k,but in pairs( base["listShopBtn"]:GetChildren() ) do
			but.Selected = false
		end
		self.Selected = true
		ShowTab("shipments")
	end

	base["ammoShopBtn"] = base["listShopBtn"]:Add("DButton")
	base["ammoShopBtn"]:SetSize(base["listShopBtn"]:GetWide()/5 -6, 50)
	base["ammoShopBtn"]:SetText("")
	base["ammoShopBtn"].Paint = function(self, w, h)
		if self:GetDisabled() then
			draw.SimpleText( DGF4.Translation.ammo, "ShopNavF4Menu", w/2, h/2, Color(150,150,150, 150), 1, 1 )
		else
			if self.Selected then
				draw.SimpleText( DGF4.Translation.ammo, "ShopNavF4Menu_Glow", w/2, h/2, Color(100,150,255, 200), 1, 1 )
			elseif self:IsHovered() then
				draw.SimpleText( DGF4.Translation.ammo, "ShopNavF4Menu_Glow", w/2, h/2, Color(255,255,255, 50), 1, 1 )
			end
			draw.SimpleText( DGF4.Translation.ammo, "ShopNavF4Menu", w/2, h/2, Color(255,255,255, 150), 1, 1 )
		end
	end
	if IsEmptyTab(DarkRP.getCategories().ammo) then
		base["ammoShopBtn"]:SetDisabled(true)
	end
	base["ammoShopBtn"].DoClick = function(self)
		for k,but in pairs( base["listShopBtn"]:GetChildren() ) do
			but.Selected = false
		end
		self.Selected = true
		ShowTab("ammo")
	end

	if not FoodItems then return end

	base["foodShopBtn"] = base["listShopBtn"]:Add("DButton")
	base["foodShopBtn"]:SetSize(base["listShopBtn"]:GetWide()/5 -6, 50)
	base["foodShopBtn"]:SetText("")
	base["foodShopBtn"].Paint = function(self, w, h)
			if self:GetDisabled() then
			draw.SimpleText( DGF4.Translation.food, "ShopNavF4Menu", w/2, h/2, Color(150,150,150, 150), 1, 1 )
		else
			if self.Selected then
				draw.SimpleText( DGF4.Translation.food, "ShopNavF4Menu_Glow", w/2, h/2, Color(100,150,255, 200), 1, 1 )
			elseif self:IsHovered() then
				draw.SimpleText( DGF4.Translation.food, "ShopNavF4Menu_Glow", w/2, h/2, Color(255,255,255, 50), 1, 1 )
			end
			draw.SimpleText( DGF4.Translation.food, "ShopNavF4Menu", w/2, h/2, Color(255,255,255, 150), 1, 1 )
		end
	end
	if IsEmptyFoodTab(FoodItems) then
		base["foodShopBtn"]:SetDisabled(true)
	end
	base["foodShopBtn"].DoClick = function(self)
		for k,but in pairs( base["listShopBtn"]:GetChildren() ) do
			but.Selected = false
		end
		self.Selected = true
		ShowFoodTab()
	end

end

DGF4:RegisterButton(shop) -- Регистрация
