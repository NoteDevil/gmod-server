if !DGF4.RegisterButton then return end

surface.CreateFont("SRP_Groups.ListFont", {
	font = "Roboto Bold",
	weight = 500,
	size = 21,
	extended = true
})

surface.CreateFont("SRP_Groups.MainFont", {
	font = "Roboto Bold",
	size = 24,
	extended = true
})

local base

local function createTabButton(name, func, check_leader)
	base.btn = vgui.Create("DButton", base.dbutonpnl)
	base.btn:Dock(LEFT)
	base.btn:DockMargin(0,0,1,0)
	base.btn:SetWide(base.groupmenu:GetWide()/4-1)
	base.btn:SetFont("DermaLarge")
	base.btn:SetText(name)
	if check_leader then
		base.btn:SetDisabled(not SRP_Groups:IsGroupLeader(base.g_name, LocalPlayer():SteamID()))
	end
	base.btn.DoClick = func
end

local function recreateTab()
	if ValidPanel(base.contentpnl) then base.contentpnl:Remove() end
	base.contentpnl = vgui.Create("DPanel", base.groupmenu)
	base.contentpnl:SetSize(base.groupmenu:GetWide()-4, base.groupmenu:GetTall()-base.dbutonpnl:GetTall()-5)
	base.contentpnl:SetPos(2,55)
	base.contentpnl.Paint = function() end
end

local function OpenCreationMenu()
	base.createbtn = vgui.Create("DButton", base)
	base.createbtn:SetSize(400, 50)
	base.createbtn:Center()
	base.createbtn:SetText("Создать новую группу($"..string.Comma(SRP_Groups.GroupCost)..")")
	base.createbtn:SetFont("DermaLarge")
	base.createbtn.DoClick = function(self)
		Derma_StringRequest(
			"Название группы", 
			"Введите название группы", 
			"", 
			function(text) 
				if SRP_Groups:GroupExists(text) then 
					notification.AddLegacy("Такая группа уже существует", 1, 5)
					return
				end

				net.Start("SRP_Groups.CreateGroup")
				net.WriteString(text)
				net.SendToServer()
			end, 
			function(text) end, 
			"Создать", "Отмена"
		)
	end
end

