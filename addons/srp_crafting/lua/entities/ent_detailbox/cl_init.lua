include("shared.lua")

surface.CreateFont("SRP_DetailBox.NameFont", {
	font = "Roboto Bold",
	size = 22,
	weight = 500,
	extended = true,
})

surface.CreateFont("SRP_DetailBox.DescFont", {
	font = "Roboto Bold",
	size = 18,
	weight = 500,
	extended = true,
})

local function MakeInlineDesc(ent, recipe)
	local str = "Рецепт: "
	for k,v in pairs(recipe) do
		local has = ent:GetNWInt(k)
		if v > has then
			str = str..SRP_Crafting.Details[k]..": <color=200,50,50>x"..v.."</color>  "
		else
			str = str..SRP_Crafting.Details[k]..": <color=50,200,50>x"..v.."</color>  "
		end
	end
	return str
end

local function CanCraftRecipe(ent, recipe)
	local can_craft = true
	for k,v in pairs(recipe) do
		local has = ent:GetNWInt(k)
		if v > has then
			can_craft = false
		end
	end
	return can_craft
end

local function GetEntContentString(ent)
	local str = "\nВнутри: "
	local anything = false
	for k,v in pairs(SRP_Crafting.Details) do
		if ent:GetNWInt(k) > 0 then
			str = str..v..": <color=0,200,0>"..ent:GetNWInt(k).."</color>  "
			anything = true
		end
	end
	
	if anything then
		return str
	end

	return ""
end

net.Receive("SRP_DetailBox.OpenMenu", function()
	local ent = net.ReadEntity()
	

	local dframe = vgui.Create("DFrame")
	dframe:SetSize(800, 600)
	dframe:Center()
	dframe:SetTitle("Меню крафта")
	dframe:MakePopup()
	dframe.Paint = function(slf, w, h)
		draw.SRPBackGround(0, 0, 0, w, h)
		draw.SRPBackGround(0, 0, 0, w, 25,200)
	end

	dframe.scrpnl = vgui.Create("DScrollPanel", dframe)
	dframe.scrpnl:SetSize(dframe:GetWide()-20, dframe:GetTall()-45)
	dframe.scrpnl:SetPos(10, 35)
	dframe.scrpnl.VBar:SetWide(0)

	dframe.layout = vgui.Create("DIconLayout", dframe.scrpnl)
	dframe.layout:SetSize( dframe.scrpnl:GetWide(), dframe.scrpnl:GetTall())
	dframe.layout:SetPos( 0, 0 )
	dframe.layout:SetSpaceY( 5 )
	dframe.layout:SetSpaceX( 5 )

	dframe.infopanel = dframe.layout:Add("DPanel")
	dframe.infopanel:SetSize(dframe.layout:GetWide(), 50)
	dframe.infopanel.Paint = function(slf, w, h)
		draw.SRPBackGround(0, 0, 0, w, h)
		local markup_obj = markup.Parse("<font=SRP_DetailBox.DescFont>С помощью этого <color=50,200,50>ящика</color> можно крафтить различные предметы, <color=200,200,50>детали</color> можно найти копаясь в <color=200,150,50>мусорке</color>, <color=200,150,50>мусорки</color> находиться перед общежитием, удачи :)</font>", dframe.layout:GetWide()-50)
		markup_obj:Draw(5,5,TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
	end

	for k,v in pairs(SRP_Crafting.Recipes) do
		dframe.crpanel = dframe.layout:Add("DPanel")
		dframe.crpanel:SetSize(dframe.layout:GetWide(), 50)
		dframe.crpanel.Paint = function(slf, w, h)
			draw.SRPBackGround(0, 0, 0, w, h)
			draw.ShadowText(v.name, "SRP_DetailBox.NameFont", 55, 5, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
			local markup_obj = markup.Parse("<font=SRP_DetailBox.DescFont>"..MakeInlineDesc(ent, v.recipe).."</font>")
			markup_obj:Draw(55,25,TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
		end

		dframe.icon = vgui.Create("ModelImage", dframe.crpanel)
		dframe.icon:SetSize(50, 50)
		dframe.icon:SetPos(0,0)
		dframe.icon:SetModel(v.model)

		dframe.btn_craft = vgui.Create("DButton", dframe.crpanel)
		dframe.btn_craft:SetSize(100, 50)
		dframe.btn_craft:SetPos(dframe.crpanel:GetWide()-100, 0)
		dframe.btn_craft:SetText("")
		dframe.btn_craft.Paint = function(slf, w, h)
			if slf:IsHovered() and CanCraftRecipe(ent, v.recipe) then
				draw.SRPBackGround(0, 0, 0, w, h, 150)
				draw.ShadowText("Создать", "SRP_DetailBox.NameFont", w/2, h/2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			else
				draw.SRPBackGround(0, 0, 0, w, h)
				draw.ShadowText("Создать", "SRP_DetailBox.NameFont", w/2, h/2, Color(100,100,100), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			end
		end
		dframe.btn_craft.DoClick = function()
			if CanCraftRecipe(ent, v.recipe) then
				net.Start("SRP_DetailBox.Craft")
				net.WriteEntity(ent)
				net.WriteString(k)
				net.SendToServer()
			else
				notification.AddLegacy( "У вас не хватает ресурсов.", 1, 4 )
				surface.PlaySound( "buttons/button15.wav" )
			end
		end
	end
end)

function ENT:Think()
	self.OverlayText = "Коробка с деталями"..GetEntContentString(self).."\nНажмите <color=0,200,0>".. srp_util.UseKey .."</color>, чтобы открыть"
	self:NextThink( CurTime() + 1 )
end