if !DGF4.RegisterButton then return end

local icons = {}
local function updateIcons()
	for rank, data in pairs(serverguard.ranks.stored) do
		icons[rank] = Material(data.texture)
	end
end
hook.Add("PlayerIsLoaded", "DarkGlowF4", updateIcons)

local function convert_rank_to_img(ply)
	-- if DGF4.Scoreboard.AdminIcons[ply:GetUserGroup()] then
	-- 	return Material("icon16/"..DGF4.Scoreboard.AdminIcons[ply:GetUserGroup()]..".png")
	-- end
	
	-- return Material("icon16/"..DGF4.Scoreboard.AdminIcons["user"]..".png")
	
	local icon = icons[ply:GetUserGroup()]
	if not icon then
		updateIcons()
		return convert_rank_to_img(ply)
	end

	return icon
end

local function sort_callback( a, b )
	return( a:Team( ) > b:Team( ) );
end

local function playTime(time)

	local h, m, s
	h = math.floor(time / 60 / 60)
	m = math.floor(time / 60) % 60
	s = math.floor(time) % 60

	return string.format("%02i:%02i:%02i", h, m, s)

end

local scoreboard = {}
scoreboard.pos = 99
scoreboard.name = DGF4.Translation.scoreboard
scoreboard.col = Color(255,36,0)
scoreboard.wide = ScrW() - 400
scoreboard.callBack = function(self)
	local x, y, ply = ScrW(), ScrH(), LocalPlayer()
	local base = DGF4.BaseElement(self, scoreboard.name, scoreboard.col, scoreboard.wide)
	/* --- BASE END --- */

	base.Paint = function(self, w, h)
		draw.SimpleText(GetHostName().." ("..#player.GetAll().."/"..game.MaxPlayers()..")", "HeaderMenu", 5, 5, Color(200, 200, 200), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
	end

	base["playerScrollPanel"] = vgui.Create( "DScrollPanel", base )
	base["playerScrollPanel"]:SetSize( scoreboard.wide, base:GetTall() - 70 )
	base["playerScrollPanel"]:SetPos( 0, 50 )

	local vbar = base["playerScrollPanel"]:GetVBar()
	vbar.Paint = function( self, w, h )	end
	vbar.btnGrip.Paint = function( self, w, h )
		local extend = vbar:IsChildHovered() or self.Depressed
		draw.RoundedBox( extend and 4 or 2, extend and 0 or w/2-2, 0, extend and w or 4, h, Color(83,104,112) )
	end
	vbar.btnUp.Paint = function( self, w, h )	end
	vbar.btnDown.Paint = function( self, w, h )	end


	base["listofplayers"] = vgui.Create( "DIconLayout", base["playerScrollPanel"] )
	base["listofplayers"]:SetSize(base["playerScrollPanel"]:GetWide(), base["playerScrollPanel"]:GetTall() )
	base["listofplayers"]:SetPos( 5, 5 )
	base["listofplayers"]:SetSpaceY( 5 )
	base["listofplayers"]:SetSpaceX( 5 )

	local players = player.GetAll()
	table.sort( players, sort_callback );

	for k,v in pairs(players) do
		if not IsValid(v) then continue end

		base["panelplayer"..k] = base["listofplayers"]:Add( "DPanel" )
		base["panelplayer"..k]:SetSize( scoreboard.wide-30, 30 )
		base["panelplayer"..k].Paint = function(self, w, h)
			if not IsValid(v) then return end

			draw.RoundedBox(0,0,0, w, h, RPExtraTeams[v:Team()].color)
			draw.RoundedBox(0, 0, 0, w, h, Color(255,255,255,10))

			surface.SetDrawColor( 255, 255, 255, 255 )
			surface.SetMaterial( convert_rank_to_img(v) )
			surface.DrawTexturedRect( 34, 8, 16, 16 )

			local name = ply:IsAdmin() and v:Name().." ("..v:SteamName()..")" or v:Name() 

			draw.SimpleText( name, "ScoreboardF4Menu", 57, 2, Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT)
			draw.SimpleText( v:getDarkRPVar("job"), "ScoreboardF4Menu", w/2, 2, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER)
			draw.SimpleText( v:Ping(), "ScoreboardF4Menu", w-15, 2, Color( 255, 255, 255, 255 ), TEXT_ALIGN_RIGHT)
		end

		local icon = vgui.Create( "AvatarImage", base["panelplayer"..k] )
		icon:SetPlayer(v, 30)
		icon:SetSize(30,30)
		icon:SetPos(0,0)

		local adminbtn = vgui.Create("DButton", base["panelplayer"..k])
		adminbtn:SetSize(base["panelplayer"..k]:GetWide(), base["panelplayer"..k]:GetTall())
		adminbtn:SetText("")
		adminbtn.Paint = function()
		end
		adminbtn.DoClick = function(self)
			-- local adm_prefix = "sg"

			-- local adminmenu = vgui.Create("UPMenu", self)
			-- adminmenu:AddOption(DGF4.Translation.copy_nick,function() SetClipboardText(v:Nick()) surface.PlaySound("buttons/button9.wav") end)
			-- adminmenu:AddOption(DGF4.Translation.copy_steamid,function() SetClipboardText(v:SteamID()) surface.PlaySound("buttons/button9.wav") end)
			-- adminmenu:AddOption(DGF4.Translation.open_steam_profile,function() v:ShowProfile() surface.PlaySound("buttons/button9.wav") end)
			-- if ply:IsAdmin() then
			-- 	local admin_things = adminmenu:AddSubMenu( "Admin" )
			-- 	admin_things:AddOption(DGF4.Translation.goto,function() RunConsoleCommand(adm_prefix, "goto", v:SteamID()) surface.PlaySound("buttons/button9.wav") end)
			-- 	admin_things:AddOption(DGF4.Translation.bring,function() RunConsoleCommand(adm_prefix, "bring", v:SteamID()) surface.PlaySound("buttons/button9.wav") end)
			-- 	admin_things:AddOption("return",function() RunConsoleCommand(adm_prefix, "return", v:SteamID()) surface.PlaySound("buttons/button9.wav") end)
			-- 	admin_things:AddOption(DGF4.Translation.kick,function() RunConsoleCommand(adm_prefix, "kick", v:SteamID(), DGF4.Scoreboard.KickReason) surface.PlaySound("buttons/button9.wav") end)
			-- 	admin_things:AddOption(DGF4.Translation.demote,function() RunConsoleCommand("rp_citizen", v:SteamID()) surface.PlaySound("buttons/button9.wav") end)
			-- end

			-- adminmenu:AddOption("Время игры: " .. playTime(v:GetUTimeTotalTime()),function()
			-- 	adminmenu:Remove()
			-- end)
			-- adminmenu:Open()

			if not IsValid(v) then return end

			local rankData = serverguard.ranks:GetRank(serverguard.player:GetRank(ply))
			local commands = serverguard.command:GetTable()
			
			local bNoAccess = true
			local menu = DermaMenu();
			menu:SetSkin("serverguard");
				menu:AddOption("Скопировать SteamID", function()
					SetClipboardText(v:SteamID());
				end):SetIcon("icon16/page_copy.png");
				menu:AddOption("Время игры: " .. playTime(v:GetUTimeTotalTime()),function()
					SetClipboardText(playTime(v:GetUTimeTotalTime()));
				end):SetIcon("icon16/clock.png")

				menu:AddSpacer()

				menu:AddOption("Goto", function()
					RunConsoleCommand("sg", "goto", v:SteamID())
				end):SetIcon("icon16/wand.png")
				menu:AddOption("Bring", function()
					RunConsoleCommand("sg", "bring", v:SteamID())
				end):SetIcon("icon16/wand.png")
				menu:AddOption("Return", function()
					RunConsoleCommand("sg", "return", v:SteamID())
				end):SetIcon("icon16/wand.png")
				menu:AddOption("Spectate", function()
					RunConsoleCommand("FSpectate", v:SteamID())
				end):SetIcon("icon16/wand.png")

				menu:AddSpacer()
				
				for unique, data in pairs(commands) do
					if (data.ContextMenu and (!data.permissions or serverguard.player:HasPermission(ply, data.permissions))) then
						data:ContextMenu(v, menu, rankData); bNoAccess = false;
					end;
				end;
			menu:Open();
			
			if (bNoAccess) then
				menu:Remove();
			end;
		end
	end
end

DGF4:RegisterButton(scoreboard)
