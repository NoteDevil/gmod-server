include "shared.lua"

local function timeFormat( time )

    local m = math.floor( time ) % 60
    local h = math.floor( time / 60 ) % 24

    return string.format( "%02i:%02i", h, m )

end

surface.CreateFont( "list_ClassTime", {
	font = "Consolas",
	size = 28,
	weight = 300,
	antialias = true,
	entended = true,
})

surface.CreateFont( "list_ClassName", {
	font = "Arial",
	size = 22,
	weight = 500,
	antialias = true,
	entended = true,
})

local pencil = Material( "icon16/pencil.png" )
local clock = Material( "icon16/clock.png" )

function ENT:InitPanel( pnl, dpu )

	local function scale( val )
		return math.Round( val / 5 * dpu )
	end

	local l = vgui.Create( "DLabel", pnl )
	l:SetSize( 350, 40 )
	l:SetPos( 0, 5 )
	l:CenterHorizontal()
	l:SetFont( "list_ClassName" )
	l:SetText( "Расписание" )
	l:SetContentAlignment( 5 )

	for i, class in ipairs( srp_classes.schedule ) do
		local p = vgui.Create( "DButton", pnl )
		p:SetSize( 350, 40 )
		p:SetPos( 0, i * 50  )
		p:CenterHorizontal()
		p:SetText("")
		p.Paint = function( self, w, h )
			surface.DisableClipping( true )

			local event, highlight = srp_classes.events[GetGlobalInt("SRP_Class")], false
			local y, col = -3, Color(83,104,112)
			if self.Depressed then
				y = -2
			elseif self.Hovered then
				y = -5
				highlight = true
				if LocalPlayer():CanEditSchedule() then
					surface.SetMaterial( pencil )
					surface.SetDrawColor( Color(255,255,255) )
					surface.DrawTexturedRect( w + 10, h/2 - 8, 16, 16 )
				end
			end

			if event[2] == class then
				surface.SetMaterial( clock )
				surface.SetDrawColor( Color(255,255,255) )
				surface.DrawTexturedRect( -26, h/2 - 8, 16, 16 )
				col = Color(102,98,75)
			end

			draw.RoundedBox( 4, 0, 0, w, h, col )
			draw.RoundedBox( 4, 0, 0, w, h, Color(0,0,0, 100) )
			draw.RoundedBox( 4, 0, y, w, h, col )

			if highlight then
				draw.RoundedBox( 4, 0, y, w, h, Color(255,255,255, 10) )
			end

			draw.SimpleText( timeFormat( class[0] * 60 ), "list_ClassTime", 10, h / 2 + y, Color(255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
			draw.SimpleText( class[1], "list_ClassName", w - 10, h / 2 + y, Color(255,255,255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER )

			surface.DisableClipping( false )
		end
		p.DoClick = function( self )
			if not LocalPlayer():CanEditSchedule() then return end
			gui.EnableScreenClicker( true )

			local m = DermaMenu()
			m:AddOption( "Нет урока", function()
				net.Start( "srp_classes.setClassInfo" )
					net.WriteUInt( i, 8 )
					net.WriteUInt( 0, 8 )
				net.SendToServer()
			end)
			m:AddSpacer()

			for i2, v in ipairs( SRP_Diary.Subjects ) do
				m:AddOption( v, function()
					net.Start( "srp_classes.setClassInfo" )
						net.WriteUInt( i, 8 )
						net.WriteUInt( i2, 8 )
					net.SendToServer()
				end)
			end
			m:Center()
			m:Open()

			gui.EnableScreenClicker( false )
		end
	end

end
