ITEM.Name = 'Кличка на день'
ITEM.Description = 'Возможность дать кличку любому игроку,\nкоторая будет отображаться рядом с именем 1 день'
ITEM.Price = 15
ITEM.Material = Material( "icon16/script_add.png" )
ITEM.NoScroll = true
ITEM.SingleUse = true
ITEM.NoPreview = true

function ITEM:OnBuy( ply )

	ply:GivePSNick( 24 * 60 * 60, self.Price )

end
