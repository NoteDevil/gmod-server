SRP_Groups = SRP_Groups or {}
SRP_Groups.groups = SRP_Groups.groups or {} 

ONE_MONTH = 30 * 24 * 60 * 60 -- one month in seconds
/*---------------------------------------------------------------------------
SRP Groups main functions
---------------------------------------------------------------------------*/
util.AddNetworkString("SRP_Groups.Sync")
util.AddNetworkString("SRP_Groups.CreateGroup")
util.AddNetworkString("SRP_Groups.InviteToGroup")
util.AddNetworkString("SRP_Groups.RemoveFromGroup")
util.AddNetworkString("SRP_Groups.DMoney")
util.AddNetworkString("SRP_Groups.WMoney")
util.AddNetworkString("SRP_Groups.AddRank")
util.AddNetworkString("SRP_Groups.RemoveRank")
util.AddNetworkString("SRP_Groups.LeaveGroup")
util.AddNetworkString("SRP_Groups.SetRank")
util.AddNetworkString("SRP_Groups.RankUpdate")
util.AddNetworkString("SRP_Groups.KickMember")
util.AddNetworkString("SRP_Groups.SetMOTD")
util.AddNetworkString("SRP_Groups.ExtendGroup")
util.AddNetworkString("SRP_Groups.UpdateSettings")
util.AddNetworkString("SRP_Groups.InviteToGroup")

function SRP_Groups:SetUserGroup(ply, group)
	return ply:SetNWString("SRPGroup", group)
end

function SRP_Groups:RegisterGroup(name, leader, expire_time, settings, bank, ranks)
	self.groups[name] = {
		leader = leader,
		members = self:GetAllMembers(name),
		expire_time = expire_time,
		settings = settings,
		bank = bank,
		ranks = ranks
	}
end

function SRP_Groups:GetAllMembers(name)
	local members = {}
	MySQLite.query("SELECT * FROM srp_groups_members WHERE group_name = '"..name.."'", function(result)
		if result then
			for k,v in pairs(result) do
				members[v.steamid] = v.rank
			end
		end
	end)
	return members	
end

function SRP_Groups:Sync(ply)
	net.Start("SRP_Groups.Sync")
	net.WriteTable(self.groups)
	if ply then net.Send(ply) else net.Broadcast() end
end

function SRP_Groups:CreateGroup(name, ply)
	if self:GroupExists(name) then DarkRP.notify(ply, 1, 4, "Группа с таким названием уже существует.") return end
	if self:SetUserGroup(ply) then DarkRP.notify(ply, 1, 4, "Вы уже состоите в группе.") return end
	if string.gsub(name, " ", " ") == "" then DarkRP.notify(ply, 1, 4, "Кажется вы забыли ввести название.") return end

	local steamid = ply:SteamID()
	local time = os.time() + ONE_MONTH

	self.groups[name] = {
		leader = steamid,
		members = {},
		expire_time = time,
		bank = 0,
		settings = {
			wallhack = { cb = true, color = Color(255,255,0) },
			ff = true,
			motd = "Здесь вы можете разместить какой-угодно <color=200,50,50>текст</color>",
		},
		ranks = {
			['новичок'] = {
				motd = false,
				bank = false,
				invite = false,
				kick = false,
				wallhack = false,
				ff = false,
			}
		}
	}

	MySQLite.query("INSERT INTO srp_groups (group_name, leader, expire_time, settings, bank, ranks) VALUES ('"..name.."', '"..steamid.."', "..time..", "..MySQLite.SQLStr(util.TableToJSON(self.groups[name].settings))..", 0, "..MySQLite.SQLStr(util.TableToJSON(self.groups[name].ranks))..");")
	self:AddToGroup(name, ply, true)
	self:Sync()
	DarkRP.notify(ply, 0, 4, "Вы создали группу: <color=50,200,50>"..name.."</color>")
end

