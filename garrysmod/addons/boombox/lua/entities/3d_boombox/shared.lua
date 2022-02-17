ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "BoomBox"
ENT.Category = "Fun + Games"
ENT.Author = "PxlCorp"
ENT.Spawnable = true

function ENT:SetupDataTables()
	self:NetworkVar("Entity", 1, "owning_ent")
	self:NetworkVar("Entity", 0, "Held")
	self:NetworkVar("Vector", 0, "SoundPos")
end