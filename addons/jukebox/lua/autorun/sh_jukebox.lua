AddCSLuaFile("jukebox/lib/lib_medialib.lua")
local medialib = include("jukebox/lib/lib_medialib.lua")

local ENT = {}
ENT.Base = "base_anim"
ENT.Type = "anim"

ENT.PrintName		= "Jukebox"
ENT.Author			= "steamcommunity/id/lostalien"
ENT.Information		= "A working jukebox"
ENT.Category		= "Others"

ENT.Editable		= true
ENT.Spawnable		= true
ENT.AdminOnly		= true
ENT.RenderGroup		= RENDERGROUP_TRANSLUCENT

jukebox = jukebox or {}


local function getcost(amount)
	amount = tostring(amount)
	if jukebox.paymentMethod == "free" then
		return ""
	elseif jukebox.paymentMethod == "ps" then
		return "("..amount.." "..PS.Config.PointsName..")"
	elseif jukebox.paymentMethod == "ps2" then
		return "("..amount.." points)"
	elseif jukebox.paymentMethod == "darkrp" then	
		return "("..amount.."р.)"
	elseif jukebox.paymentMethod == "clockwork" then
		return "("..Clockwork.option:GetKey("name_cash")..""..amount..")"
	else
		return "config fucked up "..amount
	end	
end


local function takemoney(ply,amount,ent)
	if jukebox.paymentMethod == "free" then
		return
	elseif jukebox.paymentMethod == "ps" then
		ply:PS_TakePoints(amount)
		ent.currency = ent.currency + amount
		return
	elseif jukebox.paymentMethod == "ps2" then
		ply:PS2_AddStandardPoints(-amount)
		ent.currency = ent.currency + amount
		return
	elseif jukebox.paymentMethod == "darkrp" then	
		ply:addMoney(-amount)
		ent.currency = ent.currency + amount
		return
	elseif jukebox.paymentMethod == "clockwork" then
		local player = ply
		Clockwork.player:GiveCash(player, -amount)
		ent.currency = ent.currency + amount
		return		
	end	
end

local function harvestmoney(ply,ent)
	if jukebox.paymentMethod == "free" then
		return
	elseif ent.currency < 1 then
		return
	elseif jukebox.paymentMethod == "ps" then
		ply:PS_GivePoints(ent.currency)
		jukebox.Notify(ply,"You recieved "..getcost(ent.currency) .. " from your jukebox")
		ent.currency = 0
		return
	elseif jukebox.paymentMethod == "ps2" then
		ply:PS2_AddStandardPoints(ent.currency,"You recieved money from your jukebox")
		jukebox.Notify(ply,"You recieved "..getcost(ent.currency) .. " from your jukebox")
		ent.currency = 0
		return
	elseif jukebox.paymentMethod == "darkrp" then	
		ply:addMoney(ent.currency)
		jukebox.Notify(ply,"You recieved "..getcost(ent.currency) .. " from your jukebox")
		ent.currency = 0
		return
	elseif jukebox.paymentMethod == "clockwork" then
		local player = ply
		Clockwork.player:GiveCash(player, -amount)
		jukebox.Notify(ply,"You recieved "..getcost(ent.currency) .. " from your jukebox")
		ent.currency = 0
		return		
	end	
end

local function canafford(ply,amount)
	if jukebox.paymentMethod == "free" then
		return true
	elseif jukebox.paymentMethod == "ps" then
		return ply:PS_HasPoints(amount)
	elseif jukebox.paymentMethod == "darkrp" then	
		return ply:canAfford(amount)
	elseif jukebox.paymentMethod == "clockwork" then	
		local player = ply
		return Clockwork.player:CanAfford(player, amount)		
	elseif jukebox.paymentMethod == "ps2" then
		return ply.PS2_Wallet.points >= amount
	end	
end



if SERVER then
	

util.AddNetworkString("JukeboxActivate")
util.AddNetworkString("SongRequest")
util.AddNetworkString("StartSong")
util.AddNetworkString("StopSong")
util.AddNetworkString("OwnerRestrict")

local function stopsong(ent)
	net.Start("StopSong")
		net.WriteEntity(ent)
	net.Broadcast()
	ent.media.nextSong = CurTime()
	ent:SetNWFloat("media.start",0)
	ent:SetNWString("media.player",nil)
	ent:SetNWString("media.url",nil)
	ent:SetNWInt("media.duration",0)
end

net.Receive("OwnerRestrict",function(len,ply)
	local ent = net.ReadEntity()
	local should_restrict = net.ReadBool()
	local isowner = ent:GetNWEntity("JukeOwner") == ply
	
	if isowner then
		ent:SetNWBool("JukePrivate",should_restrict)
		jukebox.Notify(ply,"Jukebox set to ", should_restrict and "private" or "public")
	end
	
end)



