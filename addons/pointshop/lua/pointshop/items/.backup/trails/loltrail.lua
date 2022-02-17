ITEM.Name = 'LOL'
ITEM.Price = 50
ITEM.Material = 'trails/lol.vmt'

function ITEM:OnEquip(ply, modifications)
	ply.LolTrail = util.SpriteTrail(ply, 0, modifications.color, false, 15, 1, 4, 0.125, self.Material)
end

function ITEM:OnHolster(ply)
	SafeRemoveEntity(ply.LolTrail)
end

function ITEM:Modify(modifications)
	PS:ShowColorChooser(self, modifications)
end

function ITEM:OnModify(ply, modifications)
	SafeRemoveEntity(ply.LolTrail)
	self:OnEquip(ply, modifications)
end
