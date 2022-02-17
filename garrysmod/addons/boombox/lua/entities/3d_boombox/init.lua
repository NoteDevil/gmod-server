AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

util.AddNetworkString("boombox_data")

function ENT:Initialize()
	self:SetModel( "models/boomboxv2/boomboxv2.mdl" )
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
	self:SetUseType( SIMPLE_USE )
	self:GetPhysicsObject():Wake()
	self:GetPhysicsObject():SetMass(60)
end

function ENT:Think()
	self.lastmove = self.lastmove or CurTime()
	if CurTime()-self.lastmove>2 then
		self:SetSoundPos(self:GetPos())
		if IsValid(self:GetHeld()) and IsValid(self:GetHeld():GetParent()) then
			local tr = util.TraceLine({start=self:GetPos(),endpos=self:GetHeld():GetParent():EyePos(),mask=MASK_NPCWORLDSTATIC})
			if tr.Hit then
				local bone = self:GetHeld():GetParent():LookupBone("ValveBiped.Bip01_R_Forearm")
				if bone then
					local pos,ang = self:GetHeld():GetParent():GetBonePosition(bone)
					local npos,nang = LocalToWorld(Vector(10,-6,0),Angle(0,-90,-90),pos,ang)
					self:SetPos(npos)
					self:SetAngles(nang)
				else
					self:SetPos(self:GetHeld():GetPos())
					self:SetAngles(self:GetHeld():GetAngles())
				end
			end
		end
		if (self:GetSolid()==SOLID_NONE and not IsValid(self:GetHeld())) or (IsValid(self:GetHeld()) and not IsValid(self:GetHeld():GetParent())) then
			self:Drop()
		end
		self.lastmove = CurTime()
	end
end

function ENT:Use( activator, caller )
	if BOOMBOX.config.UsePropProtection==2 and self.CPPICanUse and not self:CPPICanUse(activator) then return end
	if BOOMBOX.config.UsePropProtection==3 and not self:GetOwner()==activator then return end
	if IsValid(self:GetHeld()) then return end
	net.Start("boombox_data")
		net.WriteEntity(self)
		net.WriteInt(3,32)
	net.Send(activator)
end

function ENT:Take(ply)
	if not IsValid(ply:GetWeapon("hold_boombox")) then
		local wep = ply:Give("hold_boombox")
		wep.Ent = self
		
		ply:SelectWeapon("hold_boombox")

		self:SetSolid(SOLID_NONE)
		self:SetHeld(wep)
	else
		ply:GetWeapon("hold_boombox").Ent:Drop()
	end
end

function ENT:Drop()

	if IsValid(ply) then
		local tr = util.TraceLine({
			start = ply:EyePos(),
			endpos = ply:EyePos()+ply:EyeAngles():Forward()*100,
			filter = ply
		})
		self:SetPos(tr.HitPos+tr.HitNormal*20)
		self:SetAngles((ply:EyeAngles():Forward()*Vector(1,1,0)):Angle()+Angle(0,180,0))
	end

	--self:SetParent(nil)

	self:SetSolid(SOLID_VPHYSICS)
	self:SetHeld(nil)
end

hook.Add("OnPlayerChangedTeam","boomboxjobswitch",function(ply, oT, nT)
	if BOOMBOX.config.RemOnJobSwitch then
		for _, bb in ipairs(ents.FindByClass("3d_boombox")) do
			if bb:Getowning_ent() == ply or (bb.CPPIGetOwner and bb:CPPIGetOwner()==ply) or bb.Owner==ply or bb:GetOwner()==ply then
				bb:Remove()
			end
		end
	end
end)