util.AddNetworkString("DoorsTitles.SendDoorTable")

local doors = {
	{ id = 1423, text = "Биология" },
	{ id = 1427, text = "Русский Яз." },
	{ id = 1428, text = "Русский Яз.", inverted = true },
	{ id = 1424, text = "Иностранный" },
	{ id = 1426, text = "Математика" },
	{ id = 1425, text = "Математика", inverted = true },
	{ id = 1429, text = "История", inverted = true },
	{ id = 1430, text = "Учительская", inverted = true },
	{ id = 1991, text = "Директор" },
	{ id = 1990, text = "Директор", inverted = true },
	{ id = 1992, text = "Мед. Кабинет" },
	{ id = 1437, text = "Физика" },
	{ id = 1438, text = "Физика", inverted = true },
	{ id = 1436, text = "Информатика" },
	{ id = 1433, text = "Культура", inverted = true },
	{ id = 1434, text = "География", inverted = true },
	{ id = 1431, text = "Химия" },
	{ id = 1432, text = "Химия", inverted = true },
	{ id = 1439, text = "Литература" },
	{ id = 1440, text = "Литература", inverted = true },
	{ id = 1443, text = "Фотосервис" },
	{ id = 1445, text = "Шахматы"},
	{ id = 1446, text = "Шахматы", inverted = true},
}

hook.Add( "InitPostEntity", "DoorsTitles.InitPostEntity", function()

	for k,v in pairs( doors ) do
		local door = ents.GetMapCreatedEntity( v.id )
		if not IsValid( door ) then continue end

		doors[k].id = door:EntIndex()
	end

end)

hook.Add( "PlayerIsLoaded", "DoorsTitles.PlayerIsLoaded", function(ply)

	net.Start("DoorsTitles.SendDoorTable")
		net.WriteTable( doors )
	net.Send( ply )

end)
