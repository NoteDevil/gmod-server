ITEM.Name = 'Пробный администратор - на неделю'
ITEM.Price = 150
ITEM.Model = 'models/player/combine_soldier_prisonguard.mdl'
ITEM.SingleUse = true
ITEM.NoPreview = true
ITEM.BuyRank = "dadmin"
ITEM.BuyTime = 60 * 60 * 24 * 7

function ITEM:OnBuy( ply )

	serverguard.player:SetRank( ply, self.BuyRank, self.BuyTime, false )

end

-- function ITEM:CanPlayerBuy( ply )
--
-- 	local curImm = serverguard.ranks:FindByID( ply:GetUserGroup() ).immunity
-- 	local tgtImm = serverguard.ranks:FindByID( self.BuyRank ).immunity
--
-- 	return curImm < tgtImm, "Вряд ли тебе это нужно"
--
-- end
