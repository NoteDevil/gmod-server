
-----------------------------------------------------
/* #NoSimplerr# */

local Menu = {}

local function Option(title, icon, cmd, check)
	table.insert(Menu, {title = title, icon = icon, cmd = cmd, check = check})
end

local function SubMenu(title, icon, func, check)
	table.insert(Menu, {title = title, icon = icon, func = func, check = check})
end

local function Spacer(check)
	table.insert(Menu, {check = check})
end

local function Request(title, text, func)
	return function()
		Derma_StringRequest(DarkRP.getPhrase(title) or title, DarkRP.getPhrase(text) or text, nil, function(s)
			func(s)
		end)
	end
end

local function isCP()
	return LocalPlayer():isCP()
end

local function isMayor()
	return LocalPlayer():isMayor()
end

local function icon( name )
	return "icon16/" .. name .. ".png"
end

local function add(t)
	table.insert(Menu, t)
end

/* YOU CAN EDIT STUFF BELOW THIS POINT */

Option("Получить дневник", icon("vcard"), function() RunConsoleCommand("say", "/diary") end)

Option(C_LANGUAGE_DROP, icon("gun"), function()
	RunConsoleCommand( "darkrp", "dropweapon" )
end)

SubMenu(C_LANGUAGE_DEMOTE, icon("user_delete"), function(self)
	for k, v in pairs(player.GetAll()) do
		if v == LocalPlayer() then continue end
		self:AddOption(v:Name(), Request(C_LANGUAGE_DEMOTE, C_LANGUAGE_DEMOTE_DESCRIPTION, function(s)
			RunConsoleCommand("darkrp", "demote", v:UserID(), s)
		end)):SetColor(v:getJobTable().color)
	end
end)

Spacer()

SubMenu("Отправить сообщение", icon("email_edit"), function(self)
	for k, v in pairs(player.GetAll()) do
		if v == LocalPlayer() then continue end
		self:AddOption(v:Name(), Request("Отправить сообщение", "Введите текст собщения:", function(s)
			RunConsoleCommand("darkrp", "pm", v:UserID(), s)
		end)):SetColor(v:getJobTable().color)
	end
end)

Option("Опубликовать рекламу", icon("comments"), Request("Опубликовать рекламу", "Введи текст рекламы:", function(s)
	RunConsoleCommand("say", "/advert " .. s)
end))

Option("Позвать взрослых", icon("phone_add"), Request("Позвать взрослых", "Опиши свою ситуацию и местоположение:", function(s)
	RunConsoleCommand("say", "/cr " .. s)
end))

Spacer()

SubMenu( "Вероятность", icon("wand"), function(self)
	self:AddOption( "Вытащить карту", function()
		RunConsoleCommand("say", "/card")
	end):SetImage( icon("bullet_green") )

	self:AddOption( "Бросить кости", function()
		RunConsoleCommand("say", "/dice")
	end):SetImage( icon("bullet_yellow") )

	-- self:AddOption( "Прокрутить слоты", function()
	-- 	RunConsoleCommand("say", "/slots")
	-- end):SetImage( icon("bullet_red") )

	self:AddOption( "Получить шанс", function()
		RunConsoleCommand("say", "/roll")
	end):SetImage( icon("bullet_blue") )

	self:AddOption( "Камень, ножницы, бумага", function()
		RunConsoleCommand("say", "/rockpaperscissors")
	end):SetImage( icon("bullet_red") )

end)

SubMenu( "Жесты", icon("thumb_up"), function(self)
    for k,v in pairs(DarkRP.Anims) do
    	if v.spacer then
    		self:AddSpacer()
    		continue
    	end

        local entry = self:AddOption( v.name, function()
            RunConsoleCommand("_DarkRP_DoAnimation", v.anim)
		end)
    end
end)

Spacer()

Option(C_LANGUAGE_RPNAME, icon("vcard_edit"), Request(C_LANGUAGE_RPNAME, C_LANGUAGE_RPNAME_DESCRIPTION, function(s)
	RunConsoleCommand("darkrp", "rpname", s)
end))

Option(C_LANGUAGE_UNOWN_ALL, icon("door"), function()
	RunConsoleCommand("darkrp", "unownalldoors")
end)

Spacer(isCP)

SubMenu(C_LANGUAGE_WANTED, icon("flag_red"), function(self)
	for k, v in pairs(player.GetAll()) do
		if v == LocalPlayer() then continue end
		if !v:isWanted() then
			self:AddOption(v:Name(), Request(C_LANGUAGE_WANTED, C_LANGUAGE_WANTED_DESCRIPTION, function(s)
				RunConsoleCommand("darkrp", "wanted", v:UserID(), s)
			end)):SetColor(v:getJobTable().color)
		end
	end
end, isCP)

