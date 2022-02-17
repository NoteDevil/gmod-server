
//This is a bunch of helper function for getting connected devices,
//updating devices, getting linked generators etc

AddCSLuaFile("bitminers2_config.lua")
include("bitminers2_config.lua")

local P = FindMetaTable("Player")

util.AddNetworkString("BM2.OpenTerminal")

//Used to tell the client to open a terminal for this entity.
function P:OpenBitminerTerminal(bitminer)
	net.Start("BM2.OpenTerminal")
		net.WriteEntity(bitminer)
	net.Send(self)
end

function P:SellBitcoins(bitminer)
	if table.HasValue(bitminer.authorisedPlayers, self) and bitminer.isBitminer then
		self:addMoney(bitminer.bitcoin * BM2CONFIG.BitcoinValue)
		bitminer.bitcoin = 0
		bitminer:SetBitcoinAmount(0)
	end
end

//Can be called on either a power lead, extention lead or plug 1
function BM2GetConnectedDevices(ent, devices)

	//Either set up the table or use the one passed from recussion
	devices = devices or {}

	//Stop here if we are already in the table (To prevent loops)
	if table.HasValue(devices, ent) then return devices end

	//insert ourselfs into the device list
	table.insert(devices, ent)	

	//Now check what we are
	if ent:GetClass() == "bm2_extention_lead" then
		//Loop over all of the sockets
		for i = 1 , 4 do
			if ent.sockets[i].pluggedInEntity ~= nil then
				devices = BM2GetConnectedDevices(ent.sockets[i].pluggedInEntity, devices)
			end
		end
		//Now check what we are pluged into
		if ent.plug ~= nil then
			devices = BM2GetConnectedDevices(ent.plug, devices)
		end
	elseif ent:GetClass() == "bm2_plug_1" then
		if ent.connectedDevice ~= nil then
			devices = BM2GetConnectedDevices(ent.connectedDevice, devices)
		end
		devices = BM2GetConnectedDevices(ent.parent, devices)
		if ent.parent ~= nil and ent.parent:GetClass() == "bm2_power_lead" and ent.parent.connectedDevice ~= nil then
			if not table.HasValue(devices, ent.parent.connectedDevice) then
				table.insert(devices, ent.parent.connectedDevice)
			end
		end
	elseif ent:GetClass() == "bm2_power_lead" then
		if ent.connectedDevice ~= nil then
			devices = BM2GetConnectedDevices(ent.connectedDevice, devices)
		end
		devices = BM2GetConnectedDevices(ent.plug, devices)
	elseif ent:GetClass() == "bm2_generator" then
		for i = 1 , 2 do
			if ent.sockets[i].pluggedInEntity ~= nil then
				devices = BM2GetConnectedDevices(ent.sockets[i].pluggedInEntity, devices)
			end
		end
	end

	//Return the device
	return devices
end

//Triggers an update for all these devices to store the devices there connected to. When ever something is connected of disconected then this needs to be called
function BM2UpdateAllConnectedDevices(ent)

	//These are entities that dont need a copy of connected devices.
	local skipEntities = {
		"bm2_plug_1",
		"bm2_extention_lead",
		"bm2_power_lead"
	}

	//Get the devices in the circit related to the entity
	local devices = BM2GetConnectedDevices(ent)

	//Update devices table on the devices required.
	for k ,v in pairs(devices) do
		if not table.HasValue(skipEntities, devices) then
			v.devices = devices
			if v.OnDevicesUpdated then
				v:OnDevicesUpdated()
			end
		end
	end

	//Update devices table on the devices required.
	for k ,v in pairs(devices) do
		if not table.HasValue(skipEntities, devices) then
			if v.OnDevicesUpdated then
				v:OnDevicesUpdated()
			end
		end
	end
end

//Takes any bitminer and attemps to find the generator connected to it.
//Will return false is no generator is on the same cirv
function BM2GetConnectedGenerator(ent)
	if ent.devices == nil then return false end //There are no devices on this entity
	for k ,v in pairs(ent.devices) do
		if v:GetClass() == "bm2_generator" then
			return v
		end
	end
	return false
end

//Takes a generator and returns all bitminers (in a table) connected to it
//Returns false if it is connected to no devices at all
function BM2GetConnectedMiners(ent)
	if ent.devices == nil then return false end
	local miners = {}
	for k ,v in pairs(ent.devices) do
		local class = "unknown"
		if v.GetClass then class = v:GetClass() end
		if class == "bm2_bitminer_1" or class == "bm2_bitminer_2" or class == "bm2_bitminer_rack" then
			table.insert(miners, v)
		end
	end
	return miners
