if CLIENT then

    hook.Add( "Think", "PlayerIsLoaded", function()
        if IsValid( LocalPlayer() ) then
            hook.Remove( "Think", "PlayerIsLoaded" )
            
            net.Start( "PlayerIsLoaded" )
            net.SendToServer()

            hook.Run( "PlayerIsLoaded" )
        end
    end)

else

    util.AddNetworkString "PlayerIsLoaded"
    net.Receive( "PlayerIsLoaded", function( len, ply )
        hook.Run( "PlayerIsLoaded", ply )
    end)

end