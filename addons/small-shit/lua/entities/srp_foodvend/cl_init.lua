include "shared.lua"

local food = {
    "100г арахиса",
    "Пончик",
    "Коробка пончиков",
    "Молоко",
    "Бутеры",
}

-- uhhh, falco, why?
for k, v in pairs( food ) do
    for k2,v2 in pairs( FoodItems ) do
        if v == v2.name then
            food[k] = v2
        end
    end
end

function ENT:Initialize()

	vgui.MaxRange3D2D( 100 )

	local pnl = vgui.Create( "DPanel" )
	pnl:SetSize( 390, 500 )
	pnl:SetPos( 0, 0 )
	pnl:ParentToHUD()
	function pnl.Paint( self, w, h )
		draw.RoundedBox( 4, 0, 0, w, h, Color(83,104,112) )
		draw.RoundedBox( 4, 1, 1, w-2, h-2, Color(32,36,40) )
    end
    
    for i,v in ipairs( food ) do
        local p = vgui.Create( "DButton", pnl )
		p:SetSize( 350, 60 )
		p:SetPos( 0, (i-1) * 100 + 20  )
		p:CenterHorizontal()
		p:SetText("")
		p.Paint = function( self, w, h )
			surface.DisableClipping( true )

			local highlight = false
			local y, col = -3, Color(83,104,112)
			if self.Depressed then
				y = -2
			elseif self.Hovered then
				y = -5
				highlight = true
			end

			draw.RoundedBox( 4, 0, 0, w, h, col )
			draw.RoundedBox( 4, 0, 0, w, h, Color(0,0,0, 100) )
			draw.RoundedBox( 4, 0, y, w, h, col )

			if highlight then
				draw.RoundedBox( 4, 0, y, w, h, Color(255,255,255, 10) )
			end

            local cost = v.price * 3
			draw.SimpleText( v.name, "list_ClassName", 10, h / 2 + y, Color(255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
			draw.SimpleText( cost .. "р.", "list_ClassTime", w - 10, h / 2 + y, Color(255,255,255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER )

			surface.DisableClipping( false )
		end
		p.DoClick = function( selfPnl )
            net.Start( "SRP_FoodVend.Buy" )
                net.WriteEntity( self )
                net.WriteString( v.name )
            net.SendToServer()
		end
    end

	pnl:Paint3D2D()
	self.panel = pnl

end

function ENT:OnRemove()

    if IsValid( self.panel ) then self.panel:Remove() end

end

function ENT:Draw()

    self:DrawModel()
    if not IsValid( self.panel ) then return end
	if not self.panel:IsVisible() then self.panel:SetVisible(true) end

	local dist = self:GetPos():DistToSqr( LocalPlayer():EyePos() )
	if dist < 90000 then
		local pos, ang = LocalToWorld( Vector( 21, -24, 40 ), Angle(0,90,90), self:GetPos(), self:GetAngles() )
		vgui.Start3D2D( pos, ang, 0.1 )
			surface.SetAlphaMultiplier( (90000 - dist) / 50000 )
            self.panel:Paint3D2D()
            self:DrawScreen()
			surface.SetAlphaMultiplier( 1 )
		vgui.End3D2D()
	end

end

function ENT:Think()
	
	if not IsValid(self.panel) then self:Initialize() end

	if LocalPlayer():KeyDown( IN_USE ) and LocalPlayer():GetEyeTrace().Entity == self then
		if not self.isDragging then
			local dist = LocalPlayer():GetEyeTrace().HitPos:DistToSqr( LocalPlayer():EyePos() )
			if dist > 10000 then return end

			local tr = LocalPlayer():GetEyeTrace()
			local relPos = self:WorldToLocal( tr.HitPos ) * 10
			relPos.y = relPos.y + 237
			relPos.z = relPos.z - 400

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
	-- local relPos = self:WorldToLocal( tr.HitPos ) * 10
	-- draw.RoundedBox( 4, relPos.x - 4, relPos.y + 4, 8, 8, color_white )

end

ENT.clickEffects = {}
function ENT:MakeClickEffect( clickPos )

	table.insert( self.clickEffects, {
		time = CurTime(),
		x = clickPos.y,
		y = -clickPos.z,
	})

end
