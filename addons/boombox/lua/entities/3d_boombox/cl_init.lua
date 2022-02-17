include("shared.lua")

local VolumeCV = CreateClientConVar("boombox_volume","1",true,false,"Changes the max volume of the boombox (Between 0 and 1, going beyond is useless)")

function ENT:Initialize()
	self:SetRenderBounds(Vector(-16384,-16384,-16384),Vector(16384,16384,16384))
end

function ENT:OnRemove()
	if IsValid(self.audio) then
		self.audio:Stop()
	end
end

local function tryget(url,callback,tries)
	sound.PlayURL ( url, "3d noblock noplay", function(data)
		if IsValid(data) then
			callback(data)
		else
			if tries>1 then
				print("Failed, retrying...")
				tryget(url,callback,tries-1)
			else
				callback(nil)
			end
		end
	end)
end

local ExistingAudios = {}

local lastcheck = CurTime()
hook.Add("Think","Boombox.Think",function()
	if CurTime()-lastcheck>1 then
		for ent,audio in pairs(ExistingAudios) do
			if not IsValid(ent) and IsValid(audio) then
				audio:Stop()
				ExistingAudios[ent] = nil
			end
			if IsValid(audio) and IsValid(ent) then
				local dists = ent:GetSoundPos():DistToSqr(LocalPlayer():EyePos())
				if dists>BOOMBOX.config.FarDistance^2*1.1 and CurTime()-(ent.lastupdate or 0)>2 then
					audio:SetVolume(0)
				end
				if IsValid(ent:GetHeld()) and IsValid(ent:GetHeld():GetParent()) and CurTime()-(ent.lastupdate or 0)>2 then
					if ent:GetHeld():GetParent()~=LocalPlayer() or LocalPlayer():ShouldDrawLocalPlayer() then
						audio:SetPos(ent:GetHeld():GetParent():EyePos(),ent:GetForward())
					else
						audio:SetPos(LocalPlayer():EyePos()+LocalPlayer():EyeAngles():Forward()*20,-LocalPlayer():EyeAngles():Forward())
					end
				end
			end
		end
		lastcheck = CurTime()
	end
end)

function ENT:Play(data,autoplay,time)
	self.volume = self.volume or 1
	if not autoplay then
		self.shouldplay = {time,0}
	end
	if self.mdata and data.ref==self.mdata.ref then
		if IsValid(self.audio) then
			if autoplay then 
				self.audio:Stop()
			else
				self.audio:Play()
			end
			return
		end
	end
	self.loading = true
	if data.mediatype == 1 then
		tryget(data.ref, function(streamdata)
			if IsValid(streamdata) and self.loading then
				ExistingAudios[self] = streamdata
				self.error = nil
				self.loading = nil
				streamdata:SetPos(self:GetPos())
				if self.shouldplay then
					streamdata:Play()
					streamdata:SetTime(CurTime() - (self.shouldplay[1] or CurTime())+self.shouldplay[2])
					self.shouldplay = nil
				end
				streamdata:SetVolume(self.volume * math.Clamp(VolumeCV:GetFloat(),0,1))
				streamdata:Set3DCone(180,360,0.3)
				streamdata:Set3DFadeDistance(BOOMBOX.config.FarDistance or 800,0)
				self.audio = streamdata
				self.mdata = data
			else
				self.loading = nil
				self.error = true
			end
		end,3)
	else
		if BOOMBOX.interface.loaddata then
			BOOMBOX.interface.loaddata(data,function(source)
				if IsValid(source) and self.loading then
					ExistingAudios[self] = source
					self.error = nil
					self.loading = nil
					source:SetPos(self:GetPos())
					if self.shouldplay then
						source:Play()
						source:SetTime(CurTime() - (self.shouldplay[1] or CurTime())+self.shouldplay[2])
						self.shouldplay = nil
					end
					source:SetVolume(self.volume * math.Clamp(VolumeCV:GetFloat(),0,1))
					source:Set3DCone(180,360,0.3)
					source:Set3DFadeDistance(BOOMBOX.config.FarDistance or 800,0)
					self.audio = source
					self.mdata = data
				else
					self.loading = nil
					self.error = true
				end
			end)
		end
	end

end

function ENT:Draw()
	self:DrawModel()
end

