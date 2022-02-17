AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( "shared.lua" )

util.AddNetworkString("SRP_Dumpster.StartSearching")
util.AddNetworkString("SRP_Dumpster.StopSearching")

function ENT:Initialize()
	self:SetModel( "models/props_junk/TrashDumpster01a.mdl" )
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetUseType(SIMPLE_USE)
	local phys = self:GetPhysicsObject()
	self.CurUser = nil
	self.delay = 10
end

function ENT:StopSearching()
	net.Start("SRP_Dumpster.StopSearching")
	net.Send(self.CurUser)
	self.CurUser = nil
end

function ENT:StartSearching(ply)
	net.Start("SRP_Dumpster.StartSearching")
	net.WriteFloat(self.delay)
	net.Send(ply)
	self.CurUser = ply
	self.OverTime = CurTime() + self.delay
end

function ENT:Use( name, ply )
	if ply.SearchDmpCooldown and ply.SearchDmpCooldown > CurTime() then DarkRP.notify(ply, 1, 4, "Подождите еще "..math.ceil(ply.SearchDmpCooldown-CurTime()).." секунд.") return end
	if self.CurUser == ply then DarkRP.notify(ply, 0, 4, "Вы уже обыскиваете мусорку.") return end
	if self.CurUser then DarkRP.notify(ply, 1, 4, "Мусорка уже кем-то используется.") return end
	self:StartSearching(ply)
end

function ENT:SpawnDetail(name, pos)
	local ent = ents.Create("ent_cr_"..name)
	ent:SetPos(pos)
	ent:Spawn()
	local phys = ent:GetPhysicsObject()
	phys:Wake()
end

function ENT:GenerateRandomDetail()
	local rand = math.random(1, 5)
	local spawn_pos = self:GetPos()+self:GetUp()*40
	if rand == 1 then
		DarkRP.createMoneyBag(spawn_pos, math.random(1,150))
	elseif rand == 2 then
		self:SpawnDetail("iron", spawn_pos)
	elseif rand == 3 then
		self:SpawnDetail("wood", spawn_pos)
	elseif rand == 4 then
		self:SpawnDetail("glass", spawn_pos)
	elseif rand == 5 then
		self:SpawnDetail("gate", spawn_pos)
	end
	self.CurUser.SearchDmpCooldown = CurTime() + 120
	self:StopSearching()
end

function ENT:Think()
	if not self.CurUser then return end

	if self.CurUser:GetEyeTrace().Entity ~= self then
		return self:StopSearching()
	end

	if self.CurUser:GetPos():DistToSqr(self:GetPos()) > 75*75 then
		return self:StopSearching()
	end

	if self.OverTime < CurTime() then
		self:GenerateRandomDetail()
	end
end
