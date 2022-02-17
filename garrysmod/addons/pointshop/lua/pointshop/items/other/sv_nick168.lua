ITEM.Name = 'Кличка на неделю'
ITEM.Description = 'Возможность дать кличку любому игроку,\nкоторая будет отображаться рядом с именем 1 неделю'
ITEM.Price = 50
ITEM.Material = Material( "icon16/script_add.png" )
ITEM.NoScroll = true
ITEM.SingleUse = true
ITEM.NoPreview = true

function ITEM:OnBuy( ply )

	ply:GivePSNick( 7 * 24 * 60 * 60, self.Price )

end