hook.Add("PostDrawOpaqueRenderables","Boombox.PostDrawOpaqueRenderables",function()
for _,self in ipairs(ents.FindByClass("3d_boombox")) do

	local opos,oang = self:LocalToWorld(Vector(0)),self:LocalToWorldAngles(Angle(0,0,0))
	if IsValid(self:GetHeld()) and IsValid(self:GetHeld():GetParent()) then
		local owner = self:GetHeld()
		local bone = owner:GetParent():LookupBone("ValveBiped.Bip01_R_Forearm")
		if bone then
			local pos,ang = owner:GetParent():GetBonePosition(bone)
			local npos,nang = LocalToWorld(Vector(10,-6,0),Angle(0,-90,-90),pos,ang)
			
			opos = npos
			oang = nang
		else
			opos = owner:GetPos()
			oang = owner:GetAngles()
		end
		self:DrawShadow(false)
	else
		self:DrawShadow(true)
	end
	self:SetRenderOrigin(opos)
	self:SetRenderAngles(oang)

	self:DrawModel()

	if EyePos():DistToSqr(opos)>BOOMBOX.config.RenderDistance^2 then continue end

	local np,na = LocalToWorld(Vector(4.14,0.28,1),Angle(0,90,90),opos,oang)

	cam.Start3D2D( np, na, 0.01 )

		BOOMBOX.interface.preview(self,690,370)

	cam.End3D2D()

end
end)

function ENT:Think()
	if IsValid(self.audio) then
		if self.volume then
			local startpos = self:GetPos()
			if IsValid(self:GetHeld()) and IsValid(self:GetHeld():GetParent()) then 
				startpos = self:GetHeld():GetParent():EyePos()
			end
			local dsqr = startpos:DistToSqr(LocalPlayer():GetPos())
			local mins,maxs = BOOMBOX.config.CloseDistance^2,BOOMBOX.config.FarDistance^2

			if dsqr<maxs then
				local tr = util.TraceLine({start=startpos,endpos=LocalPlayer():EyePos(),mask=MASK_SHOT_HULL,filter={self,LocalPlayer()}})
				local submerged = self:WaterLevel()
				local fact = self:WaterLevel()>0 and 0.125 or 1
				fact = LocalPlayer():WaterLevel()>2 and fact/8 or fact
				if tr.Hit then fact = 0.3 end
				fact = fact * math.Clamp(VolumeCV:GetFloat(),0,1)
				if dsqr>mins then
					self.audio:SetVolume(self.volume*(1-(dsqr-mins)/(maxs-mins))*fact)
				else
					self.audio:SetVolume(self.volume*fact)
				end
			else
				self.audio:SetVolume(0)
			end
		end
		if IsValid(self:GetHeld()) and IsValid(self:GetHeld():GetParent()) then
			if self:GetHeld():GetParent()~=LocalPlayer() or LocalPlayer():ShouldDrawLocalPlayer() then
				self.audio:SetPos(self:GetHeld():GetParent():EyePos(),self:GetForward())
			else
				self.audio:SetPos(LocalPlayer():EyePos()+LocalPlayer():EyeAngles():Forward()*20,-LocalPlayer():EyeAngles():Forward())
			end
		else
			self.audio:SetPos(self:GetPos(),self:GetForward())
		end
		self.lastupdate = CurTime()
	end
end

net.Receive("boombox_data",function(len)
	local e = net.ReadEntity()
	local mode = net.ReadInt(32)

	if IsValid(e) then
		if mode==1 then --Command
			local cmd = net.ReadInt(32)
			if cmd==1 then
				local time = net.ReadFloat()
				local load = net.ReadBool()
				local mdata = net.ReadTable()
				e:Play(mdata,load,time)
			elseif cmd==2 then
				if IsValid(e.audio) then
					e.audio:Play()
				else
					e.shouldplay = {net.ReadFloat(),net.ReadFloat()}
				end
			elseif cmd==3 then
				if IsValid(e.audio) then
					e.audio:Pause()
				end
			elseif cmd==4 then
				if IsValid(e.audio) then
					e.audio:Stop()
				end
			elseif cmd==5 then
				local t = net.ReadFloat()
				if IsValid(e.audio) then
					e.audio:SetTime(e.audio:GetLength()*t)
					e.audio:Play()
				end
			elseif cmd==6 then
				local t = net.ReadFloat()
				if IsValid(e.audio) then
					e.volume = t
					e.audio:SetVolume(t * math.Clamp(VolumeCV:GetFloat(),0,1))
				end
			end
		end
		
		if mode==3 then
			BOOMBOX.interface.opengui(e)
		end

	end
end)

hook.Add("CalcViewModelView","Boombox.CalcViewModelView",function(wep, vm, opos, oang, pos, ang)
	if not IsValid(LocalPlayer():GetActiveWeapon()) then return end
    if LocalPlayer():GetActiveWeapon():GetClass()=="hold_boombox" then
        return Vector(-100,0,0),Angle(0,0,0)
    end
end)