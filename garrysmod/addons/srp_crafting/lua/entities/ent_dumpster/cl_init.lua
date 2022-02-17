include("shared.lua")
local over_time, start_time 
net.Receive("SRP_Dumpster.StartSearching", function()
	local delay = net.ReadFloat()
	start_time = CurTime()
	over_time = start_time + delay
end)

net.Receive("SRP_Dumpster.StopSearching", function()
	start_time = nil
	over_time = nil
end)

local w, h = 400, 50
local scr_w, scr_h = ScrW(), ScrH()

hook.Add("HUDPaint", "SRP_Dumpster.ProgressBar", function()
	if start_time then
		draw.RoundedBox(0, (scr_w-w)/2, (scr_h-h)/2+50, w, h, Color(0,0,0,150))
		draw.RoundedBox(0, (scr_w-w)/2, (scr_h-h)/2+50, w*(CurTime()-start_time)/(over_time-start_time), h, Color(255,249,149))
	end
end)

function ENT:Initialize()
	self.OverlayText = "Мусорка\nНажмите <color=0,200,0>".. srp_util.UseKey .."</color>, чтобы использовать"
end