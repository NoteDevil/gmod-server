local meta = FindMetaTable "Player"

--
-- POINTSHOP NOTIFICATIONS
--

util.AddNetworkString "srp_donate.PSNotification"
function meta:GivePSNotification( time, price )

	self.pendingPSNotify = { time = time, price = price }

	net.Start( "srp_donate.PSNotification" )
		net.WriteUInt( time, 8 )
	net.Send( self )

end

net.Receive( "srp_donate.PSNotification", function( len, ply )

	if not ply.pendingPSNotify then ply:Kick("Кого ты пытаешься наебать?") return end
	local time, price = ply.pendingPSNotify.time, ply.pendingPSNotify.price

	local doIt = net.ReadBool()
	if not doIt then
		ply:PS_GivePoints( price )
		DarkRP.notify( ply, NOTIFY_GENERIC, 5, "Мы вернули тебе твои " .. price .. "$" )
	else
		local text = net.ReadString()
		DarkRP.notify( ply, NOTIFY_GENERIC, 5, "Сообщение успешно размещено" )
		DarkRP.notifyAll( NOTIFY_CLEANUP, time * 60, "<color=50,200,50>" .. ply:SteamName() .. "</color>: " .. string.gsub( text, "<.->", "" ) )
	end

	ply.pendingPSNotify = nil

end)

--
-- POINTSHOP NICK
--

hook.Add( "DarkRPDBInitialized", "srp_donate.PSNick", function()

	MySQLite.query("CREATE TABLE IF NOT EXISTS `srp_nicks` ( steamid VARCHAR(35) PRIMARY KEY, nick VARCHAR(255), expires INT(11) );")

end)

hook.Add("PlayerIsLoaded", "srp_donate.PSNick", function( ply )

	local steamid = ply:SteamID()
	MySQLite.query("SELECT * FROM `srp_nicks` WHERE `steamid` = '" .. steamid .. "';", function(res)
		if not res or not res[1] then return end

		local timeLeft = tonumber(res[1].expires) - os.time()
		if timeLeft > 0 then
			ply:SetPSNick( res[1].nick, timeLeft, true )
		else
			MySQLite.query("DELETE FROM `srp_nicks` WHERE `steamid` = '" .. steamid .. "';")
		end
	end)

end)

util.AddNetworkString "srp_donate.PSNick"
function meta:GivePSNick( time, price )

	self.pendingPSNick = { time = time, price = price }
	net.Start( "srp_donate.PSNick" )
	net.Send( self )

end

-- first two parameters are needed, last two are to make a refund
function meta:SetPSNick( text, time, noDB, caller, price )

	local function applyNick( text, time )
		self:SetNWString( "PSNick", text )
		timer.Simple( time, function()
			if IsValid( self ) then self:SetNWString( "PSNick", "" ) end
		end)
	end

	if not noDB then
		local steamid = self:SteamID()
		MySQLite.query("SELECT * FROM `srp_nicks` WHERE `steamid` = '" .. steamid .. "';", function(res)
			local newTime = os.time() + time
			if not res or not res[1] then
				-- no data, create one
				MySQLite.query(string.format([[
					INSERT INTO `srp_nicks` ( steamid, nick, expires )
					VALUES ( %s, %s, %d )
				]],
					MySQLite.SQLStr(steamid),
					MySQLite.SQLStr(text),
					newTime
				))

				applyNick( text, time )
			elseif tonumber(res[1].expires) > newTime then
				-- new time is earlier than existing, cancelling
				if IsValid( caller ) then
					DarkRP.notify( caller, NOTIFY_ERROR, 2, "Нужно выбрать срок побольше, чтобы изменить его текущую кличку" )
					DarkRP.notify( caller, NOTIFY_GENERIC, 5, "Мы вернули тебе твои " .. price .. "$" )
					caller:PS_GivePoints( price )
				end
			else
				-- data exists, update
				MySQLite.query(string.format([[
					UPDATE `srp_nicks` SET `nick` = %s, expires = %d WHERE `steamid` = %s;
				]],
					MySQLite.SQLStr(text),
					newTime,
					MySQLite.SQLStr(steamid)
				))

				applyNick( text, time )
			end
		end)
	else
		applyNick( text, time )
	end