function SRP_Groups:RemoveGroup(name, ply)
	if not self:GroupExists(name) then return end
	if ply then
		if not self:IsGroupLeader(name, ply:SteamID()) 
			and not ply:IsSuperAdmin() then DarkRP.notify(ply, 1, 4, "Вы не можете удалить группу.") return end
	end

	MySQLite.query("DELETE FROM srp_groups WHERE group_name = '"..name.."'")

	for k,v in pairs(self.groups[name].members) do
		self:RemoveFromGroup(name, k, self:IsGroupLeader(name, k))
	end
	self.groups[name] = nil
	self:Sync()
	DarkRP.notify(ply, 0, 4, "Вы удалили группу: <color=50,200,50>"..name.."</color>")
end

function SRP_Groups:AddToGroup(name, ply, isleader)
	if not self:GroupExists(name) then DarkRP.notify(ply, 1, 4, "Такой группы не существует.") return end
	if self:GetUserGroup(ply) ~= "" then DarkRP.notify(ply, 1, 4, "Вы уже состоите в другой группе.")  return end

	local steamid = ply:IsBot() and "BOT" or ply:SteamID()
	local rank

	if not self:IsGroupMember(name, steamid) then 
		rank = isleader and 'лидер' or 'новичок'
		self.groups[name].members[steamid] = rank
	end

	self:SetUserGroup(ply, name)

	isleader = isleader and 1 or 0

	MySQLite.query("INSERT INTO srp_groups_members (steamid, group_name, isleader, rank) VALUES ('"..steamid.."', '"..name.."', "..isleader..", '"..rank.."')")
	self:Sync()

	DarkRP.notify(ply, 0, 4, "Вы присоединились к группе: <color=50,200,50>"..name.."</color>")
end

function SRP_Groups:SendInvite(name, ply, target)
	if not self:GroupExists(name) then DarkRP.notify(ply, 1, 4, "Такой группы не существует.") return end

	target.InviteToGroup = name
	DarkRP.notify(target, 0, 10, "Вам пригласили вступить в "..name..". Чтобы согласиться введите !accept в чат.")

	timer.Remove("InvitedToGroup"..target:EntIndex())
	timer.Create("InvitedToGroup"..target:EntIndex(), 30, 1, function()
		target.InviteToGroup = nil
		DarkRP.notify(target, 0, 10, "Приглашение в "..name.." истекло.")
	end)
end

function SRP_Groups:ExtendGroup(name)
	if not self:GroupExists(name) then DarkRP.notify(ply, 1, 4, "Такой группы не существует.") return end

	MySQLite.query("UPDATE srp_groups SET expire_time = "..(self.groups[name].expire_time + ONE_MONTH).." WHERE group_name = '"..name.."'")
	DarkRP.notify(ply, 0, 4, "Вы продлили группу: <color=50,200,50>"..name.."</color>")
end

function SRP_Groups:CheckExpiredGroups()
	for k,v in pairs(self.groups) do
		if v.expire_time <= os.time() then
			self:RemoveGroup(k)
		end
	end
end

function SRP_Groups:RemoveFromGroup(name, steamid, itsleave)
	if not self:GroupExists(name) then DarkRP.notify(ply, 1, 4, "Такой группы не существует.") return end

	if self:IsGroupMember(name, steamid) then self.groups[name].members[steamid] = nil end

	local ply = util.FindPlayer(steamid)
	if ply then	
		self:SetUserGroup(ply, "") 
		if itsleave then
			DarkRP.notify(ply, 0, 4, "Вы вышли из группы: <color=50,200,50>"..name.."</color>")
		else
			DarkRP.notify(ply, 1, 4, "Вас исключили из группы: <color=50,200,50>"..name.."</color>")
		end
	end

	MySQLite.query("DELETE FROM srp_groups_members WHERE group_name = '"..name.."' and steamid = '"..steamid.."'")
	self:Sync()
end

