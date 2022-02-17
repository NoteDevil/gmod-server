if SERVER then
	AddCSLuaFile("srp_groups/sh_srp_groups.lua")

	include("srp_groups/sh_srp_groups.lua")
	include("srp_groups/sv_srp_groups.lua")
else
	include("srp_groups/sh_srp_groups.lua")
end