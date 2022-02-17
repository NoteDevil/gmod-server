if !DGF4.RegisterButton then return end

local Info = {}
Info.pos = 3
Info.name = "Ссылки"
Info.DontSave = true
Info.col = Color(255,36,0)
Info.wide = 200
Info.callBack = function(self)
	local menu = vgui.Create("UPMenu", self)
	for k,v in pairs(DGF4.Information.Links) do
		if k == "Донат" then
			v = v..LocalPlayer():SteamID() 
		end
		menu:AddOption(k,function() gui.OpenURL(v) surface.PlaySound("buttons/button9.wav") end)
	end
	menu:Open()
end

DGF4:RegisterButton(Info)