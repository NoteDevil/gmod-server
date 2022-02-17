local command = {}

command.help		= "Set a player's name."
command.command 	= "name"
command.arguments	= {"player", "name"}
command.permissions	= {"DarkRP admin commands", "DarkRP superadmin commands"}
command.immunity 	= SERVERGUARD.IMMUNITY.LESSOREQUAL

function command:OnPlayerExecute(_, target, arguments)
	local name = arguments[2]

	RunConsoleCommand("darkrp", "forcerpname", target:Name(), name)

	return true
end

-- function command:OnNotify(pPlayer, targets, arguments)
-- 	local name = arguments[2]

-- 	return SGPF("command_armor", serverguard.player:GetName(pPlayer), util.GetNotifyListForTargets(targets, true), amount)
-- end

serverguard.command:Add(command)

local command = {}

command.help		= "Set a player's job name."
command.command 	= "jobname"
command.arguments	= {"player", "job_name"}
command.permissions	= "DarkRP admin commands"
command.immunity 	= SERVERGUARD.IMMUNITY.LESSOREQUAL

function command:OnPlayerExecute(_, target, arguments)
	local name = arguments[2]

	target:updateJob(name)

	return true
end

-- function command:OnNotify(pPlayer, targets, arguments)
-- 	local name = arguments[2]

-- 	return SGPF("command_armor", serverguard.player:GetName(pPlayer), util.GetNotifyListForTargets(targets, true), amount)
-- end

serverguard.command:Add(command)

local command = {}

command.help		= "Set a player's job"
command.command 	= "job"
command.arguments	= {"player", "job_id"}
command.permissions	= "DarkRP admin commands"
command.immunity 	= SERVERGUARD.IMMUNITY.LESSOREQUAL

function command:OnPlayerExecute(_, target, arguments)
	local id = util.ToNumber(arguments[2])

	target:changeTeam(id, true)

	return true
end

-- function command:OnNotify(pPlayer, targets, arguments)
-- 	local name = arguments[2]

-- 	return SGPF("command_armor", serverguard.player:GetName(pPlayer), util.GetNotifyListForTargets(targets, true), amount)
-- end

serverguard.command:Add(command)

local command = {}

command.help		= "Ban player from the job"
command.command 	= "teamban"
command.arguments	= {"player", "job_id", "time"}
command.permissions	= "DarkRP admin commands"
command.immunity 	= SERVERGUARD.IMMUNITY.LESSOREQUAL

function command:OnPlayerExecute(_, target, arguments)
	local id = util.ToNumber(arguments[2])
	local time = util.ToNumber(arguments[3])
	target:teamBan(id, time)

	return true
end

-- function command:OnNotify(pPlayer, targets, arguments)
-- 	local name = arguments[2]

-- 	return SGPF("command_armor", serverguard.player:GetName(pPlayer), util.GetNotifyListForTargets(targets, true), amount)
-- end

serverguard.command:Add(command)

local command = {}

command.help		= "Unban player from the job"
command.command 	= "teamunban"
command.arguments	= {"player", "job_id"}
command.permissions	= "DarkRP admin commands"
command.immunity 	= SERVERGUARD.IMMUNITY.LESSOREQUAL

function command:OnPlayerExecute(_, target, arguments)
	local id = util.ToNumber(arguments[2])
	target:teamUnBan(id)

	return true
end

-- function command:OnNotify(pPlayer, targets, arguments)
-- 	local name = arguments[2]

-- 	return SGPF("command_armor", serverguard.player:GetName(pPlayer), util.GetNotifyListForTargets(targets, true), amount)
-- end

serverguard.command:Add(command)

local command = {}

command.help		= "Arrest player"
command.command 	= "arrest"
command.arguments	= {"player", "time"}
command.permissions	= "DarkRP admin commands"
command.immunity 	= SERVERGUARD.IMMUNITY.LESSOREQUAL

function command:OnPlayerExecute(ply, target, arguments)
	local time = util.ToNumber(arguments[2])
	target:arrest(time, ply)

	return true
end

-- function command:OnNotify(pPlayer, targets, arguments)
-- 	local name = arguments[2]

-- 	return SGPF("command_armor", serverguard.player:GetName(pPlayer), util.GetNotifyListForTargets(targets, true), amount)
-- end

serverguard.command:Add(command)

local command = {}

