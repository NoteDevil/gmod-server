include("cl_frame.lua")

UPScoreboard = nil
UPMenu = nil

local function CreateScoreboard()
	if ( ScoreBoard ) then
		ScoreBoard:Remove()
		ScoreBoard = nil
	end
	UPScoreboard = vgui.Create( "F4MenuFrame" )
	DGF4.elements[1]["callBack"](UPScoreboard)
	return true
end

hook.Remove("ScoreboardShow", "FAdmin_scoreboard")
hook.Remove("ScoreboardHide", "FAdmin_scoreboard")

hook.Add("ScoreboardShow", "DGF4.ScoreboardShow", function()
	CreateScoreboard()

	GAMEMODE.ShowScoreboard = true
	gui.EnableScreenClicker( true )

	return true
end)

hook.Add("ScoreboardHide", "DGF4.ScoreboardHide", function()

	GAMEMODE.ShowScoreboard = false
	gui.EnableScreenClicker( false )

	if ValidPanel(UPScoreboard) then
		UPScoreboard:Close()
	end

	return true
end)

DarkRP.openF4Menu = nil
DarkRP.closeF4Menu = nil
DarkRP.toggleF4Menu = function() return end

local function OpenF4Menu()
	if ValidPanel(UPMenu) then UPMenu:Close() return end
	if GAMEMODE.ShowScoreboard then return end
	UPMenu = vgui.Create("F4MenuFrame")
end

local time = CurTime() + 1

hook.Add("Think", "GS_F4Menu.Think", function()
	if input.IsKeyDown(KEY_F4) and time <= CurTime() then
		time = CurTime() + 0.3
		OpenF4Menu()
	end
end)
