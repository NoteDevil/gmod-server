local events_vectors = {}
events_vectors["Математика"] = Vector('432.131104 -1715.081177 56.031250')
events_vectors["Биология"] = Vector('39.933464 -2484.304688 56.031254')
events_vectors["История"] = Vector('-1208.143433 -2482.212891 56.031254')
events_vectors["Русский"] = Vector('-1008.096924 -1715.386475 56.031250')
events_vectors["Иностранный"] = Vector('632.407227 -2485.677002 56.031250')
events_vectors["География"] = Vector('-1207.662231 -2484.156006 192.031250')
events_vectors["Физика"] = Vector('432.043976 -1714.676270 192.031250')
events_vectors["Химия"] = Vector('-1008.064270 -1714.973755 192.031250')
events_vectors["Информатика"] = Vector('631.754211 -2484.349854 192.031250')
events_vectors["Культура"] = Vector('-615.968018 -2484.060547 192.031250')
events_vectors["Литература"] = Vector('-1008.340698 -1715.263306 328.031250')
events_vectors["Физра"] = Vector('480.318939 2767.961426 -7.968750')
events_vectors["Труд"] = Vector('1902.781738 688.974426 -7.968750')

surface.CreateFont("srp_evetmarkers.MainFont", {
	font = "Roboto Bold",
	size = 12,
	weight = 500,
})

hook.Add("HUDPaint", "srp_evetmarkers.HUDPaint", function()
	local class = math.max( GetGlobalInt("SRP_Class"), 1 )
	local txt
	local curClass = srp_classes.events[class]
	local nextClass = srp_classes.events[class < #srp_classes.events and (class + 1) or 1]
	if not curClass and not nextClass then return end
	
	local subject = events_vectors[curClass[2][1]] and curClass[2][1] or events_vectors[nextClass[2][1]] and nextClass[2][1]
	local job = RPExtraTeams[LocalPlayer():Team()]
	if job.pupil or job.subject and job.subject == subject then 
		local vec = events_vectors[subject]
		if not vec then return end

		local dist = math.floor(LocalPlayer():GetPos():Distance(vec) / 40)
		local pos = vec:ToScreen()
		pos.x, pos.y = math.floor(pos.x), math.floor(pos.y)
		-- draw.RoundedBox(4, pos.x-4, pos.y-4, 8, 8, color_white )
		draw.DrawText(subject.."\n"..dist.."м", "srp_evetmarkers.MainFont", pos.x, pos.y, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end
end)