local logo = Material( "school666/logo-transparent-512.png", "noclamp smooth" )
hook.Add("HUDPaint", "SRPWaterMark.HUDPaint", function()
	local ply = LocalPlayer()
	if not ply then return end
	if not IsValid(ply:GetActiveWeapon()) then return end
	if ply:GetActiveWeapon():GetClass() != "gmod_camera" then return end
	surface.SetDrawColor(255,255,255)
	surface.SetMaterial(logo)
	surface.DrawTexturedRect( ScrW()-200, 10, 150, 150 )
end)