local enable_hud = CreateClientConVar("srp_hud_main", "1", true)
local enable_drawinfo = CreateClientConVar("srp_hud_playernames", "1", true)

local to_hide = {
  ["DarkRP_HUD"] = false,
  ["DarkRP_EntityDisplay"] = false,
  ["DarkRP_ZombieInfo"] = true,
  ["DarkRP_LocalPlayerHUD"] = true,
  ["DarkRP_Agenda"] = true,
  ["DarkRP_Hungermod"] = true,
  ["CHudHealth"] = true,
  ["CHudBattery"] = true,
  ["CHudAmmo"] = true,
  ["CHudSecondaryAmmo"] = true,
}
hook.Add("HUDShouldDraw", "BlackHUD.HUDShouldDraw", function(name)
	return not to_hide[name]
end)

surface.CreateFont("BlackHUD.MainFont", {
	font = "Roboto Bold",
	size = 21,
	weight = 600,
	extended = true,
})

surface.CreateFont("BlackHUD.Subtext", {
	font = "Roboto Bold",
	size = 17,
	weight = 600,
	extended = true,
})

surface.CreateFont("BlackHUD.MoneyFont", {
	font = "Roboto Bold",
	size = 20,
	weight = 600,
	extended = true,
})

surface.CreateFont("BlackHUD.Procents", {
	font = "Robot Bold",
	size = 15,
	weight = 500,
	extended = true,
})

surface.CreateFont("BlackHUD.LockDown", {
	font = "Robot Bold",
	size = 24,
	weight = 500,
	extended = true,
})

surface.CreateFont("BlackHUD.TimeFont", {
	font = "Consolas",
	size = 16,
	weight = 500,
	extended = true,
})

surface.CreateFont("BlackHUD.GroupFont", {
	font = "Roboto Bold",
	size = 16,
	weight = 500,
	extended = true,
})

local w, h = 300, 64
local x_, y_ = 10, ScrH()-h-10
local line_w = 300-64-10
local avatar

local function playTime(time)

	local h, m, s
	h = math.floor(time / 60 / 60)
	m = math.floor(time / 60) % 60
	s = math.floor(time) % 60

	return string.format("%02i:%02i:%02i", h, m, s)

end

hook.Add("Think", "BlackHUD", function() -- don't burn their PCs in HUDPaint, roni
	local ply = LocalPlayer()
	if not IsValid(ply) then return end

	local wep = ply:GetActiveWeapon()
	if enable_hud:GetInt() == 0 or IsValid(wep) and wep:GetClass() == 'gmod_camera' then
		if IsValid(avatar) then avatar:SetVisible(false) end
		return 
	end

	if not IsValid(avatar) then
		avatar = vgui.Create( "AvatarImage" )
		avatar:SetSize( 64, 64 )
		avatar:SetPos( x_, y_ )
		avatar:SetPlayer( ply, 66 )
	else
		if not avatar:IsVisible() then
			avatar:SetVisible(true)
		end 
	end
end)

