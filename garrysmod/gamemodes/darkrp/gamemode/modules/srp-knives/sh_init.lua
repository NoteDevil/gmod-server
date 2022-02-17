local psItems = {
	-- bayonet
	csgo_bayonet = {220, 'Штык-нож', 'models/weapons/w_csgo_bayonet.mdl', 0},
	csgo_bayonet_bluesteel = {400, 'Штык-нож | Сталь', 'models/weapons/w_csgo_bayonet.mdl', 11},
	csgo_bayonet_crimsonwebs = {600, 'Штык-нож | Паутина', 'models/weapons/w_csgo_bayonet.mdl', 3},
	csgo_bayonet_ddpat = {350, 'Штык-нож | Пиксель', 'models/weapons/w_csgo_bayonet.mdl', 5},
	csgo_bayonet_fade = {600, 'Штык-нож | Градиент', 'models/weapons/w_csgo_bayonet.mdl', 6},
	csgo_bayonet_marblefade = {750, 'Штык-нож | Мрамор', 'models/weapons/w_csgo_bayonet.mdl', 13},
	csgo_bayonet_slaughter = {750, 'Штык-нож | Убийство', 'models/weapons/w_csgo_bayonet.mdl', 8},
	csgo_bayonet_tiger = {600, 'Штык-нож | Зуб тигра', 'models/weapons/w_csgo_bayonet.mdl', 9},
	csgo_bayonet_ultraviolet = {650, 'Штык-нож | УФ', 'models/weapons/w_csgo_bayonet.mdl', 10},

	-- bowie
	csgo_bowie = {150, 'Боуи', 'models/weapons/w_csgo_bowie.mdl', 0},
	csgo_bowie_bluesteel = {250, 'Боуи | Сталь', 'models/weapons/w_csgo_bowie.mdl', 11},
	csgo_bowie_crimsonwebs = {400, 'Боуи | Паутина', 'models/weapons/w_csgo_bowie.mdl', 9},
	csgo_bowie_ddpat = {200, 'Боуи | Пиксель', 'models/weapons/w_csgo_bowie.mdl', 4},
	csgo_bowie_fade = {400, 'Боуи | Градиент', 'models/weapons/w_csgo_bowie.mdl', 10},
	csgo_bowie_marblefade = {500, 'Боуи | Мрамор', 'models/weapons/w_csgo_bowie.mdl', 13},
	csgo_bowie_slaughter = {450, 'Боуи | Убийство', 'models/weapons/w_csgo_bowie.mdl', 6},
	csgo_bowie_tiger = {400, 'Боуи | Зуб тигра', 'models/weapons/w_csgo_bowie.mdl', 7},
	csgo_bowie_ultraviolet = {400, 'Боуи | УФ', 'models/weapons/w_csgo_bowie.mdl', 8},

	-- butterfly
	csgo_butterfly = {400, 'Нож-бабочка', 'models/weapons/w_csgo_butterfly.mdl', 0},
	csgo_butterfly_bluesteel = {550, 'Нож-бабочка | Сталь', 'models/weapons/w_csgo_butterfly.mdl', 11},
	csgo_butterfly_crimsonwebs = {800, 'Нож-бабочка | Паутина', 'models/weapons/w_csgo_butterfly.mdl', 3},
	csgo_butterfly_ddpat = {500, 'Нож-бабочка | Пиксель', 'models/weapons/w_csgo_butterfly.mdl', 5},
	csgo_butterfly_fade = {1000, 'Нож-бабочка | Градиент', 'models/weapons/w_csgo_butterfly.mdl', 6},
	csgo_butterfly_marblefade = {1337, 'Нож-бабочка | Мрамор', 'models/weapons/w_csgo_butterfly.mdl', 13},
	csgo_butterfly_slaughter = {1337, 'Нож-бабочка | Убийство', 'models/weapons/w_csgo_butterfly.mdl', 8},
	csgo_butterfly_tiger = {1000, 'Нож-бабочка | Зуб тигра', 'models/weapons/w_csgo_butterfly.mdl', 9},
	csgo_butterfly_ultraviolet = {950, 'Нож-бабочка | УФ', 'models/weapons/w_csgo_butterfly.mdl', 10},

	-- falchion
	csgo_falchion = {100, 'Фальшион', 'models/weapons/w_csgo_falchion.mdl', 0},
	csgo_falchion_bluesteel = {180, 'Фальшион | Сталь', 'models/weapons/w_csgo_falchion.mdl', 11},
	csgo_falchion_crimsonwebs = {250, 'Фальшион | Паутина', 'models/weapons/w_csgo_falchion.mdl', 3},
	csgo_falchion_ddpat = {150, 'Фальшион | Пиксель', 'models/weapons/w_csgo_falchion.mdl', 5},
	csgo_falchion_fade = {250, 'Фальшион | Градиент', 'models/weapons/w_csgo_falchion.mdl', 6},
	csgo_falchion_marblefade = {350, 'Фальшион | Мрамор', 'models/weapons/w_csgo_falchion.mdl', 13},
	csgo_falchion_slaughter = {300, 'Фальшион | Убийство', 'models/weapons/w_csgo_falchion.mdl', 8},
	csgo_falchion_tiger = {250, 'Фальшион | Зуб тигра', 'models/weapons/w_csgo_falchion.mdl', 9},
	csgo_falchion_ultraviolet = {250, 'Фальшион | УФ', 'models/weapons/w_csgo_falchion.mdl', 10},

	-- flip
	csgo_flip = {120, 'Складной', 'models/weapons/w_csgo_flip.mdl', 0},
	csgo_flip_bluesteel = {200, 'Складной | Сталь', 'models/weapons/w_csgo_flip.mdl', 11},
	csgo_flip_crimsonwebs = {300, 'Складной | Паутина', 'models/weapons/w_csgo_flip.mdl', 3},
	csgo_flip_ddpat = {180, 'Складной | Пиксель', 'models/weapons/w_csgo_flip.mdl', 5},
	csgo_flip_fade = {300, 'Складной | Градиент', 'models/weapons/w_csgo_flip.mdl', 6},
	csgo_flip_marblefade = {400, 'Складной | Мрамор', 'models/weapons/w_csgo_flip.mdl', 13},
	csgo_flip_slaughter = {350, 'Складной | Убийство', 'models/weapons/w_csgo_flip.mdl', 8},
	csgo_flip_tiger = {300, 'Складной | Зуб тигра', 'models/weapons/w_csgo_flip.mdl', 9},
	csgo_flip_ultraviolet = {300, 'Складной | УФ', 'models/weapons/w_csgo_flip.mdl', 10},

	-- gut
	csgo_gut = {60, 'Крюк', 'models/weapons/w_csgo_gut.mdl', 0},
	csgo_gut_bluesteel = {150, 'Крюк | Сталь', 'models/weapons/w_csgo_gut.mdl', 11},
	csgo_gut_crimsonwebs = {200, 'Крюк | Паутина', 'models/weapons/w_csgo_gut.mdl', 3},
	csgo_gut_ddpat = {100, 'Крюк | Пиксель', 'models/weapons/w_csgo_gut.mdl', 5},
	csgo_gut_fade = {200, 'Крюк | Градиент', 'models/weapons/w_csgo_gut.mdl', 6},
	csgo_gut_marblefade = {300, 'Крюк | Мрамор', 'models/weapons/w_csgo_gut.mdl', 13},
	csgo_gut_slaughter = {250, 'Крюк | Убийство', 'models/weapons/w_csgo_gut.mdl', 8},
	csgo_gut_tiger = {250, 'Крюк | Зуб тигра', 'models/weapons/w_csgo_gut.mdl', 9},
	csgo_gut_ultraviolet = {200, 'Крюк | УФ', 'models/weapons/w_csgo_gut.mdl', 10},

	-- huntsman
	csgo_huntsman = {200, 'Охотничий', 'models/weapons/w_csgo_tactical.mdl', 0},
	csgo_huntsman_bluesteel = {350, 'Охотничий | Сталь', 'models/weapons/w_csgo_tactical.mdl', 11},
	csgo_huntsman_crimsonwebs = {500, 'Охотничий | Паутина', 'models/weapons/w_csgo_tactical.mdl', 3},
	csgo_huntsman_ddpat = {300, 'Охотничий | Пиксель', 'models/weapons/w_csgo_tactical.mdl', 5},
	csgo_huntsman_fade = {500, 'Охотничий | Градиент', 'models/weapons/w_csgo_tactical.mdl', 6},
	csgo_huntsman_marblefade = {650, 'Охотничий | Мрамор', 'models/weapons/w_csgo_tactical.mdl', 13},
	csgo_huntsman_slaughter = {650, 'Охотничий | Убийство', 'models/weapons/w_csgo_tactical.mdl', 8},
	csgo_huntsman_tiger = {500, 'Охотничий | Зуб тигра', 'models/weapons/w_csgo_tactical.mdl', 9},
	csgo_huntsman_ultraviolet = {500, 'Охотничий | УФ', 'models/weapons/w_csgo_tactical.mdl', 10},

	-- karambit
	csgo_karambit = {350, 'Керамбит', 'models/weapons/w_csgo_karambit.mdl', 0},
	csgo_karambit_bluesteel = {500, 'Керамбит | Сталь', 'models/weapons/w_csgo_karambit.mdl', 11},
	csgo_karambit_crimsonwebs = {750, 'Керамбит | Паутина', 'models/weapons/w_csgo_karambit.mdl', 3},
	csgo_karambit_ddpat = {450, 'Керамбит | Пиксель', 'models/weapons/w_csgo_karambit.mdl', 5},
	csgo_karambit_fade = {800, 'Керамбит | Градиент', 'models/weapons/w_csgo_karambit.mdl', 6},
	csgo_karambit_marblefade = {950, 'Керамбит | Мрамор', 'models/weapons/w_csgo_karambit.mdl', 13},
	csgo_karambit_slaughter = {950, 'Керамбит | Убийство', 'models/weapons/w_csgo_karambit.mdl', 8},
	csgo_karambit_tiger = {800, 'Керамбит | Зуб тигра', 'models/weapons/w_csgo_karambit.mdl', 9},
	csgo_karambit_ultraviolet = {850, 'Керамбит | УФ', 'models/weapons/w_csgo_karambit.mdl', 10},

	-- m9
	csgo_m9 = {250, 'Штык-нож М9', 'models/weapons/w_csgo_m9.mdl', 0},
	csgo_m9_bluesteel = {450, 'Штык-нож М9 | Сталь', 'models/weapons/w_csgo_m9.mdl', 11},
	csgo_m9_crimsonwebs = {650, 'Штык-нож М9 | Паутина', 'models/weapons/w_csgo_m9.mdl', 3},
	csgo_m9_ddpat = {400, 'Штык-нож М9 | Пиксель', 'models/weapons/w_csgo_m9.mdl', 5},
	csgo_m9_fade = {650, 'Штык-нож М9 | Градиент', 'models/weapons/w_csgo_m9.mdl', 6},
	csgo_m9_marblefade = {750, 'Штык-нож М9 | Мрамор', 'models/weapons/w_csgo_m9.mdl', 13},
	csgo_m9_slaughter = {750, 'Штык-нож М9 | Убийство', 'models/weapons/w_csgo_m9.mdl', 8},
	csgo_m9_tiger = {650, 'Штык-нож М9 | Зуб тигра', 'models/weapons/w_csgo_m9.mdl', 9},
	csgo_m9_ultraviolet = {650, 'Штык-нож М9 | УФ', 'models/weapons/w_csgo_m9.mdl', 10},

	-- daggers
	csgo_daggers = {100, 'Тычковые', 'models/weapons/w_csgo_push.mdl', 0},
	csgo_daggers_bluesteel = {180, 'Тычковые | Сталь', 'models/weapons/w_csgo_push.mdl', 12},
	csgo_daggers_ddpat = {250, 'Тычковые | Пиксель', 'models/weapons/w_csgo_push.mdl', 4},
	csgo_daggers_fade = {400, 'Тычковые | Градиент', 'models/weapons/w_csgo_push.mdl', 5},
	csgo_daggers_greyscaled = {200, 'Тычковые | Тень', 'models/weapons/w_csgo_push.mdl', 6},
	csgo_daggers_marblefade = {500, 'Тычковые | Мрамор', 'models/weapons/w_csgo_push.mdl', 14},
	csgo_daggers_slaughter = {450, 'Тычковые | Убийство', 'models/weapons/w_csgo_push.mdl', 8},
	csgo_daggers_tiger = {450, 'Тычковые | Зуб тигра', 'models/weapons/w_csgo_push.mdl', 9},
	csgo_daggers_ultraviolet = {350, 'Тычковые | УФ', 'models/weapons/w_csgo_push.mdl', 10},
	csgo_daggers_webs = {400, 'Тычковые | Паутина', 'models/weapons/w_csgo_push.mdl', 11},

	-- golden
	csgo_default_golden = {3500, 'Спонсор КТ | Золото', 'models/weapons/w_csgo_default.mdl', 1},
	csgo_default_t_golden = {3000, 'Спонсор Т | Золото', 'models/weapons/w_csgo_default_t.mdl', 1},
}