function SRP_Groups:SetMOTD(name, text)
	self.groups[name].settings.motd = text

	MySQLite.query("UPDATE srp_groups SET settings = "..MySQLite.SQLStr(util.TableToJSON(self.groups[name].settings)).." WHERE group_name = '"..name.."'")
	
	self:Sync()
end

function SRP_Groups:AddBankMoney(name, num)
	self.groups[name].bank = self.groups[name].bank + num

	MySQLite.query("UPDATE srp_groups SET bank = "..self.groups[name].bank.." WHERE group_name = '"..name.."'")

	self:Sync()
end

function SRP_Groups:AddRank(g_name, r_name, settings)
	self.groups[g_name].ranks[r_name] = {}
	for k,v in pairs(settings) do
		self.groups[g_name].ranks[r_name][k] = v
	end

	MySQLite.query("UPDATE srp_groups SET ranks = "..MySQLite.SQLStr(util.TableToJSON(self.groups[g_name].ranks)).." WHERE group_name = '"..g_name.."'")
	self:Sync()
end

function SRP_Groups:RankUpdate(g_name, r_name, settings)
	for k,v in pairs(settings) do
		self.groups[g_name].ranks[r_name][k] = v
	end

	MySQLite.query("UPDATE srp_groups SET ranks = "..MySQLite.SQLStr(util.TableToJSON(self.groups[g_name].ranks)).." WHERE group_name = '"..g_name.."'")
	self:Sync()
end

function SRP_Groups:RemoveRank(g_name, r_name)
	self.groups[g_name].ranks[r_name] = nil

	MySQLite.query("UPDATE srp_groups SET ranks = "..MySQLite.SQLStr(util.TableToJSON(self.groups[g_name].ranks)).." WHERE group_name = '"..g_name.."'")
	self:Sync()
end

function SRP_Groups:SetRank(g_name, r_name, steamid)
	self.groups[g_name].members[steamid] = r_name

	MySQLite.query("UPDATE srp_groups SET members = "..MySQLite.SQLStr(util.TableToJSON(self.groups[g_name].members)).." WHERE group_name = '"..g_name.."'")
	self:Sync()
end

function SRP_Groups:AddBankLog(g_name, name, deposit, sum)
	if sum <= 0 then return end

	self.groups[g_name].blogs = self.groups[g_name].blogs or {}

	local text = deposit and "внес в банк" or "снял с банка"
	local color = deposit and "<color=50,200,50>" or "<color=200,50,50>"

	if #self.groups[g_name].blogs >= 20 then table.remove(self.groups[g_name].blogs, 1) end

	table.insert(self.groups[g_name].blogs, "<color=0,200,200>"..name.."</color> "..text..": "..color..DarkRP.formatMoney(sum).."</color>")
end

function SRP_Groups:ExtendGroup(g_name)
	self.groups[g_name].expire_time = self.groups[g_name].expire_time + ONE_MONTH

	MySQLite.query("UPDATE srp_groups SET expire_time = "..self.groups[g_name].expire_time.." WHERE group_name = '"..g_name.."'")
	self:Sync()
end

function SRP_Groups:UpdateSettings(g_name, ff, wh, wh_color)
	if isbool(ff) then
		self.groups[g_name].settings.ff = ff
	end

	if isbool(wh) then
		self.groups[g_name].settings.wallhack.cb = wh
		self.groups[g_name].settings.wallhack.color = wh_color
	end

	MySQLite.query("UPDATE srp_groups SET settings = "..MySQLite.SQLStr(util.TableToJSON(self.groups[name].settings)).." WHERE group_name = '"..g_name.."'")
	self:Sync()
end

/*---------------------------------------------------------------------------
Invite accept
---------------------------------------------------------------------------*/

hook.Add("PlayerSay", "SRP_Groups.PlayerSay", function(ply, text)
	text = string.Explode(" ", string.lower(text))
	if text[1] == "!accept" then
		if not ply.InviteToGroup then return end
		SRP_Groups:AddToGroup(ply.InviteToGroup, ply)
		ply.InviteToGroup = nil
		timer.Remove("InvitedToGroup"..ply:EntIndex())
	end
end)

