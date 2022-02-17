ITEM.Name = 'Призрак-песик'
ITEM.Price = 0
ITEM.Model = 'models/roblox/ghost_puppy.mdl'
ITEM.Skin = 1
ITEM.Attachment = 'chest'
ITEM.Slots = {'companion'}
ITEM.Hidden = true

function ITEM:CanPlayerBuy(ply)
	return false, "Этот предмет из ограниченной серии"
end

function ITEM:CanPlayerSell(ply)
	return false, "Этот предмет из ограниченной серии"
end

function ITEM:OnEquip(ply, modifications)
	ply:PS_AddClientsideModel(self.ID)
end

function ITEM:OnHolster(ply)
	ply:PS_RemoveClientsideModel(self.ID)
end

function ITEM:ModifyClientsideModel(ply, model, pos, ang)
	local plyPos, plyAng = ply:EyePos(), ply:EyeAngles()
	plyAng.y = plyAng.y + 180
	plyAng.p = plyAng.p * 0.2
	ply.compPos = LocalToWorld( Vector(20, -16 + math.sin(CurTime() * 2 + 1.57) * 2, math.sin(CurTime()) * 8), Angle(), plyPos, plyAng )
	ply.compPosLast = ply.compPosLast or ply.compPos

	local dir = ply.compPos - ply.compPosLast
	ply.compPosLast = ply.compPosLast + dir * math.min(1, FrameTime())
	

	return model, ply.compPosLast, plyAng
end
