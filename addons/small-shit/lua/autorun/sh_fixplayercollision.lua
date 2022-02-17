timer.Create("srp_updateCollisions", 3, 0, function()

    for k,v in pairs( player.GetAll() ) do
        if v:GetCollisionGroup() ~= COLLISION_GROUP_WEAPON then
            v:SetCollisionGroup( COLLISION_GROUP_WEAPON )
        end
    end

end)