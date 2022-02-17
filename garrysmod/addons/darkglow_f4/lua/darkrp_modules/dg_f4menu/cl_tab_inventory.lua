if !DGF4.RegisterButton then return end

local base

surface.CreateFont( "SRP_Inv.WeightFont", {
	font = "Roboto Bold",
	size = 18,
	weight = 500,
	extended = true,
})

surface.CreateFont( "SRP_Inv.NameFont", {
	font = "Roboto Bold",
	size = 32	,
	weight = 500,
	extended = true,
})

surface.CreateFont( "SRP_Inv.DescFont", {
	font = "Roboto Lt",
	size = 22	,
	weight = 500,
	extended = true,
})

local function GetItemName(item)
	local item_tbl = SRP_Inv:GetItem(item.type)
	return item_tbl.getPrintName and item_tbl.getPrintName(item) or item_tbl.name
end

local function GetItemModel(item)
	local item_tbl = SRP_Inv:GetItem(item.type)
	return item.data and item.data.model and item.data.model or item_tbl.model
end

local function GetItemColor(item)
	local item_tbl = SRP_Inv:GetItem(item.type)
	return item_tbl.color
end

local function GetItemDesc(item)
	local item_tbl = SRP_Inv:GetItem(item.type)
	return item_tbl.createDesc and item_tbl.createDesc(item) or item_tbl.desc
end

local inventory = {}
inventory.pos = 27
inventory.name = "Инвентарь"
inventory.col = Color(255,36,0)
inventory.wide = 400
inventory.callBack = function(self)
	base = DGF4.BaseElement(self, inventory.name, inventory.col, inventory.wide)
	local x, y, ply = ScrW(), ScrH(), LocalPlayer()

	base["ProgressBar"] = vgui.Create("DPanel", base)
	base["ProgressBar"]:SetSize(inventory.wide - 10, 25)
	base["ProgressBar"]:SetPos(5, 15)
	base["ProgressBar"].Paint = function(slf, w, h)
		draw.SRPBackGround(1, 0, 0, w, h)
		draw.SRPBackGround(1, 0, 0, w*(ply:GetInventoryWeight()/ply:InventoryLimit()), h, 150)
		draw.SimpleText(ply:GetInventoryWeight().." / "..ply:InventoryLimit().." kg", "SRP_Inv.WeightFont", w/2, h/2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end

	base["InvScrollPnl"] = vgui.Create("DScrollPanel", base)
	base["InvScrollPnl"]:SetSize(inventory.wide, y-55)
	base["InvScrollPnl"]:SetPos(0, 50)
	base["InvScrollPnl"].Paint = function(slf, w, h)
	end
	
	local vbar = base["InvScrollPnl"]:GetVBar()
	vbar.Paint = function( self, w, h )	end
	vbar.btnGrip.Paint = function( self, w, h )
		local extend = vbar:IsChildHovered() or self.Depressed
		draw.RoundedBox( extend and 4 or 2, extend and 0 or w/2-2, 0, extend and w or 4, h, Color(83,104,112) )
	end
	vbar.btnUp.Paint = function( self, w, h )	end
	vbar.btnDown.Paint = function( self, w, h )	end

	base["InvLayout"] = vgui.Create( "DIconLayout", base["InvScrollPnl"] )
	base["InvLayout"]:SetSize(base["InvScrollPnl"]:GetWide()-10, 0 )
	base["InvLayout"]:SetPos( 5, 5 )
	base["InvLayout"]:SetSpaceY( 10 )
	base["InvLayout"]:SetSpaceX( 5 )

	for k,v in pairs(ply:GetInventory()) do
		base["InvPanel"] = base["InvLayout"]:Add("DButton")
		base["InvPanel"]:SetSize(base["InvLayout"]:GetWide(), 70)
		base["InvPanel"]:SetText("")
		base["InvPanel"].Paint = function(slf, w, h)
			if slf:IsHovered() then
				draw.RoundedBox(3, 0, 0, w, h, Color(75, 75, 75, 180))
			else
				draw.RoundedBox(3, 0, 0, w, h, Color(0, 0, 0, 180))
			end
			draw.SimpleText(GetItemName(v), "SRP_Inv.NameFont", 10, 5, GetItemColor(v), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
			draw.SimpleText(GetItemDesc(v), "SRP_Inv.DescFont", 10, h-8, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM)
		end
		base["InvPanel"].DoClick = function(slf)
			local orly = vgui.Create("UPMenu", self)
			orly:AddOption("Выбросить", function()
				net.Start("SRP_Inv.SpawnItem")
				net.WriteInt(k,8)
				net.SendToServer()
				slf:Remove()
				orly:Remove()
			end)
			local show_use_button = true
			if SRP_Inv:GetItem(v.type).onUse then
				orly:AddOption("Использовать", function()
					net.Start("SRP_Inv.UseItem")
					net.WriteInt(k,8)
					net.SendToServer()
					orly:Remove()
					slf:Remove()
				end)
			end
			orly:AddOption("Отмена",function()
				orly:Remove()
			end)
			orly:Open()
		end

		base["InvModelPanel"] = vgui.Create( "DModelPanel", base["InvPanel"] )
		base["InvModelPanel"]:SetModel( GetItemModel(v) )
		base["InvModelPanel"]:SetSize(70,70)
		base["InvModelPanel"]:SetPos(base["InvPanel"]:GetWide() -70,0)
		base["InvModelPanel"]:SetFOV(20)
		base["InvModelPanel"]:SetLookAt(Vector(0, 0, 5))
	end
end 

DGF4:RegisterButton(inventory) -- Регистрация
