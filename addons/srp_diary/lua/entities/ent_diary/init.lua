AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( "shared.lua" )

util.AddNetworkString("SRP_Diary.OpenMenu")

function ENT:Initialize()
	self:SetModel( "models/school/notepad.mdl" )
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetUseType(SIMPLE_USE)
	local phys = self:GetPhysicsObject()
	phys:Wake()

	self.sleepTime = 0
	self.nextThink = CurTime() + 1
	self.lastPos = self:GetPos()

	self:SetSkin(1)
end

function ENT:Use( Name, activator )
	local owner = self:Getowning_ent()

	if not IsValid(owner) then DarkRP.notify(activator, 1, 4, "Дневник недоступен.") return end 
	net.Start("SRP_Diary.OpenMenu")
	net.WriteEntity(owner)
	net.WriteTable(owner.marks)
	net.Send(activator)
end

function ENT:Think()

	if self.nextThink > CurTime() then return end

	if self:GetPos() ~= self.lastPos then
		self.sleepTime = 0
	else
		self.sleepTime = self.sleepTime + 1
		if self.sleepTime > 30 then
			local owner = self:Getowning_ent()
			if IsValid( owner ) then
				DarkRP.notify( owner, NOTIFY_GENERIC, 3, "Твой дневник снова у тебя" )
			end
			self:Remove()
		end
	end

	self.lastPos = self:GetPos()
	self.nextThink = CurTime() + 1

end
