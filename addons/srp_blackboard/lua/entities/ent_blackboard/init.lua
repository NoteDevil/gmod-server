AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( "shared.lua")

util.AddNetworkString("BlackBoard.OpenMenu")
util.AddNetworkString("BlackBoard.SaveText")

function ENT:Initialize()
	self:SetModel( "models/blackboard/blackboard.mdl" )

    //no movement
  self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid( SOLID_VPHYSICS )   
	// Wake the physics object up
	
	self:SetUseType( SIMPLE_USE )
	self:SetText("")
end

function ENT:Use(name, ply)
	net.Start("BlackBoard.OpenMenu")
	net.WriteEntity(self)
	net.Send(ply)
end

net.Receive("BlackBoard.SaveText", function(len, ply)
	local ent = net.ReadEntity()
	local text = net.ReadString()
	if ent:GetClass() != "ent_blackboard" then return end
	ent:SetText(text)
end)