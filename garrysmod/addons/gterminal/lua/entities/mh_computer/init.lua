AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

ENT.SeizeReward = 1500

function ENT:Initialize()
	self:SetModel("models/props_lab/monitor01a.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	local phys = self:GetPhysicsObject()
	phys:Wake()
	
	self:SetUseType(SIMPLE_USE)

	self.damage = 10
	
end

function ENT:Use(ply)
	ply:DrawViewModel(false)

	net.Start("manolisHackingUse")
		net.WriteEntity(self)
	net.Send(ply)
end

function ENT:OnTakeDamage(dmg)
	self.damage = self.damage - dmg:GetDamage()

	if (self.damage <= 0) then
		local effectdata = EffectData()
		effectdata:SetOrigin(self:GetPos())
		effectdata:SetMagnitude(2)
		effectdata:SetScale(2)
		effectdata:SetRadius(3)
		util.Effect("Sparks", effectdata)
		self:Remove()
	end
end