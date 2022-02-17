util.AddNetworkString("SRP_Inv.SyncInventory")
util.AddNetworkString("SRP_Inv.SpawnItem")
util.AddNetworkString("SRP_Inv.UseItem")

/*---------------------------------------------------------------------------
Meta
---------------------------------------------------------------------------*/
local meta = FindMetaTable("Player")

function meta:SetInventory(tbl)
	self.inventory = tbl
	self:SyncInventory()
end

function meta:AddInventory(item_tbl)
	table.insert(self.inventory, item_tbl)
	self:SyncInventory()
end

function meta:RemoveInventory(id)
	local contents = self:GetInventory()
	table.remove(contents, id)
	self:SetInventory(contents)
end

function meta:GetInventoryItem(id)
	local item = self:GetInventory()[id]
	return item
end

function meta:SyncInventory()
	net.Start("SRP_Inv.SyncInventory")
	net.WriteTable(self.inventory)
	net.Send(self)

	self:UpdateInventoryTable()
end

function meta:UpdateInventoryTable()
	MySQLite.query("UPDATE `srp_inventory` SET `contents` = "..MySQLite.SQLStr(util.TableToJSON(self:GetInventory())).." WHERE `steamid` = '"..self:SteamID().."';")
end

function meta:AddEntityInv(ent)
	local item_tbl = SRP_Inv:GetItem(ent:GetClass())
	if not item_tbl then DarkRP.notify(self, 1, 4, "Этот предмет нельзя положить в инвентарь.") return end
	if not self:CanCarry(ent) then DarkRP.notify(self, 1, 4, "В инвентаре не хватает места.") return end

	if item_tbl.canPickup then 
		local bCanPickup, msg = item_tbl.canPickup(ent, self)
		if not bCanPickup then
			DarkRP.notify(self, 1, 4, msg)
			return 
		end
	end

	local item = { type = ent:GetClass() }
	if item_tbl.onSave then
		item.data = item_tbl.onSave(ent)
	end

	hook.Run('SRP_Inv.OnItemPickup', self, ent)
	
	self:AddInventory(item)
	DarkRP.notify(self, 0, 4, "Предмет добавлен в инвентарь.")
	ent:Remove()

end

/*---------------------------------------------------------------------------
Other
---------------------------------------------------------------------------*/
hook.Add( "DarkRPDBInitialized", "SRP_Inv.DarkRPDBInitialized", function()
	MySQLite.query("CREATE TABLE IF NOT EXISTS `srp_inventory` ( steamid VARCHAR(255) PRIMARY KEY, contents TEXT);")
end)

hook.Add("PlayerIsLoaded", "SRP_Inv.PlayerIsLoaded", function( ply )
	local steamid = ply:SteamID()

	MySQLite.query("SELECT * FROM `srp_inventory` WHERE `steamid` = '"..steamid.."';", function(results)
		if results then
			ply:SetInventory(util.JSONToTable(results[1].contents))
		else
			MySQLite.query("INSERT INTO `srp_inventory` ( steamid, contents ) VALUES ( '"..steamid.."', '[]' );")
			ply:SetInventory({})
		end
	end)
end)

/*---------------------------------------------------------------------------
Net Shit
---------------------------------------------------------------------------*/
net.Receive("SRP_Inv.SpawnItem", function(len, ply)
	local id = net.ReadInt(8)
	local item = ply:GetInventoryItem(id)
	if not item then
		DarkRP.notify( ply, NOTIFY_ERROR, 5, "Упс... Что-то пошло не так, сообщи админам, как ты это сделал через <color=50,200,50>@ текст</color>" )
		return
	end
	local item_tbl = SRP_Inv:GetItem(item.type)
	local model = item.data and item.data.model and item.data.model or item_tbl.model

	local ent_tbl = SRP_Inv:GetDarkRPEntTable(item.type)

	if ent_tbl then 
		if ply:customEntityLimitReached(ent_tbl) then
			DarkRP.notify(ply, 1, 4, DarkRP.getPhrase("limit", ent_tbl.name))
    		return
		end
		ply:addCustomEntity(ent_tbl)
	end

	local ent = ents.Create(item.type)
	ent:SetPos(ply:GetPos() + ply:GetForward()*70 + ply:GetUp()*50)
	ent:SetModel(model)

	if ent_tbl then
		ent.allowed = ent_tbl.allowed
		ent.DarkRPItem = ent_tbl
	end
	ent.SID = ply.SID

	if item.type == "spawned_shipment" then
		if item_tbl.onDrop then item_tbl.onDrop(ent, ply, item.data) end
	end

	ent:Spawn()
	ent:Activate()
	if ent.Setowning_ent then ent:Setowning_ent(ply) end

	if item_tbl.onDrop and item.type ~= "spawned_shipment" then item_tbl.onDrop(ent, ply, item.data) end
	ply:RemoveInventory(id)

	hook.Run('SRP_Inv.OnItemDrop', ply, ent)
end)

net.Receive("SRP_Inv.UseItem", function(len, ply)
	local id = net.ReadInt(8)
	local item = ply:GetInventoryItem(id)
	local item_tbl = SRP_Inv:GetItem(item.type)
	item_tbl.onUse(ply, item.data)
	ply:RemoveInventory(id)
end)