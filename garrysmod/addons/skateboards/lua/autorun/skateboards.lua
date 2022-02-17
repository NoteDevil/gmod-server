
AddCSLuaFile()

if ( SERVER ) then

	CreateConVar( "sbox_maxskateboards", 1, { FCVAR_NOTIFY, FCVAR_ARCHIVE } )
	CreateConVar( "sv_skateboard_adminonly", 0, { FCVAR_NOTIFY, FCVAR_ARCHIVE } )
	CreateConVar( "sv_skateboard_cansteal", 0, { FCVAR_NOTIFY, FCVAR_ARCHIVE } )
	CreateConVar( "sv_skateboard_canshare", 1, { FCVAR_NOTIFY, FCVAR_ARCHIVE } )
	//CreateConVar( "sv_skateboard_points", "45", { FCVAR_NOTIFY, FCVAR_ARCHIVE } )
	CreateConVar( "sv_skateboard_canfall", "1", { FCVAR_NOTIFY, FCVAR_ARCHIVE } )

	/*util.AddNetworkString("rb655_hoverpoints")
	timer.Create( "HoverPointsThink", 5, 0, function()
		net.Start("rb655_hoverpoints")
			net.WriteString( GetConVarString( "sv_skateboard_points" ) )
		net.Broadcast()
	end )*/

	//CreateConVar( "rb655_force_downloads", "0", FCVAR_ARCHIVE )

	/*if ( GetConVarNumber( "rb655_force_downloads" ) > 0 ) then
		resource.AddFile( "materials/modulus_skateboard/glow.vmt" )
		resource.AddFile( "materials/modulus_skateboard/trail.vmt" )
		resource.AddFile( "materials/modulus_skateboard/deathicon.vmt" )
		resource.AddFile( "materials/modulus_skateboard/deathicon.vtf" )
	end*/
	
	resource.AddWorkshop( 150455514 )
else
	CreateConVar( "cl_skateboard_developer", "0", FCVAR_CHEAT )

	language.Add( "srp_skateboard", "Skateboard" )
	language.Add( "srp_skateboard_hull", "Skateboard" )
	language.Add( "srp_skateboard_avatar", "Skateboard" )

	killicon.Add( "srp_skateboard", "modulus_skateboard/deathicon", Color( 255, 80, 0, 255 ) )
	killicon.AddAlias( "srp_skateboard_hull", "modulus_skateboard" )
	killicon.AddAlias( "srp_skateboard_avatar", "modulus_skateboard" )
end

/* ------------------------------------------------
	Skateboard Types
------------------------------------------------ */

SkateboardTypes = {}

table.insert( SkateboardTypes, {
	
	model = "models/skateboard/skateboard.mdl",
	name = "Garry's Board",
	rotation = 90,
	driver = Vector( 0, 2, 1.5 ),
	files = {
		"materials/models/skateboard/skate_deck.vmt",
		"materials/models/skateboard/skate_deck.vtf",
		"materials/models/skateboard/skate_misc.vmt",
		"materials/models/skateboard/skate_misc.vtf",
	}
} )

table.insert( SkateboardTypes, {
	
	model = "models/mixerman3d/sports/rag_bmx.mdl",
	name = "BMX",
	rotation = 180,
	driver = Vector( 0, 2, 1.5 ),
	files = {
		"materials/mixerman3d/sports/bmx_bars.vmt",
		"materials/mixerman3d/sports/bmx_bars.vtf",
		"materials/mixerman3d/sports/bmx_body.vmt",
		"materials/mixerman3d/sports/bmx_body.vtf",
		"materials/mixerman3d/sports/bmx_break.vmt",
		"materials/mixerman3d/sports/bmx_break.vtf",
		"materials/mixerman3d/sports/bmx_chain.vmt",
		"materials/mixerman3d/sports/bmx_chain.vtf",
		"materials/mixerman3d/sports/bmx_grip.vmt",
		"materials/mixerman3d/sports/bmx_grip.vtf",
	}
} )


