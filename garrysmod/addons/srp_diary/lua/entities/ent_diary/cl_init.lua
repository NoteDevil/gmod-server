include("shared.lua")

surface.CreateFont("SRP_Diary.TextFont", {
	font = "Cambria",
	size = 20,
	weight = 600,
	italic = true,
	extended = true,
})

net.Receive("SRP_Diary.OpenMenu", function()
	local owner = net.ReadEntity()
	local marks = net.ReadTable()
	local ownerName = IsValid(owner) and owner:Name() or "Владелец вышел"
	local level = IsValid(owner) and owner:GetLevel() or 1

	local dframe = vgui.Create("DFrame")
	dframe:SetSize(800, 600)
	dframe:Center()
	dframe:MakePopup()
	dframe:SetTitle("Дневник ( Владелец: "..ownerName.." )")
	dframe.Paint = function(slf, w, h)
		draw.RoundedBox(0, 0, 0, w, h, Color(24, 117, 175))
	end

	dframe.dpanel = vgui.Create("DPanel", dframe)
	dframe.dpanel:SetSize(dframe:GetWide()/2-10, dframe:GetTall()-35)
	dframe.dpanel:SetPos(5, 30)
	dframe.dpanel.Paint = function(slf, w, h)
		draw.RoundedBox(0, 0, 0, w, h, color_white)

		surface.SetDrawColor(0, 0, 0, 255)
		for i=152, w, 20 do
			surface.DrawLine(i, 0, i, h)
		end

		for i=20, h, 20 do
			surface.DrawLine(0, i, w, i)
		end

		draw.SimpleText(ownerName, "SRP_Diary.TextFont", 10, 0, Color(0,0,0), 0, 0)
		draw.SimpleText("Ученик "..level.." класса", "SRP_Diary.TextFont", 10, 20, Color(0,0,0), 0, 0)

		local i = 3

		for k,v in pairs(SRP_Diary.Subjects) do
			draw.SimpleText(v, "SRP_Diary.TextFont", 2, i*20, Color(0,0,0), 0, 0)

			if marks[v] then
				local j = 8
				for _,z in pairs(marks[v]) do
					if j > 20 then break end
					draw.SimpleText(z, "SRP_Diary.TextFont", j*20-3, i*20, Color(200,0,0), 0, 0)
					j = j + 1
				end
			end

			i = i + 1
		end

		if level < 11 then
			draw.SimpleText("Набери "..SRP_Diary.Levels[level].." баллов по всем предметам", "SRP_Diary.TextFont", 10, 360, Color(0,0,0), 0, 0)
			draw.SimpleText("чтобы поступить в "..tostring(level+1).." класс", "SRP_Diary.TextFont", 10, 380, Color(0,0,0), 0, 0)
		end

		draw.SimpleText("Закончи 11 классов", "SRP_Diary.TextFont", 10, 400, Color(0,0,0), 0, 0)
		draw.SimpleText("чтобы получить награду!", "SRP_Diary.TextFont", 10, 420, Color(0,0,0), 0, 0)
	end

	dframe.dpanel1 = vgui.Create("DPanel", dframe)
	dframe.dpanel1:SetSize(dframe:GetWide()/2-10, dframe:GetTall()-35)
	dframe.dpanel1:SetPos(dframe:GetWide()/2+5, 30)
	dframe.dpanel1.Paint = function(slf, w, h)
		draw.RoundedBox(0, 0, 0, w, h, color_white)

		surface.SetDrawColor(0, 0, 0, 255)
		for i=20, w-125, 20 do
			surface.DrawLine(i, 0, i, h)
		end

		for i=20, h, 20 do
			surface.DrawLine(0, i, w, i)
		end

		local i = 3

		for k,v in pairs(SRP_Diary.Subjects) do
			if marks[v] then
				local j = 1
				for _,z in pairs(marks[v]) do
					if j >= 20 then
						draw.SimpleText(z, "SRP_Diary.TextFont", (j-20)*20+4, i*20, Color(200,0,0), 0, 0)
					end
					j = j + 1
				end
			end

			i = i + 1
		end

		local i = 3
		for k,v in pairs(SRP_Diary.Subjects) do
			draw.SimpleText("Общ."..(owner:GetTotalMarks(marks)[v] or 0), "SRP_Diary.TextFont", w-125, i*20, Color(0,0,0), 0, 0)
			i = i + 1
		end
	end

end)

function ENT:Initialize()
	local owner = self:Getowning_ent()
	local name = IsValid(owner) and owner:Name() or "вышел"
	self.OverlayText = "Дневник - <color=0,200,0>"..name.."</color> \nНажмите <color=0,200,0>".. srp_util.UseKey .."</color>, чтобы открыть"
end
