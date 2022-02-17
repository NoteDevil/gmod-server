hook.Add("PlayerShouldTakeDamage", "SRP_SaveZone.PlayerShouldTakeDamage", function(victim, attacker)
	if not victim:IsPlayer() then return end
	if SRP_SaveZones:PlayerInZone(victim) then 
		DarkRP.notify(attacker, 1, 4, "Нельзя наносить дамаг в безопасной зоне.")
		return false
	end
end)

hook.Add("PlayerSpawnProp", "SRP_SaveZone.PlayerSpawnProp", function(ply, model)
	if ply:IsSuperAdmin() then return true end
	if SRP_SaveZones:PlayerInZone(ply) then 
		DarkRP.notify(ply, 1, 4, "Нельзя спавнить пропы в безопасной зоне.")
		return false
	end
end)

hook.Add("hungerUpdate", "SRP_SaveZones.hungerUpdate", function(ply, value)
	if SRP_SaveZones:PlayerInZone(ply) then 
		return true
	end
end)