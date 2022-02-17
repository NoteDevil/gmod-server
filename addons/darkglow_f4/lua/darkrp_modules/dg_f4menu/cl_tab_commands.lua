local comGroup = {
	{
		id = "civil",
		name = DGF4.Translation.citizens,
		color = Color(50,150,50),
		check = function(ply, pnl)
			return true
		end
	},
	{
		id = "cp",
		name = DGF4.Translation.police,
		color = Color(45,115,195),
		check = function(ply, pnl)
			return ply:isCP()
		end
	},
	{
		id = "mayor",
		name = DGF4.Translation.mayor,
		color = Color(155,45,45),
		check = function(ply, pnl)
			return ply:isMayor()
		end
	},
}

local cmds = {}
cmds["civil"] = {
	{
		name = DGF4.Translation.drop_money,
		doClick = function(ply, pnl)
			Derma_StringRequest(
				DGF4.Translation.drop_money,
				DGF4.Translation.drop_money_desc,
				"",
				function(text) if !ply:canAfford(tonumber(text)) then return end ply:ConCommand("say /dropmoney "..text) end
			)
		end
	},
	{
		name = DGF4.Translation.give_money,
		doClick = function(ply, pnl)
			Derma_StringRequest(
				DGF4.Translation.give_money,
				DGF4.Translation.give_money_desc,
				"",
				function(text) if !ply:canAfford(tonumber(text)) then return end ply:ConCommand("say /give "..text) end
			)
		end
	},
	{
		name = DGF4.Translation.sell_doors,
		doClick = function(ply, pnl)
			ply:ConCommand("say /unownalldoors")
		end
	},
	{
		name = DGF4.Translation.change_rp_name,
		doClick = function(ply, pnl)
			Derma_StringRequest(
				DGF4.Translation.change_rp_name,
				DGF4.Translation.change_rp_name_desc,
				"",
				function(text) ply:ConCommand("say /rpname "..text) end
			)
		end
	},
	{
		name = DGF4.Translation.drop_weapon,
		doClick = function(ply, pnl)
			ply:ConCommand("say /dropweapon")
		end
	},
	{
		name = DGF4.Translation.demote_player,
		doClick = function(ply, pnl)
			local menu = vgui.Create("UPMenu", pnl)
				for _,v in pairs (player.GetAll()) do
					menu:AddOption( v:Name(), function()
						Derma_StringRequest(DGF4.Translation.demote_player, DGF4.Translation.demote_player_desc, "", function(reason)
							ply:ConCommand("say /demote "..v:Name().." "..reason)
						end)
					end )
				end
			menu:Open()
		end
	},
	{
		name = "Получить дневник",
		doClick = function(ply, pnl)
			ply:ConCommand("say /diary")
		end
	},

}
cmds["cp"] = {
	{
		name = DGF4.Translation.start_warrant,
		doClick = function(ply, pnl)
			local menu = vgui.Create("UPMenu", pnl)
				for _,v in pairs (player.GetAll()) do
					menu:AddOption( v:Name(), function()
						Derma_StringRequest(DGF4.Translation.start_warrant,DGF4.Translation.start_warrant_desc, "", function(reason)
							ply:ConCommand("say /warrant "..v:Name().." "..reason.."")
						end)
					end )
				end
			menu:Open()
		end
	},
	{
		name = DGF4.Translation.make_wanted,
		doClick = function(ply, pnl)
			local menu = vgui.Create("UPMenu", pnl)
				for _,v in pairs (player.GetAll()) do
					menu:AddOption( v:Name(), function()
						Derma_StringRequest(DGF4.Translation.make_wanted, DGF4.Translation.make_wanted_desc, "", function(reason)
							ply:ConCommand("say /wanted "..v:Name().." "..reason.."")
						end)
					end )
				end
			menu:Open()
		end
	},
	{
		name = DGF4.Translation.give_license,
		doClick = function(ply, pnl)
			ply:ConCommand("say /givelicense")
		end
	},
}

cmds["mayor"] = {
	{
		name = DGF4.Translation.place_law_board,
		doClick = function(ply, pnl)
			ply:ConCommand("say /placelaws")
		end
	},
	{
		name = DGF4.Translation.add_law,
		doClick = function(ply, pnl)
			Derma_StringRequest(DGF4.Translation.add_law, DGF4.Translation.add_law_desc, "", function(law)
				ply:ConCommand("say /addlaw "..law)
			end)
		end
	},
	{
		name = DGF4.Translation.remove_law,
		doClick = function(ply, pnl)
			Derma_StringRequest(DGF4.Translation.remove_law, DGF4.Translation.remove_law_desc, "", function(number)
				ply:ConCommand("say /removelaw "..number)
			end)
		end
	},
	{
		name = DGF4.Translation.start_lockdown,
		doClick = function(ply, pnl)
			ply:ConCommand("say /lockdown")
		end
	},
	{
		name = DGF4.Translation.stop_lockdown,
		doClick = function(ply, pnl)
			ply:ConCommand("say /unlockdown")
		end
	},
	{
		name = DGF4.Translation.start_lottery,
		doClick = function(ply, pnl)
			Derma_StringRequest(DGF4.Translation.start_lottery, DGF4.Translation.start_lottery_desc, "", function(num)
				ply:ConCommand("say /lottery "..num)
			end)
		end
	},
}


