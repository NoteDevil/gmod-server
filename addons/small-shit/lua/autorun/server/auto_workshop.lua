hook.Add( "Initialize", "CompareAddons:BuildList", function()
	for k, v in pairs( engine.GetAddons() ) do
		local _file = v.wsid and v.wsid or string.gsub( tostring( v.file ), "%D", "" )
		resource.AddWorkshop( _file )
	end
end )

resource.AddWorkshop "218098935" -- wot-tak-wot swep
resource.AddWorkshop "380225333" -- NB zombies
