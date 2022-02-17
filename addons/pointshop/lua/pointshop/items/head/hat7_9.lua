ITEM.Name = 'Бейсболка Bigfoot'
ITEM.Price = 80
ITEM.Model = 'models/modified/hat07.mdl'
ITEM.Skin = 9
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
	pos = pos + (ang:Forward() * -4.1) + (ang:Up() * 2) + (ang:Right() * 0.15)
	-- ang:RotateAroundAxis(ang:Right(), 0)

	return model, pos, ang
end
