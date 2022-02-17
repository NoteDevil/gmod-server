srp_util = srp_util or {}
srp_util.UseKey = string.upper( input.LookupBinding("use") )

function draw.ShadowText(text, font, x, y, color, allignx, alligny)
	draw.SimpleText(text, font, x+1, y+1, Color(0,0,0), allignx, alligny)
	draw.SimpleText(text, font, x, y, color, allignx, alligny)
end

function draw.SRPBackGround(round, x, y, w, h, alpha)
	alpha = alpha and alpha or 255

	draw.RoundedBox( round, x, y, w, h, Color(83,104,112, alpha) )
	draw.RoundedBox( round, x+1, y+1, w-2, h-2, Color(32,36,40, alpha) )
end

function draw.SRPBackGroundColored(round, x, y, w, h, color)
	alpha = alpha and alpha or 255

	draw.RoundedBox( round, x, y, w, h, color )
	draw.RoundedBox( round, x+1, y+1, w-2, h-2, Color(32,36,40) )
end

surface.CreateFont("Util.MainFont", {
	font = "Roboto Bold",
	size = 19,
	weight = 500,
	extended = true,
})

function draw.OverlayText(ent)
	local text = ent.OverlayText
	local markup_obj = markup.Parse("<font=Util.MainFont>"..text.."</font>")
	local w, h = markup_obj:GetWidth(), markup_obj:GetHeight()
	local pos = (ent:GetPos() + Vector(0,0,-ent:OBBMins().z)):ToScreen()

	local x, y = math.floor(pos.x-w/2), math.floor(pos.y-h-100)

	draw.SRPBackGround(4, x, y, w + 20, h + 20)
	draw.SimpleText("u","marlett", x+w/2+10, y+h+14, Color(83,104,112), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
	draw.SimpleText("u","marlett", x+w/2+10, y+h+13, Color(32,36,40), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)

	markup_obj:Draw( x+10, y+10, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 255 )
end

hook.Add("HUDPaint", "ENT.OverlayText", function()
	local ent = LocalPlayer():GetEyeTrace().Entity
	if not IsValid(ent) then return end
	if ent:GetPos():DistToSqr(LocalPlayer():GetPos()) > 200*200 then return end
	if ent.OverlayText then
		draw.OverlayText(ent)
	end
end)

function srp_util.openHelp()
	local f = vgui.Create("DFrame")
	f:SetSize(800, 600)
	f:Center()
	f:MakePopup()
	f:SetTitle("Школа 666 - Справка")
	f:SetSizable( true )
	f.Paint = function( self, w, h )
		draw.SRPBackGround( 4, 0, 0, w, h )
	end
	
	local h = vgui.Create("DHTML", f)
	h:Dock(FILL)
	h:SetHTML([[
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

	http.Fetch( "http://rp.octothorp.team/school666/help/",
	function( body, len, headers, code )
		if not IsValid(h) then return end
		h:SetHTML(body)
	end,
	function( error )
		-- We failed. =(
	end)
end

hook.Add("PlayerIsLoaded", "srp_util.HelpWindow", srp_util.openHelp )
