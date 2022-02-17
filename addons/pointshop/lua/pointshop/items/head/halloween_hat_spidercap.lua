ITEM.Name = 'Кепка-паук'
ITEM.Price = 0
ITEM.Model = 'models/roblox/spider_cap.mdl'
ITEM.Skin = 0
ITEM.NoLocalPlayer = true
ITEM.Attachment = 'eyes'
ITEM.Slots = {"hat"}
ITEM.OffsetType = "hat"
ITEM.Hidden = true

function ITEM:CanPlayerBuy(ply)
	return false, "Этот предмет из ограниченной серии"
end

function ITEM:CanPlayerSell(ply)
	return false, "Этот предмет из ограниченной серии"
end

function ITEM:OnEquip(ply, modifications)
	ply:PS_AddClientsideModel(self.ID)
end

function ITEM:OnHolster(ply)
	ply:PS_RemoveClientsideModel(self.ID)
end

function ITEM:ModifyClientsideModel(ply, model, pos, ang)
	ang:RotateAroundAxis(ang:Right(), 10)
	ang:RotateAroundAxis(ang:Up(), -175)
	pos = pos + (ang:Forward() * 2.4) + (ang:Up() * 3.63) + (ang:Right() * 0)

	return model, pos, ang, 0.7
end
