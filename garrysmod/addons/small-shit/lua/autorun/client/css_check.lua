hook.Add("PlayerIsLoaded", "CSS_Check.PlayerIsLoaded", function()
	if IsMounted(240) then
		return
	else
		chat.AddText("Похоже, у тебя нет контента Counter-Strike: Source, скачай ее в Steam или найди контент.")
	end
end)