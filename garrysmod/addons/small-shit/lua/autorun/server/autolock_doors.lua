local doors = {
	-- Prison
	2271,
	2272,
	2274,
	2275,
	2276,
	2278,
	2279,
	-- Weired door
	1993,
	1994,
}

hook.Add("InitPostEntity", "CloseDoors.InitPostEntity", function()
	for k,v in ipairs(doors) do
		local ent = ents.GetMapCreatedEntity(v)
		if not IsValid(ent) then continue end
		ent:Fire("Lock", "", 0)
	end
end)