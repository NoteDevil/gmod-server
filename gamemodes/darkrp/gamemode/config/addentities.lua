local spawnOwning = function(ply, tr, tblEnt)
    local ent = ents.Create(tblEnt.ent)
    if not ent:IsValid() then error("Entity '" .. tblEnt.ent .. "' does not exist or is not valid.") end
    ent.dt = ent.dt or {}
    ent.dt.owning_ent = ply
    if ent.Setowning_ent then ent:Setowning_ent(ply) end
    ent:SetPos(tr.HitPos)
    -- These must be set before :Spawn()
    ent.SID = ply.SID
    ent.allowed = tblEnt.allowed
    ent.DarkRPItem = tblEnt
    ent:Spawn()
    ent:CPPISetOwner(ply)

    local phys = ent:GetPhysicsObject()
    if phys:IsValid() then phys:Wake() end

    return ent
end

-----------------------------------------------------
DarkRP.createEntity("Тетрадка", {
    ent = "ent_notepad",
    model = "models/school/notepad.mdl",
    price = 25,
    max = 5,
    cmd = "buynotepad",
})

DarkRP.createEntity("Кейс для деталей", {
    ent = "ent_detailbox",
    model = "models/props_c17/SuitCase001a.mdl",
    price = 150,
    max = 1,
    cmd = "buydetailbox",
})

DarkRP.createEntity("Новостной телевизор", {
    ent = "ent_newstv",
    model = "models/props_phx/rt_screen.mdl",
    price = 500,
    max = 1,
    spawn = spawnOwning,
    cmd = "buytv",
})

DarkRP.createEntity("Футбольный мяч", {
    ent = "sent_soccerball",
    model = "models/props_phx/misc/soccerball.mdl",
    price = 500,
    max = 4,
    cmd = "buysoccerball",
    allowed = {TEAM_TEACHER_SPORT},
})

DarkRP.createEntity("Батут", {
    ent = "trampoline",
    model = "models/gmod_tower/trampoline.mdl",
    price = 3500,
    max = 3,
    cmd = "buytrampoline",
    allowed = {TEAM_TEACHER_SPORT},
})

DarkRP.createShipment("Ножик", {
    model = "models/weapons/w_csgo_default_t.mdl",
    entity = "csgo_default_t",
    price = 50000,
    amount = 1,
    noship = false,
    allowed = {TEAM_BARIGA, TEAM_BARIGAVIP},
    category = "Other",
})

DarkRP.createShipment("Отмычка", {
    model = "models/weapons/custom/w_lockpick.mdl",
    entity = "weapon_lockpick",
    price = 4500,
    amount = 1,
    noship = false,
    allowed = {TEAM_BARIGA, TEAM_BARIGAVIP},
    category = "Other",
})

-- DarkRP.createShipment("Лазерная Указка", {
--     model = "models/weapons/w_toolgun.mdl",
--     entity = "laserpointer",
--     price = 8000,
--     amount = 1,
--     noship = false,
--     allowed = {TEAM_BARIGA, TEAM_BARIGAVIP},
--     category = "Other",
-- })

DarkRP.createShipment("Сигарета Беломорканал", {
    model = "models/mordeciga/mordes/oldcigshib.mdl",
    entity = "weapon_ciga_cheap",
    price = 500,
    amount = 1,
    noship = false,
    allowed = {TEAM_BARIGA, TEAM_BARIGAVIP},
    category = "Other",
})

DarkRP.createShipment("Сигарета Ява", {
    model = "models/mordeciga/mordes/oldcigshib.mdl",
    entity = "weapon_ciga",
    price = 800,
    amount = 1,
    noship = false,
    allowed = {TEAM_BARIGA, TEAM_BARIGAVIP},
    category = "Other",
})

DarkRP.createShipment("Сигарета Captain Black", {
    model = "models/mordeciga/mordes/ciga.mdl",
    entity = "weapon_ciga_blat",
    price = 1000,
    amount = 1,
    noship = false,
    allowed = {TEAM_BARIGA, TEAM_BARIGAVIP},
    category = "Other",
})

