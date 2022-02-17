local enabled_schedule = CreateClientConVar("srp_hud_shedule", "1", true)

local function timeFormat( time )

    local m = math.floor( time ) % 60
    local h = math.floor( time / 60 ) % 24

    return string.format( "%02i:%02i", h, m )

end

surface.CreateFont( "ClockFace", {
	font = "Consolas",
	size = 64,
	weight = 300,
	antialias = true
})

surface.CreateFont( "ClockScheduleLarge", {
	font = "Arial",
	size = 34,
	weight = 300,
	antialias = true
})

surface.CreateFont( "ClockScheduleMedium", {
	font = "Arial",
	size = 22,
	weight = 300,
	antialias = true
})

surface.CreateFont( "ClockScheduleSmallTime", {
	font = "Consolas",
	size = 22,
	weight = 300,
	antialias = true
})

surface.CreateFont( "ClockScheduleSmall", {
	font = "Arial",
	size = 16,
	weight = 500,
	antialias = true
})

local function ring()
	local snd = CreateSound( LocalPlayer(), "ambient/alarms/city_firebell_loop1.wav" )
	snd:PlayEx( 0, 100 )
	snd:ChangeVolume( 1, 0.5 )
	timer.Simple( 4, function()
		snd:ChangeVolume( 0, 1 )
		timer.Simple( 2, function()
			snd:Stop()
		end)
	end)
end

srp_classes.lastClass = srp_classes.lastClass or srp_classes.events[1]
hook.Add( "HUDPaint", "SRP_Classes", function()
	local wep = LocalPlayer():GetActiveWeapon()
	if enabled_schedule:GetInt() == 0 or IsValid(wep) and wep:GetClass() == 'gmod_camera' then return end

	draw.RoundedBox( 8, 10, 10, 200, 70, Color(83,104,112) )
	draw.RoundedBox( 8, 11, 11, 198, 68, Color(32,36,40) )
	local time = timeFormat( GetGlobalFloat("SRP_Time") * 60 )
	draw.SimpleText( time, "ClockFace", 110, 45, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )

	local class = math.max( GetGlobalInt("SRP_Class"), 1 )
	local txt
	local curClass = srp_classes.events[class]

	txt = srp_classes.getClassInfo( curClass )
	draw.SimpleText( txt[2], "ClockScheduleLarge", 221, 16, Color(0,0,0, 150), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
	draw.SimpleText( txt[2], "ClockScheduleLarge", 220, 15, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
	draw.SimpleText( txt[3] or "Тик-так, тик-так", "ClockScheduleMedium", 221, 71, Color(0,0,0, 150), TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM )
	draw.SimpleText( txt[3] or "Тик-так, тик-так", "ClockScheduleMedium", 220, 70, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM )

	if srp_classes.lastClass ~= curClass then
		srp_classes.lastClass = curClass
		if curClass.ring then ring() end
	end

	class = class < #srp_classes.events and (class + 1) or 1
	txt = srp_classes.getClassInfo( srp_classes.events[class] )
	draw.SimpleText( timeFormat(txt[1] * 60) .. " -", "ClockScheduleSmallTime", 21, 96, Color(0,0,0, 150), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
	draw.SimpleText( timeFormat(txt[1] * 60) .. " -", "ClockScheduleSmallTime", 20, 95, Color(255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
	draw.SimpleText( txt[2], "ClockScheduleSmall", 101, 96, Color(0,0,0, 150), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
	draw.SimpleText( txt[2], "ClockScheduleSmall", 100, 95, Color(255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )

	class = class < #srp_classes.events and (class + 1) or 1
	txt = srp_classes.getClassInfo( srp_classes.events[class] )
	draw.SimpleText( timeFormat(txt[1] * 60) .. " -", "ClockScheduleSmallTime", 21, 121, Color(0,0,0, 150), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
	draw.SimpleText( timeFormat(txt[1] * 60) .. " -", "ClockScheduleSmallTime", 20, 120, Color(255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
	draw.SimpleText( txt[2], "ClockScheduleSmall", 101, 121, Color(0,0,0, 150), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
	draw.SimpleText( txt[2], "ClockScheduleSmall", 100, 120, Color(255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )

end)

net.Receive( "srp_classes.updateClassInfo", function( len )

	local schedule = net.ReadTable()
	for i, classInfo in ipairs( schedule ) do
		srp_classes.setClassInfo( i, classInfo[1], classInfo[2] )
	end

end)