table.insert( SkateboardTypes, {
	
	model = "models/hexedskate/oth10/skateboa10.mdl",
	name = "Stripes",
	rotation = 90,
	driver = Vector( 0, 2, 1.5 ),
	files = {
		"materials/hexedskate/oth10/metal_galv.vmt",
		"materials/hexedskate/oth10/metal_galv.vtf",
		"materials/hexedskate/oth10/metal_galv2.vmt",
		"materials/hexedskate/oth10/metal_galv2.vtf",
		"materials/hexedskate/oth10/skate_deck.vmt",
		"materials/hexedskate/oth10/skate_deck.vtf",
		"materials/hexedskate/oth10/skate_misc.vmt",
		"materials/hexedskate/oth10/skate_misc.vtf",
	}
} )

table.insert( SkateboardTypes, {
	
	model = "models/hexedskate/oth11/skateboa11.mdl",
	name = "Element",
	rotation = 90,
	driver = Vector( 0, 2, 1.5 ),
	files = {
		"materials/hexedskate/oth11/metal_galv.vmt",
		"materials/hexedskate/oth11/metal_galv.vtf",
		"materials/hexedskate/oth11/metal_galv2.vmt",
		"materials/hexedskate/oth11/metal_galv2.vtf",
		"materials/hexedskate/oth11/skate_deck.vmt",
		"materials/hexedskate/oth11/skate_deck.vtf",
		"materials/hexedskate/oth11/skate_misc.vmt",
		"materials/hexedskate/oth11/skate_misc.vtf",
	}
} )

table.insert( SkateboardTypes, {
	
	model = "models/hexedskate/oth12/skateboa12.mdl",
	name = "Blind",
	rotation = 90,
	driver = Vector( 0, 2, 1.5 ),
	files = {
		"materials/hexedskate/oth12/metal_galv.vmt",
		"materials/hexedskate/oth12/metal_galv.vtf",
		"materials/hexedskate/oth12/metal_galv2.vmt",
		"materials/hexedskate/oth12/metal_galv2.vtf",
		"materials/hexedskate/oth12/skate_deck.vmt",
		"materials/hexedskate/oth12/skate_deck.vtf",
		"materials/hexedskate/oth12/skate_misc.vmt",
		"materials/hexedskate/oth12/skate_misc.vtf",
	}
} )

table.insert( SkateboardTypes, {
	
	model = "models/hexedskate/othe2/skateboar2.mdl",
	name = "Habitat",
	rotation = 90,
	driver = Vector( 0, 2, 1.5 ),
	files = {
		"materials/hexedskate/othe2/metal_galv.vmt",
		"materials/hexedskate/othe2/metal_galv.vtf",
		"materials/hexedskate/othe2/metal_galv2.vmt",
		"materials/hexedskate/othe2/metal_galv2.vtf",
		"materials/hexedskate/othe2/skate_deck.vmt",
		"materials/hexedskate/othe2/skate_deck.vtf",
		"materials/hexedskate/othe2/skate_misc.vmt",
		"materials/hexedskate/othe2/skate_misc.vtf",
	}
} )

table.insert( SkateboardTypes, {
	
	model = "models/hexedskate/othe3/skateboar3.mdl",
	name = "Bubbles",
	rotation = 90,
	driver = Vector( 0, 2, 1.5 ),
	files = {
		"materials/hexedskate/othe3/metal_galv.vmt",
		"materials/hexedskate/othe3/metal_galv.vtf",
		"materials/hexedskate/othe3/metal_galv2.vmt",
		"materials/hexedskate/othe3/metal_galv2.vtf",
		"materials/hexedskate/othe3/skate_deck.vmt",
		"materials/hexedskate/othe3/skate_deck.vtf",
		"materials/hexedskate/othe3/skate_misc.vmt",
		"materials/hexedskate/othe3/skate_misc.vtf",
	}
} )


table.insert( SkateboardTypes, {
	
	model = "models/hexedskate/othe4/skateboar4.mdl",
	name = "Template",
	rotation = 90,
	driver = Vector( 0, 2, 1.5 ),
	files = {
		"materials/hexedskate/othe4/metal_galv.vmt",
		"materials/hexedskate/othe4/metal_galv.vtf",
		"materials/hexedskate/othe4/metal_galv2.vmt",
		"materials/hexedskate/othe4/metal_galv2.vtf",
		"materials/hexedskate/othe4/skate_deck.vmt",
		"materials/hexedskate/othe4/skate_deck.vtf",
		"materials/hexedskate/othe4/skate_misc.vmt",
		"materials/hexedskate/othe4/skate_misc.vtf",
	}
} )

