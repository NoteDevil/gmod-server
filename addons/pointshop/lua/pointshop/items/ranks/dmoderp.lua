ITEM.Name = '5. Модер - 3 месяца'
ITEM.Price = 850
ITEM.Material = Material( "icon16/lightbulb_add.png" )
ITEM.NoScroll = true
ITEM.SingleUse = true
ITEM.NoPreview = true
ITEM.BuyRank = "dmoder"
ITEM.BuyTime = 60 * 60 * 24 * 30 * 3

function ITEM:OnBuy( ply )

	serverguard.player:SetRank( ply, self.BuyRank, self.BuyTime, false )

end

function ITEM:CanPlayerBuy( ply )

	local curImm = serverguard.ranks:FindByID( ply:GetUserGroup() ).immunity
	local tgtImm = serverguard.ranks:FindByID( self.BuyRank ).immunity

	return curImm < tgtImm, "Вряд ли тебе это нужно"

end
