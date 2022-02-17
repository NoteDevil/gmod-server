AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( "shared.lua" )

util.AddNetworkString("SRP_Library.OpenMenu")

local models = {
	"models/fo3/misc/bookchinese_0.mdl",
	"models/fo3/misc/bookdcjournal_0.mdl",
	"models/fo3/misc/bookduckandcover_0.mdl",
	"models/fo3/misc/bookelectronics_0.mdl",
	"models/fo3/misc/bookflamethrower_0.mdl",
	"models/fo3/misc/bookgrognak_0.mdl",
	"models/fo3/misc/bookguns.mdl",
	"models/fo3/misc/bookjunkton.mdl",
	"models/fo3/misc/booklying_0.mdl",
	"models/fo3/misc/bookofscience_0.mdl",
	"models/fo3/misc/booktesla01_0.mdl",
	"models/fo3/misc/booktumbler_0.mdl",
	"models/fo3/misc/pugilism_0.mdl",
}

function ENT:Initialize()
	self:SetModel( table.Random(models) )
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetUseType(SIMPLE_USE)
	local phys = self:GetPhysicsObject()
	phys:Wake()
	self:SetPos(self:GetPos()+Vector(0,0,40))
	self:SetTitle(SRP_Library.Books[SRP_Library.LastBook][1])
	self:SetLink(SRP_Library.Books[SRP_Library.LastBook][2])
	if SRP_Library.Books[SRP_Library.LastBook+1] then
		SRP_Library.LastBook = SRP_Library.LastBook + 1
	else
		SRP_Library.LastBook = 1
	end
end

function ENT:Use( Name, activator )
	net.Start("SRP_Library.OpenMenu")
	net.WriteEntity(self)
	net.Send(activator)
end