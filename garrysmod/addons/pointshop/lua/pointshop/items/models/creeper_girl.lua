ITEM.Name = 'Creeper Girl'
ITEM.Price = 550
ITEM.Model = 'models/player/creepergirl/sour_creepergirl_player.mdl'
ITEM.Skin = 0

function ITEM:OnEquip(ply, modifications)
	if not ply._OldModel then
		ply._OldModel = ply:GetModel()
		ply._OldSkin = ply:GetSkin()
	end

	timer.Simple(1, function() ply:SetModel(self.Model) ply:SetSkin(self.Skin) end)
end

function ITEM:OnHolster(ply)
	if ply._OldModel then
		ply:SetModel(ply._OldModel)
		ply:SetSkin(ply._OldSkin or 0)
	end
end

function ITEM:PlayerSetModel(ply)
	ply:SetModel(self.Model)
	ply:SetSkin(self.Skin)
end
