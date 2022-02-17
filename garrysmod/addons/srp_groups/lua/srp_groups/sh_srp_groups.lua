SRP_Groups = SRP_Groups or {}

SRP_Groups.Limit = 8
SRP_Groups.GroupCost = 100
SRP_Groups.ExtendCost = 50

function SRP_Groups:GroupExists(name)
	return self.groups[name] and true or false
end

function SRP_Groups:IsGroupLeader(name, steamid)
	return self.groups[name].leader == steamid
end

function SRP_Groups:IsGroupMember(name, steamid)
	return self.groups[name].members[steamid] and true or false
end

function SRP_Groups:GetMemberRank(name, steamid)
	return self.groups[name].members[steamid]
end

function SRP_Groups:GetUserGroup(ply)
	return ply:GetNWString("SRPGroup")
end

function SRP_Groups:HasPermission(name, steamid, perm)
	return self:IsGroupLeader(name, steamid) and true 
		or self.groups[name].ranks[self:GetMemberRank(name, steamid)][perm]
end

function SRP_Groups:GetBankMoney(name)
	return self.groups[name].bank
end

if not CLIENT then return end

net.Receive("SRP_Groups.Sync", function()
	SRP_Groups.groups = net.ReadTable()
end)

-- hook.Add("HUDPaint", "SRP_Groups.HUDPaint", function()
-- 	draw.SimpleText(LocalPlayer():GetNWString("SRPGroup"), "DermaLarge", 5, ScrH()/2, color_white, 0, 1)
-- end)

hook.Add("PostDrawOpaqueRenderables","SRP_Groups.WallHack",function()
	-- if true then return end
	if not SRP_Groups or not SRP_Groups.groups then return end
	local group_tbl = SRP_Groups.groups[SRP_Groups:GetUserGroup(LocalPlayer())]
	if not group_tbl then return end

	if not group_tbl.settings.wallhack.cb then return end

	for k,_ in pairs(group_tbl.members) do
		local v = util.FindPlayer(k)
		if v == LocalPlayer() then continue end
		render.ClearStencil()
		if IsValid(v) then
			if not v:Alive() then continue end
			cam.Start3D()
				render.SetStencilEnable( true )
						cam.IgnoreZ( true )

						render.SetStencilWriteMask( 1 )
						render.SetStencilTestMask( 1 )
						render.SetStencilReferenceValue( 1 )
						
						render.SetStencilCompareFunction( STENCIL_ALWAYS )
						render.SetStencilPassOperation( STENCIL_REPLACE )
						render.SetStencilFailOperation( STENCIL_KEEP )
						render.SetStencilZFailOperation( STENCIL_KEEP )
						
						render.SetBlend(0)
						local wep = v:GetActiveWeapon()
						if IsValid(wep) and not wep:GetNoDraw() then
							wep:DrawModel()
						end
						if not v:GetNoDraw() then
							v:DrawModel()
						end
						render.SetBlend(1)

						render.SetStencilCompareFunction( STENCIL_EQUAL )
						render.SetStencilPassOperation( STENCIL_KEEP )
						cam.Start2D()
							surface.SetDrawColor( group_tbl.settings.wallhack.color )
							surface.DrawRect( 0, 0, ScrW(), ScrH() )
						cam.End2D()

					cam.IgnoreZ( false )
					local wep = v:GetActiveWeapon()
					if IsValid(wep) and not wep:GetNoDraw() then
						wep:DrawModel()
					end
					v:DrawModel()

				render.SetStencilEnable( false )
			cam.End3D()
		end
	end
end)
