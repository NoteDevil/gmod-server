local reward = 75000

local function databaseInit()

	MySQLite.begin()

	MySQLite.queueQuery([[
		CREATE TABLE IF NOT EXISTS communityrewards (
			`id` INT NOT NULL AUTO_INCREMENT ,
			`steamID` VARCHAR(30) NOT NULL ,
			`vkID` INT NOT NULL ,
			`claimed` TINYINT(1) NOT NULL ,
			PRIMARY KEY (`id`),
			UNIQUE (`steamID`),
			UNIQUE (`vkID`)
		)
	]])

	MySQLite.commit()

end
hook.Add("DarkRPDBInitialized", "webapi_communityRewards", databaseInit)

local function applyReward( ply )

	ply:addMoney( 10000 )
	ply:PS_GivePoints( 20 )

	DarkRP.notifyAll( NOTIFY_CLEANUP, 10,
		"<color=50,200,50>" .. ply:SteamName() ..
		"</color> получил <color=50,200,50>20$</color> и <color=50,200,50>10000р.</color>, подписавшись на нас в ВК. Пиши <color=50,200,50>!vk</color>, если хочешь тоже!"
	)

end

local function checkPlayer( ply )

	local id = MySQLite.SQLStr( ply:SteamID() )
	MySQLite.query([[
		SELECT * FROM communityrewards
		WHERE steamID = ]] .. id .. [[ AND claimed = 0;
	]], function( res )
		if res and table.Count(res) > 0 then
			local data = res[1]
			applyReward( ply )
			MySQLite.query([[
				UPDATE communityrewards
				SET claimed = 1
				WHERE steamID = ]] .. id .. [[;
			]])
		end
	end)

end
hook.Add( "PlayerIsLoaded", "CheckCommunityReward", checkPlayer )

print( "[#] Community rewards initialized." )
