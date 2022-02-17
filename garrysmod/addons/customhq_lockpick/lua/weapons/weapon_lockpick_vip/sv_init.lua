
	
	 function SWEP:CreateLockpicks()
		if not IsValid(self.lockpick1) then
			self.lockpick1 = ents.Create('prop_dynamic')
			self.lockpick1:SetModel("models/custom/lockpick1.mdl")
			self.lockpick1:Spawn()
			
			self.lockpick2 = ents.Create('prop_dynamic')
			self.lockpick2:SetModel("models/custom/lockpick2.mdl")
			self.lockpick2:Spawn()
			
			self.lockpick1:SetSolid(0)
			self.lockpick2:SetSolid(0)
			
			self.lockpick1:SetColor(Color(0,0,0,0))
			self.lockpick2:SetColor(Color(0,0,0,0))
	
			self.lockpick2:SetModelScale(0.7,0)
		end
	end
	
	function SWEP:RemoveLockpick()
		if IsValid(self.lockpick1) then
			self.lockpick1:Remove()
			self.lockpick2:Remove()
			self.Doors = nil
			self.LastNumber = 999
			self.NeedValue = 999
			self.OpenDoor = false
		end
	end


	function SWEP:MakeSoundCombo()
		if self.LastSoundCombo + 0.7 < CurTime() then
			self.LastSoundCombo = CurTime()
			self.Owner:EmitSound("weapons/357/357_reload4.wav", 100, 100)
		end
	end

	function SWEP:MakeSound()
		if self.LastSound + 0.5 < CurTime() then
			self.LastSound = CurTime()
			local snd = {1,3}
			self.Owner:EmitSound("weapons/357/357_reload".. tostring(snd[math.random(1, #snd)]) ..".wav", 100, 100,0.6)
			
		end
	end



function SWEP:Think()
	if SERVER then

		if self.IsLockPicking or self.EndPick then 

		local trace = self.Owner:GetEyeTrace()
		if not IsValid(trace.Entity) or trace.Entity ~= self.LockPickEnt or trace.HitPos:Distance(self.Owner:GetShootPos()) > 100 then
			self:Fail()
		elseif self.EndPick <= CurTime() then
			self:Succeed()
		end
		
		end

	
	
		if not IsValid(self.lockpick1) then return end
		if self.LastUsed2 + 1.2 > CurTime() then return end
		local ent = self.Doors
		
		
		
		if IsValid(ent) and ent:GetClass() == "prop_door_rotating" and IsValid(self.Owner) and self.Owner:IsPlayer() and self.Owner:Alive() and ent:GetPos():Distance(self.Owner:GetPos())<100 then 			
			local p = self.Owner:GetForward().x
			local y = self.Owner:GetForward().y
			local r = self.Owner:GetForward().z
			local p1,y1,r1 = p,y,r
			if p < 0 then p1 = p*-1 end
			if y < 0 then y1 = y*-1 end
			if r < 0 then r1 = r*-1 end
			
			local res = 0;
			if p1 > y1 then 
				res = p 
				y = 0
				r = 0
			else
				res = y
				p = 0
				r = 0 
			end
			
			local res1 = res
			if res<0 then res1 = res*-1 end
			
			if r1 > res1 then 
				res = r 
				p = 0 
				y = 0 
			end
			
			self.lockpick1:SetPos(ent.HaveLock:GetPos()+self.Owner:GetAngles():Right()*0.1  +Vector(p,y,r)*-1.3+Vector(0,0,0.8))
			self.lockpick2:SetPos(ent.HaveLock:GetPos()+self.Owner:GetAngles():Right()*-0.2	 +Vector(p,y,r)*-1.8+Vector(0,0,0.85))

			
			local modul = 1
			if p!=0 then
				if p<0 then modul = -1 end
			else
				if y<0 then modul = -1 end
			end
			
			
			local x1 = 0
			local x2 = 90
			local x3 = -90
			local x4 = 180
			local f = self.Owner:GetAngles().y
			local res = 0
			
			
			if 90 > f-30 or (f+30 > 90 and f+30< 140) then
				res = 90
			end
			if f>-50 and f<50 then
				res = 0 
			end
			if f<-50 then 
				res = -90
			end
			if math.abs(f) > 150 then
				res = 180
			end

			local sel = res - f
			if sel > 300 then sel = sel - 360 end
			sel = sel*5
			sel = math.Clamp(sel,-20,20)
			
		
			if sel != self.LastNumber then
				self:MakeSound()
				self.LastNumber = sel
				self.OpenDoor = false
				local fsel = sel
				local easy = self.HowEasy
				if fsel - easy < self.NeedValue and self.NeedValue < fsel + easy then
					self:MakeSoundCombo()
					self.OpenDoor = true
				end
			end
			
		
			
		local sel2 = math.abs(sel)-30
		if self.lockpick1:GetParent() == NULL then
			self.lockpick1:SetAngles(Angle(0,180+res,-sel)) 
			self.lockpick2:SetAngles(Angle(-90,90+res,0))
			
		end
			
		if self.Owner:GetEyeTrace().Entity != ent then
			self:RemoveLockpick()
		end

		else
			self:RemoveLockpick()
		end
	end
end