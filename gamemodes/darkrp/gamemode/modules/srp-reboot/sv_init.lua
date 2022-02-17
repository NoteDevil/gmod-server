local temp = os.date("*t") -- get current day
temp.hour = 5 -- restart is at 5 am
temp.min = 0 -- restart is at 5 am
local restartTime = os.time( temp )
if temp.hour >= 5 and temp.min >= 0 then -- if launched after 5am, then restart tomorrow
	restartTime = restartTime + (24*60*60) -- set it to next day the same time
end

-- check if it's time
local nextCheck = CurTime()
local minutesLeft = 15
local function restart()
	if CurTime() < nextCheck then return end
	nextCheck = CurTime() + 1

	local timeLeft = restartTime - os.time()
	if timeLeft < minutesLeft * 60 then
		local txt = "Сервер перезагрузится через ".. minutesLeft .." мин."
		print( "[#] " .. txt )
		DarkRP.notifyAll( NOTIFY_ERROR, 10, txt )
		minutesLeft = minutesLeft - 1
	end

	if timeLeft < 1 then
		local txt = "Вот-вот перезагрузимся..."
		print( "[#] " .. txt )
		DarkRP.notifyAll( 4, 6, txt )
	end
end
hook.Add("Tick", "srp.reboot", restart)
