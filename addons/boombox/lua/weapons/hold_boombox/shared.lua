AddCSLuaFile()

SWEP.PrintName    	= "BoomBox"			
SWEP.Slot         	= 1
SWEP.SlotPos      	= 1
SWEP.DrawAmmo     	= false
SWEP.DrawCrosshair	= true

SWEP.Category	= "Other"
SWEP.Author  	= "PxlCorp"

SWEP.Kind       	= 10
SWEP.AllowDelete	= false
SWEP.AllowDrop  	= false

SWEP.Spawnable	= false
SWEP.UseHands 	= false

SWEP.WorldModel   	= ""
SWEP.ViewModelFlip	= false
SWEP.ViewModelFOV 	= 60

SWEP.Primary.ClipSize   	= -1
SWEP.Primary.DefaultClip	= -1
SWEP.Primary.Automatic  	= false
SWEP.Primary.Ammo       	= "none"

SWEP.Secondary.ClipSize   	= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic  	= false
SWEP.Secondary.Ammo       	= "none"

function SWEP:PrimaryAttack()
	if SERVER then
		if IsValid(self.Ent) then
			net.Start("boombox_data")
				net.WriteEntity(self.Ent)
				net.WriteInt(3,32)
			net.Send(self:GetParent())
		end
	end
end

function SWEP:SecondaryAttack()
	if SERVER then
		self:Holster()
		self:GetParent():SwitchToDefaultWeapon()
	end
end

function SWEP:PreDrawViewModel()
	return true
end

function SWEP:OnDrop()
	if IsValid(self:GetParent()) then
		self:Holster()
	end
end

function SWEP:DampenDrop()
end

function SWEP:ShouldDropOnDie()
	return true
end

function SWEP:Initialize()

		
	if SERVER then
		timer.Simple(0,function()
			if not IsValid(self.Ent) then
				local ply = self:GetParent()

				local ent = ents.Create("3d_boombox") 

				ent:SetSolid(SOLID_NONE)
				ent:SetHeld(self)

				ent.SID = ply.SID
				ent:Setowning_ent(ply)

				if CPPI then
					ent:CPPISetOwner(ply)
				end
				
				ent:Spawn()
				ent:Activate()

				self.Ent = ent
			end

			if IsValid(self) and IsValid(self:GetParent()) then
				self:GetParent():SetActiveWeapon(self)
				self:Deploy()
			end
		end)
	end
end

function SWEP:Think()
	if not IsValid(self:GetParent()) then
		self:Holster()
	end
end

function SWEP:Deploy()
	self:SetHoldType("grenade")
	
	if SERVER then
		if IsValid(self.Ent) then
			self.Ent:CallOnRemove("removeHold",function(ent)
				if IsValid(ent:GetHeld()) then
					local ply = ent:GetHeld():GetParent()
					ent:GetHeld():Remove()
					ply:SwitchToDefaultWeapon()
				end
			end)
		end
		local bone = self:GetParent():LookupBone("ValveBiped.Bip01_R_Forearm")
		if bone then
			self:GetParent():ManipulateBoneAngles(bone,Angle(0,-15,0))
		end
	end
end

function SWEP:OnRemove()
	if SERVER then
		self:Remove()

		if IsValid(self.Ent) then
			self.Ent:Remove()
		end
	end
end

function SWEP:Holster(wep)
	if SERVER then
		if IsValid(self:GetParent()) then
			local bone = self:GetParent():LookupBone("ValveBiped.Bip01_R_Forearm")
			if bone then
				self:GetParent():ManipulateBoneAngles(bone,Angle(0,0,0))
			end
		end
		if IsValid(self.Ent) then
			if IsValid(self:GetParent()) then
				local tr = util.TraceLine({
					start = self:GetParent():EyePos(),
					endpos = self:GetParent():EyePos()+self:GetParent():EyeAngles():Forward()*100,
					filter = self:GetParent()
				})
				self.Ent:SetPos(tr.HitPos+tr.HitNormal*20)
				self.Ent:SetAngles((self:GetParent():EyeAngles():Forward()*Vector(1,1,0)):Angle()+Angle(0,180,0))
			end

			self.Ent:SetHeld(nil)
			self.Ent:PhysicsInit( SOLID_VPHYSICS )
			self.Ent:SetMoveType( MOVETYPE_VPHYSICS )
			self.Ent:SetSolid( SOLID_VPHYSICS )
			if IsValid(self.Ent:GetPhysicsObject()) then
				self.Ent:GetPhysicsObject():Wake()
				self.Ent:GetPhysicsObject():SetMass(60)
			end
		end

		local ply = self:GetParent()

		self.Ent = nil
		self:Remove()

		if IsValid(ply) then
			if not IsValid(wep) then
				return false
			end
		end
	end
	return true
end

function SWEP:IsEquipment()
	return true
end


--TTT compat
if BOOMBOX.config.AddTraitorWeapon or BOOMBOX.config.AddDetectiveWeapon then
	SWEP.CanBuy = { }

	if BOOMBOX.config.AddTraitorWeapon then table.insert(SWEP.CanBuy, ROLE_TRAITOR) end
	if BOOMBOX.config.AddDetectiveWeapon then table.insert(SWEP.CanBuy, ROLE_DETECTIVE) end

	SWEP.LimitedStock	= false
	SWEP.EquipMenuData  = {
		type = "BoomBox",
		desc = "Add some music to your actions."
	};
end

--DarkRP Drop
if SERVER then
	hook.Add("canDropWeapon","boomboxcanceldrop",function(ply,wep)
		if IsValid(wep) and wep:GetClass()=="hold_boombox" then
			return false
		end
	end)
end