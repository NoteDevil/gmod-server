ITEM.Name = 'Старый рюкзак (коричневый)'
ITEM.Price = 75
ITEM.Model = 'models/modified/backpack_1.mdl'
ITEM.Skin = 2
ITEM.Attachment = 'chest'
ITEM.Slots = {'back'}
ITEM.OffsetType = "back"

function ITEM:OnEquip(ply, modifications)
	ply:PS_AddClientsideModel(self.ID)
end

function ITEM:OnHolster(ply)
	ply:PS_RemoveClientsideModel(self.ID)
end

function ITEM:ModifyClientsideModel(ply, model, pos, ang)
	pos = pos + (ang:Forward() * -0.7) + (ang:Up() * -4.25) + (ang:Right() * 0)
	if string.find( ply:GetModel(), "female", 1, true ) then
		pos = pos + (ang:Forward() * -1) + (ang:Up() * -2)
	end
	-- ang:RotateAroundAxis(ang:Right(), 0)

	return model, pos, ang
end