local function OpenMainTab()
	base.groupnamelabel = vgui.Create("DPanel", base.contentpnl)
	base.groupnamelabel:SetSize(base.contentpnl:GetWide()-20, 50)
	base.groupnamelabel:SetPos(10,10)
	base.groupnamelabel.Paint = function(self, w, h)
		draw.SRPBackGround(4, 0, 0, w, h,200)
		draw.ShadowText(base.g_name, "SRP_Groups.MainFont", w/2, h/2, color_white, 1, 1)
	end

	base.members = vgui.Create("DScrollPanel", base.contentpnl)
	base.members:SetSize(base.contentpnl:GetWide()/3*2, base.contentpnl:GetTall()-75)
	base.members:SetPos(10,70)
	base.members.Paint = function() end

	base.layoutplayers = vgui.Create( "DIconLayout", base.members )
	base.layoutplayers:SetSize(base.members:GetWide(), base.members:GetTall() )
	base.layoutplayers:SetPos( 0, 0 )
	base.layoutplayers:SetSpaceY( 10 )
	base.layoutplayers:SetSpaceX( 5 )

	for k,v in pairs(base.g_tbl.members) do
		base['playerpnl'..k] = base.layoutplayers:Add("DPanel")
		base['playerpnl'..k]:SetSize(base.layoutplayers:GetWide()-10, 50)
		base['playerpnl'..k].Paint = function(self, w, h)
			draw.SRPBackGround(4, 0, 0, w, h,225)
			local ply_ = util.FindPlayer(k)
			draw.ShadowText(ply_ and ply_:Name() or k, "SRP_Groups.MainFont", 55, 2, color_white, 0, 0)
			draw.ShadowText(SRP_Groups:GetMemberRank(base.g_name, k), "SRP_Groups.MainFont", w-5, 2, Color(255, 200, 91), 2, 0)
		end

		local avatar = vgui.Create( "AvatarImage", base['playerpnl'..k] )
		avatar:SetSize( 46, 46 )
		avatar:SetPos( 2, 2)
		avatar:SetSteamID( util.SteamIDTo64(k), 66 )

		base.steamprofile = vgui.Create("DButton", base['playerpnl'..k])
		base.steamprofile:SetPos(55, base['playerpnl'..k]:GetTall()/2+5)
		base.steamprofile:SetSize(100, 15)
		base.steamprofile:SetText("Steam Profile")
		base.steamprofile.DoClick = function()
			gui.OpenURL("http://steamcommunity.com/profiles/"..util.SteamIDTo64(k))
		end

		if k == LocalPlayer():SteamID() then continue end
		if SRP_Groups:IsGroupLeader(base.g_name, k) then continue end

		if SRP_Groups:HasPermission(base.g_name, LocalPlayer():SteamID(), 'kick') then

			base.kickbtn = vgui.Create("DButton", base['playerpnl'..k])
			base.kickbtn:SetPos(265, base['playerpnl'..k]:GetTall()/2+5)
			base.kickbtn:SetSize(100, 15)
			base.kickbtn:SetText("Выгнать")
			base.kickbtn.DoClick = function()
				base['playerpnl'..k]:Remove()
				net.Start("SRP_Groups.KickMember")
				net.WriteString(k)
				net.SendToServer()
			end

		end

		if SRP_Groups:IsGroupLeader(base.g_name, LocalPlayer():SteamID()) then

			base.setrankbtn = vgui.Create("DButton", base['playerpnl'..k])
			base.setrankbtn:SetPos(160, base['playerpnl'..k]:GetTall()/2+5)
			base.setrankbtn:SetSize(100, 15)
			base.setrankbtn:SetText("Установить ранг")
			base.setrankbtn.DoClick = function(self)
				local adminmenu = vgui.Create("UPMenu", self)
				for rank,_ in pairs(base.g_tbl.ranks) do
					adminmenu:AddOption(rank,function()
						net.Start("SRP_Groups.SetRank")
						net.WriteString(k)
						net.WriteString(rank)
						net.SendToServer()
						surface.PlaySound("buttons/button9.wav") 
					end)
				end
				adminmenu:Open()
			end

		end
	end

	local text = markup.Parse("<font=SRP_Groups.ListFont>"..base.g_tbl.settings.motd.."</font>", base.contentpnl:GetWide()/3-40)

	base.InfoPnl = vgui.Create("DPanel", base.contentpnl)
	base.InfoPnl:SetSize(base.contentpnl:GetWide()/3-20, base.contentpnl:GetTall()-80)
	base.InfoPnl:SetPos(base.contentpnl:GetWide()/3*2+10,70)
	base.InfoPnl.Paint = function(self, w, h)
		draw.SRPBackGround(4, 0, 0, w, h,225)
		text:Draw(10, 35, 0, 0, 255)
	end

	base.info_dlabel = vgui.Create("DLabel", base.InfoPnl)
	base.info_dlabel:SetText("")
	base.info_dlabel:SetFont("SRP_Groups.MainFont")
	base.info_dlabel:SizeToContents()
	base.info_dlabel:Dock(TOP)
	base.info_dlabel:DockMargin(0,0,0,0)
	base.info_dlabel.Paint = function(self, w, h)
		draw.SRPBackGround(4, 0, 0, w, h, 200)
		draw.ShadowText("Информация", "SRP_Groups.MainFont", w/2, h/2, color_white, 1, 1)
	end
end