end

net.Receive( "srp_donate.PSNick", function( len, ply )

	if not ply.pendingPSNick then ply:Kick("Кого ты пытаешься наебать?") return end
	local time, price = ply.pendingPSNick.time, ply.pendingPSNick.price
	
	local doIt = net.ReadBool()
	if not doIt then
		ply:PS_GivePoints( price )
		DarkRP.notify( ply, NOTIFY_GENERIC, 5, "Мы вернули тебе твои " .. price .. "$" )
	else
		local target = net.ReadEntity()
		local text = net.ReadString()
		if not IsValid( target ) or string.len( text ) > 60 then
			DarkRP.notify( ply, NOTIFY_ERROR, 2, "Что-то пошло не так" )
			DarkRP.notify( ply, NOTIFY_GENERIC, 5, "Мы вернули тебе твои " .. price .. "$" )
			ply:PS_GivePoints( price )
			return
		end
		
		target:SetPSNick( text, time, false, ply, price )
		
		DarkRP.notify( ply, NOTIFY_GENERIC, 5, "Кличка успешно установлена" )
		DarkRP.notify( target, NOTIFY_ERROR, 5, "Тебе сменили кличку на <color=50,200,50>"..text.."</color>!" )
	end
	
	ply.pendingPSNick = nil

end)

--
-- GAME MONEY
--

function meta:GivePSMoney()
	
	net.Start( "srp_donate.PSMoney" )
	net.Send( self )
	
end

util.AddNetworkString "srp_donate.PSMoney"
net.Receive( "srp_donate.PSMoney", function( len, ply )

	local amount = tonumber( net.ReadString() )
	if not amount or amount < 1 then
		return DarkRP.notify( ply, NOTIFY_ERROR, 5, "Нужно ввести число!" )
	end

	if not ply:PS_HasPoints(amount) then
		return DarkRP.notify( ply, NOTIFY_ERROR, 5, "У тебя не хватает $$$" )
	end

	local amountMoney = amount * 2000
	ply:addMoney( amountMoney )
	ply:PS_TakePoints(amount)
	DarkRP.notify( ply, NOTIFY_ERROR, 5, "Ты купил <color=50,200,50>".. amountMoney .."р.</color> за <color=50,200,50>".. amount .."$</color>" )

end)

--
-- PLAY TIME REWARD
--

util.AddNetworkString "srp_donate.imAFK"
net.Receive( "srp_donate.imAFK", function( len, ply )

	local state = net.ReadBool()
	if state then
		ply.isAFK = true
		DarkRP.notify( ply, NOTIFY_ERROR, 10, table.Random({
			"Ну хоть бы оставил кого-нибудь поиграть за тебя",
			"Пс-ст, парень, ты тут?",
			"Ты там живой вообще?",
			"Уснул на уроке, как же это шаблонно",
		}))
	else
		ply.isAFK = nil
		DarkRP.notify( ply, NOTIFY_ERROR, 10, table.Random({
			"Привет, долговато тебя не было",
			"Где ты там шлялся?",
			"Где ты был? Мы скучали...",
			"Проснись! Ты урок проспал!",
			"А... Я уж думал ты не вернешься",
		}))
	end

end)

--
-- PROMOCODES
--

hook.Add( "DarkRPDBInitialized", "srp_donate.promo", function()

	MySQLite.query("CREATE TABLE IF NOT EXISTS `srp_promo_players` ( steamid VARCHAR(35), code VARCHAR(255), PRIMARY KEY( steamid, code ) );")

end)

