SRP_Diary = SRP_Diary or {}

SRP_Diary.Subjects = {
	"Математика",
	"Биология",
	"История",
	"Русский",
	"Иностранный",
	"География",
	"Физика",
	"Химия",
	"Информатика",
	"Культура",
	"Литература",
	"Физра",
	"Труд"
}

SRP_Diary.Levels = {
	[1] = 12,
	[2] = 14,
	[3] = 16,
	[4] = 18,
	[5] = 20,
	[6] = 22,
	[7] = 24,
	[8] = 26,
	[9] = 28,
	[10] = 30,
	[11] = 32,
}

local meta = FindMetaTable("Player")

function meta:GetLevel()
	return self:GetNWInt("Level")
end

function meta:GetTotalMarks(marks)
	local tbl = {}
	for k,v in pairs(SRP_Diary.Subjects) do
		local total = 0
		if marks[v] then
			for _,z in pairs(marks[v]) do
				total = total + z
			end
		end
		tbl[v] = total
	end
	return tbl
end