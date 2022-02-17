ITEM.Name = 'Шляпа (белая)'
ITEM.Price = 75
ITEM.Model = 'models/modified/hat01_fix.mdl'
ITEM.Skin = 2
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
	pos = pos + (ang:Forward() * -4.2) + (ang:Up() * 1.5) + (ang:Right() * 0)
	-- ang:RotateAroundAxis(ang:Right(), 0

	return model, pos, ang
end
