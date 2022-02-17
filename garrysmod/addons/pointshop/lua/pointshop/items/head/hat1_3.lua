ITEM.Name = 'Косуха (раста)'
ITEM.Price = 75
ITEM.Model = 'models/modified/hat04.mdl'
ITEM.Skin = 3
ITEM.NoLocalPlayer = true
ITEM.Attachment = 'eyes'
ITEM.Slots = {"hat"}
ITEM.OffsetType = "hat"

function ITEM:OnEquip(ply, modifications)
	ply:PS_AddClientsideModel(self.ID)
end

function ITEM:OnHolster(ply)
	ply:PS_RemoveClientsideModel(self.ID)
end

function ITEM:ModifyClientsideModel(ply, model, pos, ang)
	pos = pos + (ang:Forward() * -5.4) + (ang:Up() * 0.9) + (ang:Right() * 0.4)
	ang:RotateAroundAxis(ang:Right(), 22)
	ang:RotateAroundAxis(ang:Up(), 12)

	return model, pos, ang
end