DarkRP.createEntity("LRP PhotoPrint", {
    ent = "lrp_photoprint",
    model = "models/props_c17/consolebox03a.mdl",
    price = 7500,
    max = 1,
    cmd = "buyphotoprint",
    allowed = {TEAM_PHOTOSERVICE}
})

if not DarkRP.disabledDefaults["modules"]["hungermod"] then
    DarkRP.createEntity("Микроволновка", {
        ent = "microwave",
        model = "models/props/cs_office/microwave.mdl",
        price = 400,
        max = 1,
        cmd = "buymicrowave",
        allowed = TEAM_COOK
    })
end

DarkRP.createCategory{
    name = "Other",
    categorises = "entities",
    startExpanded = true,
    color = Color(0, 107, 0, 255),
    canSee = fp{fn.Id, true},
    sortOrder = 255,
}

DarkRP.createCategory{
    name = "Other",
    categorises = "shipments",
    startExpanded = true,
    color = Color(0, 107, 0, 255),
    canSee = fp{fn.Id, true},
    sortOrder = 255,
}

DarkRP.createCategory{
    name = "Rifles",
    categorises = "shipments",
    startExpanded = true,
    color = Color(0, 107, 0, 255),
    canSee = fp{fn.Id, true},
    sortOrder = 100,
}

DarkRP.createCategory{
    name = "Shotguns",
    categorises = "shipments",
    startExpanded = true,
    color = Color(0, 107, 0, 255),
    canSee = fp{fn.Id, true},
    sortOrder = 101,
}

DarkRP.createCategory{
    name = "Snipers",
    categorises = "shipments",
    startExpanded = true,
    color = Color(0, 107, 0, 255),
    canSee = fp{fn.Id, true},
    sortOrder = 102,
}

DarkRP.createCategory{
    name = "Pistols",
    categorises = "weapons",
    startExpanded = true,
    color = Color(0, 107, 0, 255),
    canSee = fp{fn.Id, true},
    sortOrder = 100,
}

DarkRP.createCategory{
    name = "Other",
    categorises = "weapons",
    startExpanded = true,
    color = Color(0, 107, 0, 255),
    canSee = fp{fn.Id, true},
    sortOrder = 255,
}

DarkRP.createCategory{
    name = "Other",
    categorises = "vehicles",
    startExpanded = true,
    color = Color(0, 107, 0, 255),
    canSee = fp{fn.Id, true},
    sortOrder = 255,
}

DarkRP.createCategory{
    name = "VIP",
    categorises = "entities",
    startExpanded = true,
    color = Color(182, 0, 232, 255),
    canSee = fp{fn.Id, true},
    sortOrder = 255,
}

DarkRP.createCategory{
    name = "VIP Vape",
    categorises = "entities",
    startExpanded = true,
    color = Color(182, 0, 232, 255),
    canSee = fp{fn.Id, true},
    sortOrder = 255,
}

DarkRP.createEntity( "Рояль", {
    category = "VIP",
    ent = "gmt_instrument_piano",
    model = "models/fishy/furniture/piano.mdl",
    price = 15000,
    max = 1,
    cmd = "piano",
    allowed = { TEAM_MUSIC }
} )

DarkRP.createEntity( "Барабаны", {
    category = "VIP",
    ent = "instrument_drum",
    model = "models/yukitheater/drums.mdl",
    price = 12000,
    max = 1,
    cmd = "drums",
    allowed = { TEAM_MUSIC }
} )

DarkRP.createEntity("JukeBox", {
    category = "VIP",
    ent = "jukebox",
    model = "models/fallout3/jukebox.mdl",
    price = 20000,
    max = 1,
    cmd = "jukebox",
    allowed = { TEAM_MUSIC }
})

-- DarkRP.createShipment("Гитара", {
--     name = "Other",
--     model = "models/props_phx/misc/fender.mdl",
--     entity = "guitar",
--     price = 12000,
--     amount = 1,
--     allowed = {TEAM_MUSIC},
--     category = "Rifles",
-- })