net.Receive("SongRequest",function(len,ply)
	local url = net.ReadString()
	local ent = net.ReadEntity()
	local tryskip = net.ReadBool()
	
	
	if ent:GetNWBool("JukePrivate",false) and ent:GetNWEntity("JukeOwner") ~= ply then
		jukebox.ErrorMsg(ply,"This owner has made this jukebox private!")
		return	
	end
	
	if string.find(file.Read("jukebox/blacklist.txt","DATA"),url,0,true) then
		jukebox.ErrorMsg(ply,"This song has been blacklisted!")
		return
	end
	

	local service = medialib.load("media").GuessService(url)
	if service == nil then
		jukebox.ErrorMsg(ply,"Link is invalid!")
		return
	end
	
	if ent.media.nextSong > CurTime() then
		if tryskip then
			local isowner = ply == ent:GetNWEntity("JukeOwner")
			
			if jukebox.ownerSkip and isowner then
				stopsong(ent)
			elseif jukebox.adminSkip and table.HasValue(jukebox.adminGroups,ply:GetUserGroup()) then
				stopsong(ent)
			elseif jukebox.allowSkip then
				if canafford(ply,jukebox.skipPrice) then
					takemoney(ply,jukebox.skipPrice,ent)
					stopsong(ent)
				else
					jukebox.ErrorMsg(ply,"You can't afford to skip a song! "..getcost(jukebox.skipPrice))
				end
			end
		else
			jukebox.ErrorMsg(ply,"There is already a song playing!")
			return
		end
	end
	
	
	service:query(url, function(err, data)
		if ent:GetNWEntity("JukeOWner") == ply then
			ent.media.nextSong = data.duration and (CurTime() + data.duration + 3) or 134217728
			-- set nw data for later connections
			ent:SetNWFloat("media.start",CurTime())
			ent:SetNWString("media.player",ply:Nick())
			ent:SetNWString("media.url",url)
			ent:SetNWInt("media.duration",data.duration)
			
			-- send relevant data for nearby users
			net.Start("StartSong")
				net.WriteEntity(ent)
				net.WriteString(url)
				net.WriteString(ply:Nick())
			net.Broadcast()
		else
			if type(data.duration) ~= "number" or data.duration > jukebox.maxDuration then
				jukebox.ErrorMsg(ply,"Song is too long! (Max "..string.NiceTime(jukebox.maxDuration) .. ")")
			elseif canafford(ply,jukebox.addPrice) then
				takemoney(ply,jukebox.addPrice,ent)
				ent.media.nextSong = CurTime() + data.duration + 3
				-- set nw data
				ent:SetNWFloat("media.start",CurTime())
				ent:SetNWString("media.player",ply:Nick())
				ent:SetNWString("media.url",url)
				ent:SetNWInt("media.duration",data.duration)
				
				-- send relevant data for nearby users
				net.Start("StartSong")
					net.WriteEntity(ent)
					net.WriteString(url)
					net.WriteString(ply:Nick())
				net.Broadcast()
			else
				jukebox.ErrorMsg(ply,"You can't afford to play a song! "..getcost(jukebox.addPrice))
			end
		end	
	end)
end)

net.Receive("StopSong",function(len,ply)
	local ent = net.ReadEntity()
	local forceskip = net.ReadBool()
	local isowner = ply == ent:GetNWEntity("JukeOwner")
	
	if jukebox.ownerSkip and isowner and forceskip then
		stopsong(ent)
	elseif jukebox.adminSkip and table.HasValue(jukebox.adminGroups,ply:GetUserGroup()) and forceskip then
		stopsong(ent)
	elseif jukebox.allowSkip and not forceskip then
		if ent:GetNWBool("JukePrivate",false) and not isowner then
			jukebox.ErrorMsg(ply,"This owner has made this jukebox private!")
		else
			if canafford(ply,jukebox.skipPrice) then
				takemoney(ply,jukebox.skipPrice,ent)
				stopsong(ent)
			else
				jukebox.ErrorMsg(ply,"You can't afford to stop a song! "..getcost(jukebox.skipPrice))
			end
		end
	end
end)

function ENT:SpawnFunction(ply, tr)
	if not tr.Hit then return end
	local SpawnPos = tr.HitPos + tr.HitNormal * 16
	local ent = ents.Create("Jukebox")
		ent:SetPos(SpawnPos)
	ent:Spawn()
	ent:Activate()
	ent:SetName("Jukebox")
	ent:SetNWEntity("JukeOwner",ply)
	ent:GetPhysicsObject():SetMass(2000)
	return ent
end

ENT.spawn = ENT.SpawnFunction

