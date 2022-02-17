hook.Add("PlayerSpawnedProp", "SRP_NoHugeProps", function(ply, mdl, ent)

    if IsValid(ent) then
        local mins, maxs = ent:GetModelBounds()
        local size = maxs - mins
        local vol = size.x * size.y * size.z
        if vol > 1000000 and not ply:IsAdmin() then
            ent:Remove()
            DarkRP.notify(ply, NOTIFY_ERROR, 3, "Этот объект слишком большой")
        end
    end

end)