--[[
	pointshop/cl_init.lua
	first file included clientside.
]]--

include "sh_init.lua"
include "cl_player_extension.lua"

include "vgui/DPointShopMenu.lua"
include "vgui/DPointShopItem.lua"
include "vgui/DPointShopPreview.lua"
include "vgui/DPointShopColorChooser.lua"
include "vgui/DPointShopGivePoints.lua"

PS.ShopMenu = nil
PS.ClientsideModels = {}

PS.HoverModel = nil
PS.HoverModelClientsideModel = nil

local invalidplayeritems = {}

PS_ModelOffsets = PS_ModelOffsets or {}

function PS_SaveOffsets()

	file.CreateDir( "ps_offsets" )
	file.Write( "ps_offsets/data.dat", util.TableToJSON(PS_ModelOffsets) )

	chat.AddText( "Saved PS items to 'ps_offsets/data.dat'." )

end

function PS_LoadOffsets()

	if not file.Exists( "ps_offsets/data.dat", "DATA" ) then
		chat.AddText( "No 'ps_offsets/data.dat' file." )
		return
	end

	local data = file.Read( "ps_offsets/data.dat" )
	PS_ModelOffsets = util.JSONToTable( data )

	chat.AddText( "Loaded PS items from 'ps_offsets/data.dat'." )

end
concommand.Add( "ps_loadoffsets", PS_LoadOffsets )

net.Receive('PS_ModelOffsets', function( len )

	PS_ModelOffsets = net.ReadTable()

end)

concommand.Add( "ps_offseteditor", function()

	local mdl = LocalPlayer():GetModel()
	local data = PS_ModelOffsets[ mdl ]
	if not data then
		PS_ModelOffsets[ mdl ] = {
			face = { Vector( 0, 0, 0 ), 1 },
			hat = { Vector( 0, 0, 0 ), 1 },
			back = { Vector( 0, 0, 0 ), 1 },
			neck = { Vector( 0, 0, 0 ), 1 },
		}
		data = PS_ModelOffsets[ mdl ]
	end

	local w = vgui.Create( "DFrame" )
	w:SetTitle( "PS offset editor" )
	w:SetSize( 400, 600 )
	w:Center()
	w:MakePopup()

	for typeName, offsetData in pairs( data ) do
		local s1 = vgui.Create( "DNumSlider", w )
		s1:SetTall( 30 )
		s1:Dock( TOP )
		s1:SetText( typeName .. " x" )
		s1:SetMin( -10 )
		s1:SetMax( 10 )
		s1:SetDecimals( 2 )
		s1:SetValue( offsetData[1].x )
		function s1.OnValueChanged( self, val )
			offsetData[1].x = val
		end

		local s2 = vgui.Create( "DNumSlider", w )
		s2:SetTall( 30 )
		s2:Dock( TOP )
		s2:SetText( typeName .. " y" )
		s2:SetMin( -10 )
		s2:SetMax( 10 )
		s2:SetDecimals( 2 )
		s2:SetValue( offsetData[1].y )
		function s2.OnValueChanged( self, val )
			offsetData[1].y = val
		end

		local s3 = vgui.Create( "DNumSlider", w )
		s3:SetTall( 30 )
		s3:Dock( TOP )
		s3:SetText( typeName .. " z" )
		s3:SetMin( -10 )
		s3:SetMax( 10 )
		s3:SetDecimals( 2 )
		s3:SetValue( offsetData[1].z )
		function s3.OnValueChanged( self, val )
			offsetData[1].z = val
		end

		local s4 = vgui.Create( "DNumSlider", w )
		s4:SetTall( 30 )
		s4:Dock( TOP )
		s4:SetText( "scale" )
		s4:SetMin( 0.05 )
		s4:SetMax( 3 )
		s4:SetDecimals( 2 )
		s4:SetValue( offsetData[2] )
		function s4.OnValueChanged( self, val )
			offsetData[2] = val
		end
	end

	local save = vgui.Create( "DButton", w )
	save:SetText( "Save" )
	save:SetTall( 30 )
	save:Dock( BOTTOM )
	save.DoClick = PS_SaveOffsets

end)

-- menu stuff

function PS:ToggleMenu()
	if not PS.ShopMenu then
		PS.ShopMenu = vgui.Create('DPointShopMenu')
		PS.ShopMenu:SetVisible(false)
	end

	if PS.ShopMenu:IsVisible() then
		PS.ShopMenu:Hide()
		gui.EnableScreenClicker(false)
	else
		PS.ShopMenu:Show()
		PS.ShopMenu.openedTime = SysTime()
		gui.EnableScreenClicker(true)
	end
end

function PS:SetHoverItem(item_id)
	local ITEM = PS.Items[item_id]

	if ITEM.Model then
		self.HoverModel = item_id

		self.HoverModelClientsideModel = ClientsideModel(ITEM.Model, RENDERGROUP_OPAQUE)
		self.HoverModelClientsideModel:SetNoDraw(true)
	end
end

function PS:RemoveHoverItem()
	self.HoverModel = nil
	self.HoverModelClientsideModel = nil
end

-- modification stuff

function PS:ShowColorChooser(item, modifications)
	-- TODO: Do this
	local chooser = vgui.Create('DPointShopColorChooser')
	chooser:SetColor(modifications.color)

	chooser.OnChoose = function(color)
		modifications.color = color
		self:SendModifications(item.ID, modifications)
	end
end

function PS:SendModifications(item_id, modifications)
	net.Start('PS_ModifyItem')
		net.WriteString(item_id)
		net.WriteTable(modifications)
	net.SendToServer()
end

-- net hooks

