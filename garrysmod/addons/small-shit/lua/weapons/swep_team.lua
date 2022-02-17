SWEP.Base = "weapon_base"

SWEP.PrintName = "Делитель на команды"
SWEP.Slot = 1
SWEP.SlotPos = 1
SWEP.DrawAmmo = false
SWEP.DrawCrosshair = true

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

local teamColors = {
	Color(200, 50, 50),
	Color(50, 50, 200),
	Color(50, 200, 50),
	Color(200, 200, 50),
}

function SWEP:Initialize()

	self:SetHoldType("normal")	

end

function SWEP:PreDrawViewModel()

	return true

end

function SWEP:PrimaryAttack()

	self:SetNextPrimaryFire(CurTime() + 0.3)
	if CLIENT then return end

	local ply = self.Owner:GetEyeTrace().Entity
	if not IsValid(ply) or not ply:IsPlayer() then return end

	local curTeam = ply:GetNWInt('SRP_Team', 0)
	curTeam = curTeam + 1
	if curTeam > 4 then curTeam = 1 end

	ply:SetMaterial('models/debug/debugwhite')
	ply:SetColor(teamColors[curTeam])
	ply:SetNWInt('SRP_Team', curTeam)

	local effectdata = EffectData()
	effectdata:SetOrigin(ply:GetPos() + Vector(0,0,30))
	effectdata:SetMagnitude(2.5)
	effectdata:SetScale(2)
	effectdata:SetRadius(3)
    util.Effect("Sparks", effectdata, true, true)
    ply:EmitSound("ui/hint.wav", 70, 100, 1 )

end

function SWEP:SecondaryAttack()

	self:SetNextPrimaryFire(CurTime() + 0.3)
	if CLIENT then return end

	local ply = self.Owner:GetEyeTrace().Entity
	if not IsValid(ply) or not ply:IsPlayer() then return end

	ply:SetMaterial('')
	ply:SetColor(Color(255,255,255))
	ply:SetNWInt('SRP_Team', 0)

	local effectdata = EffectData()
	effectdata:SetOrigin(ply:GetPos() + Vector(0,0,30))
	effectdata:SetMagnitude(2.5)
	effectdata:SetScale(2)
	effectdata:SetRadius(3)
    util.Effect("Sparks", effectdata, true, true)
    ply:EmitSound("ui/freeze_cam.wav", 70, 100, 0.7 )

end