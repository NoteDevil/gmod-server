if !DGF4.RegisterButton then return end

local Info = {}
Info.pos = 2
Info.name = "Помощь"
Info.DontSave = true
Info.col = Color(255,36,0)
Info.wide = 200
Info.callBack = function(self)
	srp_util.openHelp()
end

DGF4:RegisterButton(Info)