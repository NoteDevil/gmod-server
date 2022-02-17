local plugin = plugin;

plugin:IncludeFile("shared.lua", SERVERGUARD.STATE.SHARED);
plugin:IncludeFile("sh_commands.lua", SERVERGUARD.STATE.SHARED);
plugin:IncludeFile("sh_drp_commands.lua", SERVERGUARD.STATE.SHARED);

--
-- INTERACTIVE BANS
--

hook.Add("PlayerInitialSpawn", "DarkRP_bans", function( ply )
    timer.Simple( 5, function() -- why? because darkrp
        if IsValid(ply) and serverguard.banTable[ ply:SteamID() ] then
            local steamID = ply:SteamID()
            local time = serverguard.banTable[ steamID ].endTime - os.time()

            ply:changeTeam( TEAM_BANNED, true, false )
            ply:SetNWBool( "IsBanned", true )
            ply:SetNWFloat( "UnBanTime", time > 0 and CurTime() + time or 0 )

            if serverguard.banTable[ steamID ].endTime > os.time() then
                local tname = "BanTimer" .. steamID
                timer.Create( tname, time, 1, function()
                    serverguard:UnbanPlayer( steamID )
                end)
                timer.Start( tname )
            end
        end
    end )
end)

hook.Add("serverguard.PostPlayerBanned", "DarkRP_bans", function( admin, steamID, reason, length )
    local ply = player.GetBySteamID( steamID )
    if not IsValid(ply) or not serverguard.banTable[ steamID ] then return end

    local time = serverguard.banTable[ steamID ].endTime - os.time()
    ply:changeTeam( TEAM_BANNED, true, false )
    ply:SetNWBool( "IsBanned", true )
    ply:SetNWFloat( "UnBanTime", time > 0 and CurTime() + time or 0 )

    if serverguard.banTable[ steamID ].endTime > os.time() then
        local tname = "BanTimer" .. steamID
        timer.Create( tname, time, 1, function()
            serverguard:UnbanPlayer( steamID )
        end)
        timer.Start( tname )
    end
end)

hook.Add("serverguard.PostPlayerUnBanned", "DarkRP_bans", function( admin, steamID )
    local ply = player.GetBySteamID( steamID )
    if IsValid(ply) then
        ply:SetNWBool( "IsBanned", false )
        ply:changeTeam( TEAM_SHKOLNIK )
        DarkRP.notify( ply, NOTIFY_CLEANUP, 30, "Срок твоего бана истек!" )
    end
end)

hook.Add("PlayerDisconnected", "DarkRP_bans", function( ply )
    if ply:GetNWBool( "IsBanned" ) then
        timer.Remove( "BanTimer" .. ply:SteamID() )
    end
end)

hook.Add("OnPlayerChangedTeam", "DarkRP_bans", function( ply, oldTeam, newTeam )
    if oldTeam == TEAM_BANNED then
        ply:SetViewOffset( Vector(0, 0, 64) )
        ply:SetViewOffsetDucked( Vector(0, 0, 28) )
    end
end)

local deniedTexts = {
    "А-та-та, ты наказан, забыл?",
    "Ты находишься в бане",
    "Не-а, не надо было нарушать",
    "Придется подождать с этим",
    "Ты все еще отбываешь наказание",
}

hook.Add("PlayerCanHearPlayersVoice", "DarkRP_bans", function( listener, talker )
    if talker:GetNWBool( "IsBanned" ) then
        return false
    end
end)

hook.Add("playerGetSalary", "DarkRP_bans", function( ply, amount )
    if IsValid(ply) and ply:GetNWBool( "IsBanned" ) then
        return true, "Ты можешь купить разбан в магазине на <color=50,200,50>F2</color>", 0
    end
end)

local function restrictBannedPlayer( ply )
    if IsValid(ply) and ply:GetNWBool( "IsBanned" ) then
        DarkRP.notify( ply, NOTIFY_ERROR, 2, deniedTexts[ math.random( #deniedTexts ) ] )
        return false
    end
end
hook.Add("canChangeJob", "DarkRP_bans", restrictBannedPlayer)
hook.Add("CanChangeRPName", "DarkRP_bans", restrictBannedPlayer)
hook.Add("canChatCommand", "DarkRP_bans", restrictBannedPlayer)
hook.Add("canDarkRPUse", "DarkRP_bans", restrictBannedPlayer)
hook.Add("canDemote", "DarkRP_bans", restrictBannedPlayer)
hook.Add("canStartVote", "DarkRP_bans", restrictBannedPlayer)
hook.Add("canVote", "DarkRP_bans", restrictBannedPlayer)
hook.Add("playerCanChangeTeam", "DarkRP_bans", restrictBannedPlayer)
hook.Add("PlayerCanPickupWeapon", "DarkRP_bans", restrictBannedPlayer)
hook.Add("PlayerSpawnObject", "DarkRP_bans", restrictBannedPlayer)