table.insert( SkateboardTypes, {
	
	model = "models/hexedskate/othe5/skateboar5.mdl",
	name = "Skullhawk",
	rotation = 90,
	driver = Vector( 0, 2, 1.5 ),
	files = {
		"materials/hexedskate/othe5/metal_galv.vmt",
		"materials/hexedskate/othe5/metal_galv.vtf",
		"materials/hexedskate/othe5/metal_galv2.vmt",
		"materials/hexedskate/othe5/metal_galv2.vtf",
		"materials/hexedskate/othe5/skate_deck.vmt",
		"materials/hexedskate/othe5/skate_deck.vtf",
		"materials/hexedskate/othe5/skate_misc.vmt",
		"materials/hexedskate/othe5/skate_misc.vtf",
	}
} )

table.insert( SkateboardTypes, {
	
	model = "models/hexedskate/othe6/skateboar6.mdl",
	name = "Iron Flip",
	rotation = 90,
	driver = Vector( 0, 2, 1.5 ),
	files = {
		"materials/hexedskate/othe6/metal_galv.vmt",
		"materials/hexedskate/othe6/metal_galv.vtf",
		"materials/hexedskate/othe6/metal_galv2.vmt",
		"materials/hexedskate/othe6/metal_galv2.vtf",
		"materials/hexedskate/othe6/skate_deck.vmt",
		"materials/hexedskate/othe6/skate_deck.vtf",
		"materials/hexedskate/othe6/skate_misc.vmt",
		"materials/hexedskate/othe6/skate_misc.vtf",
	}
} )


table.insert( SkateboardTypes, {
	
	model = "models/hexedskate/othe7/skateboar7.mdl",
	name = "Clockwork",
	rotation = 90,
	driver = Vector( 0, 2, 1.5 ),
	files = {
		"materials/hexedskate/othe7/metal_galv.vmt",
		"materials/hexedskate/othe7/metal_galv.vtf",
		"materials/hexedskate/othe7/metal_galv2.vmt",
		"materials/hexedskate/othe7/metal_galv2.vtf",
		"materials/hexedskate/othe7/skate_deck.vmt",
		"materials/hexedskate/othe7/skate_deck.vtf",
		"materials/hexedskate/othe7/skate_misc.vmt",
		"materials/hexedskate/othe7/skate_misc.vtf",
	}
} )

table.insert( SkateboardTypes, {
	
	model = "models/hexedskate/othe8/skateboar8.mdl",
	name = "Work",
	rotation = 90,
	driver = Vector( 0, 2, 1.5 ),
	files = {
		"materials/hexedskate/othe8/metal_galv.vmt",
		"materials/hexedskate/othe8/metal_galv.vtf",
		"materials/hexedskate/othe8/metal_galv2.vmt",
		"materials/hexedskate/othe8/metal_galv2.vtf",
		"materials/hexedskate/othe8/skate_deck.vmt",
		"materials/hexedskate/othe8/skate_deck.vtf",
		"materials/hexedskate/othe8/skate_misc.vmt",
		"materials/hexedskate/othe8/skate_misc.vtf",
	}
} )

table.insert( SkateboardTypes, {
	
	model = "models/hexedskate/othe9/skateboar9.mdl",
	name = "Fire",
	rotation = 90,
	driver = Vector( 0, 2, 1.5 ),
	files = {
		"materials/hexedskate/othe9/metal_galv.vmt",
		"materials/hexedskate/othe9/metal_galv.vtf",
		"materials/hexedskate/othe9/metal_galv2.vmt",
		"materials/hexedskate/othe9/metal_galv2.vtf",
		"materials/hexedskate/othe9/skate_deck.vmt",
		"materials/hexedskate/othe9/skate_deck.vtf",
		"materials/hexedskate/othe9/skate_misc.vmt",
		"materials/hexedskate/othe9/skate_misc.vtf",
	}
} )

