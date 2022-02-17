local isnil = fn.Curry(fn.Eq, 2)(nil)
local validFood = {"name", model = isstring, "energy", "price", onEaten = fn.FOr{isnil, isfunction}}

FoodItems = {}
function DarkRP.createFood(name, mdl, energy, price)
    local foodItem = istable(mdl) and mdl or {model = mdl, energy = energy, price = price}
    foodItem.name = name

    if DarkRP.DARKRP_LOADING and DarkRP.disabledDefaults["food"][name] then return end

    for k,v in pairs(validFood) do
        local isFunction = isfunction(v)

        if (isFunction and not v(foodItem[k])) or (not isFunction and foodItem[v] == nil) then
            ErrorNoHalt("Corrupt food \"" .. (name or "") .. "\": element " .. (isFunction and k or v) .. " is corrupt.\n")
        end
    end

    table.insert(FoodItems, foodItem)
end
AddFoodItem = DarkRP.createFood

DarkRP.getFoodItems = fp{fn.Id, FoodItems}

function DarkRP.removeFoodItem(i)
    local food = FoodItems[i]
    FoodItems[i] = nil
    hook.Run("onFoodItemRemoved", i, food)
end

local plyMeta = FindMetaTable("Player")
plyMeta.isCook = fn.Compose{fn.Curry(fn.GetValue, 2)("cook"), plyMeta.getJobTable}

--[[
Valid members:
    model = string, -- the model of the food item
    energy = int, -- how much energy it restores
    price = int, -- the price of the food
    requiresCook = boolean, -- whether only cooks can buy this food
    customCheck = function(ply) return boolean end, -- customCheck on purchase function
    customCheckMessage = string -- message to people who cannot buy it because of the customCheck
]]
DarkRP.DARKRP_LOADING = true

DarkRP.registerDarkRPVar("Energy", net.WriteFloat, net.ReadFloat)

local function isBariga( ply )
    return ply:Team() == TEAM_BARIGA or ply:Team() == TEAM_BARIGAVIP
end

DarkRP.createFood("Доширак (курочка)", {
    model = "models/fg/russian_food/dohik_green.mdl",
    energy = 50,
    price = 35,
    customCheck = isBariga
})
DarkRP.createFood("Доширак (говяжий)", {
    model = "models/fg/russian_food/dohik_red.mdl",
    energy = 65,
    price = 37,
    customCheck = isBariga
})
DarkRP.createFood("Доширак (минж)", {
    model = "models/fg/russian_food/dohik_minge.mdl",
    energy = 25,
    price = 30,
    customCheck = isBariga
})
DarkRP.createFood("100г арахиса", {
    model = "models/env/food/peanuts/peanuts_bowl.mdl",
    energy = 20,
    price = 20,
    customCheck = function(ply) return ply:Team() == TEAM_COOK end
})
DarkRP.createFood("Пончик", {
    model = "models/env/food/doughnuts/doughnut_single.mdl",
    energy = 15,
    price = 15,
    customCheck = function(ply) return ply:Team() == TEAM_COOK end
})
DarkRP.createFood("Коробка пончиков", {
    model = "models/env/food/doughnuts/pack_doughnuts.mdl",
    energy = 75,
    price = 100,
    customCheck = function(ply) return ply:Team() == TEAM_COOK end
})
DarkRP.createFood("Латте", {
    model = "models/env/drinks/mug/mug_random_liquid.mdl",
    energy = 15,
    price = 50,
    customCheck = function(ply) return ply:Team() == TEAM_COOK end
})
DarkRP.createFood("Молоко", {
    model = "models/env/drinks/milk_carton/milk_carton1.mdl",
    energy = 20,
    price = 20,
    customCheck = function(ply) return ply:Team() == TEAM_COOK end
})
DarkRP.createFood("Курочка-гриль", {
    model = "models/env/food/roast_chicken/roast_chicken.mdl",
    energy = 100,
    price = 120,
    customCheck = function(ply) return ply:Team() == TEAM_COOK end
})
DarkRP.createFood("Обед школьника", {
    model = "models/env/food/breakfast/breakfast.mdl",
    energy = 100,
    price = 120,
    customCheck = function(ply) return ply:Team() == TEAM_COOK end
})
DarkRP.createFood("Паста", {
    model = "models/env/food/pastaa/pasta.mdl",
    energy = 75,
    price = 95,
    customCheck = function(ply) return ply:Team() == TEAM_COOK end
})
DarkRP.createFood("Кружечка чая", {
    model = "models/env/food/tea/tea_new.mdl",
    energy = 20,
    price = 20,
    customCheck = function(ply) return ply:Team() == TEAM_COOK end
})
DarkRP.createFood("Бутеры", {
    model = "models/env/food/sandwich/nsandwich.mdl",
    energy = 25,
    price = 25,
    customCheck = function(ply) return ply:Team() == TEAM_COOK end
})


DarkRP.DARKRP_LOADING = nil
