local mats = {
    ['bully/dirt_01'] = 0,
    ['bully/floor_06'] = 0,
    ['bully/floor_07'] = 0,
    ['bully/floor_09'] = 0,
    ['bully/floor_10'] = 0,
    ['bully/grass_01'] = 1,
    ['bully/wall_17'] = 0,
    ['bully/wall_21'] = 0,
    ['bully/wall_24'] = 0,
    ['concrete/concreteceiling002a'] = 0,
    ['cs_havana/ground01grass'] = 1,
    ['de_nuke/nukroof01'] = 0,
    ['metal/metalroof005a'] = 0,
    ['props/rubberroof002a'] = 0,

    ['de_chateau/groundd_blend'] = 0,
    ['nature/blendgrassgravel001b'] = 0,
    ['nature/blendmilground005_2'] = 0,
    ['nature/blendmilground008_2_plants'] = 0,
    ['nature/blendmilground008b_2'] = 0,
}

hook.Add("Think", "srp_newyear", function()

    for mat, mode in pairs(mats) do
        local mat = Material(mat)
        -- mat:SetString('$surfaceprop', 'snow')
        mat:SetTexture('$basetexture', 'NATURE/SNOWFLOOR001A')
        if mat:GetTexture("$basetexture2") then -- hey maxmol ;) wanna steal it?
            mat:SetTexture("$basetexture2","NATURE/SNOWFLOOR001A")
        end
    end

    hook.Remove("Think", "srp_newyear")

end)
