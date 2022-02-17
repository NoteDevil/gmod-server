/*
	Name: DarkRP 2D3D Door Options
	Author: Robotboy655
	Version: 2

	DO NOT REDESTRIBUTE OR RESELL THIS SCRIPT
*/

/* ---------------------------- CONFIG ---------------------------- */

local HideDefaultOverlay = true -- Hide the default HUD overlay when looking at doors?

local DrawCursor = true -- Draw the cursor or not, originally a dev feature
local CursorDistance = 48 -- Maximum distancem at which cursor is operational/visible

local FadeDistance = 100 -- Maximal distance, at which door info must be fully visible
local NoDrawDistance = 200 -- Distance, at which the door info/buttons won't be drawn at all

local HighLightOwner = true -- Highlights master owner in green
local ShowCoOwnersAll = true -- Show Co-Owners that haven't bough the door to everyone, false means only to master owner and coowners
local AllowCoOwnersAddOwners = false -- Allow co-owners add or remove owners from doors

/* ---------------------------- CUSTOM DOOR FIXES ---------------------------- */

/* How to use:
1) Add a new entry to the table below:
2) Uncomment helpers at lines 293-297 ( 4 lines total )
3) Play with vatiables in your table from your new model
4) Once done, comment helpers
*/

local ModelOptions = {
	[ "models/joebloom/millwork/door_commercial01.mdl" ] = {
		width = 600,
		height = 1080,
		x1 = -1.04,
		x2 = 60,
		y1 = 108,
		y2 = 108,
		side1pos = Vector( 1.01, -1, 108 ),
		side2pos = Vector( -1.01, -61, 108 ),
		titleY = 0.25, -- Offset of overall height
		namesY = 0.55, -- Offset of overall height
		angle = Angle( 0, 90, 90 )
	},
	[ "models/joebloom/millwork/door_interior_02.mdl" ] = {
		width = 590,
		height = 1080,
		x1 = -0.5,
		x2 = 59,
		y1 = 108.5,
		y2 = 108,
		side1pos = Vector( 0.76, -0.5, 108.5 ),
		side2pos = Vector( -0.76, -59.5, 108.5 ),
		titleY = 0.25,
		namesY = 0.5,
		angle = Angle( 0, 90, 90 )
	},
	[ "models/joebloom/doors/door_interior01.mdl" ] = {
		width = 510,
		height = 1085,
		x1 = -0.5,
		x2 = 51,
		y1 = 109.5,
		y2 = 108.5,
		side1pos = Vector( 1.02, -0.5, 109.5 ),
		side2pos = Vector( -1.02, -51.5, 109.5 ),
		titleY = 0.25,
		namesY = 0.5,
		angle = Angle( 0, 90, 90 )
	},
	[ "models/joebloom/millwork/door_entrance01.mdl" ] = {
		width = 580,
		height = 1085,
		x1 = 0,
		x2 = 58,
		y1 = 109,
		y2 = 108.5,
		side1pos = Vector( 1.51, -0, 109.5 ),
		side2pos = Vector( -1.51, -58, 109 ),
		titleY = 0.25,
		namesY = 0.5,
		angle = Angle( 0, 0, 90 )
	}
}

/* ---------------------------- SCRIPT ---------------------------- */

if ( SERVER ) then

	hook.Add( "PlayerBoughtDoor", "rb655_updatelockedstate", function( ply, door, cost )
		door:SetNWBool( "Locked", door:GetSaveTable().m_bLocked )
	end )

	hook.Add( "onKeysUnlocked", "rb655_updatelockedstate", function( door )
		door:SetNWBool( "Locked", false )
	end )

	hook.Add( "onKeysLocked", "rb655_updatelockedstate", function( door )
		door:SetNWBool( "Locked", true )
	end )

	concommand.Add( "darkrp_door_lock", function( ply )
		local ent = ply:GetEyeTrace().Entity
		if ( IsValid( ent ) && ent:isKeysOwnedBy( ply ) ) then
			ent:Fire( "Lock" )
			ent:SetNWBool( "Locked", true )
			
			if ( !ent:GetName() ) then return end
			for id, ent2 in pairs( ents.FindByName( ent:GetName() ) ) do
				ent2:Fire( "Lock" )
				ent2:SetNWBool( "Locked", true )
			end
		end
	end )

	concommand.Add( "darkrp_door_unlock", function( ply )
		local ent = ply:GetEyeTrace().Entity
		if ( IsValid( ent ) && ent:isKeysOwnedBy( ply ) ) then
			ent:Fire( "Unlock" )
			ent:SetNWBool( "Locked", false )
			
			if ( !ent:GetName() ) then return end
			for id, ent2 in pairs( ents.FindByName( ent:GetName() ) ) do
				ent2:Fire( "Unlock" )
				ent2:SetNWBool( "Locked", false )
			end
		end
	end )

	return
