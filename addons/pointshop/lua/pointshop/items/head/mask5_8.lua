ITEM.Name = 'Деревянная маска'
ITEM.Price = 60
ITEM.Model = 'models/sal/acc/fix/mask_4.mdl'
ITEM.Skin = 8
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
	model:SetModelScale(0.92, 0)
	pos = pos + (ang:Forward() * -3.7) + (ang:Up() * -1.8) + (ang:Right() * 0)
	ang:RotateAroundAxis(ang:Right(), -3)

	return model, pos, ang
end
