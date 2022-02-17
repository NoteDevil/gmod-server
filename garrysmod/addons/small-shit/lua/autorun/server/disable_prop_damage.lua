local function DisablePropDamage( ent, dmg )

    if ent:IsPlayer() and dmg:IsDamageType( DMG_CRUSH ) then
        dmg:ScaleDamage( 0 )
    end

end
hook.Add( "EntityTakeDamage", "DisablePropDamage", DisablePropDamage )