command.help		= "Unarrest player"
command.command 	= "unarrest"
command.arguments	= {"player"}
command.permissions	= "DarkRP admin commands"
command.immunity 	= SERVERGUARD.IMMUNITY.LESSOREQUAL

function command:OnPlayerExecute(ply, target, arguments)
	target:unArrest()

	return true
end

-- function command:OnNotify(pPlayer, targets, arguments)
-- 	local name = arguments[2]

-- 	return SGPF("command_armor", serverguard.player:GetName(pPlayer), util.GetNotifyListForTargets(targets, true), amount)
-- end

serverguard.command:Add(command)

local command = {}

command.help		= "Add money to player"
command.command 	= "addmoney"
command.arguments	= {"player", "amount"}
command.permissions	= "DarkRP superadmin commands"
command.immunity 	= SERVERGUARD.IMMUNITY.LESSOREQUAL

function command:OnPlayerExecute(ply, target, arguments)
	local amount = util.ToNumber(arguments[2])
	target:addMoney(math.max(target:getDarkRPVar("money")*-1, amount))

	return true
end

-- function command:OnNotify(pPlayer, targets, arguments)
-- 	local name = arguments[2]

-- 	return SGPF("command_armor", serverguard.player:GetName(pPlayer), util.GetNotifyListForTargets(targets, true), amount)
-- end

serverguard.command:Add(command)

local command = {}

command.help		= "Set money"
command.command 	= "setmoney"
command.arguments	= {"player", "amount"}
command.permissions	= "DarkRP superadmin commands"
command.immunity 	= SERVERGUARD.IMMUNITY.LESSOREQUAL

function command:OnPlayerExecute(ply, target, arguments)
	local amount = util.ToNumber(arguments[2])
	target:setDarkRPVar("money", math.max(0, amount))

	return true
end

-- function command:OnNotify(pPlayer, targets, arguments)
-- 	local name = arguments[2]

-- 	return SGPF("command_armor", serverguard.player:GetName(pPlayer), util.GetNotifyListForTargets(targets, true), amount)
-- end

serverguard.command:Add(command)

local command = {}

command.help		= "Sell door you'r looking at"
command.command 	= "selldoor"
command.arguments	= {"player"}
command.permissions	= "DarkRP admin commands"
command.immunity 	= SERVERGUARD.IMMUNITY.LESSOREQUAL

function command:OnPlayerExecute(ply, target, arguments)
	local trent = target:GetEyeTrace().Entity
	if not trent:isDoor() then return end
	trent:keysUnOwn()

	return true
end

-- function command:OnNotify(pPlayer, targets, arguments)
-- 	local name = arguments[2]

-- 	return SGPF("command_armor", serverguard.player:GetName(pPlayer), util.GetNotifyListForTargets(targets, true), amount)
-- end

serverguard.command:Add(command)

local command = {}

command.help		= "Sell all doors"
command.command 	= "sellalldoor"
command.arguments	= {"player"}
command.permissions	= "DarkRP admin commands"
command.immunity 	= SERVERGUARD.IMMUNITY.LESSOREQUAL

function command:OnPlayerExecute(ply, target, arguments)
	local trent = target:GetEyeTrace().Entity
	if not trent:isDoor() then return end
	trent:keysUnOwn()

	return true
end

-- function command:OnNotify(pPlayer, targets, arguments)
-- 	local name = arguments[2]

-- 	return SGPF("command_armor", serverguard.player:GetName(pPlayer), util.GetNotifyListForTargets(targets, true), amount)
-- end

serverguard.command:Add(command)

local command = {}

command.help		= "Cancel vote"
command.command 	= "cancelvote"
command.arguments	= {"player"}
command.permissions	= "DarkRP admin commands"
command.immunity 	= SERVERGUARD.IMMUNITY.LESSOREQUAL

function command:OnPlayerExecute(ply, target, arguments)
	DarkRP.destroyLastVote()

	return true
end

-- function command:OnNotify(pPlayer, targets, arguments)
-- 	local name = arguments[2]

-- 	return SGPF("command_armor", serverguard.player:GetName(pPlayer), util.GetNotifyListForTargets(targets, true), amount)
-- end

serverguard.command:Add(command)

local command = {}

command.help		= "Toggle lockdown"
command.command 	= "lockdown"
command.arguments	= {"player"}
command.permissions	= "DarkRP admin commands"
command.immunity 	= SERVERGUARD.IMMUNITY.LESSOREQUAL

