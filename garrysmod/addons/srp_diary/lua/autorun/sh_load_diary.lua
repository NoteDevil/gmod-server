if SERVER then
	AddCSLuaFile("srp_diary/sh_srp_diary.lua")
	include("srp_diary/sh_srp_diary.lua")
	include("srp_diary/sv_srp_diary.lua")
else
	include("srp_diary/sh_srp_diary.lua")
end