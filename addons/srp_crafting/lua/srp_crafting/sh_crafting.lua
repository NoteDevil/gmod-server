SRP_Crafting = SRP_Crafting or {}
SRP_Crafting.Recipes = {}

SRP_Crafting.Details = {
	["Iron"] = "Железо",
	["Wood"] = "Дерево",
	["Glass"] = "Стекло",
	["Gate"] = "Микросхема"
}

SRP_Crafting.Recipes["weapon_hl2axe"] = {
	name = "Топор",
	model = "models/weapons/HL2meleepack/v_axe.mdl",
	type = "weapon",
	recipe = {
		["Iron"] = 5,
		["Wood"] = 10,
	},
}

SRP_Crafting.Recipes["weapon_hl2brokenbottle"] = {
	name = "Сломанная бутылка",
	model = "models/weapons/HL2meleepack/w_brokenbottle.mdl",
	type = "weapon",
	recipe = {
		["Glass"] = 5,
	},
}

SRP_Crafting.Recipes["weapon_hl2pipe"] = {
	name = "Труба",
	model = "models/props_canal/mattpipe.mdl",
	type = "weapon",
	recipe = {
		["Iron"] = 10,
	},
}

SRP_Crafting.Recipes["weapon_bat"] = {
	name = "Бита",
	model = "models/weapons/w_bat.mdl",
	type = "weapon",
	recipe = {
		["Wood"] = 10,
	},
}

SRP_Crafting.Recipes["weapon_zapper"] = {
	name = "Zapper",
	model = "models/weapons/w_pistol.mdl",
	type = "weapon",
	recipe = {
		["Iron"] = 5,
		["Gate"] = 20,
		["Glass"] = 5,
		["Wood"] = 5
	},
}


