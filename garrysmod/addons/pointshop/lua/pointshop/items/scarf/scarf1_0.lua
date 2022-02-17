ITEM.Name = 'Шарф (белый)'
ITEM.Price = 75
ITEM.Model = 'models/sal/acc/fix/scarf01.mdl'
ITEM.Skin = 0
ITEM.Attachment = 'chest'
ITEM.Slots = {"neck"}
ITEM.OffsetType = "neck"

function ITEM:OnEquip(ply, modifications)
	ply:PS_AddClientsideModel(self.ID)
end

function ITEM:OnHolster(ply)
	ply:PS_RemoveClientsideModel(self.ID)
end

function ITEM:ModifyClientsideModel(ply, model, pos, ang)
	pos = pos + (ang:Forward() * -0.6) + (ang:Up() * -16) + (ang:Right() * 0)
	if string.find( ply:GetModel(), "female", 1, true ) then
		pos = pos + (ang:Forward() * -1) + (ang:Up() * -2)
	end
	-- ang:RotateAroundAxis(ang:Right(), 0)

	return model, pos, ang
end
