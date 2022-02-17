ITEM.Name = 'Наушники (розовые)'
ITEM.Price = 75
ITEM.Model = 'models/modified/headphones.mdl'
ITEM.Skin = 1
ITEM.NoLocalPlayer = true
ITEM.Attachment = 'eyes'
ITEM.Slots = {"l_ear", "r_ear"}
ITEM.OffsetType = "hat"

function ITEM:OnEquip(ply, modifications)
	ply:PS_AddClientsideModel(self.ID)
end

function ITEM:OnHolster(ply)
	ply:PS_RemoveClientsideModel(self.ID)
end

function ITEM:ModifyClientsideModel(ply, model, pos, ang)
	pos = pos + (ang:Forward() * -3.3) + (ang:Up() * -0.5) + (ang:Right() * 0)
	-- ang:RotateAroundAxis(ang:Right(), 0)

	return model, pos, ang
end
