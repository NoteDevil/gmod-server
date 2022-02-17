

if CLIENT then

	SWEP.PrintName			= "Dumbbell"
	SWEP.Author				= "Upset"
	SWEP.Instructions		= "WOT TAK WOT"
	SWEP.Slot				= 0
	SWEP.SlotPos			= 1
	SWEP.ViewModelFOV		= 85
	SWEP.BobScale			= 1
	SWEP.SwayScale			= .7
	SWEP.WepSelectIcon		= surface.GetTextureID("vgui/gantelya")	
	killicon.Add("weapon_dumbbell", "vgui/gantelya", Color(255, 80, 0, 255))
	
end

SWEP.HoldType			= "grenade"
SWEP.Category			= "Other"
SWEP.Spawnable			= true

SWEP.ViewModel			= Model("models/weapons/c_gantelya.mdl")
SWEP.WorldModel			= Model("models/weapons/w_gantelya.mdl")

SWEP.Weight				= 3
SWEP.AutoSwitchTo		= false
SWEP.AutoSwitchFrom		= false

SWEP.Primary.Sound			= Sound("weapons/gantelya_hit.wav")
SWEP.Primary.Special1		= Sound("weapons/gantelya_world.wav")
SWEP.Primary.Special2		= Sound("weapons/gantelya_miss.wav")
SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= -1
SWEP.Primary.Delay			= 1
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "none"

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Delay		= 1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"

SWEP.HitDistance			= 75
SWEP.UseHands				= true

SWEP.NevskySounds = {
	Sound("weapons/nevsky_vtv1.wav"),
	Sound("weapons/nevsky_vtv2.wav"),
	Sound("weapons/nevsky_vtv3.wav"),
	Sound("weapons/nevsky_vtv4.wav"),
	Sound("weapons/nevsky_vtv5.wav")
}

function SWEP:Initialize()
	self:SetHoldType(self.HoldType)
end

function SWEP:SetupDataTables()
	self:NetworkVar("Float", 0, "IdleDelay")
end

function SWEP:Deploy()
	self:SetNextPrimaryFire(CurTime() +.5)
	self:SetNextSecondaryFire(CurTime() +.5)
	self:SendWeaponAnim(ACT_VM_DRAW)
	self:SetIdleDelay(CurTime() +self:SequenceDuration())
	return true
end

function SWEP:Holster()
	if self.cantholster and self.cantholster > CurTime() then return false end
	return true
end

function SWEP:PrimaryAttack()
	self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
	self:SetNextSecondaryFire(CurTime() + self.Secondary.Delay)
	self:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
	self.attackdelay = CurTime() +.35
	self.cantholster = CurTime() +.4
	self:SetIdleDelay(CurTime() +self:SequenceDuration())
end

function SWEP:SecondaryAttack()
	self:SetNextPrimaryFire(CurTime() + self.Secondary.Delay)
	self:SetNextSecondaryFire(CurTime() + self.Secondary.Delay)
	self:SendWeaponAnim(ACT_VM_SECONDARYATTACK)
	self.Owner:ViewPunch(Angle(math.Rand(-.5,-.2), 0, 0))
	if SERVER then self.Owner:EmitSound(self.NevskySounds[math.random(1, #self.NevskySounds)]) end
	self:SetIdleDelay(CurTime() +self:SequenceDuration())
	self.cantholster = CurTime() +.8
	
	if SERVER then
		local newhp = math.min(self.Owner:Health() + 5, 150)
		self.Owner:SetHealth(newhp)
	end
end

function SWEP:Think()
	if self.attackdelay and CurTime() > self.attackdelay then
		self.attackdelay = nil
		self:DealDamage()
	end
	
	if game.SinglePlayer() and CLIENT then return end
	local idle = self:GetIdleDelay()
	if idle > 0 and CurTime() > idle then
		self:SetIdleDelay(0)
		self:SendWeaponAnim(ACT_VM_IDLE)
	end
end

function SWEP:DealDamage()	
	self.Owner:ViewPunch(Angle(math.Rand(-1,-.5), math.Rand(1,2), 0))
	self.Owner:SetAnimation(PLAYER_ATTACK1)
	
	//some code from gmod fists
	if CLIENT then return end
	
	self.Owner:LagCompensation(true)	
	local tr = util.TraceLine({
		start = self.Owner:GetShootPos(),
		endpos = self.Owner:GetShootPos() + self.Owner:GetAimVector() * self.HitDistance,
		filter = self.Owner
	})

	if (!IsValid(tr.Entity)) then
		tr = util.TraceHull({
			start = self.Owner:GetShootPos(),
			endpos = self.Owner:GetShootPos() + self.Owner:GetAimVector() * self.HitDistance,
			filter = self.Owner,
			mins = Vector(-10, -10, -8),
			maxs = Vector(10, 10, 8)
		})
	end
	
	if !tr.Hit then self.Owner:EmitSound(self.Primary.Special2, 70, math.random(90,102)) end
	if tr.HitWorld || tr.HitNonWorld and !tr.Entity:IsNPC() || tr.Entity:IsPlayer() then
		self.Owner:EmitSound(self.Primary.Special1, 85, math.random(97,103))
	end

	if IsValid(tr.Entity) && (tr.Entity:IsNPC() || tr.Entity:IsPlayer() || tr.Entity:Health() > 0) then
		self.Owner:EmitSound(self.Primary.Sound, 75, math.random(97,103))
		self.Owner:EmitSound(self.NevskySounds[math.random(1, 3)])
		local dmginfo = DamageInfo()
		dmginfo:SetDamage(math.random(5,10))
		dmginfo:SetDamageForce(self.Owner:GetUp() *11000 +self.Owner:GetForward() *30000 +self.Owner:GetRight() *-6500)
		dmginfo:SetInflictor(self)
		local attacker = self.Owner
		if (!IsValid(attacker)) then attacker = self end
		dmginfo:SetAttacker(attacker)
		tr.Entity:TakeDamageInfo(dmginfo)
	end
	
	if IsValid(tr.Entity) then
		local phys = tr.Entity:GetPhysicsObject()
		if IsValid(phys) then
			phys:ApplyForceOffset(self.Owner:GetAimVector() * 160 * phys:GetMass(), tr.HitPos)
		end
	end
	
	self.Owner:LagCompensation(false)
end

function SWEP:Reload()
end

function SWEP:DrawWeaponSelection(x, y, wide, tall, alpha)
	surface.SetDrawColor(255, 255, 255, alpha)
	surface.SetTexture(self.WepSelectIcon)
	
	wide = wide/1.5
	tall = tall/1.15
	x = x+wide/4
	y = y+tall/18

	surface.DrawTexturedRect(x, y, wide, tall)
end