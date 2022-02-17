ITEM.Name = 'Защ. маска (медведь)'
ITEM.Price = 75
ITEM.Model = 'models/sal/acc/fix/mask_2.mdl'
ITEM.Skin = 3
ITEM.NoLocalPlayer = true
ITEM.Attachment = 'eyes'
ITEM.Slots = {"l_ear", "r_ear", "hat", "mouth", "nose"}
ITEM.OffsetType = "face"

function ITEM:OnEquip(ply, modifications)
	ply:PS_AddClientsideModel(self.ID)
end

function ITEM:OnHolster(ply)
	ply:PS_RemoveClientsideModel(self.ID)
end

function ITEM:ModifyClientsideModel(ply, model, pos, ang)
	model:SetModelScale(0.95, 0)
	pos = pos + (ang:Forward() * -3.8) + (ang:Up() * -1.5) + (ang:Right() * 0)
	ang:RotateAroundAxis(ang:Right(), -5)

	return model, pos, ang
end
