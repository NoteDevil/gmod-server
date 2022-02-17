if !DGF4.RegisterButton then return end

local base

local function IsDark(color)
	local val = ((color.r*299)+(color.g*587)+(color.b*114))/1000
	if val < 50 then
		return Color(color.r+75,color.g+75,color.b+75)
	else
		return color
	end
end

local function IsAvailable(job)
	if job.customCheck and not job.customCheck(LocalPlayer()) then return false end
	return true
end

local function DrawJobInfo(job)
	if ValidPanel(base["jobViewPanel"]) then base["jobViewPanel"]:Remove() end
	base["jobViewPanel"] = vgui.Create("DPanel", base)
	base["jobViewPanel"]:SetSize(base:GetWide()/3, base:GetTall() -5 )
	base["jobViewPanel"]:SetPos( base["jobScrollPanel"]:GetWide(), 0 )
	base["jobViewPanel"].Paint = function(self, w, h)
		draw.RoundedBox(0, 0, 0, w, h, Color(0,0,0,100))
		draw.DrawText(job.name, "HeaderMenu", w/2, h/2, IsDark(job.color), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
	end

	local curModel
	if type(job.model) == "table" then
		curModel = table.GetFirstValue( job.model )
	end

	base.icon = vgui.Create( "DModelPanel", base["jobViewPanel"] )
	base.icon:SetSize(base["jobViewPanel"]:GetWide(), base["jobViewPanel"]:GetWide())
	base.icon:SetPos()
	if type(job.model) == "table" then
		base.icon:SetModel( curModel )
	else
		base.icon:SetModel( job.model )
	end
	function base.icon:LayoutEntity( ent )
		ent:SetAngles( Angle(0,45 + math.sin( CurTime() / 2 ) * 25,0) )
	end
	-- function base.icon.Entity:GetPlayerColor() return Vector(1, 0, 0) end

	if type(job.model) == "table" and #job.model > 1 then
		base["prevBtn"] = vgui.Create("DButton", base["jobViewPanel"])
		base["prevBtn"]:SetPos(5, 150)
		base["prevBtn"]:SetSize(50, 50)
		base["prevBtn"]:SetText("<")
		base["prevBtn"]:SetTextColor(Color( 200, 200, 200 ))
		base["prevBtn"]:SetFont("ButtonsF4Menu")
		base["prevBtn"].Paint = function()
		end
		base["prevBtn"].DoClick = function()
			local nextModel = table.FindPrev( job.model, curModel )
			base.icon:SetModel( nextModel )
			curModel = nextModel
		end

		base["nextBtn"] = vgui.Create("DButton", base["jobViewPanel"])
		base["nextBtn"]:SetPos(base["jobViewPanel"]:GetWide() - 50 -5, 150)
		base["nextBtn"]:SetSize(50, 50)
		base["nextBtn"]:SetText(">")
		base["nextBtn"]:SetTextColor(Color( 200, 200, 200 ))
		base["nextBtn"]:SetFont("ButtonsF4Menu")
		base["nextBtn"].Paint = function()
		end
		base["nextBtn"].DoClick = function()
			local nextModel = table.FindNext( job.model, curModel )
			base.icon:SetModel( nextModel )
			curModel = nextModel
		end
	end

	base["descLabel"] = vgui.Create("DLabel", base["jobViewPanel"])
	base["descLabel"]:SetPos(40, base["jobViewPanel"]:GetTall()/2+40) 
	base["descLabel"]:SetText(DarkRP.textWrap(job.description, "DescJob", base["jobViewPanel"]:GetWide()-75))
	base["descLabel"]:SetFont("DescJob")
	base["descLabel"]:SizeToContents() 
	base["descLabel"]:SetTextColor(Color( 200, 200, 200 ))

	base["selectBtn"] = vgui.Create("DButton", base["jobViewPanel"])
	base["selectBtn"]:SetPos(0, base:GetTall()-50)
	base["selectBtn"]:SetSize(base["jobViewPanel"]:GetWide(), 50)
	base["selectBtn"]:SetText("")
	base["selectBtn"].DoClick = function()
		if type(job.model) == "table" then
			for _, team in pairs( team.GetAllTeams() ) do
				if team.Name == job.name then
					DarkRP.setPreferredJobModel(_, curModel)
				end
			end
		end
		if not IsAvailable(job) then return end
		if job.vote then
			RunConsoleCommand("darkrp", "vote"..job.command)
		else
			RunConsoleCommand("darkrp", job.command)
		end
	end
	base["selectBtn"].Paint = function(self, w, h)
		draw.RoundedBox(0, 0, 0, w, h, Color(0,0,0,200))
		if IsAvailable(job) then
			if self:IsHovered() then
				draw.SimpleText( DGF4.Translation.select, "HeaderMenu_Glow", w/2, h/2, Color(255,255,255, 150), 1, 1 )
			end
			draw.SimpleText( DGF4.Translation.select, "HeaderMenu", w/2, h/2, color_white, 1, 1 )
		else
			draw.SimpleText( DGF4.Translation.unavailable, "HeaderMenu", w/2, h/2, Color(100, 100, 100), 1, 1 )
		end
	end
end

local jobs = {}
jobs.pos = 29
jobs.name = DGF4.Translation.jobs
jobs.col = Color(255,36,0)
jobs.wide = ScrW() - 400
jobs.callBack = function(self)
	local x, y, ply = ScrW(), ScrH(), LocalPlayer()
	base = DGF4.BaseElement(self, jobs.name, jobs.col, jobs.wide)
	/* --- BASE END --- */

	base["jobScrollPanel"] = vgui.Create( "DScrollPanel", base )
	base["jobScrollPanel"]:SetSize( base:GetWide()/3*2, base:GetTall() - 5 )
	base["jobScrollPanel"]:SetPos( 0, 0 )

	local vbar = base["jobScrollPanel"]:GetVBar()
	vbar.Paint = function( self, w, h )	end
	vbar.btnGrip.Paint = function( self, w, h )
		local extend = vbar:IsChildHovered() or self.Depressed
		draw.RoundedBox( extend and 4 or 2, extend and 0 or w/2-2, 0, extend and w or 4, h, Color(83,104,112) )
	end
	vbar.btnUp.Paint = function( self, w, h )	end
	vbar.btnDown.Paint = function( self, w, h )	end


	base["jobLayout"] = vgui.Create( "DIconLayout", base["jobScrollPanel"] )
	base["jobLayout"]:SetSize(base["jobScrollPanel"]:GetWide(), base["jobScrollPanel"]:GetTall() )
	base["jobLayout"]:SetPos( 5, 5 )
	base["jobLayout"]:SetSpaceY( 5 )
	base["jobLayout"]:SetSpaceX( 5 )

	local curJob = RPExtraTeams[1]

	for k,v in pairs(DarkRP.getCategories().jobs) do
		if table.Count(v.members) == 0 then continue end
		base["jobCatPanel"] = base["jobLayout"]:Add("DPanel")
		base["jobCatPanel"]:SetSize(base["jobLayout"]:GetWide() - 11, 25)
		base["jobCatPanel"].Paint = function(self, w, h)
			-- draw.RoundedBox( 2, 0, 0, w - 2, h - 2, Color( 0, 0, 0, 150 ) )
			draw.SimpleText(v.name, "ScoreboardF4Menu", 5, 0, IsDark(v.color), 0, 0)
		end
		for j,z in pairs(v.members) do
			DrawJobInfo(z)
			base["jobPanel"] = base["jobLayout"]:Add("DPanel")
			base["jobPanel"]:SetSize( base["jobLayout"]:GetWide() /2 - 15, 45 )
			base["jobPanel"].Paint = function(self, w, h)
				local max_count = z.max ~= 0 and z.max or "∞"
				-- draw.RoundedBox(3, 0, 0, w, h, z.color)
				-- draw.RoundedBox(3, 0, 0, w, h, Color(255,255,255,10))
				draw.SRPBackGroundColored(3, 0, 0, w, h, z.color)
				draw.ShadowText(z.name, "JobsTitleF4Menu", 5, 2, color_white, 0, 0)
				draw.ShadowText(team.NumPlayers(z.team).." / "..max_count, "JobsTitleF4Menu", w-45-5, h/2, color_white, 2, 1)
				
				if IsAvailable(z) then
					draw.ShadowText("+"..DarkRP.formatMoney(z.salary), "JobDescF4Menu", 5, 25, color_white, 0, 0)
				else
					draw.ShadowText(DGF4.Translation.unavailable, "JobDescF4Menu", 5, 25, Color(200,200,200), 0, 0)
				end
			end

			base["jobIcon"] = vgui.Create( "ModelImage", base["jobPanel"] )
			base["jobIcon"]:SetPos(base["jobPanel"]:GetWide() - 45, 1)
			base["jobIcon"]:SetSize( 43, 43 )
			if type(z.model) == "table" then
				base["jobIcon"]:SetModel( table.GetFirstValue( z.model ))
			else
				base["jobIcon"]:SetModel( z.model )
			end

			base["jobBtn"] = vgui.Create("DButton", base["jobPanel"])
			base["jobBtn"]:SetText("")
			base["jobBtn"]:SetSize(base["jobPanel"]:GetWide(), base["jobPanel"]:GetTall())
			base["jobBtn"].DoClick = function()
				DrawJobInfo(z)
			end
			base["jobBtn"].Paint = function(slf, w, h) end
		end
	end

end

DGF4:RegisterButton(jobs) -- Регистрация
