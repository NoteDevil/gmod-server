local distance = CreateClientConVar("srp_ent_distance", "2500", true)

hook.Add("NetworkEntityCreated", "RenderModel", function(ent) 
	timer.Simple( 1, function() 
		if not IsValid(ent) then return end
		ent.RenderOverride = function(self) 
			if(EyePos():DistToSqr(self:GetPos()) <  distance:GetInt()^2 ) then 
				self:DrawModel()
			end
		end
	end)
end)