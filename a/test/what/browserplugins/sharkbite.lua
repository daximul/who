local Plugin = {}

Plugin.PluginName = "Sharkbite"
Plugin.PluginDescription = ""
Plugin.Commands = {}

if tostring(game.PlaceId) ~= "734159876" then return Plugin end

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local ESPLib = loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/Patch-Shack/ToonESP/main/lib3.lua"))();

for indz,Shark in pairs(workspace.Sharks:GetChildren()) do
	while not Shark:FindFirstChild("Body") do wait() end
	while not Shark.Body:FindFirstChild("P") do wait() end
	ESPLib.PartESP(Shark.Body.P, {192, 57, 43}, {192, 57, 43}, tostring(Shark.Name))
end

workspace.Sharks.ChildAdded:Connect(function(Shark)
	while not Shark:FindFirstChild("Body") do wait() end
	while not Shark.Body:FindFirstChild("P") do wait() end
	ESPLib.PartESP(Shark.Body.P, {192, 57, 43}, {192, 57, 43}, tostring(Shark.Name))
end)

local createRandomString = function() return math.random(100000, 999999999) end

local Connections = {}
local lib = {
	["connect"] = function(name, func, path)
		if path ~= nil then
			if Connections[tostring(name)] == nil then Connections[tostring(name)] = path:Connect(func) end
		else
			if Connections[tostring(name)] == nil then Connections[tostring(name)] = RunService.RenderStepped:Connect(func) end
		end
	end,
	["disconnect"] = function(name)
		if Connections[tostring(name)] ~= nil then
			Connections[tostring(name)]:Disconnect()
			Connections[tostring(name)] = nil
		end
	end
}

local DisconnectAll = function()
	for key in pairs(Connections) do
		Connections[key]:Disconnect()
		Connections[key] = nil
	end
	wait(0.1)
end

Plugin.Commands["deleteallboats"] = {
	["ListName"] = ("deleteallboats / deleteboats"),
	["Description"] = ("Sharkbite - Delete All Boats"),
	["Aliases"] = {"deleteboats"},
	["Function"] = function(args, speaker)
		DisconnectAll()
		local Engines = {}
		for _, v in pairs(workspace:GetDescendants()) do
			if v:FindFirstChild("Engine") then
				table.insert(Engines, v)
			end
		end
		for _, v2 in pairs(Engines) do   
    		local EgnRet = v2.Engine.EngineEvent
			lib.connect(createRandomString(), function()
				EgnRet:FireServer(-0, Vector3.new(math.huge, math.huge, 0))
			end)
		end
	end
}

Plugin.Commands["spinallboats"] = {
	["ListName"] = ("spinallboats / spinboats"),
	["Description"] = ("Sharkbite - Spin All Boats"),
	["Aliases"] = {"spinboats"},
	["Function"] = function(args, speaker)
		DisconnectAll()
		local Engines = {}
		for _, v in pairs(workspace:GetDescendants()) do
			if v:FindFirstChild("Engine") then
				table.insert(Engines, v)
			end
		end
		for _, v2 in pairs(Engines) do   
    		local EgnRet = v2.Engine.EngineEvent
    		lib.connect(createRandomString(), function()
        		EgnRet:FireServer(-0, Vector3.new(999999, 999999, 0))
    		end)
		end
	end
}

Plugin.Commands["flareguncrash"] = {
	["ListName"] = ("flareguncrash / flaregunrain"),
	["Description"] = ("Sharkbite - Crash the server with flare guns"),
	["Aliases"] = {"flaregunrain"},
	["Function"] = function(args, speaker)
		DisconnectAll()
		lib.connect(createRandomString(), function() while wait() do workspace.Events.GamePasses.EquipFlareGun:FireServer() end end)
		lib.connect(createRandomString(), function(object)
			if object:IsA("Tool") then
        			wait()
        			object.Parent = Players.LocalPlayer.Character
        			object.Parent = workspace
    			end
		end, Players.LocalPlayer.Backpack.ChildAdded)
	end
}

Plugin.Commands["giveflaregun"] = {
	["ListName"] = ("giveflaregun / flaregun [num] (Default is 1)"),
	["Description"] = ("Sharkbite - Give yourself a flare gun"),
	["Aliases"] = {"flaregun"},
	["Function"] = function(args, speaker)
		if args[1] ~= nil then
			if isNumber(args[1]) then
				for i = 1, args[1] do
					workspace.Events.GamePasses.EquipFlareGun:FireServer()
				end
			else
				workspace.Events.GamePasses.EquipFlareGun:FireServer()
			end
		else
			workspace.Events.GamePasses.EquipFlareGun:FireServer()
		end
	end
}

Plugin.Commands["givescubagear"] = {
	["ListName"] = ("givescubagear / scubadear"),
	["Description"] = ("Sharkbite - Give yourself scuba gear"),
	["Aliases"] = {"scubadear"},
	["Function"] = function(args, speaker)
		workspace.Events.GamePasses.EquipScubaGear:FireServer()
	end
}

Plugin.Commands["sharkesp"] = {
	["ListName"] = ("sharkesp"),
	["Description"] = ("Sharkbite - Enable Shark ESP"),
	["Aliases"] = {},
	["Function"] = function(args, speaker)
		ESPLib.ToggleESP(true)
	end
}

Plugin.Commands["unsharkesp"] = {
	["ListName"] = ("unsharkesp"),
	["Description"] = ("Sharkbite - Disable Shark ESP"),
	["Aliases"] = {},
	["Function"] = function(args, speaker)
		ESPLib.ToggleESP(false)
	end
}

Plugin.Commands["removebarriers"] = {
	["ListName"] = ("removebarriers / removebarrier"),
	["Description"] = ("Sharkbite - Remove Map Barriers"),
	["Aliases"] = {"removebarrier"},
	["Function"] = function(args, speaker)
		if workspace:FindFirstChild("IslandBarrier") then
			workspace["IslandBarrier"]:Destroy()
		end
		if workspace:FindFirstChild("StuffSimonHasntFoldered") then
			workspace["StuffSimonHasntFoldered"]:Destroy()
		end
		if workspace:FindFirstChild("3rdBarrier") then
			workspace["3rdBarrier"]:Destroy()
		end
	end
}

Plugin.Commands["sharkbitedisconnect"] = {
	["ListName"] = ("sharkbitedisconnect / sharkbitedis / sharkbited"),
	["Description"] = ("Sharkbite - Disconnect all loops"),
	["Aliases"] = {"sharkbitedis", "sharkbited"},
	["Function"] = function(args, speaker)
		DisconnectAll()
	end
}

return Plugin
