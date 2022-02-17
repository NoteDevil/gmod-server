local function RemoveShit()
	local ents_ = ents.FindByClass("trigger_hurt")
	for k,v in pairs(ents_) do
		v:Remove()
	end
end
hook.Add("InitPostEntity", "RemoveShit.InitPostEntity", RemoveShit)
hook.Add("PostCleanupMap", "RemoveShit.PostCleanupMap", RemoveShit)