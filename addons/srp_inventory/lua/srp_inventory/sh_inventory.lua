SRP_Inv = SRP_Inv or {}
SRP_Inv.Items = SRP_Inv.Items or {}

SRP_Inv.canCarry = {
	["founder"] = 30,
	["superadmin"] = 30,
	["headadmin"] = 30,

	["senioradmin"] = 20,
	["admin"] = 15,

	["dsuperadmin"] = 30,
	["dadmin"] = 20,
	["dmoder"] = 15,
	["vip"] = 15,

	["user"] = 10,
}

/*---------------------------------------------------------------------------
Config ends
---------------------------------------------------------------------------*/

function SRP_Inv:RegisterItem(item)
	SRP_Inv.Items[item.id] = item
end

function SRP_Inv:GetItem(id)
	return SRP_Inv.Items[id]
end

function SRP_Inv:GetDarkRPEntTable(ent)
	for k,v in pairs(DarkRPEntities) do
		if v.ent == ent then return v end
	end
	return false
end

local meta = FindMetaTable("Player")

function meta:GetInventory()
	return self.inventory
end

function meta:GetInventoryWeight()
	local content = self:GetInventory()
	local weight = 0
	for k,v in pairs(content) do
		if v.type == "spawned_shipment" then
			weight = weight + v.data.count
		else
			weight = weight + SRP_Inv:GetItem(v.type).weight
		end
	end
	return weight
end

function meta:InventoryLimit()
	return SRP_Inv.canCarry[self:GetUserGroup()] and
	SRP_Inv.canCarry[self:GetUserGroup()] or SRP_Inv.canCarry["user"]
end

function meta:CanCarry(ent)
	local cur_weight = self:GetInventoryWeight()
	local inv_weight = 0
	local class = ent:GetClass()

	if class == "spawned_shipment" then
		inv_weight = ent:Getcount()
	else
		inv_weight = SRP_Inv:GetItem(class).weight
	end

	if cur_weight + inv_weight > self:InventoryLimit() then
		return false
	else
		return true
	end
end

net.Receive("SRP_Inv.SyncInventory", function()
	LocalPlayer().inventory = net.ReadTable()
end)
