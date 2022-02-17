ITEM.Name = 'Разноцветный физган'
ITEM.Description = 'Плавно изменяет цвет твоего физгана'
ITEM.Price = 100
ITEM.Material = Material( "icon16/rainbow.png" )
ITEM.NoScroll = true
ITEM.SingleUse = false
ITEM.NoPreview = true

function ITEM:OnEquip( ply )

	ply.physgunColour = true

end

function ITEM:OnHolster( ply )

	ply.physgunColour = nil

end