local function OpenManagmentTab()
	base.motdchangepnl = vgui.Create("DPanel", base.contentpnl)
	base.motdchangepnl:SetSize(base.contentpnl:GetWide()/2-20, base.contentpnl:GetTall()-50)
	base.motdchangepnl:SetPos(10,10)
	base.motdchangepnl.Paint = function(self, w, h)
		draw.SRPBackGround(4, 0, 0, w, h, 200)
	end

	base.motd_dlabel = vgui.Create("DLabel", base.motdchangepnl)
	base.motd_dlabel:SetText("")
	base.motd_dlabel:SetFont("SRP_Groups.MainFont")
	base.motd_dlabel:SizeToContents()
	base.motd_dlabel:Dock(TOP)
	base.motd_dlabel:DockMargin(0,0,0,0)
	base.motd_dlabel.Paint = function(self, w, h)
		draw.SRPBackGround(4, 0, 0, w, h, 200)
		draw.ShadowText("Информация", "SRP_Groups.MainFont", w/2, h/2, color_white, 1, 1)
	end

	local has_motd_right = SRP_Groups:HasPermission(base.g_name, LocalPlayer():SteamID(), 'motd')

	base.motdtextentry = vgui.Create("DTextEntry", base.motdchangepnl)
	base.motdtextentry:SetSize(base.motdchangepnl:GetWide()-20, base.motdchangepnl:GetTall()-75)
	base.motdtextentry:SetPos(10,35)
	base.motdtextentry:SetMultiline(true)
	base.motdtextentry:SetDisabled(not has_motd_right)
	base.motdtextentry:SetText(base.g_tbl.settings.motd)

	base.motdupbtn = vgui.Create("DButton", base.motdchangepnl)
	base.motdupbtn:SetSize(100, 30)
	base.motdupbtn:SetPos(base.motdchangepnl:GetWide()/2-50, base.motdtextentry:GetTall() + 40)
	base.motdupbtn:SetText(has_motd_right and "Обновить" or "Недоступно")
	base.motdupbtn:SetDisabled(not has_motd_right)
	base.motdupbtn.DoClick = function(self)
		net.Start("SRP_Groups.SetMOTD")
		net.WriteString(base.motdtextentry:GetValue())
		net.SendToServer()
		base.g_tbl.settings.motd = base.motdtextentry:GetValue()
	end

	base.extendlbl = vgui.Create("DPanel", base.contentpnl)
	base.extendlbl:SetSize(base.motdchangepnl:GetWide(), 50)
	base.extendlbl:SetPos(10, base.motdchangepnl:GetTall())
	base.extendlbl.Paint = function(self, w, h)
		draw.ShadowText("Группа до: "..os.date( "%d.%m.%Y" , base.g_tbl.expire_time ), "SRP_Groups.MainFont", w/2, h/2+5, color_white, 1, 1)
	end

	base.leavegroup = vgui.Create("DButton", base.contentpnl)
	base.leavegroup:SetSize(100, 30)
	base.leavegroup:SetPos(10, base.motdchangepnl:GetTall() + 15)
	base.leavegroup:SetText("Выйти из группы")
	base.leavegroup.DoClick = function(self)
		Derma_Query(
			"Вы уверены, что хотите выйти из группы?",
			"Выход из группы",
			"Да",
			function()
				net.Start("SRP_Groups.LeaveGroup")
				net.SendToServer()
				base:Remove()
			end,
			"Нет"
		)
	end

	base.extendgroup = vgui.Create("DButton", base.contentpnl)
	base.extendgroup:SetSize(130, 30)
	base.extendgroup:SetPos(base.motdchangepnl:GetWide()-120, base.motdchangepnl:GetTall() + 15)
	base.extendgroup:SetText("Продлить на месяц ("..SRP_Groups.ExtendCost..")")
	base.extendgroup:SetDisabled(not (LocalPlayer():PS_HasPoints(SRP_Groups.ExtendCost) and SRP_Groups:IsGroupLeader(base.g_name, LocalPlayer():SteamID())))
	base.extendgroup.DoClick = function(self)
		Derma_Query(
			"Вы уверены, что хотите продлить группу?",
			"Продление группы",
			"Да",
			function()
				net.Start("SRP_Groups.ExtendGroup")
				net.SendToServer()
				base:Remove()
			end,
			"Нет"
		)
	end

	base.otherSettingsPnl = vgui.Create("DPanel", base.contentpnl)
	base.otherSettingsPnl:SetSize(base.contentpnl:GetWide()/2-20, base.contentpnl:GetTall()-50)
	base.otherSettingsPnl:SetPos(base.contentpnl:GetWide()/2,10)
	base.otherSettingsPnl.Paint = function(self, w, h)
		draw.SRPBackGround(4, 0, 0, w, h, 200)
	end

	base.osets_dlabel = vgui.Create("DLabel", base.otherSettingsPnl)
	base.osets_dlabel:SetText("")
	base.osets_dlabel:SetFont("SRP_Groups.MainFont")
	base.osets_dlabel:SizeToContents()
	base.osets_dlabel:Dock(TOP)
	base.osets_dlabel:DockMargin(0,0,0,0)
	base.osets_dlabel.Paint = function(self, w, h)
		draw.SRPBackGround(4, 0, 0, w, h, 200)
		draw.ShadowText("Настройка", "SRP_Groups.MainFont", w/2, h/2, color_white, 1, 1)
	end

	base['cbs_ff'] = vgui.Create( "DCheckBoxLabel", base.otherSettingsPnl)
	base['cbs_ff']:SetText( "Disable FriendlyFire" )
	base['cbs_ff']:SetFont("SRP_Groups.MainFont")
	base['cbs_ff']:SetDisabled(not SRP_Groups:HasPermission(base.g_name, LocalPlayer():SteamID(), 'ff'))
	base['cbs_ff']:SetChecked(base.g_tbl.settings.ff)
	base['cbs_ff']:Dock(TOP)
	base['cbs_ff']:DockMargin(10,5,10,5)

	base['cbs_wh'] = vgui.Create( "DCheckBoxLabel", base.otherSettingsPnl)
	base['cbs_wh']:SetText( "WallHack" )
	base['cbs_wh']:SetFont("SRP_Groups.MainFont")
	base['cbs_wh']:SetDisabled(not SRP_Groups:HasPermission(base.g_name, LocalPlayer():SteamID(), 'wallhack'))
	base['cbs_wh']:SetChecked(base.g_tbl.settings.wallhack.cb)
	base['cbs_wh']:Dock(TOP)
	base['cbs_wh']:DockMargin(10,5,10,5)

	base.mixer = vgui.Create( "DColorMixer", base.otherSettingsPnl )
	base.mixer:Dock( TOP )
	base.mixer:DockMargin(10,5,10,5)
	base.mixer:SetDisabled(not SRP_Groups:HasPermission(base.g_name, LocalPlayer():SteamID(), 'wallhack'))
	base.mixer:SetPalette( false )
	base.mixer:SetAlphaBar( false )
	base.mixer:SetColor( base.g_tbl.settings.wallhack.color )

	base.setupbtn = vgui.Create("DButton", base.otherSettingsPnl)
	base.setupbtn:Dock( TOP )
	base.setupbtn:DockMargin(10,5,10,5)
	base.setupbtn:SetText("Обновить")
	base.setupbtn.DoClick = function(self)
		net.Start("SRP_Groups.UpdateSettings")
		net.WriteBool(base['cbs_ff']:GetChecked())
		net.WriteBool(base['cbs_wh']:GetChecked())
		net.WriteTable(base.mixer:GetColor())
		net.SendToServer()
	end

	base.combobox = vgui.Create("DComboBox", base.otherSettingsPnl)
	base.combobox:Dock( TOP )
	base.combobox:DockMargin(10,5,10,5)
	base.combobox:SetValue("Игроки")
	base.combobox:SetDisabled(not SRP_Groups:HasPermission(base.g_name, LocalPlayer():SteamID(), 'invite'))
	base.combobox:SetFont("SRP_Groups.MainFont")
	for k,v in pairs(player.GetAll()) do
		if v == LocalPlayer() then continue end
		base.combobox:AddChoice(v:Name())
	end

	base.invitebtn = vgui.Create("DButton", base.otherSettingsPnl)
	base.invitebtn:Dock( TOP )
	base.invitebtn:DockMargin(10,5,10,5)
	base.invitebtn:SetText("Пригласить")
	base.invitebtn:SetDisabled(not SRP_Groups:HasPermission(base.g_name, LocalPlayer():SteamID(), 'invite'))
	base.invitebtn.DoClick = function(self)
		if base.combobox:GetValue() == "Игроки" then return end
		net.Start("SRP_Groups.InviteToGroup")
		net.WriteString(base.combobox:GetValue())
		net.SendToServer()
	end

