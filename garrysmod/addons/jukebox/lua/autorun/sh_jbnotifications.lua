jukebox = jukebox or {}
jukebox_NOTIFY = 1
jukebox_ERROR = 2

if SERVER then
    util.AddNetworkString("jukeboxMsg")
	function jukebox.ErrorMsg(ply, ...)
		net.Start("jukeboxMsg")
			net.WriteUInt(jukebox_ERROR,8)
			net.WriteTable({...})
		net.Send(ply)
	end
	
	function jukebox.Notify(ply, ...)
		net.Start("jukeboxMsg")
			net.WriteUInt(jukebox_NOTIFY,8)
			net.WriteTable({...})
		net.Send(ply)
	end
	
end

if CLIENT then
	net.Receive("jukeboxMsg",function()
		local type = net.ReadUInt(8)
		local things = net.ReadTable()
		if type == jukebox_ERROR then 
			chat.AddText(Color(255,150,0),"[ERROR] ", unpack(things))
			surface.PlaySound("common/wpn_denyselect.wav")
		elseif type == jukebox_NOTIFY then
			chat.AddText(Color(10,115,0),"[Jukebox] ",Color(255,255,255), unpack(things))
		end
		
	end)
	
	
	function jukebox.ErrorMsg(...)
	        print(...)
			chat.AddText(Color(255,150,0),"[ERROR] ", unpack({...}))
			surface.PlaySound("common/wpn_denyselect.wav")
	end
	
	function jukebox.Notify(...)
        chat.AddText(Color(10,115,0),"[Jukebox] ",Color(255,255,255), unpack({...}))
	end
	
	
end