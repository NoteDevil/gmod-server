local maxPerPlayer = 2

local presentsToday = {}
local presentsEnts = {}

local function pickRandomPlayers( amount )

    local plys = player.GetAll()
    table.sort(plys, function(a, b)
        return (presentsToday[a:SteamID()] or 0) < (presentsToday[b:SteamID()] or 0)
    end)

    local receivers = {}
    for i = 1, amount do
        if (i > #plys) or ((presentsToday[plys[i]:SteamID()] or 0) >= maxPerPlayer) then break end
        table.insert(receivers, plys[i])
    end

    return receivers

end

local function givePresents()

    local amount = math.Round(player.GetCount() / 5)
    if amount < 1 then return end
    
    local receivers = pickRandomPlayers(amount)
    if #receivers < 1 then return end
    
    local receiversText = ''
    for i, ply in ipairs(receivers) do
        local pos = Vector(-278, -3580, 66) + VectorRand() * 20
        local ang = Angle(0, math.random(-180,180), 0)
        local p = ents.Create('srp_present')
        p:SetPos(pos)
        p:SetAngles(ang)
        p:Spawn()
        p.isFor = ply

        local separator = (i == #receivers-1) and ' и ' or (i == #receivers) and '' or ', '
        receiversText = receiversText .. '<color=50,200,50>' .. ply:Name() .. '</color>' .. separator

        local steamID = ply:SteamID()
        presentsToday[steamID] = presentsToday[steamID] and presentsToday[steamID] + 1 or 1

        timer.Simple(10 * 60, function()
            if IsValid(p) then p:Remove() end
        end)
    end

    DarkRP.notifyAll(NOTIFY_GENERIC, 30, 'Подарки для ' .. receiversText .. ' уже лежат под елкой!')

end

hook.Add("PlayerIsLoaded", "srp_presents", function()
    timer.Create('srp_presents', 60 * 60, 0, givePresents)
    timer.Start('srp_presents')

    hook.Remove("PlayerIsLoaded", "srp_presents")
end)
