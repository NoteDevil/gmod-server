if SERVER then
	include "srp_notifications/server.lua"
	AddCSLuaFile "srp_notifications/client.lua"
else
	include "srp_notifications/client.lua"
end
