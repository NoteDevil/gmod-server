local item = {}
item.id = "spawned_shipment"
item.color = Color(255, 255, 220)
item.name = ""
item.desc = ""
item.model = ""
item.weight = 0
item.onDrop = function(ent, ply, data)
	ent:Setcontents(data.contents)
	ent:Setcount(data.count)
end
item.onSave = function(ent)
	local to_save = {
		contents = ent:Getcontents(),
		count = ent:Getcount(),
		model = CustomShipments[ent:Getcontents()].model
	}
	return to_save
end
item.createDesc = function(item)
	return "Ящик   Кол-во: "..item.data.count
end
item.getPrintName = function(item)
	if not CLIENT then return end
	return CustomShipments[item.data.contents].name
end
SRP_Inv:RegisterItem(item)


local item = {}
item.id = "spawned_weapon"
item.color = Color(255,220,220)
item.name = ""
item.desc = "Оружие	"
item.model = ""
item.weight = 1
item.onDrop = function(ent, ply, data)
	ent:SetWeaponClass(data.class)
end
item.onSave = function(ent)
	local to_save = {
		class = ent:GetWeaponClass(),
		model = ent:GetModel()
	}
	return to_save
end
item.onUse = function(ply, data)
	ply:Give(data.class)
end
item.getPrintName = function(item)
	if not CLIENT then return end
	return weapons.Get(item.data.class).PrintName
end
SRP_Inv:RegisterItem(item)


local item = {}
item.id = "spawned_food"
item.color = Color(220,255,220)
item.name = ""
item.desc = ""
item.model = ""
item.weight = 0.2
item.onDrop = function(ent, ply, data)
	ent.foodItem = data.fooditem
end
item.onSave = function(ent)
	local to_save = {
		model = ent:GetModel(),
		fooditem = {energy = ent.foodItem.energy, name = ent.foodItem.name}
	}
	return to_save
end
item.onUse = function(ply, data)
	ply:setSelfDarkRPVar("Energy", ply:getDarkRPVar("Energy") + data.fooditem.energy)
end
item.createDesc = function(item)
	return "Пища   Энергия: "..item.data.fooditem.energy
end
item.getPrintName = function(item)
	if not CLIENT then return end
	return item.data.fooditem.name
end
SRP_Inv:RegisterItem(item)

local item = {}
item.id = "food"
item.color = Color(220,255,220)
item.name = "Китайская лапша"
item.desc = "Пища   Энергия: 100"
item.model = "models/props_junk/garbage_takeoutcarton001a.mdl"
item.weight = 0.2
item.onUse = function(ply, data)
	ply:setSelfDarkRPVar("Energy", ply:getDarkRPVar("Energy") + 100)
end
SRP_Inv:RegisterItem(item)