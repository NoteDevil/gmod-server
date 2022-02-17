hook.Add("hungerUpdate", "ForFounderDisable.hungerUpdate", function(ply, value)
	if ply:GetUserGroup() == "founder" then return true end
end)