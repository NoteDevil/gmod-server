include("shared.lua")

function ENT:Think()
	if not self.OverlayText then
		local name = self:GetTitle() ~= "" and " - "..self:GetTitle() or ""
		self.OverlayText = "Книга"..name.."\nНажмите <color=0,200,0>".. srp_util.UseKey .."</color>, чтобы открыть"
	end
end

local function GetHTMLContent(link)
	if not LocalPlayer().Books then LocalPlayer().Books = {} end
	if not LocalPlayer().Books[link] then
		
	else
		return LocalPlayer().Books[link]
	end
end

local function openHTML( content )

	local f = vgui.Create("DFrame")
	f:SetSize(450,600)
	f:SetTitle( "Книга" )
	f:Center()
	f:MakePopup()
	f.Paint = function(self, w, h)
		draw.SRPBackGround(4, 0, 0, w, h)
	end
	
	local h = vgui.Create("DHTML", f)
	h:Dock(FILL)
	h:SetHTML(content)

	LocalPlayer().BookHTML = h

end

net.Receive("SRP_Library.OpenMenu", function()
	LocalPlayer().Books = LocalPlayer().Books or {}
	local pnl = LocalPlayer().BookHTML

	local ent = net.ReadEntity()
	if not IsValid(ent) or IsValid(pnl) then return end

	local link = ent:GetLink()
	if LocalPlayer().Books[link] then
		openHTML( LocalPlayer().Books[link] )
	else
		openHTML([[
<!DOCTYPE html>
<html>
	<head>
		<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/font-awesome/4.7.0/css/font-awesome.min.css">
	</head>
	<body style="background: rgb(26,31,35);">      
        <div style="
            position: absolute;
            top: 50%;
            left: 50%;
            width: 62px;
            height: 62px;
						margin: -31px -31px;
						color: #eeeeee;
        "><i class="fa fa-refresh fa-spin fa-3x fa-fw"></i></div>
	</body>
</html>
		]])

		http.Fetch( "http://octothorp.team:1234/ParseLink?link="..link,
	    function( body, len, headers, code )
	      LocalPlayer().Books[link] = body
	      LocalPlayer().BookHTML:SetHTML( LocalPlayer().Books[link] )
	    end,
	    function( error )
	      print("ERROR UPDATING BOOK CONTENT")
	    end
		)
		content = GetHTMLContent(ent:GetLink())
	end

end)