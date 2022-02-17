AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( "shared.lua" )

util.AddNetworkString("NotePad.OpenMenu")
util.AddNetworkString("NotePad.SaveText")

function ENT:Initialize()
	self:SetModel( "models/school/notepad.mdl" )
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetUseType(SIMPLE_USE)
	local phys = self:GetPhysicsObject()
	phys:Wake()

	self.notepadText = ""
	self:SetNWString("notepadName", "Тетрадь")
end

function ENT:Use( Name, activator )

	if self:GetVelocity():LengthSqr() > 1 then return end

	local owner = self:Getowning_ent()
	local bOwner = false

	if owner == activator then
		bOwner = true
		self.np_ownerUsing = true
		self:SetCantMove(true)
	end

	net.Start("NotePad.OpenMenu")
	net.WriteString(self.notepadText)
	net.WriteBool(bOwner)
	net.WriteEntity(self)
	net.Send(activator)

end

function ENT:SetCantMove( val )

	local phys = self:GetPhysicsObject()
	if not IsValid(phys) then return end 

	phys:EnableMotion(not val)

end

net.Receive("NotePad.SaveText", function(len, ply)

	local notepadText = net.ReadString()
	local notepadName = string.sub(net.ReadString(), 1, 40)
	local ent = net.ReadEntity()
	if ent:GetClass() != "ent_notepad" then return end
	local owner = ent:Getowning_ent()
	if owner != ply then return end

	ent.notepadText = notepadText
	ent:SetNWString("notepadName", notepadName)

	ent.np_ownerUsing = nil
	ent:SetCantMove(false)

end)

hook.Add("PlayerDisconnected", "NotePad", function(ply)

	for i,v in ipairs(ents.FindByClass('ent_notepad')) do
		if v.np_ownerUsing == ply then
			v.np_ownerUsing = nil
			v:SetCantMove(false)
		end
	end

end)