net.Receive('PS_ReloadMenu', function( len, ply )
	if PS.ShopMenu then
		PS.ShopMenu:Remove()
		PS.ShopMenu = vgui.Create('DPointShopMenu')
		PS.ShopMenu:SetVisible(true)
	end
end)

net.Receive('PS_ToggleMenu', function(length)
	PS:ToggleMenu()
end)

net.Receive('PS_Items', function(length)
	local ply = net.ReadEntity()
	local items = net.ReadTable()
	ply.PS_Items = PS:ValidateItems(items)
end)

net.Receive('PS_Points', function(length)
	local ply = net.ReadEntity()
	local points = net.ReadInt(32)
	ply.PS_Points = PS:ValidatePoints(points)
end)

net.Receive('PS_AddClientsideModel', function(length)
	local ply = net.ReadEntity()
	local item_id = net.ReadString()

	if not IsValid(ply) then
		if not invalidplayeritems[ply] then
			invalidplayeritems[ply] = {}
		end

		table.insert(invalidplayeritems[ply], item_id)
		return
	end

	ply:PS_AddClientsideModel(item_id)
end)

net.Receive('PS_RemoveClientsideModel', function(length)
	local ply = net.ReadEntity()
	local item_id = net.ReadString()

	if not ply or not IsValid(ply) or not ply:IsPlayer() then return end

	ply:PS_RemoveClientsideModel(item_id)
end)

net.Receive('PS_SendClientsideModels', function(length)
	local itms = net.ReadTable()

	for ply, items in pairs(itms) do
		if not IsValid(ply) then -- skip if the player isn't valid yet and add them to the table to sort out later
			invalidplayeritems[ply] = items
			continue
		end

		for _, item_id in pairs(items) do
			if PS.Items[item_id] then
				ply:PS_AddClientsideModel(item_id)
			end
		end
	end
end)

net.Receive('PS_SendNotification', function(length)
	local str = net.ReadString()
	notification.AddLegacy(str, NOTIFY_GENERIC, 5)
end)

net.Receive('PS_UpdateSlots', function(length)
	LocalPlayer().PS_Slots = net.ReadTable()
end)

-- hooks

hook.Add('Think', 'PS_Think', function()
	for ply, items in pairs(invalidplayeritems) do
		if IsValid(ply) then
			for _, item_id in pairs(items) do
				if PS.Items[item_id] then
					ply:PS_AddClientsideModel(item_id)
				end
			end

			invalidplayeritems[ply] = nil
		end
	end
end)

hook.Add('PostDrawOpaqueRenderables', 'PS_PostPlayerDraw', function()
	for k, ply in pairs( player.GetAll() ) do
		local plyBody = ply
		if not ply:Alive() then
			plyBody = ply:GetNWEntity("DeathRagdoll")
			if not IsValid( plyBody ) then continue end
		end
		if IsValid(ply:GetNWEntity("ScriptedVehicle")) and IsValid(ply:GetNWEntity("OnSkate")) then
			plyBody = ply:GetNWEntity("OnSkate")
		end

		if plyBody == LocalPlayer() and ply:Alive() and not hook.Run( "ShouldDrawLocalPlayer", ply ) then continue end
		if ply == LocalPlayer() and PS.ShopMenu and PS.ShopMenu:IsVisible() then continue end
		if LocalPlayer():GetObserverMode() == OBS_MODE_IN_EYE and LocalPlayer():GetObserverTarget() == ply then continue end
		if plyBody:GetNoDraw() then continue end

		if not PS.ClientsideModels[ply] then continue end
		for item_id, model in pairs(PS.ClientsideModels[ply]) do
			if not PS.Items[item_id] then PS.ClientsideModel[ply][item_id] = nil continue end

			local ITEM = PS.Items[item_id]

			if not ITEM.Attachment and not ITEM.Bone then PS.ClientsideModel[ply][item_id] = nil continue end
			if plyBody == LocalPlayer() and ITEM.NoLocalPlayer and not hook.Run( "ShouldDrawLocalPlayer", ply ) then continue end

			local pos = Vector()
			local ang = Angle()

			if ITEM.Attachment then
				local attach_id = plyBody:LookupAttachment(ITEM.Attachment)
				if not attach_id then continue end

				local attach = plyBody:GetAttachment(attach_id)

				if not attach then continue end

				pos = attach.Pos
				ang = attach.Ang
			else
				local bone_id = plyBody:LookupBone(ITEM.Bone)
				if not bone_id then continue end

				pos, ang = plyBody:GetBonePosition(bone_id)
			end

			local scale, scaleMod = 1
			if plyBody:GetModelScale() ~= 1 then
				scale = scale * plyBody:GetModelScale()
			end

			local oldpos, oldang = pos, Angle(ang.p, ang.y, ang.r)
			model, pos, ang, scaleMod = ITEM:ModifyClientsideModel(plyBody, model, pos, ang)

			local off = pos - oldpos
			pos = oldpos + (off) * scale

			local plyModel = plyBody:GetModel()
			if PS_ModelOffsets[plyModel] and PS_ModelOffsets[plyModel][ ITEM.OffsetType ] then
				local offset = PS_ModelOffsets[ plyModel ][ ITEM.OffsetType ]
				scale = scale * offset[2]
				pos = pos + (oldang:Right() * offset[1].x + oldang:Forward() * offset[1].y + oldang:Up() * offset[1].z) * scale
			end

			-- model:SetPos(pos)
			-- model:SetAngles(ang)
			if scaleMod then scale = scale * scaleMod end
			model:SetModelScale( scale )

			model:SetRenderOrigin( pos )
			model:SetRenderAngles(ang)
			model:SetupBones()
			model:DrawModel()
			model:SetRenderOrigin()
			model:SetRenderAngles()
		end
	end
end)
