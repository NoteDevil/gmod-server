SRP_SaveZones = SRP_SaveZones or {}

SRP_SaveZones.zones = {
	{ 
		min = Vector('-2540.709229 -4359.469727 -15'),
		max = Vector('-1880.031250 -4024.313232 175.213745'),
	},
	{ 
		min = Vector('1064.133545 -5683.436035 -15'),
		max = Vector('1724.968750 -5348.055664 175.399658'),
	},
}

function SRP_SaveZones:VectorInZone(vecCheck, vecMin, vecMax)
	local bOutBounds = false
	if vecCheck.x >= vecMin.x and vecCheck.x <= vecMax.x then else
		bOutBounds = true
	end

	if vecCheck.y >= vecMin.y and vecCheck.y <= vecMax.y then else
		bOutBounds = true
	end
	
	if vecCheck.z >= vecMin.z and vecCheck.z <= vecMax.z then else
		bOutBounds = true
	end

	return not bOutBounds
end

function SRP_SaveZones:PlayerInZone(ply)
	for k,v in pairs(SRP_SaveZones.zones) do
		if self:VectorInZone(ply:GetPos(), v.min, v.max) then
			return true
		end
	end
	return false
end