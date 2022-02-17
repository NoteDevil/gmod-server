ITEM.Name = '6. Админ - 1 месяц'
ITEM.Price = 500
ITEM.Material = Material( "icon16/shield.png" )
ITEM.NoScroll = true
ITEM.SingleUse = true
ITEM.NoPreview = true
ITEM.BuyRank = "dadmin"
ITEM.BuyTime = 60 * 60 * 24 * 30

function ITEM:OnBuy( ply )

	serverguard.player:SetRank( ply, self.BuyRank, self.BuyTime, false )

end

function ITEM:CanPlayerBuy( ply )

	local curImm = serverguard.ranks:FindByID( ply:GetUserGroup() ).immunity
	local tgtImm = serverguard.ranks:FindByID( self.BuyRank ).immunity

	return curImm < tgtImm, "Вряд ли тебе это нужно"

end
