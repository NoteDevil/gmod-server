include "shared.lua"

local DPU = 5
local function scale( val )
	return math.Round( val / 5 * DPU )
end

function ENT:InitPanel( pnl, dpu )

	-- to be overriden

	local but = vgui.Create( "DButton", pnl )
	but:SetSize( 50, 30 )
	but:Center()

	but:SetText( "Test" )

end

function ENT:Initialize()

	vgui.MaxRange3D2D( 100 )

	local pnl = vgui.Create( "DPanel" )
	pnl:SetSize( scale(474), scale(474) )
	pnl:SetPos( 0, 0 )
	pnl:ParentToHUD()
	function pnl.Paint( self, w, h )
		draw.RoundedBox( 0, 0, 0, w, h, Color(32,36,40) )
	end

	self:InitPanel( pnl, DPU )
	pnl:Paint3D2D()
	self.panel = pnl

end

function ENT:OnRemove()

	self.panel:Remove()

end

function ENT:Draw()

	self:DrawModel()

	local dist = self:GetPos():DistToSqr( LocalPlayer():EyePos() )
	if dist < 90000 then
		local pos, ang = LocalToWorld( Vector(-47.5, 47.5, 1.6), Angle(0,0,0), self:GetPos(), self:GetAngles() )
		vgui.Start3D2D( pos, ang, 1 / DPU )
			surface.SetAlphaMultiplier( (90000 - dist) / 50000 )
			self.panel:Paint3D2D()
			self:DrawScreen()
			surface.SetAlphaMultiplier( 1 )
		vgui.End3D2D()
	end

end

function ENT:Think()
	
	if not IsValid(self.panel) then self:Initialize() end
	if not self.panel:IsVisible() then self.panel:SetVisible(true) end

	if LocalPlayer():KeyDown( IN_USE ) and LocalPlayer():GetEyeTrace().Entity == self then
		if not self.isDragging then
			local dist = LocalPlayer():GetEyeTrace().HitPos:DistToSqr( LocalPlayer():EyePos() )
			if dist > 10000 then return end

			local tr = LocalPlayer():GetEyeTrace()
			local relPos = self:WorldToLocal( tr.HitPos ) * DPU
			relPos.x = relPos.x + scale(237)
			relPos.y = -relPos.y + scale(237)

			self:DoClick( relPos )
			self.isDragging = true
		end
	else
		self.isDragging = false
	end

end

function ENT:DoClick( clickPos )

	self:MakeClickEffect( clickPos )
	self:EmitSound( "buttons/button17.wav" )

end

function ENT:DrawScreen()

	for k, v in pairs( self.clickEffects ) do
		local state = v.time + 1 - CurTime()

		local poly, radius = {}, math.pow( 1-state, 0.4 ) * 20
		for i = 1, 24 do
			poly[ i ] = { x = v.x + math.cos( math.pi / 12 * i ) * radius, y = v.y + math.sin( math.pi / 12 * i ) * radius }
		end

		draw.NoTexture()
		surface.SetDrawColor( 255,255,255, math.pow( state, 2 ) * 255 )
		surface.DrawPoly( poly )

		if state <= 0 then table.remove( self.clickEffects, k ) end
	end

	-- local tr = LocalPlayer():GetEyeTrace()
	-- local relPos = self:WorldToLocal( tr.HitPos ) * DPU
	-- draw.RoundedBox( 4, relPos.x - 4, relPos.y + 4, 8, 8, color_white )

end

ENT.clickEffects = {}
function ENT:MakeClickEffect( clickPos )

	table.insert( self.clickEffects, {
		time = CurTime(),
		x = clickPos.x,
		y = clickPos.y,
	})

end
