local enabled_notify = CreateClientConVar("srp_hud_notify", "1", true)

local cache = {}

ease = {}
function ease.quadOut( t, b, c, d )

	t = t / d;
	return -c * t * (t - 2) + b

end

surface.CreateFont( "srp_notifications", {
	font = "Roboto Bold",
	size = 19,
	weight = 500,
	extended = true,
})

local function addNotification( msgText, msgType, msgTime )

	if IsValid( LocalPlayer() ) then
		LocalPlayer():EmitSound( "buttons/blip1.wav", 75, math.random( 90,110 ), 0.5 )
	end

	table.insert( cache, 1, {
		startTime = CurTime(),
		removeTime = CurTime() + msgTime + 1.5,
		text = markup.Parse( "<font=srp_notifications>" .. msgText .. "</font>", 400 ),
		type = msgType,
		a = 0,
	})

	local cleanText = string.gsub( msgText, "<.->", "" )
	MsgC( Color(200,150,50), "УВЕДОМЛЕНИЕ", Color(200,200,200), ": " .. cleanText .. "\n" )
	if chatgui and istable(chatbox) and chatbox.ProcessAddText then
		chatbox.ProcessAddText( Color(200,150,50), "УВЕДОМЛЕНИЕ", Color(200,200,200), ": " .. cleanText )
	end

end

notification.AddLegacy = addNotification

net.Receive( "srp_notifications.notify", function()

	local msgType = net.ReadUInt(4)
	local msgTime = net.ReadUInt(16)
	local msgText = net.ReadString()

	addNotification( msgText, msgType, msgTime )

end)

hook.Add( "Think", "srp_notifications", function()

	for k, data in pairs( cache ) do
		local lifeTime = CurTime() - data.startTime
		local timeLeft = data.removeTime - CurTime()

		data.a = (lifeTime < 1 and lifeTime) or (timeLeft < 0.5 and (timeLeft * 2)) or 1
		if timeLeft <= 0 then
			table.remove( cache, k )
		end
	end

end)

local icons = {
	[NOTIFY_GENERIC] = Material("icon16/information.png"),
	[NOTIFY_ERROR] = Material("icon16/error.png"),
	[NOTIFY_UNDO] = Material("icon16/arrow_undo.png"),
	[NOTIFY_HINT] = Material("icon16/information.png"),
	[NOTIFY_CLEANUP] = Material("icon16/pill.png"),
}

hook.Add( "HUDPaint", "srp_notifications", function()

	if enabled_notify:GetInt() == 0 then return end

	local drawOrder = {}
	local yoff = 15
	for k, data in pairs( cache ) do
		local st = ease.quadOut( data.a, 0, 1, 1 )
		local w, h = data.text:Size()
		local x, y = (ScrW() - w - 24) / 2, ScrH() - (yoff + h) * st
		yoff = yoff + (h + 15) * st

		table.insert( drawOrder, 1, {
			text = data.text,
			x = math.floor(x), y = math.floor(y),
			w = w, h = h,
			a = st,
			icon = icons[ data.type ],
		})
	end
	table.Reverse( drawOrder )

	for k, data in pairs( drawOrder ) do
		draw.SRPBackGround( 4, data.x - 8, data.y - 5, data.w + 40, data.h + 10, data.a * 255 )
		data.text:Draw( data.x + 24, data.y, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, data.a * 255 )

		surface.SetMaterial( data.icon )
		surface.SetDrawColor( Color(255,255,255) )
		surface.DrawTexturedRect( data.x, data.y + (data.h / 2) - 8, 16, 16 )
	end

end)

local curAdID = 1
local ads = {
	"Нравится сервер? Поддержи его! Нажми <color=50,200,50>F2</color>",
	"Все основные функции (<color=50,200,50>игровой магазин, инвентарь и прочее</color>) находятся в <color=50,200,50>TAB</color>-меню",
	"Если у тебя есть промокод, выбери <color=50,200,50>Погасить код</color> в <color=50,200,50>TAB</color>-меню, чтобы его использовать",
	"Директор может изменять <color=50,200,50>расписание</color>, используя доску в холле школы",
	"Чтобы сесть, нажми <color=50,200,50>Shift+E</color>. Это не работает с физганом в руках",
	"Ты можешь включить вид от третьего лица на <color=50,200,50>F1</color>",
	"Сложно? Открой <color=50,200,50>помощь</color>, в <color=50,200,50>TAB</color>-меню!",
	"Если тебе нужна помощь администрации, напиши в чат <color=50,200,50>@ текст обращения</color>, и тебе помогут",
	"Каждый час мы выдаем награду участникам нашей группы. Её можно найти в <color=50,200,50>TAB</color>-меню",
	"У нас есть донат-магазин c кучей разных плюшек! Нажми <color=50,200,50>F2</color>, чтобы его открыть!",
	"Собирай материалы из <color=50,200,50>мусорок</color> в <color=50,200,50>ящики с деталями</color>, чтобы крафтить разное оружие!",
	"В командах в <color=50,200,50>TAB</color>-меню есть <color=50,200,50>дневник</color>. Получай оценки, чтобы перейти в следующий класс!",
}

timer.Create( "srp_notifications.adverts", 180, 0, function()

	addNotification( ads[ curAdID ], NOTIFY_HINT, 8 )

	curAdID = curAdID + 1
	if curAdID > #ads then curAdID = 1 end

end)
timer.Start( "srp_notifications.adverts" )

hook.Add( "PlayerIsLoaded", "srp_notifications.startNotify", function()

	timer.Simple( 15, function()
		addNotification( "Здесь появляются уведомления и полезные подсказки во время игры", NOTIFY_HINT, 14.5 )
	end)
	timer.Simple( 30, function()
		addNotification( "Все основные функции находятся в <color=50,200,50>TAB</color>-меню", NOTIFY_HINT, 14.5 )
	end)
	timer.Simple( 45, function()
		addNotification( "Каждый час мы выдаем награду участникам группы Steam! Напиши <color=50,200,50>!steam</color> в чат, чтобы открыть", NOTIFY_HINT, 14.5 )
	end)
	timer.Simple( 60, function()
		addNotification( "Мы даем 50$ в донат-магазин и 10 000 игровых рублей за подписку в ВК! Напиши <color=50,200,50>!vk</color> в чат, чтобы узнать больше", NOTIFY_HINT, 14.5 )
	end)

end)
