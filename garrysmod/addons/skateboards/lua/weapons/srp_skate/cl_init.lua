include("shared.lua")

SWEP.DrawAmmo = false
SWEP.DrawCrosshair = true
SWEP.DrawViewModel = false
SWEP.DrawWorldModel = false

SWEP.ViewModelFOV = 65

SWEP.Slot = 1
SWEP.SlotPos = 1

function SWEP:Initialize()
    
    self:SetWeaponHoldType("normal")
    
end

function SWEP:Deploy()

    self:SetNoDraw(true)
    return true
    
end

function SWEP:Holster()

    return true
    
end

function SWEP:PreDrawViewModel()

    return true
    
end

function SWEP:DrawViewModel()

    return false
    
end

function SWEP:DrawWorldModel()

	-- self:DrawModel()
    return false
    
end
