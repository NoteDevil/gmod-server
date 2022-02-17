if SERVER then
	AddCSLuaFile("srp_savezones/sh_srp_savezones.lua")
	AddCSLuaFile("srp_savezones/cl_srp_savezones.lua")

	include("srp_savezones/sh_srp_savezones.lua")
	include("srp_savezones/sv_srp_savezones.lua")
else
	include("srp_savezones/sh_srp_savezones.lua")
	include("srp_savezones/cl_srp_savezones.lua")
end