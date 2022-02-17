


SWEP.BreakChance = 3	-- 3% what lockpick breaking, if you fail. -1 to unbreakable lockpick
timer.Simple(3,function() 
AddCustomShipment("LockPick VIP", {
	model = "models/custom/lockpick2.mdl",
	entity = "weapon_lockpick_vip",			-- classname (folder name)
	price = 215,
	amount = 10,
	seperate = true,
	pricesep = 7000,
	noship = true,
	allowed = {TEAM_THIEF},
	customCheck = function(ply) return ply:IsUserGroup("superadmin") end
})
end)
--------------------------------------------------
--------------------------------------------------
--------------------------------------------------
SWEP.Sound = Sound("physics/wood/wood_box_impact_hard3.wav")
SWEP.LockPickTime = 30

AddCSLuaFile()
if SERVER then
	include("sv_init.lua")
	util.AddNetworkString("lockpick_time")
end

SWEP.HowEasy = 0.02	-- no edit here pls
SWEP.MinTime = 3	-- no edit here pls

 
if CLIENT then
	SWEP.PrintName = "LockPick VIP"			
	SWEP.Author = "CustomHQ"
	SWEP.Contact = "just add on Steam"
	SWEP.Purpose = "Description"
	SWEP.Instructions = "CustomHQ"
	SWEP.Slot      = 2
    SWEP.SlotPos   = 1
	
	
	net.Receive("lockpick_time", function()
		local wep = net.ReadEntity()
		local ent = net.ReadEntity()
		local time = net.ReadUInt(5)

		wep.IsLockPicking = true
		wep.LockPickEnt = ent
		wep.StartPick = CurTime()
		wep.LockPickTime = time
		wep.EndPick = CurTime() + time

		wep.Dots = wep.Dots or ""
		timer.Create("LockPickDots", 0.5, 0, function()
			if not IsValid(wep) then timer.Destroy("LockPickDots") return end
			local len = string.len(wep.Dots)
			local dots = {[0]=".", [1]="..", [2]="...", [3]=""}
			wep.Dots = dots[len]
		end)
	end)
	
end

SWEP.UseHands = true
SWEP.Spawnable = true
SWEP.AdminSpawnable = true

SWEP.Category = "CustomHQ"

SWEP.ViewModel = "models/weapons/Custom/v_lockpick.mdl" 
SWEP.WorldModel = "models/weapons/Custom/w_lockpick.mdl"	
SWEP.HoldType = "knife"

SWEP.Weight = 5
SWEP.AutoSwitchTo = false
SWEP.AutoSwitchFrom = false

SWEP.Primary.Sound = Sound("weapons/clipempty_rifle.wav")
SWEP.Primary.Recoil = 0.1
SWEP.Primary.Damage = 0
SWEP.Primary.NumShots = -1
SWEP.Primary.Cone = 0.05
SWEP.Primary.ClipSize = -1
SWEP.Primary.Delay = 0.06
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "none"

SWEP.DrawCrosshair = false

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"

SWEP.IronSightsPos = Vector(-6, 2.2, -2)
SWEP.IronSightsAng = Vector(0.9, 0, 0)
SWEP.ViewModelFlip = false
SWEP.ViewModelFOV = 65
		
	
function SWEP:Initialize()
	self:SetWeaponHoldType("knife")
	self.LastSound = CurTime() - 2
	self.LastSoundCombo = CurTime() - 2
	self.LastUsed = CurTime() - 2
	self.LastUsed2 = CurTime() - 2
	self.NeedValue = 999
end
	

function SWEP:Deploy()
	self:SetWeaponHoldType("knife")
	return true
end


function SWEP:Succeed()

	local ent = self.LockPickEnt
	self.IsLockPicking = false
	self.LockPickEnt = nil

	if SERVER then timer.Destroy("LockPickSounds") end
	if CLIENT then timer.Destroy("LockPickDots") end

	if not IsValid(ent) then return end

	local override = hook.Call("onLockpickCompleted", nil, self.Owner, true, ent)

	if override then return end

	if ent.isFadingDoor and ent.fadeActivate and not ent.fadeActive then
		ent:fadeActivate()
		timer.Simple(5, function() if IsValid(ent) and ent.fadeActive then ent:fadeDeactivate() end end)
	elseif ent.Fire then
		ent:keysUnLock()
		ent:Fire("open", "", .6)
		ent:Fire("setanimation", "open", .6)
	end
