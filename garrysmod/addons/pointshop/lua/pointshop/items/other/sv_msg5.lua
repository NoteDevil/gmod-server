ITEM.Name = 'Уведомление на 5 минут'
ITEM.Description = 'Показывает уведомление в нижней части экрана\nвсем игрокам в течение 5 минут'
ITEM.Price = 10
ITEM.Material = Material( "icon16/script_add.png" )
ITEM.NoScroll = true
ITEM.SingleUse = true
ITEM.NoPreview = true

function ITEM:OnBuy( ply )

	ply:GivePSNotification( 5, self.Price )

end