function ENT:Use(activator, ply)
	if activator:KeyDownLast(IN_USE) then return end 
	if not ply:IsPlayer() then return end
	if ply:GetPData("JukeBan","false") ~= "false" then
		jukebox.ErrorMsg(ply,"You have been banned from jukebox access!")
		return
	end
	
	if self:GetNWEntity("JukeOwner") == ply then
		harvestmoney(ply,self)
	end
	net.Start("JukeboxActivate")
		net.WriteEntity(self)
	net.Send(ply)
end

function ENT:Think()
end	

function ENT:OnRemove()
end


function ENT:Initialize()
	self.Entity:SetModel("models/fallout3/jukebox.mdl")
	self.Entity:PhysicsInit(SOLID_VPHYSICS)
	self.Entity:SetMoveType(MOVETYPE_VPHYSICS)
	self.Entity:SetSolid(SOLID_VPHYSICS)
	self:SetUseType(SIMPLE_USE)
	
	self:SetNWEntity("JukeOwner",self:GetNWEntity("JukeOwner") or self)
	self:SetNWBool("JukePrivate",false)
	
	self.currency = 0
	
	self.media = {}
	self.media.nextSong = CurTime()

	local phys = self.Entity:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:Wake()
		phys:SetMass(2000)
	end
end

function ENT:Setowning_ent(ent)
	self:CPPISetOwner(ent)
	self:SetNWEntity("JukeOwner",ent)
end

end

if CLIENT then

surface.CreateFont("JukeboxL", {
	font = "Roboto",
	size = 30,
	weight = 800
})

surface.CreateFont("JukeboxM", {
	font = "Roboto",
	size = 18,
	weight = 400
})

surface.CreateFont("JukeboxS", {
	font = "Roboto",
	size = 16,
	weight = 200
})	

surface.CreateFont("textentry", {
	font = "Railway",
	size = 15,
	weight = 400
})

CreateConVar("jukebox_volume", "1", FCVAR_ARCHIVE)
CreateConVar("jukebox_enabled", "1", FCVAR_ARCHIVE)

local function stopsong(ent,bool)
	net.Start("StopSong")
		net.WriteEntity(ent)
		net.WriteBool(bool)
	net.SendToServer()
end

local blur = Material('pp/blurscreen')
function draw.Blur(panel, amount) -- Thanks nutscript
	local x, y = panel:LocalToScreen(0, 0)
	local scrW, scrH = ScrW(), ScrH()
	surface.SetDrawColor(255, 255, 255)
	surface.SetMaterial(blur)
	for i = 1, 3 do
		blur:SetFloat('$blur', (i / 3) * (amount or 6))
		blur:Recompute()
		render.UpdateScreenEffectTexture()
		surface.DrawTexturedRect(x * -1, y * -1, scrW, scrH)
	end
end

local function dreq(text,title,func1,func2)
	
	local dreq = Derma_Query( text,
		title,
		"Yes",
		func1,
		"No",
		func2)
	function dreq:Paint(w,h)
		draw.Blur(self,6)
		surface.SetDrawColor( Color(25,25,25,230))
		surface.DrawRect(0,0,w,h)
		surface.SetDrawColor( Color(0,0,0,200) )
		surface.DrawOutlinedRect( 0,0,w,h )
	end
	local yes = dreq:GetChildren()[6]:GetChildren()[1]
	yes:SetTextColor(Color(255,255,255))
	function yes:Paint(w,h)
		if yes.Depressed or yes.m_bSelected then 
			draw.RoundedBox( 1, 0, 0, w, h, Color(50,205,50,255) )
		elseif yes.Hovered then
			draw.RoundedBox( 1, 0, 0, w, h, Color(30,155,30,255) )
		else
			draw.RoundedBox( 1, 0, 0, w, h, Color(80,80,80,255) )
		end
	end	
	
	local no = dreq:GetChildren()[6]:GetChildren()[2]
	no:SetTextColor(Color(255,255,255))
	function no:Paint(w,h)
		if no.Depressed or no.m_bSelected then 
			draw.RoundedBox( 1, 0, 0, w, h, Color(255,50,50,255) )
		elseif no.Hovered then
			draw.RoundedBox( 1, 0, 0, w, h, Color(205,30,30,255) )
		else
			draw.RoundedBox( 1, 0, 0, w, h, Color(80,80,80,255) )
		end
	end	

end

