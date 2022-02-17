local Anims = {}

-- Load animations after the languages for translation purposes
hook.Add("loadCustomDarkRPItems", "loadAnimations", function()
    table.insert( Anims, { anim = ACT_GMOD_GESTURE_AGREE, name = "Одобрить" } )
    table.insert( Anims, { anim = ACT_GMOD_GESTURE_DISAGREE, name = "Поругать" } )
    table.insert( Anims, { anim = ACT_GMOD_GESTURE_BECON, name = "Подозвать" } )
    table.insert( Anims, { anim = ACT_GMOD_GESTURE_WAVE, name = "Помахать" } )
    table.insert( Anims, { anim = ACT_GMOD_GESTURE_BOW, name = "Поклониться" } )
    table.insert( Anims, { anim = ACT_GMOD_TAUNT_SALUTE, name = "Отдать честь" } )
    
    table.insert( Anims, { spacer = true } )

    table.insert( Anims, { anim = ACT_GMOD_TAUNT_LAUGH, name = "Смеяться" } )
    table.insert( Anims, { anim = ACT_GMOD_GESTURE_TAUNT_ZOMBIE, name = "Устрашить" } )
    table.insert( Anims, { anim = ACT_GMOD_TAUNT_PERSISTENCE, name = "Поза льва" } )

    table.insert( Anims, { spacer = true } )

    table.insert( Anims, { anim = ACT_GMOD_TAUNT_ROBOT, name = "Танцевать как робот" } )
    table.insert( Anims, { anim = ACT_GMOD_TAUNT_DANCE, name = "Танцевать как человек" } )
    table.insert( Anims, { anim = ACT_GMOD_TAUNT_MUSCLE, name = "Танцевать как шлюха" } )

    table.insert( Anims, { spacer = true } )

    table.insert( Anims, { anim = ACT_SIGNAL_FORWARD, name = "Вперёд" } )
    table.insert( Anims, { anim = ACT_SIGNAL_HALT, name = "Остановить" } )
    table.insert( Anims, { anim = ACT_SIGNAL_GROUP, name = "Сгруппировать" } )

    -- Anims[ACT_GMOD_GESTURE_BOW] = DarkRP.getPhrase("bow")
    -- Anims[ACT_GMOD_TAUNT_MUSCLE] = DarkRP.getPhrase("dance")
    -- Anims[ACT_GMOD_GESTURE_BECON] = DarkRP.getPhrase("follow_me")
    -- Anims[ACT_GMOD_TAUNT_LAUGH] = DarkRP.getPhrase("laugh")
    -- Anims[ACT_GMOD_TAUNT_PERSISTENCE] = DarkRP.getPhrase("lion_pose")
    -- Anims[ACT_GMOD_GESTURE_DISAGREE] = DarkRP.getPhrase("nonverbal_no")
    -- Anims[ACT_GMOD_GESTURE_AGREE] = DarkRP.getPhrase("thumbs_up")
    -- Anims[ACT_GMOD_GESTURE_WAVE] = DarkRP.getPhrase("wave")

    DarkRP.Anims = Anims
end)

function DarkRP.addPlayerGesture(anim, text)
    if not anim then DarkRP.error("Argument #1 of DarkRP.addPlayerGesture (animation/gesture) does not exist.", 2) end
    if not text then DarkRP.error("Argument #2 of DarkRP.addPlayerGesture (text) does not exist.", 2) end

    table.insert( Anims, { anim = anim, name = text } )
end

function DarkRP.removePlayerGesture(anim)
    if not anim then DarkRP.error("Argument #1 of DarkRP.removePlayerGesture (animation/gesture) does not exist.", 2) end

   for k,v in pairs(Anims) do
       if v.anim == anim then table.remove( Anims, k ) end
   end
end

hook.Add("CalcMainActivity", "darkrp_animations", function(ply, velocity) -- Using hook.Add and not GM:CalcMainActivity to prevent animation problems
    -- Dropping weapons/money!
    if ply.anim_DroppingItem then
        ply:AnimRestartGesture(GESTURE_SLOT_ATTACK_AND_RELOAD, ACT_GMOD_GESTURE_ITEM_DROP, true)
        ply.anim_DroppingItem = nil
    end

    -- Giving items!
    if ply.anim_GivingItem then
        ply:AnimRestartGesture(GESTURE_SLOT_ATTACK_AND_RELOAD, ACT_GMOD_GESTURE_ITEM_GIVE, true)
        ply.anim_GivingItem = nil
    end

    if CLIENT and ply.SaidHi then
        ply:AnimRestartGesture(GESTURE_SLOT_ATTACK_AND_RELOAD, ACT_SIGNAL_GROUP, true)
        ply.SaidHi = nil
    end

    if CLIENT and ply.ThrewPoop then
        ply:AnimRestartGesture(GESTURE_SLOT_ATTACK_AND_RELOAD, ACT_GMOD_GESTURE_ITEM_THROW, true)
        ply.ThrewPoop = nil
    end

    if CLIENT and ply.knocking then
        ply:AnimRestartGesture(GESTURE_SLOT_ATTACK_AND_RELOAD, ACT_HL2MP_GESTURE_RANGE_ATTACK_FIST, true)
        ply.knocking = nil
    end

    if CLIENT and ply.usekeys then
        ply:AnimRestartGesture(GESTURE_SLOT_ATTACK_AND_RELOAD, ACT_GMOD_GESTURE_ITEM_PLACE, true)
        ply.usekeys = nil
    end

    if not SERVER then return end

    -- Hobo throwing poop!
    local Weapon = ply:GetActiveWeapon()
    if RPExtraTeams[ply:Team()] and RPExtraTeams[ply:Team()].hobo and not ply.ThrewPoop and IsValid(Weapon) and Weapon:GetClass() == "weapon_bugbait" and ply:KeyDown(IN_ATTACK) then
        ply.ThrewPoop = true
        ply:AnimRestartGesture(GESTURE_SLOT_ATTACK_AND_RELOAD, ACT_GMOD_GESTURE_ITEM_THROW, true)


        local RP = RecipientFilter()
        RP:AddAllPlayers()

        umsg.Start("anim_throwpoop", RP)
            umsg.Entity(ply)
        umsg.End()
    elseif ply.ThrewPoop and not ply:KeyDown(IN_ATTACK) then
        ply.ThrewPoop = nil
    end

    -- Saying hi/hello to a player
    -- if not ply.SaidHi and IsValid(Weapon) and Weapon:GetClass() == "weapon_physgun" and ply:KeyDown(IN_ATTACK) then
    --     local ent = ply:GetEyeTrace().Entity
    --     if IsValid(ent) and ent:IsPlayer() then
    --         ply.SaidHi = true
    --         ply:AnimRestartGesture(GESTURE_SLOT_ATTACK_AND_RELOAD, ACT_SIGNAL_GROUP, true)

    --         local RP = RecipientFilter()
    --         RP:AddAllPlayers()

    --         umsg.Start("anim_sayhi", RP)
    --             umsg.Entity(ply)
    --         umsg.End()
    --     end
    -- elseif ply.SaidHi and not ply:KeyDown(IN_ATTACK) then
    --     ply.SaidHi = nil
    -- end
end)

