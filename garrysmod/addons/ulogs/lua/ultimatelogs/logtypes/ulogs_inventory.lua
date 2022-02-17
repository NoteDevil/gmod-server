--[[
    
     _   _  _  _    _                    _           _                        
    | | | || || |  (_)                  | |         | |                       
    | | | || || |_  _  _ __ ___    __ _ | |_   ___  | |      ___    __ _  ___ 
    | | | || || __|| || '_ ` _ \  / _` || __| / _ \ | |     / _ \  / _` |/ __|
    | |_| || || |_ | || | | | | || (_| || |_ |  __/ | |____| (_) || (_| |\__ \
     \___/ |_| \__||_||_| |_| |_| \__,_| \__| \___| \_____/ \___/  \__, ||___/
                                                                    __/ |     
                                                                   |___/      
    
    
]]--





local INDEX = 88
local GM = 0

ULogs.AddLogType( INDEX, GM, "Inventory", function( ply, ent )
	
	if !ply or !ply:IsValid() or !ply:IsPlayer() then return end
	if !ent or !ent:IsValid() then return end
	
	local Informations = {}
	local Base = ULogs.RegisterBase( ply )
	local Data = {}
	Data[ 1 ] = ply:Name()
	Data[ 2 ] = {}
	table.Add( Data[ 2 ], Base )
	table.insert( Informations, Data )
	
	return Informations
	
end)

if SERVER then
	hook.Add( "SRP_Inv.OnItemDrop", "ULogs_SRP_Inv", function( ply, ent )
		
		if ply and ply:IsValid() and ply:IsPlayer() and ent and ent:IsValid() then
			ULogs.AddLog( INDEX, ULogs.PlayerInfo( ply ) .. " dropped " .. tostring(ent),
				ULogs.Register( INDEX, ply, ent ) )
		end
		
	end)

	hook.Add( "SRP_Inv.OnItemPickup", "ULogs_SRP_Inv", function( ply, ent )
		
		if ply and ply:IsValid() and ply:IsPlayer() and ent and ent:IsValid() then
			ULogs.AddLog( INDEX, ULogs.PlayerInfo( ply ) .. " picked up " .. tostring(ent),
				ULogs.Register( INDEX, ply, ent ) )
		end
		
	end)
end