end

function SWEP:Fail()
	self.IsLockPicking = false

	hook.Call("onLockpickCompleted", nil, self.Owner, false, self.LockPickEnt)
	self.LockPickEnt = nil

	if SERVER then timer.Destroy("LockPickSounds") end
	if CLIENT then timer.Destroy("LockPickDots") end
end

function SWEP:Holster()
	self.IsLockPicking = false
	self.LockPickEnt = nil
	if CLIENT then timer.Destroy("LockPickDots") end
	if SERVER then
		timer.Destroy("LockPickSounds")
		self:RemoveLockpick() 
	end
	return true
end

function SWEP:OnDrop()
	if SERVER then
		self:RemoveLockpick()
	end
end

function SWEP:OnRemove()
	if SERVER then
		self:RemoveLockpick()
	end
end

function SWEP:Reload()
	if not self.Weapon:DefaultReload(ACT_VM_RELOAD) then return end
end

function SWEP:GetViewModelPosition(pos, ang )
	if self.Owner:GetEyeTrace().Entity:GetClass() == "prop_door_rotating" then
	if self.Owner:GetPos():Distance(self.Owner:GetEyeTrace().Entity:GetPos()) > 80 then return end
			local f = self.Owner:GetAngles().y
			local res = 0
			
			
			if 90 > f-30 or (f+30 > 90 and f+30< 140) then
				res = 90
			end
			if f>-50 and f<50 then
				res = 0 
			end
			if f<-50 then 
				res = -90
			end
			if math.abs(f) > 150 then
				res = 180
			end

			local sel = res - f
			if sel > 300 then sel = sel - 360 end
			sel = sel*5
			sel = math.Clamp(sel,-20,20)
		return pos, ang + Angle(0,-sel/4,0)
	end
end

function SWEP:SecondaryAttack() 

end 


function SWEP:PrimaryAttack()
	self:SetWeaponHoldType("knife")

	local ent = self.Owner:GetEyeTrace().Entity

	if ent:GetClass() != "prop_door_rotating" then  
		self:BreakOther()
		return
	end
	if SERVER then
	
		if self.LastUsed + 1.2 > CurTime() then return end
		self.LastUsed = CurTime()
	
		if not IsValid(ent.HaveLock) then return end
		if not ent.HaveLock.Door:isLocked() then return end
		
		self.HowEasy = ent.HaveLock.LockPower 
		self.MinTime = ent.HaveLock.MinTime	

		if not IsValid(self.lockpick1) then		
			self:CreateLockpicks()
			
			timer.Simple(self.MinTime, function()
				if IsValid(self) and IsValid(ent) then
					self.NeedValue = ent.SecretValue or 10
				end
			end)
			 
			self:MakeSound()
			self.Doors  = ent
		else
			
			self.lockpick1:SetPos(self.lockpick1:GetPos()+Vector(0,0,0.45)+ent.HaveLock:GetForward()*0.57)
			self.lockpick2:SetPos(self.lockpick2:GetPos()+Vector(0,0,0.3)+ent.HaveLock:GetForward()*0.5)
			self.LastUsed2 = CurTime()
				
			self.lockpick1:SetParent(ent.HaveLock)
			self.lockpick2:SetParent(ent.HaveLock)
					
			self.lockpick1:Fire("SetParentAttachmentMaintainOffset", "palki", 0.00 )
			self.lockpick2:Fire("SetParentAttachmentMaintainOffset", "palki", 0.00 )
				
			if self.OpenDoor then
				ent.HaveLock:AnimOpen()
				ent:keysUnLock()
				timer.Simple(1,function()
					if IsValid(self) then
						self:RemoveLockpick()
					end
				end)
				
			else
				
				ent.HaveLock:AnimFail()
				local rand = math.random(1,100)
				timer.Simple(1.15,function()
					if IsValid(self.lockpick1) then
						self.lockpick1:SetParent(nil)
						self.lockpick2:SetParent(nil)
					end
				end)
				if rand < self.BreakChance then 
				timer.Simple(1,function()
					if IsValid(self) then
						self.Owner:EmitSound("physics/glass/glass_pottery_break2.wav", 100, 100,0.6)
						self:Remove() 
					end
				end)
				end
			end
		end
	end
