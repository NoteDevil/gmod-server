--[[
	pointshop/sv_init.lua
	first file included serverside.
]]--

include "sh_init.lua"
include "sv_player_extension.lua"
include "sv_manifest.lua"

PS_ModelOffsets = {}
if file.Exists( "ps_offsets/data.dat", "DATA" ) then
	local data = file.Read( "ps_offsets/data.dat" )
	PS_ModelOffsets = util.JSONToTable( data )
end

util.AddNetworkString "PS_ModelOffsets"
hook.Add( "PlayerIsLoaded", "PS_SendOffsets", function( ply )

	net.Start( "PS_ModelOffsets" )
		net.WriteTable( PS_ModelOffsets )
	net.Send( ply )

end)

-- net hooks

net.Receive('PS_BuyItem', function(length, ply)
	ply:PS_BuyItem(net.ReadString())
end)

net.Receive('PS_SellItem', function(length, ply)
	ply:PS_SellItem(net.ReadString())
end)

net.Receive('PS_EquipItem', function(length, ply)
	ply:PS_EquipItem(net.ReadString())
end)

net.Receive('PS_HolsterItem', function(length, ply)
	ply:PS_HolsterItem(net.ReadString())
end)

net.Receive('PS_ModifyItem', function(length, ply)
	ply:PS_ModifyItem(net.ReadString(), net.ReadTable())
end)

-- player to player

net.Receive('PS_SendPoints', function(length, ply)
	local other = net.ReadEntity()
	local points = math.Clamp(net.ReadInt(32), 0, 1000000)

	if not PS.Config.CanPlayersGivePoints then return end
	if not points or points == 0 then return end
	if not other or not IsValid(other) or not other:IsPlayer() then return end
	if not ply or not IsValid(ply) or not ply:IsPlayer() then return end
	if not ply:PS_HasPoints(points) then
		ply:PS_Notify("У тебя нет ", points .. PS.Config.PointsName, ".")
		return
	end

	ply.PS_LastGavePoints = ply.PS_LastGavePoints or 0
	if ply.PS_LastGavePoints + 5 > CurTime() then
		ply:PS_Notify("Погоди чутка")
		return
	end

	ply:PS_TakePoints(points)
	ply:PS_Notify("Ты отдал ", other:Nick(), " ", points .. PS.Config.PointsName, ".")

	other:PS_GivePoints(points)
	other:PS_Notify(ply:Nick(), " дал тебе ", points .. PS.Config.PointsName, ".")

	ply.PS_LastGavePoints = CurTime()
end)

-- admin points

net.Receive('PS_GivePoints', function(length, ply)
	local other = net.ReadEntity()
	local points = net.ReadInt(32)

	if not PS.Config.AdminCanAccessAdminTab and not PS.Config.SuperAdminCanAccessAdminTab then return end

	local admin_allowed = PS.Config.AdminCanAccessAdminTab and ply:IsAdmin()
	local super_admin_allowed = PS.Config.SuperAdminCanAccessAdminTab and ply:IsSuperAdmin()

	if (admin_allowed or super_admin_allowed) and other and points and IsValid(other) and other:IsPlayer() then
		other:PS_GivePoints(points)
		other:PS_Notify(ply:Nick(), ' дал тебе ', points .. PS.Config.PointsName, '.')
	end
end)

net.Receive('PS_TakePoints', function(length, ply)
	local other = net.ReadEntity()
	local points = net.ReadInt(32)

	if not PS.Config.AdminCanAccessAdminTab and not PS.Config.SuperAdminCanAccessAdminTab then return end

	local admin_allowed = PS.Config.AdminCanAccessAdminTab and ply:IsAdmin()
	local super_admin_allowed = PS.Config.SuperAdminCanAccessAdminTab and ply:IsSuperAdmin()

	if (admin_allowed or super_admin_allowed) and other and points and IsValid(other) and other:IsPlayer() then
		other:PS_TakePoints(points)
		other:PS_Notify(ply:Nick(), ' забрал у тебя ', points .. PS.Config.PointsName )
	end
end)

