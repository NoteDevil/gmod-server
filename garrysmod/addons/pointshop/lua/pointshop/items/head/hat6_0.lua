ITEM.Name = 'Кепка болельщика (синяя)'
ITEM.Price = 60
ITEM.Model = 'models/sal/acc/fix/beerhat.mdl'
ITEM.Skin = 0
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
	pos = pos + (ang:Forward() * -3.8) + (ang:Up() * 0) + (ang:Right() * 0)
	-- ang:RotateAroundAxis(ang:Right(), 0)

	return model, pos, ang
end
