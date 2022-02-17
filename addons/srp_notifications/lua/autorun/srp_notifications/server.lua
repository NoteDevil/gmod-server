util.AddNetworkString "srp_notifications.notify"

local function init()

local function doNotify( ply, msgtype, len, msg )

	msgtype = msgtype or NOTIFY_GENERIC
	len = len or 5
	msg = msg or "Notification"

	net.Start( "srp_notifications.notify" )
		net.WriteUInt( msgtype, 4 )
		net.WriteUInt( len, 16 )
		net.WriteString( msg )
	net.Send( ply )

end

if DarkRP then
	function DarkRP.notify( ply, msgtype, len, msg )

	    if not istable( ply ) then
	        if not IsValid( ply ) then
	            -- Dedicated server console
	            print( "NOTIFY: " .. msg )
	            return
	        end

	        ply = { ply }
	    end

		doNotify( ply, msgtype, len, msg )

	end

	function DarkRP.notifyAll( msgtype, len, msg )

		doNotify( player.GetAll(), msgtype, len, msg )

	end
end

local meta = FindMetaTable "Player"

function meta:PS_Notify( msg )

	doNotify( self, NOTIFY_GENERIC, 5, msg )

end

end
hook.Add( "DarkRPFinishedLoading", "srp_notifications", init )

init()