/*---------------------------------------------------------------------------
Database shit
---------------------------------------------------------------------------*/

hook.Add("DatabaseInitialized", "SRP_Groups.DatabaseInitialized", function()
	MySQLite.query("CREATE TABLE IF NOT EXISTS srp_groups (group_name VARCHAR(255) PRIMARY KEY, leader VARCHAR(255), expire_time INTEGER, settings TEXT, bank INTEGER, ranks TEXT);")
	MySQLite.query("CREATE TABLE IF NOT EXISTS srp_groups_members (steamid VARCHAR(255) PRIMARY KEY, group_name VARCHAR(255), isleader INT, rank VARCHAR(255));")
end)

hook.Add("PlayerInitialSpawn", "SRP_Groups.PlayerInitialSpawn.LoadTables", function()
	MySQLite.query("SELECT * FROM srp_groups;", function(result)
		if result then
			for k, v in pairs(result) do
				SRP_Groups:RegisterGroup(v.group_name, v.leader, tonumber(v.expire_time), util.JSONToTable(v.settings), tonumber(v.bank), util.JSONToTable(v.ranks))
			end
		end
	end)
	SRP_Groups:CheckExpiredGroups()
	hook.Remove("PlayerInitialSpawn", "SRP_Groups.PlayerInitialSpawn.LoadTables")
end)

hook.Add("PlayerIsLoaded", "SRP_Groups.PlayerIsLoaded", function(ply)
	MySQLite.query("SELECT * FROM srp_groups_members WHERE steamid = '"..ply:SteamID().."'", function(result)
		if result then
			SRP_Groups:SetUserGroup(ply, result[1].group_name)
		else
			SRP_Groups:SetUserGroup(ply, "")
		end
	end)
	SRP_Groups:Sync(ply)
end)

/*---------------------------------------------------------------------------
Net group shit
---------------------------------------------------------------------------*/

net.Receive("SRP_Groups.CreateGroup", function(len, ply)
	if not ply:PS_HasPoints(SRP_Groups.GroupCost) then DarkRP.notify(ply, 1, 4, "У тебя не хватает долларов.") return end
	SRP_Groups:CreateGroup(net.ReadString(), ply)
	ply:PS_TakePoints(SRP_Groups.GroupCost)
	DarkRP.notify(ply, 0, 4, "Вы успешно создали группу")
end)

net.Receive("SRP_Groups.InviteToGroup", function(len, ply)
	local target = net.ReadEntity()
	local group_name = SRP_Groups:GetUserGroup(ply)
	if not SRP_Groups:IsGroupLeader(group_name, ply:SteamID()) then DarkRP.notify(ply, 1, 4, "Вы не являетесь лидером.") return end
	SRP_Groups:AddToGroup(group_name, target)
end)

net.Receive("SRP_Groups.RemoveFromGroup", function(len, ply)
	local steamid = net.ReadString()
	local group_name = SRP_Groups:GetUserGroup(ply)
	if not SRP_Groups:IsGroupLeader(group_name, ply:SteamID()) then DarkRP.notify(ply, 1, 4, "Вы не являетесь лидером.") return end
	if steamid == ply:SteamID() then DarkRP.notify(ply, 1, 4, "Вы не можете удалить себя из группы.") return end
	SRP_Groups:RemoveFromGroup(group_name, steamid)
end)

/*---------------------------------------------------------------------------
Net bank shit
---------------------------------------------------------------------------*/

