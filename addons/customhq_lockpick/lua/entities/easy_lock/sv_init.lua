function ENT:Initialize()
	self.Owner = self:Getowning_ent()
	self.Parented = false
	self:SetModel("models/custom/dlock.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	local phys = self:GetPhysicsObject()
	phys:Wake()
	phys:SetMass(50)
	--self:SetMaterial('models/player/shared/gold_player')
	self:SetModelScale(0.7,0)
	self.Locked = false
	self:SetColor(self.Color)
end


 
 
 function ENT:AnimOpen()
	local id = self:LookupSequence("open")
	self:ResetSequence(id)
 end
 
 function ENT:AnimClose()
	local id = self:LookupSequence("close")
	self:ResetSequence(id)
 end
 
 function ENT:AnimFail()
	local id = self:LookupSequence("fail")
	self:ResetSequence(id)
 end 
 
 
 function ENT:ParentTo(ent,magick,breaking)
	if IsValid(ent) and ent:GetClass() == "prop_door_rotating" then
		local doorData = ent:getDoorData()
		if not magick and not doorData.owner then if breaking then self:Remove() end return end		
		if not magick and doorData.owner != self.Owner:UserID()  then if breaking then self:Remove() end return end
		if IsValid(ent.HaveLock) then return end 
			
		if magick then self.Magick = true end
		self:SetMoveType(0)
		self:SetPos(ent:GetPos()+ent:GetRight()*-43)
		self:SetAngles(ent:GetAngles())
		self:SetParent(ent)
		self:SetNotSolid(true)
		self.Parented = true
		self.Door = ent
		ent.HaveLock = self
		ent.SecretValue =  math.random(-18,18)
	end
 
 
 end


function ENT:StartTouch(ent) 
 self:ParentTo(ent)
end

		
 
 
function ENT:Think()		
		if not IsValid(self.Owner) then self:Remove() end
		if not self.Parented then self:NextThink(CurTime()+1) return true end
		if not self.Door then self:Remove() end
		local doorData = self.Door:getDoorData()
		if not self.Magick and doorData.owner == nil then self:Remove() end
		
		if self.Door:isLocked() and !self.Locked then
			self.Locked = true
			self:AnimClose()
		end
		
		if not self.Door:isLocked() and self.Locked then
			self.Locked = false
			self:AnimOpen()
		end
	
	self:NextThink(CurTime()+0.12);  return true;
end
 
 