local function OpenJukeUI(ent)
	if LocalPlayer():GetPos():Distance(ent:GetPos()) > 150 then
		return
	end	
	
	local inittime = SysTime() - 0.5
	local frame = vgui.Create("DFrame")
	local w,h = 500,370
	local x,y = ScrW()/2-(w/2),ScrH()/2-(h/2)
	frame:SetSize(w,h)
	frame:SetPos(x,y)
	frame:ShowCloseButton(false)
	frame:SetTitle("")
	frame:MakePopup()
	function frame:Paint(w,h)
		Derma_DrawBackgroundBlur(frame,inittime)
	end
	function frame:Think()
		if not ent:IsValid() then frame:Close() end
	end	
	
	local panel = vgui.Create("DPanel",frame)
	panel:SetPos(0,0)
	panel:SetSize(w,h)
	function panel:Paint(w,h)
		draw.Blur(self,6)
		surface.SetDrawColor( Color(25,25,25,230))
		surface.DrawRect(0,0,w,h)
		surface.SetDrawColor( Color(0,0,0,200) )
		surface.DrawOutlinedRect( 0,0,w,h )
		draw.SimpleTextOutlined( "Jukebox", "JukeboxL", (w/2), 5, Color(255,255,255,255), 1, 5, 1, Color(0,0,0,255) )
	end	
	
	local bu = vgui.Create("DButton",frame)
	bu:SetText("×")
	bu:SetTooltip("Close")
	bu:SetColor(Color(255,255,255))
	bu:SetPos(w-31,1)
	bu:SetSize(30,20)
	function bu:Paint(w,h)
		if bu.Depressed or bu.m_bSelected then 
			draw.RoundedBox( 1, 0, 0, w, h, Color(255,50,50,255) )
		elseif bu.Hovered then
			draw.RoundedBox( 1, 0, 0, w, h, Color(205,30,30,255) )
		else
			draw.RoundedBox( 1, 0, 0, w, h, Color(80,80,80,255) )
		end
	end	
	bu.DoClick = function()
		frame:Close()
	end
	
	local media = vgui.Create("DPanel",frame)
	media:SetSize(350,198)
	media:SetPos(75,50)
	function media:Paint(w,h)
		if ent and ent.media and ent.media.mediaclip and ent.media.mediaclip:IsValid() and ent.media.mediaclip:isPlaying() then
			ent.media.mediaclip:draw(0, 0, w, h)
		else
			draw.RoundedBox( 1, 0, 0, w, h, Color(20,20,20,230) )
			draw.SimpleTextOutlined( "No song playing", "JukeboxM", (w/2), h/2, Color(255,255,255,255), 1, 1, 1, Color(0,0,0,255) )
		end
	end
	
	local title = vgui.Create("DPanel",frame)
	title:SetSize(w,50)
	title:SetPos(0,260)
	function title:Paint(w,h)
		if ent and ent.media and ent.media.ply and ent.media.mediaclip and ent.media.mediaclip:IsValid() and ent.media.mediaclip:isPlaying() then
		local str = ent.media.data.title
			draw.SimpleTextOutlined( str, "JukeboxM", (w/2), 2, Color(255,255,255,255), 1, 5, 1, Color(0,0,0,255) )
			draw.SimpleTextOutlined( "Added by "..ent.media.ply, "JukeboxS", (w/2), 30, Color(255,255,255,255), 1, 5, 1, Color(0,0,0,255) )
		end
	end
	
	if LocalPlayer() == ent:GetNWEntity("JukeOwner") then
			local bu = vgui.Create("DButton",frame)
		bu:SetText("")
		bu:SetTooltip("Toggle private/public")
		bu:SetColor(Color(255,255,255))
		bu:SetPos(1,1)
		bu:SetSize(20,20)
		function bu:Paint(w,h)
			if bu.Depressed or bu.m_bSelected then 
				draw.RoundedBox( 1, 0, 0, w, h, Color(255,50,50,255) )
				surface.SetDrawColor(255, 255, 255, 255)
			elseif bu.Hovered then
				draw.RoundedBox( 1, 0, 0, w, h, Color(205,30,30,255) )
				surface.SetDrawColor(230, 230, 230, 255)
			else
				draw.RoundedBox( 1, 0, 0, w, h, Color(80,80,80,255) )
				surface.SetDrawColor(150, 150, 150, 255)
			end
			
			if ent:GetNWBool("JukePrivate",false) then
				surface.SetMaterial(Material("icon16/user.png"))
			else
				surface.SetMaterial(Material("icon16/group.png"))
			end
			surface.DrawTexturedRect(2, 2, 16, 16)
		end	
		bu.DoClick = function()
			if not ent:IsValid() then frame:Close() return end
			net.Start("OwnerRestrict")
				net.WriteEntity(ent)
				net.WriteBool(not ent:GetNWBool("JukePrivate",false))
			net.SendToServer()
		end
		
	end
	
	local bu = vgui.Create("DButton",frame)
	bu:SetText("")
	bu:SetTooltip("Settings")
	bu:SetColor(Color(255,255,255))
	if LocalPlayer() == ent:GetNWEntity("JukeOwner") then 
		bu:SetPos(21,1)
	else
		bu:SetPos(1,1)
	end	
	bu:SetSize(20,20)
	function bu:Paint(w,h)
		if bu.Depressed or bu.m_bSelected then 
			draw.RoundedBox( 1, 0, 0, w, h, Color(255,50,50,255) )
			surface.SetDrawColor(255, 255, 255, 255)
		elseif bu.Hovered then
			draw.RoundedBox( 1, 0, 0, w, h, Color(205,30,30,255) )
			surface.SetDrawColor(230, 230, 230, 255)
		else
			draw.RoundedBox( 1, 0, 0, w, h, Color(80,80,80,255) )
			surface.SetDrawColor(150, 150, 150, 255)
		end
		
		surface.SetMaterial(Material("icon16/cog.png"))
		surface.DrawTexturedRect(2, 2, 16, 16)
	end	
	bu.DoClick = function()
		local frm = vgui.Create("DFrame",frame)
		frm:SetSize(200,200)
		frm:SetTitle("Settings")
		frm.lblTitle:SetColor(Color(255,255,255))
		frm:SetPos(ScrW()/2 - 100,ScrH()/2 - 100)
		function frm:Paint(w,h)
			draw.Blur(self,6)
			surface.SetDrawColor( Color(25,25,25,230))
			surface.DrawRect(0,0,w,h)
			surface.SetDrawColor( Color(0,0,0,200) )
			surface.DrawOutlinedRect( 0,0,w,h )
		end	
		
		local form = vgui.Create("DForm", frm)
		form:Dock(FILL)
		form:SetName("Settings")

		local ch = form:CheckBox("Enable","jukebox_enabled")
		ch.Label:SetColor(Color(255,255,255))
		
		local sl = form:NumSlider("Volume", "jukebox_volume", 0, 1, 1)
		sl.Label:SetColor(Color(255,255,255))
		sl.TextArea:SetTextColor(Color(255,255,255))
		
			local bu = vgui.Create("DButton",frm)
		bu:SetText("×")
		bu:SetTooltip("Close")
		bu:SetColor(Color(255,255,255))
		bu:SetPos(179,1)
		bu:SetSize(20,14)
		function bu:Paint(w,h)
			if bu.Depressed or bu.m_bSelected then 
				draw.RoundedBox( 1, 0, 0, w, h, Color(255,50,50,255) )
			elseif bu.Hovered then
				draw.RoundedBox( 1, 0, 0, w, h, Color(205,30,30,255) )
			else
				draw.RoundedBox( 1, 0, 0, w, h, Color(80,80,80,255) )
			end
		end	
		bu.DoClick = function()
			frm:Close()
		end
		frm:ShowCloseButton(false)
		frm:MakePopup()
	end
	
	if ent:GetNWBool("JukePrivate",false) and LocalPlayer() ~= ent:GetNWEntity("JukeOwner") then
	
		local private = vgui.Create("DPanel",frame)
		private:SetSize(w,50)
		private:SetPos(0,h-70)
		function private:Paint(w,h)
			draw.SimpleTextOutlined( "Jukebox in private mode", "JukeboxS", (w/2), 30, Color(255,255,255,255), 1, 5, 1, Color(0,0,0,255) )
		end
		
	else
	
		local txt = vgui.Create( "DTextEntry",frame)
		if ent:GetNWEntity("JukeOwner") ~= LocalPlayer() then
			txt:SetText( " Paste streaming link here ".. getcost(jukebox.addPrice))
		else
			txt:SetText( " Paste streaming link here ")
		end
		txt:SetSize(w-160,20)
		txt:SetPos(80,h-40)
		txt:SetTooltip("Paste a link and hit ENTER")
		txt:SetFont("textentry")
		txt.shouldclear = true
		txt.OnMousePressed = function(MOUSE_LEFT)
			if txt.shouldclear then
				txt:SetText( "" )
				txt.shouldclear = false
			end
		end
		function txt:PaintOver(w,h)
			surface.SetDrawColor(255, 255, 255, 255)
			surface.SetMaterial(Material("icon16/music.png"))
			surface.DrawTexturedRect(w-20, 2, 16, 16)
		end
		txt.OnEnter = function( self )
			if not ent:IsValid() then frame:Close() return end
			local url = self:GetValue()
			net.Start("SongRequest")
				net.WriteString(url)
				net.WriteEntity(ent)
			if ent:IsPlaying() then
				local isowner = LocalPlayer() == ent:GetNWEntity("JukeOwner")
				if jukebox.ownerSkip and isowner then
					dreq("Do you want to skip the current song?","Skip song",
					function() net.WriteBool(true) net.SendToServer() end,
					function() net.WriteBool(false) net.SendToServer() end)
				elseif jukebox.adminSkip and table.HasValue(jukebox.adminGroups,LocalPlayer():GetUserGroup()) then
					dreq("Do you want to skip the current song?","Skip song",
					function() net.WriteBool(true) net.SendToServer() end,
					function() net.WriteBool(false) net.SendToServer() end)
				elseif jukebox.allowSkip then
					dreq("Do you want to skip the current song? "..getcost(jukebox.skipPrice),"Skip song",
					function()
						if canafford(LocalPlayer(),jukebox.skipPrice) then
							net.WriteBool(true) net.SendToServer()
						end
					end,
					function() net.WriteBool(false) net.SendToServer() end)
				end
			else
				net.WriteBool(false)
				net.SendToServer()
			end
			txt.shouldclear = true
			if ent:GetNWEntity("JukeOwner") ~= LocalPlayer() then
				txt:SetText( " Paste streaming link here ".. getcost(jukebox.addPrice))
			else
				txt:SetText( " Paste streaming link here ")
			end
		end
		
	
		local skip = vgui.Create("DButton",frame)
		skip:SetText("Stop")
		skip:SetTextColor(Color(255,255,255))
		skip:SetPos(w-70,h-40)
		skip:SetSize(50,20)
		skip:SetTooltip("Stop current song")
		function skip:Paint(w,h)
			if skip.Depressed or skip.m_bSelected then 
				draw.RoundedBox( 1, 0, 0, w, h, Color(255,50,50,255) )
			elseif skip.Hovered then
				draw.RoundedBox( 1, 0, 0, w, h, Color(205,30,30,255) )
			else
				draw.RoundedBox( 1, 0, 0, w, h, Color(80,80,80,255) )
			end
		end	
		skip.DoClick = function()
			if not ent:IsValid() then frame:Close() return end
			if not ent:IsPlaying() then return end
			local isowner = LocalPlayer() == ent:GetNWEntity("JukeOwner")
			if jukebox.ownerSkip and isowner then
				dreq("Do you want to stop the current song?","Stop song",
				function() stopsong(ent,true) end,
				function() end)
			elseif jukebox.adminSkip and table.HasValue(jukebox.adminGroups,LocalPlayer():GetUserGroup()) then
				dreq("Do you want to stop the current song?","Stop song",
				function() stopsong(ent,true) end,
				function() end)
			elseif jukebox.allowSkip then
				dreq("Do you want to stop the current song? "..getcost(jukebox.skipPrice),"Stop song",
				function()
					if canafford(LocalPlayer(),jukebox.skipPrice) then
						stopsong(ent,false)
					end
				end,
				function() end)
			end	
			
		end
	
		local browser = vgui.Create("DButton",frame)
		browser:SetText("YouTube")
		browser:SetTextColor(Color(255,255,255))
		browser:SetPos(20,h-40)
		browser:SetSize(50,20)
		browser:SetTooltip("Open Youtube browser")
		function browser:Paint(w,h)
			if browser.Depressed or browser.m_bSelected then 
				draw.RoundedBox( 1, 0, 0, w, h, Color(255,50,50,255) )
			elseif browser.Hovered then
				draw.RoundedBox( 1, 0, 0, w, h, Color(205,30,30,255) )
			else
				draw.RoundedBox( 1, 0, 0, w, h, Color(80,80,80,255) )
			end
		end	
		browser.DoClick = function()
			
			local url = "https://www.youtube.com"
			local w2,h2 = ScrW()/1.3,ScrH()/1.3
			
			local bframe = vgui.Create("DFrame",frame)
			bframe:SetSize(w2,h2)
			bframe:SetTitle("")
			bframe:SetPos(ScrW()/2 - w2/2,ScrH()/2 - h2/2)
			bframe:MakePopup()
			bframe:ShowCloseButton(false)
			function bframe:Paint(w,h)
				draw.RoundedBox( 1, 0, 0, w, h, Color(255,255,255,255) )
			end
			
			local window = vgui.Create( "DHTML", bframe)
			window:SetSize(w2,h2-(h2/20))
			window:SetPos(0,0)
			window:OpenURL( url )
			window.Paint = function() end
			local cbu = vgui.Create("DButton",bframe)
			cbu:SetText("Close")
			cbu:SetColor(Color(255,255,255))
			cbu:SetPos(w2-(w2*0.2),h2-(h2/20))
			cbu:SetSize(w2*0.2,h2/20)
			function cbu:Paint(w,h)
				if cbu.Depressed or cbu.m_bSelected then 
					draw.RoundedBox( 1, 0, 0, w, h, Color(232,83,63,255) )
				elseif cbu.Hovered then
					draw.RoundedBox( 1, 0, 0, w, h, Color(212,70,53,255) )
				else
					draw.RoundedBox( 1, 0, 0, w, h, Color(192, 57, 43) )
				end
			end	
			cbu.DoClick = function()
				bframe:Close()
			end
			
			local rbu = vgui.Create("DButton",bframe)
			if ent:GetNWEntity("JukeOwner") ~= LocalPlayer() then
				rbu:SetText( "Request current url ".. getcost(jukebox.addPrice))
			else
				rbu:SetText( "Request current url ")
			end
			rbu:SetColor(Color(255,255,255))
			rbu:SetPos(0,h2-(h2/20))
			rbu:SetSize(w2*0.6,h2/20)
			function rbu:Paint(w,h)
				if rbu.Depressed or rbu.m_bSelected then 
					draw.RoundedBox( 1, 0, 0, w, h, Color(59,205,116,255) )
				elseif rbu.Hovered then
					draw.RoundedBox( 1, 0, 0, w, h, Color(49,190,106,255) )
				else
					draw.RoundedBox( 1, 0, 0, w, h, Color(39, 175, 96) )
				end
			end	
			rbu.DoClick = function()
				if not ent:IsValid() then frame:Close() return end
				window:AddFunction("jukebox", "GetURL", function(loaded_url)
					net.Start("SongRequest")
						net.WriteString(loaded_url)
						net.WriteEntity(ent)
					if ent:IsPlaying() then
						local isowner = LocalPlayer() == ent:GetNWEntity("JukeOwner")
						if jukebox.ownerSkip and isowner then
							dreq("Do you want to the current song?","Skip song",
							function() net.WriteBool(true) net.SendToServer() end,
							function() net.WriteBool(false) net.SendToServer() end)
						elseif jukebox.adminSkip and table.HasValue(jukebox.adminGroups,LocalPlayer():GetUserGroup()) then
							dreq("Do you want to the current song?","Skip song",
							function() net.WriteBool(true) net.SendToServer() end,
							function() net.WriteBool(false) net.SendToServer() end)
						elseif jukebox.allowSkip then
							dreq("Do you want to the current song? "..getcost(jukebox.skipPrice),"Skip song",
							function()
								if canafford(LocalPlayer(),jukebox.skipPrice) then
									net.WriteBool(true) net.SendToServer()
								end
							end,
							function() net.WriteBool(false) net.SendToServer() end)
						end
					else
						net.WriteBool(false)
						net.SendToServer()
					end
					bframe:Close()	
				end)
				window:RunJavascript([[jukebox.GetURL(window.location.href);]])
			end
			
			local cpy = vgui.Create("DButton",bframe)
			cpy:SetText( "Copy URL")
			cpy:SetColor(Color(255,255,255))
			cpy:SetPos(w2*0.6,h2-(h2/20))
			cpy:SetSize(w2*0.2,h2/20)
			function cpy:Paint(w,h)
				if cpy.Depressed or cpy.m_bSelected then 
					draw.RoundedBox( 1, 0, 0, w, h, Color(60,160,220,255) )
				elseif cpy.Hovered then
					draw.RoundedBox( 1, 0, 0, w, h, Color(51, 148, 205) )
				else
					draw.RoundedBox( 1, 0, 0, w, h, Color(41, 128, 185) )
				end
			end	
			cpy.DoClick = function()
				window:AddFunction("jukebox", "GetURL", function(loaded_url)
					SetClipboardText(loaded_url)
					bframe:Close()	
				end)
				window:RunJavascript([[jukebox.GetURL(window.location.href);]])	
			end
			
			
		end
	end	
	