net.Receive("SRP_Groups.DMoney", function(len, ply)
	local sum = net.ReadUInt(32)
	local group_name = SRP_Groups:GetUserGroup(ply)
	if group_name == "" then return end

	if not ply:canAfford(sum) then DarkRP.notify(ply, 1, 4, "У вас нет такого кол-ва денег.") return end

	SRP_Groups:AddBankLog(group_name, ply:Name(), true, sum)
	SRP_Groups:AddBankMoney(group_name, sum)
	ply:addMoney(-sum)
	DarkRP.notify(ply, 0, 4, "Вы внесли в банк: <color=50,200,50>"..DarkRP.formatMoney(sum).."</color>")
end)

net.Receive("SRP_Groups.WMoney", function(len, ply)
	local sum = net.ReadUInt(32)
	local group_name = SRP_Groups:GetUserGroup(ply)
	if group_name == "" then return end

	if not SRP_Groups:HasPermission(group_name, ply:SteamID(), 'bank') then DarkRP.notify(ply, 1, 4, "У вас нет возможности снятия денег.") return end
	if SRP_Groups:GetBankMoney(group_name) < sum then DarkRP.notify(ply, 1, 4, "В банке нет такого кол-ва денег.") return end
	SRP_Groups:AddBankLog(group_name, ply:Name(), false, sum)
	SRP_Groups:AddBankMoney(group_name, -sum)
	ply:addMoney(sum)
	DarkRP.notify(ply, 0, 4, "Вы сняли с банка: <color=50,200,50>"..DarkRP.formatMoney(sum).."</color>")
end)

/*---------------------------------------------------------------------------
Net rank shit
---------------------------------------------------------------------------*/

net.Receive("SRP_Groups.AddRank", function(len, ply)
	local r_name = net.ReadString()
	local settings = net.ReadTable()
	local g_name = SRP_Groups:GetUserGroup(ply)
	if not SRP_Groups:IsGroupLeader(g_name, ply:SteamID()) then DarkRP.notify(ply, 1, 4, "Вы не являетесь лидером.") return end

	SRP_Groups:AddRank(g_name, r_name, settings)
	DarkRP.notify(ply, 0, 4, "Вы успешно добавили новый ранг: <color=50,200,50>"..r_name.."</color>")
end)

net.Receive("SRP_Groups.RankUpdate", function(len, ply)
	local r_name = net.ReadString()
	local settings = net.ReadTable()
	local g_name = SRP_Groups:GetUserGroup(ply)
	if not SRP_Groups:IsGroupLeader(g_name, ply:SteamID()) then DarkRP.notify(ply, 1, 4, "Вы не являетесь лидером.") return end

	SRP_Groups:RankUpdate(g_name, r_name, settings)
	DarkRP.notify(ply, 0, 4, "Вы успешно обновили права ранга: <color=50,200,50>"..r_name.."</color>")
end)

net.Receive("SRP_Groups.KickMember", function(len, ply)
	local steamid = net.ReadString()
	local g_name = SRP_Groups:GetUserGroup(ply)
	if not SRP_Groups:HasPermission(g_name, ply:SteamID(), 'kick') then DarkRP.notify(ply, 1, 4, "Вы не можете этого сделать.") return end

	SRP_Groups:RemoveFromGroup(g_name, steamid)
	DarkRP.notify(ply, 0, 4, "Вы выгнали игрока из группы")
end)

net.Receive("SRP_Groups.RemoveRank", function(len, ply)
	local r_name = net.ReadString()
	local g_name = SRP_Groups:GetUserGroup(ply)
	if not SRP_Groups:IsGroupLeader(g_name, ply:SteamID()) then DarkRP.notify(ply, 1, 4, "Вы не являетесь лидером.") return end

	SRP_Groups:RemoveRank(g_name, r_name)
	DarkRP.notify(ply, 0, 4, "Вы успешно удалили ранг: <color=200,50,50>"..r_name.."</color>")
end)