function meta:useCode( code )

	local steamid = self:SteamID()

	-- if code == "halloween666" then
	-- 	MySQLite.query("SELECT * FROM `srp_promo_players` WHERE `steamid` = '" .. steamid .. "' AND `code` = '" .. code .. "';", function(res)
	-- 		if not res or not res[1] then
	-- 			-- no data, success
	-- 			MySQLite.query(string.format([[
	-- 				INSERT INTO `srp_promo_players` (steamid, code) VALUES (%s, %s);
	-- 			]],
	-- 				MySQLite.SQLStr(steamid),
	-- 				MySQLite.SQLStr(code)
	-- 			))

	-- 			DarkRP.notify( self, NOTIFY_CLEANUP, 3, "Код успешно применен")
	-- 			self:PS_GivePoints( 15 )
	-- 			DarkRP.notify( self, NOTIFY_CLEANUP, 10, "Ты получил <color=50,200,50>15$</color> по промокоду")
	-- 		else
	-- 			-- data exists, cancel
	-- 			DarkRP.notify( self, NOTIFY_ERROR, 3, "Ты уже использовал этот код")
	-- 		end
	-- 	end)
	-- else
		DarkRP.notify( self, NOTIFY_ERROR, 3, "Кода не существует или срок действия уже истек")
	-- end

end

-- quick thingie
-- TODO: make better system
util.AddNetworkString "srp_donate.promo"
net.Receive( "srp_donate.promo", function( len, ply )

	ply.nextPromoCode = ply.nextPromoCode or 0

	local code = string.lower( net.ReadString() )
	if CurTime() < ply.nextPromoCode then
		DarkRP.notify( ply, NOTIFY_ERROR, 3, "Ты можешь использовать коды не чаще, чем раз в 5 секунд" )
		return
	end

	ply:useCode( code )
	ply.nextPromoCode = CurTime() + 3

end)

--
-- CUSTOM WORKSHOP MODELS
--

local changedOutfitToday = {}
hook.Add( "CanOutfit", "srp_donate.wsmodels", function( ply, mdl, wsid )

	if not ply:PS_HasItem('wsmodel') then
		DarkRP.notify(ply, NOTIFY_ERROR, 3, "Ты не купил эту плюшку!")
		return false
	end

	local todayOutfit = changedOutfitToday[ ply:SteamID() ]
	if todayOutfit and todayOutfit ~= mdl and not ply:IsSuperAdmin() then
		DarkRP.notify(ply, NOTIFY_ERROR, 3, "Обновлять модель можно один раз в день!")
		return false
	end

	if wsid then
		changedOutfitToday[ ply:SteamID() ] = mdl
	end

	return true

end)

hook.Add("PlayerIsLoaded", "srp_donate.wsmodels", function(ply)

	timer.Simple(30, function()
		if not IsValid(ply) then return end

		if ply:PS_HasItem('wsmodel') then
			local fname = "srp_wsmodels/" .. ply:SteamID64() .. ".dat"
			if file.Exists(fname, "DATA") then
				local expires = tonumber( file.Read(fname, "DATA") )
				if expires and expires < os.time() then
					ply:PS_TakeItem('wsmodel')
					file.Delete(fname)
					DarkRP.notify(ply, NOTIFY_ERROR, 10, "Срок действия твоей модели закончился!")
				end
			end
		end
	end)

end)

hook.Add("PlayerSay", "srp_donate.wsmodels", function(ply, text)

	text = string.Explode(" ", text)
	if text[1] == "!mymodel" then
		ply:SendLua("outfitter.GUIOpen()")
		return ""
	end

end)

--
-- CSGO KNIVES
--

local function checkKnife(ply, wepClass, ent)

	if wepClass:sub(1,5) == 'csgo_' then
		local plyClass = ply.SRP_Knife
		if plyClass then
			if wepClass ~= plyClass then
				ent:Remove()
				ply:Give(plyClass)
				return false
			end
		elseif wepClass ~= 'csgo_default_t' then
			ent:Remove()
			ply:Give('csgo_default_t')
			return false
		end
	end

end

hook.Add("PlayerCanPickupWeapon", "SRP_Knives", function(ply, wep)
	checkKnife(ply, wep:GetClass(), wep)
end)

hook.Add("PlayerPickupDarkRPWeapon", "SRP_Knives", function(ply, ent, wep)
	checkKnife(ply, wep:GetClass(), ent)
end)
