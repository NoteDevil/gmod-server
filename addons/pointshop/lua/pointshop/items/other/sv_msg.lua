ITEM.Name = 'Уведомление на 1 минуту'
ITEM.Description = 'Показывает уведомление в нижней части экрана\nвсем игрокам в течение 1 минуты'
ITEM.Price = 5
ITEM.Material = Material( "icon16/script.png" )
ITEM.NoScroll = true
ITEM.SingleUse = true
ITEM.NoPreview = true

function ITEM:OnBuy( ply )

	ply:GivePSNotification( 1, self.Price )

end