end

local function OpenBankTab()
	base.banklabel = vgui.Create("DPanel", base.contentpnl)
	base.banklabel:SetSize(base.contentpnl:GetWide()-20, 50)
	base.banklabel:SetPos(10,10)
	base.banklabel.Paint = function(self, w, h)
		draw.SRPBackGround(4, 0, 0, w, h,200)
		draw.ShadowText("На счету: "..DarkRP.formatMoney(SRP_Groups:GetBankMoney(base.g_name)), "SRP_Groups.MainFont", w/2, h/2, color_white, 1, 1)
	end

	base.bank_operations = vgui.Create("DPanel", base.contentpnl)
	base.bank_operations:SetSize(base.contentpnl:GetWide()/3*2-20, base.contentpnl:GetTall()-75)
	base.bank_operations:SetPos(10,70)
	base.bank_operations.Paint = function() end

	base.bank_d = vgui.Create("DButton", base.bank_operations)
	base.bank_d:SetSize(base.bank_operations:GetWide(), 50)
	base.bank_d:Dock(TOP)
	base.bank_d:DockMargin(0,0,0,5)
	base.bank_d:SetText("")
	base.bank_d.Paint = function(self, w, h)
		if self:IsHovered() then
			draw.SRPBackGround(4, 0, 0, w, h,200)
		else
			draw.SRPBackGround(4, 0, 0, w, h)
		end
		draw.ShadowText("Внести деньги", "SRP_Groups.MainFont", w/2, h/2, color_white, 1, 1)
	end
	base.bank_d.DoClick = function(self)
		Derma_StringRequest(
			"Внести деньги", 
			"Введите сумму", 
			"", 
			function(text)
				text = tonumber(text)
				if text then
					net.Start("SRP_Groups.DMoney") -- Zdravstvuy strannik, tam na servere proverki
					net.WriteUInt(tonumber(text), 32)
					net.SendToServer()
					base:Remove()
				else
					notification.AddLegacy("Ты чего, не знаешь что такое сумма?", 1, 4)
				end
			end, 
			function(text) end, 
			"Внести", "Отмена"
		)
	end

	if SRP_Groups:HasPermission(base.g_name, LocalPlayer():SteamID(), 'bank') then

		base.bank_w = vgui.Create("DButton", base.bank_operations)
		base.bank_w:SetSize(base.bank_operations:GetWide(), 50)
		base.bank_w:Dock(TOP)
		base.bank_d:DockMargin(0,0,0,5)
		base.bank_w:SetText("")
		base.bank_w.Paint = function(self, w, h)
			if self:IsHovered() then
				draw.SRPBackGround(4, 0, 0, w, h,200)
			else
				draw.SRPBackGround(4, 0, 0, w, h)
			end
			draw.ShadowText("Снять деньги", "SRP_Groups.MainFont", w/2, h/2, color_white, 1, 1)
		end
		base.bank_w.DoClick = function(self)
			Derma_StringRequest(
				"Снять деньги", 
				"Введите сумму", 
				"", 
				function(text)
					text = tonumber(text)
					if text then
						net.Start("SRP_Groups.WMoney") -- Zdravstvuy strannik, tam na servere proverki
						net.WriteUInt(tonumber(text), 32)
						net.SendToServer()
						base:Remove()
					else
						notification.AddLegacy("Ты чего, не знаешь что такое сумма?", 1, 4)
					end
				end, 
				function(text) end, 
				"Снять", "Отмена"
			)
		end
	end

	base.BankLogsPnl = vgui.Create("DPanel", base.contentpnl)
	base.BankLogsPnl:SetSize(base.contentpnl:GetWide()/3-20, base.contentpnl:GetTall()-80)
	base.BankLogsPnl:SetPos(base.contentpnl:GetWide()/3*2+10,70)
	base.BankLogsPnl.Paint = function(self, w, h)
		draw.SRPBackGround(4, 0, 0, w, h,225)
	end

	base.banklog_dlabel = vgui.Create("DLabel", base.BankLogsPnl)
	base.banklog_dlabel:SetText("")
	base.banklog_dlabel:SetFont("SRP_Groups.MainFont")
	base.banklog_dlabel:SizeToContents()
	base.banklog_dlabel:Dock(TOP)
	base.banklog_dlabel:DockMargin(0,0,0,10)
	base.banklog_dlabel.Paint = function(self, w, h)
		draw.SRPBackGround(4, 0, 0, w, h, 200)
		draw.ShadowText("Последние операции", "SRP_Groups.MainFont", w/2, h/2, color_white, 1, 1)
	end

	if not base.g_tbl.blogs then return end
	
	for i=#base.g_tbl.blogs, 1, -1 do

		base.banklog_pnl = vgui.Create("DPanel", base.BankLogsPnl)
		base.banklog_pnl:Dock(TOP)
		base.banklog_pnl:DockMargin(10,0,10,5)
		base.banklog_pnl.Paint = function(self, w, h) 
			local log = markup.Parse("<font=SRP_Groups.ListFont>"..base.g_tbl.blogs[i].."</font>", w)
			log:Draw(0,h/2,0,1)
		end

	end