end

//Networking stuff here
util.AddNetworkString("BM2.Client.TerminalPrint")
util.AddNetworkString("BM2.Command.Mining")
util.AddNetworkString("BM2.Command.SellBitcoins")
util.AddNetworkString("BM2.Command.Upgrade")
util.AddNetworkString("BM2.Command.Eject")

//Handles mining toggling
net.Receive("BM2.Command.Mining", function(len, ply)

	local ent = net.ReadEntity()
	local state = net.ReadBool()

	if ent.isBitminer then
		if table.HasValue(ent.authorisedPlayers, ply) then
			local info = ent:UpdateMiningState(state)
			net.Start("BM2.Client.TerminalPrint")
			net.WriteString(info)
			net.Send(ply)
		end
	end
end)

//Sell bitcoins
net.Receive("BM2.Command.SellBitcoins", function(len, ply)
	local e = net.ReadEntity()
	if e ~= nil then
		ply:SellBitcoins(e)
	end
end)

//Handles ejecting servers.
net.Receive("BM2.Command.Eject", function(len, ply)
	local e = net.ReadEntity()
	local index = net.ReadInt(8)
	print("Received!!!", e, index)
	if e ~= nil and table.HasValue(e.authorisedPlayers or {}, ply) then
		if e:GetClass() == "bm2_bitminer_rack" then
			if index > 0 and index < 9 then
				//Eject the server if it exists
				if e.rack[index] ~= nil then
					e:RemoveServer(index)
					net.Start("BM2.Client.TerminalPrint")
					net.WriteString("The server has been ejected.")
					net.Send(ply)
				else
					net.Start("BM2.Client.TerminalPrint")
					net.WriteString("There is not server in that slot, type 'SERVERS' for a list of connected servers.")
					net.Send(ply)
				end
			else
				net.Start("BM2.Client.TerminalPrint")
				net.WriteString("The index you supplied is not in range (1-8)")
				net.Send(ply)
			end
		end
	end
end)

//Upgrade the bitminers
net.Receive("BM2.Command.Upgrade", function(len, ply)
	local e = net.ReadEntity()
	local type = net.ReadBool() //false = 1 , true = 2
	if e ~= nil and e.isBitminer then
		if table.HasValue(e.authorisedPlayers, ply) then
			if type then
				//Upgrade Cores
				if e.upgrades.CORES.cost[e.upgradeTracker.cores + 1] ~= nil then
					if ply:canAfford(e.upgrades.CORES.cost[e.upgradeTracker.cores + 1]) then
						ply:addMoney(e.upgrades.CORES.cost[e.upgradeTracker.cores + 1] * -1)
						e.upgradeTracker.cores = e.upgradeTracker.cores + 1
						e:SetCoreUpgrade(e.upgradeTracker.cores)
						e.cores = e.cores + 1
						e:SetCoreCount(e.cores)
						net.Start("BM2.Client.TerminalPrint")
						net.WriteString("Your upgrade has been installed (CORE), type info to see the new specifications!")
						net.Send(ply)
					else
						net.Start("BM2.Client.TerminalPrint")
						net.WriteString("You cannot afford this upgrade!")
						net.Send(ply)
					end
				end
			else
				//Upgrade Cores
				if e.upgrades.CPU.cost[e.upgradeTracker.cpu + 1] ~= nil then
					if ply:canAfford(e.upgrades.CPU.cost[e.upgradeTracker.cpu + 1]) then
						ply:addMoney(e.upgrades.CPU.cost[e.upgradeTracker.cpu + 1] * -1)
						e.clockSpeed = e.clockSpeed + e.upgrades.CPU.amountPerUpgrade
						e.upgradeTracker.cpu = e.upgradeTracker.cpu + 1
						e:SetClockSpeed(e.clockSpeed)
						e:SetCPUUpgrade(e.upgradeTracker.cpu)
						net.Start("BM2.Client.TerminalPrint")
						net.WriteString("Your upgrade has been installed (CPU), type info to see the new specifications!")
						net.Send(ply)
					else
						net.Start("BM2.Client.TerminalPrint")
						net.WriteString("You cannot afford this upgrade!")
						net.Send(ply)
					end
				end
			end
		end
	end
end)
