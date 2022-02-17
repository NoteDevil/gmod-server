hook.Add("canDemote", "srp_no_demote", function(ply, target, reason)

    for i,v in ipairs(player.GetAll()) do
        if v:IsAdmin() then return false, "Для этого на сервере есть администраторы!\nОткрой жалобу через <color=50,200,50>@ текст</color>" end 
    end

end)