ITEM.Name = '50,000 руб'
ITEM.Price = 50
ITEM.Model = 'models/props_c17/suitcase_passenger_physics.mdl'
ITEM.SingleUse = true

function ITEM:OnBuy(ply)
	ply:addMoney( 50000 )
end