if SERVER then
    local donatorGestures = {
        ACT_GMOD_TAUNT_LAUGH,
        ACT_GMOD_GESTURE_TAUNT_ZOMBIE
    }

    local vehGestures = {
        ACT_SIGNAL_FORWARD,
        ACT_SIGNAL_HALT,
        ACT_SIGNAL_GROUP
    }

    local function CustomAnim(ply, cmd, args)
        if ply:EntIndex() == 0 then return end
        local Gesture = tonumber(args[1] or 0)
        local found = false
        for k,v in pairs(Anims) do
            if v.anim and v.anim == Gesture then found = true end 
        end
        if not found then return end

        if (table.HasValue( donatorGestures, Gesture ) and !ply:query( "ulx gestures" ))
        or (IsValid(ply:GetVehicle()) and !table.HasValue( vehGestures, Gesture )) then
            return false
        end

        local RP = RecipientFilter()
        RP:AddAllPlayers()

        umsg.Start("_DarkRP_CustomAnim", RP)
        umsg.Entity(ply)
        umsg.Short(Gesture)
        umsg.End()
    end
    concommand.Add("_DarkRP_DoAnimation", CustomAnim)
    return
end

local function DropItem(um)
    local ply = um:ReadEntity()
    if not IsValid(ply) then return end

    ply.anim_DroppingItem = true
end
usermessage.Hook("anim_dropitem", DropItem)

local function GiveItem(um)
    local ply = um:ReadEntity()
    if not IsValid(ply) then return end

    ply.anim_GivingItem = true
end
usermessage.Hook("anim_giveitem", GiveItem)

local function ThrowPoop(um)
    local ply = um:ReadEntity()
    if not IsValid(ply) then return end

    ply.ThrewPoop = true
end
usermessage.Hook("anim_throwpoop", ThrowPoop)

local function PhysgunHi(um)
    local ply = um:ReadEntity()
    if not IsValid(ply) then return end

    ply.SaidHi = true
end
usermessage.Hook("anim_sayhi", PhysgunHi)

local function KeysAnims(um)
    local ply = um:ReadEntity()
    if not IsValid(ply) then return end
    local Type = um:ReadString()
    ply[Type] = true
end
usermessage.Hook("anim_keys", KeysAnims)


local function CustomAnimation(um)
    local ply = um:ReadEntity()
    local act = um:ReadShort()

    if not IsValid(ply) then return end
    ply:AnimRestartGesture(GESTURE_SLOT_CUSTOM, act, true)
end
usermessage.Hook("_DarkRP_CustomAnim", CustomAnimation)

local AnimFrame
local function AnimationMenu()
    if AnimFrame then return end

    local Panel = vgui.Create("Panel")
    Panel:SetPos(0,0)
    Panel:SetSize(ScrW(), ScrH())
    function Panel:OnMousePressed()
        AnimFrame:Close()
    end

    AnimFrame = AnimFrame or vgui.Create("DFrame", Panel)
    local Height = table.Count(Anims) * 55 + 32
    AnimFrame:SetSize(130, Height)
    AnimFrame:SetPos(ScrW() / 2 + ScrW() * 0.1, ScrH() / 2 - (Height / 2))
    AnimFrame:SetTitle(DarkRP.getPhrase("custom_animation"))
    AnimFrame:SetVisible(true)
    AnimFrame:MakePopup()

    function AnimFrame:Close()
        Panel:Remove()
        AnimFrame:Remove()
        AnimFrame = nil
    end

    local i = 0
    for k,v in SortedPairs(Anims) do
        i = i + 1

        if v.spacer then continue end

        local button = vgui.Create("DButton", AnimFrame)
        button:SetPos(10, (i - 1) * 55 + 30)
        button:SetSize(110, 50)
        button:SetText(v.name)

        button.DoClick = function()
            RunConsoleCommand("_DarkRP_DoAnimation", v.anim)
        end
    end
    AnimFrame:SetSkin(GAMEMODE.Config.DarkRPSkin)
end
concommand.Add("_DarkRP_AnimationMenu", AnimationMenu)