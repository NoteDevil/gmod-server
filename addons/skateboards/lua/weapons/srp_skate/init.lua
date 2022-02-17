AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "cl_init.lua" )

include("shared.lua")

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

function SWEP:SetSkateData( data )

    self.SkateData = data

end

function SWEP:PrimaryAttack()

    if self.SpawnedSkate then return end
    self.SpawnedSkate = true
    
    self:SpawnSkate()
    self:Remove()

end

function SWEP:SpawnSkate()

    local skateboard = ents.Create('srp_skateboard')
    if ( !IsValid( skateboard ) ) then error("Entity '" .. 'srp_skateboard' .. "' does not exist or is not valid.") end

    local boardinfo
    for _, board in pairs( SkateboardTypes ) do
        if ( board[ 'model' ]:lower() == self.SkateData.Model:lower() ) then
            boardinfo = board
            break
        end
    end
    if ( !boardinfo ) then error("No board info for '" .. self.SkateData.Model .. "'.") end

    util.PrecacheModel( self.SkateData.Model )

    local pos = self.Owner:GetShootPos() + self.Owner:GetAimVector() * 50
    local tr = util.TraceLine({
        start = self.Owner:EyePos(),
        endpos = self.Owner:EyePos() + self.Owner:EyeAngles():Forward() * 50,
        filter = self.Owner
    })
    if tr.Hit then pos = tr.HitPos + tr.HitNormal * 3 end
    local ang = self.Owner:EyeAngles()
    ang.p = 0
    ang.y = ang.y + 90

    skateboard:SetModel( self.SkateData.Model )
    skateboard:SetPos( pos )
    skateboard:SetAngles( ang )
    skateboard:SetBoardRotation( 0 )

    if ( boardinfo[ "rotation" ] ) then
        local rot = tonumber( boardinfo[ "rotation" ] )
        skateboard:SetBoardRotation( tonumber( boardinfo[ "rotation" ] ) )
    end

    skateboard:Spawn()
    skateboard:Activate()
    skateboard:SetAvatarPosition( Vector( 0, 0, 0 ) )

    if ( boardinfo[ 'driver' ] ) then
        skateboard:SetAvatarPosition( boardinfo[ 'driver' ] )
    end

    for k, v in pairs( boardinfo ) do
        if ( k:sub( 1, 7 ):lower() == "effect_" && type( boardinfo[ k ] == "table" ) ) then
            local effect = boardinfo[ k ]

            local normal
            if ( effect[ 'normal' ] ) then normal = effect[ 'normal' ] end

            skateboard:AddEffect( effect[ 'effect' ] or "trail", effect[ 'position' ], normal, effect[ 'scale' ] or 1 )
        end
    end

    skateboard:SetControls(1) // controls
    skateboard:SetBoostShake(0) // boost shake
    skateboard:SetHoverHeight(1) // hover height
    skateboard:SetViewDistance(128) // view distance
    skateboard:SetSpring(0.07 * 0.8 * 1.6) // spring

    skateboard:SetSpeed( self.SkateData.Speed )
    skateboard:SetJumpPower( self.SkateData.JumpPower )
    skateboard:SetTurnSpeed( self.SkateData.TurnSpeed )
    skateboard:SetPitchSpeed( self.SkateData.PitchSpeed )
    skateboard:SetYawSpeed( self.SkateData.YawSpeed )
    skateboard:SetRollSpeed( self.SkateData.RollSpeed )

    skateboard:Setowning_ent( self.Owner )
    DoPropSpawnedEffect( skateboard )

    return skateboard

end

function SWEP:SecondaryAttack()

    if self.SpawnedSkate then return end
    self.SpawnedSkate = true

    local skateboard = self:SpawnSkate()
    skateboard:SetDriver(self.Owner)
    self:Remove()

end
