ITEM.Name = 'Сова в тыкве'
ITEM.Price = 0
ITEM.Model = 'models/roblox/owl_of_the_week__pumpkin_owl.mdl'
ITEM.Skin = 1
ITEM.Attachment = 'chest'
ITEM.Slots = {'companion'}
ITEM.Hidden = true
ITEM.OffsetType = "back"

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
	pos = pos + (ang:Forward() * -3.5) + (ang:Up() * 8.3) + (ang:Right() * -5.4)
	ang:RotateAroundAxis(ang:Right(), -0)
	ang:RotateAroundAxis(ang:Up(), 180)

	return model, pos, ang, 0.62
end
