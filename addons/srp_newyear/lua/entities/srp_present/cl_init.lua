include "shared.lua"

local markers = {}

ENT.RenderGroup = RENDERGROUP_BOTH

function newColor(name, col, bump)
	if bump then
		return CreateMaterial( 'srp_present_' .. name, 'VertexLitGeneric', {
			['$baseTexture'] = 'phoenix_storms/mat/mat_phx_metallic',
			['$bumpmap'] = 'phoenix_storms/mat/mat_phx_metallic_normal',
			['$surfaceprop'] = 'cardboard',
			['$color2'] = '[' .. (col.r / 255) .. ' ' .. (col.g / 255) .. ' ' .. (col.b / 255) .. ']',
		})
	else
		return CreateMaterial( 'srp_present_' .. name, 'VertexLitGeneric', {
			['$baseTexture'] = 'models/debug/debugwhite',
			['$envmap'] = 'engine/defaultcubemap',
			['$envmapsaturation'] = '0.1',
			['$envmaptint'] = '[0.25 0.25 0.25]',
			['$surfaceprop'] = 'cardboard',
			['$color2'] = '[' .. (col.r / 255) .. ' ' .. (col.g / 255) .. ' ' .. (col.b / 255) .. ']',
		})
	end
end

newColor('belt', Color(180,40,10))
local colors = {
	blue = Color(100,150,255),
	green = Color(150,255,100),
	yellow = Color(235,235,100),
	pink = Color(235,100,235),
}

for colName, col in pairs(colors) do
	newColor(colName, col, true)
end

function ENT:Initialize()

	self.emitter = ParticleEmitter( Vector() )

	timer.Simple(0.2, function()
		if not IsValid(self) then return end

		local colName = string.Explode( '_', self:GetSubMaterial(0) )
		colName = colName[#colName]
		self.col = colors[colName] or color_white

		for i = 1, 20 do
			local dir = VectorRand()
			local particle = self.emitter:Add("particle/fire", self:LocalToWorld(Vector(0,0,12)) + dir * 5)
			if particle then
				particle:SetColor(self.col.r, self.col.g, self.col.b)

				particle:SetVelocity(dir * (50 + math.random(0, 30)))
				particle:SetDieTime(math.random(5,10) / 2)
				particle:SetLifeTime(0)

				particle:SetAngles(AngleRand())
				particle:SetStartSize(5)
				particle:SetEndSize(0)

				particle:SetStartAlpha(255)
				particle:SetEndAlpha(0)

				particle:SetAirResistance(100)
				particle:SetCollide(true)
			end
		end

		self:EmitSound('garrysmod/balloon_pop_cute.wav')
	end)

end

ENT.shakesDone = 0
ENT.nextShake = 0
function ENT:Draw()

	if self.nextShake ~= 0 and CurTime() >= self.nextShake then
		local dir = VectorRand()
		local particle = self.emitter:Add("particle/fire", self:LocalToWorld(Vector(0,0,12)) + dir * 10)
		if particle then
			particle:SetColor(self.col.r, self.col.g, self.col.b)

			particle:SetVelocity(dir * (15 + math.random(0, 30)))
			particle:SetDieTime(math.random(5,10) / 5)
			particle:SetLifeTime(0)

			particle:SetAngles(AngleRand())
			particle:SetStartSize(3)
			particle:SetEndSize(0)

			particle:SetStartAlpha(255)
			particle:SetEndAlpha(0)

			particle:SetAirResistance(100)
			particle:SetCollide(true)
			particle:SetBounce(1)
			particle:SetGravity(Vector(0,0,-75))
		end

		self.nextShake = CurTime() + 0.025
	end

	self:DrawModel()

end

function ENT:OnRemove()

	self:EmitSound('ui/freeze_cam.wav', 75, 100, 1)
	self:EmitSound('garrysmod/save_load' .. math.random(1,4) .. '.wav', 75, 100, 1)

	local effectdata = EffectData()
	effectdata:SetOrigin( self:LocalToWorld(Vector(0,0,12)) )
	util.Effect( "GlassImpact", effectdata, true, true )

	for i = 1, 35 do
		local dir = VectorRand()
		local particle = self.emitter:Add("particle/fire", self:LocalToWorld(Vector(0,0,12)) + dir * 5)
		if particle then
			particle:SetColor(self.col.r, self.col.g, self.col.b)

			particle:SetVelocity(dir * (50 + math.random(0, 30)))
			particle:SetDieTime(math.random(5,10) / 2)
			particle:SetLifeTime(0)

			particle:SetAngles(AngleRand())
			particle:SetStartSize(5)
			particle:SetEndSize(0)

			particle:SetStartAlpha(255)
			particle:SetEndAlpha(0)

			particle:SetAirResistance(100)
			particle:SetCollide(true)
			particle:SetBounce(1)
			particle:SetGravity(Vector(0,0,-75))
		end
	end

	if self.rewardText then
		table.insert(markers, {
			text = self.rewardText,
			pos = self:LocalToWorld(Vector(0,0,12)),
			spawnTime = CurTime(),
			col = self.col
		})
	end

end

net.Receive('srp_present.open', function()

	local p = net.ReadEntity()
	local t = net.ReadString()
	if IsValid(p) then
		p.nextShake = CurTime()
		p.rewardText = t
	end

end)

surface.CreateFont("srp_present.reward", {
    font = "Roboto Bold",
	extended = true,
	size = 64,
	weight = 500,
})

hook.Add("PostDrawTranslucentRenderables", "srp_present", function()

	for k, v in pairs(markers) do
		local state = (CurTime() - v.spawnTime) / 4
		local al = 255 * math.min(4 - state * 4, 1)
		local ang = EyeAngles()
		ang.r, ang.p = 90, ang.r
		ang.y = ang.y - 90

		cam.Start3D2D(v.pos + state * Vector(0,0,10), ang, 0.1)
			surface.DisableClipping(true)
			draw.SimpleTextOutlined(v.text, 'srp_present.reward', 0, 0, Color(v.col.r, v.col.g, v.col.b, al), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 2, Color(0,0,0, al))
			surface.DisableClipping(false)
		cam.End3D2D()

		if state >= 1 then markers[k] = nil end
	end

end)
