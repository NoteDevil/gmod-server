include("shared.lua")



local curCameraPos = Vector(0,0,0)
local curCameraAngle = Angle(0,0,0)


local uPos = Vector(0,0,0)
local uAng = Angle(0,0,0)

local blinker = false
local blinkerTime = CurTime()
local start = CurTime()
function ENT:Initialize()
	self.useCamera = false
	self.uPos = self:GetPos()
	self.uAng = self:GetAngles():Normalize()
	self.cameraInit = false
	hook.Add('CalcView', 'viewcalculatormanolis'..self:EntIndex(), function(ply,pos,angles,fov)
		if(self.useCamera) then
			if(!self.cameraInit) then 
				curCameraPos = pos
				curCameraAngle = angles
				self.cameraInit = true
			end

			local xPos = self.uPos 

			local aAng = self.uAng:Right():Angle():Right():Angle()
			aAng:RotateAroundAxis(aAng:Up(),-90)
		

			curCameraPos = LerpVector(FrameTime(), curCameraPos,xPos)
			curCameraAngle = LerpAngle(FrameTime(), curCameraAngle, aAng)

			local view = {}
			view.origin = curCameraPos-(curCameraAngle:Forward()*18) // Forward Back Higher is back
			view.origin = view.origin+curCameraAngle:Up()*2 // Up / Down
			view.angles = curCameraAngle

			if(curCameraPos:Distance(xPos) < .4) then
				if(blinker) then
					net.Start('startedUsingHackingTerminal')
						net.WriteEntity(self)
					net.SendToServer()

					self.useCamera = false
				end
			end


			return view
		end
	end)

end


function ENT:Draw()
	self.uPos = self:GetPos()
	self.uAng = self:GetAngles()

	self:DrawModel()

	local Pos = self.uPos
	local Ang = self.uAng

	local owner = self:Getowning_ent()
	owner = (IsValid(owner) and owner:Nick()) or DarkRP.getPhrase("unknown")

	surface.SetFont("HUDNumber5")
	local text = DarkRP.getPhrase("money_printer")
	local TextWidth = surface.GetTextSize(text)
	local TextWidth2 = surface.GetTextSize(owner)
	Ang:RotateAroundAxis(Ang:Forward(),90)
	Ang:RotateAroundAxis(Ang:Right(),270)
	Ang:RotateAroundAxis(Ang:Forward(), -4.5)
	cam.Start3D2D(Pos +Ang:Forward() * 11.5 + Ang:Up()*12.6, Ang, 0.11)
		surface.SetDrawColor(0,0,0,255)
		surface.DrawRect(-200,-100,190,170)
		if(blinker) then
			surface.SetDrawColor(0,255,0,255)
			surface.DrawRect(-200+(25),-80,5,5)
		end
	cam.End3D2D()
	blinkerTime = CurTime()
	if(blinkerTime-start > .5) then
		blinkerTime = CurTime()
		start = CurTime()
		if(blinker) then blinker=false 
		else blinker = true end
	end

end


function ENT:UseCam()
	self.useCamera = true
	self.cameraInit = false
end

function enableCamera()

end






