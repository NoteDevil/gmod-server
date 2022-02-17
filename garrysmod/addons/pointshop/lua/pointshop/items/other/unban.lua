ITEM.Name = 'Разбан'
ITEM.Description = 'Снимает активный бан'
ITEM.Price = 50
ITEM.Material = Material( "icon16/page_white_delete.png" )
ITEM.NoScroll = true
ITEM.SingleUse = true
ITEM.NoPreview = true

function ITEM:OnBuy( ply )

	timer.Remove( "BanTimer" .. ply:SteamID() )
	serverguard:UnbanPlayer( ply:SteamID() )

end

function ITEM:CanPlayerBuy( ply )

	return ply:GetNWBool( "IsBanned" ), "Ты и так без бана, дружище"

end
