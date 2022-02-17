SRP_Library = SRP_Library or {}
SRP_Library.Books = SRP_Library.Books or {}
SRP_Library.LastBook = 1

function UpdateSRPLibrary()
	if SRP_Library.Loaded then return end
	http.Fetch("http://octothorp.team:1234/GetNewPosts", function(body)
		SRP_Library.Books = util.JSONToTable(body)
		SRP_Library.Loaded = true
	end,
	function()
		print("ERROR UPDATING BOOK CONTENT ON SERVER")
	end)
end
hook.Add("PlayerIsLoaded", "SRP_Library.PlayerIsLoaded", UpdateSRPLibrary)

concommand.Add("update_srp_library", function(ply)
	if ply:GetUserGroup() ~= "founder" then return end
	SRP_Library.Loaded = false
	UpdateSRPLibrary()
end)