end

local function OpenRanksTab()
	base.rankspnl = vgui.Create("DPanel", base.contentpnl)
	base.rankspnl:SetSize(base.contentpnl:GetWide()-20, 50)
	base.rankspnl:SetPos(10,10)
	base.rankspnl.Paint = function(self, w, h)
		draw.SRPBackGround(4, 0, 0, w, h,225)
	end

	local def_rank = table.GetFirstKey(base.g_tbl.ranks)

	base.rankscombo = vgui.Create("DComboBox", base.rankspnl)
	base.rankscombo:SetSize(base.rankspnl:GetWide()-10, base.rankspnl:GetTall()-10)
	base.rankscombo:SetPos(5,5)
	base.rankscombo:SetValue(def_rank)
	base.rankscombo:SetFont("SRP_Groups.MainFont")
	for k,v in pairs(base.g_tbl.ranks) do
		base.rankscombo:AddChoice(k)
	end
	base.rankscombo.OnSelect = function(self, index, value, data )
		for k,v in pairs(base.g_tbl.ranks[value]) do
			base['cb_'..k]:SetChecked(v)
		end
	end

	base.ranksrightspnl = vgui.Create("DPanel", base.contentpnl)
	base.ranksrightspnl:SetSize(base.contentpnl:GetWide()-20, base.contentpnl:GetTall()-80)
	base.ranksrightspnl:SetPos(10,70)
	base.ranksrightspnl.Paint = function(self, w, h)
		draw.SRPBackGround(4, 0, 0, w, h,255)
	end

	base['cb_bank'] = vgui.Create( "DCheckBoxLabel", base.ranksrightspnl)
	base['cb_bank']:SetText( "Снимать деньги" )
	base['cb_bank']:SetFont("SRP_Groups.MainFont")
	base['cb_bank']:Dock(TOP)
	base['cb_bank']:DockMargin(10,5,10,5)

	base['cb_invite'] = vgui.Create( "DCheckBoxLabel", base.ranksrightspnl)
	base['cb_invite']:SetText( "Приглашать" )
	base['cb_invite']:SetFont("SRP_Groups.MainFont")
	base['cb_invite']:Dock(TOP)
	base['cb_invite']:DockMargin(10,5,10,5)

	base['cb_kick'] = vgui.Create( "DCheckBoxLabel", base.ranksrightspnl)
	base['cb_kick']:SetText( "Кикать" )
	base['cb_kick']:SetFont("SRP_Groups.MainFont")
	base['cb_kick']:Dock(TOP)
	base['cb_kick']:DockMargin(10,5,10,5)

	base['cb_motd'] = vgui.Create( "DCheckBoxLabel", base.ranksrightspnl)
	base['cb_motd']:SetText( "Настройка MOTD" )
	base['cb_motd']:SetFont("SRP_Groups.MainFont")
	base['cb_motd']:Dock(TOP)
	base['cb_motd']:DockMargin(10,5,10,5)

	base['cb_ff'] = vgui.Create( "DCheckBoxLabel", base.ranksrightspnl)
	base['cb_ff']:SetText( "Настройка FF" )
	base['cb_ff']:SetFont("SRP_Groups.MainFont")
	base['cb_ff']:Dock(TOP)
	base['cb_ff']:DockMargin(10,5,10,5)

	base['cb_wallhack'] = vgui.Create( "DCheckBoxLabel", base.ranksrightspnl)
	base['cb_wallhack']:SetText( "Настройка WH" )
	base['cb_wallhack']:SetFont("SRP_Groups.MainFont")
	base['cb_wallhack']:Dock(TOP)
	base['cb_wallhack']:DockMargin(10,5,10,5)

	for k,v in pairs(base.g_tbl.ranks[def_rank]) do
		base['cb_'..k]:SetChecked(v)
	end

	base.remvovebtn = vgui.Create("DButton", base.ranksrightspnl)
	base.remvovebtn:SetSize(150,40)
	base.remvovebtn:SetPos((base.ranksrightspnl:GetWide()-150)/2-152, base.ranksrightspnl:GetTall()-45)
	base.remvovebtn:SetText("Удалить")
	base.remvovebtn:SetFont("SRP_Groups.MainFont")
	base.remvovebtn.DoClick = function(self)
		local rank = base.rankscombo:GetValue()
		Derma_Query(
			"Вы уверены, что хотите удалить ранг: "..rank.."?",
			"Удаление ранга",
			"Да",
			function()
				net.Start("SRP_Groups.RemoveRank")
				net.WriteString(rank)
				net.SendToServer()
				base:Remove()
			end,
			"Нет"
		)
	end

	base.updatebtn = vgui.Create("DButton", base.ranksrightspnl)
	base.updatebtn:SetSize(150,40)
	base.updatebtn:SetPos((base.ranksrightspnl:GetWide()-150)/2, base.ranksrightspnl:GetTall()-45)
	base.updatebtn:SetText("Обновить")
	base.updatebtn:SetFont("SRP_Groups.MainFont")
	base.updatebtn.DoClick = function(self)
		-- if base.rankscombo:GetValue() == "Ранги" then return end
		local tbl = {}
		for k,v in pairs(base.g_tbl.ranks[base.rankscombo:GetValue()]) do
			tbl[k] = base['cb_'..k]:GetChecked()
			local value = base['cb_'..k]:GetChecked() and true or false
			base.g_tbl.ranks[base.rankscombo:GetValue()][k] = value
		end
		net.Start("SRP_Groups.RankUpdate")
		net.WriteString(base.rankscombo:GetValue())
		net.WriteTable(tbl)
		net.SendToServer()
	end

	base.createbtn = vgui.Create("DButton", base.ranksrightspnl)
	base.createbtn:SetSize(150,40)
	base.createbtn:SetPos((base.ranksrightspnl:GetWide()+154)/2, base.ranksrightspnl:GetTall()-45)
	base.createbtn:SetText("Создать")
	base.createbtn:SetFont("SRP_Groups.MainFont")
	base.createbtn.DoClick = function(self)	
		local tbl = {}
		for k,v in pairs(base.g_tbl.ranks['новичок']) do
			tbl[k] = false
		end
		Derma_StringRequest(
			"Название ранга", 
			"Введите название ранга", 
			"", 
			function(text)
				if string.gsub(text, " ", "") == "" then return end
				net.Start("SRP_Groups.AddRank")
				net.WriteString(text)
				net.WriteTable(tbl)
				net.SendToServer()
			end, 
			function(text) end, 
			"Создать", "Отмена"
		)
	end
