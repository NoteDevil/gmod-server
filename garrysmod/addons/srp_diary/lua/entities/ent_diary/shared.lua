ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "Diary"
ENT.Author = "roni_sl"
ENT.Category = ""
ENT.Spawnable = false

function ENT:SetupDataTables()
    self:NetworkVar("Entity", 0, "owning_ent")
end