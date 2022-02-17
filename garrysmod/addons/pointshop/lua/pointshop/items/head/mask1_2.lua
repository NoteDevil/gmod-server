ITEM.Name = 'Маска-череп (камуфляж)'
ITEM.Price = 120
ITEM.Model = 'models/modified/mask6.mdl'
ITEM.Skin = 2
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
	model:SetModelScale(0.85, 0)
	pos = pos + (ang:Forward() * -3.3) + (ang:Up() * -2.6) + (ang:Right() * 0)
	-- ang:RotateAroundAxis(ang:Right(), 0)

	return model, pos, ang
end
