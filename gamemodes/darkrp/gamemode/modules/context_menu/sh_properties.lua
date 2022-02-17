---------English Version by The Postal Dude----------
-----------------------------------------------------
/* #NoSimplerr# */

// position of the menu
C_CONFIG_POSITION = "bottom" // left, right, top or bottom

C_LANGUAGE_MONEY = "Дать деньги"
C_LANGUAGE_MONEY_DESCRIPTION = "Введите количество"


C_LANGUAGE_DEMOTE = "Уволить"
C_LANGUAGE_DEMOTE_DESCRIPTION = "Введите причину"


C_LANGUAGE_WANTED = "В розыск"
C_LANGUAGE_WANTED_DESCRIPTION = "Введите причину"

C_LANGUAGE_UNWANTED = "Отменить розыск"

C_LANGUAGE_WARRANT = "Ордер"
C_LANGUAGE_WARRANT_DESCRIPTION = "Введите причину"

C_LANGUAGE_WARRANT_PROP = "Получить ордер на владельца пропа"

C_LANGUAGE_GIVE_LICENSE = "Выдать лицензию"

C_LANGUAGE_MONEY_DROP = "Выкинуть деньги"
C_LANGUAGE_MONEY_DROP_DESCRIPTION = "Введите количество"

C_LANGUAGE_MONEY_GIVE = "Дать денег"
C_LANGUAGE_MONEY_GIVE_DESCRIPTION = "Введите количество"

C_LANGUAGE_DROP = "Выбросить оружие"

C_LANGUAGE_UNOWN_ALL = "Продать все двери"

C_LANGUAGE_LOCKDOWN = "Начать собрание"
C_LANGUAGE_UNLOCKDOWN = "Закончить собрание"


C_LANGUAGE_CUSTOM_JOB = "Сменить название профессии"
C_LANGUAGE_CUSTOM_JOB_DESCRIPTION = "Введите новое имя"

C_LANGUAGE_RPNAME = "Сменить RP имя"
C_LANGUAGE_RPNAME_DESCRIPTION = "Введите новое имя"

properties.Add("givemoney", {
	MenuLabel = C_LANGUAGE_MONEY,
	Order = 1,
	MenuIcon = "icon16/money.png",

	Filter = function( self, ent, ply )
		return IsValid( ent ) && ent:IsPlayer() && ply:GetPos():Distance(ent:GetPos()) < 200
	end,
	Action = function( self, ent )
		Derma_StringRequest(C_LANGUAGE_MONEY, C_LANGUAGE_MONEY_DESCRIPTION, nil, function(a)
			if !tonumber(a) then return end
			self:MsgStart()
				net.WriteEntity(ent)
				net.WriteFloat(tonumber(a))
			self:MsgEnd()
		end)
	end,
	Receive = function( self, length, ply )
		local ent = net.ReadEntity()
		local amount = net.ReadFloat()

		if !(self:Filter(ent, ply) && amount) then return end

		if not ply:canAfford(amount) then
			DarkRP.notify(ply, 1, 4, DarkRP.getPhrase("cant_afford", ""))

			return ""
		end

		ply:addMoney(-amount)
		ent:addMoney(amount)

		DarkRP.notify(ent, 0, 4, DarkRP.getPhrase("has_given", ply:Nick(), DarkRP.formatMoney(amount)))
		DarkRP.notify(ply, 0, 4, DarkRP.getPhrase("you_gave", ent:Nick(), DarkRP.formatMoney(amount)))
	end
})

properties.Add("demote", {
	MenuLabel = C_LANGUAGE_DEMOTE,
	Order = 2,
	MenuIcon = "icon16/user_delete.png",

	Filter = function( self, ent, ply )
		return IsValid( ent ) && ent:IsPlayer()
	end,
	Action = function( self, ent )
		Derma_StringRequest(C_LANGUAGE_DEMOTE, C_LANGUAGE_DEMOTE_DESCRIPTION, nil, function(a)
			RunConsoleCommand("darkrp", "demote", ent:UserID(), a)
		end)
	end
})

