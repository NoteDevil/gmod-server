local item = {}
item.id = "ent_notepad"
item.color = color_white
item.name = "Тетрадка"
item.desc = "В ней можно писать :D"
item.model = "models/school/notepad.mdl"
item.weight = 0.1
item.onDrop = function(ent, ply, data)
	ent.notepadText = data.text
	ent:SetNWString('notepadName', data.name)
end
item.onSave = function(ent)
	local to_save = {
		text = ent.notepadText,
		name = ent:GetNWString('notepadName')
	}
	return to_save
end
SRP_Inv:RegisterItem(item)

local item = {}
item.id = "ent_book"
item.color = color_white
item.name = "Книга"
item.desc = ""
item.model = ""
item.weight = 0.4
item.onDrop = function(ent, ply, data)
	ent:SetTitle(data.title)
	ent:SetLink(data.link)
	ent:SetModel(data.model)
end
item.onSave = function(ent)
	local to_save = {
		title = ent:GetTitle(),
		link = ent:GetLink(),
		model = ent:GetModel(),
	}
	return to_save
end
item.createDesc = function(item)
	local desc = item.data.title
	if string.len(item.data.title) >= 32 then
		desc = string.Left(item.data.title, 32).."..."
	end
	return desc
end
SRP_Inv:RegisterItem(item)

local item = {}
item.id = "3d_boombox"
item.color = color_white
item.name = "Бумбокс"
item.desc = "Можно врубать музыку, каеф"
item.model = "models/boomboxv2/boomboxv2.mdl"
item.weight = 1
SRP_Inv:RegisterItem(item)

/*---------------------------------------------------------------------------
Крафт
---------------------------------------------------------------------------*/

local item = {}
item.id = "ent_detailbox"
item.color = color_white
item.name = "Кейс с деталями"
item.desc = "Используется для крафта"
item.model = "models/props_c17/SuitCase001a.mdl"
item.weight = 1
item.onDrop = function(ent, ply, data)
	ent:SetNWInt("Iron", data.iron)
	ent:SetNWInt("Wood", data.wood)
	ent:SetNWInt("Glass", data.glass)
	ent:SetNWInt("Gate", data.gate)
end
item.onSave = function(ent)
	local to_save = {
		iron = ent:GetNWInt("Iron"),
		wood = ent:GetNWInt("Wood"),
		glass = ent:GetNWInt("Glass"),
		gate = ent:GetNWInt("Gate"),
	}
	return to_save
end
SRP_Inv:RegisterItem(item)

local item = {}
item.id = "ent_cr_gate"
item.color = color_white
item.name = "Микросхема"
item.desc = "Используется для крафта"
item.model = ""
item.weight = 0.5
item.onDrop = function(ent, ply, data)
	ent:SetModel(data.model)
end
item.onSave = function(ent)
	local to_save = {
		model = ent:GetModel(),
	}
	return to_save
end
SRP_Inv:RegisterItem(item)

local item = {}
item.id = "ent_cr_iron"
item.color = color_white
item.name = "Железо"
item.desc = "Используется для крафта"
item.model = ""
item.weight = 0.5
item.onDrop = function(ent, ply, data)
	ent:SetModel(data.model)
end
item.onSave = function(ent)
	local to_save = {
		model = ent:GetModel(),
	}
	return to_save
end
SRP_Inv:RegisterItem(item)

local item = {}
item.id = "ent_cr_wood"
item.color = color_white
item.name = "Дерево"
item.desc = "Используется для крафта"
item.model = ""
item.weight = 0.5
item.onDrop = function(ent, ply, data)
	ent:SetModel(data.model)
end
item.onSave = function(ent)
	local to_save = {
		model = ent:GetModel(),
	}
	return to_save
end
SRP_Inv:RegisterItem(item)

local item = {}
item.id = "ent_cr_gate"
item.color = color_white
item.name = "Стекло"
item.desc = "Используется для крафта"
item.model = ""
item.weight = 0.5
item.onDrop = function(ent, ply, data)
	ent:SetModel(data.model)
end
item.onSave = function(ent)
	local to_save = {
		model = ent:GetModel(),
	}
	return to_save
end
SRP_Inv:RegisterItem(item)

local item = {}
item.id = "srp_skateboard"
item.color = color_white
item.name = "Скейтборд"
item.desc = "На нем можно катать :D"
item.model = ""
item.weight = 0.5
item.onDrop = function(ent, ply, data)
	ent:SetModel(data.model)
	ent:SetDampingFactor(data.DampingFactor)
	ent:SetSpeed(data.Speed)
	ent:SetYawSpeed(data.YawSpeed)
	ent:SetTurnSpeed(data.TurnSpeed)
	ent:SetPitchSpeed(data.PitchSpeed)
	ent:SetRollSpeed(data.RollSpeed)
	ent:SetJumpPower(data.JumpPower)
	ent:SetBoostMultiplier(data.BoostMultiplier)

	ent:SetControls(1)
  ent:SetBoostShake(0)
  ent:SetHoverHeight(1)
  ent:SetViewDistance(128)
  ent:SetSpring(0.07 * 0.8 * 1.6)

	local boardinfo = {}
	for _,v in pairs(SkateboardTypes) do
		if string.lower(v.model) == string.lower(data.model) then
			boardinfo = v
		end
	end

	ent:SetBoardRotation( tonumber( boardinfo.rotation ) )
	ent:SetAvatarPosition( boardinfo.driver )

	for k, v in pairs( boardinfo ) do
    if ( k:sub( 1, 7 ):lower() == "effect_" && istable(boardinfo[ k ]) ) then
        local effect = boardinfo[ k ]

        local normal
        if ( effect[ 'normal' ] ) then normal = effect[ 'normal' ] end

        ent:AddEffect( effect[ 'effect' ] or "trail", effect[ 'position' ], normal, effect[ 'scale' ] or 1 )
    end
	end

	DoPropSpawnedEffect(ent)
end
item.onSave = function(ent)
	local to_save = {
		model = ent:GetModel(),
		DampingFactor = ent:GetDampingFactor(),
		Speed = ent:GetSpeed(),
		YawSpeed = ent:GetYawSpeed(),
		TurnSpeed = ent:GetTurnSpeed(),
		PitchSpeed = ent:GetPitchSpeed(),
		RollSpeed = ent:GetRollSpeed(),
		JumpPower = ent:GetJumpPower(),
		BoostMultiplier = ent:GetBoostMultiplier(),
	}
	return to_save
end
item.canPickup = function(ent, ply)
	return ent:Getowning_ent() == ply, "Это не твой скейтборд!"
end
item.createDesc = function(item)
	for _,v in pairs(SkateboardTypes) do
		if string.lower(v.model) == string.lower(item.data.model) then
			return v.name
		end
	end
end
SRP_Inv:RegisterItem(item)