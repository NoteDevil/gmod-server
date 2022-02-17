srp_classes = srp_classes or {}

if SERVER then
	AddCSLuaFile("srp_classes/shared.lua")
	AddCSLuaFile("srp_classes/client.lua")

	include("srp_classes/shared.lua")
	include("srp_classes/server.lua")
else
	include("srp_classes/shared.lua")
	include("srp_classes/client.lua")
end