end

function SWEP:DrawHUD()
	if not self.IsLockPicking or not self.EndPick then return end

	self.Dots = self.Dots or ""
	local w = ScrW()
	local h = ScrH()
	local x,y,width,height = w/2-w/10, h/2-60, w/5, h/15
	draw.RoundedBox(8, x, y, width, height, Color(10,10,10,120))

	local time = self.EndPick - self.StartPick
	local curtime = CurTime() - self.StartPick
	local status = math.Clamp(curtime/time, 0, 1)
	local BarWidth = status * (width - 16)
	local cornerRadius = math.Min(8, BarWidth/3*2 - BarWidth/3*2%2)
	draw.RoundedBox(cornerRadius, x+8, y+8, BarWidth, height-16, Color(255-(status*255), 0+(status*255), 0, 255))

	draw.DrawNonParsedSimpleText(DarkRP.getPhrase("picking_lock") .. self.Dots, "Trebuchet24", w/2, y + height/2, Color(255,255,255,255), 1, 1)
end


if CLIENT then


function SWEP:Think()
	if not self.IsLockPicking or not self.EndPick then return end

	local trace = self.Owner:GetEyeTrace()
	if not IsValid(trace.Entity) or trace.Entity ~= self.LockPickEnt or trace.HitPos:Distance(self.Owner:GetShootPos()) > 100 then
		self:Fail()
	elseif self.EndPick <= CurTime() then
		self:Succeed()
	end
end

end



function SWEP:BreakOther()
	self.Weapon:SetNextPrimaryFire(CurTime() + 2)
	if self.IsLockPicking then return end

	local trace = self.Owner:GetEyeTrace()
	local ent = trace.Entity

	if not IsValid(ent) then return end
	local canLockpick = hook.Call("canLockpick", nil, self.Owner, ent)

	if canLockpick == false then return end
	if canLockpick ~= true and (
			trace.HitPos:Distance(self.Owner:GetShootPos()) > 100 or
			(not GAMEMODE.Config.canforcedooropen and ent:getKeysNonOwnable()) or
			(not ent:isDoor() and not ent:IsVehicle() and not string.find(string.lower(ent:GetClass()), "vehicle") and (not GAMEMODE.Config.lockpickfading or not ent.isFadingDoor))
		) then
		return
	end

	self:SetHoldType("pistol")

	if CLIENT then return end

	local onFail = function(ply) if ply == self.Owner then hook.Call("onLockpickCompleted", nil, ply, false, ent) end end

	-- Lockpick fails when dying or disconnecting
	hook.Add("PlayerDeath", self, fc{onFail, fn.Flip(fn.Const)})
	hook.Add("PlayerDisconnected", self, fc{onFail, fn.Flip(fn.Const)})
	-- Remove hooks when finished
	hook.Add("onLockpickCompleted", self, fc{fp{hook.Remove, "PlayerDisconnected", self}, fp{hook.Remove, "PlayerDeath", self}})

	self.IsLockPicking = true
	self.LockPickEnt = ent
	self.StartPick = CurTime()
	self.LockPickTime = math.Rand(10, 30)
	net.Start("lockpick_time")
		net.WriteEntity(self)
		net.WriteEntity(ent)
		net.WriteUInt(self.LockPickTime, 5) -- 2^5 = 32 max
	net.Send(self.Owner)
	self.EndPick = CurTime() + self.LockPickTime

	timer.Create("LockPickSounds", 1, self.LockPickTime, function()
		if not IsValid(self) then return end
		local snd = {1,3,4}
		self:EmitSound("weapons/357/357_reload".. tostring(snd[math.random(1, #snd)]) ..".wav", 50, 100)
	end)
end


