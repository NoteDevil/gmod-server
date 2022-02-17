ITEM.Name = '100,000 руб'
ITEM.Price = 100
ITEM.Model = 'models/props_c17/suitcase001a.mdl'
ITEM.SingleUse = true

function ITEM:OnBuy(ply)
	ply:addMoney( 100000 )
end
