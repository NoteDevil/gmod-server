ITEM.Name = 'Junko'
ITEM.Price = 0
ITEM.Model = 'models/player/dewobedil/junko_enoshima/default_p.mdl'
ITEM.Hidden = true

function ITEM:OnEquip(ply, modifications)
	if not ply._OldModel then
		ply._OldModel = ply:GetModel()
	end

	timer.Simple(1, function() ply:SetModel(self.Model) end)
end

function ITEM:OnHolster(ply)
	if ply._OldModel then
		ply:SetModel(ply._OldModel)
	end
end

function ITEM:PlayerSetModel(ply)
	ply:SetModel(self.Model)
end

function ITEM:CanPlayerBuy(ply)
	return false, "Это только для Володи ;)"
end
