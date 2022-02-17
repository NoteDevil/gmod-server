AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( "shared.lua" )

util.AddNetworkString("SRP_DetailBox.Craft")
util.AddNetworkString("SRP_DetailBox.OpenMenu")

function ENT:Initialize()
	self:SetModel( "models/props_c17/SuitCase001a.mdl" )
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetUseType(SIMPLE_USE)
	self:SetTrigger(true)
	local phys = self:GetPhysicsObject()
	phys:Wake()
	self:SetNWInt("Iron", 0)
	self:SetNWInt("Glass", 0)
	self:SetNWInt("Wood", 0)
	self:SetNWInt("Gate", 0)
end

function ENT:AddDetail(name, count)
	self:SetNWInt(name, self:GetNWInt(name) + count)
end

function ENT:Use( name, ply )
	net.Start("SRP_DetailBox.OpenMenu")
	net.WriteEntity(self)
	net.Send(ply)
end

function ENT:Craft(item)
	local item_tbl = SRP_Crafting.Recipes[item]
	for k,v in pairs(item_tbl.recipe) do
		self:AddDetail(k, -v)
	end
	if item_tbl.type == "weapon" then
		local ent = ents.Create("spawned_weapon")
		ent:SetWeaponClass(item)
		ent:Setamount(1)
		ent:SetModel(item_tbl.model)
		ent:SetPos(self:GetPos()+Vector(0,0,30))
		ent:Spawn()
	end
end

function ENT:Touch(ent)
	if ent.touched then return end
	if not ent.item then return end
	ent.touched = true
	self:AddDetail(ent.item, 1) 
	timer.Simple(0, function() ent:Remove() end)
end

net.Receive("SRP_DetailBox.Craft", function(len, ply)
	local ent = net.ReadEntity()
	local item = net.ReadString()
	if not IsValid(ent) then return end
	if ent:GetClass() ~= "ent_detailbox" then return end
	ent:Craft(item)
end)
