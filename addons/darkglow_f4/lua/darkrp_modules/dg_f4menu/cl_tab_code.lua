if !DGF4.RegisterButton then return end

local Info = {}
Info.pos = 4
Info.name = "Погасить код"
Info.DontSave = true
Info.col = Color(255,36,0)
Info.wide = 200
Info.callBack = function(self)
	RunConsoleCommand( "srp_promo" )
end

DGF4:RegisterButton(Info)