ITEM.Name = 'Пакет Дьявол'
ITEM.Price = 65
ITEM.Model = 'models/sal/halloween/bag.mdl'
ITEM.Skin = 9
ITEM.NoLocalPlayer = true
ITEM.Attachment = 'eyes'
ITEM.Slots = {"l_eye", "r_eye", "mouth", "nose", "l_ear", "r_ear", "hat"}
ITEM.OffsetType = "hat"

function ITEM:OnEquip(ply, modifications)
	ply:PS_AddClientsideModel(self.ID)
end

function ITEM:OnHolster(ply)
	ply:PS_RemoveClientsideModel(self.ID)
end

function ITEM:ModifyClientsideModel(ply, model, pos, ang)
	pos = pos + (ang:Forward() * -4) + (ang:Up() * -1.7) + (ang:Right() * 0)
	-- ang:RotateAroundAxis(ang:Right(), 0)

	return model, pos, ang
end