DarkRP.createEntity("Компьютер", {
    name = "Other",
    ent = "sent_computer",
    model = "models/props_lab/monitor01a.mdl",
    price = 1000,
    max = 5,
    cmd = "computer",
    allowed = {TEAM_TEACHER_ICT}
})

DarkRP.createCategory{
    name = "Майнинг",
    categorises = "entities",
    startExpanded = true,
    color = Color(120, 120, 255, 255),
    sortOrder = 1,
}

DarkRP.createEntity("Битмайнер 1", {
    ent = "bm2_bitminer_2",
    model = "models/bitminers2/bitminer_3.mdl",
    price = 5000,
    max = 2,
    cmd = "buybitminers2",
    category = "Майнинг"
})

DarkRP.createEntity("Битмайнер сервер", {
    ent = "bm2_bitminer_server",
    model = "models/bitminers2/bitminer_2.mdl",
    price = 5000,
    max = 8,
    cmd = "buybitminerserver",
    category = "Майнинг"
})

DarkRP.createEntity("Битмайнер стойка", {
    ent = "bm2_bitminer_rack",
    model = "models/bitminers2/bitminer_rack.mdl",
    price = 10000,
    max = 2,
    cmd = "buybitminerrack",
    category = "Майнинг"
})

DarkRP.createEntity("Провод доп. питания", {
    ent = "bm2_extention_lead",
    model = "models/bitminers2/bitminer_plug_3.mdl",
    price = 500,
    max = 8,
    cmd = "buybitminerextension",
    category = "Майнинг"
})

DarkRP.createEntity("Провод питания", {
    ent = "bm2_power_lead",
    model = "models/bitminers2/bitminer_plug_2.mdl",
    price = 500,
    max = 10,
    cmd = "buybitminerpowerlead",
    category = "Майнинг"
})

DarkRP.createEntity("Генератор", {
    ent = "bm2_generator",
    model = "models/bitminers2/generator.mdl",
    price = 2000,
    max = 3,
    cmd = "buybitminergenerator",
    category = "Майнинг"
})

DarkRP.createEntity("Топливо", {
    ent = "bm2_fuel",
    model = "models/props_junk/gascan001a.mdl",
    price = 750,
    max = 4,
    cmd = "buybitminerfuel",
    category = "Майнинг"
})

DarkRP.createEntity("Бумбокс", {
    ent = "3d_boombox",
    model = "models/boomboxv2/boomboxv2.mdl",
    price = 5000,
    max = 1,
    cmd = "buyboombox",
    customCheck = function( ply ) return ply:IsVIP() end,
    category = "VIP",
})

DarkRP.createEntity("Медиа телевизор", {
    ent = "mediaplayer_tv",
    model = "models/props_phx/rt_screen.mdl",
    price = 10000,
    max = 1,
    cmd = "buymediatv",
    customCheck = function( ply ) return ply:IsVIP() end,
    spawn = spawnOwning,
    category = "VIP",
})

DarkRP.createEntity("Отмычка VIP", {
    ent = "weapon_lockpick_vip",
    model = "models/weapons/custom/w_lockpick.mdl",
    price = 5000,
    max = 1,
    cmd = "buylockpickvip",
    customCheck = function( ply ) return ply:IsVIP() end,
    category = "VIP",
}) 

DarkRP.createEntity("Волшебная флейта", {
    ent = "wowozela",
    model = "models/weapons/w_bugbait.mdl",
    price = 5000,
    max = 1,
    cmd = "buywowozelavip",
    customCheck = function( ply ) return ply:IsVIP() end,
    category = "VIP",
}) 

DarkRP.createEntity("Книга", {
    ent = "ent_book",
    model = "models/fo3/misc/bookchinese_0.mdl",
    price = 2500,
    max = 2,
    cmd = "buyrandombook",
    allowed = {TEAM_LIBRARY}
}) 

