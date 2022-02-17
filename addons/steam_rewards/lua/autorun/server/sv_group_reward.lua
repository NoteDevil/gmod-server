require("gxml")

util.AddNetworkString("GroupReward.OpenMenu")

srp_rewards = {}

local APIKey = "F737E0C61D78730886053303516850F2"
srp_rewards.lastCheck = 0

local function updateInfo( func )
	if CurTime() > srp_rewards.lastCheck + 3 then
		http.Fetch("http://steamcommunity.com/groups/SchoolRP666/memberslistxml/?xml=1",
			function( body, len, headers, code )
				body = XMLToTable(body)
				srp_rewards.cache = {}
				for k,v in pairs(body["memberList"]["members"]["steamID64"]) do
					srp_rewards.cache[v] = true
				end
				srp_rewards.lastCheck = CurTime()
				func()
			end,
			function( error )
				print("ERROR UPDATING GROUP MEMBERS")
			end
		)
	else
		func()
	end
end

local meta = FindMetaTable "Player"
function meta:IsGroupMember( func )
	updateInfo( function()
		func( srp_rewards.cache[ self:SteamID64() ] )
	end)
end

hook.Add( "PlayerIsLoaded", "GroupReward.PlayerIsLoaded", function( ply )
	ply:IsGroupMember( function( isMember )
		if not isMember then
			net.Start( "GroupReward.OpenMenu" )
			net.Send( ply )
		end
	end)
end)

timer.Create( "GroupReward.Timer", 60 * 60, 0, function()
	for k, ply in pairs( player.GetAll() ) do
		ply:IsGroupMember( function( isMember )
			if isMember then
				ply:addMoney( 1000 )
				DarkRP.notify( ply, NOTIFY_CLEANUP, 5, "Ты получил <color=50,200,50>1000 руб.</color> будучи участником группы!" )
			else
				DarkRP.notify( ply, NOTIFY_ERROR, 5, "Ты бы сейчас получил деньги, если был участником нашей группы :(" )
			end
		end)
	end
end)
timer.Start( "GroupReward.Timer" )



hook.Add("PlayerSay", "GroupReward.PlayerSay", function(ply, text)
	text = string.Explode(" ", text)
	if text[1] == "!steam" then
		ply:SendLua("gui.OpenURL(\"http://steamcommunity.com/groups/schoolrp666\")")
		return ""
	elseif text[1] == "!vk" then
		ply:SendLua("srp_util.openVK()")
		return ""
	end
end)
