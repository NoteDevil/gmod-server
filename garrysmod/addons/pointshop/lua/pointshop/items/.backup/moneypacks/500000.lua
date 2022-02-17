ITEM.Name = '500,000 руб'
ITEM.Price = 500
ITEM.Model = 'models/props/cs_assault/moneypallet03d.mdl'
ITEM.SingleUse = true

function ITEM:OnBuy(ply)
	ply:addMoney( 500000 )
end
