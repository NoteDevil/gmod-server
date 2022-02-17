if !DGF4.RegisterButton then return end

local Settings = {}
Settings.pos = 5
Settings.name = "Настройки"
Settings.col = Color(255,36,0)
Settings.wide = 400
Settings.callBack = function(self)
	local x, y, ply = ScrW(), ScrH(), LocalPlayer()
	base = DGF4.BaseElement(self, Settings.name, Settings.col, Settings.wide)

	base.main = vgui.Create("DScrollPanel", base)
	base.main:SetSize(Settings.wide, y)
	base.main:SetPos(0, 0)
	base.main.Paint = function(self, w, h)
		draw.RoundedBox(0, 0, 0, w, h, Color(0,0,0,150))
	end

	base.sound_dlabel = vgui.Create("DLabel", base.main)
	base.sound_dlabel:SetText("")
	base.sound_dlabel:SetFont("InfoBtnMenu")
	base.sound_dlabel:SizeToContents()
	base.sound_dlabel:Dock(TOP)
	base.sound_dlabel:DockMargin(5,10,5,10)
	base.sound_dlabel.Paint = function(self, w, h)
		draw.ShadowText("Звук", "InfoBtnMenu", w/2, h/2, color_white, 1, 1)
	end

	base.jukebox_slider = vgui.Create( "DNumSlider", base.main)
	base.jukebox_slider:Dock(TOP)
	base.jukebox_slider:DockMargin(5,5,5,5)
	base.jukebox_slider:SetConVar( "jukebox_volume" )
	base.jukebox_slider:SetMin( 0 )
	base.jukebox_slider:SetMax( 1 )
	base.jukebox_slider:SetText( "Jukebox" )
	base.jukebox_slider.Label:SetTextInset( 5, 0 )
	base.jukebox_slider.TextArea:SetTextColor( Color(200, 200, 200, 255) )
	base.jukebox_slider.PerformLayout = function()
		base.jukebox_slider.Label:SizeToContents()
		base.jukebox_slider.Label:SetWide( base.jukebox_slider.Label:GetWide() +5 )
	end

	base.mediaplayer_slider = vgui.Create( "DNumSlider", base.main)
	base.mediaplayer_slider:Dock(TOP)
	base.mediaplayer_slider:DockMargin(5,5,5,5)
	base.mediaplayer_slider:SetConVar( "mediaplayer_volume" )
	base.mediaplayer_slider:SetMin( 0 )
	base.mediaplayer_slider:SetMax( 1 )	
	base.mediaplayer_slider:SetText( "MediaPlayer" )
	base.mediaplayer_slider.Label:SetTextInset( 5, 0 )
	base.mediaplayer_slider.TextArea:SetTextColor( Color(200, 200, 200, 255) )
	base.mediaplayer_slider.PerformLayout = function()
		base.mediaplayer_slider.Label:SizeToContents()
		base.mediaplayer_slider.Label:SetWide( base.mediaplayer_slider.Label:GetWide() +5 )
	end

	base.wowovolume_slider = vgui.Create( "DNumSlider", base.main)
	base.wowovolume_slider:Dock(TOP)
	base.wowovolume_slider:DockMargin(5,5,5,5)
	base.wowovolume_slider:SetConVar( "srp_wowozela_volume" )
	base.wowovolume_slider:SetMin( 0 )
	base.wowovolume_slider:SetMax( 1 )	
	base.wowovolume_slider:SetText( "Волшебная дудка" )
	base.wowovolume_slider.Label:SetTextInset( 5, 0 )
	base.wowovolume_slider.TextArea:SetTextColor( Color(200, 200, 200, 255) )
	base.wowovolume_slider.PerformLayout = function()
		base.wowovolume_slider.Label:SizeToContents()
		base.wowovolume_slider.Label:SetWide( base.wowovolume_slider.Label:GetWide() +5 )
	end

	base.gamevolume_slider = vgui.Create( "DNumSlider", base.main)
	base.gamevolume_slider:Dock(TOP)
	base.gamevolume_slider:DockMargin(5,5,5,5)
	base.gamevolume_slider:SetConVar( "volume" )
	base.gamevolume_slider:SetMin( 0 )
	base.gamevolume_slider:SetMax( 1 )	
	base.gamevolume_slider:SetText( "Громкость игры" )
	base.gamevolume_slider.Label:SetTextInset( 5, 0 )
	base.gamevolume_slider.TextArea:SetTextColor( Color(200, 200, 200, 255) )
	base.gamevolume_slider.PerformLayout = function()
		base.gamevolume_slider.Label:SizeToContents()
		base.gamevolume_slider.Label:SetWide( base.gamevolume_slider.Label:GetWide() +5 )
	end

	base.stop_sound = vgui.Create("DButton", base.main)
	base.stop_sound:Dock(TOP)
	base.stop_sound:DockMargin(5,5,5,5)
	base.stop_sound:SetText("Остановить все звуки")
	base.stop_sound.DoClick = function(self)
		RunConsoleCommand("stopsound")
	end

	base.performance_dlabel = vgui.Create("DLabel", base.main)
	base.performance_dlabel:SetText("")
	base.performance_dlabel:SetFont("InfoBtnMenu")
	base.performance_dlabel:SizeToContents()
	base.performance_dlabel:Dock(TOP)
	base.performance_dlabel:DockMargin(5,10,5,10)
	base.performance_dlabel.Paint = function(self, w, h)
		draw.ShadowText("Производительность", "InfoBtnMenu", w/2, h/2, color_white, 1, 1)
	end

	base.m_pnl3DSkyboxSetting = vgui.Create( "DCheckBoxLabel", base.main)
	base.m_pnl3DSkyboxSetting:SetConVar( "r_3dsky" )
	base.m_pnl3DSkyboxSetting:SetText( "3DSkybox" )
	base.m_pnl3DSkyboxSetting:Dock(TOP)
	base.m_pnl3DSkyboxSetting:DockMargin(5,5,5,5)
	
	base.m_pnlObjectShadows = vgui.Create( "DCheckBoxLabel", base.main)
	base.m_pnlObjectShadows:SetConVar( "r_shadows" )
	base.m_pnlObjectShadows:SetText( "Тени объектов" )
	base.m_pnlObjectShadows:Dock(TOP)
	base.m_pnlObjectShadows:DockMargin(5,5,5,5)
	
	base.m_pnlObjectShadowRender = vgui.Create( "DCheckBoxLabel", base.main)
	base.m_pnlObjectShadowRender:SetConVar( "r_shadowrendertotexture" )
	base.m_pnlObjectShadowRender:SetText( "Детализированные тени" )
	base.m_pnlObjectShadowRender:Dock(TOP)
	base.m_pnlObjectShadowRender:DockMargin(5,5,5,5)
	
	base.m_pnlObjectDynamicLighting = vgui.Create( "DCheckBoxLabel", base.main)
	base.m_pnlObjectDynamicLighting:SetConVar( "r_dynamic" )
	base.m_pnlObjectDynamicLighting:SetText( "Динамический свет" )
	base.m_pnlObjectDynamicLighting:Dock(TOP)
	base.m_pnlObjectDynamicLighting:DockMargin(5,5,5,5)

	base.m_pnlObjectDrawFlecks = vgui.Create( "DCheckBoxLabel", base.main)
	base.m_pnlObjectDrawFlecks:SetConVar( "r_drawflecks" )
	base.m_pnlObjectDrawFlecks:SetText( "Мелкие частицы" )
	base.m_pnlObjectDrawFlecks:Dock(TOP)
	base.m_pnlObjectDrawFlecks:DockMargin(5,5,5,5)

	base.m_pnlObjectDrawDecals = vgui.Create( "DCheckBoxLabel", base.main)
	base.m_pnlObjectDrawDecals:SetConVar( "r_drawmodeldecals" )
	base.m_pnlObjectDrawDecals:SetText( "Декали" )
	base.m_pnlObjectDrawDecals:Dock(TOP)
	base.m_pnlObjectDrawDecals:DockMargin(5,5,5,5)

	base.m_pnlObjectFPSCounter = vgui.Create( "DCheckBoxLabel", base.main)
	base.m_pnlObjectFPSCounter:SetConVar( "cl_showfps" )
	base.m_pnlObjectFPSCounter:SetText( "FPS счетчик" )
	base.m_pnlObjectFPSCounter:Dock(TOP)
	base.m_pnlObjectFPSCounter:DockMargin(5,5,5,5)

	base.voice_slider = vgui.Create( "DNumSlider", base.main)
	base.voice_slider:Dock(TOP)
	base.voice_slider:DockMargin(5,5,5,5)
	base.voice_slider:SetConVar( "srp_ent_distance" )
	base.voice_slider:SetMin( 300 )
	base.voice_slider:SetMax( 5000 )	
	base.voice_slider:SetText( "Дистанция отображения энтити" )
	base.voice_slider:SetDecimals(0)
	base.voice_slider.Label:SetTextInset( 5, 0 )
	base.voice_slider.TextArea:SetTextColor( Color(200, 200, 200, 255) )
	base.voice_slider.PerformLayout = function()
		base.voice_slider.Label:SizeToContents()
		base.voice_slider.Label:SetWide( base.voice_slider.Label:GetWide() +5 )
	end

	--
	-- SNOW START
	--

	base.snow_check = vgui.Create( "DCheckBoxLabel", base.main)
	base.snow_check:SetConVar( "atmos_cl_snowenable" )
	base.snow_check:SetText( "Снег" )
	base.snow_check:Dock(TOP)
	base.snow_check:DockMargin(5,5,5,5)

	base.snow_slider1 = vgui.Create( "DNumSlider", base.main)
	base.snow_slider1:Dock(TOP)
	base.snow_slider1:DockMargin(5,5,5,5)
	base.snow_slider1:SetConVar( "atmos_cl_snowradius" )
	base.snow_slider1:SetMin( 200 )
	base.snow_slider1:SetMax( 2000 )	
	base.snow_slider1:SetText( "Снег: радиус" )
	base.snow_slider1:SetDecimals(0)
	base.snow_slider1.Label:SetTextInset( 5, 0 )
	base.snow_slider1.TextArea:SetTextColor( Color(200, 200, 200, 255) )
	base.snow_slider1.PerformLayout = function()
		base.snow_slider1.Label:SizeToContents()
		base.snow_slider1.Label:SetWide( base.snow_slider1.Label:GetWide() +5 )
	end

	base.snow_slider2 = vgui.Create( "DNumSlider", base.main)
	base.snow_slider2:Dock(TOP)
	base.snow_slider2:DockMargin(5,5,5,5)
	base.snow_slider2:SetConVar( "atmos_cl_snowperparticle" )
	base.snow_slider2:SetMin( 8 )
	base.snow_slider2:SetMax( 64 )	
	base.snow_slider2:SetText( "Снег: количество" )
	base.snow_slider2:SetDecimals(0)
	base.snow_slider2.Label:SetTextInset( 5, 0 )
	base.snow_slider2.TextArea:SetTextColor( Color(200, 200, 200, 255) )
	base.snow_slider2.PerformLayout = function()
		base.snow_slider2.Label:SizeToContents()
		base.snow_slider2.Label:SetWide( base.snow_slider2.Label:GetWide() +5 )
	end

	base.snow_slider3 = vgui.Create( "DNumSlider", base.main)
	base.snow_slider3:Dock(TOP)
	base.snow_slider3:DockMargin(5,5,5,5)
	base.snow_slider3:SetConVar( "atmos_cl_snowdietime" )
	base.snow_slider3:SetMin( 2 )
	base.snow_slider3:SetMax( 16 )	
	base.snow_slider3:SetText( "Снег: время снежинки" )
	base.snow_slider3:SetDecimals(0)
	base.snow_slider3.Label:SetTextInset( 5, 0 )
	base.snow_slider3.TextArea:SetTextColor( Color(200, 200, 200, 255) )
	base.snow_slider3.PerformLayout = function()
		base.snow_slider3.Label:SizeToContents()
		base.snow_slider3.Label:SetWide( base.snow_slider3.Label:GetWide() +5 )
	end

	--
	-- SNOW END
	--

	base.interface_dlabel = vgui.Create("DLabel", base.main)
	base.interface_dlabel:SetText("")
	base.interface_dlabel:SetFont("InfoBtnMenu")
	base.interface_dlabel:SizeToContents()
	base.interface_dlabel:Dock(TOP)
	base.interface_dlabel:DockMargin(5,10,5,10)
	base.interface_dlabel.Paint = function(self, w, h)
		draw.ShadowText("Интерфейс", "InfoBtnMenu", w/2, h/2, color_white, 1, 1)
	end

	base.m_pnlObjectDrawMainHud = vgui.Create( "DCheckBoxLabel", base.main)
	base.m_pnlObjectDrawMainHud:SetConVar( "srp_hud_main" )
	base.m_pnlObjectDrawMainHud:SetText( "HUD: Основной" )
	base.m_pnlObjectDrawMainHud:Dock(TOP)
	base.m_pnlObjectDrawMainHud:DockMargin(5,5,5,5)

	base.m_pnlObjectDrawPlayerHud = vgui.Create( "DCheckBoxLabel", base.main)
	base.m_pnlObjectDrawPlayerHud:SetConVar( "srp_hud_playernames" )
	base.m_pnlObjectDrawPlayerHud:SetText( "HUD: Имена игроков" )
	base.m_pnlObjectDrawPlayerHud:Dock(TOP)
	base.m_pnlObjectDrawPlayerHud:DockMargin(5,5,5,5)

	base.m_pnlObjectDrawScheduleHud = vgui.Create( "DCheckBoxLabel", base.main)
	base.m_pnlObjectDrawScheduleHud:SetConVar( "srp_hud_shedule" )
	base.m_pnlObjectDrawScheduleHud:SetText( "HUD: Расписание" )
	base.m_pnlObjectDrawScheduleHud:Dock(TOP)
	base.m_pnlObjectDrawScheduleHud:DockMargin(5,5,5,5)

	base.m_pnlObjectDrawWeaponHud = vgui.Create( "DCheckBoxLabel", base.main)
	base.m_pnlObjectDrawWeaponHud:SetConVar( "srp_hud_weapon" )
	base.m_pnlObjectDrawWeaponHud:SetText( "HUD: Выбор оружия" )
	base.m_pnlObjectDrawWeaponHud:Dock(TOP)
	base.m_pnlObjectDrawWeaponHud:DockMargin(5,5,5,5)

	base.m_pnlObjectDrawNotifyHud = vgui.Create( "DCheckBoxLabel", base.main)
	base.m_pnlObjectDrawNotifyHud:SetConVar( "srp_hud_notify" )
	base.m_pnlObjectDrawNotifyHud:SetText( "HUD: Уведомления" )
	base.m_pnlObjectDrawNotifyHud:Dock(TOP)
	base.m_pnlObjectDrawNotifyHud:DockMargin(5,5,5,5)

	-- base.m_pnlObjectDrawNotifyHud = vgui.Create( "DCheckBoxLabel", base.main)
	-- base.m_pnlObjectDrawNotifyHud:SetConVar( "coh_enabled" )
	-- base.m_pnlObjectDrawNotifyHud:SetText( "HUD: Текст над" )
	-- base.m_pnlObjectDrawNotifyHud:Dock(TOP)
	-- base.m_pnlObjectDrawNotifyHud:DockMargin(5,5,5,5)

end

DGF4:RegisterButton(Settings)