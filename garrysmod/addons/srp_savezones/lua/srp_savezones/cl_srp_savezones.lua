surface.CreateFont("SRP_SaveZones.MainFont", {
	font = "Roboto Bold",
	size = 25,
	weight = 500,
	extended = true,
})

local function drawBackGround(round, x, y, w, h, alpha)
	alpha = alpha and alpha or 255
	draw.RoundedBox( round, x, y, w, h, Color(83,104,112, alpha) )
	draw.RoundedBox( round, x+1, y+1, w-2, h-2, Color(32,36,40, alpha) )
end

hook.Add("HUDPaint", "SRP_SaveZones.HUDPaint", function()
	if not SRP_SaveZones:PlayerInZone(LocalPlayer()) then return end
	if GetConVar("srp_hud_main") and GetConVar("srp_hud_main"):GetInt() == 0 then return end
	draw.SRPBackGround(8, ScrW()-250-10, 10, 250, 40)
	draw.SimpleText("Ты в безопасной зоне", "SRP_SaveZones.MainFont", ScrW()-125-10, 30, Color(114,179,114), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
end)
