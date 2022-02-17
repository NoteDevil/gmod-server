function CollisionBoxOutsideMap( pPos, minBound, maxBound )
	if not util.IsInWorld( Vector( pPos.x+minBound.x, pPos.y+minBound.y, pPos.z+minBound.z ) ) then return true end
	if not util.IsInWorld( Vector( pPos.x-minBound.x, pPos.y+minBound.y, pPos.z+minBound.z ) ) then return true end
	if not util.IsInWorld( Vector( pPos.x-minBound.x, pPos.y-minBound.y, pPos.z+minBound.z ) ) then return true end
	if not util.IsInWorld( Vector( pPos.x+minBound.x, pPos.y-minBound.y, pPos.z+minBound.z ) ) then return true end
	
	if not util.IsInWorld( Vector( pPos.x+maxBound.x, pPos.y+maxBound.y, pPos.z+maxBound.z ) ) then return true end
	if not util.IsInWorld( Vector( pPos.x-maxBound.x, pPos.y+maxBound.y, pPos.z+maxBound.z ) ) then return true end
	if not util.IsInWorld( Vector( pPos.x-maxBound.x, pPos.y-maxBound.y, pPos.z+maxBound.z ) ) then return true end
	if not util.IsInWorld( Vector( pPos.x+maxBound.x, pPos.y-maxBound.y, pPos.z+maxBound.z ) ) then return true end
	
	for i=0.2, 0.8, 0.2 do
		if not util.IsInWorld( Vector( pPos.x, pPos.y, pPos.z+(maxBound.z+minBound.z)*i ) ) then return true end
	end
	return false
end


function CollisionBoxContainsProps( pPos, minBound, maxBound )
	lowerBoxPos = Vector()
	lowerBoxPos:Set(pPos)
	lowerBoxPos:Add(minBound)
	upperBoxPos = Vector()
	upperBoxPos:Set(pPos)
	upperBoxPos:Add(maxBound)
	
	t = ents.FindInBox(lowerBoxPos, upperBoxPos)
	for key,value in pairs(t) do
		colliding = value:GetSolid()==SOLID_VPHYSICS
		-- print(value:GetSolid(), colliding, value)
		if colliding then return true end
	end
	return false
end


local function FindNewPos( ply , try )
	local minBound, maxBound = ply:GetCollisionBounds()
	local oldZVelo = ply:GetVelocity().z
	ply:SetVelocity( Vector( 0, 0, 250 ) )
	
	timer.Simple( 0.1, function()
		local absZdelta = math.abs(  (ply:GetVelocity().z-oldZVelo) );
		if absZdelta>30 then
			DarkRP.notify( ply, NOTIFY_ERROR, 3, "Ну вот и все" )
			return
		end
		
		-- PLAYER IS STUCK...
		local pos = ply:GetPos()
		if try>0 then
			pos:Add(Vector(0,0,30))     -- ...diving up undetectable displacement-maps
			ply:SetPos(pos)
		end
		local testPos
		for i=15, 10550.0, 0.1 do
			testPos = Vector( math.random(-i, i)+pos.x, math.random(-i, i)+pos.y, math.random(-i, i)+pos.z)
			if not CollisionBoxOutsideMap( testPos, minBound, maxBound ) then
				if not CollisionBoxContainsProps( testPos, minBound, maxBound ) then
					ply:SetPos(testPos)
					if try<5 then
						try = try + 1						
						FindNewPos( ply , try )
					end
					return
				end
			end
		end
		DarkRP.notify( ply, NOTIFY_ERROR, 3, "Невозможно вытащить тебя отсюда" )
	end)
end

local function UnStuck( ply )
	if ply:GetMoveType() == MOVETYPE_OBSERVER or ply:InVehicle() or not ply:Alive() then
		DarkRP.notify( ply, NOTIFY_ERROR, 3, "Невозможно вытащить тебя отсюда" )
		return
	end
	
	FindNewPos( ply , 0 )
end

concommand.Add("srp_unstuck", function( ply, args )

	ply.nextUnstuck = ply.nextUnstuck or 0
	if CurTime() < ply.nextUnstuck then
		DarkRP.notify( ply, NOTIFY_ERROR, 3, "Нужно подождать еще " .. math.ceil(ply.nextUnstuck - CurTime()) .. "с." )
		return
	end

	UnStuck( ply )
	ply.nextUnstuck = CurTime() + 20

end)
