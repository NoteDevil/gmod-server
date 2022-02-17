BOOMBOX = {}

if SERVER then
	resource.AddWorkshop("658963840")
	util.AddNetworkString("getbbcrcodecl")
	AddCSLuaFile()
	AddCSLuaFile("boombox/lang.lua")
	AddCSLuaFile("boombox/interface.lua")
	AddCSLuaFile("boombox/config.lua")
	include("boombox/config.lua")

	util.AddNetworkString("clrequestbbcode")
	util.AddNetworkString("getbbcldata")
	util.AddNetworkString("bbcsloaded")

	local vlist = {
		".youtube.com",
		".yt-downloader.org",
		".ymcdn.cc"
	}
	local validateaddress = function(str)
		if str:StartWith("http://") or str:StartWith("https://") then
			local valid = false
			local pieces = string.Explode("/",str)
			for _,approved in ipairs(vlist) do
				if pieces[3]:EndsWith(approved) then
					valid = true
				end
			end
			return valid
		end
		return false
	end

	net.Receive("boombox_data",function(len,ply)
		local ent = net.ReadEntity()
		if not IsValid(ent) then return end
		if ent:GetClass()!="3d_boombox" then
			print("WARNING: Got entity "..tostring(ent).." from player "..tostring(ply).." instead of a boombox.")
			return 
		end
		if CPPI and BOOMBOX.config.UsePropProtection == 2 and ent.CPPICanUse and not ent:CPPICanUse(ply) then return end
		if (BOOMBOX.config.UsePropProtection == 3 or not CPPI) and not ent:GetOwner() == ply then return end
		if IsValid(ent:GetHeld()) and ent:GetHeld():GetParent() ~= ply then return end
		local mode = net.ReadInt(32)
		if mode == 7 then
			local wep = ply:GetWeapon("hold_boombox")
			if not IsValid(wep) then
				ent:Take(ply)
			else
				ent:Drop(wep)
				ply:SwitchToDefaultWeapon()
			end
			return
		end
		if mode == 8 then
			local sk = net.ReadInt(32)
			ent:SetSkin(sk or 0)
			return
		end
		if IsValid(ent) then
			
			net.Start("boombox_data")
			net.WriteEntity(ent)
			net.WriteInt(1,32)
			net.WriteInt(mode,32)
			if mode == 1 then --new song, loading, mdata
				net.WriteFloat(net.ReadFloat())
				net.WriteBool(net.ReadBool())
				local data = net.ReadTable()
				if not validateaddress(data.ref) then
					print("WARNING: Player " .. tostring(ply).." tried to play the boombox from an unknow source!")
					print(data.ref)
					net.SendPVS(Vector(0, 0, -500000))
					return
				end
				net.WriteTable(data)
			elseif mode == 2 then --resume
				net.WriteFloat(net.ReadFloat())
				net.WriteFloat(net.ReadFloat())
			elseif mode == 3 then --pause

			elseif mode == 4 then --stop

			elseif mode == 5 then --set time, fraction
				net.WriteFloat(net.ReadFloat())
			elseif mode == 6 then --set time, fraction
				net.WriteFloat(net.ReadFloat())
			end
			net.Broadcast()
		end
	end)


end

