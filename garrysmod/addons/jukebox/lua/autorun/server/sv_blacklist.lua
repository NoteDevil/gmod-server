if not file.Exists("jukebox","DATA") then
	file.CreateDir("jukebox")
end

if not file.Exists("jukebox/blacklist.txt","DATA") then
	file.Write("jukebox/blacklist.txt","")
end

util.AddNetworkString("Jukeban")

net.Receive("Jukeban",function(len,ply)
	local ctype = net.ReadUInt(8)
	local strarg = net.ReadString()
	if not ply:IsSuperAdmin() then msg.ErrorMsg(ply,"Superadmin function only!") return end
	
	if ctype == 1 then
		file.Append("jukebox/blacklist.txt",strarg.." \n")
		jukebox.Notify(ply,"URL '"..strarg.."' succesfully blacklisted!")
	elseif ctype == 2 then
		util.SetPData(strarg,"JukeBan","true")
		jukebox.Notify(ply,"SteamID '"..strarg.."' succesfully banned!")
	elseif ctype == 3 then
		util.SetPData(strarg,"JukeBan","false")
		jukebox.Notify(ply,"SteamID '"..strarg.."' succesfully unbanned!")
	end
end)
