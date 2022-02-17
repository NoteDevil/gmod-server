local EFF = {}

function EFF:Init(data)
	self.Orig = data:GetOrigin()
	
	self.Start = CurTime()
	self.Dur = 3.5
	
	self.Hue = math.random(0, 360)
end

function EFF:Think()
	return CurTime() < self.Start + self.Dur
end

function EFF:Render()
	render.SetMaterial(Material("icon16/music.png"))
--	render.SetMaterial(Material("materials/wyoziworld/sprites/ayylmao.png"))
	local elapsed = CurTime() - self.Start
	render.DrawSprite(self.Orig + Vector(math.sin(elapsed*2)*5, math.cos(elapsed*2)*5, 0) + Vector(0, 0, 1)*elapsed*27, 7, 7, HSVToColor(self.Hue, 0.5, 0.8))
end

effects.Register(EFF, "jukebox_note")