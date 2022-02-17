if SERVER then
	AddCSLuaFile("srp_dumpsters/sh_srp_dumpsters.lua")
	include("srp_dumpsters/sh_srp_dumpsters.lua")
	include("srp_dumpsters/sv_srp_dumpsters.lua")
else
	include("srp_dumpsters/sh_srp_dumpsters.lua")
end