if CLIENT then
	include("boombox/lang.lua")
	include("boombox/interface.lua")
	include("boombox/config.lua")
	local INTERFACE = {}

	local ffts = 0.5
	local fftsp = ffts^(1/6)
	local fftgamma = 2
	local function getfftt(n)
		local t =  (n ^ (1 / fftgamma)) * 10
		--print(t)
		t = math.max(0,math.log10(t))+0.01
		return t
	end

	local function itocol(n)
		return Color(255-n*255,n*255,n*255,255)
	end

	local function formatt(sec)
		local s = math.floor(sec%60)
		return math.floor(sec/60)..":".. (s<10 and "0" or "") .. s
	end

	local themesel = 1

	INTERFACE.preview = function(self,width,height)
		surface.SetDrawColor( BOOMBOX.config.themes[themesel].primary )
		surface.DrawRect( -width/2, -height/2, width, height )
		surface.SetDrawColor( BOOMBOX.config.themes[themesel].secondary )
		surface.DrawOutlinedRect( -width/2+2, -height/2+2, width-4, height-4 )

		surface.SetDrawColor( BOOMBOX.config.themes[themesel].secondary )
		surface.DrawRect( -width/2+6, -height/2+30, width-12, height-36 )

		local art,name = "-","-"
		if self.error then
			art = BOOMBOX.lang.error
			name = ""
		elseif self.mdata then
			art = self.mdata.artist
			name = self.mdata.name
		end

		draw.SimpleText( art, "Trebuchet24", -width/2+8, -height/2+17, BOOMBOX.config.themes[themesel].text_1, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
		draw.SimpleText( name, "Trebuchet24", width/2-8, -height/2+17, BOOMBOX.config.themes[themesel].text_1, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER )


		surface.SetDrawColor( BOOMBOX.config.themes[themesel].primary )
		surface.DrawRect( -width/2+8, -height/2+32, width-16, height-80 )

		local num = 128
		local data = {}
		if IsValid(self.audio) then
			self.audio:FFT(data, FFT_1024)
		end
		local nw = width-23
		local spb = nw/num
		self.lastd = self.lastd or {}
		local avg = 0
		for i=1,num do
			local ls = self.lastd[i] or 0--geth(lastd[i] or 0)
			local cr = getfftt(data[i] or 0)--math.max(0,math.min(1,((1+math.log10((data[i] or 0)^2)/8.5)^2)))
			if i>num/2 then
				avg = avg + (data[i] or 0)
			end
			local fftsp = ffts^(FrameTime()*20)
			local h = ls * fftsp + cr * (1-fftsp)
			--print(h)

			surface.SetDrawColor( Color(100,100,100) )
			if h>0 and h<=1 then
				surface.DrawRect( -width/2+12 + (i-1)*spb, height/2-52, spb+1, -cr*(height-90) )
				surface.SetDrawColor( itocol(-h) )
				surface.DrawRect( -width/2+12 + (i-1)*spb, height/2-52, spb+1, -h*(height-90) )
			end
			self.lastd[i] = h--data[i]
		end
		local minr,maxr = 15,100
		minr = minr/20000*512
		maxr = maxr/20000*512
		avg = 0
		for i = minr,maxr do
			avg = avg + (data[math.floor(i)] or 0)
		end
		avg = ((data[1] or 0)*avg*3)%1
		local l,r = 0,0
		if IsValid(self.audio) then l,r = self.audio:GetLevel() end
		if true then
			self:ManipulateBoneAngles(1,Angle(0,0,0))
			self:ManipulateBonePosition(1,Vector(avg,0,0))
		end

		surface.SetDrawColor( BOOMBOX.config.themes[themesel].time_secondary )
		surface.DrawRect( -width/2+64, height/2-37, width-128, 20 )

		local percent = 0
		local t2 = 0
		if IsValid(self.audio) then
			t2 = self.audio:GetLength()
			percent = self.audio:GetTime()/t2*100
		end
		local t1 = t2/100*percent

		surface.SetDrawColor( BOOMBOX.config.themes[themesel].time_scroll, 255 )
		surface.DrawRect( -width/2+64 + percent/100*(width-132), height/2-37, 4, 20 )

		draw.SimpleText( formatt(t1), "Trebuchet24",-width/2+60, height/2-27, BOOMBOX.config.themes[themesel].text_2, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER )
		draw.SimpleText( formatt(t2), "Trebuchet24",width/2-60, height/2-27, BOOMBOX.config.themes[themesel].text_2, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
	end

	local function sendupdate(ent, mode, ...)
		local prms = {...}
		net.Start("boombox_data")
		net.WriteEntity(ent)
		net.WriteInt(mode,32)
		if mode==1 then --new song, loading, mdata
			net.WriteFloat(CurTime())
			net.WriteBool(prms[1])
			net.WriteTable(prms[2])
		elseif mode==2 then
			net.WriteFloat(CurTime()) --sync
			net.WriteFloat(prms[1]) --starttime
		elseif mode==5 then --set time, fraction
			net.WriteFloat(prms[1])
		elseif mode==6 then --set volume, fraction
			net.WriteFloat(prms[1])
		elseif mode==8 then
			net.WriteInt(prms[1],32)
		end
		net.SendToServer()
	end

	INTERFACE.opengui = function(e)
		local frame = vgui.Create("DFrame")
		frame:SetSize(500,122)
		frame:Center()
		frame:SetTitle("")
		frame:SetVisible(true)
		frame:SetDraggable(false)
		frame:ShowCloseButton(false)
		frame:MakePopup()
		frame.Paint = function(self, w, h)
			surface.SetDrawColor(BOOMBOX.config.themes[themesel].primary)
			surface.DrawRect( 0,0,w,h )
			surface.SetDrawColor( BOOMBOX.config.themes[themesel].secondary )
			surface.DrawOutlinedRect( 2,2,w-4,h-4 )
			
			if e.error then
				draw.SimpleText( BOOMBOX.lang.error, "Trebuchet18",156, 18, BOOMBOX.config.themes[themesel].text_1, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
				return
			end
			local art,name = "-","-"
			if e.mdata then
				art = e.mdata.artist
				name = e.mdata.name
			end
			draw.SimpleText( BOOMBOX.lang.artist ..": "..art, "Trebuchet18",64, 28, BOOMBOX.config.themes[themesel].text_1, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
			draw.SimpleText( BOOMBOX.lang.song ..": "..name, "Trebuchet18",64, 43, BOOMBOX.config.themes[themesel].text_1, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
		end
		
		local playpause = vgui.Create("DButton",frame)
		playpause:SetPos(10,64)
		playpause:SetSize(48,48)
		playpause:SetText("")
		playpause.Paint = function(self, w, h)
			surface.SetDrawColor( BOOMBOX.config.themes[themesel].secondary )
			surface.DrawRect( 0,0,w,h )
			surface.SetDrawColor( BOOMBOX.config.themes[themesel].primary )
			draw.NoTexture()
			if e.loading then
				for i=1,4 do
					local t = os.clock()*5
					local d = math.cos(t)*w/3
					local x,y = math.cos(i/2*math.pi+t)*d,math.sin(i/2*math.pi+t)*d
					surface.DrawTexturedRectRotated(w/2+x,h/2+y,w/5,w/5,-i*60+t*d)
				end
				return
			end
			if IsValid(e.audio) then
				local st = e.audio:GetState()
				if st==GMOD_CHANNEL_PAUSED or st==GMOD_CHANNEL_STOPPED then
					surface.DrawPoly({
						{x=10,y=10},
						{x=w-10,y=h/2},
						{x=10,y=h-10},
					})
				elseif st==GMOD_CHANNEL_PLAYING then
					surface.DrawRect( 10,10,w/2-15,h-20 )
					surface.DrawRect( w/2+5,10,w/2-15,h-20 )
				end
			else
				surface.DrawPoly({
					{x=10,y=10},
					{x=w-10,y=h/2},
					{x=10,y=h-10},
				})
			end
		end
		playpause.DoClick = function()
			if IsValid(e.audio) then
				local st = e.audio:GetState()
				if st==GMOD_CHANNEL_PAUSED or st==GMOD_CHANNEL_STOPPED then
					--e.audio:Play()
					sendupdate(e,2,e.audio:GetTime())
				elseif st==GMOD_CHANNEL_PLAYING then
					--e.audio:Pause()
					sendupdate(e,3)
				end
			elseif e.mdata then
				--e:Play(e.mdata)
				e.mdata.start = CurTime()
				sendupdate(e,1,false,e.mdata)
			end
		end

		local stop = vgui.Create("DButton",frame)
		stop:SetPos(64,64)
		stop:SetSize(48,48)
		stop:SetText("")
		stop.Paint = function(self, w, h)
			surface.SetDrawColor( BOOMBOX.config.themes[themesel].secondary )
			surface.DrawRect( 0,0,w,h )
			surface.SetDrawColor( BOOMBOX.config.themes[themesel].primary )
			surface.DrawRect( 10,10,w-20,h-20 )
		end
		stop.DoClick = function()
			e.loading = nil
			if IsValid(e.audio) then
				--e.audio:Stop()
				sendupdate(e,4)
			end
		end

		local timeslider = vgui.Create( "DSlider", frame )
		timeslider:SetPos( 124, 96 )
		timeslider:SetSize( 360, 16 )
		timeslider:SetSlideX(0)
		timeslider:NoClipping(true)
		timeslider.Paint = function(self,w,h)
			surface.SetDrawColor( BOOMBOX.config.themes[themesel].time_primary )
			surface.DrawRect( -6,0,w+12,h )
			surface.SetDrawColor( BOOMBOX.config.themes[themesel].time_secondary )
			surface.DrawRect( -6,0,w*self:GetSlideX(),h )
			if IsValid(e.audio) then
				draw.SimpleText( formatt(self:GetSlideX()*e.audio:GetLength()), "Trebuchet18",-6, -7, BOOMBOX.config.themes[themesel].text_1, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
				draw.SimpleText( formatt(e.audio:GetLength()), "Trebuchet18",w+6, -7, BOOMBOX.config.themes[themesel].text_1, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER )
			end
		end
		timeslider.Knob:SetSize(12,18)
		timeslider.Knob.Paint = function(self,w,h)
			surface.SetDrawColor( BOOMBOX.config.themes[themesel].time_scroll )
			surface.DrawRect( 0,0,w,h )
		end
		local oktsor = timeslider.Knob.OnMouseReleased
		timeslider.Knob.OnMouseReleased = function(self,t)
			oktsor(self,t)
			if IsValid(e.audio) then
				sendupdate(e,5,self:GetParent():GetSlideX())
			end
		end
		local otsor = timeslider.OnMouseReleased
		timeslider.OnMouseReleased = function(self,t)
			otsor(self,t)
			if IsValid(e.audio) then
				sendupdate(e,5,self:GetSlideX())
			end
		end
		frame.Think = function()
			if IsValid(e.audio) then
				if not timeslider:GetDragging() then
					timeslider:SetSlideX(e.audio:GetTime()/e.audio:GetLength())
				end
			end
		end

		local volumeslider = vgui.Create( "DSlider", frame )
		volumeslider:SetPos( 118, 64 )
		volumeslider:SetSize( 100, 16 )
		volumeslider:SetSlideX(IsValid(e.audio) and e.audio:GetVolume() or e.volume or 1)
		volumeslider.Paint = function(self,w,h)
			surface.SetDrawColor( BOOMBOX.config.themes[themesel].volume_inactive )
			surface.DrawRect( 0,0,w,h )
			surface.SetDrawColor( BOOMBOX.config.themes[themesel].volume_active )
			surface.DrawRect( 0,0,w*self:GetSlideX(),h )
			draw.SimpleText( BOOMBOX.lang.volume or "Volume", "Trebuchet18",w/2,h/2+0.5, BOOMBOX.config.themes[themesel].text_2, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		end
		volumeslider.Knob:SetSize(8,10)
		volumeslider.Knob.Paint = function(self,w,h) end
		local okvsor = volumeslider.Knob.OnMouseReleased
		volumeslider.Knob.OnMouseReleased = function(self,t)
			okvsor(self,t)
			if IsValid(e.audio) then
				sendupdate(e,6,self:GetParent():GetSlideX())
			end
		end
		local ovsor = volumeslider.OnMouseReleased
		volumeslider.OnMouseReleased = function(self,t)
			ovsor(self,t)
			if IsValid(e.audio) then
				sendupdate(e,6,self:GetSlideX())
			end
		end

		local find = vgui.Create("DButton",frame)
		find:SetPos(10,10)
		find:SetSize(48,48)
		find:SetText("")
		find.Paint = function(self, w, h)
			surface.SetDrawColor( BOOMBOX.config.themes[themesel].secondary )
			surface.DrawRect( 0,0,w,h )
			draw.RoundedBox(w/2-13,19,2.5,w-25,h-25,BOOMBOX.config.themes[themesel].primary)
			surface.SetDrawColor( BOOMBOX.config.themes[themesel].primary )
			draw.NoTexture()
			surface.DrawTexturedRectRotated(w/2,h/2,40,8,55)
			draw.RoundedBox(w/2-17,21,4.5,w-29,h-29,BOOMBOX.config.themes[themesel].secondary)
		end
		find.DoClick = function()
			INTERFACE.opensearch(e)
		end

		local pickup = vgui.Create("DButton",frame)
		pickup:SetPos(382,10)
		pickup:SetSize(32,32)
		pickup:SetText("")
		pickup.Paint = function(self, w, h)
			if IsValid(e:GetHeld()) then
				surface.SetDrawColor( BOOMBOX.config.themes[themesel].secondary )
				surface.DrawRect( 0,0,w,h )
				draw.RoundedBox(0,w/5*2,h/6,w/5,h/3,BOOMBOX.config.themes[themesel].primary)
				surface.SetDrawColor( BOOMBOX.config.themes[themesel].primary )
				draw.NoTexture()
				surface.DrawPoly( {
					{x=w/2,y=h/6*5},
					{x=w/5,y=h/2},
					{x=w/5*4,y=h/2},
				} )
			else
				surface.SetDrawColor( BOOMBOX.config.themes[themesel].secondary )
				surface.DrawRect( 0,0,w,h )
				draw.RoundedBox(0,w/5*2,h/4,w/5,h/3,BOOMBOX.config.themes[themesel].primary)
				draw.RoundedBox(0,w/5,h/6*4,w*3/5+1,h/4,BOOMBOX.config.themes[themesel].primary)
				surface.SetDrawColor(BOOMBOX.config.themes[themesel].primary)
				draw.NoTexture()
				surface.DrawPoly( {
					{x=w/2,y=h/10},
					{x=w/5*4,y=h/3},
					{x=w/5,y=h/3}
				} )
			end
		end
		pickup.DoClick = function()
			sendupdate(e,7)
			frame:Close()
		end

		local setrot = 20
		local settings = vgui.Create("DButton",frame)
		settings:SetPos(420,10)
		settings:SetSize(32,32)
		settings:SetText("")
		settings.Paint = function(self, w, h)
			if self:IsHovered() then
				setrot = setrot - FrameTime()*30
			end
			surface.SetDrawColor( BOOMBOX.config.themes[themesel].secondary )
			surface.DrawRect( 0,0,w,h )
			surface.SetDrawColor( BOOMBOX.config.themes[themesel].primary )
			draw.NoTexture()
			local t = {}
			for i=1,12 do
				local cs,sn = math.cos(i/6*math.pi),math.sin(i/6*math.pi)
				t[i] = {x=w/2+cs*w/3.5,y=h/2+sn*w/3.5}
			end
			for i=1,4 do
				surface.DrawTexturedRectRotated(w/2,h/2,w/1.2,w/7,i*45+setrot)
			end
			surface.DrawPoly( t )
		end
		settings.DoClick = function()
			INTERFACE.opensettings(e)
		end

		local close = vgui.Create("DButton",frame)
		close:SetPos(458,10)
		close:SetSize(32,32)
		close:SetText("")
		close.Paint = function(self, w, h)
			surface.SetDrawColor( BOOMBOX.config.themes[themesel].secondary )
			surface.DrawRect( 0,0,w,h )
			surface.SetDrawColor( BOOMBOX.config.themes[themesel].primary )
			draw.NoTexture()
			surface.DrawTexturedRectRotated(w/2,h/2,w/1.5,w/5,45)
			surface.DrawTexturedRectRotated(w/2,h/2,w/1.5,w/5,-45)
		end
		close.DoClick = function()
			frame:Close()
		end
	end

	-----------------------------YOUTUBE-----------------------

	local ytprovider = {}
	ytprovider.extractinfo = function(str)
		local data = {}
		
		data.mediatype=1

		local id = str.ref

		data.ref = function(data, callback)
			local frame = vgui.Create( "DFrame" )
			frame:SetSize( 300, 100 )
			frame:SetTitle( "" )
			frame:SetVisible( true )
			frame:Center()
			frame.Paint = function(self, w, h)
				surface.SetDrawColor( BOOMBOX.config.themes[themesel].primary )
				surface.DrawRect( 0,0,w,h )
				surface.SetDrawColor( BOOMBOX.config.themes[themesel].secondary )
				surface.DrawOutlinedRect( 2,2,w-4,h-4 )

				draw.SimpleText( "Preparing video..", "Trebuchet18",150,20, BOOMBOX.config.themes[themesel].text_1, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
				draw.SimpleText( "Close this window to cancel.", "Trebuchet18",150,80, BOOMBOX.config.themes[themesel].text_1, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
				for i=0,270,90 do
					local t = (i/180+CurTime()*3)*math.pi
					local c,s = math.cos(t),math.sin(t)
					draw.NoTexture()
					surface.SetDrawColor(BOOMBOX.config.themes[themesel].text_1)
					surface.DrawTexturedRectRotated(150+c*12,50+s*12,5,5,-t*10)
				end	
			end
			local html = vgui.Create( "DHTML" , frame )
			html:SetSize(0,0)
			html:OpenURL("https://ycapi.org/iframe/?v="..id.."=mp3")
			html:AddFunction("gmod","cb",function(str)
				print(str)
				if not str then print("FAILED YOUTUBE CONVERSION; ABORTING") frame:Close() return end
				data.ref = str
				callback(data)
				frame:Close()
			end)
			html:QueueJavascript([[
				function checkname() {
					var ref = document.getElementById("file").getAttribute("href");
					if(ref.length>0) {
						gmod.cb(ref);
					} else {
						setTimeout(checkname,500);
					}
				}
				checkname();
			]])
			frame:MakePopup()
		end

		data.name = str.name

		data.artist = str.artist

		local t = string.Explode(":",str.time)
		data.time = 0
		for i=1,#t do
			data.time = data.time*60
			data.time = data.time + tonumber(t[i])
		end

		return data
	end
	ytprovider.makelist = function(body)
		local f = function(callback)
			local frame = vgui.Create( "DFrame" )
			frame:SetSize( 300, 300 )
			frame:SetTitle( "" )
			frame:SetVisible( true )
			frame:SetPos(-300,0)
			
			local html = vgui.Create( "DHTML" , frame )
			html:SetSize(0,0)
			html:SetHTML(body)
			html:AddFunction("gmod","cb",function(str)
				if(type(str)=="string") then 
					local json = util.JSONToTable(str)
					if(json) then
						local ls = {}
						for k,v in pairs(json) do
							ls[#ls+1]=ytprovider.extractinfo(v)
						end
						callback(ls)
					end
				end
				frame:Close()
			end)
			html:QueueJavascript([[
				function checkname() {
					var elements = document.getElementsByClassName("yt-lockup-video");
					var lists = [];
					for(var i = 0; i < elements.length; i++) {
						var vidd = elements[i];
						var islive = vidd.getElementsByClassName("yt-badge-live");
						if(islive.length==0) {
							lists.push({
								ref: vidd.getAttribute("data-context-item-id"),
								name: vidd.getElementsByClassName("yt-lockup-title")[0].getElementsByClassName("yt-uix-tile-link")[0].getAttribute("title"),
								artist: vidd.getElementsByClassName("yt-lockup-byline")[0].childNodes[0].innerHTML,
								time: vidd.getElementsByClassName("video-time")[0].innerHTML
							});
						}
					}
					gmod.cb(JSON.stringify(lists));
				}
				setTimeout(checkname,500);
			]])
			frame:MakePopup()
			timer.Simple(5,function() if IsValid(frame) then frame:Close() end end)
		end
		return f
	end

	--

	local defaulttxtval = ""
	local defaultlist = {}

	INTERFACE.opensearch = function(e)
		local frame = vgui.Create("DFrame")
		frame:SetSize(384,512)
		frame:Center()
		frame:SetTitle("")
		frame:SetVisible(true)
		frame:SetDraggable(false)
		frame:MakePopup()
		frame.Paint = function(self, w, h)
			surface.SetDrawColor( BOOMBOX.config.themes[themesel].primary )
			surface.DrawRect( 0,0,w,h )
			surface.SetDrawColor( BOOMBOX.config.themes[themesel].secondary )
			surface.DrawOutlinedRect( 2,2,w-4,h-4 )
		end

		local sheet = vgui.Create( "DPropertySheet", frame )
		sheet:SetSize(364,40)
		sheet:SetPos(10,20)
		sheet:SetPadding(0)

		local nlist = vgui.Create( "DListView", frame )
		nlist:SetPos(10,70)
		nlist:SetSize(364,396)

		nlist:SetMultiSelect( false )
		local c = nlist:AddColumn( BOOMBOX.lang.time )
		c:SetWidth(50)
		c = nlist:AddColumn( BOOMBOX.lang.artist )
		c:SetWidth(100)
		c = nlist:AddColumn( BOOMBOX.lang.song )
		c:SetWidth(214)
		for i,v in ipairs(defaultlist) do
			nlist:AddLine(formatt(v.time),v.artist,v.name)
		end

		local function addprovider(sheet,name,searchlink,listfunc,icon,tooltip)
			local nselect = vgui.Create( "DTextEntry", sheet )	
			local pnl = sheet:AddSheet( name, nselect, icon ,false,false,tooltip)
			nselect:Dock(NODOCK )
			nselect:SetPos( 0,20 )
			nselect:SetText( defaulttxtval )
			nselect.OnEnter = function( self )
				local etxt = self:GetValue() or ""
				defaulttxtval = etxt
				etxt = etxt:gsub ("\n", "\r\n")
				etxt = etxt:gsub ("([^%w ])",
					function (c) 
						return string.format ("%%%02X", string.byte(c)) 
					end
				)
				etxt = etxt:gsub (" ", "+")

				if etxt~="" then
					nlist:Clear()
					nlist:AddLine("","Loading","")
					http.Fetch(searchlink..etxt,function(body)
						local ret = listfunc(body)
						if type(ret)=="function" then
							ret(function(ls)
								defaultlist = ls
								if IsValid(nlist) then
									nlist:Clear()
									for i=1,#defaultlist do
										local mdata = defaultlist[i]
										nlist:AddLine(formatt(mdata.time),mdata.artist,mdata.name)
									end
								end
							end)
						else
							defaultlist = ret
							if IsValid(nlist) then
								nlist:Clear()
								for i=1,#defaultlist do
									local mdata = defaultlist[i]
									nlist:AddLine(formatt(mdata.time),mdata.artist,mdata.name)
								end
							end
						end
					end,function(err)
						defaultlist = {}
						if IsValid(nlist) then
							nlist:Clear()
						end
					end)
				end
			end
			return pnl.Tab
		end
		local yttab = addprovider(sheet,"YouTube","https://www.youtube.com/results?search_query=",ytprovider.makelist,"icon16/film.png","Improved!")

		local selects = vgui.Create("DButton",frame)
		selects:SetPos(10,476)
		selects:SetSize(364,26)
		selects:SetText("")
		selects.Paint = function(self, w, h)
			surface.SetDrawColor( BOOMBOX.config.themes[themesel].secondary )
			surface.DrawRect( 0,0,w,h )
			local c = BOOMBOX.config.themes[themesel].text_2
			if nlist:GetSelectedLine() then
				c = BOOMBOX.config.themes[themesel].text_1
			end
			draw.SimpleText( BOOMBOX.lang.select, "Trebuchet24",w/2,h/2, c, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		end
		selects.DoClick = function()
			local l = nlist:GetSelectedLine()
			if l then
				frame:Close()
				if IsValid(e.audio) then
					sendupdate(e,4)
				end
				if type(defaultlist[l].ref)=="function" then
					defaultlist[l].ref(defaultlist[l],function(data)
						sendupdate(e,1,true,data)
					end)
				else
					sendupdate(e,1,true,defaultlist[l])
				end
			end
		end
		local osel = sheet.SetActiveTab
		function sheet:SetActiveTab( active )
			if active.disabled then return end
			active:GetPanel():RequestFocus()
			osel(self,active)
		end
		sheet:GetChild(1):RequestFocus()
	end

	INTERFACE.opensettings = function(e)
		local frame = vgui.Create("DFrame")
		frame:SetSize(222,160)
		frame:Center()
		frame:SetTitle("")
		frame:SetVisible(true)
		frame:SetDraggable(false)
		frame:MakePopup()
		frame.Paint = function(self, w, h)
			surface.SetDrawColor( BOOMBOX.config.themes[themesel].primary )
			surface.DrawRect( 0,0,w,h )
			surface.SetDrawColor( BOOMBOX.config.themes[themesel].secondary )
			surface.DrawOutlinedRect( 2,2,w-4,h-4 )
		end

		local nlist = vgui.Create( "DListView", frame )
		nlist:SetPos(10,25)
		nlist:SetSize(100,125)

		nlist:SetMultiSelect( false )
		nlist:AddColumn( BOOMBOX.lang.theme )
		for i,v in ipairs(BOOMBOX.config.themes) do
			nlist:AddLine(v.name)
		end
		nlist.OnRowSelected = function(self,ind)
			themesel = ind
		end

		local nlist = vgui.Create( "DListView", frame )
		nlist:SetPos(112,25)
		nlist:SetSize(100,125)

		nlist:SetMultiSelect( false )
		nlist:AddColumn( BOOMBOX.lang.skin )
		local tb= {}
		for k,v in pairs(BOOMBOX.config.skins) do
			nlist:AddLine(k)
			tb[#tb+1]=v
		end
		nlist.OnRowSelected = function(self,ind,l)
			sendupdate(e,8,tb[ind])
		end

	end

	INTERFACE.loaddata = function(data,callback)
		callback(nil)
	end

	net.Receive("openboomboxcls",function()
	local frame = vgui.Create("DFrame")
		frame:SetSize(222,160)
		frame:Center()
		frame:SetTitle("")
		frame:SetVisible(true)
		frame:SetDraggable(false)
		frame:MakePopup()
		frame.Paint = function(self, w, h)
			surface.SetDrawColor( BOOMBOX.config.themes[1].primary )
			surface.DrawRect( 0,0,w,h )
			surface.SetDrawColor( BOOMBOX.config.themes[1].secondary )
			surface.DrawOutlinedRect( 2,2,w-4,h-4 )
	  draw.SimpleText( BOOMBOX.lang.volume, "Trebuchet16",10,40, c, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
		end

	local vslider = vgui.Create( "DNumSlider", frame )	
	vslider:SetPos(10,60)
	vslider:SetSize(202,10)
	function vslider:PerformLayout() self.Label:SetWide(0) end
	vslider:SetConVar("boombox_volume")
	function vslider.TextArea:Paint(w,h)
		draw.SimpleText( self:GetValue(), "Trebuchet16",w/2,h/2, c, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	end
	end)


	BOOMBOX.interface = INTERFACE
end