SubMenu(C_LANGUAGE_UNWANTED, icon("flag_green"), function(self)
	for k, v in pairs(player.GetAll()) do
		if v:isWanted() then
			self:AddOption(v:Name(), function() RunConsoleCommand("darkrp", "unwanted", v:UserID(), s) end):SetColor(v:getJobTable().color)
		end
	end
end, isCP)

--[[SubMenu(C_LANGUAGE_WARRANT, icon("door_in"), function(self)
	for k, v in pairs(player.GetAll()) do
		if v == LocalPlayer() then continue end
		self:AddOption(v:Name(), function(s)
			RunConsoleCommand("darkrp", "warrant", v:UserID(), s)
		end):SetColor(v:getJobTable().color)
	end
end, isCP)]]

Option(C_LANGUAGE_GIVE_LICENSE, icon("page_add"), function(self)
	RunConsoleCommand("darkrp", "givelicense")
end, function()
	local ply = LocalPlayer()
	local noMayorExists = fn.Compose{fn.Null, fn.Curry(fn.Filter, 2)(ply.isMayor), player.GetAll}
	local noChiefExists = fn.Compose{fn.Null, fn.Curry(fn.Filter, 2)(ply.isChief), player.GetAll}

	local canGiveLicense = fn.FOr{
		ply.isMayor, -- Mayors can hand out licenses
		fn.FAnd{ply.isChief, noMayorExists}, -- Chiefs can if there is no mayor
		fn.FAnd{ply.isCP, noChiefExists, noMayorExists} -- CP's can if there are no chiefs nor mayors
	}

	return canGiveLicense(ply)
end)

Spacer( isMayor )

Option( "Добавить пункт в устав", icon("pencil_add"), Request("Добавить пункт в устав", "Содержание правила:", function(s)
	RunConsoleCommand("say", "/addlaw " .. s)
end), isMayor)

SubMenu( "Убрать пункт устава", icon("pencil_delete"), function( self )
	for k,v in pairs( DarkRP.getLaws() ) do
		self:AddOption( v, function()
			RunConsoleCommand("say", "/removelaw " .. k)
		end)
	end
end, isMayor)

Option( "Переиздать устав", icon("pencil_go"), function()
	RunConsoleCommand("say", "/resetlaws")
end, isMayor)

Option(C_LANGUAGE_LOCKDOWN, icon("stop"), Request("Объявление ком. часа", "Введи причину ком. часа:", function(s)
	RunConsoleCommand("say", "/broadcast " .. s)
	RunConsoleCommand("darkrp", "lockdown")
end), function() return LocalPlayer():isMayor() && !GetGlobalBool("DarkRP_LockDown") end)

Option(C_LANGUAGE_UNLOCKDOWN, icon("stop"), function(s)
	RunConsoleCommand("darkrp", "unlockdown")
end, function() return LocalPlayer():isMayor() && GetGlobalBool("DarkRP_LockDown") end)

Option("Радиовещание", icon("transmit"), Request("Радиовещание", "Введи текст радиовещания:", function(s)
	RunConsoleCommand("say", "/broadcast " .. s)
end), isMayor)

Option("Запустить лотерею", icon("coins"), Request("Запустить лотерею", "Введи сумму:", function(s)
	RunConsoleCommand("say", "/lottery " .. s)
end), isMayor)

--[[Option(C_LANGUAGE_AGENDA, icon("application"), Request(C_LANGUAGE_AGENDA, C_LANGUAGE_AGENDA_DESCRIPTION, function(s)
	RunConsoleCommand("darkrp", "agenda", s)
end), function()
	for k, v in pairs(DarkRPAgendas) do
		if type(v.Manager) == "table" then
			if table.HasValue(v.Manager, LocalPlayer():Team()) then
				return true
			end
		elseif v.Manager == LocalPlayer():Team() then
			return true
		end
	end
end)]]--

/* DO NOT EDIT STUFF BELOW THIS POINT UNLESS YOU KNOW WHAT YOU ARE DOING */

