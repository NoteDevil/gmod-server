ITEM.Name = 'Игровые деньги'
ITEM.Description = 'Купить игровую валюту по курсу 1$ = 2000р.'
ITEM.Price = 0
ITEM.Material = Material( "icon16/money.png" )
ITEM.NoScroll = true
ITEM.SingleUse = true
ITEM.NoPreview = true

function ITEM:OnBuy( ply )

	ply:GivePSMoney()

end
