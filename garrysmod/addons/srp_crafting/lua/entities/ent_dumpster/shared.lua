ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "Dumpster"
ENT.Author = "roni_sl"
ENT.Category = "SRP_Crafting"
ENT.Spawnable = true

function ENT:SetupDataTables()
    self:NetworkVar("Bool", 0, "InUse")
end