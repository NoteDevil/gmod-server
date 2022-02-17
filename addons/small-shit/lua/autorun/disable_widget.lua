hook.Add( "PreGamemodeLoaded", "DisableWidget.PreGamemodeLoaded", function()
	widgets.PlayerTick = nil
	hook.Remove( "PlayerTick", "TickWidgets" )
	hook.Remove( "PostDrawEffects", "RenderWidgets" )
end )
