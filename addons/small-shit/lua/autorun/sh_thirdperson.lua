local third_person_state = false

hook.Add( "HUDShouldDraw", "ThirdPerson.HUDShouldDraw", function( name )
	if name == "CHudCrosshair" then return !third_person_state end
end )

local function check_player_valid()
	local ply = LocalPlayer()
	if not ply:Alive() or ply:IsRagdoll() or ply:InVehicle() then
		return false
	else
		return true
	end
end

hook.Add("CalcView", "ThirdPerson.CalcView", function(ply, pos, angles, fov)
	if third_person_state and ply:Alive() and not IsValid(ply:GetNWEntity("ScriptedVehicle")) then
		local view = {}
		view.origin = pos-(angles:Forward()*50)-(angles:Right()*-22)-(angles:Up()*5)
		view.angles = angles
		view.fov = fov

		local traceData = {}
		traceData.start = pos
		traceData.endpos = traceData.start + angles:Forward() * -72
		traceData.endpos = traceData.endpos + angles:Right() * 24
		traceData.endpos = traceData.endpos + angles:Up() * 5
		traceData.filter = ply

		local trace = util.TraceLine(traceData)

		pos = trace.HitPos

		if trace.Fraction < 1.0 then
			pos = pos + trace.HitNormal * 5
		end

		view.origin = pos

 		return view

	end
end)

hook.Add("ShouldDrawLocalPlayer", "ThirdPerson.ShouldDrawLocalPlayer", function()
		return third_person_state
end)

usermessage.Hook("ThirdPerson.Toggle", function(ply, cmd, args)
	if not third_person_state then
		third_person_state = true
	else
		third_person_state = false
	end
end)


hook.Add("HUDPaint","Crosshair",function()
	local ply = LocalPlayer()
	local p = ply:GetEyeTrace().HitPos:ToScreen()
	local x,y = p.x, p.y
	if check_player_valid() then
		if third_person_state then
			surface.SetDrawColor( 255, 0, 0, 255 )

			surface.DrawLine( x-5, y, x+5, y )
			surface.DrawLine( x, y-5, x, y+5 )
		end
	end
end )

if SERVER then

	hook.Add("ShowHelp", "ThirdPerson.ShowHelp", function(ply)
		umsg.Start( "ThirdPerson.Toggle", ply )
	    umsg.End()
	end)
end