net.Receive('PS_SetPoints', function(length, ply)
	local other = net.ReadEntity()
	local points = net.ReadInt(32)

	if not PS.Config.AdminCanAccessAdminTab and not PS.Config.SuperAdminCanAccessAdminTab then return end

	local admin_allowed = PS.Config.AdminCanAccessAdminTab and ply:IsAdmin()
	local super_admin_allowed = PS.Config.SuperAdminCanAccessAdminTab and ply:IsSuperAdmin()

	if (admin_allowed or super_admin_allowed) and other and points and IsValid(other) and other:IsPlayer() then
		other:PS_SetPoints(points)
		other:PS_Notify(ply:Nick(), ' установил твой баланс на ', PS.Config.PointsName .. points )
	end
end)

-- admin items

net.Receive('PS_GiveItem', function(length, ply)
	local other = net.ReadEntity()
	local item_id = net.ReadString()

	if not PS.Config.AdminCanAccessAdminTab and not PS.Config.SuperAdminCanAccessAdminTab then return end

	local admin_allowed = PS.Config.AdminCanAccessAdminTab and ply:IsAdmin()
	local super_admin_allowed = PS.Config.SuperAdminCanAccessAdminTab and ply:IsSuperAdmin()

	if (admin_allowed or super_admin_allowed) and other and item_id and PS.Items[item_id] and IsValid(other) and other:IsPlayer() and not other:PS_HasItem(item_id) then
		other:PS_GiveItem(item_id)
	end
end)

net.Receive('PS_TakeItem', function(length, ply)
	local other = net.ReadEntity()
	local item_id = net.ReadString()

	if not PS.Config.AdminCanAccessAdminTab and not PS.Config.SuperAdminCanAccessAdminTab then return end

	local admin_allowed = PS.Config.AdminCanAccessAdminTab and ply:IsAdmin()
	local super_admin_allowed = PS.Config.SuperAdminCanAccessAdminTab and ply:IsSuperAdmin()

	if (admin_allowed or super_admin_allowed) and other and item_id and PS.Items[item_id] and IsValid(other) and other:IsPlayer() and other:PS_HasItem(item_id) then
		-- holster it first without notificaiton
		other.PS_Items[item_id].Equipped = false

		local ITEM = PS.Items[item_id]
		ITEM:OnHolster(other)
		other:PS_TakeItem(item_id)
	end
end)

-- hooks

local KeyToHook = {
	F1 = "ShowHelp",
	F2 = "ShowTeam",
	F3 = "ShowSpare1",
	F4 = "ShowSpare2",
	None = "ThisHookDoesNotExist"
}

hook.Add(KeyToHook[PS.Config.ShopKey], "PS_ShopKey", function(ply)
	ply:PS_ToggleMenu()
end)

hook.Add('PlayerSpawn', 'PS_PlayerSpawn', function(ply) ply:PS_PlayerSpawn() end)
hook.Add('PlayerDeath', 'PS_PlayerDeath', function(ply) ply:PS_PlayerDeath() end)
hook.Add('PlayerInitialSpawn', 'PS_PlayerInitialSpawn', function(ply) ply:PS_PlayerInitialSpawn() end)
hook.Add('PlayerDisconnected', 'PS_PlayerDisconnected', function(ply) ply:PS_PlayerDisconnected() end)
hook.Add('OnPlayerChangedTeam','PS_OnPlayerChangedTeam',function(ply, oldTeam, newTeam) ply:PS_OnPlayerChangedTeam(oldTeam, newTeam) end)


hook.Add('PlayerSay', 'PS_PlayerSay', function(ply, text)
	if string.len(PS.Config.ShopChatCommand) > 0 then
		if string.sub(text, 0, string.len(PS.Config.ShopChatCommand)) == PS.Config.ShopChatCommand then
			ply:PS_ToggleMenu()
			return ''
		end
	end
end)

-- ugly networked strings

util.AddNetworkString('PS_ReloadMenu')
util.AddNetworkString('PS_Items')
util.AddNetworkString('PS_Points')
util.AddNetworkString('PS_BuyItem')
util.AddNetworkString('PS_SellItem')
util.AddNetworkString('PS_EquipItem')
util.AddNetworkString('PS_HolsterItem')
util.AddNetworkString('PS_ModifyItem')
util.AddNetworkString('PS_SendPoints')
util.AddNetworkString('PS_GivePoints')
util.AddNetworkString('PS_TakePoints')
util.AddNetworkString('PS_SetPoints')
util.AddNetworkString('PS_GiveItem')
util.AddNetworkString('PS_TakeItem')
util.AddNetworkString('PS_AddClientsideModel')
util.AddNetworkString('PS_RemoveClientsideModel')
util.AddNetworkString('PS_SendClientsideModels')
util.AddNetworkString('PS_SendNotification')
util.AddNetworkString('PS_ToggleMenu')
util.AddNetworkString('PS_UpdateSlots') -- kek