function command:OnPlayerExecute(ply, target, arguments)
	if GetGlobalBool("DarkRP_LockDown") then
		DarkRP.unLockdown(NULL)
	else
		DarkRP.lockdown(NULL)
	end

	return true
end

-- function command:OnNotify(pPlayer, targets, arguments)
-- 	local name = arguments[2]

-- 	return SGPF("command_armor", serverguard.player:GetName(pPlayer), util.GetNotifyListForTargets(targets, true), amount)
-- end

function command:ContextMenu(pPlayer, menu, rankData)
	local DRPMenu, icon = menu:AddSubMenu("DarkRP")
	icon:SetImage("icon16/plugin.png")

	local option = DRPMenu:AddOption("Toggle lockdown", function()
		serverguard.command.Run("lockdown", false, pPlayer:Name())
	end)

	option:SetImage("icon16/exclamation.png")

	local option = DRPMenu:AddOption("Cancel last vote", function()
		serverguard.command.Run("cancelvote", false, pPlayer:Name())
	end)

	option:SetImage("icon16/bomb.png")

	local option = DRPMenu:AddOption("Sell all doors", function()
		serverguard.command.Run("sellalldoors", false, pPlayer:Name())
	end)

	option:SetImage("icon16/house_go.png")

	local option = DRPMenu:AddOption("Set money", function()
		Derma_StringRequest("Set money of player", "Amount of money", "", function(text)
			serverguard.command.Run("setmoney", false, pPlayer:Name(), text)
		end, function(text) end, "Accept", "Cancel") end)

	option:SetImage("icon16/money_add.png")

	local option = DRPMenu:AddOption("Add money to player", function()
		Derma_StringRequest("Add money to player", "Amount of money", "", function(text)
			serverguard.command.Run("addmoney", false, pPlayer:Name(), text)
		end, function(text) end, "Accept", "Cancel") end)

	option:SetImage("icon16/money_add.png")

	local option = DRPMenu:AddOption("Unarrest player", function()
		serverguard.command.Run("unarrest", false, pPlayer:Name())
	end)

	option:SetImage("icon16/lock_open.png")

	local option = DRPMenu:AddOption("Arrest player", function()
		Derma_StringRequest("Arrest player", "time in seconds", "", function(text)
			serverguard.command.Run("arrest", false, pPlayer:Name(), text)
		end, function(text) end, "Accept", "Cancel") end)

	option:SetImage("icon16/lock.png")

	local SubMenu, icon = DRPMenu:AddSubMenu( "Ban from job")
	icon:SetImage("icon16/door_in.png")
	for k,v in pairs(RPExtraTeams) do
		local option = SubMenu:AddOption(v.name, function()
			Derma_StringRequest("Ban player from the job", "Set time for ban in seconds.", "", function(text)
				serverguard.command.Run("teamban", false, pPlayer:Name(), k, text)
			end, function(text) end, "Accept", "Cancel") end)
	end

	local SubMenu, icon = DRPMenu:AddSubMenu( "Unban from job")
	icon:SetImage("icon16/door_out.png")
	for k,v in pairs(RPExtraTeams) do
		local option = SubMenu:AddOption(v.name, function()
			serverguard.command.Run("teamunban", false, pPlayer:Name(), k)
		end)
	end

	local SubMenu, icon = DRPMenu:AddSubMenu( "Change job")
	icon:SetImage("icon16/group_go.png")
	for k,v in pairs(RPExtraTeams) do
		local option = SubMenu:AddOption(v.name, function()
			serverguard.command.Run("job", false, pPlayer:Name(), k)
		end)
	end

	local option = DRPMenu:AddOption("Change job name", function()
		Derma_StringRequest("Change job name", "Specify job name.", "", function(text)
			serverguard.command.Run("jobname", false, pPlayer:Name(), text)
		end, function(text) end, "Accept", "Cancel") end)

	option:SetImage("icon16/information.png")

	local option = DRPMenu:AddOption("Change name", function()
		Derma_StringRequest("Change name", "Specify name.", "", function(text)
			serverguard.command.Run("name", false, pPlayer:Name(), text)
		end, function(text) end, "Accept", "Cancel") end)

	option:SetImage("icon16/information.png")
end

serverguard.command:Add(command)
