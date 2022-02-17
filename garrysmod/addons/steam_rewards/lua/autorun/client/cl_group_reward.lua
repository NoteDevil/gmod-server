surface.CreateFont("GroupReward.Font", {
	font = "Roboto Bold",
	size = 15,
	extended = true,
})

net.Receive( "GroupReward.OpenMenu", function()
	local dframe = vgui.Create('DFrame')
	dframe:SetSize(200, 120)
	dframe:Center()
	dframe:SetTitle("")
	dframe:MakePopup()
	dframe:ShowCloseButton(false)
	dframe.Paint = function(self, w, h)
		draw.SRPBackGround(1, 0, 0, w, h)
		draw.DrawText("Зайди в нашу группу Steam\nи получай 1000 руб. каждый час!", "GroupReward.Font", w/2, 7, color_white, TEXT_ALIGN_CENTER)
	end

	dframe.btn_join = vgui.Create('DButton', dframe)
	dframe.btn_join:SetSize(190, 25)
	dframe.btn_join:SetPos(5, 60)
	dframe.btn_join:SetText('')
	dframe.btn_join.Paint = function(self, w, h)
		if self:IsHovered() then
			draw.SRPBackGround(1, 0, 0, w, h, 150)
			draw.SimpleText("Вступить", "GroupReward.Font", w/2, h/2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		else
			draw.SRPBackGround(1, 0, 0, w, h)
			draw.SimpleText("Вступить", "GroupReward.Font", w/2, h/2, Color(150,150,150), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end
	end
	dframe.btn_join.DoClick = function(self)
		RunConsoleCommand("say","!steam")
	end

	dframe.btn_close = vgui.Create('DButton', dframe)
	dframe.btn_close:SetSize(190, 25)
	dframe.btn_close:SetPos(5, 90)
	dframe.btn_close:SetText('')
	dframe.btn_close.Paint = function(self, w, h)
		if self:IsHovered() then
			draw.SRPBackGround(1, 0, 0, w, h, 150)
			draw.SimpleText("Закрыть", "GroupReward.Font", w/2, h/2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		else
			draw.SRPBackGround(1, 0, 0, w, h)
			draw.SimpleText("Закрыть", "GroupReward.Font", w/2, h/2, Color(150,150,150), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end
	end
	dframe.btn_close.DoClick = function(self)
		dframe:Remove()
	end
end)

srp_util = srp_util or {}
function srp_util.openVK()

	Derma_Query(
		"Ты уже подписан на нашу группу ВК?", "Получить бонус",
		"Да", function()
			Derma_Query(
				"Следуй инструкции в открывшемся окне", "Получить бонус",
				"ОК", function()
					gui.OpenURL("http://rp.octothorp.team/school666/bonus/")
				end
			)
		end,
		"Нет", function()
			Derma_Query(
				"Чтобы получить бонус, в открывшемся окне войди в ВК,\nподпишись на группу и снова напиши в чат !vk", "Группа ВК",
				"ОК", function()
					gui.OpenURL("https://vk.com/schoolrp666")
				end
			)
		end
	)

end