local menu
hook.Add("OnContextMenuOpen", "CMenuOnContextMenuOpen", function()
	if not g_ContextMenu:IsVisible() then
		local orig = g_ContextMenu.Open
		g_ContextMenu.Open = function(self, ...)
			self.Open = orig
			orig(self, ...)

			menu = vgui.Create("CMenuExtension")
			menu:SetDrawOnTop(false)

			for k, v in pairs(Menu) do
				if not v.check or v.check() then
					if v.cmd then
						menu:AddOption(v.title, isfunction(v.cmd) and v.cmd or function() RunConsoleCommand(v.cmd) end):SetImage(v.icon)
					elseif v.func then
						local m, s = menu:AddSubMenu(v.title)
						s:SetImage(v.icon)
						v.func(m)
					else
						menu:AddSpacer()
					end
				end
			end

			menu:Open()
			if C_CONFIG_POSITION == "bottom" then
				menu:CenterHorizontal()
				menu.y = ScrH()
				menu:MoveTo(menu.x, ScrH() - menu:GetTall() - 8, .1, 0)
			elseif C_CONFIG_POSITION == "right" then
				menu:CenterVertical()
				menu.x = ScrW()
				menu:MoveTo(ScrW() - menu:GetWide() - 8, menu.y, .1, 0)
			elseif C_CONFIG_POSITION == "left" then
				menu:CenterVertical()
				menu.x = - menu:GetWide()
				menu:MoveTo(8, menu.y, .1, 0)
			else
				menu:CenterHorizontal()
				menu.y = - menu:GetTall()
				menu:MoveTo(menu.x, 30 + 8, .1, 0)
			end


			-- menu:MakePopup()
		end
	end
end)

hook.Add( "CloseDermaMenus", "CMenuCloseDermaMenus", function()
	if menu && menu:IsValid() then
		menu:MakePopup()
	end
end)

hook.Add("OnContextMenuClose", "CMenuOnContextMenuClose", function()
	menu:Remove()
end)

local f = RegisterDermaMenuForClose

function RegisterDermaMenuForClose( menu )
	f(menu)
end



