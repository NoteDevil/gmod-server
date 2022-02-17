if !DGF4.RegisterButton then return end

local Info = {}
Info.pos = 1
Info.name = "Донат"
Info.DontSave = true
Info.col = Color(255,36,0)
Info.wide = 200
Info.callBack = function(self)
	PS:ToggleMenu()
end

DGF4:RegisterButton(Info)