end

hook.Add( "HUDDrawDoorData", "rb655_darkrp_nodoorsz", function( ent )
	if ( ent:GetClass() == "prop_door_rotating" && HideDefaultOverlay ) then return true end
end )

surface.CreateFont( "DoorFont_Scale0", {
	font = "Tahoma",
	size = 64,
	weight = 800
} )

surface.CreateFont( "DoorFont_Scale1", {
	font = "Tahoma",
	size = 48,
	weight = 800
} )

surface.CreateFont( "DoorFont_Scale2", {
	font = "Tahoma",
	size = 43,
	weight = 800
} )

surface.CreateFont( "DoorFont_Scale3", {
	font = "Tahoma",
	size = 38,
	weight = 800
} )

surface.CreateFont( "DoorFont_Scale4", {
	font = "Tahoma",
	size = 33,
	weight = 800
} )

surface.CreateFont( "DoorFont_Scale5", {
	font = "Tahoma",
	size = 28,
	weight = 800
} )

local DoorAction = ""
//local DoorSide = 1

local function CanBuyDoor( ent )
	//if ( ent:isKeysOwnedBy( LocalPlayer() ) ) then return false end
	if ( ent:getKeysAllowedToOwn( LocalPlayer() ) ) then return true end
	if ( !ent:getKeysNonOwnable() && !ent.DoorData.NonOwnable && !ent:getKeysDoorGroup() && !ent:getKeysDoorTeams() && !ent:isKeysOwned() ) then return true end
	return false
end

