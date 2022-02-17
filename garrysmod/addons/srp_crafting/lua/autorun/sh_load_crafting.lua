if SERVER then
	AddCSLuaFile("srp_crafting/sh_crafting.lua")

	include("srp_crafting/sh_crafting.lua")
	include("srp_crafting/sv_crafting.lua")
else
	include("srp_crafting/sh_crafting.lua")
end