local PANEL = {}

function PANEL:Paint(w, h)
end

function PANEL:AddSubMenu()

	local SubMenu = vgui.Create("UPMenu", self)
		SubMenu:SetVisible( false )
		SubMenu:SetParent( self )

	self:SetSubMenu( SubMenu )

	return SubMenu

end

derma.DefineControl( "UPMenuOption", "Menu option", PANEL, "DMenuOption" )


local PANEL = {}

function PANEL:Paint(w, h)
	local x, y = self:GetPos()
	DGF4:drawBlur( x, y )
	draw.RoundedBox(0, 0, 0, w, h, Color(0,0,0, 200))
end


function PANEL:AddOption( strText, funcFunction )

	local pnl = vgui.Create( "UPMenuOption", self )
	pnl:SetMenu( self )
	pnl:SetText( strText )
	pnl:SetTextColor(color_white)
	if ( funcFunction ) then pnl.DoClick = funcFunction end
	pnl.Paint = function(slf, w, h)
		if slf:IsHovered() then
			draw.RoundedBox(0, 0, 0, w, h, Color(110, 110, 110, 150))
		end
	end
	self:AddPanel( pnl )

	return pnl

end

function PANEL:AddSubMenu( strText, funcFunction )

	local pnl = vgui.Create( "UPMenuOption", self )
	local SubMenu = pnl:AddSubMenu( strText, funcFunction )

	pnl:SetText( strText )
	pnl:SetTextColor(color_white)
	if ( funcFunction ) then pnl.DoClick = funcFunction end
	pnl.Paint = function(slf, w, h)
		if slf:IsHovered() then
			draw.RoundedBox(0, 0, 0, w, h, Color(110, 110, 110, 150))
		end
	end
	self:AddPanel( pnl )

	return SubMenu, pnl

end

derma.DefineControl( "UPMenu", "Another Menu", PANEL, "DMenu" )
