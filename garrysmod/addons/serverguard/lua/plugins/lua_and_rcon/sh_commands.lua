local plugin = plugin;

local command = {};

command.help        = "Run Lua code.";
command.command       = "lua";
command.arguments     = {"code"};
command.permissions     = "Lua and RCON";

function command:Execute(player, silent, arguments)

  local code = table.concat( arguments, " " )
  
  if ( #code > 0 ) then
    ME = player
    THIS = player:GetEyeTrace().Entity
    PLAYER = function( nick ) return util.FindPlayer(nick, player) end

    local f = CompileString( code, "" )
    if ( !f ) then
      serverguard.Notify( player, SERVERGUARD.NOTIFY.RED, "Syntax error! Check your script!");
      return
    end
    
    local status, err = pcall( f )
    
    if ( status && !silent ) then
      serverguard.Notify( nil, SERVERGUARD.NOTIFY.GREEN, serverguard.player:GetName(player), SERVERGUARD.NOTIFY.WHITE, " ran Lua code: ", SERVERGUARD.NOTIFY.RED, code);
    else
      serverguard.Notify( player, SERVERGUARD.NOTIFY.RED, string.sub( err, 5 ));
    end
    
    THIS, ME, PLAYER = nil
  else
    serverguard.Notify( player, SERVERGUARD.NOTIFY.RED, "No code specified.");
  end

end;
plugin:AddCommand(command);

local command = {};

command.help        = "Run RCON command.";
command.command       = "rcon";
command.arguments     = {"command"};
command.permissions     = "Lua and RCON";

function command:Execute(player, silent, arguments)
  if ( #arguments > 0 ) then
    RunConsoleCommand( unpack( arguments ) )
    if (!silent) then
      serverguard.Notify( nil, SERVERGUARD.NOTIFY.GREEN, serverguard.player:GetName(player), SERVERGUARD.NOTIFY.WHITE, " ran RCON command: ", SERVERGUARD.NOTIFY.RED, string.Implode(arguments));
    end
  else
    serverguard.Notify( player, SERVERGUARD.NOTIFY.RED, "No command specified.");
  end
end;
plugin:AddCommand(command);

