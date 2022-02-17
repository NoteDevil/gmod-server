


if ( SERVER ) then

	AddCSLuaFile( "shared.lua" )
	SWEP.HoldType	= "melee2"
	
end

if ( CLIENT ) then

         SWEP.PrintName	            = "Baseball-Bat"	 
         SWEP.Author				= "Ryan Kingstone"
         SWEP.Category				= "SRP" 
         SWEP.Slot			        = 0					 
         SWEP.SlotPos		        = 1
         SWEP.DrawAmmo                  = false					 
         SWEP.IconLetter			= "w"

         killicon.AddFont( "weapon_crowbar", 	"HL2MPTypeDeath", 	"6", 	Color( 255, 80, 0, 255 ) )

end


SWEP.Base				= "weapon_base"

SWEP.Spawnable			= true
SWEP.AdminSpawnable		= true

SWEP.ViewModel		= "models/weapons/v_bat.mdl"	 
SWEP.WorldModel		= "models/weapons/w_bat.mdl"	
SWEP.DrawCrosshair      = false

SWEP.ViewModelFOV = 45

SWEP.ViewModelFlip = false


SWEP.Weight					= 1			 
SWEP.AutoSwitchTo			= true		 
SWEP.AutoSwitchFrom			= false	
SWEP.CSMuzzleFlashes		= false	  	 		 
		 
SWEP.Primary.Damage			= 15						 			  
SWEP.Primary.ClipSize		= -1		
SWEP.Primary.Delay			= 1		  
SWEP.Primary.DefaultClip	= 1		 
SWEP.Primary.Automatic		= true		 
SWEP.Primary.Ammo			= "none"	 

SWEP.Secondary.ClipSize		= -1			
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Damage		= 0		 
SWEP.Secondary.Automatic	= false		 
SWEP.Secondary.Ammo			= "none"

function SWEP:Initialize()

	self:SetWeaponHoldType( "melee2" )

end


SWEP.MissSound 				= Sound("weapons/knife/knife_slash1.wav")
SWEP.WallSound 				= Sound("weapons/melee/crowbar/crowbar_hit-1.wav")

/*---------------------------------------------------------
PrimaryAttack
---------------------------------------------------------*/
function SWEP:PrimaryAttack()

	local tr = {}
	tr.start = self.Owner:GetShootPos()
	tr.endpos = self.Owner:GetShootPos() + ( self.Owner:GetAimVector() * 65 )
	tr.filter = self.Owner
	tr.mask = MASK_SHOT
	local trace = util.TraceLine( tr )

	self.Weapon:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
	self.Owner:SetAnimation( PLAYER_ATTACK1 )

	if ( trace.Hit ) then
		self.Weapon:SendWeaponAnim(ACT_VM_HITCENTER)
		bullet = {}
		bullet.Num    = 1
		bullet.Src    = self.Owner:GetShootPos()
		bullet.Dir    = self.Owner:GetAimVector()
		bullet.Spread = Vector(0, 0, 0)
		bullet.Tracer = 0
		bullet.Force  = 2
		bullet.Damage = self.Primary.Damage
		self.Owner:FireBullets(bullet) 
		-- self.Owner:FireBullets(bullet) 
		if SERVER then
			self.Owner:EmitSound( self.WallSound, 75, math.random(90,105), 0.4 )		
		end
		-- util.Decal("ManhackCut", trace.HitPos + trace.HitNormal, trace.HitPos - trace.HitNormal)
	else
		if SERVER then
			self.Owner:EmitSound( self.MissSound, 75, math.random(90,105) )
		end
		self.Weapon:SendWeaponAnim(ACT_VM_MISSCENTER)
	end
	
	-- timer.Simple( 0.05, function()
	-- 		self.Owner:ViewPunch( Angle( 0, 30, 0 ) )
	-- end )

	-- timer.Simple( 0.2, function()
	-- 		self.Owner:ViewPunch( Angle( -20, -16, 0 ) )
	-- end )
end

function SWEP:SecondaryAttack()
	return false
end

/*---------------------------------------------------------
Reload
---------------------------------------------------------*/
function SWEP:Reload()

	return false
end

/*---------------------------------------------------------
OnRemove
---------------------------------------------------------*/
function SWEP:OnRemove()

return true
end

/*---------------------------------------------------------
Holster
---------------------------------------------------------*/
function SWEP:Holster()

	return true
end

