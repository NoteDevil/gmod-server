local mat = Material("bully/credits")

local to_replace = {
	{ material = Material("BULLY/LOGO"), replacement = "school666/logo_1" },
	{ material = Material("bully/credits"), replacement = "school666/logo_1" },
	-- { material = Material("BULLY/DIRT_01"), replacement = "BULLY/GRASS_01" },
	-- { material = Material("BULLY/GRASS_01"), replacement = "BULLY/GRASS_01" },
	-- { material = Material("BULLY/WALL_21"), replacement = "school666/hd_floor" },
}
hook.Add("PlayerIsLoaded", "OverrideShittyLogos.PlayerIsLoaded", function()
	mat:SetInt("$alpha", 0)
	for k,v in ipairs(to_replace) do
		v.material:SetTexture("$basetexture", v.replacement)
	end
end)