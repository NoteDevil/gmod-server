if SERVER then
	AddCSLuaFile("srp_inventory/sh_inventory.lua")

	include("srp_inventory/sh_inventory.lua")
	include("srp_inventory/sv_inventory.lua")
else
	include("srp_inventory/sh_inventory.lua")
end

local files = file.Find("srp_inventory/items/" .. "*", "LUA")

for _, file_ in pairs(files) do
	if SERVER then
		AddCSLuaFile("srp_inventory/items/"..file_)
		include("srp_inventory/items/"..file_)
	else
		include("srp_inventory/items/"..file_)
	end
end
	