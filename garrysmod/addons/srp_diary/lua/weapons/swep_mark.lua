AddCSLuaFile()

SWEP.PrintName = "Оценка"
SWEP.Slot = 1
SWEP.SlotPos = 1
SWEP.DrawAmmo = false
SWEP.DrawCrosshair = true

SWEP.Author = "SRP"
SWEP.Instructions = "ЛКМ: Поставить оценку"
SWEP.Contact = ""
SWEP.Purpose = ""
SWEP.IsDarkRPKeys = true

SWEP.WorldModel = ""

SWEP.ViewModelFOV = 62
SWEP.ViewModelFlip = false
SWEP.AnimPrefix  = "rpg"

SWEP.UseHands = true

SWEP.Spawnable = true
SWEP.AdminOnly = true
SWEP.Category = "SRP"
SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = 0
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = ""

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = 0
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = ""

SWEP.marks = { 2, 3, 4, 5 }
SWEP.selected = 5

function SWEP:Initialize()

    self:SetHoldType("normal")

end

function SWEP:DrawHUD()

    local ent = self.Owner:GetEyeTrace().Entity
    if not IsValid(ent) then return end
    if ent:GetClass() ~= "ent_diary" then return end
    local ply = ent:Getowning_ent()
    if not IsValid( ply ) then return end

    draw.SimpleText("Поставить оценку:", "TargetID", ScrW()/2, ScrH()/2-10, color_white, 1, 1)
    draw.SimpleText(ply:Name(), "DermaLarge", ScrW()/2, ScrH()/2+10, Color(50,200,50), 1, 1)

end

function SWEP:Deploy()

    if CLIENT or not IsValid(self:GetOwner()) then return true end
    self:GetOwner():DrawWorldModel(false)
    return true

end

function SWEP:Holster()

    return true

end

function SWEP:PreDrawViewModel()

    return true

end


function SWEP:PrimaryAttack()

    if SERVER then return end

    local job = LocalPlayer():getJobTable()
    if not job.subject and LocalPlayer():Team() ~= TEAM_DIRECTOR then return end

    gui.EnableScreenClicker( true )
    local m = DermaMenu()

    if LocalPlayer():Team() == TEAM_DIRECTOR then
        for k, subject in pairs(SRP_Diary.Subjects) do
            local sm = m:AddSubMenu(subject)
            for i = 1, 5 do
                sm:AddOption( "Поставить " .. i, function()
                    net.Start('srp_diary.addMark')
                        net.WriteString(subject)
                        net.WriteUInt( i, 8 )
                    net.SendToServer()
                end)
            end
        end
    else
        for i = 1, 5 do
            m:AddOption( "Поставить " .. i, function()
                net.Start('srp_diary.addMark')
                    net.WriteString(job.subject)
                    net.WriteUInt( i, 8 )
                net.SendToServer()
            end)
        end
    end

    m:Center()
    m:Open()
    gui.EnableScreenClicker( false )

end

function SWEP:SecondaryAttack()

    -- keep calm and do nothing ;)

end
