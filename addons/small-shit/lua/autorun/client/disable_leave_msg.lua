hook.Add("ChatText", "hide_joinleave", function( index, name, text, typ )
	if typ == "joinleave" then return true end
end)