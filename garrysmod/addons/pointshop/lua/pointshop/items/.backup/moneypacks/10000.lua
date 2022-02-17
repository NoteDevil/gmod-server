ITEM.Name = '10,000 руб'
ITEM.Price = 10
ITEM.Model = 'models/props/cs_assault/money.mdl'
ITEM.SingleUse = true

function ITEM:OnBuy(ply)
	ply:addMoney( 10000 )
end