end

local playingstates = {"loading", "buffering", "playing"}

function ENT:IsPlaying()
	if not self:IsValid() then return false end
	if self:GetNWInt("media.duration",0) == 0 then return false end
	if self.songstarted + self:GetNWInt("media.duration",0) > CurTime() then return true end -- allow for 3 seconds of 'prebuffering'
	if not self.media.mediaclip or not self.media.mediaclip:IsValid() then return false end
	if table.HasValue(playingstates,self.media.mediaclip:getState()) then return true end
	return false
end

function ENT:Initialize()
	self.media = {}
	self.media.data = {}
	self.media.data.title = "Jukebox"
	self.songstarted = 0
end


function ENT:Draw()
	self.Entity:DrawModel();
	
	local pos = self:GetPos()
	local ang = self:GetAngles()
	ang:RotateAroundAxis(ang:Right(),270)
	ang:RotateAroundAxis(ang:Up(),90)
	
	surface.SetFont("JukeboxS")
	cam.Start3D2D( pos + (ang:Up() * 12.5) - (ang:Right() * 13), ang, 0.2 )
		draw.SimpleTextOutlined( "Jukebox", "JukeboxM", 90, -120, Color(255,255,255,255), 1, 0, 1, Color(0,0,0,255) )
	cam.End3D2D()
	
		
