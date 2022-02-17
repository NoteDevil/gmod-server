surface.CreateFont("DoorsTitles.TitleFont", {
	font = "Cambria",
	size = 72,
	weight = 600,
	italic = true,
	extended = true,
})

SRP_Doors = SRP_Doors or ""

net.Receive("DoorsTitles.SendDoorTable", function()
	SRP_Doors = net.ReadTable() 
end) 

hook.Add("PostDrawOpaqueRenderables", "DoorsTitles.PostDrawOpaqueRenderables", function()
	if not SRP_Doors then return end
	if not istable(SRP_Doors) then return end
	for _, door in ipairs(SRP_Doors) do
		local ent = ents.GetByIndex(door.id)
		if not IsValid(ent) then return end
		if ent:GetPos():Distance(LocalPlayer():GetPos()) < 700 then
			
			local Ang = ent:GetAngles()
			local pos = ent:GetPos()
			Ang:RotateAroundAxis( Ang:Forward(), 90)
			if door.inverted then
				Ang:RotateAroundAxis( Ang:Right(), 90)
				pos = pos+ent:GetForward()*-1.3+ent:GetRight()*-24+ent:GetUp()*40
			else
				Ang:RotateAroundAxis( Ang:Right(), 270)
				pos = pos+ent:GetForward()*1.3+ent:GetRight()*-24+ent:GetUp()*40
			end
		
			cam.Start3D2D(pos, Ang, 0.1)
				draw.RoundedBox(0, -210, 0, 420, 80, color_white)
				draw.SimpleText(door.text, "DoorsTitles.TitleFont", 0, 35, Color(0,0,0), 1, 1)
			cam.End3D2D()
		end
	end
end)