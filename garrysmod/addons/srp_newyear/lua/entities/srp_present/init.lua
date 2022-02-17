AddCSLuaFile "cl_init.lua"
AddCSLuaFile "shared.lua"
include "shared.lua"

local colors = {
	'blue',
	'green',
	'yellow',
	'pink',
}

-- local p = ents.Create('srp_present')
-- p:SetPos(me:EyePos() + me:GetAimVector() * 40)
-- p:Spawn()

function ENT:Initialize()

	self:SetModel( "models/griim/christmas/present_colourable.mdl" )
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
	self:SetUseType( SIMPLE_USE )

	local phys = self:GetPhysicsObject()
	phys:Wake()

	local colName = colors[math.random(#colors)]
	self:SetSubMaterial(0, '!srp_present_' .. colName)
	self:SetSubMaterial(1, '!srp_present_belt')
	self:SetSubMaterial(2, '!srp_present_belt')

	-- clientside

	-- if not self.firstShakeTime then
	-- 	self.firstShakeAngle = self:GetAngles()
	-- 	self.firstShakePos = self:GetPos()
	-- 	self.firstShakeTime = CurTime()
	-- end

	-- local mag = (CurTime() - self.firstShakeTime)
	-- local ang = Angle(self.firstShakeAngle.p, self.firstShakeAngle.y, self.firstShakeAngle.r)
	-- ang:RotateAroundAxis(Vector(0,0,1), math.random(-2,2) * mag * 2)
	-- self:SetRenderAngles(ang)
	-- self:SetRenderOrigin(self.firstShakePos + Vector(math.random(-2,2) * mag / 10, math.random(-2,2) * mag / 10, 0))

end

ENT.firstShake = 0
function ENT:Think()

	if self.firstShake ~= 0 then
		local delta = CurTime() - self.firstShake

		local phys = self:GetPhysicsObject()
		if IsValid(phys) then
			phys:ApplyForceOffset((VectorRand() + Vector(0,0,0.8)) * (delta + 2) * 80, self:LocalToWorld(Vector(0,0,12) + VectorRand() * 5))
		end
		if math.random(3) == 3 then
			self:EmitSound('physics/cardboard/cardboard_box_impact_soft' .. math.random(1,7) .. '.wav', 75, 100, 1)
		end

		self:NextThink(CurTime() + 0.04)
		return true
	end

end

util.AddNetworkString 'srp_present.open'
ENT.nextUse = 0
function ENT:Use( ply )

	if CurTime() < self.nextUse then return end
	self.nextUse = CurTime() + 0.5

	if not IsValid(ply) or self.used then return end
	if IsValid(self.isFor) and self.isFor ~= ply then
		local phys = self:GetPhysicsObject()
		if IsValid(phys) then
			phys:ApplyForceCenter(Vector(0,0,350))
		end
		DarkRP.notify(ply, NOTIFY_ERROR, 3, 'Этот подарок не для тебя!')
		return
	end

	self.used = true
	self.firstShake = CurTime()

	local rewardText, rewardFunc = 'error', function(ply) DarkRP.notify(ply, NOTIFY_ERROR, 10, 'Произошла ошибка, напиши администраторам') end
	
	local chance = math.random(1,100)
	if chance > 50 then
		local amount = math.random(1,5)
		if chance == 100 then
			amount = math.random(1,3) * 100
			self:EmitSound('vo/npc/male01/hacks01.wav')
		end
		rewardText = '+'.. amount ..'$'
		rewardFunc = function(ply)
			ply:PS_GivePoints(amount)
			DarkRP.notifyAll(NOTIFY_CLEANUP, 10, '<color=50,200,50>' .. ply:Name() .. '</color> получил в подарок <color=50,200,50>' .. rewardText .. '</color>')
		end
	else
		local amount = math.random(1,10) * 1000
		rewardText = '+'.. amount ..'р.'
		rewardFunc = function(ply)
			ply:addMoney(amount)
			DarkRP.notifyAll(NOTIFY_CLEANUP, 10, '<color=50,200,50>' .. ply:Name() .. '</color> получил в подарок <color=50,200,50>' .. rewardText .. '</color>')
		end
	end

	net.Start('srp_present.open')
		net.WriteEntity(self)
		net.WriteString(rewardText)
	net.Broadcast()

	timer.Simple(1.5, function()
		self:Remove()
		
		if not IsValid(ply) then return end
		rewardFunc(ply)
		file.Append('srp_presents.txt', os.date('%H:%M:%S - ', os.time()) .. '(' .. ply:SteamID() .. ') ' .. rewardText .. '\n' )
	end)

end

hook.Add("GravGunPickupAllowed", "srp_present", function(ply, ent)

	if ent:GetClass() == 'srp_present' then
		return false
	end

end)
