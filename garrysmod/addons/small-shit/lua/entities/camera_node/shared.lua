
-----------------------------------------------------
ENT.Type = "anim"  
ENT.Base = "base_gmodentity"  
  
if SERVER then   
AddCSLuaFile("shared.lua")

function ENT:Initialize()   
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_NONE )
	self:PhysicsInitSphere(1)
	self:GetPhysicsObject():Wake()
	self:GetPhysicsObject():EnableCollisions( false )
	self:GetPhysicsObject():EnableGravity( false )
	self:GetPhysicsObject():EnableMotion( true )
	self:DrawShadow(false)
	self:SetNoDraw(true)
	self:SetNotSolid(true)
end

end