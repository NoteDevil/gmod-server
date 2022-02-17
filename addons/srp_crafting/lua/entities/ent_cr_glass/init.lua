AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( "shared.lua" )

local models = {
	"models/props_junk/garbage_glassbottle001a_chunk01.mdl",
	"models/props_junk/glassbottle01a_chunk02a.mdl",
	"models/props/cs_militia/skylight_glass_p10.mdl"
}

function ENT:Initialize()
	self:SetModel( table.Random(models) )
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetTrigger(true)
	self.item = "Glass"
	local phys = self:GetPhysicsObject()
	phys:SetMass(10)
	
	self.lastPos = self:GetPos()
	self.nextThink = CurTime() + 1
end

function ENT:Think()

	if self.nextThink > CurTime() then return end

	self.sleepTime = self.sleepTime or 0
	if self:GetPos() ~= self.lastPos then
		self.sleepTime = 0
	else
		self.sleepTime = self.sleepTime + 1
		if self.sleepTime > 120 then
			self:Remove()
		end
	end

	self.lastPos = self:GetPos()
	self.nextThink = CurTime() + 1

end
