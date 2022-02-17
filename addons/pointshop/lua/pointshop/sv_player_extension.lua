PS_ITEM_EQUIP = 1
PS_ITEM_HOLSTER = 2
PS_ITEM_MODIFY = 3

local Player = FindMetaTable('Player')

function Player:PS_PlayerSpawn()
	-- if not self:PS_CanPerformAction() then return end

	-- TTT ( and others ) Fix
	-- if TEAM_SPECTATOR != nil and self:Team() == TEAM_SPECTATOR then return end
	-- if TEAM_SPEC != nil and self:Team() == TEAM_SPEC then return end

	-- Murder Spectator Fix (they don't specify the above enums when making teams)
	-- https://github.com/mechanicalmind/murder/blob/master/gamemode/sv_spectate.lua#L15
	-- if self.Spectating then return end

	timer.Simple(1, function()
		if !IsValid(self) then return end
		for item_id, item in pairs(self.PS_Items) do
			local ITEM = PS.Items[item_id]
			if item.Equipped then
				ITEM:OnEquip(self, item.Modifiers)
				if ITEM.Slots then

					self.PS_Slots = self.PS_Slots or {}

					for k,v in pairs(ITEM.Slots) do
						self.PS_Slots[v] = item_id
					end

				end
			end
		end
		self:PS_UpdateSlots()
	end)
end

function Player:PS_PlayerDeath()
	-- for item_id, item in pairs(self.PS_Items) do
	-- 	if item.Equipped then
	-- 		local ITEM = PS.Items[item_id]
	-- 		ITEM:OnHolster(self, item.Modifiers)
	-- 	end
	-- end
end

hook.Add("PlayerFinishedLoading", "PS_PlayerFinishedLoading", function(ply)
	ply:PS_PlayerSpawn()
end)

function Player:PS_PlayerInitialSpawn()
	self.PS_Points = 0
	self.PS_Items = {}

	if !IsValid(self) then return end

	-- Send stuff
	timer.Simple(1.5, function()

		self:PS_LoadData()

		for item_id, item in pairs(self.PS_Items) do
			local ITEM = PS.Items[item_id]
			if item.Equipped then
				ITEM:OnEquip(self, item.Modifiers)
				if ITEM.Slots then
					self.PS_Slots = self.PS_Slots or {}

					for k,v in pairs(ITEM.Slots) do
						self.PS_Slots[v] = item_id
					end

				end
			end
		end
		self:PS_SendClientsideModels()

		self:PS_UpdateSlots()

		timer.Simple( 0.1, function()
			self:KillSilent()
		end)
	end)

	if PS.Config.NotifyOnJoin then
		if PS.Config.ShopKey ~= '' then
			timer.Simple(5, function() -- Give them time to load up
				self:PS_Notify('Нажми ' .. PS.Config.ShopKey .. ', чтобы открыть магазин')
			end)
		end

		if PS.Config.ShopCommand ~= '' then
			timer.Simple(5.5, function() -- Give them time to load up
				self:PS_Notify('Type ' .. PS.Config.ShopCommand .. ' in console to open PointShop!')
			end)
		end

		if PS.Config.ShopChatCommand ~= '' then
			timer.Simple(6, function() -- Give them time to load up
				self:PS_Notify('Напиши ' .. PS.Config.ShopChatCommand .. ' в чат, чтобы открыть магазин')
			end)
		end

		timer.Simple(10, function() -- Give them time to load up
			if !IsValid(self) then return end
			self:PS_Notify('У тебя есть ' .. self:PS_GetPoints() .. PS.Config.PointsName)
		end)
	end

	if PS.Config.CheckVersion and PS.BuildOutdated and self:IsAdmin() then
		timer.Simple(5, function()
			if !IsValid(self) then return end
			self:PS_Notify("PointShop is out of date, please tell the server owner!")
		end)
	end

	if PS.Config.PointsOverTime then
		timer.Create('PS_PointsOverTime_' .. self:SteamID(), PS.Config.PointsOverTimeDelay * 60, 0, function()
			if !IsValid(self) then return end
			local amount = PS.Config.PointsOverTimeAmount[self:GetUserGroup()] or 1
			if not self.isAFK then
				self:PS_GivePoints( amount )
				self:PS_Notify("Ты получил " .. amount .. PS.Config.PointsName .. " за игру на сервере")
			else
				self:PS_Notify("Ты бы получил " .. amount .. PS.Config.PointsName .. ", если был тут")
			end
		end)
	end
end

if PS.Config.PointsOverTime then
	-- timer.Create( 'PS_PointsOverTime', 30, 0, function()
	-- 	for k, ply in pairs( player.GetAll() ) do
	-- 		ply.PS_LastPos = ply.PS_LastPos or ply:GetPos()
	-- 		ply.PS_TimeActive = ply.PS_TimeActive or 0
	--
	-- 		if (ply.PS_LastPos - ply:GetPos()):LengthSqr() > 4 then
	-- 			ply.PS_TimeActive = ply.PS_TimeActive + 1
	-- 		end
	--
	-- 		if ply.PS_TimeActive >= 180 then
	-- 			ply:PS_GivePoints(PS.Config.PointsOverTimeAmount)
	-- 			ply:PS_Notify("Ты получил ", PS.Config.PointsOverTimeAmount .. PS.Config.PointsName, " за игру на сервере")
	-- 			ply.PS_TimeActive = 0
	-- 		end
	--
	-- 		ply.PS_LastPos = ply:GetPos()
	-- 	end
	-- end)
end

function Player:PS_PlayerDisconnected()
	PS.ClientsideModels[self] = nil

	if timer.Exists('PS_PointsOverTime_' .. self:UniqueID()) then
		timer.Destroy('PS_PointsOverTime_' .. self:UniqueID())
	end
end

function Player:PS_Save()
	PS:SetPlayerData(self, self.PS_Points, self.PS_Items)
end

function Player:PS_LoadData()
	self.PS_Points = 0
	self.PS_Items = {}

	PS:GetPlayerData(self, function(points, items)
		self.PS_Points = points
		self.PS_Items = items

		self:PS_SendPoints()
		self:PS_SendItems()
	end)
end

function Player:PS_CanPerformAction(itemname)
	local allowed = true
	local itemexcept = false
	if itemname then itemexcept = PS.Items[itemname].Except end

	if (self.IsSpec and self:IsSpec()) and not itemexcept then allowed = false end
	if not self:Alive() and not itemexcept then allowed = false end
	if self:GetNWBool("Ghost") then allowed = false end


	if not allowed then
		self:PS_Notify('Ты сейчас не можешь это сделать!')
	end

	return allowed
end

-- points

function Player:PS_GivePoints(points)
	self.PS_Points = self.PS_Points + points
	PS:GivePlayerPoints(self, points)
	self:PS_SendPoints()
end

function Player:PS_TakePoints(points)
	self.PS_Points = self.PS_Points - points >= 0 and self.PS_Points - points or 0
	PS:TakePlayerPoints(self, points)
	self:PS_SendPoints()
end

function Player:PS_SetPoints(points)
	self.PS_Points = points
	PS:SetPlayerPoints(self, points)
	self:PS_SendPoints()
end

function Player:PS_GetPoints()
	return self.PS_Points and self.PS_Points or 0
end

function Player:PS_HasPoints(points)
	return self.PS_Points >= points
end

-- give/take items

function Player:PS_GiveItem(item_id)
	if not PS.Items[item_id] then return false end

	self.PS_Items[item_id] = { Modifiers = {}, Equipped = false }

	PS:GivePlayerItem(self, item_id, self.PS_Items[item_id])

	self:PS_SendItems()

	return true
end

function Player:PS_TakeItem(item_id)
	if not PS.Items[item_id] then return false end
	if not self:PS_HasItem(item_id) then return false end

	self.PS_Items[item_id] = nil

	PS:TakePlayerItem(self, item_id)

	self:PS_SendItems()

	return true
end

-- buy/sell items

function Player:PS_BuyItem(item_id)
	local ITEM = PS.Items[item_id]
	if not ITEM then return false end

	local points = PS.Config.CalculateBuyPrice(self, ITEM)

	if not self:PS_HasPoints(points) then return false end
	-- if not self:PS_CanPerformAction(item_id) then return end

	if ITEM.AdminOnly and not self:IsAdmin() then
		self:PS_Notify('This item is Admin only!')
		return false
	end

	if ITEM.AllowedUserGroups and #ITEM.AllowedUserGroups > 0 then
		if not table.HasValue(ITEM.AllowedUserGroups, self:PS_GetUsergroup()) then
			self:PS_Notify('You\'re not in the right group to buy this item!')
			return false
		end
	end

	local cat_name = ITEM.Category
	local CATEGORY = PS:FindCategoryByName(cat_name)

	if CATEGORY.AllowedUserGroups and #CATEGORY.AllowedUserGroups > 0 then
		if not table.HasValue(CATEGORY.AllowedUserGroups, self:PS_GetUsergroup()) then
			self:PS_Notify('You\'re not in the right group to buy this item!')
			return false
		end
	end

	if CATEGORY.CanPlayerSee then
		if not CATEGORY:CanPlayerSee(self) then
			self:PS_Notify('Ты сейчас не можешь это сделать!')
			return false
		end
	end

	if ITEM.CanPlayerBuy then -- should exist but we'll check anyway
		local allowed, message
		if ( type(ITEM.CanPlayerBuy) == "function" ) then
			allowed, message = ITEM:CanPlayerBuy(self)
		elseif ( type(ITEM.CanPlayerBuy) == "boolean" ) then
			allowed = ITEM.CanPlayerBuy
		end

		if not allowed then
			self:PS_Notify(message or 'Ты сейчас не можешь это сделать!')
			return false
		end
	end

	self:PS_TakePoints(points)

	self:PS_Notify('Ты купил ' .. ITEM.Name )

	ITEM:OnBuy(self)

	hook.Call( "PS_ItemPurchased", nil, self, item_id )

	if ITEM.SingleUse then
		self:PS_Notify('Успешно приобретен одноразовый предмет!')
		return
	end

	self:PS_GiveItem(item_id)
	-- self:PS_EquipItem(item_id)
end

function Player:PS_SellItem(item_id)
	if not PS.Items[item_id] then return false end
	if not self:PS_HasItem(item_id) then return false end
	if self:PS_HasItemEquipped(item_id) and not self:PS_CanPerformAction(item_id) then return end

	local ITEM = PS.Items[item_id]

	if ITEM.CanPlayerSell then -- should exist but we'll check anyway
		local allowed, message
		if ( type(ITEM.CanPlayerSell) == "function" ) then
			allowed, message = ITEM:CanPlayerSell(self)
		elseif ( type(ITEM.CanPlayerSell) == "boolean" ) then
			allowed = ITEM.CanPlayerSell
		end

		if not allowed then
			self:PS_Notify(message or 'Ты сейчас не можешь это сделать!')
			return false
		end
	end

	local points = PS.Config.CalculateSellPrice(self, ITEM)
	self:PS_GivePoints(points)

	ITEM:OnHolster(self)
	ITEM:OnSell(self)

	hook.Call( "PS_ItemSold", nil, self, item_id )

	self:PS_Notify('Ты продал ' .. ITEM.Name )

	return self:PS_TakeItem(item_id)
end

function Player:PS_HasItem(item_id)
	return self.PS_Items[item_id] or false
end

function Player:PS_HasItemEquipped(item_id)
	if not self:PS_HasItem(item_id) then return false end

	return self.PS_Items[item_id].Equipped or false
end

function Player:PS_NumItemsEquippedFromCategory(cat_name)
	local count = 0

	for item_id, item in pairs(self.PS_Items) do
		local ITEM = PS.Items[item_id]
		if ITEM.Category == cat_name and item.Equipped then
			count = count + 1
		end
	end

	return count
end

-- equip/hoster items

function Player:PS_EquipItem(item_id)
	if not PS.Items[item_id] then return false end
	if not self:PS_HasItem(item_id) then return false end
	if not self:PS_CanPerformAction(item_id) then return false end

	local ITEM = PS.Items[item_id]

	if type(ITEM.CanPlayerEquip) == 'function' then
		allowed, message = ITEM:CanPlayerEquip(self)
	elseif type(ITEM.CanPlayerEquip) == 'boolean' then
		allowed = ITEM.CanPlayerEquip
	end

	if not allowed then
		self:PS_Notify(message or 'Ты сейчас не можешь это сделать!')
		return false
	end

	local cat_name = ITEM.Category
	local CATEGORY = PS:FindCategoryByName(cat_name)

	-- if CATEGORY and CATEGORY.AllowedEquipped > -1 then
	-- 	if self:PS_NumItemsEquippedFromCategory(cat_name) + 1 > CATEGORY.AllowedEquipped then
	-- 		self:PS_Notify('Only ' .. CATEGORY.AllowedEquipped .. ' item' .. (CATEGORY.AllowedEquipped == 1 and '' or 's') .. ' can be equipped from this category!')
	-- 		return false
	-- 	end
	-- end

	if PS.Items[item_id].Slots then

		self.PS_Slots = self.PS_Slots or {}

		for k,v in pairs(PS.Items[item_id].Slots) do
			for slot, id in pairs(self.PS_Slots) do
				if v == slot then
					if id == "_job" then self:PS_Notify('Unavailable for this job!') return false end
					self:PS_HolsterItem(id)
				end
			end
		end

		for k,v in pairs(PS.Items[item_id].Slots) do
			self.PS_Slots[v] = item_id
		end
		self:PS_UpdateSlots()
	end


	if CATEGORY.SharedCategories then
		local ConCatCats = CATEGORY.Name
		for p, c in pairs( CATEGORY.SharedCategories ) do
			if p ~= #CATEGORY.SharedCategories then
				ConCatCats = ConCatCats .. ', ' .. c
			else
				if #CATEGORY.SharedCategories ~= 1 then
					ConCatCats = ConCatCats .. ', и ' .. c
				else
					ConCatCats = ConCatCats .. ' и ' .. c
				end
			end
		end
		local NumEquipped = self.PS_NumItemsEquippedFromCategory
		for id, item in pairs(self.PS_Items) do
			if not self:PS_HasItemEquipped(id) then continue end
			local CatName = PS.Items[id].Category
			local Cat = PS:FindCategoryByName( CatName )
			if not Cat.SharedCategories then continue end
			for _, SharedCategory in pairs( Cat.SharedCategories ) do
				if SharedCategory == CATEGORY.Name then
					if Cat.AllowedEquipped > -1 and CATEGORY.AllowedEquipped > -1 then
						if NumEquipped(self,CatName) + NumEquipped(self,CATEGORY.Name) + 1 > Cat.AllowedEquipped then
							self:PS_Notify('Only ' .. Cat.AllowedEquipped .. ' item'.. (Cat.AllowedEquipped == 1 and '' or 's') ..' can be equipped over ' .. ConCatCats .. '!')
							return false
						end
					end
				end
			end
		end
	end

	self.PS_Items[item_id].Equipped = true

	ITEM:OnEquip(self, self.PS_Items[item_id].Modifiers)

	self:PS_Notify('Ты надел ' .. ITEM.Name )

	hook.Call( "PS_ItemUpdated", nil, self, item_id, PS_ITEM_EQUIP )

	PS:SavePlayerItem(self, item_id, self.PS_Items[item_id])

	self:PS_SendItems()
end

function Player:PS_HolsterItem(item_id)
	if not PS.Items[item_id] then return false end
	if not self:PS_HasItem(item_id) then return false end
	if not self:PS_CanPerformAction(item_id) then return false end

	if self.PS_Items[item_id].Equipped == false then return end

	self.PS_Items[item_id].Equipped = false

	local ITEM = PS.Items[item_id]

	if type(ITEM.CanPlayerHolster) == 'function' then
		allowed, message = ITEM:CanPlayerHolster(self)
	elseif type(ITEM.CanPlayerHolster) == 'boolean' then
		allowed = ITEM.CanPlayerHolster
	end

	if PS.Items[item_id].Slots then

		self.PS_Slots = self.PS_Slots or {}

		for k,v in pairs(PS.Items[item_id].Slots) do
			self.PS_Slots[v] = nil
		end
		self:PS_UpdateSlots()
	end

	if not allowed then
		self:PS_Notify(message or 'Ты сейчас не можешь это сделать!')
		return false
	end

	ITEM:OnHolster(self)

	self:PS_Notify('Ты снял ' .. ITEM.Name )

	hook.Call( "PS_ItemUpdated", nil, self, item_id, PS_ITEM_HOLSTER )

	PS:SavePlayerItem(self, item_id, self.PS_Items[item_id])

	self:PS_SendItems()
end

-- modify items

function Player:PS_ModifyItem(item_id, modifications)
	if not PS.Items[item_id] then return false end
	if not self:PS_HasItem(item_id) then return false end
	if not type(modifications) == "table" then return false end
	if not self:PS_CanPerformAction(item_id) then return false end

	local ITEM = PS.Items[item_id]

	for key, value in pairs(modifications) do
		self.PS_Items[item_id].Modifiers[key] = value
	end

	ITEM:OnModify(self, self.PS_Items[item_id].Modifiers)

	hook.Call( "PS_ItemUpdated", nil, self, item_id, PS_ITEM_MODIFY, modifications )

	PS:SavePlayerItem(self, item_id, self.PS_Items[item_id])

	self:PS_SendItems()
end

-- clientside Models

function Player:PS_AddClientsideModel(item_id)
	if not PS.Items[item_id] then return false end
	if not self:PS_HasItem(item_id) then return false end

	net.Start('PS_AddClientsideModel')
		net.WriteEntity(self)
		net.WriteString(item_id)
	net.Broadcast()

	if not PS.ClientsideModels[self] then PS.ClientsideModels[self] = {} end

	PS.ClientsideModels[self][item_id] = item_id
end

function Player:PS_RemoveClientsideModel(item_id)
	if not PS.Items[item_id] then return false end
	if not self:PS_HasItem(item_id) then return false end
	if not PS.ClientsideModels[self] or not PS.ClientsideModels[self][item_id] then return false end

	net.Start('PS_RemoveClientsideModel')
		net.WriteEntity(self)
		net.WriteString(item_id)
	net.Broadcast()

	PS.ClientsideModels[self][item_id] = nil
end

-- menu stuff

function Player:PS_ToggleMenu(show)
	net.Start('PS_ToggleMenu')
	net.Send(self)
end

-- send stuff

function Player:PS_SendPoints()
	net.Start('PS_Points')
		net.WriteEntity(self)
		net.WriteInt(self.PS_Points, 32)
	net.Broadcast()
end

function Player:PS_SendItems()
	net.Start('PS_Items')
		net.WriteEntity(self)
		net.WriteTable(self.PS_Items)
	net.Broadcast()
end

function Player:PS_SendClientsideModels()
	net.Start('PS_SendClientsideModels')
		net.WriteTable(PS.ClientsideModels)
	net.Send(self)
end

function Player:PS_UpdateSlots()
	self.PS_Slots = self.PS_Slots or {}
	net.Start('PS_UpdateSlots')
	net.WriteTable(self.PS_Slots)
	net.Send(self)
end

-- notifications

function Player:PS_Notify(...)
	local str = table.concat({...}, '')

	net.Start('PS_SendNotification')
		net.WriteString(str)
	net.Send(self)
end

-- handle player change team
function Player:PS_OnPlayerChangedTeam(oldTeam, newTeam)
	for k,v in pairs(self.PS_Slots) do
		if v == "_job" then
			self.PS_Slots[k] = nil
		end
	end

	if RPExtraTeams[newTeam].slots then
		for k,v in pairs(RPExtraTeams[newTeam].slots) do
			for slot, id in pairs(self.PS_Slots) do
				if v == slot then
					self:PS_HolsterItem(id)
					self.PS_Slots[v] = "_job"
				end
			end
		end
	end

	self:PS_UpdateSlots()
	return true
end