hook.Add("HUDPaint", "BlackHUD", function()
	local ply = LocalPlayer()
	if not IsValid(ply) then return end

	local wep = ply:GetActiveWeapon()
	if enable_hud:GetInt() == 0 or IsValid(wep) and wep:GetClass() == 'gmod_camera' then return end

	local yoff = 0
	do -- UTime thing
		surface.SetFont("BlackHUD.TimeFont")
		local text_w, text_h = surface.GetTextSize(playTime(ply:GetUTimeTotalTime()))
		draw.SRPBackGround(3, x_+w-text_w-17, y_-20, text_w+12, 30)
		draw.ShadowText(playTime(ply:GetUTimeTotalTime()), "BlackHUD.TimeFont", x_+w-11, y_-17, Color(110,130,139), TEXT_ALIGN_RIGHT)
		yoff = text_w + 12 + 2
	end

	do -- Group thing
		render.SetScissorRect(x_, y_-18, x_+210, y_, true)
		-- draw.RoundedBox(0, 0, y_-20, 500, y_, Color(255,0,0)) -- debug
		draw.ShadowText(ply:GetNWString("SRPGroup"), "BlackHUD.GroupFont", x_, y_-10, color_white, 0, 1)
		render.SetScissorRect(x_, y_-15, x_+300, y_, false)
	end

	if ply:GetNWBool( "IsBanned" ) then -- banned thing
		surface.SetFont("BlackHUD.TimeFont")

		local unbanTime = ply:GetNWFloat( "UnBanTime" )
		local text = unbanTime ~= 0 and ("Бан: " .. playTime(unbanTime - CurTime())) or "Пермабан"
		local text_w, text_h = surface.GetTextSize(text)
		draw.SRPBackGround(3, x_+w-text_w-17 - yoff, y_-20, text_w+12, 30)
		draw.ShadowText(text, "BlackHUD.TimeFont", x_+w-11 - yoff, y_-17, Color(255,80,90), TEXT_ALIGN_RIGHT)
	end

	do -- Main Part
		draw.SRPBackGround(3, x_, y_, w, h)

		local job = ply:getDarkRPVar('job') and ply:getDarkRPVar('job') or "nil"
		if RPExtraTeams[ply:Team()] and RPExtraTeams[ply:Team()].category == "Школьники" then
			job = job.." - "..ply:GetLevel().." класс"
		end
		draw.ShadowText(job, "BlackHUD.MainFont", x_+64+5, y_+3, color_white, 0, 0 )
		draw.ShadowText(DarkRP.formatMoney(ply:getDarkRPVar('money')).."+"..DarkRP.formatMoney(ply:getDarkRPVar('salary')), "BlackHUD.MoneyFont", x_+64+5, y_+28, Color(120,193,120), 0, 0 )

		do -- Hunger
			draw.RoundedBox(0, x_+64+5, y_+54, line_w-24-1, 1, Color(83,104,112))

			local energy = ply:getDarkRPVar('Energy') and ply:getDarkRPVar('Energy') or 100
			local energy_p = math.Clamp(energy, 0, 100)
			draw.RoundedBox(0, x_+64+5, y_+54, (line_w-24)/100*energy_p, 1, Color(201,184,88))

			draw.ShadowText(energy_p, "BlackHUD.Procents", x_+w-29, y_+39, color_white, 2, 2 )
		end

		do -- Health
			draw.RoundedBox(0, x_+64+5, y_+59, line_w-1, 1, Color(83,104,112))
			local health_p = math.min(ply:Health()/ply:GetMaxHealth(), 1)*100
			draw.RoundedBox(0, x_+64+5, y_+59, line_w/ply:GetMaxHealth()*health_p, 1, Color(255,0,0))

			draw.ShadowText(ply:Health(), "BlackHUD.Procents", x_+w-5, y_+44, color_white, 2, 2 )
		end
	end

	do -- Ammo Count
		if ply:Alive() and ply:GetActiveWeapon():IsValid() then
			local w_, h_ = h+30, h
			local cur = ply:GetActiveWeapon():Clip1()
			local rem = ply:GetAmmoCount(ply:GetActiveWeapon():GetPrimaryAmmoType())
			if ply:GetActiveWeapon():Clip1() >= 0 then
				draw.SRPBackGround(3, ScrW()-w_-10, y_, w_, h_)
				draw.SimpleText(cur.." | "..rem, "BlackHUD.LockDown", ScrW()-w_/2-10, y_+h/2, Color(255, 255, 255), 1, 1)
			end
		end
	end

	do -- LockDown
		if GetGlobalBool("DarkRP_LockDown") then
			draw.ShadowText(DarkRP.getPhrase("lockdown_started"), "BlackHUD.LockDown", x_, y_-30, Color(200,200,200), 0, 0)
		end
	end

	do -- Agenda shit
		local agenda = ply:getAgendaTable()
	    if not agenda then return end
	    if not ply:getDarkRPVar("agenda") then return end
	    if string.Replace(ply:getDarkRPVar("agenda"), " ", "") == "" then return end
	    local agendatext = markup.Parse(ply:getDarkRPVar("agenda"), 300)
	    draw.SRPBackGround(3, 10, 150, 300, 100)
	    draw.SRPBackGround(3, 10, 150, 300, 25,100)
	    draw.ShadowText("Задания", "BlackHUD.Procents", 20, 155, color_white)
	    agendatext:Draw( 15, 180, 0, 0 )
	end

end)

local meta = FindMetaTable("Player")

function meta:drawPlayerInfo()

	if enable_drawinfo:GetInt() == 0 then return end

	local pos = self:EyePos()
	local bone = self:LookupBone("ValveBiped.Bip01_Head1")
	if bone then
		pos = self:GetBonePosition( bone )
	end

    pos = (pos + Vector(0,0,12)):ToScreen()

	local name, job = self:Name(), self:getDarkRPVar("job") or team.GetName( self:Team() )
	local nick = self:GetNWString( "PSNick" )
	local hasNick = nick ~= ""

	surface.SetFont( "BlackHUD.MainFont" )
	local tw1, th1 = surface.GetTextSize( name )
	surface.SetFont( "BlackHUD.Subtext" )
	local tw2, th2 = surface.GetTextSize( job )
	local tw3, th3 = 0, 0
	if hasNick then
		surface.SetFont( "BlackHUD.MainFont" )
		tw3, th3 = surface.GetTextSize( nick )
	end
	local w, h = math.max( tw1, tw2, tw3 ) + 16, hasNick and 68 or 45
	pos.x, pos.y = math.floor(pos.x), math.floor(pos.y)

	draw.SRPBackGround( 4, pos.x - w/2, pos.y - h - 5, w, h )
	if hasNick then draw.SimpleText( nick, "BlackHUD.MainFont", pos.x, pos.y - 58, Color(255,255,255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER ) end
	draw.SimpleText( name, "BlackHUD.MainFont", pos.x, pos.y - 37, Color(255,255,255, hasNick and 100 or 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	draw.SimpleText( job, "BlackHUD.Subtext", pos.x, pos.y - 18, team.GetColor(self:Team()), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	draw.SimpleText("u","marlett", pos.x, pos.y - 11, Color(83,104,112), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
	draw.SimpleText("u","marlett", pos.x, pos.y - 12, Color(32,36,40), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)

end
