ITEM.Name = 'Дорогие очки (зеленые)'
ITEM.Price = 75
ITEM.Model = 'models/modified/glasses01.mdl'
ITEM.Skin = 2
ITEM.NoLocalPlayer = true
ITEM.Attachment = 'eyes'
ITEM.Slots = {"l_eye", "r_eye"}
ITEM.OffsetType = "face"

function ITEM:OnEquip(ply, modifications)
	ply:PS_AddClientsideModel(self.ID)
end

function ITEM:OnHolster(ply)
	ply:PS_RemoveClientsideModel(self.ID)
end

function ITEM:ModifyClientsideModel(ply, model, pos, ang)
	pos = pos + (ang:Forward() * -3.5) + (ang:Up() * -0.1) + (ang:Right() * 0)
	ang:RotateAroundAxis(ang:Right(), -2)

	return model, pos, ang
end
