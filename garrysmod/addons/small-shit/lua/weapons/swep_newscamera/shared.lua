
-----------------------------------------------------
SWEP.PrintName = "News Camera"
SWEP.Slot = 4
SWEP.SlotPos = 1
SWEP.DrawAmmo = false
SWEP.DrawCrosshair = false

SWEP.Author = "Sinavestos"
SWEP.Instructions = "Equip to use"
SWEP.Contact = ""
SWEP.Purpose = ""

SWEP.ViewModelFOV = 62
SWEP.ViewModelFlip = false
SWEP.AnimPrefix	 = "rpg"

SWEP.ViewModel = Model( "models/maxofs2d/camera.mdl" )
SWEP.WorldModel = ""

SWEP.Spawnable = false
SWEP.AdminSpawnable = true
SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = 0
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = ""

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = 0
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = ""

SWEP.FrameVisible = false
SWEP.OnceReload = false

if CLIENT then
	function SWEP:GetViewModelPosition( pos, ang )
		pos = pos + ( ang:Right() * 8 )
		return pos, ang
	end
end


function SWEP:Initialize()
	self:SetHoldType("rpg")
end

function SWEP:Deploy()
	if SERVER then self:TurnOnCamera() end
	return true
end

function SWEP:Holster()
	if SERVER then self:TurnOffCamera() end
	return true
end

function SWEP:OnRemove()
	if SERVER then self:TurnOffCamera() end
end

/*---------------------------------------------------------
Name: SWEP:Initialize()
Desc: Called when the weapon is first loaded
---------------------------------------------------------*/

function UpdateRenderTarget( ent )
	if ( !ent || !ent:IsValid( ) ) then 
		SafeRemoveEntity( RenderTargetCamera ) 
		SafeRemoveEntity( RenderThing )
		return 
	end

	local angle = ent:EyeAngles()
	pos = ent:GetShootPos() + (angle:Forward() * 40)
	if ( !RenderTargetCamera || !RenderTargetCamera:IsValid() ) then

		RenderTargetCamera = ents.Create( "point_camera" )
		RenderTargetCamera:SetKeyValue( "GlobalOverride", 1 )
		RenderTargetCamera:SetPos( pos )
		RenderTargetCamera:SetAngles( angle )
		RenderTargetCamera:Spawn( )
		RenderTargetCamera:Activate( )
		RenderTargetCamera:Fire( "SetOn", "", 0.0 )
		RenderThing = ents.Create( "camera_node" )
		RenderThing:SetPos(pos)
		RenderThing:SetAngles(angle)
		RenderThing:Spawn( )
		RenderThing:Activate( )
		RenderTargetCamera:SetParent(RenderThing)
	end
	
	RenderThing:GetPhysicsObject( ):SetPos( pos )
	RenderThing:GetPhysicsObject( ):SetVelocity( ent:GetVelocity( ) )
	RenderThing:GetPhysicsObject( ):SetAngles( angle )

	RenderTargetCameraProp = ent
	
end

function SWEP:TurnOnCamera( )
	self:SetHoldType( "slam" )
	if ( SERVER ) then
		if not IsValid(self.Owner.cameraent) then 
			self.Owner:DrawViewModel(true)
			self.Owner:DrawWorldModel(false)
			self.Owner.cameraent = ents.Create( "ent_camera" )
			self.Owner.cameraent:SetOwner(self.Owner) 
			self.Owner.cameraent:SetParent(self.Owner)
			self.Owner.cameraent:SetPos(self.Owner:GetPos())
			self.Owner.cameraent:Spawn()
			self.Owner.cameraent:SetModel( "models/maxofs2d/camera.mdl" )
		end
		SetGlobalEntity('CameraMan', self.Owner)
	end
	self.enabled = true
	UpdateRenderTarget( self.Owner )
end

function SWEP:TurnOffCamera()
	UpdateRenderTarget( nil )
	self.enabled = false
	if self.Owner and self.Owner.cameraent and IsValid( self.Owner.cameraent ) then self.Owner.cameraent:Remove() end
	SetGlobalEntity('CameraMan', NULL)
end

function SWEP:Think()
	if self.enabled then UpdateRenderTarget( self.Owner ) end
end

if SERVER then
	hook.Add( "SetupPlayerVisibility", "NewsCamera.AddRTCamera", function( ply )
		local camera_man = GetGlobalEntity("CameraMan")
		if IsValid(camera_man) and camera_man ~= ply then
			AddOriginToPVS( camera_man:GetPos() )
		end
	end)
end