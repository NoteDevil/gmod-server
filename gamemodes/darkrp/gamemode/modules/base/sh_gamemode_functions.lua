function GM:SetupMove(ply, mv, cmd)
    if ply:isArrested() then
        mv:SetMaxClientSpeed(self.Config.arrestspeed)
    end
    return self.Sandbox.SetupMove(self, ply, mv, cmd)
end

function GM:StartCommand(ply, usrcmd)
    -- Used in arrest_stick and unarrest_stick but addons can use it too!
    local wep = ply:GetActiveWeapon()
    if IsValid(wep) and isfunction(wep.startDarkRPCommand) then
        wep:startDarkRPCommand(usrcmd)
    end
end

function GM:OnPlayerChangedTeam(ply, oldTeam, newTeam)
    if RPExtraTeams[newTeam] and RPExtraTeams[newTeam].OnPlayerChangedTeam then
        RPExtraTeams[newTeam].OnPlayerChangedTeam(ply, oldTeam, newTeam)
    end

    if CLIENT then return end

    local agenda = ply:getAgendaTable()

    -- Remove agenda text when last manager left
    if agenda and agenda.ManagersByKey[oldTeam] then
        local found = false
        for man, _ in pairs(agenda.ManagersByKey) do
            if team.NumPlayers(man) > 0 then found = true break end
        end
        if not found then agenda.text = nil end
    end

    ply:setSelfDarkRPVar("agenda", agenda and agenda.text or nil)
end

hook.Add("loadCustomDarkRPItems", "CAMI privs", function()
    CAMI.RegisterPrivilege{
        Name = "DarkRP_SeeEvents",
        MinAccess = "admin"
    }

    CAMI.RegisterPrivilege{
        Name = "DarkRP_GetAdminWeapons",
        MinAccess = "admin"
    }

    CAMI.RegisterPrivilege{
        Name = "DarkRP_SetDoorOwner",
        MinAccess = "admin"
    }

    CAMI.RegisterPrivilege{
        Name = "DarkRP_ChangeDoorSettings",
        MinAccess = "superadmin"
    }

    CAMI.RegisterPrivilege{
        Name = "DarkRP_AdminCommands",
        MinAccess = "admin"
    }

    CAMI.RegisterPrivilege{
        Name = "DarkRP_SetMoney",
        MinAccess = "superadmin"
    }

    CAMI.RegisterPrivilege{
        Name = "DarkRP_SetLicense",
        MinAccess = "superadmin"
    }

    for k,v in pairs(RPExtraTeams) do
        if not v.vote or v.admin and v.admin > 1 then continue end

        local toAdmin = {[0] = "admin", [1] = "superadmin"}
        CAMI.RegisterPrivilege{
            Name = "DarkRP_GetJob_" .. v.command,
            MinAccess = toAdmin[v.admin or 0]-- Add privileges for the teams that are voted for
        }
    end
end)

--[[---------------------------------------------------------
   Bring those back from Sandbox
-----------------------------------------------------------]]
function GM:UpdateAnimation( ply, velocity, maxseqgroundspeed )

	local len = velocity:Length()
	local movement = 1.0

	if ( len > 0.2 ) then
		movement = ( len / maxseqgroundspeed )
    end
    
    local scale = ply:GetModelScale()
    if scale ~= 1 then
        movement = movement / scale
    end

	local rate = math.min( movement, 2 )

	-- if we're under water we want to constantly be swimming..
	if ( ply:WaterLevel() >= 2 ) then
		rate = math.max( rate, 0.5 )
	elseif ( !ply:IsOnGround() && len >= 1000 ) then
		rate = 0.1
	end

	ply:SetPlaybackRate( rate )

	if ( ply:InVehicle() ) then

		local Vehicle = ply:GetVehicle()
		
		-- We only need to do this clientside..
		if ( CLIENT ) then
			-- This is used for the 'rollercoaster' arms
			local Velocity = Vehicle:GetVelocity()
			local fwd = Vehicle:GetUp()
			local dp = fwd:Dot( Vector( 0, 0, 1 ) )
			local dp2 = fwd:Dot( Velocity )

			ply:SetPoseParameter( "vertical_velocity", ( dp < 0 and dp or 0 ) + dp2 * 0.005 )

			-- Pass the vehicles steer param down to the player
			local steer = Vehicle:GetPoseParameter( "vehicle_steer" )
			steer = steer * 2 - 1 -- convert from 0..1 to -1..1
			if ( Vehicle:GetClass() == "prop_vehicle_prisoner_pod" ) then steer = 0 ply:SetPoseParameter( "aim_yaw", math.NormalizeAngle( ply:GetAimVector():Angle().y - Vehicle:GetAngles().y - 90 ) ) end
			ply:SetPoseParameter( "vehicle_steer", steer )

		end
		
	end

	if ( CLIENT ) then
		GAMEMODE:GrabEarAnimation( ply )
		GAMEMODE:MouthMoveAnimation( ply )
	end

end

function GM:GrabEarAnimation( ply )

	ply.ChatGestureWeight = ply.ChatGestureWeight or 0

	-- Don't show this when we're playing a taunt!
	if ( ply:IsPlayingTaunt() ) then return end

	if ( ply:IsTyping() ) then
		ply.ChatGestureWeight = math.Approach( ply.ChatGestureWeight, 1, FrameTime() * 5.0 )
	else
		ply.ChatGestureWeight = math.Approach( ply.ChatGestureWeight, 0, FrameTime() * 5.0 )
	end

	if ( ply.ChatGestureWeight > 0 ) then
	
		ply:AnimRestartGesture( GESTURE_SLOT_VCD, ACT_GMOD_IN_CHAT, true )
		ply:AnimSetGestureWeight( GESTURE_SLOT_VCD, ply.ChatGestureWeight )
	
	end

end
