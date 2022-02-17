
------------------------------------------------------------
------------------------CONFIG------------------------------

ENT.LockPower = 0.3  -- 0.15 normal,  5 - so fucking easy to break door
ENT.MinTime = 0.1		  -- You cant break door before MinTime
ENT.Color = Color(100,100,100,255) -- color

AddEntity("Улучшенный замок", {					-- edit name like "Easy lock
	ent = "normal_lock",			-- edit class name of lock, must be like folder name
	model = "models/custom/dlock.mdl",	-- no edit here
	price = 2500,							-- price of the lock
	max = 1,								-- maximum lock for player --
	cmd = "buy_normal_lock"					-- unique chat command for buy this
})
------------------------------------------------------------
------------------------------------------------------------


AddCSLuaFile()
if SERVER then
	include("sv_init.lua")
end

ENT.Type = "anim"
ENT.PrintName = "I'm easy lock"
ENT.Author = "CustomHQ"
ENT.Spawnable = false
ENT.IsDoorLock = true
ENT.AutomaticFrameAdvance = true 

function ENT:SetupDataTables()
	self:NetworkVar("Int",0,"price")
	self:NetworkVar("Entity",1,"owning_ent")
end


if CLIENT then
	function ENT:Draw()
		self:DrawModel()
	end
end

 