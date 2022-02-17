ITEM.Name = 'Колпак повара'
ITEM.Price = 15
ITEM.Model = 'models/sal/acc/fix/cheafhat.mdl'
ITEM.Skin = 0
ITEM.Attachment = 'eyes'

function ITEM:OnEquip(ply, modifications)
	ply:PS_AddClientsideModel(self.ID)
end

function ITEM:OnHolster(ply)
	ply:PS_RemoveClientsideModel(self.ID)
end

function ITEM:ModifyClientsideModel(ply, model, pos, ang)
	pos = pos + (ang:Forward() * -4.9) + (ang:Up() * 4.4) + (ang:Right() * 0.16)
	ang:RotateAroundAxis(ang:Right(), 6.6)
	model:SetModelScale(0.9, 0)

	return model, pos, ang
end
