ITEM.Name = 'Тыква-песик'
ITEM.Price = 0
ITEM.Model = 'models/roblox/pup-_o-lantern.mdl'
ITEM.Skin = 0
ITEM.NoLocalPlayer = true
ITEM.Attachment = 'eyes'
ITEM.Slots = {"l_ear", "r_ear", "hat", "mouth", "nose", "l_eye", "r_eye"}
ITEM.OffsetType = "hat"
ITEM.Hidden = true

function ITEM:CanPlayerBuy(ply)
	return false, "Этот предмет из ограниченной серии"
end

function ITEM:CanPlayerSell(ply)
	return false, "Этот предмет из ограниченной серии"
end

function ITEM:OnEquip(ply, modifications)
	ply:PS_AddClientsideModel(self.ID)
end

function ITEM:OnHolster(ply)
	ply:PS_RemoveClientsideModel(self.ID)
end

function ITEM:ModifyClientsideModel(ply, model, pos, ang)
	ang:RotateAroundAxis(ang:Right(), -5)
	ang:RotateAroundAxis(ang:Up(), 180)
	pos = pos + (ang:Forward() * 2.44) + (ang:Up() * 0.54) + (ang:Right() * 0)

	return model, pos, ang, 0.72
end
