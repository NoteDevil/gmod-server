if SERVER then
	AddCSLuaFile()
end

SWEP.PrintName = "Инвентарь"
SWEP.Slot = 1
SWEP.SlotPos = 1
SWEP.DrawAmmo = false
SWEP.DrawCrosshair = true

SWEP.Base = "weapon_cs_base2"

SWEP.Author = "roni_sl"
SWEP.Instructions = "ЛКМ - спрятать вещь в инвентарь"
SWEP.Contact = ""
SWEP.Purpose = ""
SWEP.IconLetter = ""

SWEP.ViewModelFOV = 62
SWEP.ViewModelFlip = false
SWEP.AnimPrefix	 = "rpg"
SWEP.WorldModel	= ""

SWEP.Spawnable = false
SWEP.AdminSpawnable = true
SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = 0
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = ""

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = 0
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = ""

function SWEP:Initialize()

	//self:SetWeaponHoldType("normal")

end

function SWEP:Deploy()

	if not SERVER then return end

	self.Owner:DrawViewModel(false)
	self.Owner:DrawWorldModel(false)

end

function SWEP:Equip(newOwner)

	if not SERVER then return end

end

function SWEP:PrimaryAttack()

	self.Weapon:SetNextPrimaryFire(CurTime() + 1)

	if not SERVER then return end
	local ent = self.Owner:GetEyeTrace().Entity
	if not IsValid(ent) then DarkRP.notify(self.Owner, 1, 4, "Вы должны смотреть на предмет.") return end
	if ent:GetPos():DistToSqr(self.Owner:GetPos()) > 100*100 then DarkRP.notify(self.Owner, 1, 4, "Предмет далеко.") return end

	if ent:GetClass() == 'ent_diary' then
		DarkRP.notify( self.Owner, NOTIFY_GENERIC, 3, "Дневник убран" )
		ent:Remove()
		return
	end

	self.Owner:AddEntityInv(ent)

end

function SWEP:SecondaryAttack()

	if SERVER or not IsFirstTimePredicted() then return end

	-- fuck you, roni
	if ValidPanel(UPMenu) then UPMenu:Close() return end
	if GAMEMODE.ShowScoreboard then return end
	UPMenu = vgui.Create("F4MenuFrame")

	for k,v in pairs(DGF4.elements) do
		if v.name ~= "Инвентарь" then continue end

		local slf = UPMenu['mbtn'..k]
		slf.Selected = true
		for k,but in pairs( UPMenu.submenu:GetChildren() ) do
			but.Selected = false
		end
		if not v.DontSave then
			LocalPlayer().LastTab = k
		end 
		slf.Selected = true
		v["callBack"](UPMenu)
	end

end
