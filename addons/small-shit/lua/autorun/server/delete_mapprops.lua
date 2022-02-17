local ents_list = {
	1236,
	1237,
	1238,
	2217,
	2218
}

local function DeleteMapProps()
	for k,v in pairs(ents_list) do
		local ent = ents.GetMapCreatedEntity(v)
		if IsValid(ent) then
			ent:Remove()
		end
	end
end
hook.Add("InitPostEntity", "DeleteMapProps.InitPostEntity", DeleteMapProps)
hook.Add("PostCleanupMap", "DeleteMapProps.PostCleanupMap", DeleteMapProps)