/*---------------------------------------------------------------------------
Vape
---------------------------------------------------------------------------*/
DarkRP.createEntity("iJust 2", {
    ent = "weapon_vape",
    model = "models/swamponions/vape.mdl",
    price = 25000,
    max = 1,
    cmd = "buyclassicvape",
    customCheck = function( ply ) return ply:IsVIP() end,
    category = "VIP Vape",
    allowed = {TEAM_BARIGAVIP},
})

DarkRP.createEntity("iJust S", {
    ent = "weapon_vape_juicy",
    model = "models/swamponions/vape.mdl",
    price = 50000,
    max = 1,
    cmd = "buyjuicyvape",
    customCheck = function( ply ) return ply:IsVIP() end,
    category = "VIP Vape",
    allowed = {TEAM_BARIGAVIP},
})

DarkRP.createEntity("iJust S (Медицинский)", {
    ent = "weapon_vape_medicinal",
    model = "models/swamponions/vape.mdl",
    price = 80000,
    max = 1,
    cmd = "buymdeicvape",
    customCheck = function( ply ) return ply:IsVIP() end,
    category = "VIP Vape",
    allowed = {TEAM_BARIGAVIP},
})

DarkRP.createEntity("SubZero Shorty (жижка Cloud9)", {
    ent = "weapon_vape_hallucinogenic",
    model = "models/swamponions/vape.mdl",
    price = 80000,
    max = 1,
    cmd = "buyhallucivape",
    customCheck = function( ply ) return ply:IsVIP() end,
    category = "VIP Vape",
    allowed = {TEAM_BARIGAVIP},
})

DarkRP.createEntity("El Thunder (Гелий)", {
    ent = "weapon_vape_helium",
    model = "models/swamponions/vape.mdl",
    price = 100000,
    max = 1,
    cmd = "buyheliumvape",
    customCheck = function( ply ) return ply:IsVIP() end,
    category = "VIP Vape",
    allowed = {TEAM_BARIGAVIP},
})

local function spawnSkate(ply, tr, tblEnt)

    local skateboard = ents.Create(tblEnt.ent)
    if ( !IsValid( skateboard ) ) then error("Entity '" .. tblEnt.ent .. "' does not exist or is not valid.") end

    local boardinfo
    for _, board in pairs( SkateboardTypes ) do
        if ( board[ 'model' ]:lower() == tblEnt.model:lower() ) then
            boardinfo = board
            break
        end
    end
    if ( !boardinfo ) then error("No board info for '" .. tblEnt.model .. "'.") end

    util.PrecacheModel( tblEnt.model )

    skateboard:SetModel( tblEnt.model )
    skateboard:SetPos( tr.HitPos )
    skateboard:SetBoardRotation( 0 )

    if ( boardinfo[ "rotation" ] ) then
        local rot = tonumber( boardinfo[ "rotation" ] )
        skateboard:SetBoardRotation( tonumber( boardinfo[ "rotation" ] ) )
    end

    skateboard.SID = ply.SID
    skateboard.allowed = tblEnt.allowed
    skateboard.DarkRPItem = tblEnt
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

    local speed = ( 5 * 0.1 ) * 20
    skateboard:SetSpeed( speed )
    local jump = ( 0 * 0.1 ) * 250 -- It seems to me that this should be 2500
    skateboard:SetJumpPower( jump )
    local turn = ( 16 * 0.1 ) * 25
    skateboard:SetTurnSpeed( turn )
    local flip = ( 16 * 0.1 ) * 25
    skateboard:SetPitchSpeed( flip )
    local twist = ( 16 * 0.1 ) * 25
    skateboard:SetYawSpeed( twist )
    local roll = ( ( flip + twist ) / 50 ) * 22
    skateboard:SetRollSpeed( roll )

    DoPropSpawnedEffect( skateboard )
    skateboard:Setowning_ent(ply)

    return skateboard

end

DarkRP.createEntity("Скейтборд", {
    category = "VIP",
    ent = "srp_skateboard",
    model = "models/skateboard/skateboard.mdl",
    price = 30000,
    max = 1,
    spawn = spawnSkate,
    cmd = "buyskate",
    customCheck = function( ply )
        return ply:IsVIP(), 'Нужно быть VIP!'
    end
})

