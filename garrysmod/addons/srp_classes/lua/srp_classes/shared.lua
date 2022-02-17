srp_classes.schedule = {
	{ "Нет урока" },
	{ "Нет урока" },
	{ "Нет урока" },
	{ "Нет урока" },
	{ "Нет урока" },
	{ "Нет урока" },
	{ "Нет урока" },
	{ "Нет урока" },
}

srp_classes.events = {
	{ 0, "Ночь", "Ученики должны находиться в общежитии" },
	{ 7, "Утро", "Не опоздай на первый урок" },
	{ 9, srp_classes.schedule[1], ring = true },
	{ 10, "Перемена", "Не опоздай на следующий урок", ring = true },
	{ 10 + (20 / 60), srp_classes.schedule[2], ring = true },
	{ 11 + (20 / 60), "Большая перемена", "Сходи в столовку, что ли", ring = true },
	{ 12, srp_classes.schedule[3], ring = true },
	{ 13, "Перемена", "Не опоздай на следующий урок" },
	{ 13 + (20 / 60), srp_classes.schedule[4], ring = true },
	{ 14 + (20 / 60), "Перемена", "Не опоздай на следующий урок", ring = true },
	{ 14 + (40 / 60), srp_classes.schedule[5], ring = true },
	{ 15 + (40 / 60), "Перемена", "Не опоздай на следующий урок", ring = true },
	{ 16, srp_classes.schedule[6], ring = true },
	{ 17, "Большая перемена", "Не опоздай на следующий урок", ring = true },
	{ 17 + (20 / 60), srp_classes.schedule[7], ring = true },
	{ 18 + (20 / 60), "Перемена", "Не опоздай на следующий урок", ring = true },
	{ 18 + (40 / 60), srp_classes.schedule[8], ring = true },
	{ 19 + (40 / 60), "Свободное время", "Не гуляй до поздна", ring = true },
	{ 22, "Вечер", "Ученики должны находиться в общежитии" },
}

for i1, v1 in ipairs( srp_classes.schedule ) do
	for i2,v2 in ipairs( srp_classes.events ) do
		if v2[2] == v1 then
			v1[0] = v2[1]
			break
		end
	end
end

function srp_classes.getClassInfo( class )

	if istable( class ) then
		if istable( class[2] ) then
			return { class[1], class[2][1], class[2][2] }
		else
			return { class[1], class[2], class[3] }
		end
	else
		return { -1, "error", "error" }
	end

end

function srp_classes.setClassInfo( class, name, desc )

	if not srp_classes.schedule[ class ] then return end

	-- keep it this way to save links and properly update srp_classes.events
	srp_classes.schedule[ class ][1] = name
	srp_classes.schedule[ class ][2] = desc

	if SERVER then srp_classes.updateClassInfo() end

end

function srp_classes.getCurrentEvent()
	return srp_classes.events[GetGlobalInt("SRP_Class")]
end

local meta = FindMetaTable "Player"

function meta:CanEditSchedule()

	return self:Team() == TEAM_DIRECTOR

end
