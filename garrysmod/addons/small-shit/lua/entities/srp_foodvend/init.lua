AddCSLuaFile "shared.lua"
AddCSLuaFile "cl_init.lua"
include "shared.lua"

function ENT:Initialize()

	self:SetModel( "models/props_interiors/vendingmachinesoda01a.mdl" )
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetUseType(SIMPLE_USE)
	local phys = self:GetPhysicsObject()
    phys:Wake()
    
end

util.AddNetworkString "SRP_FoodVend.Buy"
net.Receive( "SRP_FoodVend.Buy" , function( len, ply )
    local ent = net.ReadEntity()
    local name = net.ReadString()

    if ply:GetPos():DistToSqr( ent:GetPos() ) > 40000 or ent:GetClass() ~= "srp_foodvend" then return end
    ent:SpawnFood( ply, name )
end)

function ENT:SpawnFood( ply, name )

    -- GOOOOOOOOOOD FALCO WHYYYYYYYYYYYY?!?!?!?!?!
    for _,v in pairs(FoodItems) do
        if string.lower(name) ~= string.lower(v.name) then continue end

        ply.maxFoodItems = ply.maxFoodItems or 0
        if ply.maxFoodItems > GAMEMODE.Config.maxfooditems then
            DarkRP.notify(ply, 1, 4, DarkRP.getPhrase("limit", GAMEMODE.Config.chatCommandPrefix .. "buyfood"))

            return ""
        end
        ply.maxFoodItems = ply.maxFoodItems + 1
        
        local cost = v.price * 3
        if not ply:canAfford(cost) then
            DarkRP.notify(ply, 1, 4, DarkRP.getPhrase("cant_afford", DarkRP.getPhrase("food")))
            return ""
        end
        ply:addMoney(-cost)
        DarkRP.notify(ply, 0, 4, DarkRP.getPhrase("you_bought", v.name, DarkRP.formatMoney(cost), ""))

        local SpawnedFood = ents.Create("spawned_food")
        SpawnedFood:Setowning_ent(ply)
        SpawnedFood:SetPos( self:LocalToWorld( Vector(21, -5, -30) ) )
        SpawnedFood.onlyremover = true
        SpawnedFood.SID = ply.SID
        SpawnedFood:SetModel(v.model)

        SpawnedFood:CallOnRemove("maxFoodItems", function()
            if not IsValid(ply) then return end
            ply.maxFoodItems = ply.maxFoodItems - 1
        end)

        SpawnedFood.FoodName = v.name
        SpawnedFood.FoodEnergy = v.energy
        SpawnedFood.FoodPrice = v.price
        SpawnedFood.foodItem = v

        SpawnedFood:Spawn()
        hook.Call("playerBoughtFood", nil, ply, v, SpawnedFood, cost)

        break
    end

end
