ITEM.Name = 'Кепка Rainbow'
ITEM.Price = 60
ITEM.Model = 'models/modified/hat08.mdl'
ITEM.Skin = 10
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
	pos = pos + (ang:Forward() * -3.8) + (ang:Up() * 1.5) + (ang:Right() * 0)
	-- ang:RotateAroundAxis(ang:Right(), 0)

	return model, pos, ang
end
