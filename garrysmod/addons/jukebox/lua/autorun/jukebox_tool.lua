local SWEP = {}
SWEP.Primary = {}
SWEP.Secondary = {}

if (CLIENT) then
	SWEP.PrintName        	= "Jukebox Spawn Tool"			   
	SWEP.Slot				= 0  
	SWEP.SlotPos			= 100    
	SWEP.DrawCrosshair		= true
	SWEP.DrawAmmo    		= false

end



SWEP.Author					= ""
SWEP.Instructions	 	    = "Left Click to add a spawn\nRight click to reload spawns\nReload to wipe spawns"
SWEP.Spawnable				= true
SWEP.AdminOnly				= true
SWEP.ViewModel				= "models/weapons/c_pistol.mdl"
SWEP.WorldModel				= "models/weapons/w_crowbar.mdl"
SWEP.Weight					= 5   
SWEP.AutoSwitchTo			= false   
SWEP.AutoSwitchFrom			= false  
SWEP.HoldType 				= "pistol"
SWEP.UseHands 				= true
SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= -1
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "negus"
SWEP.Primary.Delay			= 0.1
SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "" 

function SWEP:CanPrimaryAttack()
	return true
end

function SWEP:CanSecondaryAttack()
	return true
end

function SWEP:PrimaryAttack()
	self.LastUse = self.LastUse or CurTime() + self.Primary.Delay
	if self.LastUse + self.Primary.Delay > CurTime() then return end
	self.LastUse = CurTime()
	if CLIENT then
		LocalPlayer():ConCommand("-attack")
		net.Start("JukeboxSpawn")
			net.WriteUInt(1,8)
		net.SendToServer()
	end
end

function SWEP:SecondaryAttack()
	self.LastUse = self.LastUse or CurTime()
	if self.LastUse + self.Primary.Delay > CurTime() then return end
	self.LastUse = CurTime()
	if CLIENT then
		LocalPlayer():ConCommand("-attack2")
		net.Start("JukeboxSpawn")
			net.WriteUInt(3,8)
		net.SendToServer()
	end
end

function SWEP:Reload()
	self.LastUse = self.LastUse or CurTime()
	if self.LastUse + self.Primary.Delay > CurTime() then return end
	self.LastUse = CurTime()
	if CLIENT then
		LocalPlayer():ConCommand("-reload")
		net.Start("JukeboxSpawn")
			net.WriteUInt(2,8)
		net.SendToServer()
	end
end

weapons.Register(SWEP,"jukebox_tool")