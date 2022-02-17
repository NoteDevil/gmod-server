ITEM.Name = 'Карнавальная маска'
ITEM.Price = 40
ITEM.Model = 'models/sal/acc/fix/mask_1.mdl'
ITEM.Skin = 0
ITEM.NoLocalPlayer = true
ITEM.Attachment = 'eyes'
ITEM.Slots = {"l_eye", "r_eye"}
ITEM.OffsetType = "face"

function ITEM:OnEquip(ply, modifications)
	ply:PS_AddClientsideModel(self.ID)
end

function ITEM:OnHolster(ply)
	ply:PS_RemoveClientsideModel(self.ID)
end

function ITEM:ModifyClientsideModel(ply, model, pos, ang)
	model:SetModelScale(0.97, 0)
	pos = pos + (ang:Forward() * -3.84) + (ang:Up() * -65.5) + (ang:Right() * 0)
	-- ang:RotateAroundAxis(ang:Right(), 0)

	return model, pos, ang
end