net.Receive("SRP_Groups.SetRank", function(len, ply)
	local steamid = net.ReadString()
	local r_name = net.ReadString()
	local g_name = SRP_Groups:GetUserGroup(ply)
	if not SRP_Groups:IsGroupLeader(g_name, ply:SteamID()) then DarkRP.notify(ply, 1, 4, "Вы не являетесь лидером.") return end

	SRP_Groups:SetRank(g_name, r_name, steamid)
	DarkRP.notify(ply, 0, 4, "Вы успешно поменяли ранг: <color=50,200,50>"..r_name.."</color>")
end)

/*---------------------------------------------------------------------------
Net management shit
---------------------------------------------------------------------------*/

net.Receive("SRP_Groups.SetMOTD", function(len, ply)
	local motd = net.ReadString()
	local g_name = SRP_Groups:GetUserGroup(ply)
	if not SRP_Groups:HasPermission(g_name, ply:SteamID(), 'motd') then DarkRP.notify(ply, 1, 4, "Вы не можете этого сделать.") return end

	SRP_Groups:SetMOTD(g_name, motd)

	DarkRP.notify(ply, 0, 4, "Вы успешно поменяли информацию о группе")
end)

net.Receive("SRP_Groups.LeaveGroup", function(len, ply)
	local g_name = SRP_Groups:GetUserGroup(ply)
	if SRP_Groups:IsGroupLeader(g_name, ply:SteamID()) then
		SRP_Groups:RemoveGroup(g_name, ply)
	else
		SRP_Groups:RemoveFromGroup(g_name, ply:SteamID(), true)
	end
end)

net.Receive("SRP_Groups.ExtendGroup", function(len, ply)
	local g_name = SRP_Groups:GetUserGroup(ply)

	if not SRP_Groups:IsGroupLeader(g_name, ply:SteamID()) then DarkRP.notify(ply, 1, 4, "Вы не являетесь лидером.") return end

	if ply:PS_HasPoints(SRP_Groups.ExtendCost) then
		SRP_Groups:ExtendGroup(g_name)
		ply:PS_TakePoints(SRP_Groups.ExtendCost)
		DarkRP.notify(ply, 0, 4, "Вы успешно продлили группу еще на месяц: <color=50,200,50>"..g_name.."</color>")
	else
		DarkRP.notify(ply, 1, 4, "У вас не хватает денег.")
	end
end)

net.Receive("SRP_Groups.UpdateSettings", function(len, ply)
	local ff = net.ReadBool()
	local wh = net.ReadBool()
	local wh_color = net.ReadTable()
	local g_name = SRP_Groups:GetUserGroup(ply)
	local ff_perm, wh_perm = SRP_Groups:HasPermission(g_name, ply:SteamID(), 'ff'), SRP_Groups:HasPermission(g_name, ply:SteamID(), 'wallhack')
	if not ff_perm then
		ff = nil
	end
	if not wh_perm then
		wh = nil
	end
	SRP_Groups:UpdateSettings(g_name, ff, wh, wh_color)
end)

net.Receive("SRP_Groups.InviteToGroup", function(len, ply)
	local t_name = net.ReadString()
	local g_name = SRP_Groups:GetUserGroup(ply)
	if not SRP_Groups:HasPermission(g_name, ply:SteamID(), 'invite') then DarkRP.notify(ply, 1, 4, "Вы не можете этого сделать.") return end

	local target = util.FindPlayer(t_name)
	if not target then return end

	SRP_Groups:SendInvite(g_name, ply, target)
	DarkRP.notify(ply, 0, 4, "Вы пригласили игрока: "..target:Name().." в группу.")
end)

/*---------------------------------------------------------------------------
Friendly Fire
---------------------------------------------------------------------------*/

hook.Add("PlayerShouldTakeDamage", "SRP_Groups.PlayerShouldTakeDamage", function(victim, attacker)
	local v_group = SRP_Groups:GetUserGroup(victim)
	local a_group = SRP_Groups:GetUserGroup(attacker) 
	if v_group == a_group then
		local group_tbl = SRP_Groups.groups[v_group]
		if not group_tbl then return end

		if not group_tbl.settings.ff then return end 
		return false
	end
end)