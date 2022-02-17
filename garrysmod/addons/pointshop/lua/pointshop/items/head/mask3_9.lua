ITEM.Name = 'Маска-повязка (розовая)'
ITEM.Price = 75
ITEM.Model = 'models/sal/halloween/ninja.mdl'
ITEM.Skin = 9
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
	pos = pos + (ang:Forward() * -3.8) + (ang:Up() * -2) + (ang:Right() * 0)
	-- ang:RotateAroundAxis(ang:Right(), 0))

	return model, pos, ang
end
