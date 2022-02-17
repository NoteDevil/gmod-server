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





local INDEX = 28
local GM = 5

ULogs.AddLogType( INDEX, GM, "Serverguard", function( text )
	
	if !text or !isstring(text) then return end
	
	local Informations = {}
	table.insert( Informations, { "Copy message", text } )
	
	return Informations
	
end)

hook.Add( "serverguard.Notify", "ULogs_sg_command", function( text )
	
	if !SERVER then return end
	if !text or !isstring(text) then return end
	
	ULogs.AddLog( INDEX, text,
		ULogs.Register( INDEX, text ) )
	
end)
