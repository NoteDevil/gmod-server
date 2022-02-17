local my_language = {
	-- Admin things
	need_admin = "Чтобы %s, нужно быть администратором",
	need_sadmin = "Чтобы %s, нужно быть суперадминистратором",
	no_privilege = "У тебя нет нужных привилегий",
	no_jail_pos = "Нет тюрьмы",
	invalid_x = "%s содержит ошибку! %s",

	-- F1 menu
	f1ChatCommandTitle = "Команды для чата",
	f1Search = "Поиск...",

	-- Money things:
	price = "Цена: %s%d",
	priceTag = "Цена: %s",
	reset_money = "%s обнулил все кошельки",
	has_given = "%s дал тебе %s",
	you_gave = "Ты дал %s %s",
	npc_killpay = "%s за убийство персонажа!",
	profit = "profit",
	loss = "loss",

	-- backwards compatibility
	deducted_x = "Вычтено %s%d",
	need_x = "Нужно %s%d",

	deducted_money = "Вычтено %s",
	need_money = "Нужно %s",

	payday_message = "Зарплата! Ты получил %s!",
	payday_unemployed = "Ты сегодня без зарплаты. Иди работай!",
	payday_missed = "Ты сегодня без зарплаты. В тюрьме не платят.",

	property_tax = "Налог на собственность! %s",
	property_tax_cant_afford = "Ты не смог оплатить налоги и теперь у тебя нет собственности!",
	taxday = "День налогов! %s%% изъято из твоей зарплаты!",

	found_cheque = "Ты нашёл чек на %s%s выписанный тебе от %s.",
	cheque_details = "Этот чек выписан игроку %s.",
	cheque_torn = "Ты разорвал чек.",
	cheque_pay = "Кому: %s",
	signed = "От: %s",

	found_cash = "Ты нашел %s%d!", -- backwards compatibility
	found_money = "Ты нашел %s!",

	owner_poor = "The %s owner is too poor to subsidize this sale!",

	-- Police
	Wanted_text = "В розыске!",
	wanted = "Разыскивается полицией!\nЗа %s",
	youre_arrested = "Ты арестован на %d секунд!",
	youre_arrested_by = "Ты арестован игроком %s.",
	youre_unarrested_by = "Ты был отпущен игроком %s.",
	hes_arrested = "%s арестован на %d секунд!",
	hes_unarrested = "%s выпущен из тюрьмы!",
	warrant_ordered = "%s дал ордер на обыск игрока %s. Причина: %s",
	warrant_request = "%s запросил ордер на обыск игрока %s\nПричина: %s",
	warrant_request2 = "Запрос на обыск отправлен директору %s!",
	warrant_approved = "Запрос на обыск игрока %s подтверждён!\nПричина: %s\nЗапросил: %s",
	warrant_approved2 = "Теперь ты можешь обыскать его дом.",
	warrant_denied = "Директор %s отклонил твой запрос на обыск.",
	warrant_expired = "Ордер на обыск игрока %s истёк!",
	warrant_required = "Чтобы открыть эту дверь, нужен ордер на обыск.",
	warrant_required_unfreeze = "Чтобы разморозить этот проп, нужен ордер на обыск.",
	warrant_required_unweld = "Чтобы открепить этот проп, нужен ордер на обыск.",
	wanted_by_police = "%s разыскивается полицией!\nПричина: %s\nЗапросил: %s",
	wanted_by_police_print = "%s подал в розыск на %s. Причина: %s",
	wanted_expired = "%s больше не разыскивается.",
	wanted_revoked = "%s больше не разыскивается.\nРозыск отозвал: %s",
	cant_arrest_other_cp = "Ты не можешь арестовывать других копов!",
	must_be_wanted_for_arrest = "Чтобы арестовать игрока, он должен быть в розыске.",
	cant_arrest_fadmin_jailed = "Ты не можешь арестовать игрока, который был посажен в тюрьму админом.",
	cant_arrest_no_jail_pos = "Ты не можешь арестовывать игроков — нет тюрьмы!",
	cant_arrest_spawning_players = "Ты не можешь арестовывать игроков на спауне.",

	suspect_doesnt_exist = "Подозреваемый не найден.",
	actor_doesnt_exist = "Преступник не найден.",
	get_a_warrant = "получить ордер",
	make_someone_wanted = "подать в розыск",
	remove_wanted_status = "убрать из розыска",
	already_a_warrant = "Ордер на обыск этого подозреваемого уже в действии.",
	already_wanted = "Подозреваемый уже в розыске.",
	not_wanted = "Подозреваемый не разыскивается.",
	need_to_be_cp = "Ты должен быть копом.",
	suspect_must_be_alive_to_do_x = "Подозреваемый должен быть жив для %s.",
	suspect_already_arrested = "Подозреваемый уже в тюрьме.",

	-- Players
	health = "Здоровье: %s",
	job = "Профессия: %s",
	salary = "Зарплата: %s%s",
	wallet = "Кошелёк: %s%s",
	weapon = "Оружие: %s",
	kills = "Убийства: %s",
	deaths = "Смерти: %s",
	rpname_changed = "%s сменил своё ролевое имя на %s",
	disconnected_player = "Ушедший игрок",

	-- Teams
	need_to_be_before = "Нужно иметь профессию %s, чтобы получить профессию %s",
	need_to_make_vote = "Чтобы получить профессию %s, нужно создать голосование!",
	team_limit_reached = "Невозможно получить профессию %s из-за лимита",
	wants_to_be = "%s\nхочет получить профессию\n%s",
	has_not_been_made_team = "%s не получил профессию %s!",
	job_has_become = "%s получил профессию %s!",

	-- Disasters
	meteor_approaching = "ВНИМАНИЕ: Метеоритный дождь!",
	meteor_passing = "Метеоритный дождь закончился.",
	meteor_enabled = "Метеоритные дожди включены.",
	meteor_disabled = "Метеоритные дожди выключени.",
	earthquake_report = "Earthquake reported of magnitude %sMw",
	earthtremor_report = "Earth tremor reported of magnitude %sMw",

	-- Keys, vehicles and doors
	keys_allowed_to_coown = "Ты один из совладельцев\n(Нажми F2 для покупки)\n",
	keys_other_allowed = "Совладельцы:",
	keys_allow_ownership = "(Нажми F2 для добавление совладельцев)",
	keys_disallow_ownership = "(Нажми F2 для удаления совладельцев)",
	keys_owned_by = "Владелец:",
	keys_unowned = "F2 – приобрести",
	keys_everyone = "(Нажми F2 для разрешения покупки всем)",
	door_unown_arrested = "Ты не можешь ничего делать под арестом!",
	door_unownable = "С этой дверью нельзя ничего сделать!",
	door_sold = "Ты продал дверь за %s",
	door_already_owned = "Эта дверь уже кому-то пренадлежит!",
	door_cannot_afford = "Ты не можешь позволить себе эту дверь!",
	door_hobo_unable = "Ты бомж, ты не можешь купить дверь!",
	vehicle_cannot_afford = "Ты не можешь позволить себе этот транспорт!",
	door_bought = "Ты купил дверь за %s%s",
	vehicle_bought = "Ты купил транспорт за %s%s",
	door_need_to_own = "Ты должен владеть этой дверью, чтобы делать %s",
	door_rem_owners_unownable = "Ты не можешь убирать совладельцев, с этой дверью нельзя ничего сделать!",
	door_add_owners_unownable = "Ты не можешь добавлять совладельцев, с этой дверью нельзя ничего сделать!",
	rp_addowner_already_owns_door = "%s уже является совладельцем этой двери!",
	add_owner = "Добавить совладельца",
	remove_owner = "Удалить совладельца",
	coown_x = "Co-own %s",
	allow_ownership = "Разрешить покупку",
	disallow_ownership = "Запретить покупку",
	edit_door_group = "Редактировать группы",
	door_groups = "Группы дверей",
	door_group_doesnt_exist = "Группа дверей не существует!",
	door_group_set = "Группы двери отредактированы.",
	sold_x_doors_for_y = "Ты продал %d дверей за %s%d!", -- backwards compatibility
	sold_x_doors = "Ты продал %d дверей за %s!",

	-- Entities
	drugs = "Наркотики",
	drug_lab = "Лаборатория",
	gun_lab = "Станок",
	gun = "оружие",
	microwave = "Микроволновка",
	food = "Еда",
	money_printer = "Принтер",

	sign_this_letter = "Подписать письмо",
	signed_yours = "Ваш,",

	money_printer_exploded = "Твой принтер взорвался!",
	money_printer_overheating = "Твой принтер перегрелся!",

	contents = "Содержимое: ",
	amount = "Количество: ",

	picking_lock = "Взлом",

	cannot_pocket_x = "Ты не можешь положить это в карман!",
	object_too_heavy = "Этот предмет слишком тяжёлый.",
	pocket_full = "Твой карман полон!",
	pocket_no_items = "В твоём кармане ничего нет.",
	drop_item = "Положить предмет",

	bonus_destroying_entity = "уничтожение нелегальщины.",

	switched_burst = "Переключено на режим стрельбы очередями.",
	switched_fully_auto = "Переключено в автоматический режим стрельбы.",
	switched_semi_auto = "Переключено в полуавтоматический режим стрельбы.",

	keypad_checker_shoot_keypad = "Выстрели в кейпад, чтобы увидеть чем он управляет.",
	keypad_checker_shoot_entity = "Выстрели в предмет, чтобы увидеть какие кейпады им управляют",
	keypad_checker_click_to_clear = "Right click to clear.",
	keypad_checker_entering_right_pass = "Ввод правильного пароля",
	keypad_checker_entering_wrong_pass = "Ввод неправильного пароля",
	keypad_checker_after_right_pass = "после ввода правильного пароля",
	keypad_checker_after_wrong_pass = "после ввода неправильного пароля",
	keypad_checker_right_pass_entered = "Введён правильный пароль",
	keypad_checker_wrong_pass_entered = "Введён неправильный пароль",
	keypad_checker_controls_x_entities = "Этот кейпад управляет %d предметами",
	keypad_checker_controlled_by_x_keypads = "Этот предмет управляется %d кейпадами",
	keypad_on = "ВКЛ.",
	keypad_off = "ВЫКЛ.",
	seconds = "сек.",

	persons_weapons = "%s имеет при себе нелегальное оружие:",
	returned_persons_weapons = "Ты вернул игроку %s конфискованное у него оружие.",
	no_weapons_confiscated = "У игрока %s ничего не было конфисковано!",
	no_illegal_weapons = "%s не имеет при себе нелегального оружия.",
	confiscated_these_weapons = "Ты конфисковал:",
	checking_weapons = "Конфискация",

	shipment_antispam_wait = "Подожди немного прежде чем покупать ещё один ящик.",
	shipment_cannot_split = "Этот ящик нельзя разделить.",

	-- Talking
	hear_noone = "Тебя никто не слышит!",
	hear_everyone = "Тебя все слышат!",
	hear_certain_persons = "Тебя слышат: ",

	whisper = "шёпот",
	yell = "крик",
	advert = "[реклама]",
	broadcast = "[трансляция]",
	radio = "радио",
	request = "[запрос]",
	group = "[группа]",
	demote = "[увольнение]",
	ooc = "OOC",
	radio_x = "Радио %d",

	talk = "talk",
	speak = "speak",

	speak_in_ooc = "говорить в OOC",
	perform_your_action = "совершить действие",
	talk_to_your_group = "говорить с группой",

	channel_set_to_x = "Радио настроено на канал %s!",

	-- Notifies
	disabled = "%s отключено! %s",
	gm_spawnvehicle = "The spawning of vehicles",
	gm_spawnsent = "The spawning of scripted entities (SENTs)",
	gm_spawnnpc = "The spawning of Non-Player Characters (NPCs)",
	see_settings = "Посмотри в настройки DarkRP.",
	limit = "Многовато у тебя %s!",
	have_to_wait = "Надо подождать %dс перед использованием %s!",
	must_be_looking_at = "Для выполнения этого действия нужно смотреть на игрока.",
	incorrect_job = "Твоя профессия не позволяет тебе это сделать.",
	unavailable = "Это %s недоступно",
	unable = "Ты не можешь %s. %s",
	cant_afford = "Маловато деньжат для %s",
	created_x = "%s создал %s",
	cleaned_up = "Твои %s были убраны.",
	you_bought_x = "Ты купил %s за %s%d.", -- backwards compatibility
	you_bought = "Ты купил %s за %s.",
	you_received_x = "Ты получил %s за %s.",

	created_first_jailpos = "You have created the first jail position!",
	added_jailpos = "You have added one extra jail position!",
	reset_add_jailpos = "You have removed all jail positions and you have added a new one here.",
	created_spawnpos = "%s's spawn position created.",
	updated_spawnpos = "%s's spawn position updated.",
	do_not_own_ent = "You do not own this entity!",
	cannot_drop_weapon = "Это оружие нельзя выбросить.",
	job_switch = "Jobs switched successfully!",
	job_switch_question = "Switch jobs with %s?",
	job_switch_requested = "Job switch requested.",

	cooks_only = "Только для поваров.",

	-- Misc
	unknown = "Неизвестный",
	arguments = "аргумент",
	no_one = "ни один",
	door = "дверь",
	vehicle = "транспорт",
	door_or_vehicle = "дверь/транспорт",
	driver = "Водитель: %s",
	name = "Имя: %s",
	locked = "Закрыто.",
	unlocked = "Открыто.",
	player_doesnt_exist = "Игрок не существует.",
	job_doesnt_exist = "Профессия не существует!",
	must_be_alive_to_do_x = "Ты должен быть живым, чтобы делать %s.",
	banned_or_demoted = "Забанен/уволен",
	wait_with_that = "Погоди с этим.",
	could_not_find = "Не найден %s",
	f3tovote = "Нажми F3 для голосования",
	listen_up = "Слушай сюда:", -- In rp_tell or rp_tellall
	nlr = "New Life Rule: Do Not Revenge Arrest/Kill.",
	reset_settings = "Ты сбросил все настройки!",
	must_be_x = "Ты должен быть %s, чтобы делать %s.",
	agenda_updated = "Повестка обновлена",
	job_set = "%s сделал '%s' своей профессией",
	demoted = "%s был уволен",
	demoted_not = "%s не был уволен",
	demote_vote_started = "%s начал голосование за увольнение игрока %s",
	demote_vote_text = "Кандидат на увольнение:\n%s", -- '%s' is the reason here
	cant_demote_self = "Ты не можешь уволить себя.",
	i_want_to_demote_you = "Я хочу тебя уволить. Причина: %s",
	tried_to_avoid_demotion = "Ты пытался избежать увольнения, но у тебя не получилось.", -- naughty boy!
	lockdown_started = "Директор объявил комендатский час! Все по домам!",
	lockdown_ended = "Комендантский час окончен.",
	gunlicense_requested = "%s запросил лицензию у игрока %s",
	gunlicense_granted = "%s выдал лицензию игроку %s",
	gunlicense_denied = "%s отказал в выдаче лицензии игроку %s",
	gunlicense_question_text = "Дать лицензию игроку %s?",
	gunlicense_remove_vote_text = "%s начал голосование на отзыв лицензии у игрока %s",
	gunlicense_remove_vote_text2 = "Отозвать лицензию:\n%s", -- Where %s is the reason
	gunlicense_removed = "Лицензия игрока %s была отозвана!",
	gunlicense_not_removed = "Лицензия игрока %s не была отозвана!",
	vote_specify_reason = "Ты должен определить причину!",
	vote_started = "Голосование создано",
	vote_alone = "Ты победил в голосовании, ты же один на сервере, лол.",
	you_cannot_vote = "Ты не можешь голосовать!",
	x_cancelled_vote = "%s отменил последнее голосование.",
	cant_cancel_vote = "Нельзя отменить голосование!",
	jail_punishment = "Наказание за побег! Арестован на %d сек.",
	admin_only = "Только для админов!", -- When doing /addjailpos
	chief_or = "Шеф или ",-- When doing /addjailpos
	frozen = "Заморожен.",

	dead_in_jail = "Ты мёртв, пока не выйдёшь из тюрьмы!",
	died_in_jail = "%s скончался в тюрьме!",

	credits_for = "CREDITS FOR %s\n",
	credits_see_console = "DarkRP credits printed to console.",

	rp_getvehicles = "Available vehicles for custom vehicles:",

	data_not_loaded_one = "Your data has not been loaded yet. Please wait.",
	data_not_loaded_two = "If this persists, try rejoining or contacting an admin.",

	cant_spawn_weapons = "You cannot spawn weapons.",
	drive_disabled = "Drive disabled for now.",
	property_disabled = "Property disabled for now.",

	not_allowed_to_purchase = "Ты не можешь это купить.",

	rp_teamban_hint = "rp_teamban [player name/ID] [team name/id]. Use this to ban a player from a certain team.",
	rp_teamunban_hint = "rp_teamunban [player name/ID] [team name/id]. Use this to unban a player from a certain team.",
	x_teambanned_y = "%s has banned %s from being a %s.",
	x_teamunbanned_y = "%s has unbanned %s from being a %s.",

	-- Backwards compatibility:
	you_set_x_salary_to_y = "Ты установил зарплату у %s's на %s%d.",
	x_set_your_salary_to_y = "%s изменил твою зарплату на %s%d.",
	you_set_x_money_to_y = "Ты изменил деньги %s на %s%d.",
	x_set_your_money_to_y = "%s изменил твои деньги на %s%d.",

	you_set_x_salary = "Ты установил зарплату у %s на %s.",
	x_set_your_salary = "%s изменил твою зарплату на %s.",
	you_set_x_money = "Ты установил деньги у %s на %s.",
	x_set_your_money = "%s изменил твои деньги на %s.",
	you_set_x_name = "Ты установил имя у %s на %s",
	x_set_your_name = "%s изменил твое имя на %s",

	someone_stole_steam_name = "Someone is already using your Steam name as their RP name so we gave you a '1' after your name.", -- Uh oh
	already_taken = "Занято :\\",

	job_doesnt_require_vote_currently = "This job does not require a vote at the moment!",

	x_made_you_a_y = "%s has made you a %s!",

	cmd_cant_be_run_server_console = "This command cannot be run from the server console.",

	-- The lottery
	lottery_started = "Лотерея! Принять участие за %s%d?", -- backwards compatibility
	lottery_has_started = "Лотерея! Принять участие за %s?",
	lottery_entered = "Ты принял участие в лотерее за %s",
	lottery_not_entered = "%s не принял участие в лотерее",
	lottery_noone_entered = "Никто не принял участие в лотерее",
	lottery_won = "%s победил в лотерее! Он выиграл %s!",

	-- Animations
	custom_animation = "Custom animation!",
	bow = "Bow",
	dance = "Dance",
	follow_me = "Follow me!",
	laugh = "Laugh",
	lion_pose = "Lion pose",
	nonverbal_no = "Non-verbal no",
	thumbs_up = "Thumbs up",
	wave = "Wave",

	-- Hungermod
	starving = "Нужно поесть!",

	-- AFK
	afk_mode = "Режим AFK",
	salary_frozen = "Твоя зарплата заморожена.",
	salary_restored = "С возвращением! Твоя зарплата восстановлена.",
	no_auto_demote = "Ты не будешь уволен автоматически.",
	youre_afk_demoted = "Ты уволен за долгий AFK. В следующий раз используй /afk.",
	hes_afk_demoted = "%s уволен за долгий AFK.",
	afk_cmd_to_exit = "Введи /afk ещё раз, чтобы выйти из режима AFK.",
	player_now_afk = "%s теперь AFK.",
	player_no_longer_afk = "%s теперь не AFK.",

	-- Hitmenu
	hit = "hit",
	hitman = "Наёмник",
	current_hit = "Цель: %s",
	cannot_request_hit = "Сейчас нанять не получится! %s",
	hitmenu_request = "Заказать",
	player_not_hitman = "Этот игрок не наёмник!",
	distance_too_big = "Слишком далеко.",
	hitman_no_suicide = "Наёмник не станет убивать себя.",
	hitman_no_self_order = "Наёмник не может нанять сам себя.",
	hitman_already_has_hit = "Наёмник уже нанят кем-то.",
	price_too_low = "Цена слишком мала!",
	hit_target_recently_killed_by_hit = "Наёмник убил свою цель,",
	customer_recently_bought_hit = "Наёмник только что был нанят.",
	accept_hit_question = "Принять заказ %s\nна убийство игрока %s за %s%d?", -- backwards compatibility
	accept_hit_request = "Принять заказ %s\nна убийство игрока %s за %s?",
	hit_requested = "Заказ получен!",
	hit_aborted = "Выполнение заказа провалилось! %s",
	hit_accepted = "Заказ принят!",
	hit_declined = "Наёмник отменил заказ!",
	hitman_left_server = "Наёмник ушёл!",
	customer_left_server = "Заказчик ушёл!",
	target_left_server = "Цель ушла!",
	hit_price_set_to_x = "Цена убийства установлена на %s%d.", -- backwards compatibility
	hit_price_set = "Цена убийства установлена на %s.",
	hit_complete = "Заказ игрока %s выполнен!",
	hitman_died = "Наёмник погиб!",
	target_died = "Цель погибла!",
	hitman_arrested = "Наёмник арестован!",
	hitman_changed_team = "Наёмник сменил профессию!",
	x_had_hit_ordered_by_y = "%s был нанят игроком %s",

	-- Vote Restrictions
	hobos_no_rights = "Бомжи не могут голосовать!",
	gangsters_cant_vote_for_government = "Бандиты не могут принимать участие в голосованиях, связанных с государственными делами!",
	government_cant_vote_for_gangsters = "Члены государственного управление не могут принимать участие в голосованиях, связанных с бандитскими делами!",

	-- VGUI and some more doors/vehicles
	vote = "Vote",
	time = "Время: %d",
	yes = "Да",
	no = "Нет",
	ok = "Ок",
	cancel = "Отмена",
	add = "Добавить",
	remove = "Удалить",
	none = "None",

	x_options = "Настроить %s",
	sell_x = "Продать %s",
	set_x_title = "Назвать %s",
	set_x_title_long = "Назвать %s, на которую ты сейчас смотришь.",
	jobs = "Профессии",
	buy_x = "Купить %s",

	-- F4menu
	no_extra_weapons = "This job has no extra weapons.",
	become_job = "Become job",
	create_vote_for_job = "Create vote",
	shipments = "Shipments",
	F4guns = "Weapons",
	F4entities = "Miscellaneous",
	F4ammo = "Ammo",
	F4vehicles = "Vehicles",

	-- Tab 1
	give_money = "Give money to the player you're looking at",
	drop_money = "Drop money",
	change_name = "Change your DarkRP name",
	go_to_sleep = "Go to sleep/wake up",
	drop_weapon = "Drop current weapon",
	buy_health = "Buy health(%s)",
	request_gunlicense = "Request gunlicense",
	demote_player_menu = "Demote a player",


	searchwarrantbutton = "Make a player wanted",
	unwarrantbutton = "Remove the wanted status from a player",
	noone_available = "No one available",
	request_warrant = "Request a search warrant for a player",
	make_wanted = "Make someone wanted",
	make_unwanted = "Make someone unwanted",
	set_jailpos = "Set the jail position",
	add_jailpos = "Add a jail position",

	set_custom_job = "Set a custom job (press enter to activate)",

	set_agenda = "Set the agenda (press enter to activate)",

	initiate_lockdown = "Объявить комендантский час",
	stop_lockdown = "Отменить комендантский час",
	start_lottery = "Начать лотерею",
	give_license_lookingat = "Give <lookingat> a gun license",

	laws_of_the_land = "УСТАВ ШКОЛЫ",
	law_added = "Правило добавлено",
	law_removed = "Пункт правил убран",
	law_reset = "Устав переиздан",
	law_too_short = "Сликом короткое правило",
	laws_full = "СЛИШКОМ МНОГО ПРАВИЛ!!!",
	default_law_change_denied = "Нельзя изменять стандартные правила",

	-- Second tab
	job_name = "Name: ",
	job_description = "Description: ",
	job_weapons = "Weapons: ",

	-- Entities tab
	buy_a = "Buy %s: %s",

	-- Licenseweaponstab
	license_tab = [[License weapons

	Tick the weapons people should be able to get WITHOUT a license!
	]],
	license_tab_other_weapons = "Другое оружие:",

	zombie_spawn_removed = "You have removed this zombie spawn.",
	zombie_spawn = "Zombie Spawn",
	zombie_disabled = "Zombies are now disabled.",
	zombie_enabled = "Zombies are now enabled.",
	zombie_maxset = "Maximum amount of zombies is now set to %s",
	zombie_spawn_added = "You have added a zombie spawn.",
	zombie_spawn_not_exist = "Zombie Spawn %s does not exist.",
	zombie_leaving = "Zombies are leaving.",
	zombie_approaching = "WARNING: Zombies are approaching!",
	zombie_toggled = "Zombies toggled.",
}

-- The language code is usually (but not always) a two-letter code. The default language is "en".
-- Other examples are "nl" (Dutch), "de" (German)
-- If you want to know what your language code is, open GMod, select a language at the bottom right
-- then enter gmod_language in console. It will show you the code.
-- Make sure language code is a valid entry for the convar gmod_language.
DarkRP.addLanguage("en", my_language)
