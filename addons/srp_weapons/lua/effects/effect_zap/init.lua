
/*---------------------------------------------------------
	EFFECT:Init(data)
---------------------------------------------------------*/
function EFFECT:Init(data)
	
	self.WeaponEnt 		= data:GetEntity()
	self.Attachment 		= data:GetAttachment()
	
	self.Position 		= self:GetTracerShootPos(data:GetOrigin(), self.WeaponEnt, self.Attachment)
	self.Forward 		= data:GetNormal()
	self.Angle 			= self.Forward:Angle()
	self.Right 			= self.Angle:Right()
	self.Up 			= self.Angle:Up()
	
	if not IsValid(self.WeaponEnt) or not IsValid(self.WeaponEnt:GetOwner()) then return end
	
	local AddVel 		= self.WeaponEnt:GetOwner():GetVelocity()
	
	local emitter 		= ParticleEmitter(self.Position)

		for i = 1, 32 do
	
			local particle = emitter:Add("effects/yellowflare", self.Position)
		
				
		end

		local particle = emitter:Add("effects/yellowflare", self.Position + 8 * self.Forward)

			particle:SetVelocity(self.Forward + 1.1 * AddVel)
			particle:SetAirResistance(160)

			particle:SetDieTime(0.10)

			particle:SetStartAlpha(255)
			particle:SetEndAlpha(0)

			particle:SetStartSize(255)
			particle:SetEndSize(255)

			particle:SetRoll(math.Rand(380, 480))
			particle:SetRollDelta(math.Rand(-1, 1))

			particle:SetColor(255, 255, 255)	
			
			local particle = emitter:Add("effects/yellowflare", self.Position + 8 * self.Forward)

			particle:SetVelocity(self.Forward + 1.1 * AddVel)
			particle:SetAirResistance(160)

			particle:SetDieTime(0.10)

			particle:SetStartAlpha(255)
			particle:SetEndAlpha(0)

			particle:SetStartSize(255)
			particle:SetEndSize(255)

			particle:SetRoll(math.Rand(380, 480))
			particle:SetRollDelta(math.Rand(-1, 1))

			particle:SetColor(255, 255, 255)	

	emitter:Finish()
end

/*---------------------------------------------------------
	EFFECT:Think()
---------------------------------------------------------*/
function EFFECT:Think()

	return false
end

/*---------------------------------------------------------
	EFFECT:Render()
---------------------------------------------------------*/
function EFFECT:Render()
end