--[[   _                                
    ( )                               
   _| |   __   _ __   ___ ___     _ _ 
 /'_` | /'__`\( '__)/' _ ` _ `\ /'_` )
( (_| |(  ___/| |   | ( ) ( ) |( (_| |
`\__,_)`\____)(_)   (_) (_) (_)`\__,_) 
	DMenu
--]]

local PANEL = {}

AccessorFunc( PANEL, "m_bBorder", 			"DrawBorder" )
AccessorFunc( PANEL, "m_bDeleteSelf", 		"DeleteSelf" )
AccessorFunc( PANEL, "m_iMinimumWidth", 	"MinimumWidth" )
AccessorFunc( PANEL, "m_bDrawColumn", 		"DrawColumn" )
AccessorFunc( PANEL, "m_iMaxHeight", 		"MaxHeight" )

AccessorFunc( PANEL, "m_pOpenSubMenu", 		"OpenSubMenu" )


--[[---------------------------------------------------------
	Init
-----------------------------------------------------------]]
function PANEL:Init()

	self:SetIsMenu( true )
	self:SetDrawBorder( true )
	self:SetDrawBackground( true )
	self:SetMinimumWidth( 100 )
	self:SetDrawOnTop( true )
	self:SetMaxHeight( ScrH() * 0.9 )
	self:SetDeleteSelf( true )
		
	self:SetPadding( 0 )
	
end

--[[---------------------------------------------------------
	AddPanel
-----------------------------------------------------------]]
function PANEL:AddPanel( pnl )

	self:AddItem( pnl )
	pnl.ParentMenu = self
	
end

--[[---------------------------------------------------------
	AddOption
-----------------------------------------------------------]]
function PANEL:AddOption( strText, funcFunction )
	if not strText then return end -- stupid check

	local pnl = vgui.Create( "DMenuOption", self )
	pnl:SetMenu( self )
	pnl:SetText( strText )
	if ( funcFunction ) then pnl.DoClick = funcFunction end
	
	self:AddPanel( pnl )
	
	return pnl

end

--[[---------------------------------------------------------
	AddCVar
-----------------------------------------------------------]]
function PANEL:AddCVar( strText, convar, on, off, funcFunction )

	local pnl = vgui.Create( "DMenuOptionCVar", self )
	pnl:SetMenu( self )
	pnl:SetText( strText )
	if ( funcFunction ) then pnl.DoClick = funcFunction end
	
	pnl:SetConVar( convar )
	pnl:SetValueOn( on )
	pnl:SetValueOff( off )
	
	self:AddPanel( pnl )
	
	return pnl

end

--[[---------------------------------------------------------
	AddSpacer
-----------------------------------------------------------]]
function PANEL:AddSpacer( strText, funcFunction )

	local pnl = vgui.Create( "DPanel", self )
	pnl.Paint = function( p, w, h )
		surface.SetDrawColor( Color( 0, 0, 0, 100 ) )
		surface.DrawRect( 0, 0, w, h )
	end
	
	pnl:SetTall( 1 )	
	self:AddPanel( pnl )
	
	return pnl

end

--[[---------------------------------------------------------
	AddSubMenu
-----------------------------------------------------------]]
function PANEL:AddSubMenu( strText, funcFunction )

	local pnl = vgui.Create( "DMenuOption", self )
	local SubMenu = pnl:AddSubMenu( strText, funcFunction )

	pnl:SetText( strText )
	if ( funcFunction ) then pnl.DoClick = funcFunction end

	self:AddPanel( pnl )

	return SubMenu, pnl

end

--[[---------------------------------------------------------
	Hide
-----------------------------------------------------------]]
function PANEL:Hide()

	local openmenu = self:GetOpenSubMenu()
	if ( openmenu ) then
		openmenu:Hide()
	end
	
	self:SetVisible( false )
	self:SetOpenSubMenu( nil )
	
end

--[[---------------------------------------------------------
	OpenSubMenu
-----------------------------------------------------------]]
function PANEL:OpenSubMenu( item, menu )

	-- Do we already have a menu open?
	local openmenu = self:GetOpenSubMenu()
	if ( IsValid( openmenu ) ) then
	
		-- Don't open it again!
		if ( menu && openmenu == menu ) then return end
	
		-- Close it!
		self:CloseSubMenu( openmenu )
	
	end
	
	if ( !IsValid( menu ) ) then return end

	local x, y = item:LocalToScreen( self:GetWide(), 0 )
	menu:Open( x-3, y, false, item )
	
	self:SetOpenSubMenu( menu )

end


--[[---------------------------------------------------------
	CloseSubMenu
-----------------------------------------------------------]]
function PANEL:CloseSubMenu( menu )

	menu:Hide()
	self:SetOpenSubMenu( nil )

end

--[[---------------------------------------------------------
	Paint
-----------------------------------------------------------]]
function PANEL:Paint( w, h )

	if ( !self:GetDrawBackground() ) then return end

	derma.SkinHook( "Paint", "Menu", self, w, h )
	return true

end

function PANEL:ChildCount()
	return #self:GetCanvas():GetChildren()
end

function PANEL:GetChild( num )
	return self:GetCanvas():GetChildren()[ num ]
end

--[[---------------------------------------------------------
	PerformLayout
-----------------------------------------------------------]]
function PANEL:PerformLayout()

	local w = self:GetMinimumWidth()
	
	-- Find the widest one
	for k, pnl in pairs( self:GetCanvas():GetChildren() ) do
	
		pnl:PerformLayout()
		w = math.max( w, pnl:GetWide() )
	
	end

	self:SetWide( w )
	
	local y = 0 -- for padding
	
	for k, pnl in pairs( self:GetCanvas():GetChildren() ) do
	
		pnl:SetWide( w )
		pnl:SetPos( 0, y )
		pnl:InvalidateLayout( true )
		
		y = y + pnl:GetTall()
	
	end
	
	y = math.min( y, self:GetMaxHeight() )
	
	self:SetTall( y )

	derma.SkinHook( "Layout", "Menu", self )
	
	DScrollPanel.PerformLayout( self )

end


--[[---------------------------------------------------------
	Open - Opens the menu. 
	x and y are optional, if they're not provided the menu 
		will appear at the cursor.
-----------------------------------------------------------]]
function PANEL:Open( x, y, skipanimation, ownerpanel )

	local maunal = x and y

	x = x or gui.MouseX()
	y = y or gui.MouseY()
	
	local OwnerHeight = 0
	local OwnerWidth = 0
	
	if ( ownerpanel ) then
		OwnerWidth, OwnerHeight = ownerpanel:GetSize()
	end
		
	self:PerformLayout()
		
	local w = self:GetWide()
	local h = self:GetTall()
	
	self:SetSize( w, h )
	
	
	if ( y + h > ScrH() ) then y = ((maunal and ScrH()) or (y + OwnerHeight)) - h end
	if ( x + w > ScrW() ) then x = ((maunal and ScrW()) or x) - w end
	if ( y < 1 ) then y = 1 end
	if ( x < 1 ) then x = 1 end
	
	self:SetPos( x, y )
	
	-- Popup!
	self:MakePopup()
	
	-- Make sure it's visible!
	self:SetVisible( true )
	
	-- Keep the mouse active while the menu is visible.
	self:SetKeyboardInputEnabled( false )
	
end

--
-- Called by DMenuOption
--
function PANEL:OptionSelectedInternal( option )

	self:OptionSelected( option, option:GetText() )

end

-----------LeakedbySourusRex-----------
function PANEL:OptionSelected( option, text )

	-- For override

end

function PANEL:ClearHighlights()

	for k, pnl in pairs( self:GetCanvas():GetChildren() ) do
		pnl.Highlight = nil
	end

end

function PANEL:HighlightItem( item )

	for k, pnl in pairs( self:GetCanvas():GetChildren() ) do
		if ( pnl == item ) then
			pnl.Highlight = true
		end
	end

end

--[[---------------------------------------------------------
   Name: GenerateExample
-----------------------------------------------------------]]
function PANEL:GenerateExample( ClassName, PropertySheet, Width, Height )


end

derma.DefineControl( "CMenuExtension", "A Menu", PANEL, "DScrollPanel" )