for class, data in pairs( psItems ) do
	ITEM = {}

	ITEM.__index = ITEM
	ITEM.ID = "knife_" .. class
	ITEM.Category = "Ножи"
	ITEM.Price = data[1]

	ITEM.AdminOnly = false
	ITEM.AllowedUserGroups = {}
	ITEM.SingleUse = false
	ITEM.NoPreview = true

	ITEM.CanPlayerBuy = true
	ITEM.CanPlayerSell = true
	ITEM.CanPlayerEquip = true
	ITEM.CanPlayerHolster = true

	ITEM.OnBuy = function() end
	ITEM.OnSell = function() end
	ITEM.OnEquip = function( self, ply ) ply.SRP_Knife = class end
	ITEM.OnHolster = function( self, ply ) ply.SRP_Knife = nil end
	ITEM.OnModify = function() end
	ITEM.ModifyClientsideModel = function(ITEM, ply, model, pos, ang)
		return model, pos, ang
	end
	ITEM.Name = data[2]
	ITEM.Model = data[3]
	ITEM.Skin = data[4]

	local _item = ITEM
	for prop, val in pairs(_item) do
		if type(val) == "function" then
			hook.Add(prop, 'PS_Item_' .. _item.Name .. '_' .. prop, function(...)
				for _, ply in pairs(player.GetAll()) do
					if ply:PS_HasItemEquipped(_item.ID) then
						_item[prop](_item, ply, ply.PS_Items[_item.ID].Modifiers, unpack({...}))
					end
				end
			end)
		end
	end

	PS.Items[ITEM.ID] = ITEM

	ITEM = nil
end
-- from 666 with love
