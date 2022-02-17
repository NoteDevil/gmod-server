ITEM.Name = 'Своя модель на месяц'
ITEM.Description = 'Позволяет выбрать любую модель из Workshop\nи использовать ее в игре в течение месяца.\nМодель можно изменять раз в день'
ITEM.Price = 1000
ITEM.Material = Material( "icon16/user_gray.png" )
ITEM.NoScroll = true
ITEM.SingleUse = false
ITEM.NoPreview = true

function ITEM:OnBuy( ply )

	if not file.Exists("srp_wsmodels", "DATA") then file.CreateDir("srp_wsmodels") end
	file.Write("srp_wsmodels/" .. ply:SteamID64() .. ".dat", tostring( os.time() + 30 * 24 * 60 * 60 ))
	DarkRP.notify(ply, NOTIFY_CLEANUP, 20, "Обязательно прочти правила использования своих моделей. При их несоблюдении ты можешь потерять привилегию!")

end

function ITEM:CanPlayerSell( ply )

	return false, "Эту плюшку нельзя продать!"

end

function ITEM:CanPlayerEquip( ply )

	return false, "Чтобы настроить свою модель, напиши <color50,200,50>!mymodel</color>"

end

function ITEM:CanPlayerHolster( ply )

	return false, "Как ты это сделал? Обратись к админам"

end
