timer.Create( "physgunColour", 0.1, 0, function()
	for _,ply in pairs( player.GetAll() ) do
		if ply.physgunColour then
			local col = HSVToColor( CurTime() % 9 * 40, 1, 1 )
			ply:SetWeaponColor( Vector( col.r / 255, col.g / 255, col.b / 255 ) )
		end
	end
end )
