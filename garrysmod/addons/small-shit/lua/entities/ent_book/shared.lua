ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "Book"
ENT.Author = "roni_sl"
ENT.Category = "SRP"
ENT.Spawnable = true

function ENT:SetupDataTables()
	self:NetworkVar("String", 0, "Title")
  self:NetworkVar("String", 1, "Link")
end