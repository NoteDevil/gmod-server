AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( "shared.lua" )

local models = {
	"models/props/cs_office/computer_caseb_p2a.mdl",
	"models/props/cs_office/computer_caseb_p3a.mdl",
	"models/props/cs_office/computer_caseb_p6a.mdl"
}

function ENT:Initialize()
	self:SetModel( table.Random(models) )
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetTrigger(true)
	self.item = "Gate"

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