end	

function ENT:Think()
	if not self:IsValid() then return end
	self.LastNote = self.LastNote or CurTime()
	if self.LastNote + 0.8 < CurTime() and self:IsPlaying() then
		self.LastNote = CurTime()
		local pos = self:WorldSpaceCenter()
		local edata = EffectData()
		edata:SetOrigin(pos)
		util.Effect("jukebox_note",edata)
	end
	
	self.lastcheck = self.lastcheck or CurTime()
	if self.lastcheck + 2 < CurTime() then
		self.lastcheck = CurTime()
		
		if not cvars.Bool("jukebox_enabled") then return end
		
		local duration = self:GetNWInt("media.duration",0)
		local url = self:GetNWString("media.url","https://www.youtube.com/watch?v=hod0WtYE4SA")
		local start = self:GetNWFloat("media.start",0)
		local pl = self:GetNWString("media.player","Negus")
	
		if (start + duration) > CurTime() and not self:IsPlaying() then
			
			self.songstarted = CurTime()
			local service = medialib.load("media").guessService(url)
			local mediaclip = service:load(url, {use3D = true, ent3D = self})
			mediaclip:play()
			mediaclip:setVolume(cvars.Number("jukebox_volume"))
			mediaclip:set3DFadeMax(jukebox.maxfade)
			if start + 2 < CurTime() then
				mediaclip:seek(math.Round(CurTime() - start))
			end
			
			self.media.ply = pl
			self.media.mediaclip = mediaclip
			service:query(url, function(err, data)
				self.media.data = data
			end)

			print("New jukebox detected, song started")
		end
		
	end
	
	if self.media.mediaclip then
		self.media.mediaclip:setVolume(cvars.Number("jukebox_volume"))
	end	
	