local function GetDoorOwners( ent )
	local t = {}
	
	for k, v in pairs( player.GetAll() ) do
		if ( ent:isKeysOwnedBy( v ) ) then
			table.insert( t, v:Nick() )
		end
	end
	
	if ( ent:getKeysDoorTeams() ) then
		for k, v in pairs( ent:getKeysDoorTeams() ) do
			if ( v ) then table.insert( t, RPExtraTeams[k].name ) end
		end
	end

	if ( ent:getKeysDoorGroup() ) then
		table.insert( t, ent:getKeysDoorGroup() )
	end
	
	if ( #t < 1 && CanBuyDoor( ent ) ) then return { "Свободно" } end
	if ( #t < 1 && !CanBuyDoor( ent ) ) then return { "" } end
	return t
end

local function GetCoOwners( ent )
	local t = {}
	local ply
	local test = ent:getKeysAllowedToOwn()
	if test != nil then
		for k, v in pairs(player.GetAll()) do
			for p, j in pairs(test) do
				if v:UserID() == p then
					table.insert(t, v:Nick())
				end
			end
		end
	end

	return t
end

local function GetDoorTitle( ent )
	if ( ent.DoorData ) then return ent:getKeysTitle() or "" end
	return ""
end

local FontList = { "DoorFont_Scale0", "DoorFont_Scale1", "DoorFont_Scale2", "DoorFont_Scale3", "DoorFont_Scale4", "DoorFont_Scale5" }
local function GetDrawTable( tbl, maxw )

	local t = {}
	local lastH = 0
	local totlH = 50

	for id, str in pairs( tbl ) do

		local font = FontList[ 1 ]
		local height = 50
	
		for i = 1, #FontList - 1 do
			surface.SetFont( FontList[ i ] )
			local textW, textH = surface.GetTextSize( str )

			if ( textW > maxw ) then
				font = FontList[ i + 1 ]
				surface.SetFont( font )
				local textW, textH = surface.GetTextSize( str )
				height = textH
			else
				break
			end
		end
		
		totlH = totlH + lastH
		
		table.insert( t, { str, font, totlH } )

		lastH = height
	end
	
	return t, totlH
	
end

local function DrawTextTable( tbl, y, clr, maxw, vcenter, owner )

	local tb, h = GetDrawTable( tbl, maxw )
	local totolH = 0
	if ( vcenter ) then y = y - h / 2 end

	for id, t in pairs( tb ) do

		if ( IsValid( owner ) && t[ 1 ] == owner:Nick() && HighLightOwner ) then clr = Color( 200, 255, 200, clr.a ) end

		draw.SimpleText( t[ 1 ], t[ 2 ], maxw / 2 + 1, y + t[ 3 ] + 1, Color(0,0,0, clr.a), 1, 1)
		draw.SimpleText( t[ 1 ], t[ 2 ], maxw / 2, y + t[ 3 ], clr, 1, 1)

	end

	return h
	
end

local PrecachedIcons = {}
local function DrawButton( settings, x, y, width, icn, act )

	local cx = settings[ 1 ]
	local cy = settings[ 2 ]
	local ca = settings[ 3 ]
	local alpha = settings[ 4 ]
	local side2 = settings[ 5 ]

	local w = 26
	local h = 26
	if ( !side2 ) then x = width - w - x end
	
	local over = 0
	if ( cx > x && cx < x + w && cy > y && cy < y + h && ca ) then
		DoorAction = act
		over = 255
	end

	draw.NoTexture()
	surface.SetDrawColor( Color( 0, over / 2, over, alpha ) )
	surface.DrawTexturedRect( x, y, 26, 26 )
	
	if ( !PrecachedIcons[ icn ] ) then PrecachedIcons[ icn ] = Material( icn ) end
	surface.SetMaterial( PrecachedIcons[ icn ] )
	surface.SetDrawColor( Color( 255, 255, 255, alpha ) )
	surface.DrawTexturedRect( x + 5, y + 5, 16, 16 )

end

local function DrawDoor( ent, w, h, alpha, cursorx, cursory, cusrorActive, side2 )

	local titleY = 0.25
	local namesY = 0.5
	
	if ( ModelOptions[ ent:GetModel() ] ) then
		local t = ModelOptions[ ent:GetModel() ]
		titleY = t.titleY
		namesY = t.namesY
	end
	
	local title = GetDoorTitle( ent )
	while ( string.find( title, "  " ) ) do title = title:gsub( "  ", " " ) end
	DrawTextTable( string.Explode( " ", title ), h * titleY, Color( 255, 255, 255, alpha ), w, true )
	local namesH = DrawTextTable( GetDoorOwners( ent ), h * namesY, Color( 255, 255, 255, alpha ), w, false, ent:getDoorOwner() )

	if ( ShowCoOwnersAll || ent:getKeysAllowedToOwn( LocalPlayer() ) || ent:isKeysOwnedBy( LocalPlayer() ) ) then DrawTextTable( GetCoOwners( ent ), namesH + h * namesY, Color( 169, 82, 82, alpha ), w, false ) end

	local ButtonSettings = { cursorx, cursory, cusrorActive, alpha, side2 }

	local ButtonY = 450 -- Position of the Menu button ( Top, Left )
	local ButtonX = 29
	
	//DrawButton( ButtonSettings, ButtonX, ButtonY, w, "icon16/text_list_bullets.png", "Menu" )

	if ( ( FAdmin && FAdmin.Access.PlayerHasPrivilege( LocalPlayer(), "rp_doorManipulation" ) || LocalPlayer():IsAdmin() ) ) then
		if ( ent.DoorData.NonOwnable ) then
			DrawButton( ButtonSettings, ButtonX, ButtonY + 30, w, "icon16/cross.png", "Allow Ownership" )
		else
			DrawButton( ButtonSettings, ButtonX, ButtonY + 30, w, "icon16/tick.png", "Disallow Ownership" )
		end

		DrawButton( ButtonSettings, ButtonX + 30, ButtonY + 30, w, "icon16/group.png", "Set Group" )

	end

	if ( ent:isKeysOwnedBy( LocalPlayer() ) || ( ( FAdmin && FAdmin.Access.PlayerHasPrivilege( LocalPlayer(), "rp_doorManipulation" ) || LocalPlayer():IsAdmin() ) && ent.DoorData.NonOwnable ) ) then
		DrawButton( ButtonSettings, ButtonX + 10, ButtonY, w, "icon16/textfield_rename.png", "Изменить описание" )
	end

	if ( ent:isKeysOwnedBy( LocalPlayer() ) ) then

		DrawButton( ButtonSettings, ButtonX, ButtonY - 30, w, "icon16/key_delete.png", "Продать" )

		if ( AllowCoOwnersAddOwners || ent:getDoorOwner() == LocalPlayer() ) then
			DrawButton( ButtonSettings, ButtonX + 40, ButtonY, w, "icon16/add.png", "Добавить" )
		
			DrawButton( ButtonSettings, ButtonX + 70, ButtonY, w, "icon16/delete.png", "Убрать" )

			DrawButton( ButtonSettings, ButtonX + 100, ButtonY, w, "icon16/bullet_wrench.png", "Убрать замок" )
		end

	elseif ( CanBuyDoor( ent ) ) then 

		DrawButton( ButtonSettings, ButtonX, ButtonY - 30, w, "icon16/key_add.png", "Купить" )

	end

	local trianglevertex = { {
		x = cursorx,
		y = cursory
	}, {
		x = cursorx + 10,
		y = cursory + 10
	}, {
		x = cursorx + 4,
		y = cursory + 9
	}, {
		x = cursorx + 0,
		y = cursory + 15
	} }
	
	if ( cusrorActive && DrawCursor ) then
		draw.NoTexture()
		surface.SetDrawColor( 255, 255, 255, alpha )
		surface.DrawPoly( trianglevertex )
	end
	
	if ( DoorAction != "" && LocalPlayer():GetEyeTrace().Entity == ent ) then
		surface.SetFont( "DoorFont_Scale5" )
		local textW, textH = surface.GetTextSize( DoorAction )

		local x = cursorx + 5
		if ( !side2 ) then x = cursorx - textW - 10 end
		
		draw.NoTexture()
		surface.SetDrawColor( Color( 0, 0, 0, alpha ) )
		surface.DrawTexturedRect( x, cursory - 31, textW + 10, 26 )

		draw.SimpleText( DoorAction, "DoorFont_Scale5", x + 5, cursory - 34, Color( 255, 255, 255, alpha ) )
	end

end

hook.Remove( "PreDrawTranslucentRenderables", "DarkRP_3D2D_Doors" )
hook.Add( "PostDrawTranslucentRenderables", "DarkRP_3D2D_Doors", function()

	if ( FadeDistance > NoDrawDistance ) then FadeDistance = NoDrawDistance / 2 end

	cam.Start3D( EyePos(), EyeAngles() )

	for id, ent in pairs( ents.FindByClass( "prop_door_rotating" ) ) do

		local distToDoor = ent:GetPos():Distance( LocalPlayer():GetPos() )
		if ( distToDoor > NoDrawDistance ) then continue end

		local alpha = math.Clamp( ( 1 - ( distToDoor - FadeDistance ) / ( NoDrawDistance - FadeDistance ) ) * 255, 0, 255 )

		local screenWidth = 480
		local screenHeight = 1080

		local x1 = 1
		local x2 = 48
		local y1 = 54
		local y2 = 108
		
		local side1pos = Vector( 1.03, 1, 54 )
		local side2pos = Vector( -1.03, -47, 54 )
		local angle = Angle( 0, 90, 90 )
		
		if ( ModelOptions[ ent:GetModel() ] ) then
			local t = ModelOptions[ ent:GetModel() ]

			screenWidth = t.width
			screenHeight = t.height

			x1 = t.x1
			x2 = t.x2
			y1 = t.y1
			y2 = t.y2
			
			side1pos = t.side1pos
			side2pos = t.side2pos
			angle = t.angle

		end

		local trace = LocalPlayer():GetEyeTrace()
		
		local posOnDoor = ent:WorldToLocal( trace.HitPos )
		local distToCursor = trace.HitPos:Distance( LocalPlayer():GetShootPos() )

		local cx = ( posOnDoor.y + x1 ) / x2
		if ( ent:GetForward():Distance( ( ent:GetAngles() + angle ):Forward() ) < 1 ) then
			cx = ( posOnDoor.x + x1 ) / x2
		end
		local cy = ( posOnDoor.z - y1 ) / y2
		cy = math.abs( cy )

		local cursorActive = trace.Entity == ent && distToCursor < CursorDistance

		if ( ent == LocalPlayer():GetEyeTrace().Entity ) then DoorAction = "" end

		local ang = ent:GetAngles() + angle
		local pos = ent:GetPos() + ang:Up() * side1pos.x - ang:Forward() * side1pos.y - ang:Right() * side1pos.z

		cam.Start3D2D( pos, ang, 0.1 )

			DrawDoor( ent, screenWidth, screenHeight, alpha, cx * screenWidth, cy * screenHeight, cursorActive )

		cam.End3D2D()

		
		local pos2 = ent:GetPos() + ang:Up() * side2pos.x - ang:Forward() * side2pos.y - ang:Right() * side2pos.z
		ang:RotateAroundAxis( Vector( 0, 0, 1 ), 180 )

		cam.Start3D2D( pos2, ang, 0.1 )

			DrawDoor( ent, screenWidth, screenHeight, alpha, ( 1 - cx ) * screenWidth, cy * screenHeight, cursorActive, true )

		cam.End3D2D()

		/*if ( ent == LocalPlayer():GetEyeTrace().Entity ) then

			local PlyPos = LocalPlayer():GetShootPos()
			DoorSide = 1
			if ( ent:GetPos() + ent:GetForward() ):Distance( PlyPos ) > ( ent:GetPos() - ent:GetForward() ):Distance( PlyPos ) then DoorSide = 2 end

		end*/

	end

	cam.End3D()

end )

hook.Add( "PlayerBindPress", "function_doorz", function( ply, bind, pressed )

	local ent = LocalPlayer():GetEyeTrace().Entity

	if ( IsValid( ent ) && bind == "+use" && ent:GetClass() == "prop_door_rotating" && DoorAction != "" && pressed ) then

		if ( DoorAction == "Купить" || DoorAction == "Продать" ) then
			RunConsoleCommand( "say", "/toggleown" )
		end
		if ( DoorAction == "Menu" ) then GAMEMODE.ShowTeam() end
		if ( DoorAction == "Изменить описание" ) then
			Derma_StringRequest( "Измените описание", "Set the title of the door you're looking at:", ent:getKeysTitle() or "", function( text )
				RunConsoleCommand( "say", "/title "..text )
			end, function() end, "Okay", "Cancel" )
		end
		if ( DoorAction == "Убрать замок" ) then
			RunConsoleCommand("DemontageLock")
		end

		if ( DoorAction == "Allow Ownership" || DoorAction == "Disallow Ownership" ) then RunConsoleCommand( "say", "/toggleownable" ) end

		if ( DoorAction == "Добавить" ) then
			gui.EnableScreenClicker( true )
			local AddMenu = DermaMenu()
			AddMenu.found = false
			for k, v in pairs( player.GetAll() ) do
				if ( !ent:isKeysOwnedBy( v ) && !ent:getKeysAllowedToOwn( v ) ) then
					AddMenu.found = true
					AddMenu:AddOption( v:Nick(), function() RunConsoleCommand( "say", "/ao "..v:SteamID() ) end )
				end
			end
			if ( !AddMenu.found ) then AddMenu:AddOption( "Недоступно", function() end ) end
			AddMenu:Open()
			gui.EnableScreenClicker( false )
		end

		if ( DoorAction == "Убрать" ) then
			gui.EnableScreenClicker( true )
			local AddMenu = DermaMenu()
			AddMenu.found = false
			for k, v in pairs( player.GetAll() ) do
				if  ( ent:isKeysOwnedBy( v ) || ent:getKeysAllowedToOwn( v ) ) then
					AddMenu.found = true
					if v:IsBot() then
						AddMenu:AddOption( v:Nick(), function() RunConsoleCommand( "say", "/ro "..v:Nick() ) end )
					else
						AddMenu:AddOption( v:Nick(), function() RunConsoleCommand( "say", "/ro "..v:SteamID() ) end )
					end
				end
			end
			if ( !AddMenu.found ) then AddMenu:AddOption( "Недоступно", function() end ) end
			AddMenu:Open()
			gui.EnableScreenClicker( false )
		end

		if ( DoorAction == "Set Group" ) then
			gui.EnableScreenClicker( true )
	
			local AddMenu = DermaMenu()
			local groups = AddMenu:AddSubMenu( "Door Groups" )
			local teams = AddMenu:AddSubMenu( "Jobs" )
			local add = teams:AddSubMenu( "Add" )
			local remove = teams:AddSubMenu( "Remove" )

			AddMenu:AddOption( "None", function() RunConsoleCommand( "say", "/togglegroupownable" ) end )
			for k, v in pairs( RPExtraTeamDoors ) do
				groups:AddOption( k, function() RunConsoleCommand( "say", "/togglegroupownable "..k ) end )
			end

			if ( !ent.DoorData ) then return end

			for k, v in pairs( RPExtraTeams ) do
				if ( !ent:getKeysDoorTeams() ) then
					add:AddOption( v.name, function() RunConsoleCommand( "say", "/toggleteamownable "..k ) end)
				else
					remove:AddOption( v.name, function() RunConsoleCommand( "say", "/toggleteamownable "..k ) end)
				end
			end

			AddMenu:Open()
			
			gui.EnableScreenClicker( false )
		end

		return true
	end

end )