include("shared.lua")

ENT.RenderGroup = RENDERGROUP_BOTH

surface.CreateFont( "BlackBoard.MainFont", {
	font = "Comic Sans MS",
	size = 45,
	weight = 500,
	extended = true,
} )

surface.CreateFont( "BlackBoard.TxtEntFont", {
	font = "Comic Sans MS",
	size = 28,
	weight = 500,
	extended = true,
} )

function ENT:Initialize()
	self.OverlayText = "Школьная доска\nНажмите <color=0,200,0>".. srp_util.UseKey .."</color>, чтобы открыть"
end

function ENT:Draw()
	self:DrawModel()
	local dist = self:GetPos():DistToSqr( LocalPlayer():EyePos() )
  if dist < 250000 then
		local ang = self:GetAngles()
		
		ang:RotateAroundAxis( ang:Right(), -90)
		ang:RotateAroundAxis( ang:Up(), 90)
	 
		cam.Start3D2D( self:GetPos()+self:GetForward()+self:GetUp()*33, ang, 0.1 )
			local alpha = ((250000 - dist) / 50000)*255
			draw.DrawText(self:GetText(), "BlackBoard.MainFont", 0, 3, Color(255,255,255,alpha), 1, 0)
		cam.End3D2D()
	end
end

local bg = CreateMaterial( "blacboard_vgui", "UnlitGeneric", { ["$basetexture"] = "models/blackboard/blackboard_texture"} )
net.Receive("BlackBoard.OpenMenu", function()
	local ent = net.ReadEntity()
	local dframe
	if ValidPanel(dframe) then dframe:Remove() end
	
	dframe = vgui.Create("DFrame")
	dframe:SetSize(700, 400)
	dframe:Center()
	dframe:MakePopup()
	dframe:SetTitle("")
	dframe:ShowCloseButton(false)
	dframe.Paint = function(slf, w, h)
		surface.SetDrawColor(Color(50,50,50))
		surface.SetMaterial(bg)
		surface.DrawTexturedRect(0,0, w, h)
	end
	dframe.OnClose = function()
		net.Start("BlackBoard.SaveText")
		net.WriteEntity(ent)
		net.WriteString(dframe.txtent:GetValue())
		net.SendToServer()
	end

	dframe.close = vgui.Create("DButton", dframe)
	dframe.close:SetSize(15, 15)
	dframe.close:SetPos(dframe:GetWide()-15, 0)
	dframe.close:SetText("")
	dframe.close.Paint = function(slf, w, h)
		draw.SimpleText("X", "ChatFont", 0, 0, color_white, 0, 0)
	end
	dframe.close.DoClick = function(slf)
		dframe:Close()
	end

	dframe.txtent = vgui.Create("DTextEntry", dframe)
	dframe.txtent:SetSize(dframe:GetWide()-50, dframe:GetTall()-50)
	dframe.txtent:SetPos(25, 20)
	dframe.txtent:SetMultiline(true)
	dframe.txtent:SetValue(ent:GetText())
	dframe.txtent:SetFont("BlackBoard.TxtEntFont")
	dframe.txtent.Paint = function(slf, w, h)
		slf:DrawTextEntryText(color_white, Color(30, 130, 255), color_white)
	end
	dframe.txtent.AllowInput = function(slf, value)
		local result = string.Explode( "\n", slf:GetValue() )
		if #result > 12 then
			notification.AddLegacy( "На доске больше нет места.", 1, 4 )
			surface.PlaySound( "buttons/button15.wav" )
			return true
		else
			return false
		end
	end
	dframe.txtent.OnEnter = function(slf)
		net.Start("BlackBoard.SaveText")
		net.WriteEntity(ent)
		net.WriteString(slf:GetValue())
		net.SendToServer()
	end
end)