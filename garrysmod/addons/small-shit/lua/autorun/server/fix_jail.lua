hook.Add( "playerUnArrested", "srp_fix_jail", function( ply, actor )

	if ply:InVehicle() then ply:ExitVehicle() end

    if ply.Sleeping then
        DarkRP.toggleSleep(ply, "force")
    end

    gamemode.Call("PlayerLoadout", ply)
    if GAMEMODE.Config.telefromjail then
		local pos = DarkRP.findEmptyPos( Vector(-2254, 2557, 56), {ply}, 600, 30, Vector(16, 16, 64))
        timer.Simple(0, function() if IsValid(ply) then ply:SetPos(pos) end end)
    end

    timer.Remove(ply:SteamID64() .. "jailtimer")
    DarkRP.notifyAll(0, 4, DarkRP.getPhrase("hes_unarrested", ply:Name()))

	return true -- disable default behaviour

end)

-- make admins not arrestable
hook.Add("canArrest", "srp_no_admin_arrest", function(arrester, arrestee)

    if arrestee:Team() == TEAM_ADMIN then
        return false, "Нельзя арестовывать администраторов!"
    end

end)
