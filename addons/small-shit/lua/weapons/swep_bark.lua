SWEP.Base = "weapon_base"

SWEP.PrintName = "Гав"
SWEP.Slot = 1
SWEP.SlotPos = 1
SWEP.DrawAmmo = false
SWEP.DrawCrosshair = false

SWEP.WorldModel	= ""
SWEP.ViewModelFOV = 62
SWEP.ViewModelFlip = false
SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = 0
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = ""

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = 0
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = ""

function SWEP:Attack()
	if CLIENT then return end
	local tr = util.TraceLine( {
		start = self.Owner:GetShootPos(),
		endpos = self.Owner:GetShootPos() + self.Owner:GetAimVector() * 80,
		filter = self.Owner,
		mask = MASK_SHOT_HULL
	} )

	if ( IsValid( tr.Entity ) && ( tr.Entity:IsNPC() || tr.Entity:IsPlayer() || tr.Entity:Health() > 0 ) ) then
		local dmginfo = DamageInfo()

		local attacker = self.Owner
		if ( !IsValid( attacker ) ) then attacker = self end
		dmginfo:SetAttacker( attacker )
		dmginfo:SetInflictor( self )
		dmginfo:SetDamage( 6 )

		tr.Entity:TakeDamageInfo( dmginfo )
		
		tr.Entity:SetVelocity(tr.Normal*250)
		tr.Entity:EmitSound('physics/body/body_medium_impact_hard'.. math.random(1, 6) ..'.wav')
	end
end

function SWEP:Initialize()
	self:SetHoldType("normal")		
end

function SWEP:PreDrawViewModel()
	return true
end

function SWEP:PrimaryAttack()
	if CLIENT then return end
	self:SetNextPrimaryFire(CurTime() + 1)
	self.Owner:EmitSound("ambient/animal/dog_med_inside_bark_" .. math.random(1, 6) .. ".wav")
end

function SWEP:SecondaryAttack()
	if CLIENT then return end
	self:SetNextSecondaryFire(CurTime() + 2)
	self.Owner:EmitSound("ambient/animal/dog_growl_behind_wall_" .. math.random(1, 3) .. ".wav")
	self:Attack()
end