end

--[[hook.Add( "PreDrawHalos", "jukehalo", function()
	local trent = LocalPlayer():GetEyeTrace().Entity
	if trent and trent:IsValid() and trent:GetClass() == "jukebox" and trent:GetPos():Distance(LocalPlayer():GetPos()) < 120 then
		halo.Add( {trent}, Color( 255, 255, 255 ), 2, 2, 1 )
	end
end)]]

net.Receive("JukeboxActivate",function(len)
	local ent = net.ReadEntity()
	OpenJukeUI(ent)
end)

net.Receive("StartSong",function(len)
	local ent = net.ReadEntity()
	local url = net.ReadString()
	local pl = net.ReadString()
	
	if not cvars.Bool("jukebox_enabled") then return end
	
	if not ent or not ent.media or ent:IsPlaying() then return end
	ent.songstarted = CurTime()
	local service = medialib.load("media").guessService(url)
	local mediaclip = service:load(url, {use3D = true, ent3D = ent})
	mediaclip:play()
	mediaclip:setVolume(cvars.Number("jukebox_volume"))
	mediaclip:set3DFadeMax(jukebox.maxfade)
	
	ent.media.ply = pl
	ent.media.mediaclip = mediaclip
	service:query(url, function(err, data)
		ent.media.data = data
	end)
end)