if !DGF4.RegisterButton then return end
local commands = {}
commands.pos = 30
commands.name = DGF4.Translation.commands
commands.col = Color(255,36,0)
commands.wide = ScrW() - 400
commands.callBack = function(self)
	local x, y, ply = ScrW(), ScrH(), LocalPlayer()
	local base = DGF4.BaseElement(self, commands.name, commands.col, commands.wide)
	local btn = {}
	/* --- BASE END --- */

	base["commands"] = vgui.Create( "DScrollPanel", base )
	base["commands"]:SetSize( commands.wide-10, y-70 )
	base["commands"]:SetPos( 5, 0 )
	base["commands"].VBar:SetWide(0)

	base["list"] = vgui.Create( "DIconLayout", base["commands"] )
	base["list"]:SetSize(commands.wide, y-70 )
	base["list"]:SetPos( 0, 5 )
	base["list"]:SetSpaceY( 5 )
	base["list"]:SetSpaceX( 5 )

	base["civ_header"]= base["list"]:Add("DLabel")
	base["civ_header"]:SetText("")
	base["civ_header"]:SetSize(commands.wide, 30)
	base["civ_header"].Paint = function(slf, w, h)
		draw.SimpleText(comGroup[1]["name"], "ButtonsF4Menu", w/2-10, h/2, comGroup[1]["color"], 1, 1)
	end

	for k,v in pairs(cmds["civil"]) do
		local color_of_panel = Color(0,0,0,100)

		btn["panel_civ"] = base["list"]:Add("DPanel")
		btn["panel_civ"]:SetSize(commands.wide-10, 30)
		btn["panel_civ"].Paint = function()
			draw.RoundedBox(4,0,0,btn["panel_civ"]:GetWide(), btn["panel_civ"]:GetTall(), color_of_panel)
		end
		btn["civ"..k] = vgui.Create("DButton", btn["panel_civ"])
		btn["civ"..k]:SetFont("Trebuchet24")
		btn["civ"..k]:SetText(v.name)
		btn["civ"..k]:SetSize(btn["panel_civ"]:GetWide(), btn["panel_civ"]:GetTall())
		btn["civ"..k]:SetColor(Color(255,255,255))
		btn["civ"..k].DoClick = function()
			v.doClick(ply, base)
		end
		btn["civ"..k].Paint = function()
		end
		btn["civ"..k].OnCursorEntered = function()
			color_of_panel = Color(0,0,0,200)
		end
		btn["civ"..k].OnCursorExited = function()
			color_of_panel = Color(0,0,0,100)
		end
	end
	if LocalPlayer():isCP() || LocalPlayer():isMayor() then
		base["cp_header"]= base["list"]:Add("DLabel")
		base["cp_header"]:SetText("")
		base["cp_header"]:SetSize(commands.wide, 30)
		base["cp_header"].Paint = function(slf, w, h)
			draw.SimpleText(comGroup[2]["name"], "ButtonsF4Menu", w/2-10, h/2, comGroup[2]["color"], 1, 1)
		end

		for k,v in pairs(cmds["cp"]) do
			local color_of_panel = Color(0,0,0,100)

			btn["panel_cp"] = base["list"]:Add("DPanel")
			btn["panel_cp"]:SetSize(commands.wide-10, 30)
			btn["panel_cp"].Paint = function()
				draw.RoundedBox(4,0,0,btn["panel_cp"]:GetWide(), btn["panel_cp"]:GetTall(), color_of_panel)
			end
			btn["cp"..k] = vgui.Create("DButton", btn["panel_cp"])
			btn["cp"..k]:SetFont("Trebuchet24")
			btn["cp"..k]:SetText(v.name)
			btn["cp"..k]:SetSize(btn["panel_cp"]:GetWide(), btn["panel_cp"]:GetTall())
			btn["cp"..k]:SetColor(Color(255,255,255))
			btn["cp"..k].DoClick = function()
				v.doClick(ply, base)
			end
			btn["cp"..k].Paint = function()
			end
			btn["cp"..k].OnCursorEntered = function()
				color_of_panel = Color(0,0,0,200)
			end
			btn["cp"..k].OnCursorExited = function()
				color_of_panel = Color(0,0,0,100)
			end
		end
	end

	if LocalPlayer():isMayor() then
		base["mayor_header"]= base["list"]:Add("DLabel")
		base["mayor_header"]:SetText("")
		base["mayor_header"]:SetSize(commands.wide, 30)
		base["mayor_header"].Paint = function(slf, w, h)

			draw.SimpleText(comGroup[3]["name"], "ButtonsF4Menu", w/2-10, h/2, comGroup[3]["color"], 1, 1)
		end

		for k,v in pairs(cmds["mayor"]) do
			local color_of_panel = Color(0,0,0,100)

			btn["panel_mayor"] = base["list"]:Add("DPanel")
			btn["panel_mayor"]:SetSize(commands.wide-10, 30)
			btn["panel_mayor"].Paint = function()
				draw.RoundedBox(4,0,0,btn["panel_mayor"]:GetWide(), btn["panel_mayor"]:GetTall(), color_of_panel)
			end
			btn["mayor"..k] = vgui.Create("DButton", btn["panel_mayor"])
			btn["mayor"..k]:SetFont("Trebuchet24")
			btn["mayor"..k]:SetText(v.name)
			btn["mayor"..k]:SetSize(btn["panel_mayor"]:GetWide(), btn["panel_mayor"]:GetTall())
			btn["mayor"..k]:SetColor(Color(255,255,255))
			btn["mayor"..k].DoClick = function()
				v.doClick(ply, base)
			end
			btn["mayor"..k].Paint = function()
			end
			btn["mayor"..k].OnCursorEntered = function()
				color_of_panel = Color(0,0,0,200)
			end
			btn["mayor"..k].OnCursorExited = function()
				color_of_panel = Color(0,0,0,100)
			end
		end
	end
end

DGF4:RegisterButton(commands)