properties.Add("wanted", {
	MenuLabel = C_LANGUAGE_WANTED,
	Order = 3,
	MenuIcon = "icon16/flag_red.png",

	Filter = function( self, ent, ply )
		return IsValid( ent ) && ent:IsPlayer() && !ent:isWanted() && GAMEMODE.CivilProtection[ply:Team()]
	end,
	Action = function( self, ent )
		Derma_StringRequest(C_LANGUAGE_WANTED, C_LANGUAGE_WANTED_DESCRIPTION, nil, function(a)
			RunConsoleCommand("darkrp", "wanted", ent:UserID(), a)
		end)
	end
})

properties.Add("unwanted", {
	MenuLabel = C_LANGUAGE_UNWANTED,
	Order = 4,
	MenuIcon = "icon16/flag_green.png",

	Filter = function( self, ent, ply )
		return IsValid( ent ) && ent:IsPlayer() && ent:isWanted() && ply:isCP()
	end,
	Action = function( self, ent )
		RunConsoleCommand("darkrp", "unwanted", ent:UserID())
	end
})

properties.Add("warrant", {
	MenuLabel = C_LANGUAGE_WARRANT,
	Order = 5,
	MenuIcon = "icon16/door_in.png",

	Filter = function( self, ent, ply )
		return IsValid( ent ) && ent:IsPlayer() && ply:isCP()
	end,
	Action = function( self, ent )
		Derma_StringRequest(C_LANGUAGE_WARRANT, C_LANGUAGE_WARRANT_DESCRIPTION, nil, function(a)
			RunConsoleCommand("darkrp", "warrant", ent:UserID(), a)
		end)
	end
})

properties.Add("givelicense", {
	MenuLabel = C_LANGUAGE_GIVE_LICENSE,
	Order = 6,
	MenuIcon = "icon16/page_add.png",

	Filter = function( self, ent, ply )
		local noMayorExists = fn.Compose{fn.Null, fn.Curry(fn.Filter, 2)(ply.isMayor), player.GetAll}
		local noChiefExists = fn.Compose{fn.Null, fn.Curry(fn.Filter, 2)(ply.isChief), player.GetAll}

		local canGiveLicense = fn.FOr{
			ply.isMayor, -- Mayors can hand out licenses
			fn.FAnd{ply.isChief, noMayorExists}, -- Chiefs can if there is no mayor
			fn.FAnd{ply.isCP, noChiefExists, noMayorExists} -- CP's can if there are no chiefs nor mayors
		}

		if not canGiveLicense(ply) then
			return false
		end

		return IsValid( ent ) && ent:IsPlayer() && !ent:getDarkRPVar("HasGunlicense")
	end,
	Action = function( self, ent )
		self:MsgStart()
			net.WriteEntity(ent)
		self:MsgEnd()
	end,
	Receive = function( self, length, ply )
		local ent = net.ReadEntity()

		if !(self:Filter(ent, ply)) then return end

		DarkRP.notify(ent, 0, 4, DarkRP.getPhrase("gunlicense_granted", ply:Nick(), ent:Nick()))
		DarkRP.notify(ply, 0, 4, DarkRP.getPhrase("gunlicense_granted", ply:Nick(), ent:Nick()))
		ent:setDarkRPVar("HasGunlicense", true)
	end
})

properties.Add("warrantbyprop", {
	MenuLabel = C_LANGUAGE_WARRANT_PROP,
	Order = 5,
	MenuIcon = "icon16/door_in.png",

	Filter = function( self, ent, ply )
		return IsValid( ent ) && IsValid(ent:CPPIGetOwner()) && ent:CPPIGetOwner():IsPlayer() && ply:isCP()
	end,
	Action = function( self, ent )
		Derma_StringRequest(C_LANGUAGE_WARRANT, C_LANGUAGE_WARRANT_DESCRIPTION, nil, function(a)
			RunConsoleCommand("darkrp", "warrant", ent:CPPIGetOwner():UserID(), a)
		end)
	end
})