end

local function OpenInviteTab()
	base.invitepnlc = vgui.Create("DPanel", base.contentpnl)
	base.invitepnlc:SetSize(base.contentpnl:GetWide()-20, 50)
	base.invitepnlc:SetPos(10,10)
	base.invitepnlc.Paint = function(self, w, h)
		draw.SRPBackGround(4, 0, 0, w, h,225)
	end

	base.combobox = vgui.Create("DComboBox", base.invitepnlc)
	base.combobox:SetSize(base.invitepnlc:GetWide()-10, base.invitepnlc:GetTall()-10)
	base.combobox:SetPos(5,5)
	base.combobox:SetValue("Игроки")
	base.combobox:SetFont("SRP_Groups.MainFont")
	for k,v in pairs(player.GetAll()) do
		base.combobox:AddChoice(v:Name())
	end

	base.invitepnl = vgui.Create("DPanel", base.contentpnl)
	base.invitepnl:SetSize(base.contentpnl:GetWide()-20, base.contentpnl:GetTall()-80)
	base.invitepnl:SetPos(10,70)
	base.invitepnl.Paint = function(self, w, h)
		draw.SRPBackGround(4, 0, 0, w, h,225)
	end

	base.textentryinv = vgui.Create("DTextEntry", base.invitepnl)
	base.textentryinv:SetSize(base.invitepnl:GetWide()-20, base.invitepnl:GetTall()-60)
	base.textentryinv:SetPos(10,10)
	base.textentryinv:SetMultiline(true)
	base.textentryinv.Paint = function(self, w, h)
		draw.SRPBackGround(4, 0, 0, w, h,200)
	end
