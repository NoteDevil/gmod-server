--
-- POINTSHOP NOTIFICATIONS
--

net.Receive( "srp_donate.PSNotification", function( len )

	local length = net.ReadUInt(8)
	Derma_StringRequest(
		"Сообщение на " .. length .. "мин",
		"Введи текст сообщения длиной до 150 символов:", "",
		function( val )
			net.Start( "srp_donate.PSNotification" )
				net.WriteBool( true )
				net.WriteString( val )
			net.SendToServer()
		end,
		function()
			net.Start( "srp_donate.PSNotification" )
				net.WriteBool( false )
			net.SendToServer()
		end,
		"Отправить", "Отмена"
	)

end)

--
-- POINTSHOP NICK
--

net.Receive("srp_donate.PSNick", function()

	local accepted = false

	local dpanel = vgui.Create("DFrame")
	dpanel:SetTitle("")
	dpanel:ShowCloseButton(true)
	dpanel:SetSize(200,110)
	dpanel:Center()
	dpanel:MakePopup()
	dpanel.Paint = function(self, w, h)
		draw.SRPBackGround(3, 0, 0, w, h)
	end
	dpanel.OnClose = function( self )
		if not accepted then
			net.Start( "srp_donate.PSNick" )
				net.WriteBool( false )
			net.SendToServer()
		end
	end

	dpanel.dcbox = vgui.Create("DComboBox", dpanel)
	dpanel.dcbox:SetSize( 180, 20 )
	dpanel.dcbox:SetPos( 10, 25 )
	dpanel.dcbox:SetValue( "Выберите игрока" )
	for k, v in pairs( player.GetAll() ) do
		dpanel.dcbox:AddChoice( v:Name(), v )
	end

	dpanel.txtentry = vgui.Create("DTextEntry", dpanel)
	dpanel.txtentry:SetSize(180, 20)
	dpanel.txtentry:SetPos( 10, 55)
	dpanel.txtentry:SetValue("Введите кличку")
	dpanel.txtentry.AllowInput = function(self)
		return string.len( self:GetValue() ) > 60
	end

	dpanel.button = vgui.Create("DButton", dpanel)
	dpanel.button:SetSize(100, 20)
	dpanel.button:SetPos( 50, 85)
	dpanel.button:SetText("")
	dpanel.button.DoClick = function(self)
		local name, ply = dpanel.dcbox:GetSelected()
		local nick = dpanel.txtentry:GetValue()
		if string.len(nick) <= 60 then
			if nick != "Введите кличку" and name != "Выберите игрока" then
				net.Start("srp_donate.PSNick")
					net.WriteBool( true )
					net.WriteEntity( ply )
					net.WriteString( nick )
				net.SendToServer()

				accepted = true
				dpanel:Close()
			end
		else
			notification.AddLegacy( "Кличка должна быть <color=50,200,50>короткой</color> и запоминающейся!", NOTIFY_ERROR, 2 )
		end
	end
	dpanel.button.Paint = function(self, w, h)
		draw.SRPBackGround(3, 0, 0, w, h)
		if self:IsHovered() then draw.RoundedBox( 3, 1, 1, w-2, h-2, Color(255,255,255, 10) ) end
		draw.SimpleText( "Готово", "default", w/2, h/2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	end

end)

--
-- GAME MONEY
--

net.Receive( "srp_donate.PSMoney", function( len )

	Derma_StringRequest(
		"Купить валюту",
		"1$ дает тебе 2000р. Сколько $ ты хочешь потратить на валюту?", "",
		function( val )
			net.Start( "srp_donate.PSMoney" )
				net.WriteString( val )
			net.SendToServer()
		end,
		function() end,
		"Купить", "Отмена"
	)

end)

--
-- PLAY TIME REWARD
--

local timeout = 5 * 60
local timeSinceLastPress = 0
local isAFK = false

timer.Create( "srp_donate.afkTick", 1, 0, function()

	timeSinceLastPress = timeSinceLastPress + 1
	if timeSinceLastPress >= timeout and not isAFK then
		-- yeah yeah I know
		net.Start( "srp_donate.imAFK" )
			net.WriteBool( true )
		net.SendToServer()

		isAFK = true
	end

end)

hook.Add( "KeyPress", "srp_donate.afkTick", function( ply )

	if ply == LocalPlayer() then
		if isAFK then
			net.Start( "srp_donate.imAFK" )
				net.WriteBool( false )
			net.SendToServer()

			isAFK = false
		end

		timeSinceLastPress = 0
	end

end)

--
-- PROMOCODES
--

concommand.Add( "srp_promo",  function()

	Derma_StringRequest(
		"Погасить код",
		"Введи свой промокод:", "",
		function( val )
			net.Start( "srp_donate.promo" )
				net.WriteString( val )
			net.SendToServer()
		end,
		function() end,
		"Отправить", "Отмена"
	)

end)

hook.Add( "CanOutfit", "srp_donate.wsmodels", function( ply, info )

	if ply == LocalPlayer() then
		if not LocalPlayer():PS_HasItem('wsmodel') then
			notification.AddLegacy( 'Ты не купил эту плюшку!', NOTIFY_ERROR, 3 )
			return false
		end

		return true
	end

end)

