util.AddNetworkString("SRP_Diary.SyncMarks")

local meta = FindMetaTable("Player")

function meta:SetMarks(marks)
	self.marks = marks
	self:SyncMarks()
end

function meta:AddMarks(subject, mark)
	if not self.marks[subject] then self.marks[subject] = {} end
	table.insert(self.marks[subject], mark)
	self:SyncMarks()
end

function meta:ResetMarks()
	for k,v in pairs(self.marks) do
		self.marks[k] = {}
	end
end

function meta:GetMarks()
	return self.marks
end

function meta:IsPassedLevel()
	local tbl = self:GetTotalMarks(self.marks)
	if table.Count(tbl) == 0 then return false end
	for k,v in pairs(tbl) do
		if v < SRP_Diary.Levels[self:GetLevel()] then
			return false
		end
	end
	return true
end

function meta:SetLevel(lvl)
	self:SetNWInt("Level", lvl)
end

function meta:AddLevel(num)
	self:SetNWInt("Level", self:GetNWInt("Level") + num)
end

function meta:SyncMarks()
	
	if self:IsPassedLevel() then
		self:ResetMarks()
		self:AddLevel(1)
	end
	
	MySQLite.query("UPDATE `srp_diary` SET `level` = "..self:GetLevel()..", `marks` = '"..util.TableToJSON(self.marks).."' WHERE `steamid` = '"..self:SteamID().."';")
end

function meta:ClearDiaries()
	for k,v in pairs(ents.FindByClass("ent_diary")) do
		if v:Getowning_ent() == self then
			v:Remove()
		end
	end
end

hook.Add("DatabaseInitialized", "SRP_Diary.DatabaseInitialized", function()
	MySQLite.query("CREATE TABLE IF NOT EXISTS `srp_diary` (`steamid` VARCHAR(255) PRIMARY KEY, `level` INTEGER, `marks` TEXT);")
end)

hook.Add( "PlayerIsLoaded", "SRP_Diary.PlayerIsLoaded", function(ply)
	
	ply.marks = {}
	MySQLite.query("SELECT * FROM `srp_diary` WHERE `steamid` = '"..ply:SteamID().."';", function(result)
		if result then
			local marks = util.JSONToTable(result[1].marks)
			ply:SetLevel(tonumber(result[1].level))
			ply:SetMarks(marks)
		else
			MySQLite.query("INSERT INTO `srp_diary`(`steamid`, `level`, `marks`) VALUES ('"..ply:SteamID().."', 1, '[]');")
			ply:SetLevel(1)
			ply:SyncMarks()			
		end
	end)
end)

hook.Add("PlayerDisconnected", "SRP_Diary.PlayerDisconnected", function(ply)
	ply:ClearDiaries()
	ply:SyncMarks()
end)

hook.Add("PlayerSay", "SRP_Diary.PlayerSay", function(ply, text)
	text = string.Explode(" ", text)
	if text[1] == "/diary" then
		ply:ClearDiaries()

		local diary_ent = ents.Create("ent_diary")
		diary_ent:SetPos(ply:GetPos()+ply:GetAimVector()*45+ply:GetUp()*50)
		diary_ent:Spawn()
		diary_ent:Setowning_ent(ply)
		diary_ent:DropToFloor()
		return 
	end
end)

local function updateScale( ply )

	timer.Simple(0, function()
		if not IsValid(ply) then return end
		if ply:getJobTable().pupil then
			local scale = 0.7 + (0.3) * (ply:GetNWInt("Level") / 11)
			ply:SetModelScale( scale )
			ply:SetViewOffset( Vector(0, 0, 64) * scale )
			ply:SetViewOffsetDucked( Vector(0, 0, 28) * scale )
			ply.lastPupilScale = scale
		elseif ply:GetModelScale() == 1 then
			ply:SetViewOffset( Vector(0, 0, 64) )
			ply:SetViewOffsetDucked( Vector(0, 0, 28) )
		end
	end)

end

hook.Add("PlayerSetModel", "SRP_Diary.PlayerSetModel", updateScale )
hook.Add("PlayerLoadout", "SRP_Diary.PlayerLoadout", updateScale )
hook.Add("PlayerSpawn", "SRP_Diary.PlayerSpawn", updateScale )
hook.Add("playerUnArrested", "SRP_Diary.playerUnArrested", updateScale )

util.AddNetworkString 'srp_diary.addMark'
net.Receive('srp_diary.addMark', function(len, ply)

	local subject = net.ReadString()
	local mark = math.Clamp(net.ReadUInt(8), 1, 5)
	
    local ent = ply:GetEyeTrace().Entity
    if not IsValid(ent) or ent:GetClass() ~= "ent_diary" then DarkRP.notify(ply, NOTIFY_ERROR, 3, "Нужно смотреть на дневник!") return end
    
    local targetPly = ent:Getowning_ent()
    if not IsValid( targetPly ) then return end

    if not targetPly:getJobTable().pupil then DarkRP.notify(ply, NOTIFY_ERROR, 4, "Оценки можно ставить только школьникам") return end
    if targetPly.MarkCooldown and targetPly.MarkCooldown > CurTime() then DarkRP.notify(ply, NOTIFY_ERROR, 4, "Ему недавно ставили оценку") return end
    -- if ply.MarkGiveCooldown and ply.MarkGiveCooldown > CurTime() then DarkRP.notify(ply, 1, 4, "Вы уже недавно ставили оценку.") return end
    
    local job = ply:getJobTable()
    if job.subject ~= subject and ply:Team() ~= TEAM_DIRECTOR then DarkRP.notify(ply, NOTIFY_CLEANUP, 4, "Откуда у тебя этот SWEP?") return end

	targetPly.MarkCooldown = CurTime() + 120
	-- ply.MarkGiveCooldown = CurTime() + 10

    local effectdata = EffectData()
	effectdata:SetOrigin(ent:GetPos())
	effectdata:SetMagnitude(2.5)
	effectdata:SetScale(2)
	effectdata:SetRadius(3)
    util.Effect("Sparks", effectdata, true, true)
    ent:EmitSound("ambient/alarms/warningbell1.wav", 70, 150, 0.8 )

    DarkRP.notify(targetPly, 0, 4, "Тебе поставили <color=50,200,50>"..mark.."</color>, предмет: "..subject)
    DarkRP.notify(ply, 0, 4, "Ты поставил <color=50,200,50>"..mark.."</color> ученику: <color=50,200,50>"..targetPly:Name().."</color>")
    targetPly:AddMarks(subject, mark)

end)
