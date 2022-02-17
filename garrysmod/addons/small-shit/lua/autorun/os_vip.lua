local meta = FindMetaTable "Player"

local function isvip( self )

	return self:query( "SRP: VIP статус" )

end
meta.IsVIP = isvip
meta.IsVip = isvip
