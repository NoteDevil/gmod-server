local PANEL = {}

function PANEL:Init()
	self:SetModel(LocalPlayer():GetModel())
	self.Entity:SetSkin(LocalPlayer():GetSkin())
	self:SetFOV(40)

	local PrevMins, PrevMaxs = self.Entity:GetRenderBounds()
	self:SetCamPos(PrevMins:Distance(PrevMaxs) * Vector(0.30, 0.30, 0.25) + Vector(0, 0, 15))
	self:SetLookAt((PrevMaxs + PrevMins) / 2)
end

function PANEL:Paint( w, h )
	if ( !IsValid( self.Entity ) ) then return end

	local ITEM = PS.Items[item_id]

	local x, y = self:LocalToScreen( 0, 0 )

	self:LayoutEntity( self.Entity )

	local ang = self.aLookAngle
	if ( !ang ) then
		ang = (self.vLookatPos-self.vCamPos):Angle()
	end

	local w, h = self:GetSize()
	cam.Start3D( self.vCamPos, ang, self.fFOV, x, y, w, h, 5, 4096 )
	cam.IgnoreZ( true )

	render.SuppressEngineLighting( true )
	render.SetLightingOrigin( self.Entity:GetPos() )
	render.ResetModelLighting( self.colAmbientLight.r/255, self.colAmbientLight.g/255, self.colAmbientLight.b/255 )
	render.SetColorModulation( self.colColor.r/255, self.colColor.g/255, self.colColor.b/255 )
	render.SetBlend( self.colColor.a/255 )

	for i=0, 6 do
		local col = self.DirectionalLight[ i ]
		if ( col ) then
			render.SetModelLighting( i, col.r/255, col.g/255, col.b/255 )
		end
	end

	local curCat = PS:FindCategoryByName( PS.curCategory )
	if not curcat or not curCat.NoPlayer or PS.HoverModel then
		self.Entity:DrawModel()
	end

	self:DrawOtherModels()

	render.SuppressEngineLighting( false )
	cam.IgnoreZ( false )
	cam.End3D()

	self.LastPaint = RealTime()
end

local function FindEqualSlots(item1, item2)
	item1 = PS.Items[item1]
	item2 = PS.Items[item2]
	if item1.Slots and item2.Slots then
		for k,v in pairs(item1.Slots) do
			for j,z in pairs(item2.Slots) do
				if v == z then
					return true
				end
			end
		end
	end
	return false
end

function PANEL:DrawOtherModels()
	local ply = LocalPlayer()

	if PS.ClientsideModels[ply] then
		for item_id, model in pairs(PS.ClientsideModels[ply]) do
			local ITEM = PS.Items[item_id]

			if not ITEM.Attachment and not ITEM.Bone then PS.ClientsideModel[ply][item_id] = nil continue end

			local pos = Vector()
			local ang = Angle()

			if ITEM.Attachment then
				local attach_id = self.Entity:LookupAttachment(ITEM.Attachment)
				if not attach_id then return end

				local attach = self.Entity:GetAttachment(attach_id)

				if not attach then return end

				pos = attach.Pos
				ang = attach.Ang
			else
				local bone_id = self.Entity:LookupBone(ITEM.Bone)
				if not bone_id then return end

				pos, ang = self.Entity:GetBonePosition(bone_id)
			end

			local scale, scaleMod = 1

			local oldpos, oldang = pos, Angle(ang.p, ang.y, ang.r)
			model, pos, ang, scaleMod = ITEM:ModifyClientsideModel(ply, model, pos, ang)

			local off = pos - oldpos
			pos = oldpos + (off) * scale

			local plyModel = ply:GetModel()
			if PS_ModelOffsets[plyModel] and PS_ModelOffsets[plyModel][ ITEM.OffsetType ] then
				local offset = PS_ModelOffsets[ plyModel ][ ITEM.OffsetType ]
				scale = scale * offset[2]
				pos = pos + (oldang:Right() * offset[1].x + oldang:Forward() * offset[1].y + oldang:Up() * offset[1].z) * scale
			end

			model:SetPos(pos)
			model:SetAngles(ang)
			if scaleMod then scale = scale * scaleMod end
			model:SetModelScale( scale )

			if PS.HoverModel then
				if not FindEqualSlots(PS.HoverModel, item_id) then
					model:DrawModel()
				else
					model:SetNoDraw(true)
				end
			else
				model:DrawModel()
			end
		end
	end

	if PS.HoverModel then
		local ITEM = PS.Items[PS.HoverModel]

		if ITEM.NoPreview then return end -- don't show
		if ITEM.WeaponClass and not ITEM.Model then return end -- hack for weapons WHY!?

		if not ITEM.Attachment and not ITEM.Bone then -- must be a playermodel?
			if ITEM.Models then
				local amount = #ITEM.Models
				local curID = math.ceil( CurTime() * 2 ) % amount + 1
				self:SetModel( ITEM.Models[curID][1] )
				self.Entity:SetSkin( ITEM.Models[curID][2] )
			else
				self:SetModel(ITEM.Model)
				if ITEM.Skin then self.Entity:SetSkin(ITEM.Skin) end
			end
		else
			local model = PS.HoverModelClientsideModel

			local pos = Vector()
			local ang = Angle()

			if ITEM.Attachment then
				local attach_id = self.Entity:LookupAttachment(ITEM.Attachment)
				if not attach_id then return end

				local attach = self.Entity:GetAttachment(attach_id)

				if not attach then return end

				pos = attach.Pos
				ang = attach.Ang
			else
				local bone_id = self.Entity:LookupBone(ITEM.Bone)
				if not bone_id then return end

				pos, ang = self.Entity:GetBonePosition(bone_id)
			end

			local scale, scaleMod = 1

			local oldpos, oldang = pos, Angle(ang.p, ang.y, ang.r)
			model, pos, ang, scaleMod = ITEM:ModifyClientsideModel(ply, model, pos, ang)

			local off = pos - oldpos
			pos = oldpos + (off) * scale

			local plyModel = ply:GetModel()
			if PS_ModelOffsets[plyModel] and PS_ModelOffsets[plyModel][ ITEM.OffsetType ] then
				local offset = PS_ModelOffsets[ plyModel ][ ITEM.OffsetType ]
				scale = scale * offset[2]
				pos = pos + (oldang:Right() * offset[1].x + oldang:Forward() * offset[1].y + oldang:Up() * offset[1].z) * scale
			end

			if ITEM.Skin then model:SetSkin(ITEM.Skin) end

			model:SetPos(pos)
			model:SetAngles(ang)
			if scaleMod then scale = scale * scaleMod end
			model:SetModelScale( scale )

			model:DrawModel()
		end
	else
		self:SetModel(LocalPlayer():GetModel())
		self.Entity:SetSkin(LocalPlayer():GetSkin())
	end
end

vgui.Register('DPointShopPreview', PANEL, 'DModelPanel')