-- console commands

concommand.Add('ps_reload', function(ply, cmd, args)
	ply.PS_LastReload = ply.PS_LastReload or 0
	if CurTime() - ply.PS_LastReload < 5 then
		ply:PS_Notify("Перезагружать данные можно раз в 5 секунд")
		return
	end
	ply.PS_LastReload = CurTime()

	ply.PS_Points = 0
	ply.PS_Items = {}

	PS:GetPlayerData(ply, function( points, items )
		ply.PS_Points = points
		ply.PS_Items = items

		ply:PS_SendPoints()
		ply:PS_SendItems()

		timer.Simple( 0, function()
			net.Start( "PS_ReloadMenu" )
			net.Send( ply )
		end)
	end)
end)

concommand.Add(PS.Config.ShopCommand, function(ply, cmd, args)
	ply:PS_ToggleMenu()
end)

concommand.Add('ps_clear_points', function(ply, cmd, args)
	if IsValid(ply) then return end -- only allowed from server console

	for _, ply in pairs(player.GetAll()) do
		ply:PS_SetPoints(0)
	end

	sql.Query("DELETE FROM playerpdata WHERE infoid LIKE '%PS_Points%'")
end)

concommand.Add('ps_clear_items', function(ply, cmd, args)
	if IsValid(ply) then return end -- only allowed from server console

	for _, ply in pairs(player.GetAll()) do
		ply.PS_Items = {}
		ply:PS_SendItems()
	end

	sql.Query("DELETE FROM playerpdata WHERE infoid LIKE '%PS_Items%'")
end)

-- version checker

PS.CurrentBuild = 0
PS.LatestBuild = 0
PS.BuildOutdated = false

local function CompareVersions()
	if PS.CurrentBuild < PS.LatestBuild then
		-- MsgN('PointShop is out of date!')
		-- MsgN('Local version: ' .. PS.CurrentBuild .. ', Latest version: ' .. PS.LatestBuild)

		PS.BuildOutdated = true
	else
		MsgN('PointShop is on the latest version.')
	end
end

function PS:CheckVersion()
	if file.Exists('data/pointshop_build.txt', 'GAME') then
		PS.CurrentBuild = tonumber(file.Read('data/pointshop_build.txt', 'GAME')) or 0
	end

	local url = self.Config.Branch .. 'data/pointshop_build.txt'
	http.Fetch( url,
		function( content ) -- onSuccess
			PS.LatestBuild = tonumber( content ) or 0
			CompareVersions()
		end,
		function(failCode) -- onFailure
			-- MsgN('PointShop couldn\'t check version.')
			-- MsgN(url, ' returned ', failCode)
		end
	)
end

-- data providers

function PS:LoadDataProvider()
	local path = "pointshop/providers/" .. self.Config.DataProvider .. ".lua"
	if not file.Exists(path, "LUA") then
		error("Pointshop data provider not found. " .. path)
	end

	PROVIDER = {}
	PROVIDER.__index = {}
	PROVIDER.ID = self.Config.DataProvider

	include(path)

	self.DataProvider = PROVIDER
	PROVIDER = nil
end

function PS:GetPlayerData(ply, callback)
	self.DataProvider:GetData(ply, function(points, items)
		callback(PS:ValidatePoints(tonumber(points)), PS:ValidateItems(items))
	end)
end

function PS:SetPlayerData(ply, points, items)
	self.DataProvider:SetData(ply, points, items)
end

function PS:SetPlayerPoints(ply, points)
	self.DataProvider:SetPoints(ply, points)
end

function PS:GivePlayerPoints(ply, points)
	self.DataProvider:GivePoints(ply, points, items)
end

function PS:TakePlayerPoints(ply, points)
	self.DataProvider:TakePoints(ply, points)
end

function PS:SavePlayerItem(ply, item_id, data)
	self.DataProvider:SaveItem(ply, item_id, data)
end

function PS:GivePlayerItem(ply, item_id, data)
	self.DataProvider:GiveItem(ply, item_id, data)
end

function PS:TakePlayerItem(ply, item_id)
	self.DataProvider:TakeItem(ply, item_id)
end