end

local function OpenGroupMenu()
	base.groupmenu = vgui.Create("DPanel", base)
	base.groupmenu:SetSize(ScrW()*0.7, ScrH()*0.8)
	base.groupmenu:Center()
	base.groupmenu.Paint = function(self, w, h)
		draw.SRPBackGround(4, 0, 0, w, h)
	end

	base.dbutonpnl = vgui.Create("DPanel", base.groupmenu)
	base.dbutonpnl:SetSize(base.groupmenu:GetWide()-4, 50)
	base.dbutonpnl:SetPos(2,2)
	base.dbutonpnl.Paint = function() end

	createTabButton("Главная", function(self)
		recreateTab()
		OpenMainTab()
	end)
	createTabButton("Управление", function(self)
		recreateTab()
		OpenManagmentTab()
	end)
	createTabButton("Банк", function(self)
		recreateTab()
		OpenBankTab()
	end)
	createTabButton("Ранги", function(self)
		recreateTab()
		OpenRanksTab()
	end,
	true
	)
	-- createTabButton("Пригласить", function(self)
	-- 	recreateTab()
	-- 	OpenInviteTab()
	-- end)

	recreateTab()
	OpenMainTab()
end

local Groups = {}
Groups.pos = 26
Groups.name = "Группы"
Groups.col = Color(255,36,0)
Groups.wide = ScrW() - 400
Groups.callBack = function(self)
	local x, y, ply = ScrW(), ScrH(), LocalPlayer()
	base = DGF4.BaseElement(self, Groups.name, Groups.col, Groups.wide)

	base.g_name = SRP_Groups:GetUserGroup(LocalPlayer())
	base.g_tbl = SRP_Groups.groups[base.g_name]

	if SRP_Groups:GetUserGroup(ply) ~= "" then
		OpenGroupMenu()
	else
		OpenCreationMenu()
	end
end

DGF4:RegisterButton(Groups)