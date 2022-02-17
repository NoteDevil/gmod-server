local command = {};

command.help    = "Set model for player.";
command.command   = "setmodel";
command.arguments = {"player", "model"};
command.permissions = "Set Model";
command.immunity  = SERVERGUARD.IMMUNITY.LESSOREQUAL;

function command:OnPlayerExecute(ply, target, arguments)
	target:SetModel(arguments[2])

  return true;
end;

-- function command:OnNotify(pPlayer, targets, arguments)
--   local amount = util.ToNumber(arguments[2]);

--   return SGPF("command_respawn", serverguard.player:GetName(pPlayer), util.GetNotifyListForTargets(targets), amount);
-- end;

function command:ContextMenu(pPlayer, menu, rankData)
  local option = menu:AddOption("Set Model", function()
    Derma_StringRequest("Set Model", "Write model path.", "", function(text)
			serverguard.command.Run("setmodel", false, pPlayer:Name(), text)
		end, function(text) end, "Accept", "Cancel") end) 
  
  option:SetImage("icon16/user_go.png");
end;

serverguard.command:Add(command);

local command = {};

command.help    = "Set model scale for player.";
command.command   = "scale";
command.arguments = {"player", "model"};
command.permissions = "Set Model Scale";
command.immunity  = SERVERGUARD.IMMUNITY.LESSOREQUAL;

function command:OnPlayerExecute(ply, target, arguments)
  local num = util.ToNumber(arguments[2])
  target:SetModelScale(num)

  return true;
end;

-- function command:OnNotify(pPlayer, targets, arguments)
--   local amount = util.ToNumber(arguments[2]);

--   return SGPF("command_respawn", serverguard.player:GetName(pPlayer), util.GetNotifyListForTargets(targets), amount);
-- end;

function command:ContextMenu(pPlayer, menu, rankData)
  local option = menu:AddOption("Set Model scale", function()
    Derma_StringRequest("Set Model scale", "Write model scale(default = 1).", "", function(text)
      serverguard.command.Run("scale", false, pPlayer:Name(), text)
    end, function(text) end, "Accept", "Cancel") end) 
  
  option:SetImage("icon16/user_go.png");
end;

serverguard.command:Add(command);


local command = {};

command.help    = "Teleport to player.";
command.command   = "tpr";
command.arguments = {"player"};
command.permissions = "SRP: VIP статус";
command.immunity  = SERVERGUARD.IMMUNITY.LESSOREQUAL;

function command:Execute(player, silent, arguments)
  local target = util.FindPlayer(arguments[1], player);
  serverguard.Notify( player, SERVERGUARD.NOTIFY.WHITE, " Вы отправили запрос игроку: ", SERVERGUARD.NOTIFY.GREEN, target:Name());
  serverguard.Notify( target, SERVERGUARD.NOTIFY.GREEN, player:Name(), SERVERGUARD.NOTIFY.WHITE, " Запросил телпорт к вам. Введите, чтобы принять: ", SERVERGUARD.NOTIFY.GREEN, "!tpa");
  target.TPRequest = player
  timer.Create("TPRequest"..target:EntIndex(), 30, 1, function()
    if IsValid(target) then
      target.TPRequest = nil
      serverguard.Notify( player, SERVERGUARD.NOTIFY.RED, "Время запроса на телепорт истекло.");
      serverguard.Notify( target, SERVERGUARD.NOTIFY.RED, "Время ответа на запрос истекло.");
    end
  end)
end;

serverguard.command:Add(command);

local command = {};

command.help    = "Accept teleport.";
command.command   = "tpa";

function command:Execute(player)
  if player.TPRequest then
    local requester = player.TPRequest
    local position = serverguard:playerSend(requester, player, true);

    if (position) then
      requester:SetPos(position);
      requester:SetEyeAngles(Angle(player:EyeAngles().pitch, player:EyeAngles().yaw, 0));

      timer.Destroy("TPRequest"..player:EntIndex())
      serverguard.Notify( requester, SERVERGUARD.NOTIFY.GREEN, "Вы успешно телепортировались.");
      player.TPRequest = nil      
      return true;
    else
      if (serverguard.requester:HasPermission(requester, "Noclip")) then
        requester:SetMoveType(MOVETYPE_NOCLIP);
        position = serverguard:requesterSend(requester, player, true);

        requester:SetPos(position);
        requester:SetEyeAngles(Angle(player:EyeAngles().pitch, player:EyeAngles().yaw, 0));

        timer.Destroy("TPRequest"..player:EntIndex())
        serverguard.Notify( requester, SERVERGUARD.NOTIFY.GREEN, "Вы успешно телепортировались.");
        player.TPRequest = nil
        return true;
      end;
      serverguard.Notify( requester, SERVERGUARD.NOTIFY.RED, "Игрок в недоступном месте.");
      serverguard.Notify( player, SERVERGUARD.NOTIFY.RED, "Телепорт к вас невозможен.");
    end;
  else
    serverguard.Notify( player, SERVERGUARD.NOTIFY.RED, "У вас нет запросов на телепорт.");
  end
end;

serverguard.command:Add(command);