table.insert( SkateboardTypes, {
	
	model = "models/hexedskate/other/skateboar1.mdl",
	name = "Zero Green",
	rotation = 90,
	driver = Vector( 0, 2, 1.5 ),
	files = {
		"materials/hexedskate/other/metal_galv.vmt",
		"materials/hexedskate/other/metal_galv.vtf",
		"materials/hexedskate/other/metal_galv2.vmt",
		"materials/hexedskate/other/metal_galv2.vtf",
		"materials/hexedskate/other/skate_deck.vmt",
		"materials/hexedskate/other/skate_deck.vtf",
		"materials/hexedskate/other/skate_misc.vmt",
		"materials/hexedskate/other/skate_misc.vtf",
	}
} )


table.insert( SkateboardTypes, {
	
	model = "models/mixerman3d/other/ameriboard.mdl",
	name = "Zero America",
	rotation = 90,
	driver = Vector( 0, 2, 1.5 ),
} )

table.insert( SkateboardTypes, {
	
	model = "models/mixerman3d/other/bamm1board.mdl",
	name = "Bam Margera",
	rotation = 90,
	driver = Vector( 0, 2, 1.5 ),
} )

table.insert( SkateboardTypes, {
	
	model = "models/mixerman3d/other/bamm2board.mdl",
	name = "Bam Margera 2",
	rotation = 90,
	driver = Vector( 0, 2, 1.5 ),
} )

table.insert( SkateboardTypes, {
	
	model = "models/mixerman3d/other/bamm3board.mdl",
	name = "Bam Margera 3",
	rotation = 90,
	driver = Vector( 0, 2, 1.5 ),
} )

table.insert( SkateboardTypes, {
	
	model = "models/mixerman3d/other/imgodboard.mdl",
	name = "Bam Margera 4",
	rotation = 90,
	driver = Vector( 0, 2, 1.5 ),
} )

table.insert( SkateboardTypes, {
	
	model = "models/mixerman3d/other/jrs10board.mdl",
	name = "Bull",
	rotation = 90,
	driver = Vector( 0, 2, 1.5 ),
} )

table.insert( SkateboardTypes, {
	
	model = "models/mixerman3d/other/krookboard.mdl",
	name = "Krook",
	rotation = 90,
	driver = Vector( 0, 2, 1.5 ),
} )

table.insert( SkateboardTypes, {
	
	model = "models/mixerman3d/other/wind1board.mdl",
	name = "Rainbow",
	rotation = 90,
	driver = Vector( 0, 2, 1.5 ),
} )

table.insert( SkateboardTypes, {
	
	model = "models/mixerman3d/other/wind2board.mdl",
	name = "Wind",
	rotation = 90,
	driver = Vector( 0, 2, 1.5 ),
} )

table.insert( SkateboardTypes, {
	
	model = "models/mixerman3d/other/worldboard.mdl",
	name = "World",
	rotation = 90,
	driver = Vector( 0, 2, 1.5 ),
} )

table.insert( SkateboardTypes, {
	
	model = "models/mixerman3d/other/zerosboard.mdl",
	name = "Zero's",
	rotation = 90,
	driver = Vector( 0, 2, 1.5 ),
} )

table.insert( SkateboardTypes, {
	
	model = "models/mixerman3d/other/zooy1board.mdl",
	name = "Zoo York",
	rotation = 90,
	driver = Vector( 0, 2, 1.5 ),
} )

table.insert( SkateboardTypes, {
	
	model = "models/mixerman3d/other/zooy2board.mdl",
	name = "Zoo York 2",
	rotation = 90,
	driver = Vector( 0, 2, 1.5 ),
} )

table.insert( SkateboardTypes, {
	
	model = "models/mixerman3d/other/zooy3board.mdl",
	name = "Zoo York 3",
	rotation = 90,
	driver = Vector( 0, 2, 1.5 ),
} )

table.insert( SkateboardTypes, {
	
	model = "models/mixerman3d/other/zooy4board.mdl",
	name = "Zoo York 4",
	rotation = 90,
	driver = Vector( 0, 2, 1.5 ),
} )

table.insert( SkateboardTypes, {
	
	model = "models/mixerman3d/other/zooy5board.mdl",
	name = "Zoo York 5",
	rotation = 90,
	driver = Vector( 0, 2, 1.5 ),
} )