hook.Add("HUDPaint","StartJBMusic",function()
	hook.Remove("HUDPaint","StartJBMusic")
	
	if not cvars.Bool("jukebox_enabled") then return end
	
	for k,ent in pairs(ents.FindByClass("jukebox")) do
		
		local duration = ent:GetNWInt("media.duration",0)
		local url = ent:GetNWString("media.url","https://www.youtube.com/watch?v=hod0WtYE4SA")
		local start = ent:GetNWFloat("media.start",0)
		local pl = ent:GetNWString("media.player","Negus")
	
		if (start + duration) > CurTime() and not ent:IsPlaying() then
		
			ent.songstarted = CurTime()
			local service = medialib.load("media").guessService(url)
			local mediaclip = service:load(url, {use3D = true, ent3D = ent})
			mediaclip:play()
			mediaclip:setVolume(cvars.Number("jukebox_volume"))
			mediaclip:set3DFadeMax(jukebox.maxfade)
			if start + 2 < CurTime() then
				mediaclip:seek(math.Round(CurTime() - start))
			end
			ent.media = ent.media or {}
			ent.media.ply = pl
			ent.media.mediaclip = mediaclip
			service:query(url, function(err, data)
				ent.media.data = data
			end)

		end
	end
end)

net.Receive("StopSong",function(len)
	local ent = net.ReadEntity()
	if ent and ent.media and ent.media.mediaclip and ent.media.mediaclip:IsValid() and ent.media.mediaclip:isPlaying() then
		ent.media.mediaclip:stop()
	end
end)
	
end

scripted_ents.Register(ENT, "jukebox")