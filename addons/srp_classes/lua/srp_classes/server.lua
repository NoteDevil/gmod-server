local curEvent = 1
SetGlobalInt( "SRP_Class", curEvent )

timer.Create( "SRP_Classes", 1, 0, function()

	local time = AtmosGlobal:GetTime()
	SetGlobalFloat( "SRP_Time", time )

	local newEvent = 1
	for i, v in ipairs( srp_classes.events ) do
		if v[1] > time then break end
		if v[1] > srp_classes.events[newEvent][1] then
			newEvent = i
		end
	end

	if newEvent ~= curEvent then
		SetGlobalInt( "SRP_Class", newEvent )
		curEvent = newEvent
	end

end)

util.AddNetworkString "srp_classes.updateClassInfo"
function srp_classes.updateClassInfo( ply )

	net.Start( "srp_classes.updateClassInfo" )
		net.WriteTable( srp_classes.schedule )
	net.Broadcast()

	SetGlobalInt( "SRP_Class", 1 )
	SetGlobalInt( "SRP_Class", curEvent ) -- help garry at sending globals to new players

end
hook.Add( "PlayerIsLoaded", "srp_classes", srp_classes.updateClassInfo )

util.AddNetworkString "srp_classes.setClassInfo"
net.Receive( "srp_classes.setClassInfo", function( len, ply )

	if not ply:CanEditSchedule() then return end

	local classID, class = net.ReadUInt(8), net.ReadUInt(8)
	class = SRP_Diary.Subjects[ class ] or "Нет урока"
	srp_classes.setClassInfo( classID, class )

	DarkRP.notifyAll(NOTIFY_GENERIC, 10, 'Изменения в расписании: ' .. classID .. ' урок - ' .. class )

end)
