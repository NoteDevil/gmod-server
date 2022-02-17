ENT.Type        		= "anim"
ENT.Base        		= "base_anim"
ENT.PrintName   		= "Blackboard Sign"
ENT.Author      		= "roni_sl"
ENT.Category				= "SRP"
ENT.Spawnable				= true
ENT.AdminSpawnable	= true

function ENT:SetupDataTables()
    self:NetworkVar("String", 0, "Text")
end