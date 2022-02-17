include("shared.lua")

net.Receive("NotePad.OpenMenu", function()

	local text = net.ReadString()
	local bOwner = net.ReadBool()
	local ent = net.ReadEntity()

	local owner = ent:Getowning_ent()

	local dframe = vgui.Create("DFrame")
	dframe:SetSize(400, 600)
	dframe:Center()
	dframe:MakePopup()
	dframe:SetTitle("Тетрадь - ".. ent:GetNWString('notepadName') .." (".. (IsValid(owner) and owner:Name() or "Владелец вышел") ..")")
	dframe.Paint = function(slf, w, h)
		draw.RoundedBox(0, 0, 0, w, h, Color(252, 67, 55))
	end

	dframe.OnClose = function(slf)
		net.Start("NotePad.SaveText")
		net.WriteString(string.Left(slf.dtextentry:GetValue(), 7500))
		net.WriteString(string.Left(slf.dnameentry:GetValue(), 40))
		net.WriteEntity(ent)
		net.SendToServer()
	end

	dframe.dnameentry = vgui.Create("DTextEntry", dframe)
	dframe.dnameentry:SetSize(dframe:GetWide()-10, 20)
	dframe.dnameentry:SetPos(5, 30)
	dframe.dnameentry:SetMultiline(false)
	dframe.dnameentry:SetValue(ent:GetNWString('notepadName'))
	if not bOwner then
		dframe.dnameentry:SetDisabled(true)
	else
		dframe.dnameentry:SetDisabled(false)
	end
	dframe.dnameentry.Paint = function(slf, w, h)
		draw.RoundedBox(0, 0, 0, w, h, color_white)

		surface.SetDrawColor(255, 96, 96, 255)
		surface.DrawLine(w - 30, 0, w - 30, h)
		surface.DrawLine(0, 19, w, 19)

		slf:DrawTextEntryText(Color(0, 0, 0), Color(30, 130, 255), Color(0, 0, 0))
	end

	dframe.dtextentry = vgui.Create("DTextEntry", dframe)
	dframe.dtextentry:SetSize(dframe:GetWide()-10, dframe:GetTall()-55)
	dframe.dtextentry:SetPos(5, 50)
	dframe.dtextentry:SetMultiline(true)
	dframe.dtextentry:SetValue(text)
	if not bOwner then
		dframe.dtextentry:SetDisabled(true)
	else
		dframe.dtextentry:SetDisabled(false)
	end
	dframe.dtextentry.Paint = function(slf, w, h)
		draw.RoundedBox(0, 0, 0, w, h, color_white)

		surface.SetDrawColor(255, 96, 96, 255)
		surface.DrawLine(w - 30, 0, w - 30, h)

		surface.SetDrawColor(96, 96, 255, 255)
		for i=14, h, 14 do
			surface.DrawLine(0, i, w, i)
		end
		slf:DrawTextEntryText(Color(0, 0, 0), Color(30, 130, 255), Color(0, 0, 0))
	end
	dframe.dtextentry.AllowInput = function(slf, value)
		local result = slf:GetValue()
		if string.len(slf:GetValue()) > 7500 then
			notification.AddLegacy( "В тетрадке больше нет места.", 1, 4 )
			surface.PlaySound( "buttons/button15.wav" )
			return true
		end
	end

end)

function ENT:Think()
	local owner = self:Getowning_ent()
	self.OverlayText = self:GetNWString('notepadName') .. " - <color=0,200,0>".. (IsValid(owner) and owner:Name() or "владелец вышел") .."</color> \nНажмите <color=0,200,0>".. srp_util.UseKey .."</color>, чтобы открыть"

	self:NextThink(CurTime() + 3)
	return true
end
