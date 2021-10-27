local StarterTick = StarterTick or tick() or os.clock()

local Import = function(Asset)
	if (type(Asset) == "number") then
		return game:GetObjects("rbxassetid://" .. Asset)[1]
	else
		local Link = string.format("https://raw.githubusercontent.com/daximul/who/main/a/test/what/others/%s", Asset)
		local Response = game:HttpGetAsync(Link)

		local Function = loadstring(Response)
		local Success, Return = pcall(Function)

		if (Success) then
			return Return
		else
			warn("[da]: Failed to Import Asset " .. "'" .. Asset .. "'")
		end
	end
end

Import("asset_creator.lua")

Prote = Import("prote.lua")




local GUI = Import("interface.lua")
local Main = GUI.CommandBar
local Cmdbar = Main.Input
Prote.ProtectInstance(Cmdbar, true)
local Assets = GUI.Assets
local CommandsGui = GUI.CMDS
local NotificationTemplate = GUI.NotificationTemplate
local CmdSu = Cmdbar.Predict
local PluginBrowser = GUI.PluginBrowser
local UiDragF = GUI.MainDragFrame
local DaUi = UiDragF.Main

for superindx, objct in pairs(DaUi:GetDescendants()) do
	if objct.Name == "Results" then
		if objct:IsA("ScrollingFrame") then
			objct.CanvasSize = UDim2.new(0, 0, 0, objct.UIListLayout.AbsoluteContentSize.Y)
			objct.UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
				objct.CanvasSize = UDim2.new(0, 0, 0, objct.UIListLayout.AbsoluteContentSize.Y)
			end)
		end
	end
	if objct.Name == "SearchBar" then
		Prote.ProtectInstance(objct.SearchFrame.Search, true)
	end
end

local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local DAMouse = Players.LocalPlayer:GetMouse()

local string = loadstring(game:HttpGetAsync(("https://raw.githubusercontent.com/Toon-arch/libpp/main/libraries/string.lua")))();
local table = loadstring(game:HttpGetAsync(("https://raw.githubusercontent.com/Toon-arch/libpp/main/libraries/table.lua")))();

local Settings = {
	Prefix = ";",
	PluginsTable = {},
	daflyspeed = 1,
	vehicleflyspeed = 1,
	cframeflyspeed = 1,
	gyroflyspeed = 3,
	ChatLogs = false,
	JoinLogs = false,
	KeepDA = false,
	AutoNet = false,
	cmdautorj = false,
	disablenotifications = false,
}

local cmds = {}
local customAlias = {}
local AdminDebug = false
local Settings_Path = "Dark Admin/Settings.json"

local CommandsLoaded = false
local BrowserLoaded = false
local ScriptTabLoaded = false
local IsDaUi = false
local PluginCache = nil
local Loaded_Title = Import("osdate.lua")
local ScriptsHolder = Import("script_table.lua")
local wfile_cooldown = false
local topCommand = nil
local tabComplete = nil
local origsettings = {
	Lighting = {
		abt = game:GetService("Lighting").Ambient,
		oabt = game:GetService("Lighting").OutdoorAmbient,
		brt = game:GetService("Lighting").Brightness,
		time = game:GetService("Lighting").ClockTime,
		fe = game:GetService("Lighting").FogEnd,
		fs = game:GetService("Lighting").FogStart,
		gs = game:GetService("Lighting").GlobalShadows,
	},
	Player = {
		Id = Players.LocalPlayer.UserId,
		Ws = Players.LocalPlayer.Character:FindFirstChildWhichIsA("Humanoid").WalkSpeed,
		Jp = Players.LocalPlayer.Character:FindFirstChildWhichIsA("Humanoid").JumpPower,
	},
	Camera = {
		Fov = workspace.CurrentCamera.FieldOfView,
	},
}
randomString = function() return HttpService:GenerateGUID(false):gsub("-", ""):sub(1, math.random(25, 30)) end

--// Start of Command Variables \\--

local sethidden = sethiddenproperty or set_hidden_property or set_hidden_prop
local gethidden = gethiddenproperty or get_hidden_property or get_hidden_prop
local setsimulation = setsimulationradius or set_simulation_radius
local Network_Loop = nil
local ClientByp = nil
local currentToolSize = ""
local currentGripPos = ""
local cmdinfjump = false
local LastDeathPos = nil
local spawnpos = nil
local spawnpoint = false
local spDelay = 0.1
local WallTpTouch = nil
local walkto = false
local HumanModCons = {}
local StareLoop = nil
local FLYING = false
local GYROFLYING = false
local Floating = false
local CmdNoclipping = nil
local Noclipping = nil
local Clip = true
local viewing = nil
local isAutoClicking = false
local AutoclickerInput = nil
local AutomaticKeyPressing = false
local AutoKeyPressInput = nil
local ESPenabled = false
local swimming = false
local cmdflinging = false
local floatName = randomString()
local spinName = randomString()
local pointLightName = randomString()
local selectionBoxName = randomString()
local clientsidebypass = false
local QEfly = true
local invisRunning = false
local spinhats = nil
local BubbleChatFix = nil
local CflyCon = nil
local KeyCodeMap = {["0"]=0x30,["1"]=0x31,["2"]=0x32,["3"]=0x33,["4"]=0x34,["5"]=0x35,["6"]=0x36,["7"]=0x37,["8"]=0x38,["9"]=0x39,["a"]=0x41,["b"]=0x42,["c"]=0x43,["d"]=0x44,["e"]=0x45,["f"]=0x46,["g"]=0x47,["h"]=0x48,["i"]=0x49,["j"]=0x4A,["k"]=0x4B,["l"]=0x4C,["m"]=0x4D,["n"]=0x4E,["o"]=0x4F,["p"]=0x50,["q"]=0x51,["r"]=0x52,["s"]=0x53,["t"]=0x54,["u"]=0x55,["v"]=0x56,["w"]=0x57,["x"]=0x58,["y"]=0x59,["z"]=0x5A,["enter"]=0x0D,["shift"]=0x10,["ctrl"]=0x11,["alt"]=0x12,["pause"]=0x13,["capslock"]=0x14,["spacebar"]=0x20,["pageup"]=0x21,["pagedown"]=0x22,["end"]=0x23,["home"]=0x24,["left"]=0x25,["up"]=0x26,["right"]=0x27,["down"]=0x28,["insert"]=0x2D,["delete"]=0x2E,["f1"]=0x70,["f2"]=0x71,["f3"]=0x72,["f4"]=0x73,["f5"]=0x74,["f6"]=0x75,["f7"]=0x76,["f8"]=0x77,["f9"]=0x78,["f10"]=0x79,["f11"]=0x7A,["f12"]=0x7B}
local Keys = {}
local DA_Binds = {}
local ChatlogAPI = {}
local JoinlogAPI = {}
local HopTbl = {}
HopTbl.Mem = game:GetService("MemStorageService")
HopTbl.TP = game:GetService("TeleportService")
HopTbl.Http = game:GetService("HttpService")
HopTbl.GetPublicServers = function(a)
	a = tonumber(a) or game.PlaceId
	local b, c = {}, ""
	while c do
		local d = "https://games.roblox.com/v1/games/" .. a .. "/servers/Public?sortOrder=Asc&limit=100" .. ((#c <= 0 and "") or ("&cursor=" .. c))
		local e = HopTbl.Http:JSONDecode(game:HttpGet(d))
		for _, v in ipairs(e.data) do
			b[#b + 1] = v
		end
		c = e.nextPageCursor
	end
	return b
end

--// End of Command Variables \\--

Players.LocalPlayer.Character:FindFirstChildWhichIsA("Humanoid").Died:Connect(function()
	if getRoot(Players.LocalPlayer.Character) then
		LastDeathPos = getRoot(Players.LocalPlayer.Character).CFrame
	end
end)

local Queue_Admin = function()
	if (syn and syn.queue_on_teleport) and (Settings.KeepDA == false) then
		syn.queue_on_teleport("loadstring(game:HttpGetAsync(\"https://raw.githubusercontent.com/daximul/who/main/a/test/what/script.lua\"))();")
	end
end

Players.LocalPlayer.CharacterAdded:Connect(function()
	NOFLY()
	FLYING = false
	GYROFLYING = false
	Floating = false
	Clip = true
	invisRunning = false
	
	repeat wait() until getRoot(Players.LocalPlayer.Character)
	
	execCmd("clip nonotify")
	
	pcall(function()
		if spawnpoint and spawnpos ~= nil then
			wait(spDelay)
			getRoot(Players.LocalPlayer.Character).CFrame = spawnpos
		end
	end)
	
	Players.LocalPlayer.Character:FindFirstChildWhichIsA("Humanoid").Died:Connect(function()
		if getRoot(Players.LocalPlayer.Character) then
			LastDeathPos = getRoot(Players.LocalPlayer.Character).CFrame
		end
	end)
end)

CoreGui:FindFirstChild("RobloxPromptGui"):FindFirstChildWhichIsA("Frame").DescendantAdded:Connect(function(Overlay)
	if cmdautorj == true then
		if Overlay.Name == "ErrorTitle" then
			Overlay:GetPropertyChangedSignal("Text"):Wait()
			if Overlay.Text == "Disconnected" then
				if #Players:GetPlayers() <= 1 then
					Queue_Admin()
					Players.LocalPlayer:Kick("\nRejoining...")
					wait()
					TeleportService:Teleport(game.PlaceId, Players.LocalPlayer)
				else
					Queue_Admin()
					TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, Players.LocalPlayer)
				end
			end
		end
	end
end)

game:GetService("UserInputService").InputBegan:Connect(function(Input, GameProccesed)
	if GameProccesed then return end
	local KeyCode = tostring(Input.KeyCode):split(".")[3]
	Keys[KeyCode] = true
end)

game:GetService("UserInputService").InputEnded:Connect(function(Input, GameProccesed)
	if GameProccesed then return end
	local KeyCode = tostring(Input.KeyCode):split(".")[3]
	if Keys[KeyCode] then
		Keys[KeyCode] = false
	end
end)

local returnGray = function(str)
	str = tostring(str)
	local output = '<font color="rgb(140, 144, 150)"><b>'.. str .. '</b></font>'
	return output
end

local Time = function()
	local HOUR = math.floor((tick() % 86400) / 3600)
	local MINUTE = math.floor((tick() % 3600) / 60)
	local SECOND = math.floor(tick() % 60)
	local AP = HOUR > 11 and "PM" or "AM"
	HOUR = (HOUR % 12 == 0 and 12 or HOUR % 12)
	HOUR = HOUR < 10 and "0" .. HOUR or HOUR
	MINUTE = MINUTE < 10 and "0" .. MINUTE or MINUTE
	SECOND = SECOND < 10 and "0" .. SECOND or SECOND
	return HOUR .. ":" .. MINUTE .. ":" .. SECOND .. " " .. AP
end

ChatlogAPI.loggedTable = {}
ChatlogAPI.folderPath = ("Dark Admin/Logs/")
ChatlogAPI.Scroll = DaUi.Pages.ChatLogs.LogResults
ChatlogAPI.BUD = UDim2.new(0, 0, 0, 0)
ChatlogAPI.TotalNum = 0
ChatlogAPI.Market = game:GetService("MarketplaceService")
ChatlogAPI.gameName = tostring(ChatlogAPI.Market:GetProductInfo(game.PlaceId).Name)

ChatlogAPI.getTotalSize = function()
	local totalSize = UDim2.new(0, 0, 0, 0)
	
	for i, v in next, ChatlogAPI.loggedTable do
		totalSize = totalSize + UDim2.new(0, 0, 0, v.Size.Y.Offset)
	end
	
	return totalSize
end

ChatlogAPI.GenLog = function(txt, colo, time)
	local oldColo = Color3.fromRGB(0, 0, 0)	
	
	local Temp = Assets["LogTemplate"]:Clone()
	Temp.Parent = ChatlogAPI.Scroll
	Temp.Name = txt .. "Logged"
	Temp.Text = tostring(txt)
	Temp.Visible = true
	Temp.Position = ChatlogAPI.BUD + UDim2.new(0, 0, 0, 0)

	if colo then
		oldColo = colo Temp.TextColor3 = colo
	elseif not colo then
		Temp.TextColor3 = Color3.fromRGB(200, 200, 200)
	end

	local timeVal = Instance.new("StringValue", Temp)
	timeVal.Name = "TimeVal"
	timeVal.Value = time

	ChatlogAPI.TotalNum = ChatlogAPI.TotalNum + 1
	
	if not Temp.TextFits then repeat Temp.Size = UDim2.new(Temp.Size.X.Scale, Temp.Size.X.Offset, Temp.Size.Y.Scale, Temp.Size.Y.Offset + 10)
		Temp.Text = txt
	until Temp.TextFits 
end

	ChatlogAPI.BUD = ChatlogAPI.BUD + UDim2.new(0, 0, 0, Temp.Size.Y.Offset)
	
	table.insert(ChatlogAPI.loggedTable, Temp)
	
	local totSize = ChatlogAPI.getTotalSize()
	
	if totSize.Y.Offset >= ChatlogAPI.Scroll.CanvasSize.Y.Offset then
		ChatlogAPI.Scroll.CanvasSize = UDim2.new(totSize.X.Scale, totSize.X.Offset, totSize.Y.Scale, totSize.Y.Offset + 1)
		ChatlogAPI.Scroll.CanvasPosition = ChatlogAPI.Scroll.CanvasPosition + Vector2.new(0, totSize.Y.Offset)
	end
	
	return Temp
end

ChatlogAPI.ChatData = ""

ChatlogAPI.SaveAllLogsToFile = function()
	local t = os.date("*t")
	local dateDat = (t["hour"] .. " " .. t["min"] .. " " .. t["sec"] .. " " .. t["day"] .. "." .. t["month"] .. "." .. t["year"])
	
	ChatlogAPI.ChatData = ""
	
	for i, v in pairs(ChatlogAPI.Scroll:GetChildren()) do
		ChatlogAPI.ChatData = (ChatlogAPI.ChatData .. v.TimeVal.Value .. " - " .. v.Text .. "\n")
	end

	local topSaveText = '-- Chat Logs for "'..ChatlogAPI.gameName..'"'
	writefile(ChatlogAPI.folderPath .. ChatlogAPI.gameName .. " - " .. dateDat .. ".txt", topSaveText .. "\n" .. ChatlogAPI.ChatData)
	notify("Chat Logs", "Check the Logs Folder")
end

ChatlogAPI.ClearAllChatLogs = function()
	ChatlogAPI.loggedTable = {}
	ChatlogAPI.ChatData = ""
	ChatlogAPI.Scroll.CanvasPosition = Vector2.new(0, 0)
	for i, v in pairs(ChatlogAPI.Scroll:GetChildren()) do
		v:Destroy()
	end
	ChatlogAPI.Scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
	ChatlogAPI.BUD = UDim2.new(0, 0, 0, 0)
end

ChatlogAPI.fixateUsername = function(plr)
    local result = ""
    plrName = tostring(plr.Name)
    if plrName ~= plr.DisplayName then
        result = plr.DisplayName .. " | @" .. plrName
    else
        result = plrName
    end
    return result
end

ChatlogAPI.LogUser = function(plr)
	plr.Chatted:Connect(function(msg)
		if Settings.ChatLogs == false then return end

		local t = os.date("*t")
		local dateDat = (t["hour"] .. ":" .. t["min"] .. ":" .. t["sec"])

		if string.len(msg) >= 1000 then return nil end
		if string.sub(msg, 1, 1):match("%p") and string.sub(msg, 2, 2):match("%a") and string.len(msg) >= 5 then
			ChatlogAPI.GenLog("[" .. ChatlogAPI.fixateUsername(plr) .. "]: " .. msg, Color3.new(255, 0, 0), dateDat)
		else
			ChatlogAPI.GenLog("[" .. ChatlogAPI.fixateUsername(plr) .. "]: " .. msg, Color3.new(255, 255, 255), dateDat)
		end
	end)
end

JoinlogAPI.loggedTable = {}
JoinlogAPI.folderPath = ("Dark Admin/Logs/")
JoinlogAPI.Scroll = DaUi.Pages.JoinLogs.LogResults
JoinlogAPI.BUD = UDim2.new(0, 0, 0, 0)
JoinlogAPI.TotalNum = 0
JoinlogAPI.Market = game:GetService("MarketplaceService")
JoinlogAPI.gameName = tostring(ChatlogAPI.Market:GetProductInfo(game.PlaceId).Name)

JoinlogAPI.getTotalSize = function()
	local totalSize = UDim2.new(0, 0, 0, 0)
	
	for i, v in next, JoinlogAPI.loggedTable do
		totalSize = totalSize + UDim2.new(0, 0, 0, v.Size.Y.Offset)
	end
	
	return totalSize
end

JoinlogAPI.GenLog = function(txt, colo, time)
	local oldColo = Color3.fromRGB(0, 0, 0)	
	
	local Temp = Assets["LogTemplate"]:Clone()
	Temp.Parent = JoinlogAPI.Scroll
	Temp.Name = txt .. "Logged"
	Temp.Text = tostring(txt)
	Temp.Visible = true
	Temp.Position = JoinlogAPI.BUD + UDim2.new(0, 0, 0, 0)

	if colo then
		oldColo = colo Temp.TextColor3 = colo
	elseif not colo then
		Temp.TextColor3 = Color3.fromRGB(200, 200, 200)
	end

	local timeVal = Instance.new("StringValue", Temp)
	timeVal.Name = "TimeVal"
	timeVal.Value = time

	JoinlogAPI.TotalNum = JoinlogAPI.TotalNum + 1
	
	if not Temp.TextFits then repeat Temp.Size = UDim2.new(Temp.Size.X.Scale, Temp.Size.X.Offset, Temp.Size.Y.Scale, Temp.Size.Y.Offset + 10)
		Temp.Text = txt
	until Temp.TextFits 
end

	JoinlogAPI.BUD = JoinlogAPI.BUD + UDim2.new(0, 0, 0, Temp.Size.Y.Offset)
	
	table.insert(JoinlogAPI.loggedTable, Temp)
	
	local totSize = JoinlogAPI.getTotalSize()
	
	if totSize.Y.Offset >= JoinlogAPI.Scroll.CanvasSize.Y.Offset then
		JoinlogAPI.Scroll.CanvasSize = UDim2.new(totSize.X.Scale, totSize.X.Offset, totSize.Y.Scale, totSize.Y.Offset + 1)
		JoinlogAPI.Scroll.CanvasPosition = JoinlogAPI.Scroll.CanvasPosition + Vector2.new(0, totSize.Y.Offset)
	end
	
	return Temp
end

JoinlogAPI.ChatData = ""

JoinlogAPI.SaveAllLogsToFile = function()
	local t = os.date("*t")
	local dateDat = (t["hour"] .. " " .. t["min"] .. " " .. t["sec"] .. " " .. t["day"] .. "." .. t["month"] .. "." .. t["year"])
	
	JoinlogAPI.ChatData = ""
	
	for i, v in pairs(JoinlogAPI.Scroll:GetChildren()) do
		JoinlogAPI.ChatData = (JoinlogAPI.ChatData .. v.TimeVal.Value .. " - " .. v.Text .. "\n")
	end

	local topSaveText = '-- Join and Leave Logs for "'..JoinlogAPI.gameName..'"'
	writefile(JoinlogAPI.folderPath .. JoinlogAPI.gameName .. " [Joins]" .. " - " .. dateDat .. ".txt", topSaveText .. "\n" .. JoinlogAPI.ChatData)
	notify("Join Logs", "Check the Logs Folder")
end

JoinlogAPI.ClearAllLogs = function()
	JoinlogAPI.loggedTable = {}
	JoinlogAPI.ChatData = ""
	JoinlogAPI.Scroll.CanvasPosition = Vector2.new(0, 0)
	for i, v in pairs(JoinlogAPI.Scroll:GetChildren()) do
		v:Destroy()
	end
	JoinlogAPI.Scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
	JoinlogAPI.BUD = UDim2.new(0, 0, 0, 0)
end

JoinlogAPI.fixateUser = function(plr, status)
	status = string.lower(tostring(status))
	local result = ""
	if status == "join" then
    	plrName = tostring(plr.Name)
		if plrName ~= plr.DisplayName then
			result = plr.DisplayName .. " (@" .. plrName .. ") " .. "Joined"
		else
			result = plrName .. " Joined"
		end
	end
	if status == "leave" then
    	plrName = tostring(plr.Name)
		if plrName ~= plr.DisplayName then
			result = plr.DisplayName .. " (@" .. plrName .. ") " .. "Left"
		else
			result = plrName .. " Left"
		end
	end
	return result
end

JoinlogAPI.LogJoin = function(plr)
	if Settings.JoinLogs == false then return end

	local t = os.date("*t")
	local dateDat = (t["hour"] .. ":" .. t["min"] .. ":" .. t["sec"])

	JoinlogAPI.GenLog(JoinlogAPI.fixateUser(plr, "join"), Color3.new(255, 255, 255), dateDat)
end

JoinlogAPI.LogLeave = function(plr)
	if Settings.JoinLogs == false then return end

	local t = os.date("*t")
	local dateDat = (t["hour"] .. ":" .. t["min"] .. ":" .. t["sec"])

	JoinlogAPI.GenLog(JoinlogAPI.fixateUser(plr, "leave"), Color3.new(255, 255, 255), dateDat)
end

Players.PlayerAdded:Connect(function(player)
	JoinlogAPI.LogJoin(player)
	ChatlogAPI.LogUser(player)
	if ESPenabled then
		repeat wait(1) until player.Character and getRoot(player.Character)
		ESP(player)
	end
end)

Players.PlayerRemoving:Connect(function(player)
	JoinlogAPI.LogLeave(player)
	if ESPenabled then
		for i,v in pairs(CoreGui:GetChildren()) do
			if v.Name == player.Name .. "_ESP" then
				v:Destroy()
			end
		end
	end
	if viewing ~= nil and player == viewing then
		if findhum() then
			execCmd("unspectate nonotify")
			notify("Spectate", "Disabled (Player Left)")
		else
			notify("Un-Spectate", "Missing Humanoid")
		end
	end
end)

local inputService = game:GetService("UserInputService")
local heartbeat = game:GetService("RunService").Heartbeat
local SmoothDrag = function(frame)
	local s, event = pcall(function() return frame.MouseEnter end)
	if s then
		frame.Active = true
		event:connect(function()
			local input = frame.InputBegan:connect(function(key)
				if key.UserInputType == Enum.UserInputType.MouseButton1 then
					local objectPosition = Vector2.new(DAMouse.X - frame.AbsolutePosition.X, DAMouse.Y - frame.AbsolutePosition.Y)
					while heartbeat:wait() and inputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) do
						pcall(function()
							frame:TweenPosition(UDim2.new(0, DAMouse.X - objectPosition.X, 0, DAMouse.Y - objectPosition.Y), "Out", "Linear", 0.1, true)
						end)
					end
				end
			end)
			local leave
			leave = frame.MouseLeave:connect(function()
				input:Disconnect()
				leave:Disconnect()
			end)
		end)
	end
end

ParentGui = function(Gui)
	Prote.ProtectInstance(Gui)
	Gui.Name = randomString()
	if (not is_sirhurt_closure) and (syn and syn.protect_gui) then
		syn.protect_gui(Gui)
		Gui.Parent = CoreGui
	elseif get_hidden_gui or gethui then
		local HiddenUI = get_hidden_gui or gethui
		Gui.Parent = HiddenUI()
	elseif CoreGui:FindFirstChild("RobloxGui") then
		Gui.Parent = CoreGui["RobloxGui"]
	else
		Gui.Parent = CoreGui
	end
end

SmoothScroll = function(content, SmoothingFactor)
	content.ScrollingEnabled = false
	local input = content:Clone()
	input:ClearAllChildren()
	input.BackgroundTransparency = 1
	input.ScrollBarImageTransparency = 1
	input.ZIndex = content.ZIndex + 1
	input.Name = "_smoothinputframe"
	input.ScrollingEnabled = true
	input.Parent = content.Parent
	local syncProperty = function(prop)
		content:GetPropertyChangedSignal(prop):Connect(function()
			if prop == "ZIndex" then
				input[prop] = content[prop] + 1
			else
				input[prop] = content[prop]
			end
		end)
	end
	syncProperty("CanvasSize")
	syncProperty("Position")
	syncProperty("Rotation")
	syncProperty("ScrollingDirection")
	syncProperty("ScrollBarThickness")
	syncProperty("BorderSizePixel")
	syncProperty("ElasticBehavior")
	syncProperty("SizeConstraint")
	syncProperty("ZIndex")
	syncProperty("BorderColor3")
	syncProperty("Size")
	syncProperty("AnchorPoint")
	syncProperty("Visible")
	local smoothConnection = game:GetService("RunService").RenderStepped:Connect(function()
		local a = content.CanvasPosition
		local b = input.CanvasPosition
		local c = SmoothingFactor
		local d = (b - a) * c + a
		content.CanvasPosition = d
	end)
	content.AncestryChanged:Connect(function()
		if content.Parent == nil then
			input:Destroy()
			smoothConnection:Disconnect()
		end
	end)
end

CaptureCmdBar = function()
	Cmdbar:CaptureFocus()
	spawn(function() repeat Cmdbar.Text = "" until Cmdbar.Text == "" end)
	spawn(function() CmdBarStatus(true) end)
end

local SetSimulationRadius = function()
	--[[
	spawn(function()
		Network_Loop = game:GetService("RunService").RenderStepped:Connect(function()
			pcall(function()
				workspace.FallenPartsDestroyHeight = 0/1/0
				settings().Physics.ThrottleAdjustTime = math.huge-math.huge
				settings().Physics.AllowSleep = false
				setsimulation(math.huge*math.huge,math.huge*math.huge,1/0*1/0*1/0*1/0*1/0)
				Players.LocalPlayer.SimulationRadius = math.huge
				Players.LocalPlayer.ReplicationFocus = workspace
			end)
		end)
	end)
	]]--
end

TweenObj = function(Object, Style, Direction, Time, Goal)
	local TweenService = game:GetService("TweenService")
	local TInfo = TweenInfo.new(Time, Enum.EasingStyle[Style], Enum.EasingDirection[Direction])
	local Tween = TweenService:Create(Object, TInfo, Goal)
	Tween:Play()
	return Tween
end

TweenAllTrans = function(Object, Time)
	local Tween
	Tween = TweenObj(Object, "Sine", "Out", Time, {
		BackgroundTransparency = 1
	})
	for _, v in ipairs(Object:GetDescendants()) do
		local IsText = v:IsA("TextBox") or v:IsA("TextLabel") or v:IsA("TextButton")
		local IsImage = v:IsA("ImageLabel") or v:IsA("ImageButton")
		local IsScrollingFrame = v:IsA("ScrollingFrame")
			if not v:IsA("UIListLayout") then
				if IsText then
					TweenObj(v, "Sine", "Out", Time, {
						TextTransparency = 1,
						BackgroundTransparency = 1
					})
				elseif IsImage then
					TweenObj(v, "Sine", "Out", Time, {
						ImageTransparency = 1,
						BackgroundTransparency = 1
					})
				elseif IsScrollingFrame then
					TweenObj(v, "Sine", "Out", Time, {
						ScrollBarImageTransparency = 1,
						BackgroundTransparency = 1
					})
				else
					TweenObj(v, "Sine", "Out", Time, {
						BackgroundTransparency = 1
					})
			end
		end
	end
	return Tween
end

SetAllTrans = function(Object)
	Object.BackgroundTransparency = 1
	for _, v in ipairs(Object:GetDescendants()) do
		local IsText = v:IsA("TextBox") or v:IsA("TextLabel") or v:IsA("TextButton")
		local IsImage = v:IsA("ImageLabel") or v:IsA("ImageButton")
		local IsScrollingFrame = v:IsA("ScrollingFrame")
		if not v:IsA("UIListLayout") then	
			v.BackgroundTransparency = 1
			if IsText then
				v.TextTransparency = 1
			elseif IsImage then
				v.ImageTransparency = 1
			elseif IsScrollingFrame then
				v.ScrollBarImageTransparency = 1
			end
		end
	end
end

TweenAllTransToObject = function(Object, Time, BeforeObject)
    local Descendants = Object:GetDescendants()
    local OldDescentants = BeforeObject:GetDescendants()
    local Tween
    Tween = TweenObj(Object, "Sine", "Out", Time, {
        BackgroundTransparency = BeforeObject.BackgroundTransparency
    })
    for i, v in next, Descendants do
        local IsText = v:IsA("TextBox") or v:IsA("TextLabel") or v:IsA("TextButton")
        local IsImage = v:IsA("ImageLabel") or v:IsA("ImageButton")
        local IsScrollingFrame = v:IsA("ScrollingFrame")
        if not v:IsA("UIListLayout") then
            if IsText then
                TweenObj(v, "Sine", "Out", Time, {
                    TextTransparency = OldDescentants[i].TextTransparency,
                    TextStrokeTransparency = OldDescentants[i].TextStrokeTransparency,
                    BackgroundTransparency = OldDescentants[i].BackgroundTransparency
                })
            elseif IsImage then
                TweenObj(v, "Sine", "Out", Time, {
                    ImageTransparency = OldDescentants[i].ImageTransparency,
                    BackgroundTransparency = OldDescentants[i].BackgroundTransparency
                })
            elseif IsScrollingFrame then
                TweenObj(v, "Sine", "Out", Time, {
                    ScrollBarImageTransparency = OldDescentants[i].ScrollBarImageTransparency,
                    BackgroundTransparency = OldDescentants[i].BackgroundTransparency
                })
            else
                TweenObj(v, "Sine", "Out", Time, {
                    BackgroundTransparency = OldDescentants[i].BackgroundTransparency
                })
            end
        end
    end
    return Tween
end

local removeCutOff = function(Object)
    local Container = Instance.new("Frame")
    local Hitbox = Instance.new("ImageButton")
    Container.Name = "Container"
    Container.Parent = Object.Parent
    Container.BackgroundTransparency = 1.000
    Container.BorderSizePixel = 0
    Container.Position = Object.Position
    Container.ClipsDescendants = true
    Container.Size = UDim2.fromOffset(Object.AbsoluteSize.X, Object.AbsoluteSize.Y)
    Container.ZIndex = Object
    Object.AutomaticSize = Enum.AutomaticSize.X
    Object.Size = UDim2.fromScale(1, 1)
    Object.Position = UDim2.fromScale(0, 0)
    Object.Parent = Container
    Object.TextTruncate = Enum.TextTruncate.None
    Object.ZIndex = Object.ZIndex + 2
    Hitbox.Name = "Hitbox"
    Hitbox.Parent = Container.Parent
    Hitbox.BackgroundTransparency = 1.000
    Hitbox.Size = Container.Size
    Hitbox.Position = Container.Position
    Hitbox.ZIndex = Object.ZIndex + 2
    local MouseOut = true
    Hitbox.MouseEnter:Connect(function()
        if Object.AbsoluteSize.X > Container.AbsoluteSize.X then
            MouseOut = false
            repeat
                local Tween1 = TweenObj(Object, "Quad", "Out", 0.5, {
                    Position = UDim2.fromOffset(Container.AbsoluteSize.X - Object.AbsoluteSize.X, 0)
                })
                wait(Tween1.Completed)
                wait(2)
                local Tween2 = TweenObj(Object, "Quad", "Out", 0.5, {
                    Position = UDim2.fromOffset(0, 0)
                })
                wait(Tween2.Completed)
                wait(2)
            until MouseOut
        end
    end)
    Hitbox.MouseLeave:Connect(function()
        MouseOut = true
        TweenObj(Object, "Quad", "Out", 0.25, {
            Position = UDim2.fromOffset(0, 0)
        })
    end)
    return Object
end

CmdBarStatus = function(bool)
	if bool == true then
		TweenObj(Main, "Quint", "Out", 0.5, {
			Position = UDim2.new(0.5, -100, 1, -60)
		})
	else
		TweenObj(Main, "Quint", "Out", 0.5, {
			Position = UDim2.new(0.5, -100, 1, 5)
		})
	end
end

CmdListStatus = function(bool)
	if bool == true then
		TweenObj(CommandsGui, "Quint", "Out", 0.3, {
			Position = UDim2.new(0.694, -75, 0.656, -105)
		})
	else
		TweenObj(CommandsGui, "Quint", "Out", 0.5, {
			Position = UDim2.new(0.694, -75, 10, -105)
		})
	end
end

PlugBrowseStatus = function(bool)
	if bool == true then
		TweenObj(PluginBrowser, "Quint", "Out", 0.3, {
			Position = UDim2.new(0.42, -75, 0.512, -105)
		})
	else
		TweenObj(PluginBrowser, "Quint", "Out", 0.5, {
			Position = UDim2.new(0.42, -75, 2, -105)
		})
	end
end

DaUiStatus = function(bool)
	IsDaUi = bool
	if bool == true then
		TweenObj(UiDragF, "Quint", "Out", .3, {
			Position = UDim2.new(0.5, -200, 0.5, -125)
		})
	else
		TweenObj(UiDragF, "Quint", "Out", .5, {
			Position = UDim2.new(0.5, -200, 1.8, -125)
		})
	end
end

notify = function(Title, Message, Duration)
	if Settings.disablenotifications == true then return end
	spawn(function()
		local Notification = NotificationTemplate:Clone()
		local Desc = tostring(Message)
		local TweenDestroy = function()
			if Notification then
				local Tween = TweenAllTrans(Notification, 0.25)
				Tween.Completed:Wait()
				Notification:Destroy()
			end
		end
		if Title == ("" or " " or nil) then
			Notification.Title.Text = "Notification"
		else
			Notification.Title.Text = Title
		end
		if Desc == ("" or " " or nil) then
			Notification.Description.Text = "Message"
		else
			Notification.Description.Text = Desc
		end
		SetAllTrans(Notification)
		Notification.Visible = true
		if Desc:len() >= 35 then
			Notification.AutomaticSize = Enum.AutomaticSize.Y
			Notification.Description.AutomaticSize = Enum.AutomaticSize.Y
			Notification.Description.RichText = true
			Notification.Description.TextScaled = false
			Notification.Description.TextYAlignment = Enum.TextYAlignment.Top
			Notification.Shadow.AutomaticSize = Enum.AutomaticSize.Y
		end
		Notification.Parent = GUI.NotificationList
		coroutine.wrap(function()
			local Tween = TweenAllTransToObject(Notification, 0.5, NotificationTemplate)
			Tween.Completed:Wait()
			wait(Duration or 5)
			if Notification then TweenDestroy() end
		end)()
		Notification.Close.MouseButton1Down:Connect(function() TweenDestroy() end)
		return TweenDestroy
	end)
end

local bignotify = function(Title, Message, Duration)
	if Settings.disablenotifications == true then return end
	spawn(function()
		local Notification = NotificationTemplate:Clone()
		local Desc = tostring(Message)
		local TweenDestroy = function()
			if Notification then
				local Tween = TweenAllTrans(Notification, 0.25)
				Tween.Completed:Wait()
				Notification:Destroy()
			end
		end
		if Title == ("" or " " or nil) then
			Notification.Title.Text = "Notification"
		else
			Notification.Title.Text = Title
		end
		if Desc == ("" or " " or nil) then
			Notification.Description.Text = "Message"
		else
			Notification.Description.Text = Desc
		end
		SetAllTrans(Notification)
		Notification.Visible = true
		Notification.AutomaticSize = Enum.AutomaticSize.Y
		Notification.Description.AutomaticSize = Enum.AutomaticSize.Y
		Notification.Description.RichText = true
		Notification.Description.TextScaled = false
		Notification.Description.TextYAlignment = Enum.TextYAlignment.Top
		Notification.Shadow.AutomaticSize = Enum.AutomaticSize.Y
		Notification.Parent = GUI.NotificationList
		coroutine.wrap(function()
			local Tween = TweenAllTransToObject(Notification, 0.5, NotificationTemplate)
			Tween.Completed:Wait()
			wait(Duration or 5)
			if Notification then TweenDestroy() end
		end)()
		Notification.Close.MouseButton1Down:Connect(function() TweenDestroy() end)
		return TweenDestroy
	end)
end

isNumber = function(str)
	if tonumber(str) ~= nil or str == "inf" then
		return true
	end
end

FindInTable = function(tbl,val)
	if tbl == nil then return false end
	for _, v in pairs(tbl) do
		if v == val then return true end
	end 
	return false
end

ClearTable = function(tbl)
	if tbl == nil then return end
	if type(tbl) == "table" then
		for key in pairs(tbl) do
			tbl[key] = nil
		end
	end
end

SetTableContents = function(tbl, bool)
	if tbl == nil then return end
	if bool == nil then bool = false end
	if type(tbl) == "table" then
		for key in pairs(tbl) do
			tbl[key] = bool
		end
	end
end

getRoot = function(char)
	local RootPart = char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso") or char:FindFirstChild("UpperTorso")
	return RootPart
end

SetLocalAnimate = function(ch, val)
	if val == nil then val = false end
	if ch ~= nil then
		local AnimateScript = ch["Animate"]
		AnimateScript = AnimateScript:IsA("LocalScript") and AnimateScript or nil
		if AnimateScript then
			Prote.SpoofProperty(AnimateScript, "Disabled")
			AnimateScript.Disabled = val
		end
	else
		local AnimateScript = Players.LocalPlayer.Character["Animate"]
		AnimateScript = AnimateScript:IsA("LocalScript") and AnimateScript or nil
		if AnimateScript then
			Prote.SpoofProperty(AnimateScript, "Disabled")
			AnimateScript.Disabled = val
		end
	end
end

r15 = function(speaker)
	local Humanoid = speaker.Character:FindFirstChildOfClass("Humanoid")
	if (Humanoid.RigType == Enum.HumanoidRigType.R15) then
		return true
	else
		return false
	end
end

tools = function(plr)
	if plr:FindFirstChildOfClass("Backpack"):FindFirstChildOfClass("Tool") or plr.Character:FindFirstChildOfClass("Tool") then
		return true
	else
		notify("Command Error", "Tool Required to Run Command.")
		return false
	end
end

toClipboard = function(String)
	local clipBoard = setclipboard or toclipboard or set_clipboard or (Clipboard and Clipboard.set)
	if clipBoard then
		clipBoard(String)
		notify("Clipboard", "Copied")
	else
		print("[da]: " .. String)
		notify("Clipboard Error", "Can't use clipboard, printed instead")
	end
end

GetInTable = function(Table, Name)
	for i = 1, #Table do
		if Table[i] == Name then
			return i
		end
	end
	return false
end

local fixcam = function(speaker)
	workspace.CurrentCamera:remove()
	wait(0.1)
	repeat wait() until speaker.Character ~= nil
	workspace.CurrentCamera.CameraSubject = speaker.Character:FindFirstChildWhichIsA("Humanoid")
	workspace.CurrentCamera.CameraType = "Custom"
	speaker.CameraMinZoomDistance = 0.5
	speaker.CameraMaxZoomDistance = 400
	speaker.CameraMode = "Classic"
	speaker.Character.Head.Anchored = false
end

findCmd = function(cmd_name)
	for i,v in pairs(cmds) do
		if v.NAME:lower() == cmd_name:lower() or FindInTable(v.ALIAS, cmd_name:lower()) then
			return v
		end
	end
	return customAlias[cmd_name:lower()]
end

splitString = function(str, delim)
	local broken = {}
	if delim == nil then delim = "," end
	for w in string.gmatch(str, "[^" .. delim .. "]+") do
		table.insert(broken, w)
	end
	return broken
end

local cmdHistory = {}
local lastCmds = {}
local historyCount = 0
local split = " "
local lastBreakTime = 0
execCmd = function(cmdStr, speaker, store)
	cmdStr = cmdStr:gsub("%s+$", "")
	spawn(function()
		local rawCmdStr = cmdStr
		cmdStr = string.gsub(cmdStr, "\\\\", "%%BackSlash%%")
		local commandsToRun = splitString(cmdStr, "\\")
		for i,v in pairs(commandsToRun) do
			v = string.gsub(v, "%%BackSlash%%", "\\")
			local x, y, num = v:find("^(%d+)%^")
			local cmdDelay = 0
			local infTimes = false
			if num then
				v = v:sub(y + 1)
				local x, y, del = v:find("^([%d%.]+)%^")
				if del then
					v = v:sub(y + 1)
					cmdDelay = tonumber(del) or 0
				end
			else
				local x,y = v:find("^inf%^")
				if x then
					infTimes = true
					v = v:sub(y + 1)
					local x, y, del = v:find("^([%d%.]+)%^")
					if del then
						v = v:sub(y + 1)
						del = tonumber(del) or 1
						cmdDelay = (del > 0 and del or 1)
					else
						cmdDelay = 1
					end
				end
			end
			num = tonumber(num or 1)
			if v:sub(1, 1) == "!" then
				local chunks = splitString(v:sub(2), split)
				if chunks[1] and lastCmds[chunks[1]] then v = lastCmds[chunks[1]] end
			end
			local args = splitString(v,split)
			local cmdName = args[1]
			local cmd = findCmd(cmdName)
			if cmd then
				table.remove(args, 1)
				cargs = args
				if not speaker then speaker = Players.LocalPlayer end
				if store then
					if speaker == Players.LocalPlayer then
						if cmdHistory[1] ~= rawCmdStr and rawCmdStr:sub(1, 11) ~= "lastcommand" and rawCmdStr:sub(1, 7) ~= "lastcmd" then
							table.insert(cmdHistory, 1, rawCmdStr)
						end
					end
					if #cmdHistory > 30 then table.remove(cmdHistory) end
					lastCmds[cmdName] = v
				end
				local cmdStartTime = tick()
				if infTimes then
					while lastBreakTime < cmdStartTime do
						local success,err = pcall(cmd.FUNC, args, speaker)
						if not success and AdminDebug then
							warn("Command Error:", cmdName, err)
						end
						wait(cmdDelay)
					end
				else
					for rep = 1,num do
						if lastBreakTime > cmdStartTime then break end
						local success, err = pcall(function()
							cmd.FUNC(args, speaker)
						end)
						if not success and AdminDebug then
							warn("Command Error:", cmdName, err)
						end
						if cmdDelay ~= 0 then wait(cmdDelay) end
					end
				end
			end
		end
	end)
end

getstring = function(begin)
	local start = begin - 1
	local AA = "" for i,v in pairs(cargs) do
		if i > start then
			if AA ~= "" then
				AA = AA .. " " .. v
			else
				AA = AA .. v
			end
		end
	end
	return AA
end

addcmd = function(name, alias, title, desc, func, plgn, plgnn)
	cmds[#cmds + 1]=
		{
			NAME = name;
			ALIAS = alias or {};
			TITLE = title;
			DESC = desc;
			FUNC = func;
			PLUGIN = plgn;
			PLUGNN = plgnn or "";
		}
end

local removecmd_cmdarea = function(cmd)
	if cmd ~= " " then
		for i = #cmds,1,-1 do
			if cmds[i].NAME == cmd or FindInTable(cmds[i].ALIAS,cmd) then
				table.remove(cmds, i)
				for a,c in pairs(DaUi.CmdArea.ScrollingFrame:GetChildren()) do
					if string.find(c.Text, "^" .. cmd .. "$") or string.find(c.Text, "^" .. cmd .. " ") or string.find(c.Text, " " .. cmd .. "$") or string.find(c.Text, " " .. cmd .. " ") then
						c.TextTransparency = 0.7
						c.MouseButton1Click:Connect(function()
							notify(c.Text, "Disabled by you or a plugin")
						end)
					end
				end
			end
		end
	end
end

removecmd = function(cmd)
	spawn(function()
		removecmd_cmdarea(cmd)
	end)
	if cmd ~= " " then
		for i = #cmds,1,-1 do
			if cmds[i].NAME == cmd or FindInTable(cmds[i].ALIAS,cmd) then
				table.remove(cmds, i)
				for a,c in pairs(DaUi.Pages.Commands.Results:GetChildren()) do
					if string.find(c.Text, "^" .. cmd .. "$") or string.find(c.Text, "^" .. cmd .. " ") or string.find(c.Text, " " .. cmd .. "$") or string.find(c.Text, " " .. cmd .. " ") then
						c.TextTransparency = 0.7
						c.MouseButton1Click:Connect(function()
							notify(c.Text, "Disabled by you or a plugin")
						end)
					end
				end
			end
		end
	end
end

replacecmd = function(cmd, func)
	if cmd ~= " " then
		if type(func) == "function" then
			cmd = string.lower(cmd)
			for i = #cmds,1,-1 do
				if cmds[i].NAME == cmd or FindInTable(cmds[i].ALIAS, cmd) then
					cmds[i].FUNC = func
				end
			end
		end
	end
end

gethum = function(ch) return (ch and ch:FindFirstChildWhichIsA("Humanoid")) or (Players.LocalPlayer and Players.LocalPlayer.Character:FindFirstChildWhichIsA("Humanoid")) end
getbp = function(ch) return (ch and ch:FindFirstChildWhichIsA("Backpack")) or (Players.LocalPlayer and Players.LocalPlayer:FindFirstChildWhichIsA("Backpack")) end
		
findhum = function(ch)
	if ch ~= nil then
		if ch and ch:FindFirstChildWhichIsA("Humanoid") then
			return true
		else
			return false
		end
	else
		if Players.LocalPlayer and Players.LocalPlayer.Character:FindFirstChildWhichIsA("Humanoid") then
			return true
		else
			return false
		end
	end
end
findbp = function(ch)
	if ch ~= nil then
		if ch and ch:FindFirstChildWhichIsA("Backpack") then
			return true
		else
			return false
		end
	else
		if Players.LocalPlayer and Players.LocalPlayer:FindFirstChildWhichIsA("Backpack") then
			return true
		else
			return false
		end
	end
end

local SpecialPlayerCases = {
	["all"] = function(speaker) return Players:GetPlayers() end,
	["others"] = function(speaker)
		local plrs = {}
		for i,v in pairs(Players:GetPlayers()) do
			if v ~= speaker then
				table.insert(plrs, v)
			end
		end
		return plrs
	end,
	["me"] = function(speaker) return {speaker} end,
	["#(%d+)"] = function(speaker, args, currentList)
		local returns = {}
		local randAmount = tonumber(args[1])
		local players = {unpack(currentList)}
		for i = 1,randAmount do
			if #players == 0 then break end
			local randIndex = math.random(1, #players)
			table.insert(returns, players[randIndex])
			table.remove(players, randIndex)
		end
		return returns
	end,
	["random"] = function(speaker, args, currentList)
		local players = currentList
		return {players[math.random(1, #players)]}
	end,
	["%%(.+)"] = function(speaker, args)
		local returns = {}
		local team = args[1]
		for _,plr in pairs(Players:GetPlayers()) do
			if plr.Team and string.sub(string.lower(plr.Team.Name), 1, #team) == string.lower(team) then
				table.insert(returns, plr)
			end
		end
		return returns
	end,
	["allies"] = function(speaker)
		local returns = {}
		local team = speaker.Team
		for _,plr in pairs(Players:GetPlayers()) do
			if plr.Team == team then
				table.insert(returns, plr)
			end
		end
		return returns
	end,
	["enemies"] = function(speaker)
		local returns = {}
		local team = speaker.Team
		for _,plr in pairs(Players:GetPlayers()) do
			if plr.Team ~= team then
				table.insert(returns, plr)
			end
		end
		return returns
	end,
	["team"] = function(speaker)
		local returns = {}
		local team = speaker.Team
		for _,plr in pairs(Players:GetPlayers()) do
			if plr.Team == team then
				table.insert(returns, plr)
			end
		end
		return returns
	end,
	["nonteam"] = function(speaker)
		local returns = {}
		local team = speaker.Team
		for _,plr in pairs(Players:GetPlayers()) do
			if plr.Team ~= team then
				table.insert(returns, plr)
			end
		end
		return returns
	end,
	["friends"] = function(speaker, args)
		local returns = {}
		for _,plr in pairs(Players:GetPlayers()) do
			if plr:IsFriendsWith(speaker.UserId) and plr ~= speaker then
				table.insert(returns, plr)
			end
		end
		return returns
	end,
	["nonfriends"] = function(speaker, args)
		local returns = {}
		for _,plr in pairs(Players:GetPlayers()) do
			if not plr:IsFriendsWith(speaker.UserId) and plr ~= speaker then
				table.insert(returns, plr)
			end
		end
		return returns
	end,
	["guests"] = function(speaker, args)
		local returns = {}
		for _,plr in pairs(Players:GetPlayers()) do
			if plr.Guest then
				table.insert(returns, plr)
			end
		end
		return returns
	end,
	["bacons"] = function(speaker, args)
		local returns = {}
		for _,plr in pairs(Players:GetPlayers()) do
			if plr.Character:FindFirstChild("Pal Hair") or plr.Character:FindFirstChild("Kate Hair") then
				table.insert(returns, plr)
			end
		end
		return returns
	end,
	["age(%d+)"] = function(speaker, args)
		local returns = {}
		local age = tonumber(args[1])
		if not age == nil then return end
		for _,plr in pairs(Players:GetPlayers()) do
			if plr.AccountAge <= age then
				table.insert(returns, plr)
			end
		end
		return returns
	end,
	["nearest"] = function(speaker, args, currentList)
		local speakerChar = speaker.Character
		if not speakerChar or not getRoot(speakerChar) then return end
		local lowest = math.huge
		local NearestPlayer = nil
		for _,plr in pairs(currentList) do
			if plr ~= speaker and plr.Character then
				local distance = plr:DistanceFromCharacter(getRoot(speakerChar).Position)
				if distance < lowest then
					lowest = distance
					NearestPlayer = {plr}
				end
			end
		end
		return NearestPlayer
	end,
	["farthest"] = function(speaker, args, currentList)
		local speakerChar = speaker.Character
		if not speakerChar or not getRoot(speakerChar) then return end
		local highest = 0
		local Farthest = nil
		for _,plr in pairs(currentList) do
			if plr ~= speaker and plr.Character then
				local distance = plr:DistanceFromCharacter(getRoot(speakerChar).Position)
				if distance > highest then
					highest = distance
					Farthest = {plr}
				end
			end
		end
		return Farthest
	end,
	["group(%d+)"] = function(speaker, args)
		local returns = {}
		local groupID = tonumber(args[1])
		for _,plr in pairs(Players:GetPlayers()) do
			if plr:IsInGroup(groupID) then  
				table.insert(returns, plr)
			end
		end
		return returns
	end,
	["alive"] = function(speaker, args)
		local returns = {}
		for _,plr in pairs(Players:GetPlayers()) do
			if plr.Character and plr.Character:FindFirstChildOfClass("Humanoid") and plr.Character:FindFirstChildOfClass("Humanoid").Health > 0 then
				table.insert(returns, plr)
			end
		end
		return returns
	end,
	["dead"] = function(speaker, args)
		local returns = {}
		for _,plr in pairs(Players:GetPlayers()) do
			if (not plr.Character or not plr.Character:FindFirstChildOfClass("Humanoid")) or plr.Character:FindFirstChildOfClass("Humanoid").Health <= 0 then
				table.insert(returns, plr)
			end
		end
		return returns
	end,
	["rad(%d+)"] = function(speaker, args)
		local returns = {}
		local radius = tonumber(args[1])
		local speakerChar = speaker.Character
		if not speakerChar or not getRoot(speakerChar) then return end
		for _,plr in pairs(Players:GetPlayers()) do
			if plr.Character and getRoot(plr.Character) then
				local magnitude = (getRoot(plr.Character).Position-getRoot(speakerChar).Position).magnitude
				if magnitude <= radius then table.insert(returns, plr) end
			end
		end
		return returns
	end
}

toTokens = function(str)
	local tokens = {}
	for op,name in string.gmatch(str, "([+-])([^+-]+)") do table.insert(tokens, {Operator = op, Name = name}) end
	return tokens
end

onlyIncludeInTable = function(tab, matches)
	local matchTable = {}
	local resultTable = {}
	for i,v in pairs(matches) do matchTable[v.Name] = true end
	for i,v in pairs(tab) do if matchTable[v.Name] then table.insert(resultTable, v) end end
	return resultTable
end

removeTableMatches = function(tab, matches)
	local matchTable = {}
	local resultTable = {}
	for i,v in pairs(matches) do matchTable[v.Name] = true end
	for i,v in pairs(tab) do if not matchTable[v.Name] then table.insert(resultTable, v) end end
	return resultTable
end

getPlayersByName = function(Name)
	local Name, Len, Found = string.lower(Name), #Name, {}
	for _,v in pairs(Players:GetPlayers()) do
		if Name:sub(0, 1) == "@" then
			if string.sub(string.lower(v.Name), 1, Len-1) == Name:sub(2) then
				table.insert(Found, v)
			end
		else
			if string.sub(string.lower(v.Name), 1, Len) == Name or string.sub(string.lower(v.DisplayName), 1, Len) == Name then
				table.insert(Found, v)
			end
		end
	end
	return Found
end

getPlayer = function(list, speaker)
	if list == nil then return {speaker.Name} end
	local nameList = splitString(list, ",")

	local foundList = {}

	for _,name in pairs(nameList) do
		if string.sub(name, 1, 1) ~= "+" and string.sub(name,1,1) ~= "-" then name = "+" .. name end
		local tokens = toTokens(name)
		local initialPlayers = Players:GetPlayers()

		for i,v in pairs(tokens) do
			if v.Operator == "+" then
				local tokenContent = v.Name
				local foundCase = false
				for regex,case in pairs(SpecialPlayerCases) do
					local matches = {string.match(tokenContent, "^" .. regex .. "$")}
					if #matches > 0 then
						foundCase = true
						initialPlayers = onlyIncludeInTable(initialPlayers, case(speaker, matches, initialPlayers))
					end
				end
				if not foundCase then
					initialPlayers = onlyIncludeInTable(initialPlayers, getPlayersByName(tokenContent))
				end
			else
				local tokenContent = v.Name
				local foundCase = false
				for regex,case in pairs(SpecialPlayerCases) do
					local matches = {string.match(tokenContent, "^" .. regex .. "$")}
					if #matches > 0 then
						foundCase = true
						initialPlayers = removeTableMatches(initialPlayers, case(speaker, matches, initialPlayers))
					end
				end
				if not foundCase then
					initialPlayers = removeTableMatches(initialPlayers, getPlayersByName(tokenContent))
				end
			end
		end

		for i,v in pairs(initialPlayers) do table.insert(foundList, v) end
	end

	local foundNames = {}
	for i,v in pairs(foundList) do table.insert(foundNames, v.Name) end

	return foundNames
end

MatchSearch = function(str1, str2)
	return str1 == string.sub(str2, 1, #str1)
end

StringFind = function(tbl, str)
	if tbl == nil then return end
	if type(tbl) == "table" then
		for _, v in ipairs(tbl) do
			if MatchSearch(str, v) then
				return v
			end
		end
	end
end

local PlayerArgs = function(argument)
	local arg = string.lower(argument)
	local SpecialCases = {"all", "others", "random", "me", "nearest", "farthest", "allies", "enemies", "team", "nonteam", "friends", "nonfriends", "bacons", "nearest", "farthest", "alive", "dead"}
	return StringFind(SpecialCases, arg) or (function()
		for _, v in ipairs(Players:GetPlayers()) do
			local Name = string.lower(v.Name)
			if MatchSearch(arg, Name) then
				return Name
			end
		end
	end)()
end

local autoComplete = function(str, curText)
	local endingChar = {"[", "/", "(", " "}
	local stop = 0
	for i = 1, #str do
		local c = str:sub(i, i)
		if table.find(endingChar, c) then
			stop = i
			break
		end
	end
	curText = curText or Cmdbar.Text
	local subPos = 0
	local pos = 1
	local findRes = string.find(curText, "\\", pos)
	while findRes do
		subPos = findRes
		pos = findRes + 1
		findRes = string.find(curText, "\\", pos)
	end
	if curText:sub(subPos + 1, subPos + 1) == "!" then subPos = subPos + 1 end
	Cmdbar.Text = curText:sub(1, subPos) .. str:sub(1, stop - 1) .. " "
	wait()
	Cmdbar.Text = Cmdbar.Text:gsub("\t", "")
	Cmdbar.CursorPosition = #Cmdbar.Text + 1
end

Match = function(name, str)
	str = str:gsub("%W", "%%%1")
	return name:lower():find(str:lower()) and true
end

getprfx = function(strn)
	if strn:sub(1, string.len(Settings.Prefix)) == Settings.Prefix then return {"cmd", string.len(Settings.Prefix) + 1}
	end return
end

do_exec = function(str, plr)
	str = str:gsub("/e ", "")
	local t = getprfx(str)
	if not t then return end
	str = str:sub(t[2])
	if t[1] == "cmd" then
		execCmd(str, plr, true)
	end
end

Cmdbar.FocusLost:Connect(function(enterPressed)
	CmdSu.Text = ""
	if tabComplete then tabComplete:Disconnect() end
end)

Cmdbar:GetPropertyChangedSignal("Text"):Connect(function()
	Cmdbar.Text = string.lower(Cmdbar.Text)
	CmdSu.Text = ""
	local InputText = Cmdbar.Text
	local Args = string.split(InputText, " ")
	local CmdArgs = cargs or {}
	if InputText == "" then return end
	for _, v in next, cmds do
		local Name = v.NAME
		local Aliases = v.ALIAS
		local FoundAlias = false
		if MatchSearch(InputText, Name) then
			CmdSu.Text = Name
			break
		end
		for _, v2 in next, Aliases do
			if MatchSearch(InputText, v2) then
				FoundAlias = true
				CmdSu.Text = v2
				break
			end
			if FoundAlias then break end
		end
	end
	for i,v in next, Args do
		if i > 1 and v ~= "" then
			local Predict = ""
			if #CmdArgs >= 1 then
				Predict = PlayerArgs(v) or Predict
			else
				Predict = PlayerArgs(v) or Predict
			end
			CmdSu.Text = string.sub(InputText, 1, #InputText - #Args[#Args]) .. Predict
			local split = v:split(",")
			if next(split) then
				for i2, v2 in next, split do
					if i2 > 1 and v2 ~= "" then
						local PlayerName = PlayerArgs(v2)
						CmdSu.Text = string.sub(InputText, 1, #InputText - #split[#split]) .. (PlayerName or "")
					end
				end
			end
		end
	end
end)

Cmdbar.Focused:Connect(function()
	local userinpser = game:GetService("UserInputService")
	tabComplete = userinpser.InputBegan:Connect(function(input, gameProcessed)
		if Cmdbar:IsFocused() then
			if input.KeyCode == Enum.KeyCode.Tab then
				if CmdSu.Text == "" then
					autoComplete("commands")
				elseif CmdSu.Text == " " then
					autoComplete("commands")
				else
					if string.match(CmdSu.Text, " ") then
						Cmdbar.Text = CmdSu.Text
						wait()
						Cmdbar.Text = Cmdbar.Text:gsub("\t", "")
						Cmdbar.CursorPosition = #Cmdbar.Text + 1
					else
						Cmdbar.Text = CmdSu.Text .. " "
						wait()
						Cmdbar.Text = Cmdbar.Text:gsub("\t", "")
						Cmdbar.CursorPosition = #Cmdbar.Text + 1
					end
				end
			end
		else
			tabComplete:Disconnect()
		end
	end)
end)

addcmdtext = function(name, cmdname, aliases, desc, plug)
	local nametextlabel = string.lower(tostring(name))
	local cmdNamePicked = nil
	if plug ~= nil then
		cmdNamePicked = ("PLUGIN_" .. tostring(name))
	else
		cmdNamePicked = ("CMD_" .. tostring(name))
	end
	local CommandFrame = Assets.CmdFrame:Clone()
	local NewCommand = Assets.CmdAreaLabel:Clone()
	NewCommand.Parent = DaUi.Pages.Commands.Results
	NewCommand.Name = tostring(cmdNamePicked)
	NewCommand.Visible = true
	NewCommand.Label.Text = tostring(cmdname)
	NewCommand.MouseButton1Down:Connect(function()
		CommandFrame:FindFirstChild("Name").Text = ("Name: " .. nametextlabel)
		CommandFrame.Alias.Text = (#aliases > 0 and ("Aliases: " .. table.concat(aliases, ", ")) or "Aliases: There are no aliases")
		CommandFrame.Desc.Text = ("Description: " .. desc)
		CommandFrame.Parent = DaUi.Pages.Commands
		CommandFrame.Visible = true
	end)
	DaUi.Menu.Commands.MouseButton1Down:Connect(function()
		CommandFrame.Visible = false
	end)
	NewCommand.paste.MouseButton1Down:Connect(function()
		CaptureCmdBar()
		wait()
		autoComplete(tostring(NewCommand.Label.Text))
	end)
end

writefileExploit = function()
	if writefile then
		return true
	end
end

readfileExploit = function()
	if readfile then
		return true
	end
end

writefileCooldown = function(name,data)
	spawn(function()
		if not wfile_cooldown then
			wfile_cooldown = true
			writefile(name, data)
		else
			repeat wait() until wfile_cooldown == false
			writefileCooldown(name, data)
		end
		wait(3)
		wfile_cooldown = false
	end)
end

local Defaults = game:GetService("HttpService"):JSONEncode(Settings)
local nosaves = false
local loadedEventData = nil
LoadSettings = function()
	if writefileExploit() then
		if pcall(function() readfile(Settings_Path) end) then
			if readfile(Settings_Path) ~= nil then
				local success, response = pcall(function()
					local json = game:GetService("HttpService"):JSONDecode(readfile(Settings_Path))
					if json.Prefix ~= nil then Settings.Prefix = json.Prefix else Settings.Prefix = ";" end
					if json.PluginsTable ~= nil then Settings.PluginsTable = json.PluginsTable else Settings.PluginsTable = {} end
					if json.daflyspeed ~= nil then Settings.daflyspeed = json.daflyspeed else Settings.daflyspeed = 1 end
					if json.vehicleflyspeed ~= nil then Settings.vehicleflyspeed = json.vehicleflyspeed else Settings.vehicleflyspeed = 1 end
					if json.cframeflyspeed ~= nil then Settings.cframeflyspeed = json.cframeflyspeed else Settings.cframeflyspeed = 1 end
					if json.gyroflyspeed ~= nil then Settings.gyroflyspeed = json.gyroflyspeed else Settings.gyroflyspeed = 3 end
					if json.ChatLogs ~= nil then Settings.ChatLogs = json.ChatLogs else Settings.ChatLogs = false end
					if json.JoinLogs ~= nil then Settings.JoinLogs = json.JoinLogs else Settings.JoinLogs = false end
					if json.KeepDA ~= nil then Settings.KeepDA = json.KeepDA else Settings.KeepDA = false end
					if json.AutoNet ~= nil then Settings.AutoNet = json.AutoNet else Settings.AutoNet = false end
					if json.cmdautorj ~= nil then Settings.cmdautorj = json.cmdautorj else Settings.cmdautorj = false end
					if json.disablenotifications ~= nil then Settings.disablenotifications = json.disablenotifications else Settings.disablenotifications = false end
				end)
				if not success then
					warn("Save Json Error:", response)
					warn("Overwriting Save File")
					writefileCooldown(Settings_Path, Defaults)
					wait()
					LoadSettings()
				end
			else
				writefileCooldown(Settings_Path, Defaults)
				wait()
				LoadSettings()
			end
		else
			writefileCooldown(Settings_Path, Defaults)
			wait()
			if pcall(function() readfile(Settings_Path) end) then
				LoadSettings()
			else
				nosaves = true
				Settings.Prefix = ";"
				Settings.PluginsTable = {}
				Settings.daflyspeed = 1
				Settings.vehicleflyspeed = 1
				Settings.cframeflyspeed = 1
				Settings.gyroflyspeed = 3
				Settings.ChatLogs = false
				Settings.JoinLogs = false
				Settings.KeepDA = false
				Settings.AutoNet = false
				Settings.cmdautorj = false
				Settings.disablenotifications = false
				
				notify("", "There was a problem writing a save file to your PC")
			end
		end
	else
		Settings.Prefix = ";"
		Settings.PluginsTable = {}
		Settings.daflyspeed = 1
		Settings.vehicleflyspeed = 1
		Settings.cframeflyspeed = 1
		Settings.gyroflyspeed = 3
		Settings.ChatLogs = false
		Settings.JoinLogs = false
		Settings.KeepDA = false
		Settings.AutoNet = false
		Settings.cmdautorj = false
		Settings.disablenotifications = false
	end
end
LoadSettings()

updatesaves = function()
	if nosaves == false and writefileExploit() then
		local update = {
			Prefix = Settings.Prefix;
			PluginsTable = Settings.PluginsTable;
			daflyspeed = Settings.daflyspeed;
			vehicleflyspeed = Settings.vehicleflyspeed;
			cframeflyspeed = Settings.cframeflyspeed;
			gyroflyspeed = Settings.gyroflyspeed;
			ChatLogs = Settings.ChatLogs;
			JoinLogs = Settings.JoinLogs;
			KeepDA = Settings.KeepDA;
			AutoNet = Settings.AutoNet;
			cmdautorj = Settings.cmdautorj;
			disablenotifications = Settings.disablenotifications;
		}
		writefileCooldown(Settings_Path, game:GetService("HttpService"):JSONEncode(update))
	end
end

addPlugin = function(name)
	if name:lower() == "plugin file name" or name:lower() == "dark admin" or name == "settings" then
		notify("Plugin Error", "Please enter a valid plugin")
	else
		local file
		local fileName
		if name:sub(-3) == ".da" then
			pcall(function() file = readfile("Dark Admin/Plugins/" .. name) end)
			fileName = name
		else
			pcall(function() file = readfile("Dark Admin/Plugins/".. name .. ".da") end)
			fileName = name .. ".da"
		end
		if file then
			if not FindInTable(Settings.PluginsTable, fileName) then
				table.insert(Settings.PluginsTable, fileName)
				LoadPlugin(fileName)
			else
				notify("Plugin Error", "This plugin is already added")
			end
		else
			notify("Plugin Error", "Cannot locate file " .. "'" .. fileName .. "'" .. ".")
		end
	end
end

deletePlugin = function(name)
	local pName = name .. ".da"
	if name:sub(-3) == ".da" then
		pName = name
	end
	for i = #cmds,1,-1 do
		if cmds[i].PLUGNN == pName then
			table.remove(cmds, i)
		end
	end
	for i,v in pairs(DaUi.Pages.Commands.Results:GetChildren()) do
		if v.Name == "PLUGIN_" .. pName then
			v:Destroy()
		end
	end
	for i,v in pairs(Settings.PluginsTable) do
		if v == pName then
			table.remove(Settings.PluginsTable, i)
			notify("Removed Plugin", pName .. " was removed")
		end
	end
end

LoadPlugin = function(val, startup)
	local plugin

	CatchedPluginLoad = function()
		plugin = loadfile("Dark Admin/Plugins/" .. val)()
	end

	handlePluginError = function(plerror)
		notify("Plugin Error", val)
		if FindInTable(Settings.PluginsTable,val) then
			for i,v in pairs(Settings.PluginsTable) do
				if v == val then
					table.remove(Settings.PluginsTable, i)
				end
			end
		end
		updatesaves()

		print("Original Error: " .. tostring(plerror))
		print("Plugin Error, stack traceback: " .. tostring(debug.traceback()))

		plugin = nil

		return false
	end

	xpcall(CatchedPluginLoad, handlePluginError)

	if plugin ~= nil then
		if not startup then
			spawn(function()
				if plugin["PluginDescription"] ~= ("" or " " or nil) then
					bignotify("Loaded Plugin", "Name: " .. plugin["PluginName"] .. "\nDesc: " .. plugin["PluginDescription"])
				else
					notify("Loaded Plugin", "Name: " .. plugin["PluginName"])
				end
			end)
		end
		for i,v in pairs(plugin["Commands"]) do 
			local cmdExt = ""
			local cmdName = i
			local function handleNames()
				cmdName = i
				if findCmd(cmdName .. cmdExt) then
					if isNumber(cmdExt) then
						cmdExt = cmdExt + 1
					else
						cmdExt = 1
					end
					handleNames()
				else
					cmdName = cmdName .. cmdExt
				end
			end
			handleNames()
			if v["ListName"] then
				local newName = v["ListName"]
				local cmdNames = {i, unpack(v["Aliases"])}
				for i,v in pairs(cmdNames) do
					newName = newName:gsub(v, v .. cmdExt)
				end
				addcmd(cmdName, v["Aliases"], newName, v["Description"], v["Function"], true, val)
			else
				addcmd(cmdName, v["Aliases"], cmdName, v["Description"], v["Function"], true, val)
			end
			if CommandsLoaded then
				if v["ListName"] then
					local newName = v["ListName"]
					local cmdNames = {i, unpack(v["Aliases"])}
					for i,v in pairs(cmdNames) do
						newName = newName:gsub(v, v .. cmdExt)
					end
					addcmdtext(cmdName, newName, v["Aliases"], v["Description"], true)
				else
					addcmdtext(cmdName, cmdName, v["Aliases"], v["Description"], true)
				end
			end
		end
	elseif plugin == nil then
		plugin = nil
	end
end

FindPlugins = function()
	if Settings.PluginsTable ~= nil and type(Settings.PluginsTable) == "table" then
		for i,v in pairs(Settings.PluginsTable) do
			LoadPlugin(v, true)
		end
	end
end

local xrayobjects = function(bool)
	if bool == true then
		for i, v in next, workspace:GetDescendants() do
			if v:IsA("Part") and v.Transparency <= 0.3 then
				Prote.SpoofProperty(v, "Transparency")
				Prote.SpoofProperty(v, "LocalTransparencyModifier")
				v.LocalTransparencyModifier = 0.3
			end
		end
	else
		for i, v in next, workspace:GetDescendants() do
			if v:IsA("Part") and v.Transparency <= 0.3 then
				Prote.SpoofProperty(v, "Transparency")
				Prote.SpoofProperty(v, "LocalTransparencyModifier")
				v.LocalTransparencyModifier = 0
			end
		end
	end
end

local GetHandleTools = function(p)
	p = p or Players.LocalPlayer
	local r = {}
	for _, v in ipairs(p.Character and p.Character:GetChildren() or {}) do
		if v.IsA(v, "BackpackItem") and v.FindFirstChild(v, "Handle") then
			r[#r + 1] = v
		end
	end
	for _, v in ipairs(p.Backpack:GetChildren()) do
		if v.IsA(v, "BackpackItem") and v.FindFirstChild(v, "Handle") then
			r[#r + 1] = v
		end
	end
	return r
end

local sFLY = function(vfly)
	repeat wait() until Players.LocalPlayer and Players.LocalPlayer.Character and getRoot(Players.LocalPlayer.Character) and Players.LocalPlayer.Character:FindFirstChildWhichIsA('Humanoid')
	repeat wait() until DAMouse
	if flyKeyDown or flyKeyUp then flyKeyDown:Disconnect() flyKeyUp:Disconnect() end
	
	local CONTROL = {F = 0, B = 0, L = 0, R = 0, Q = 0, E = 0}
	local lCONTROL = {F = 0, B = 0, L = 0, R = 0, Q = 0, E = 0}
	local SPEED = 0

	local FLY = function()
		FLYING = true
		local BG = Instance.new("BodyGyro")
		local BV = Instance.new("BodyVelocity")
		Prote.ProtectInstance(BG)
		Prote.ProtectInstance(BV)
		BG.Parent = getRoot(Players.LocalPlayer.Character)
		BV.Parent = getRoot(Players.LocalPlayer.Character)
		BG.P = 9e4
		local T = getRoot(Players.LocalPlayer.Character)
		BG.Parent = T
		BV.Parent = T
		BG.maxTorque = Vector3.new(9e9, 9e9, 9e9)
		BG.cframe = T.CFrame
		BV.velocity = Vector3.new(0, 0, 0)
		BV.maxForce = Vector3.new(9e9, 9e9, 9e9)
		Prote.SpoofProperty(gethum(), "PlatformStand")
		spawn(function()
			repeat wait()
				if not vfly and findhum() then
					local Human = gethum()
					Human.PlatformStand = true
				end
				if CONTROL.L + CONTROL.R ~= 0 or CONTROL.F + CONTROL.B ~= 0 or CONTROL.Q + CONTROL.E ~= 0 then
					SPEED = 50
				elseif not (CONTROL.L + CONTROL.R ~= 0 or CONTROL.F + CONTROL.B ~= 0 or CONTROL.Q + CONTROL.E ~= 0) and SPEED ~= 0 then
					SPEED = 0
				end
				if (CONTROL.L + CONTROL.R) ~= 0 or (CONTROL.F + CONTROL.B) ~= 0 or (CONTROL.Q + CONTROL.E) ~= 0 then
					BV.velocity = ((workspace.CurrentCamera.CoordinateFrame.lookVector * (CONTROL.F + CONTROL.B)) + ((workspace.CurrentCamera.CoordinateFrame * CFrame.new(CONTROL.L + CONTROL.R, (CONTROL.F + CONTROL.B + CONTROL.Q + CONTROL.E) * 0.2, 0).p) - workspace.CurrentCamera.CoordinateFrame.p)) * SPEED
					lCONTROL = {F = CONTROL.F, B = CONTROL.B, L = CONTROL.L, R = CONTROL.R}
				elseif (CONTROL.L + CONTROL.R) == 0 and (CONTROL.F + CONTROL.B) == 0 and (CONTROL.Q + CONTROL.E) == 0 and SPEED ~= 0 then
					BV.velocity = ((workspace.CurrentCamera.CoordinateFrame.lookVector * (lCONTROL.F + lCONTROL.B)) + ((workspace.CurrentCamera.CoordinateFrame * CFrame.new(lCONTROL.L + lCONTROL.R, (lCONTROL.F + lCONTROL.B + CONTROL.Q + CONTROL.E) * 0.2, 0).p) - workspace.CurrentCamera.CoordinateFrame.p)) * SPEED
				else
					BV.velocity = Vector3.new(0, 0, 0)
				end
				BG.cframe = workspace.CurrentCamera.CoordinateFrame
			until not FLYING
			CONTROL = {F = 0, B = 0, L = 0, R = 0, Q = 0, E = 0}
			lCONTROL = {F = 0, B = 0, L = 0, R = 0, Q = 0, E = 0}
			SPEED = 0
			BG:Destroy()
			BV:Destroy()
			if findhum() then
				local Human = gethum()
				Human.PlatformStand = true
			end
		end)
	end
	flyKeyDown = DAMouse.KeyDown:Connect(function(KEY)
		if KEY:lower() == "w" then
			CONTROL.F = (vfly and Settings.vehicleflyspeed or Settings.daflyspeed)
		elseif KEY:lower() == "s" then
			CONTROL.B = - (vfly and Settings.vehicleflyspeed or Settings.daflyspeed)
		elseif KEY:lower() == "a" then
			CONTROL.L = - (vfly and Settings.vehicleflyspeed or Settings.daflyspeed)
		elseif KEY:lower() == "d" then 
			CONTROL.R = (vfly and Settings.vehicleflyspeed or Settings.daflyspeed)
		elseif QEfly and KEY:lower() == "e" then
			CONTROL.Q = (vfly and Settings.vehicleflyspeed or Settings.daflyspeed) * 2
		elseif QEfly and KEY:lower() == "q" then
			CONTROL.E = - (vfly and Settings.vehicleflyspeed or Settings.daflyspeed) * 2
		end
		pcall(function() workspace.CurrentCamera.CameraType = Enum.CameraType.Track end)
	end)
	flyKeyUp = DAMouse.KeyUp:Connect(function(KEY)
		if KEY:lower() == "w" then
			CONTROL.F = 0
		elseif KEY:lower() == "s" then
			CONTROL.B = 0
		elseif KEY:lower() == "a" then
			CONTROL.L = 0
		elseif KEY:lower() == "d" then
			CONTROL.R = 0
		elseif KEY:lower() == "e" then
			CONTROL.Q = 0
		elseif KEY:lower() == "q" then
			CONTROL.E = 0
		end
	end)
	FLY()
end

NOFLY = function()
	FLYING = false
	if flyKeyDown or flyKeyUp then flyKeyDown:Disconnect() flyKeyUp:Disconnect() end
	pcall(function() workspace.CurrentCamera.CameraType = Enum.CameraType.Custom end)
	wait()
	execCmd("unstun")
end

local RoundNumber = function(Number, Divider)
	Divider = Divider or 1
	return (math.floor((Number/Divider) + 0.5) * Divider)
end

r15 = function(speaker)
	local Humanoid = speaker.Character:FindFirstChildWhichIsA("Humanoid")
	if Humanoid.RigType == Enum.HumanoidRigType.R15 then
		return true
	else
		return false
	end
end

local respawn = function(plr)
	local char = plr.Character
	char:ClearAllChildren()
	local newChar = Instance.new("Model")
	Prote.ProtectInstance(newChar)
	newChar.Parent = workspace
	plr.Character = newChar
	wait()
	plr.Character = char
	newChar:Destroy()
end

local refresh = function(plr)
	spawn(function()
		refreshCmd = true
		local rpos = plr.Character.HumanoidRootPart.Position
		wait()
		respawn(plr)
		wait()
		repeat wait() until plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
		wait(.1)
		if rpos then
			plr.Character:MoveTo(rpos)
			wait()
		end
		refreshCmd = false
	end)
end

local attach = function(speaker, target)
	if tools(speaker) then
		local chara = speaker.Character
		local tchar = target.Character
		local hum = gethum(speaker.Character)
		local hrp = speaker.Character.HumanoidRootPart
		local hrp2 = target.Character.HumanoidRootPart
		hum.Name = "1"
		local newHum = hum:Clone()
		newHum.Parent = chara
		newHum.Name = "Humanoid"
		wait()
		hum:Destroy()
		workspace.CurrentCamera.CameraSubject = chara
		newHum.DisplayDistanceType = "None"
		local tool = getbp(speaker):FindFirstChildOfClass("Tool") or speaker.Character:FindFirstChildOfClass("Tool")
		Prote.SpoofInstance(tool)
		tool.Parent = chara
		hrp.CFrame = hrp2.CFrame * CFrame.new(0, 0, 0) * CFrame.new(math.random(-100, 100)/200,math.random(-100, 100)/200,math.random(-100, 100)/200)
		local n = 0
		repeat
			wait(.1)
			n = n + 1
			hrp.CFrame = hrp2.CFrame
		until (tool.Parent ~= chara or not hrp or not hrp2 or not hrp.Parent or not hrp2.Parent or n > 250) and n > 2
	end
end

iRound = function(num, numDecimalPlaces)
	local mult = 10^(numDecimalPlaces or 0)
	return math.floor(num * mult + 0.5) / mult
end

local ESP = function(plr)
	spawn(function()
		for i,v in pairs(CoreGui:GetChildren()) do
			if v.Name == plr.Name .. "_ESP" then
				v:Destroy()
			end
		end
		wait()
		if plr.Character and plr.Name ~= Players.LocalPlayer.Name and not CoreGui:FindFirstChild(plr.Name .. "_ESP") then
			local ESPholder = Instance.new("Folder", CoreGui)
			Prote.ProtectInstance(ESPholder)
			ESPholder.Name = plr.Name .. "_ESP"
			repeat wait(1) until plr.Character and getRoot(plr.Character) and plr.Character:FindFirstChildWhichIsA("Humanoid")
			for b,n in pairs (plr.Character:GetChildren()) do
				if (n:IsA("BasePart")) then
					local a = Instance.new("BoxHandleAdornment")
					Prote.ProtectInstance(a)
					a.Name = plr.Name
					a.Parent = ESPholder
					a.Adornee = n
					a.AlwaysOnTop = true
					a.ZIndex = 10
					a.Size = n.Size
					a.Transparency = 0.3
					a.Color = plr.TeamColor
				end
			end
			if plr.Character and plr.Character:FindFirstChild("Head") then
				local BillboardGui = Instance.new("BillboardGui")
				Prote.ProtectInstance(BillboardGui)
				local TextLabel = Instance.new("TextLabel")
				BillboardGui.Adornee = plr.Character.Head
				BillboardGui.Name = plr.Name
				BillboardGui.Parent = ESPholder
				BillboardGui.Size = UDim2.new(0, 100, 0, 150)
				BillboardGui.StudsOffset = Vector3.new(0, 1, 0)
				BillboardGui.AlwaysOnTop = true
				TextLabel.Parent = BillboardGui
				TextLabel.BackgroundTransparency = 1
				TextLabel.Position = UDim2.new(0, 0, 0, -50)
				TextLabel.Size = UDim2.new(0, 100, 0, 100)
				TextLabel.Font = Enum.Font.SourceSansSemibold
				TextLabel.TextSize = 20
				TextLabel.TextColor3 = Color3.new(1, 1, 1)
				TextLabel.TextStrokeTransparency = 0
				TextLabel.TextYAlignment = Enum.TextYAlignment.Bottom
				TextLabel.Text = "Name: " .. plr.Name
				TextLabel.ZIndex = 10
				local espLoopFunc
				local teamChange
				local addedFunc
				addedFunc = plr.CharacterAdded:Connect(function()
					if ESPenabled then
						espLoopFunc:Disconnect()
						teamChange:Disconnect()
						ESPholder:Destroy()
						repeat wait(1) until getRoot(plr.Character) and plr.Character:FindFirstChildWhichIsA("Humanoid")
						ESP(plr)
						addedFunc:Disconnect()
					else
						teamChange:Disconnect()
						addedFunc:Disconnect()
					end
				end)
				teamChange = plr:GetPropertyChangedSignal("TeamColor"):Connect(function()
					if ESPenabled then
						espLoopFunc:Disconnect()
						addedFunc:Disconnect()
						ESPholder:Destroy()
						repeat wait(1) until getRoot(plr.Character) and plr.Character:FindFirstChildWhichIsA("Humanoid")
						ESP(plr)
						teamChange:Disconnect()
					else
						teamChange:Disconnect()
					end
				end)
				local function espLoop()
					if CoreGui:FindFirstChild(plr.Name .. "_ESP") then
						if plr.Character and getRoot(plr.Character) and plr.Character:FindFirstChildWhichIsA("Humanoid") and Players.LocalPlayer.Character and getRoot(Players.LocalPlayer.Character) and Players.LocalPlayer.Character:FindFirstChildWhichIsA("Humanoid") then
							local pos = math.floor((getRoot(Players.LocalPlayer.Character).Position - getRoot(plr.Character).Position).magnitude)
							TextLabel.Text = "Name: " .. plr.Name .. " | Health: " .. iRound(plr.Character:FindFirstChildOfClass("Humanoid").Health, 1) .. " | Studs: " .. pos
						end
					else
						teamChange:Disconnect()
						addedFunc:Disconnect()
						espLoopFunc:Disconnect()
					end
				end
				espLoopFunc = game:GetService("RunService").RenderStepped:Connect(espLoop)
			end
		end
	end)
end

local Locate = function(plr)
	spawn(function()
		for i,v in pairs(CoreGui:GetChildren()) do
			if v.Name == plr.Name .. "_LC" then
				v:Destroy()
			end
		end
		wait()
		if plr.Character and plr.Name ~= Players.LocalPlayer.Name and not CoreGui:FindFirstChild(plr.Name .. "_LC") then
			local ESPholder = Instance.new("Folder", CoreGui)
			Prote.ProtectInstance(ESPholder)
			ESPholder.Name = plr.Name .. "_LC"
			repeat wait(1) until plr.Character and getRoot(plr.Character) and plr.Character:FindFirstChildWhichIsA("Humanoid")
			for b,n in pairs (plr.Character:GetChildren()) do
				if (n:IsA("BasePart")) then
					local a = Instance.new("BoxHandleAdornment")
					Prote.ProtectInstance(a)
					a.Name = plr.Name
					a.Parent = ESPholder
					a.Adornee = n
					a.AlwaysOnTop = true
					a.ZIndex = 10
					a.Size = n.Size
					a.Transparency = 0.3
					a.Color = plr.TeamColor
				end
			end
			if plr.Character and plr.Character:FindFirstChild("Head") then
				local BillboardGui = Instance.new("BillboardGui")
				Prote.ProtectInstance(BillboardGui)
				local TextLabel = Instance.new("TextLabel")
				BillboardGui.Adornee = plr.Character.Head
				BillboardGui.Name = plr.Name
				BillboardGui.Parent = ESPholder
				BillboardGui.Size = UDim2.new(0, 100, 0, 150)
				BillboardGui.StudsOffset = Vector3.new(0, 1, 0)
				BillboardGui.AlwaysOnTop = true
				TextLabel.Parent = BillboardGui
				TextLabel.BackgroundTransparency = 1
				TextLabel.Position = UDim2.new(0, 0, 0, -50)
				TextLabel.Size = UDim2.new(0, 100, 0, 100)
				TextLabel.Font = Enum.Font.SourceSansSemibold
				TextLabel.TextSize = 20
				TextLabel.TextColor3 = Color3.new(1, 1, 1)
				TextLabel.TextStrokeTransparency = 0
				TextLabel.TextYAlignment = Enum.TextYAlignment.Bottom
				TextLabel.Text = "Name: " .. plr.Name
				TextLabel.ZIndex = 10
				local lcLoopFunc
				local addedFunc
				local teamChange
				addedFunc = plr.CharacterAdded:Connect(function()
					if ESPholder ~= nil and ESPholder.Parent ~= nil then
						lcLoopFunc:Disconnect()
						teamChange:Disconnect()
						ESPholder:Destroy()
						repeat wait(1) until getRoot(plr.Character) and plr.Character:FindFirstChildWhichIsA("Humanoid")
						Locate(plr)
						addedFunc:Disconnect()
					else
						teamChange:Disconnect()
						addedFunc:Disconnect()
					end
				end)
				teamChange = plr:GetPropertyChangedSignal("TeamColor"):Connect(function()
					if ESPholder ~= nil and ESPholder.Parent ~= nil then
						lcLoopFunc:Disconnect()
						addedFunc:Disconnect()
						ESPholder:Destroy()
						repeat wait(1) until getRoot(plr.Character) and plr.Character:FindFirstChild("Humanoid")
						Locate(plr)
						teamChange:Disconnect()
					else
						teamChange:Disconnect()
					end
				end)
				local lcLoop = function()
					if CoreGui:FindFirstChild(plr.Name .. "_LC") then
						if plr.Character and getRoot(plr.Character) and plr.Character:FindFirstChildWhichIsA("Humanoid") and Players.LocalPlayer.Character and getRoot(Players.LocalPlayer.Character) and Players.LocalPlayer.Character:FindFirstChildWhichIsA("Humanoid") then
							local pos = math.floor((getRoot(Players.LocalPlayer.Character).Position - getRoot(plr.Character).Position).magnitude)
							TextLabel.Text = "Name: " .. plr.Name .. " | Health: " .. round(plr.Character:FindFirstChildOfClass("Humanoid").Health, 1) .. " | Studs: " .. pos
						end
					else
						teamChange:Disconnect()
						addedFunc:Disconnect()
						lcLoopFunc:Disconnect()
					end
				end
				lcLoopFunc = game:GetService("RunService").RenderStepped:Connect(lcLoop)
			end
		end
	end)
end

local kill = function(speaker, target, fast)
	if tools(speaker) then
		if target ~= nil then
			local NormPos = speaker.Character.HumanoidRootPart.CFrame
			if not fast then
				refresh(speaker)
				wait()
				repeat wait() until speaker.Character ~= nil and speaker.Character:FindFirstChild("HumanoidRootPart")
				wait(0.3)
			end
			local hrp = speaker.Character.HumanoidRootPart
			attach(speaker,target)
			repeat
				wait()
				hrp.CFrame = CFrame.new(999999, workspace.FallenPartsDestroyHeight + 5,999999)
			until not target.Character:FindFirstChild("HumanoidRootPart") or not speaker.Character:FindFirstChild("HumanoidRootPart")
			wait(3)
			speaker.CharacterAdded:Wait():WaitForChild("HumanoidRootPart").CFrame = NormPos
		end
	end
end

local bring = function(speaker, target, fast)
	if tools(speaker) then
		if target ~= nil then
			local NormPos = getRoot(speaker.Character).CFrame
			if not fast then
				refresh(speaker)
				wait()
				repeat wait() until speaker.Character ~= nil and getRoot(speaker.Character)
				wait(0.3)
			end
			local hrp = getRoot(speaker.Character)
			attach(speaker, target)
			repeat
				wait()
				hrp.CFrame = NormPos
			until not getRoot(target.Character) or not getRoot(speaker.Character)
			wait(1)
			speaker.CharacterAdded:Wait():WaitForChild("HumanoidRootPart").CFrame = NormPos
		end
	end
end

local teleport = function(speaker, target, target2, fast)
	if tools(speaker) then
		if target ~= nil then
			local NormPos = getRoot(speaker.Character).CFrame
			if not fast then
				refresh(speaker)
				wait()
				repeat wait() until speaker.Character ~= nil and getRoot(speaker.Character)
				wait(0.3)
			end
			local hrp = getRoot(speaker.Character)
			local hrp2 = getRoot(target2.Character)
			attach(speaker,target)
			repeat
				wait()
				hrp.CFrame = hrp2.CFrame
			until not getRoot(target.Character) or not getRoot(speaker.Character)
			wait(1)
			speaker.CharacterAdded:Wait():WaitForChild("HumanoidRootPart").CFrame = NormPos
		end
	end
end

local BrowserList = {}
local BrowserBtn = function(plugin_name, plugin_name, plugin_description, plugin_source)
	BrowserList[#BrowserList + 1] = {
		name = plugin_name,
		plugname = plugin_name,
		plugdesc = plugin_description,
		source = plugin_source,
	}
end

Players.LocalPlayer.Chatted:Connect(function(message)
	spawn(function()
		wait()
		message = message:lower()
		do_exec(message, Players.LocalPlayer)
	end)
end)

DAMouse.KeyDown:Connect(function(key)
	if (key == Settings.Prefix) then
		spawn(function()
			CaptureCmdBar()
		end)
	end
end)

local cmdbarText = Cmdbar.Text:gsub("^" .. "%" .. Settings.Prefix, "")

Cmdbar.FocusLost:Connect(function(enterPressed)
	if enterPressed then
		cmdbarText = Cmdbar.Text:gsub("^" .. "%" .. Settings.Prefix, "") 
		spawn(function()
			CmdBarStatus(false)
		end)
		spawn(function()
			execCmd(cmdbarText, Players.LocalPlayer, true)
		end)
	end
	wait()
	if not Cmdbar:IsFocused() then
		Cmdbar.Text = ""
	end
end)

local macroSystem = function()
	DAMouse.KeyDown:Connect(function(Key)
		for i = 1, #DA_Binds do
			if DA_Binds[i].KEY == string.lower(tostring(Key)) then
				execCmd(DA_Binds[i].CMD)
			end
		end
	end)
end

local newCmd = function(name, aliases, title, description, func) addcmd(name, aliases, title, description, func) end

local VirtualEnvironment = function()
	if not getgenv then return end
	local Environment = {}
	Environment.loaded = true
	Environment.Interface = GUI
	Environment.newCmd = newCmd
	Environment.BrowserBtn = BrowserBtn
	Environment.build_key = randomString()
	Environment.notify = notify
	Environment.getcmds = function() return cmds end
	Environment.running_error = function() notify(Loaded_Title, "Already Running!") end
	Environment.matchsearch = MatchSearch
	Environment.execCmd = execCmd
	Environment.events = {}
	getgenv()["DA_ENV"] = Environment
	getgenv()["da_env"] = Environment
end

--// Start of Setup \\--
local ToggleBoxFunc = function(Container, Enabled, Callback)
	local Switch = Container.Switch
	local Hitbox = Container.Hitbox
	if not Enabled then
		Switch.Position = UDim2.fromOffset(2, 2)
		Container.BackgroundColor3 = Color3.fromRGB(34, 30, 28)
	end
	Hitbox.MouseButton1Down:Connect(function()
		Enabled = not Enabled
		TweenObj(Switch, "Quad", "Out", 0.25, {
			Position = Enabled and UDim2.new(1, -18, 0, 2) or UDim2.fromOffset(2, 2)
		})
		TweenObj(Container, "Quad", "Out", 0.25, {
			BackgroundColor3 = Enabled and Color3.fromRGB(85, 255, 127) or Color3.fromRGB(34, 30, 28)
		})
		Callback(Enabled)
	end)
end

local AddInputBox = function(Title, Callback)
	local NewBtn = Assets.InputBox:Clone()
	NewBtn.Title.Text = tostring(Title)
	NewBtn.Input.FocusLost:Connect(function(enterPressed)
		if enterPressed then
			Callback(tostring(NewBtn.Input.Text))
		end
	end)
	NewBtn.Parent = DaUi.Pages.Menu.Results
	NewBtn.Visible = true
	return NewBtn
end

local AddButton = function(Title, Func)
	Func = Func or function() end
	local NewBtn = Assets.ButtonBox:Clone()
	NewBtn.Hitbox.MouseButton1Down:Connect(function()
		pcall(Func)
	end)
	NewBtn.Title.Text = tostring(Title)
	NewBtn.Parent = DaUi.Pages.Menu.Results
	NewBtn.Visible = true
	removeCutOff(NewBtn.Title)
end

local AddSetting = function(Title, Enabled, Callback)
	local Toggle = Assets.ToggleBox:Clone()
	local Container = Toggle.Container
	ToggleBoxFunc(Container, Enabled, Callback)
	Toggle.Title.Text = tostring(Title)
	Toggle.Parent = DaUi.Pages.Menu.Results
	Toggle.Visible = true
	removeCutOff(Toggle.Title)
end

local ClearScriptArea = function()
	spawn(function()
		ScriptTabLoaded = false
		for i,v in pairs(DaUi.Pages.Scripts.Results:GetChildren()) do
			if not v:IsA("UIListLayout") then
				v:Destroy()
			end
		end
	end)
end

local CreateScript = function(scriptname, devs, gameid, scrfunction)
	local log = Assets.ScriptLog:Clone()
	log.Name = (string.lower(tostring(scriptname)) .. " " .. string.lower(tostring(devs)) .. " " .. string.lower(tostring(gameid)))
	log.ScriptName.Text = tostring(scriptname)
	log.Creator.Text = tostring(devs)
	log.Compatibility.Text = tostring(gameid)
	log.Execute.MouseButton1Down:Connect(function()
		pcall(scrfunction)
	end)
	log.Parent = DaUi.Pages.Scripts.Results
	log.Visible = true
end

spawn(function()
	pcall(function() ParentGui(GUI) end)
	spawn(function()
		SmoothDrag(CommandsGui)
		SmoothDrag(PluginBrowser)
		UiDragF.Active = true
		UiDragF.Draggable = true
		local pb_scroll = PluginBrowser.Area.ScrollingFrame
		SmoothScroll(pb_scroll, 0.14)
		macroSystem()
	end)
	spawn(function()
		DaUi.Pages.Commands.SearchBar.SearchFrame.Search:GetPropertyChangedSignal("Text"):Connect(function()
			local Text = string.lower(DaUi.Pages.Commands.SearchBar.SearchFrame.Search.Text)
			for _, v in next, DaUi.Pages.Commands.Results:GetChildren() do
				if v:IsA("TextButton") then
					local Command = v.Label.Text
					v.Visible = string.find(string.lower(Command), Text, 1, true)
				end
			end
		end)
	end)
	spawn(function()
		DaUi.Pages.Scripts.SearchBar.SearchFrame.Search:GetPropertyChangedSignal("Text"):Connect(function()
			local Text = string.lower(tostring(DaUi.Pages.Scripts.SearchBar.SearchFrame.Search.Text))
			for _, v in next, DaUi.Pages.Scripts.Results:GetChildren() do
				if v:IsA("Frame") then
					local ScriptString = tostring(v.Name)
					v.Visible = string.find(string.lower(ScriptString), Text, 1, true)
				end
			end
		end)
	end)
	spawn(function()
		PluginBrowser.Area.ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, PluginBrowser.Area.ScrollingFrame.UIListLayout.AbsoluteContentSize.Y)
		DaUi.Pages.Scripts.Results.CanvasSize = UDim2.new(0, 0, 0, DaUi.Pages.Scripts.Results.UIListLayout.AbsoluteContentSize.Y)
		PluginBrowser.Area.ScrollingFrame.UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
			PluginBrowser.Area.ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, PluginBrowser.Area.ScrollingFrame.UIListLayout.AbsoluteContentSize.Y)
		end)
		DaUi.Pages.Scripts.Results.UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
			DaUi.Pages.Scripts.Results.CanvasSize = UDim2.new(0, 0, 0, DaUi.Pages.Scripts.Results.UIListLayout.AbsoluteContentSize.Y)
		end)
	end)
	CommandsGui.Close.MouseButton1Down:Connect(function()
		CmdListStatus(false)
	end)
	PluginBrowser.Close.MouseButton1Down:Connect(function()
		PlugBrowseStatus(false)
	end)
	PluginBrowser.GoBack.MouseButton1Down:Connect(function()
		for idk2,okay2 in pairs(PluginBrowser.Container:GetChildren()) do
			okay2.Visible = false
			PluginBrowser.GoBack.Visible = false
			PluginBrowser.Area.Visible = true
		end
	end)
	DaUi.Title.Close.MouseButton1Down:Connect(function()
		DaUiStatus(false)
	end)
	DaUi.Menu.Settings.MouseButton1Down:Connect(function()
		ClearScriptArea()
		DaUi.Pages.UIPageLayout:JumpTo(DaUi.Pages.Menu)
	end)
	DaUi.Menu.Server.MouseButton1Down:Connect(function()
		ClearScriptArea()
		DaUi.Pages.UIPageLayout:JumpTo(DaUi.Pages.Server)
	end)
	DaUi.Menu.ChatLogs.MouseButton1Down:Connect(function()
		ClearScriptArea()
		DaUi.Pages.UIPageLayout:JumpTo(DaUi.Pages.ChatLogs)
	end)
	DaUi.Menu.JoinLogs.MouseButton1Down:Connect(function()
		ClearScriptArea()
		DaUi.Pages.UIPageLayout:JumpTo(DaUi.Pages.JoinLogs)
	end)
	DaUi.Menu.Commands.MouseButton1Down:Connect(function()
		ClearScriptArea()
		DaUi.Pages.UIPageLayout:JumpTo(DaUi.Pages.Commands)
		if not CommandsLoaded then
			CommandsLoaded = true
			for _, v in next, cmds do
				if v["PLUGIN"] == false then
					addcmdtext(v["NAME"], v["TITLE"], v["ALIAS"], v["DESC"])
				else
					addcmdtext(v["NAME"], v["TITLE"], v["ALIAS"], v["DESC"], true)
				end
			end
		end
	end)
	DaUi.Menu.Scripts.MouseButton1Down:Connect(function()
		DaUi.Pages.UIPageLayout:JumpTo(DaUi.Pages.Scripts)
		if not ScriptTabLoaded then
			ScriptTabLoaded = true
			for _, v in next, ScriptsHolder do
				CreateScript(v["Name"], v["Dev"], v["ID"], v["Func"])
			end
		end
	end)
	DaUi.Pages.ChatLogs.ClearChatLogs.MouseButton1Down:Connect(function()
		ChatlogAPI.ClearAllChatLogs()
	end)
	DaUi.Pages.JoinLogs.ClearJoinLogs.MouseButton1Down:Connect(function()
		JoinlogAPI.ClearAllLogs()
	end)
	spawn(function()
		while wait(0.05) do
			if PluginBrowser.Area.Visible == false then
				PluginBrowser.GoBack.Visible = true
			else
				PluginBrowser.GoBack.Visible = false
			end
		end
	end)
	spawn(function()
		for _, plr in pairs(Players:GetChildren()) do
			if plr.ClassName == "Player" then
				ChatlogAPI.LogUser(plr)
			end
		end
	end)
	spawn(function()
		if syn and syn.queue_on_teleport and Settings.KeepDA then
			syn.queue_on_teleport("loadstring(game:HttpGetAsync(\"https://raw.githubusercontent.com/daximul/who/main/a/test/what/script.lua\"))();")
		end
	end)
end)
SetPrefix = AddInputBox("Prefix", function(Callback)
	if typeof(Callback) == "string" and #Callback <= 2 then
		Settings.Prefix = Callback
		updatesaves()
		notify("Prefix", "Succesfully changed to: " .. Callback)
    elseif #Callback > 2 then
    	SetPrefix.Input.Text = Settings.Prefix
        notify("Prefix", "Cannot be longer than 2 characters.")
    end
end)
SetPrefix.Input.Text = tostring(Settings.Prefix)
AddButton("Save Chat Logs", function()
	if writefileExploit() then
		ChatlogAPI.SaveAllLogsToFile()
	else
		notify("writefile", "Cannot Save File")
	end
end)
AddButton("Save Join Logs", function()
	if writefileExploit() then
		JoinlogAPI.SaveAllLogsToFile()
	else
		notify("writefile", "Cannot Save File")
	end
end)
AddSetting("Keep Admin", Settings.KeepDA, function(Callback)
	Settings.KeepDA = Callback
	Queue_Admin()
	updatesaves()
end)
AddSetting("Chat Logs", Settings.ChatLogs, function(Callback)
	Settings.ChatLogs = Callback
	updatesaves()
end)
AddSetting("Join Logs", Settings.JoinLogs, function(Callback)
	Settings.JoinLogs = Callback
	updatesaves()
end)
AddSetting("No Notifications", Settings.disablenotifications, function(Callback)
	Settings.disablenotifications = Callback
	updatesaves()
end)
AddSetting("Auto Net", Settings.AutoNet, function(Callback)
	Settings.AutoNet = Callback
	updatesaves()
end)
BrowserBtn("Hub Loader", "Hub Loader", "Load Specific Hubs", "return loadstring(game:HttpGet('https://raw.githubusercontent.com/daximul/who/main/a/test/what/browserplugins/hubloader.lua'))();")
BrowserBtn("Telekinesis", "Telekinesis", "Control Unanchored Parts\n~ Controls ~\nE = Push Part Away\nQ = Push Part Closer\n+ = Increase Telekinesis Strength(too much will make the part spaz out)\n- = Decrease Telekinesis Strength\nT = Instant Bring Part\nY = Instant Repulsion(Opposite of Bring)\nR = Makes Part Stiff (Cannot Rotate/Spin)", "return loadstring(game:HttpGet('https://raw.githubusercontent.com/daximul/who/main/a/test/what/browserplugins/telekinesis.lua'))();")
BrowserBtn("Freecam", "Freecam", "Control your Camera in a Smooth way", "return loadstring(game:HttpGet('https://raw.githubusercontent.com/daximul/who/main/a/test/what/browserplugins/freecam.lua'))();")
BrowserBtn("Shader Mod", "Shader Mod", "Toggle Shaders in your Roblox game (best with max graphics)", "return loadstring(game:HttpGet('https://raw.githubusercontent.com/daximul/who/main/a/test/what/browserplugins/shadermod.lua'))();")
BrowserBtn("Chat Spy", "Chat Spy", "Spy on Messages in Chat", "return loadstring(game:HttpGet('https://raw.githubusercontent.com/daximul/who/main/a/test/what/browserplugins/chatspy.lua'))();")
BrowserBtn("System Chat", "System Chat", "Fake your Chat as System\n\n{System} Your mom has joined the game", "return loadstring(game:HttpGet('https://raw.githubusercontent.com/daximul/who/main/a/test/what/browserplugins/systemchat.lua'))();")
BrowserBtn("Lag Server", "Lag Server", "Lag the Server. You will lag for 6 seconds before it works.", "return loadstring(game:HttpGet('https://raw.githubusercontent.com/daximul/who/main/a/test/what/browserplugins/lagserver.lua'))();")
BrowserBtn("Chat Translator", "Chat Translator", "Translate Chat and Reply\n\nhttps://en.wikipedia.org/wiki/List_of_ISO_639-1_codes\n\nYou have to look the 639-1 column to get a language", "return loadstring(game:HttpGet('https://raw.githubusercontent.com/daximul/who/main/a/test/what/browserplugins/chattranslator.lua'))();")
BrowserBtn("Toon ESP", "Toon ESP", "Load my ESP Script", "return loadstring(game:HttpGet('https://raw.githubusercontent.com/daximul/who/main/a/test/what/browserplugins/toonesp.lua'))();")
BrowserBtn("Drag and Resize Chat", "Drag and Resize Chat", "Make the Default ROBLOX Chat Draggable and Resizable", "return loadstring(game:HttpGet('https://raw.githubusercontent.com/daximul/who/main/a/test/what/browserplugins/dragresizechat.lua'))();")
BrowserBtn("Fun Gravity", "Fun Gravity", "Have Fun with Unanchored Parts", "return loadstring(game:HttpGet('https://raw.githubusercontent.com/daximul/who/main/a/test/what/browserplugins/fungravity.lua'))();")
BrowserBtn("Cyclically Btools", "Cyclically's Custom Btools", "Better Btools with Undo & Identify", "return loadstring(game:HttpGet('https://raw.githubusercontent.com/daximul/who/main/a/test/what/browserplugins/cycbtools.lua'))();")
BrowserBtn("Wall Run", "Wall Run", "Walk/Run on Walls!\n\nGravity Controller Originally made by EgoMoose", "return loadstring(game:HttpGet('https://raw.githubusercontent.com/daximul/who/main/a/test/what/browserplugins/wallrun.lua'))();")
BrowserBtn("RTX", "RTX: Graphics Enhancer", "Enhance your Graphics\n\nLevels in the Command Name:\n1: Low, not that good\n2: Medium sort of good\n3: Epic", "return loadstring(game:HttpGet('https://raw.githubusercontent.com/daximul/who/main/a/test/what/browserplugins/rtx.lua'))();")
BrowserBtn("Empty Server Finder", "Empty Server Finder", "Find the emptiest server of the current game you are playing", "return loadstring(game:HttpGet('https://raw.githubusercontent.com/daximul/who/main/a/test/what/browserplugins/emptyserverfinder.lua'))();")
BrowserBtn("Bypass Anticheats", "Bypass Anticheats", "Bypass the Anticheat in Most Games", "return loadstring(game:HttpGet('https://raw.githubusercontent.com/daximul/who/main/a/test/what/browserplugins/bypassanticheats.lua'))();")
BrowserBtn("Universal Bhop", "Universal Bhop", "Get the ability to bhop. Make sure to hold Space and then either hold A or D.", "return loadstring(game:HttpGet('https://raw.githubusercontent.com/daximul/who/main/a/test/what/browserplugins/universalbhop.lua'))();")
BrowserBtn("Future Lighting", "Future Lighting", "Lets you enable Future Lighting in any game", "return loadstring(game:HttpGet('https://raw.githubusercontent.com/daximul/who/main/a/test/what/browserplugins/futurelighting.lua'))();")
--// End of Setup \\--


--// Commands

newCmd("commands", {"cmds"}, "commands / cmds", "View the Command List", function(args, speaker)
	if IsDaUi == false then
		DaUiStatus(true)
		DaUi.Pages.UIPageLayout:JumpTo(DaUi.Pages.Commands)
	else
		DaUi.Pages.UIPageLayout:JumpTo(DaUi.Pages.Commands)
	end
	if not CommandsLoaded then
		CommandsLoaded = true
		for _, v in next, cmds do
			if v["PLUGIN"] == false then
				addcmdtext(v["NAME"], v["TITLE"], v["ALIAS"], v["DESC"])
			else
				addcmdtext(v["NAME"], v["TITLE"], v["ALIAS"], v["DESC"], true)
			end
		end
	end
end)

newCmd("openui", {"ui"}, "openui / ui", "Open the Dark Admin UI", function(args, speaker)
	DaUiStatus(true)
end)

newCmd("browser", {}, "browser", "Open the Plugin Browser", function(args, speaker)
	if not BrowserLoaded then
		BrowserLoaded = true
		for _, v in next, BrowserList do
			local name = v["name"]
			local plugname = v["plugdesc"]
			local plugdesc = v["plugdesc"]
			local source = v["source"]
			local PlugAreaTemplate = Assets.PlugAreaTemplate:Clone()
			local PlugName = PlugAreaTemplate.PlugName
			local PlugDesc = PlugAreaTemplate.PlugDesc
			local PlugAdd = PlugAreaTemplate.PlugAdd
			local PlugRemove = PlugAreaTemplate.PlugRemove
			local BrowserLabel = Assets.BrowserLabel:Clone()
			local OldFileName = string.lower(name)
			local NewFileName = string.gsub(OldFileName, " ", "")
			local ExtensionFile = ("Dark Admin/Plugins/" .. NewFileName .. ".da")
			PlugAreaTemplate.Parent = PluginBrowser.Container
			BrowserLabel.Parent = PluginBrowser.Area.ScrollingFrame
			BrowserLabel.Visible = true
			PlugName.Text = ("Plugin Name: " .. name)
			PlugDesc.Text = ("Plugin Description:\n" .. plugdesc)
			BrowserLabel.Label.Text = name
			BrowserLabel.MouseButton1Down:Connect(function()
				for idk,okay in pairs(PluginBrowser.Container:GetChildren()) do
					okay.Visible = false
					PluginBrowser.Area.Visible = false
					PlugAreaTemplate.Visible = true
				end
			end)
			PlugAdd.MouseButton1Down:Connect(function()
				if not isfile(ExtensionFile) then
					writefile(ExtensionFile, source)
					wait(0.2)
					addPlugin(NewFileName)
					updatesaves()
				else
					addPlugin(NewFileName)
					updatesaves()
				end
			end)
			PlugRemove.MouseButton1Down:Connect(function()
				deletePlugin(NewFileName)
				wait(0.2)
				updatesaves()
			end)
		end
	end
	PlugBrowseStatus(true)
end)

newCmd("prefix", {}, "prefix [string]", "Change the Prefix", function(args, speaker)
    if not args[1] then return notify("Prefix Error", "Missing Argument") end
	local pref = tostring(args[1])
	if typeof(pref) == "string" and #pref <= 2 then
		Settings.Prefix = pref
        SetPrefix.Input.Text = pref
		updatesaves()
		notify("Prefix", "Succesfully changed to: " .. pref)
    elseif #prefix > 2 then
        notify("Prefix", "Cannot be longer than 2 characters.")
    end
end)

newCmd("currentprefix", {}, "currentprefix", "Notify the Current Prefix", function(args, speaker)
	notify("", "Current Prefix is " .. Settings.Prefix)
end)

newCmd("rejoin", {"rj"}, "rejoin / rj", "Rejoin the server", function(args, speaker)
	if #Players:GetPlayers() <= 1 then
		Queue_Admin()
		Players.LocalPlayer:Kick("\nRejoining...")
		wait()
		TeleportService:Teleport(game.PlaceId, Players.LocalPlayer)
	else
		Queue_Admin()
		TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, Players.LocalPlayer)
	end
end)

newCmd("exit", {}, "exit", "Close Roblox", function(args, speaker)
	game:shutdown()
end)

newCmd("fullnet", {}, "fullnet", "Full Network Ownership", function(args, speaker)
	SetSimulationRadius()
	notify("Simulation Radius", "~ Inf ~")
end)

newCmd("unfullnet", {}, "unfullnet", "Disable Your Full Network Ownership", function(args, speaker)
	if Network_Loop ~= nil then
		Network_Loop:Disconnect()
		wait()
		Network_Loop = nil
		if setsimulation then
			setsimulation(139, 139)
		else
			sethidden(speaker, "MaximumSimulationRadius", 139)
			sethidden(speaker, "SimulationRadius", 139)
		end
		if args[1] and args[1] == "nonotify" then return end
		notify("Simulation Radius", "~ 139 ~")
	end
end)

newCmd("netcheck", {}, "netcheck", "Notify Who is Using Network Ownership", function(args, speaker)
	local CheckIfWorks = pcall(function()
		gethidden(Players.LocalPlayer, "SimulationRadius")
	end)
	
	local Plrs = {}
	local Msg = ""
	
	if CheckIfWorks then
		for i, v in pairs(Players:GetPlayers()) do
			if gethidden(v, "SimulationRadius") >= 5000 then
				table.insert(Plrs, v.Name)
			end
		end
		
		if #Plrs <= 0 then
			Msg = "No Players Found"
		elseif #Plrs == 1 then
			Msg = Plrs[1]
		elseif #Plrs > 1 then
			Msg = table.concat(Plrs, ", ")
		end
		
		return notify("Net Check", Msg)
	else
		return notify("Incompatible Exploit", "Missing gethiddenproperty")
	end
end)

newCmd("walkspeed", {"ws"}, "walkspeed / ws [number]", "Change your WalkSpeed", function(args, speaker)
	if args[1] == nil then return notify("WalkSpeed", "Argument Missing") end
	local wspeed = args[1]
	if speaker and speaker.Character and findhum() then
		if isNumber(wspeed) then
			local Human = gethum()
			Prote.SpoofProperty(Human, "WalkSpeed")
			Human.WalkSpeed = wspeed
		else
			notify("WalkSpeed", "Number Required")
		end
	end
end)

newCmd("loopspeed", {"loopws"}, "loopspeed / loopws [num]", "Loops your Walkspeed", function(args, speaker)
	local speed = args[1] or 16
	if args[2] then
		speed = args[2] or 16
	end
	if isNumber(speed) then
		local Char = speaker.Character or workspace:FindFirstChild(speaker.Name)
		local Human = Char and Char:FindFirstChildWhichIsA("Humanoid")
		local WalkSpeedChange = function()
			if Char and Human then
				Prote.SpoofProperty(Human, "WalkSpeed")
				Human.WalkSpeed = speed
			end
		end
		WalkSpeedChange()
		HumanModCons.wsLoop = (HumanModCons.wsLoop and HumanModCons.wsLoop:Disconnect() and false) or Human:GetPropertyChangedSignal("WalkSpeed"):Connect(WalkSpeedChange)
		HumanModCons.wsCA = (HumanModCons.wsCA and HumanModCons.wsCA:Disconnect() and false) or speaker.CharacterAdded:Connect(function(nChar)
			Char, Human = nChar, nChar:WaitForChild("Humanoid")
			WalkSpeedChange()
			HumanModCons.wsLoop = (HumanModCons.wsLoop and HumanModCons.wsLoop:Disconnect() and false) or Human:GetPropertyChangedSignal("WalkSpeed"):Connect(WalkSpeedChange)
		end)
	end
end)

newCmd("unloopspeed", {"unloopws"}, "unloopspeed / unloopws", "Disable LoopSpeed", function(args, speaker)
	HumanModCons.wsLoop = (HumanModCons.wsLoop and HumanModCons.wsLoop:Disconnect() and false) or nil
	HumanModCons.wsCA = (HumanModCons.wsCA and HumanModCons.wsCA:Disconnect() and false) or nil
end)

newCmd("jumppower", {"jp"}, "jumppower / jp [number]", "Change your JumpPower", function(args, speaker)
	if args[1] == nil then return notify("JumpPower", "Argument Missing") end
	local jppower = args[1]
	if speaker and speaker.Character and findhum() then
		if isNumber(jppower) then
			local Human = gethum()
			if Human.UseJumpPower then
				Prote.SpoofProperty(Human, "JumpPower")
				Human.JumpPower = jppower
			else
				Prote.SpoofProperty(Human, "JumpHeight")
				Human.JumpHeight = jppower
			end
		else
			notify("JumpPower", "Number Required")
		end
	end
end)

newCmd("loopjumppower", {"loopjp"}, "loopjumppower / loopjp [num]", "Loops your Jump Height", function(args, speaker)
	local jpower = args[1] or 50
	if isNumber(jpower) then
		local Char = speaker.Character or workspace:FindFirstChild(speaker.Name)
		local Human = Char and Char:FindFirstChildWhichIsA("Humanoid")
		local JumpPowerChange = function()
			if Char and Human then
				if Human.UseJumpPower then
					Prote.SpoofProperty(Human, "JumpPower")
					Human.JumpPower = jppower
				else
					Prote.SpoofProperty(Human, "JumpHeight")
					Human.JumpHeight = jppower
				end
			end
		end
		JumpPowerChange()
		HumanModCons.jpLoop = (HumanModCons.jpLoop and HumanModCons.jpLoop:Disconnect() and false) or Human:GetPropertyChangedSignal("JumpPower"):Connect(JumpPowerChange)
		HumanModCons.jpCA = (HumanModCons.jpCA and HumanModCons.jpCA:Disconnect() and false) or speaker.CharacterAdded:Connect(function(nChar)
			Char, Human = nChar, nChar:WaitForChild("Humanoid")
			JumpPowerChange()
			HumanModCons.jpLoop = (HumanModCons.jpLoop and HumanModCons.jpLoop:Disconnect() and false) or Human:GetPropertyChangedSignal("JumpPower"):Connect(JumpPowerChange)
		end)
	end
end)

newCmd("unloopjumppower", {"unloopjp"}, "unloopjumppower / unloopjp", "Disable LoopJumpPower", function(args, speaker)
	HumanModCons.jpLoop = (HumanModCons.jpLoop and HumanModCons.jpLoop:Disconnect() and false) or nil
	HumanModCons.jpCA = (HumanModCons.jpCA and HumanModCons.jpCA:Disconnect() and false) or nil
end)

newCmd("goto", {"to"}, "goto / to [plr]", "Teleport to a Player", function(args, speaker)
	if clientsidebypass == false then
		local users = getPlayer(args[1], speaker)
		for i,v in pairs(users) do
			if Players[v].Character ~= nil then
				if speaker.Character:FindFirstChildWhichIsA("Humanoid") and speaker.Character:FindFirstChildWhichIsA("Humanoid").SeatPart then
					local Human = speaker.Character:FindFirstChildWhichIsA("Humanoid")
					Prote.SpoofProperty(Human, "Sit")
					Human.Sit = false
					wait(0.1)
				end
				getRoot(speaker.Character).CFrame = getRoot(Players[v].Character).CFrame + Vector3.new(3, 1, 0)
			end
		end
		execCmd("breakvelocity")
	else
		local users = getPlayer(args[1], speaker)
		for i,v in pairs(users) do
			if Players[v].Character ~= nil then
				if speaker.Character:FindFirstChildWhichIsA("Humanoid") and speaker.Character:FindFirstChildWhichIsA("Humanoid").SeatPart then
					local Human = speaker.Character:FindFirstChildWhichIsA("Humanoid")
					Prote.SpoofProperty(Human, "Sit")
					Human.Sit = false
					wait(0.1)
				end
				game:GetService("TweenService"):Create(getRoot(speaker.Character), TweenInfo.new(2), {CFrame = getRoot(Players[v].Character).CFrame}):Play()
			end
		end
	end
end)

newCmd("pulseto", {"pto"}, "pulseto / pto [plr] [seconds]", "Teleports you to a player for a specified ammount of time", function(args, speaker)
	if clientsidebypass == false then
		local users = getPlayer(args[1], speaker)
		for i,v in pairs(users) do
			if Players[v].Character ~= nil then
				local startPos = getRoot(speaker.Character).CFrame
				local seconds = tonumber(args[2]) or 1
				if speaker.Character:FindFirstChildWhichIsA("Humanoid") and speaker.Character:FindFirstChildWhichIsA("Humanoid").SeatPart then
					local Human = speaker.Character:FindFirstChildWhichIsA("Humanoid")
					Prote.SpoofProperty(Human, "Sit")
					Human.Sit = false
					wait(0.1)
				end
				getRoot(speaker.Character).CFrame = getRoot(Players[v].Character).CFrame + Vector3.new(3, 1, 0)
				wait(seconds)
				getRoot(speaker.Character).CFrame = startPos
			end
		end
		execCmd("breakvelocity")
	else
		local users = getPlayer(args[1], speaker)
		for i,v in pairs(users) do
			if Players[v].Character ~= nil then
				local startPos = getRoot(speaker.Character).CFrame
				local seconds = tonumber(args[2]) or 1
				if speaker.Character:FindFirstChildWhichIsA("Humanoid") and speaker.Character:FindFirstChildWhichIsA("Humanoid").SeatPart then
					local Human = speaker.Character:FindFirstChildWhichIsA("Humanoid")
					Prote.SpoofProperty(Human, "Sit")
					Human.Sit = false
					wait(0.1)
				end
				game:GetService("TweenService"):Create(getRoot(speaker.Character), TweenInfo.new(2), {CFrame = getRoot(Players[v].Character).CFrame}):Play()
				wait(seconds)
				game:GetService("TweenService"):Create(getRoot(speaker.Character), TweenInfo.new(2), {CFrame = startPos}):Play()
			end
		end
	end
end)

newCmd("noclip", {}, "noclip", "Disable your Collison", function(args, speaker)
	Clip = false
	wait(0.1)
	local NoclipLoop = function()
		if Clip == false and speaker.Character ~= nil then
			for _, child in pairs(speaker.Character:GetDescendants()) do
				if child:IsA("BasePart") and child.CanCollide == true and child.Name ~= floatName then
					Prote.SpoofProperty(child, "CanCollide")
					child.CanCollide = false
				end
			end
		end
	end
	Noclipping = game:GetService("RunService").Stepped:Connect(NoclipLoop)
	if args[1] and args[1] == "nonotify" then return end
	notify("Noclip", "Noclip Enabled")
end)

newCmd("clip", {"unnoclip"}, "clip / unnoclip", "Stop Noclipping", function(args, speaker)
	if Noclipping then
		Noclipping:Disconnect()
	end
	Clip = true
	if args[1] and args[1] == "nonotify" then return end
	notify("Noclip", "Noclip Disabled")
end)

newCmd("togglenoclip", {}, "togglenoclip", "Toggle Noclip", function(args, speaker)
	if Clip == true then
		execCmd("clip nonotify")
		wait()
		execCmd("noclip")
	elseif Clip == false then
		execCmd("clip")
	end
end)

newCmd("fly", {}, "fly [number]", "Be Able to Fly", function(args, speaker)
	NOFLY()
	wait()
	sFLY()
	if args[1] and isNumber(args[1]) then
		Settings.daflyspeed = tonumber(args[1])
		updatesaves()
	end
end)

newCmd("vfly", {"vehiclefly"}, "vfly / vehiclefly [number]", "Be Able to Make Vehicles Fly", function(args, speaker)
	NOFLY()
	wait()
	sFLY(true)
	if args[1] and isNumber(args[1]) then
		Settings.vehicleflyspeed = tonumber(args[1])
		updatesaves()
	end
end)

newCmd("flyspeed", {"flysp"}, "flyspeed / flysp", "Change your Flyspeed", function(args, speaker)
	local speed = args[1] or 1
	if args[1] and isNumber(speed) then
		Settings.daflyspeed = tonumber(speed)
		updatesaves()
	end
end)

newCmd("vflyspeed", {"vflysp"}, "vflyspeed / vflysp", "Change your Vehicle Flyspeed", function(args, speaker)
	local speed = args[1] or 1
	if args[1] and isNumber(speed) then
		Settings.vehicleflyspeed = tonumber(speed)
		updatesaves()
	end
end)

newCmd("unfly", {"unvfly"}, "unfly / unvfly", "Stop Flying", function(args, speaker)
	NOFLY()
end)

newCmd("cframefly", {"cfly"}, "cframefly / cfly [speed]", "Makes you Fly (Bypasses Some Anti Cheats)", function(args, speaker)
	if args[1] and isNumber(args[1]) then
		Settings.cframeflyspeed = tonumber(args[1])
		updatesaves()
	end
	local UIS = game:GetService("UserInputService")
	local RunService = game:GetService("RunService")
	local GC = getconnections or get_signal_cons
	local Keys = Enum.KeyCode
	local v3 = Vector3.new()
	local cf = CFrame.new()
	CflyCon = RunService.Heartbeat:Connect(function()
		local Camera = workspace.CurrentCamera
		local Cache = {}
		local Human = speaker.Character and speaker.Character:FindFirstChildWhichIsA("Humanoid")
		local HRP = Human and Human.RootPart or speaker.Character.PrimaryPart
		if not speaker.Character or not Human or not HRP or not Camera then
			return 
		end
		local Cache = {}
		local Cons = {game.ItemChanged, Human.StateChanged, Human.Changed, speaker.Character.Changed}
		for _, v in ipairs(speaker.Character:GetChildren()) do
			if v:IsA("BasePart") then
				Cons[#Cons + 1] = v.Changed
				Cons[#Cons + 1] = v:GetPropertyChangedSignal("CFrame")
			end
		end
		for _, v in ipairs(Cons) do
			for _, v1 in ipairs(GC(v)) do
				if not rawget(v1, "__OBJECT_ENABLED") then
					Cache[#Cache + 1] = v1
					v1:Disable()
				end
			end
		end
		Human:ChangeState(11)
		HRP.CFrame = CFrame.new(HRP.Position, HRP.Position + Camera.CFrame.LookVector) * (UIS:GetFocusedTextBox() and cf or CFrame.new((UIS:IsKeyDown(Keys.D) and Settings.cframeflyspeed) or (UIS:IsKeyDown(Keys.A) and -Settings.cframeflyspeed) or 0, (UIS:IsKeyDown(Keys.E) and Settings.cframeflyspeed / 2) or (UIS:IsKeyDown(Keys.Q) and -Settings.cframeflyspeed / 2) or 0, (UIS:IsKeyDown(Keys.S) and Settings.cframeflyspeed) or (UIS:IsKeyDown(Keys.W) and -Settings.cframeflyspeed) or 0))
		for _, v in ipairs(Cache) do
			v:Enable()
		end
	end)
end)

newCmd("cframeflyspeed", {"cflyspeed"}, "cframeflyspeed / cflyspeed [num]", "Sets CFrame Fly Speed", function(args, speaker)
	if args[1] and isNumber(args[1]) then
		Settings.cframeflyspeed = tonumber(args[1])
		updatesaves()
	end
end)

newCmd("uncframefly", {"uncfly"}, "uncframefly / uncfly", "Disables CFrame Fly", function(args, speaker)
	if CflyCon then
		CflyCon:Disconnect()
	end
end)

newCmd("gyrofly", {"gfly"}, "gyrofly / gfly [speed]", "Make your Character Fly Using Body Gyros", function(args, speaker)
	if args[1] and isNumber(args[1]) then
		Settings.gyroflyspeed = tonumber(args[1])
		updatesaves()
	end
	for i, v in next, getRoot(speaker.Character):GetChildren() do
        if v:IsA("BodyPosition") or v:IsA("BodyGyro") then
            v:Destroy()
        end
    end
    local BodyPos = Instance.new("BodyPosition")
    local BodyGyro = Instance.new("BodyGyro")
    Prote.ProtectInstance(BodyPos)
    Prote.ProtectInstance(BodyGyro)
    BodyPos.Parent = getRoot(speaker.Character)
    BodyGyro.Parent = getRoot(speaker.Character)
    BodyGyro.maxTorque = Vector3.new(1, 1, 1) * 9e9
    BodyGyro.CFrame = getRoot(speaker.Character).CFrame
    BodyPos.maxForce = Vector3.new(1, 1, 1) * math.huge
    local Human = speaker.Character and speaker.Character:FindFirstChildWhichIsA("Humanoid")
    Prote.SpoofProperty(Human, "PlatformStand")
    Human.PlatformStand = true
    coroutine.wrap(function()
        BodyPos.Position = getRoot(speaker.Character).Position
        while wait() do
            local NewPos = (BodyGyro.CFrame - (BodyGyro.CFrame).Position) + BodyPos.Position
            local CoordinateFrame = workspace.CurrentCamera.CoordinateFrame
            if Keys["W"] then
                NewPos = NewPos + CoordinateFrame.lookVector * Settings.gyroflyspeed
                BodyPos.Position = (getRoot(speaker.Character).CFrame * CFrame.new(0, 0, -Settings.gyroflyspeed)).Position
                BodyGyro.CFrame = CoordinateFrame * CFrame.Angles(-math.rad(Settings.gyroflyspeed * 15), 0, 0)
            end
            if Keys["A"] then
                NewPos = NewPos * CFrame.new(-Settings.gyroflyspeed, 0, 0)
            end
            if Keys["S"] then
                NewPos = NewPos - CoordinateFrame.lookVector * Settings.gyroflyspeed
                BodyPos.Position = (getRoot(speaker.Character).CFrame * CFrame.new(0, 0, Settings.gyroflyspeed)).Position
                BodyGyro.CFrame = CoordinateFrame * CFrame.Angles(-math.rad(Settings.gyroflyspeed * 15), 0, 0)
            end
            if Keys["D"] then
                NewPos = NewPos * CFrame.new(Settings.gyroflyspeed, 0, 0)
            end
            BodyPos.Position = NewPos.Position
            BodyGyro.CFrame = CoordinateFrame
        end
        Human.PlatformStand = false
    end)()
    GYROFLYING = true
    notify("Gyro Fly", "Enabled")
end)

newCmd("ungyrofly", {"ungfly"}, "ungyrofly / ungfly", "Disables Gyro Fly", function(args, speaker)
	local Human = speaker.Character and speaker.Character:FindFirstChildWhichIsA("Humanoid")
	for i,v in next, getRoot(speaker.Character):GetChildren() do
		if v:IsA("BodyPosition") or v:IsA("BodyGyro") then
			v:Destroy()
		end
	end
	Human.PlatformStand = false
	GYROFLYING = false
	if args[1] and args[1] == "nonotify" then return end
	notify("Gyro Fly", "Disabled")
end)

newCmd("gyroflyspeed", {"gflyspeed"}, "gyroflyspeed / gflyspeed [num]", "Sets Gyro Fly Speed", function(args, speaker)
	local speed = args[1] or 3
	if args[1] and isNumber(args[1]) then
		Settings.gyroflyspeed = tonumber(speed)
		updatesaves()
	end
end)

newCmd("togglefly", {}, "togglefly", "Toggle Fly", function(args, speaker)
	if FLYING == true then
		NOFLY()
	elseif FLYING == false then
		sFLY()
	end
end)

newCmd("togglegyrofly", {"togglegfly"}, "togglegyrofly / togglegfly", "Toggle Gyro Fly", function(args, speaker)
	if GYROFLYING == true then
		execCmd("ungyrofly")
	elseif GYROFLYING == false then
		execCmd("gyrofly")
	end
end)

newCmd("anchor", {}, "anchor", "Anchor your RootPart", function(args, speaker)
	if speaker and speaker.Character then
		for i,v in pairs(speaker.Character:GetChildren()) do
			if v:IsA("BasePart") then
				Prote.SpoofProperty(v, "Anchored")
				v.Anchored = true
			end
		end
	end
end)

newCmd("unanchor", {}, "unanchor", "Makes your Player Movable Again", function(args, speaker)
	if speaker and speaker.Character then
		for i,v in pairs(speaker.Character:GetChildren()) do
			if v:IsA("BasePart") then
				Prote.SpoofProperty(v, "Anchored")
				v.Anchored = false
			end
		end
	end
end)

newCmd("reset", {}, "reset", "Reset your Character", function(args, speaker)
	if not speaker then return notify("Reset", "Missing LocalPlayer") end
	if not speaker.Character then return notify("Reset", "Missing Character") end
	speaker.Character:BreakJoints()
end)

newCmd("reset2", {}, "reset2", "Use a Set Humanoid Method to reset your Character", function(args, speaker)
	if not speaker then return notify("Reset", "Missing LocalPlayer") end
	if not speaker.Character then return notify("Reset", "Missing Character") end
	local Human = speaker.Character:FindFirstChildWhichIsA("Humanoid")
	if not Human then return notify("Reset", "Missing Humanoid") end
	Prote.SpoofProperty(Human, "Health")
	Prote.SpoofProperty(Human, "MaxHealth")
	Human.Health = 0
	Human.MaxHealth = 0
end)

newCmd("notify", {}, "notify [title] [desc] [time]", "Run a Custom Notification", function(args, speaker)
	if args[3] ~= nil then
		notify(args[1], args[2], args[3])
	else
		notify(args[1], args[2])
	end
end)

newCmd("kill", {}, "kill [plr]", "Try to Kill a User", function(args, speaker)
	local users = getPlayer(args[1], speaker)
	for i,Target in pairs(users) do
		if Target and Target.Character then
			kill(speaker, Target)
		end
	end
end)

newCmd("fastkill", {}, "fastkill [plr]", "Try to Kill a User Fast", function(args, speaker)
	local users = getPlayer(args[1], speaker)
	for i,Target in pairs(users) do
		if Target and Target.Character then
			kill(speaker, Target, true)
		end
	end
end)

newCmd("clientkill", {"ckill"}, "clientkill / ckill [plr]", "Kill a User on your Client", function(args, speaker)
	local users = getPlayer(args[1], speaker)
	for i,Target in pairs(users) do
		if Target and Target.Character and findhum(Target.Character) then
			gethum(Target.Character).Health = 0
		end
	end
end)

newCmd("bring", {}, "bring [plr]", "Try to Bring a User", function(args, speaker)
	local users = getPlayer(args[1], speaker)
	for i,Target in pairs(users) do
		if Target and Target.Character then
			bring(speaker, Target)
		end
	end
end)

newCmd("fastbring", {}, "fastbring [plr]", "Try to Bring a User Fast", function(args, speaker)
	local users = getPlayer(args[1], speaker)
	for i,Target in pairs(users) do
		if Target and Target.Character then
			bring(speaker, Target, true)
		end
	end
end)

newCmd("clientbring", {"cbring"}, "clientbring / cbring [plr]", "Bring a User on your Client", function(args, speaker)
	local users = getPlayer(args[1], speaker)
	for i,v in pairs(users)do
		if Players[v].Character ~= nil then
			if Players[v].Character:FindFirstChild("Humanoid") then
				Players[v].Character:FindFirstChildOfClass('Humanoid').Sit = false
			end
			wait()
			getRoot(Players[v].Character).CFrame = getRoot(speaker.Character).CFrame + Vector3.new(3,1,0)
		end
	end
end)

newCmd("respawn", {}, "respawn", "Respawn your Character", function(args, speaker)
	respawn(speaker)
end)

newCmd("refresh", {"re"}, "refresh / re", "Respawn in the Same Spot", function(args, speaker)
	refresh(speaker)
end)

newCmd("split", {}, "split", "Split Your Character in Half", function(args, speaker)
	if r15(speaker) then
		speaker.Character.UpperTorso.Waist:Destroy()
	else
		notify("R15 Required", "Requires R15 Rig Type")
	end
end)

newCmd("float", {}, "float", "Walk On An Invisible Part to Look Like You Are Floating", function(args, speaker)
	Floating = true
	local pchar = speaker.Character
	local Human = speaker.Character and speaker.Character:FindFirstChildWhichIsA("Humanoid")
	if pchar and not pchar:FindFirstChild(floatName) then
		spawn(function()
			local Float = Instance.new("Part")
			Prote.ProtectInstance(Float)
			Float.Name = floatName
			Float.Parent = pchar
			Float.Transparency = 1
			Float.Size = Vector3.new(6, 1, 6)
			Float.Anchored = true
			local FloatValue = -3.5
			if r15(speaker) then FloatValue = -3.65 end
			Float.CFrame = getRoot(pchar).CFrame * CFrame.new(0, FloatValue, 0)
			notify("Float", "Float Enabled (Q = Down & E = Up)")
			qUp = DAMouse.KeyUp:Connect(function(KEY)
				if KEY == "q" then
					FloatValue = FloatValue + 0.5
				end
			end)
			eUp = DAMouse.KeyUp:Connect(function(KEY)
				if KEY == "e" then
					FloatValue = FloatValue - 0.5
				end
			end)
			qDown = DAMouse.KeyDown:Connect(function(KEY)
				if KEY == "q" then
					FloatValue = FloatValue - 0.5
				end
			end)
			eDown = DAMouse.KeyDown:Connect(function(KEY)
				if KEY == "e" then
					FloatValue = FloatValue + 0.5
				end
			end)
			floatDied = speaker.Character:FindFirstChildWhichIsA("Humanoid").Died:Connect(function()
				FloatingFunc:Disconnect()
				Float:Destroy()
				qUp:Disconnect()
				eUp:Disconnect()
				qDown:Disconnect()
				eDown:Disconnect()
				floatDied:Disconnect()
			end)
			local FloatPadLoop = function()
				if pchar:FindFirstChild(floatName) and getRoot(pchar) then
					Float.CFrame = getRoot(pchar).CFrame * CFrame.new(0, FloatValue, 0)
				else
					FloatingFunc:Disconnect()
					Float:Destroy()
					qUp:Disconnect()
					eUp:Disconnect()
					qDown:Disconnect()
					eDown:Disconnect()
					floatDied:Disconnect()
				end
			end			
			FloatingFunc = game:GetService("RunService").Heartbeat:Connect(FloatPadLoop)
		end)
	end
end)

newCmd("unfloat", {}, "unfloat", "Disable Floating", function(args, speaker)
	Floating = false
	local pchar = speaker.Character
	notify("Float", "Float Disabled")
	if pchar:FindFirstChild(floatName) then
		pchar:FindFirstChild(floatName):Destroy()
	end
	if floatDied then
		FloatingFunc:Disconnect()
		qUp:Disconnect()
		eUp:Disconnect()
		qDown:Disconnect()
		eDown:Disconnect()
		floatDied:Disconnect()
	end
end)

newCmd("sit", {}, "sit", "Make your Character Sit", function(args, speaker)
	if speaker and speaker.Character and findhum() then
		local Human = gethum()
		Prote.SpoofProperty(Human, "Sit", false)
		Human.Sit = true
	end
end)

newCmd("stun", {}, "stun", "Enable Platform Stand", function(args, speaker)
	if speaker and speaker.Character and findhum() then
		local Human = gethum()
		Prote.SpoofProperty(Human, "PlatformStand", false)
		Human.PlatformStand = true
	end
end)

newCmd("unstun", {}, "unstun", "Disable Platform Stand", function(args, speaker)
	if speaker and speaker.Character and findhum() then
		local Human = gethum()
		Prote.SpoofProperty(Human, "PlatformStand", false)
		Human.PlatformStand = false
	end
end)

newCmd("jump", {}, "jump", "Make your Character Jump", function(args, speaker)
	if speaker and speaker.Character and findhum() then
		local Human = gethum()
		Prote.SpoofProperty(Human, "Jump", false)
		Human.Jump = true
	end
end)

newCmd("togglefullscreen", {"togglefs"}, "togglefullscreen / togglefs", "Toggles Fullscreen", function(args, speaker)
	return game:GetService("GuiService"):ToggleFullscreen()
end)

newCmd("screenshot", {}, "screenshot", "Take a Screenshot", function(args, speaker)
	return game:GetService("CoreGui"):TakeScreenshot()
end)

newCmd("addplugin", {}, "addplugin [string]", "Add a Plugin", function(args, speaker)
	addPlugin(getstring(1))
	updatesaves()
end)

newCmd("removeplugin", {}, "removeplugin [string]", "Remove a Plugin", function(args, speaker)
	deletePlugin(getstring(1))
	updatesaves()
end)

newCmd("reloadplugin", {}, "reloadplugin [string]", "Reload a Plugin", function(args, speaker)
	local pluginName = getstring(1)
	deletePlugin(pluginName)
	wait(1)
	addPlugin(pluginName)
end)

newCmd("pluginlist", {}, "pluginlist", "List all your plugins that are enabled", function(args, speaker)
	if not table.isempty(Settings.PluginsTable) then
		notify("Plugin List: " .. #Settings.PluginsTable, string.join(", ", Settings.PluginsTable))
    else
        	notify("Plugin Error", "Zero Plugins Enabled")
	end
end)

newCmd("grabknife", {"knife"}, "grabknife / knife", "Load Grab Knife (Works on Players/Characters you have ownership over)", function(args, speaker)
	notify("", "Loaded Grab Knife", 2)
	Import("knif.lua")
end)

newCmd("clientantikick", {"antikick"}, "clientantikick / antikick (Client)", "Prevents LocalScripts From Kicking You", function(args, speaker)
	local getrawmt = (debug and debug.getmetatable) or getrawmetatable
	local setReadOnly = setreadonly or (make_writeable and function(table, readonly) if readonly then make_readonly(table) else make_writeable(table) end end)
	local getnamecall = getnamecallmethod or get_namecall_method
	local mt = getrawmt(game)
	local old = mt.__namecall
	local protect = newcclosure or protect_function
	local hookfunc = hookfunction or detour_function

	if not protect then
		notify("Incompatible Exploit", "Missing newcclosure or protect_function")
		protect = function(f)
			return f
		end
	end

	setReadOnly(mt, false)
	
	mt.__namecall = protect(function(self, ...)
		local method = getnamecall()
		if method == "Kick" then
			wait(9e9)
			return
		end
		return old(self, ...)
	end)
	
	hookfunc(Players.LocalPlayer.Kick, protect(function() wait(9e9) end))

	notify("Client Anti-Kick", "Enabled, only affects locally.")
end)

newCmd("antiafk", {"antiidle"}, "antiafk / antiidle", "Don't Get Kicked for Being AFK", function(args, speaker)
	local getcons = getconnections or get_signal_cons
	if getcons then
		for i,v in pairs(getcons(Players.LocalPlayer.Idled)) do
			if v["Disable"] then
				v["Disable"](v)
			elseif v["Disconnect"] then
				v["Disconnect"](v)
			end
		end
		notify("Anti Idle", "Enabled")
	else
		notify("Incompatible Exploit", "Missing getconnections")
	end
end)

newCmd("btools", {}, "btools", "Building Tools", function(args, speaker)
	if findbp() then
		local Backpack = getbp()
		for i = 1, 4 do
			local Bin = Instance.new("HopperBin")
			Prote.ProtectInstance(Bin)
			Bin.BinType = i
			Bin.Parent = Backpack
		end
	else
		notify("Command Error", "Missing Backpack")
	end
end)

newCmd("f3x", {"fex"}, "f3x / fex", "Building Tools", function(args, speaker)
	loadstring(game:GetObjects("rbxassetid://4698064966")[1].Source)()
end)

newCmd("console", {}, "console", "Open the Old Roblox Console", function(args, speaker)
	notify("Loading", "Hold on a sec")
	local _, str = pcall(function()
		return game:HttpGetAsync("https://raw.githubusercontent.com/daximul/who/main/a/test/what/others/rbx_console.lua", true)
	end)
	local s, e = loadstring(str)
	if typeof(s) ~= "function" then
		return
	end
	local success, message = pcall(s)
	if (not success) then
		if printconsole then
			printconsole(message)
		elseif printoutput then
			printoutput(message)
		end
	end
	wait(1)
	notify("Console", "Press F9 to Open the Console")
end)

newCmd("explorer", {"dex"}, "explorer / dex", "Load a Game Explorer by Moon", function(args, speaker)
	if (not is_sirhurt_closure) and syn then
		notify("Loading", "Hold on a sec")
		wait(0.2)
		local Dex = game:GetObjects("rbxassetid://3567096419")[1]
		ParentGui(Dex)
		local Load = function(Obj, Url)
			local GiveOwnGlobals = function(Func, Script)
				local Fenv = {}
				local RealFenv = {script = Script}
				local FenvMt = {}
				FenvMt.__index = function(a,b)
					if RealFenv[b] == nil then
						return getfenv()[b]
					else
						return RealFenv[b]
					end
				end
				FenvMt.__newindex = function(a, b, c)
					if RealFenv[b] == nil then
						getfenv()[b] = c
					else
						RealFenv[b] = c
					end
				end
				setmetatable(Fenv, FenvMt)
				setfenv(Func, Fenv)
				return Func
			end
			local LoadScripts = function(Script)
				if Script.ClassName == "Script" or Script.ClassName == "LocalScript" then
					spawn(function()
						GiveOwnGlobals(loadstring(Script.Source, "=" .. Script:GetFullName()), Script)()
					end)
				end
				for i,v in pairs(Script:GetChildren()) do
					LoadScripts(v)
				end
			end
			LoadScripts(Obj)
		end
		Load(Dex)
	elseif is_sirhurt_closure and syn then
		notify("Loading", "Hold on a sec")
		wait(0.2)
		Import("sirh_dex.lua")
	else
		notify("Loading", "Hold on a sec")
		wait(0.2)
		loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/Patch-Shack/newLoad/master/dexv2.lua"))();
	end
end)

newCmd("remotespy", {"rspy"}, "remotespy / rspy", "Load a Remote Spy (SimpleSpy)", function(args, speaker)
	notify("Loading", "Hold on a sec", 2)
	Import("simple_spy.lua")
end)

newCmd("audiologger", {}, "audiologger", "Audio Logger by Edge", function(args, speaker)
	notify("Loading", "Hold on a sec", 2)
	loadstring(game:HttpGetAsync(("https://pastebin.com/raw/GmbrsEjM")))();
end)

newCmd("vr", {}, "vr", "Load the CLOVR VR Script by Abacaxl", function(args, speaker)
	notify("", "Loading CLOVR . . .", 2)
	loadstring(game:HttpGet('https://ghostbin.co/paste/yb288/raw'))()
end)

newCmd("jobid", {}, "jobid", "Copy the Server's JobId, this can be put in console on Google to join someone's exact server", function(args, speaker)
	local jobId = ('Roblox.GameLauncher.joinGameInstance(' .. game.PlaceId .. ', "' .. game.JobId ..'")')
	toClipboard(jobId)
end)

newCmd("safechat", {}, "safechat", "Enable Safechat", function(args, speaker)
	speaker:SetSuperSafeChat(true)
end)

newCmd("nosafechat", {}, "nosafechat", "Disable Safechat", function(args, speaker)
	speaker:SetSuperSafeChat(false)
end)

newCmd("creeper", {}, "creeper", "Become a Creeper", function(args, speaker)
	if r15(speaker) then
		speaker.Character.Head:FindFirstChildWhichIsA("SpecialMesh"):Destroy()
		speaker.Character.LeftUpperArm:Destroy()
		speaker.Character.RightUpperArm:Destroy()
		speaker.Character:FindFirstChildWhichIsA("Humanoid"):RemoveAccessories()
	else
		speaker.Character.Head:FindFirstChildWhichIsA("SpecialMesh"):Destroy()
		speaker.Character["Left Arm"]:Destroy()
		speaker.Character["Right Arm"]:Destroy()
		speaker.Character:FindFirstChildWhichIsA("Humanoid"):RemoveAccessories()
	end
end)

newCmd("reach", {}, "reach [number]", "Put reach on the currently equipped tool/item", function(args, speaker)
	execCmd("unreach")
	wait()
	for i,v in pairs(speaker.Character:GetDescendants()) do
		if v:IsA("Tool") then
			if args[1] then
				currentToolSize = v.Handle.Size
				currentGripPos = v.GripPos
				local a = Instance.new("SelectionBox")
				Prote.ProtectInstance(a)
				a.Name = selectionBoxName
				a.Parent = v.Handle
				a.Adornee = v.Handle
				Prote.SpoofProperty(v.Handle, "Size")
				Prote.SpoofProperty(v.Handle, "Massless")
				v.Handle.Massless = true
				v.Handle.Size = Vector3.new(0.5, 0.5, args[1])
				v.GripPos = Vector3.new(0, 0, 0)
				gethum():UnequipTools()
			else
				currentToolSize = v.Handle.Size
				currentGripPos = v.GripPos
				local a = Instance.new("SelectionBox")
				Prote.ProtectInstance(a)
				a.Name = selectionBoxName
				a.Parent = v.Handle
				a.Adornee = v.Handle
				Prote.SpoofProperty(v.Handle, "Size")
				Prote.SpoofProperty(v.Handle, "Massless")
				v.Handle.Massless = true
				v.Handle.Size = Vector3.new(0.5, 0.5, 60)
				v.GripPos = Vector3.new(0, 0, 0)
				gethum():UnequipTools()
			end
		end
	end
end)

newCmd("unreach", {"noreach"}, "unreach / noreach", "Disable Reach", function(args, speaker)
	for i,v in pairs(speaker.Character:GetDescendants()) do
		if v:IsA("Tool") then
			v.Handle.Size = currentToolSize
			v.GripPos = currentGripPos
			if v.Handle:FindFirstChild(selectionBoxName) then
				v.Handle[selectionBoxName]:Destroy()
			end
		end
	end
end)

newCmd("fov", {}, "fov", "Change your Field of View", function(args, speaker)
	local FOV = 0
	if args[1] then
		FOV = tonumber(args[1])
	else
		FOV = origsettings.Camera.Fov or 70
	end
	Prote.SpoofProperty(workspace.CurrentCamera, "FieldOfView")
	workspace.CurrentCamera.FieldOfView = FOV
end)

newCmd("invisible", {"invis"}, "invisible / invis", "Become invisible to other players", function(args, speaker)
	if invisRunning then return end
	invisRunning = true
	local Player = game:GetService("Players").LocalPlayer
	repeat wait(.1) until Player.Character
	local Character = Player.Character
	Character.Archivable = true
	local IsInvis = false
	local IsRunning = true
	local InvisibleCharacter = Character:Clone()
	InvisibleCharacter.Parent = game:GetService("Lighting")
	local Void = workspace.FallenPartsDestroyHeight
	InvisibleCharacter.Name = ""
	local CF
	
	local invisFix = game:GetService("RunService").Stepped:Connect(function()
	    pcall(function()
	        local IsInteger
	        if tostring(Void):find("-") then
	            IsInteger = true
	        else
	            IsInteger = false
	        end
	        local Pos = Player.Character.HumanoidRootPart.Position
	        local Pos_String = tostring(Pos)
	        local Pos_Seperate = Pos_String:split(", ")
	        local X = tonumber(Pos_Seperate[1])
	        local Y = tonumber(Pos_Seperate[2])
	        local Z = tonumber(Pos_Seperate[3])
	        if IsInteger == true then
	            if Y <= Void then
	                Respawn()
	            end
	        elseif IsInteger == false then
	            if Y >= Void then
	                Respawn()
	            end
	        end
	    end)
	end)
	
	for i,v in pairs(InvisibleCharacter:GetDescendants())do
	    if v:IsA("BasePart") then
	        if v.Name == "HumanoidRootPart" then
	        	Prote.SpoofProperty(v, "HumanoidRootPart")
	            v.Transparency = 1
	        else
	        	Prote.SpoofProperty(v, "HumanoidRootPart")
	            v.Transparency = 0.5
	        end
	    end
	end
	
	Respawn = function()
	    IsRunning = false
	    if IsInvis == true then
	        pcall(function()
	            Player.Character = Character
	            wait()
	            Character.Parent = workspace
	            Character:FindFirstChildWhichIsA("Humanoid"):Destroy()
	            IsInvis = false
	            InvisibleCharacter.Parent = nil
				invisRunning = false
	        end)
	    elseif IsInvis == false then
	        pcall(function()
	            Player.Character = Character
	            wait()
	            Character.Parent = workspace
	            Character:FindFirstChildWhichIsA("Humanoid"):Destroy()
	            TurnVisible()
	        end)
	    end
	end
	
	local invisDied
	invisDied = InvisibleCharacter:FindFirstChildOfClass("Humanoid").Died:Connect(function()
	    Respawn()
		invisDied:Disconnect()
	end)
	
	if IsInvis == true then return end
	IsInvis = true
	CF = workspace.CurrentCamera.CFrame
	local CF_1 = Player.Character.HumanoidRootPart.CFrame
	Character:MoveTo(Vector3.new(0, math.pi * 1000000, 0))
	workspace.CurrentCamera.CameraType = Enum.CameraType.Scriptable
	wait(.2)
	workspace.CurrentCamera.CameraType = Enum.CameraType.Custom
	InvisibleCharacter = InvisibleCharacter
	Character.Parent = game:GetService("Lighting")
	InvisibleCharacter.Parent = workspace
	InvisibleCharacter.HumanoidRootPart.CFrame = CF_1
	Player.Character = InvisibleCharacter
	fixcam(Player)
	SetLocalAnimate(Player.Character, true)
	SetLocalAnimate(Player.Character, false)
	
	TurnVisible = function()
	    if IsInvis == false then return end
		invisFix:Disconnect()
		invisDied:Disconnect()
	    CF = workspace.CurrentCamera.CFrame
	    Character = Character
	    local CF_1 = Player.Character.HumanoidRootPart.CFrame
	    Character.HumanoidRootPart.CFrame = CF_1
	    InvisibleCharacter:Destroy()
	    Player.Character = Character
	    Character.Parent = workspace
	    IsInvis = false
	    SetLocalAnimate(Player.Character, true)
	    SetLocalAnimate(Player.Character, false)
		invisDied = Character:FindFirstChildOfClass("Humanoid").Died:Connect(function()
		    Respawn()
			invisDied:Disconnect()
		end)
		invisRunning = false
	end
	notify("Invisibility", "You are invisible to players!")
end)

newCmd("tinvisible", {"tinvis"}, "tinvisible / tinvis", "Invisibility but no godmode but some tools work", function(args, speaker)
	Import("tinv.lua")
	notify("T Invis", "You are now Invisible")
end)

newCmd("invisible2", {"invis2"}, "invisible2 / invis2", "Second Version of Invisibility", function(args, speaker)
	local OldPos = getRoot(Players.LocalPlayer.Character).CFrame
	getRoot(Players.LocalPlayer.Character).CFrame = CFrame.new(9e9, 9e9, 9e9)
	local Clone = getRoot(Players.LocalPlayer.Character):Clone()
	wait(.2)
	getRoot(Players.LocalPlayer.Character):Destroy()
	Clone.CFrame = OldPos
	Clone.Parent = Players.LocalPlayer.Character
	notify("Invisibility 2", "You are now Invisible")
end)

newCmd("visible", {"vis"}, "visible / vis", "Become Visible", function(args, speaker)
	TurnVisible()
end)

newCmd("gotocamera", {"gotocam"}, "gotocamera / gotocam", "Go to the Workspace Camera", function(args, speaker)
	getRoot(speaker.Character).CFrame = workspace.Camera.CFrame
end)

newCmd("spectate", {"spec"}, "spectate / spec [plr]", "Spectate a Player", function(args, speaker)
	local users = getPlayer(args[1], speaker)
	for i,v in pairs(users) do
		if viewDied then
			viewDied:Disconnect()
			viewChanged:Disconnect()
		end
		if not Players[v].Character then return notify("Spectate", "Target Missing Character") end
		if not findhum(Players[v].Character) then return notify("Spectate", "Target Missing Humanoid") end
		viewing = Players[v]
		local targethum = gethum(Players[v].Character)
		workspace.Camera.CameraSubject = targethum
		notify("Spectating", Players[v].Name)
		local viewDiedFunc = function()
			repeat wait() until Players[v].Character ~= nil and getRoot(Players[v].Character)
			workspace.Camera.CameraSubject = targethum
		end
		viewDied = Players[v].CharacterAdded:Connect(viewDiedFunc)
		local viewChangedFunc = function()
			workspace.Camera.CameraSubject = targethum
		end
		viewChanged = workspace.Camera:GetPropertyChangedSignal("CameraSubject"):Connect(viewChangedFunc)
	end
end)

newCmd("unspectate", {"unspec"}, "unspectate / unspec [plr]", "Stop viewing a Player", function(args, speaker)
	if viewing ~= nil then
		viewing = nil
	end
	if viewDied then
		viewDied:Disconnect()
		viewChanged:Disconnect()
	end
	if findhum() then
		workspace.Camera.CameraSubject = gethum()
		if tostring(args[1]) ~= "nonotify" then
			notify("Spectate", "Disabled")
		end
	else
		if tostring(args[1]) ~= "nonotify" then
			notify("Un-Spectate", "Missing Humanoid")
		end
	end
end)

newCmd("fixcam", {}, "fixcam", "Fix/Restore your Camera", function(args, speaker)
	execCmd("unspectate")
	workspace.CurrentCamera:remove()
	wait(0.1)
	repeat wait() until speaker.Character ~= nil
	Prote.SpoofProperty(workspace.CurrentCamera, "CameraType")
	workspace.CurrentCamera.CameraSubject = speaker.Character:FindFirstChildWhichIsA("Humanoid")
	workspace.CurrentCamera.CameraType = "Custom"
	Prote.SpoofProperty(speaker, "CameraMinZoomDistance")
	Prote.SpoofProperty(speaker, "CameraMaxZoomDistance")
	Prote.SpoofProperty(speaker, "CameraMode")
	speaker.CameraMinZoomDistance = 0.5
	speaker.CameraMaxZoomDistance = 400
	speaker.CameraMode = "Classic"
	if speaker.Character:FindFirstChild("Head") then
		Prote.SpoofProperty(speaker.Character.Head, "Anchored")
		speaker.Character.Head.Anchored = false
	end
end)

newCmd("esp", {}, "esp", "Use ESP on Players", function(args, speaker)
	ESPenabled = true
	for i,v in pairs(Players:GetChildren()) do
		if v.ClassName == "Player" and v.Name ~= speaker.Name then
			ESP(v)
		end
	end
end)

newCmd("unesp", {}, "unesp", "Stop Using ESP on Players", function(args, speaker)
	ESPenabled = false
	for i,c in pairs(CoreGui:GetChildren()) do
		if string.sub(c.Name, -4) == "_ESP" then
			c:Destroy()
		end
	end
end)

newCmd("locate", {}, "locate [plr]", "View a single player and their status", function(args, speaker)
	local players = getPlayer(args[1], speaker)
	for i,v in pairs(players) do
		Locate(Players[v])
	end
end)

newCmd("unlocate", {}, "unlocate [plr]", "Removes Locate", function(args, speaker)
	local players = getPlayer(args[1], speaker)
	if args[1] then
		for i,v in pairs(players) do
			for i,c in pairs(CoreGui:GetChildren()) do
				if c.Name == Players[v].Name .. "_LC" then
					c:Destroy()
				end
			end
		end
	else
		for i,c in pairs(CoreGui:GetChildren()) do
			if string.sub(c.Name, -3) == "_LC" then
				c:Destroy()
			end
		end
	end
end)

newCmd("xray", {}, "xray", "Make all parts in Workspace transparent", function(args, speaker)
	xrayobjects(true)
end)

newCmd("unxray", {}, "unxray", "Restore transparency", function(args, speaker)
	xrayobjects(false)
end)

newCmd("enableshiftlock", {"enablesl"}, "enableshiftlock / enablesl", "Enable Shiftlock", function(args, speaker)
	Prote.SpoofProperty(speaker, "DevEnableMouseLock")
	speaker.DevEnableMouseLock = true
	notify("Shiftlock", "Shift Lock is now Available")
end)

newCmd("firstp", {}, "firstp", "First Person", function(args, speaker)
	Prote.SpoofProperty(speaker.CameraMode, "LockFirstPerson")
	speaker.CameraMode = "LockFirstPerson"
end)

newCmd("thirdp", {}, "thirdp", "Third Person", function(args, speaker)
	Prote.SpoofProperty(speaker.CameraMode, "Classic")
	speaker.CameraMode = "Classic"
end)

newCmd("showprompts", {}, "showprompts", "Continue Receiving Purchase Prompts", function(args, speaker)
	CoreGui.PurchasePromptApp.Visible = true
end)

newCmd("noprompts", {}, "noprompts", "Stop Receiving Purchase Prompts", function(args, speaker)
	CoreGui.PurchasePromptApp.Visible = false
end)

newCmd("deletehats", {"nohats"}, "deletehats / nohats", "Delete your Hats", function(args, speaker)
	if Players.LocalPlayer and Players.LocalPlayer.Character and findhum() then
		gethum():RemoveAccessories()
	end
end)

newCmd("breakloops", {"break"}, "breakloops / break", "Stops every current command loop (inf^reset)", function(args, speaker)
	lastBreakTime = tick()
end)

newCmd("grabtools", {}, "grabtools", "Copies Tools from ReplicatedStorage and Lighting", function(args, speaker)
	local copy = function(instance)
		for i,c in pairs(instance:GetChildren())do
			if c:IsA("Tool") or c:IsA("HopperBin") then
				c:Clone().Parent = speaker:FindFirstChildOfClass("Backpack")
			end
			copy(c)
		end
	end
	copy(game:GetService("Lighting"))
	local copy = function(instance)
		for i,c in pairs(instance:GetChildren())do
			if c:IsA("Tool") or c:IsA("HopperBin") then
				c:Clone().Parent = speaker:FindFirstChildOfClass("Backpack")
			end
			copy(c)
		end
	end
	copy(game:GetService("ReplicatedStorage"))
	notify("Tools", "Copied Tools from ReplicatedStorage and Lighting")
end)

newCmd("removetools", {}, "removetools", "Removes Tools from Character and Backpack", function(args, speaker)
	for i,v in pairs(speaker:FindFirstChildOfClass("Backpack"):GetDescendants()) do
		if v:IsA("Tool") or v:IsA("HopperBin") then
			v:Destroy()
		end
	end
	for i,v in pairs(speaker.Character:GetDescendants()) do
		if v:IsA("Tool") or v:IsA("HopperBin") then
			v:Destroy()
		end
	end
	notify("Tools", "Removed All Tools from Character and Backpack")
end)

newCmd("copytools", {}, "copytools [plr] (Client)", "Copies a Player's Tools", function(args, speaker)
	local players = getPlayer(args[1], speaker)
	for i,v in pairs(players) do
		spawn(function()
			for i,v in pairs(Players[v]:FindFirstChildOfClass("Backpack"):GetChildren()) do
				if v:IsA("Tool") or v:IsA("HopperBin") then
					v:Clone().Parent = speaker:FindFirstChildOfClass("Backpack")
				end
			end
		end)
		notify("Tools", "Copied Tools from " .. Players[v].Name)
	end
end)

newCmd("equiptools", {}, "equiptools", "Equips every Tool in your Inventory", function(args, speaker)
	for i,v in pairs(speaker:FindFirstChildOfClass("Backpack"):GetChildren()) do
		if v:IsA("Tool") or v:IsA("HopperBin") then
			v.Parent = speaker.Character
		end
	end
end)

newCmd("droptools", {}, "droptools", "Drop your Tools", function(args, speaker)
	for i,v in pairs(Players.LocalPlayer.Backpack:GetChildren()) do
		if v:IsA("Tool") then
			Prote.SpoofProperty(v, "Parent")
			v.Parent = Players.LocalPlayer.Character
		end
	end
	wait()
	for i,v in pairs(Players.LocalPlayer.Character:GetChildren()) do
		if v:IsA("Tool") then
			Prote.SpoofProperty(v, "Parent")
			v.Parent = workspace
		end
	end
end)

newCmd("droppabletools", {}, "droppabletools", "Make Undroppable Tools Droppable", function(args, speaker)
	if speaker and speaker.Character then
		for _,obj in pairs(speaker.Character:GetChildren()) do
			if obj:IsA("Tool") then
				Prote.SpoofProperty(obj, "CanBeDropped")
				obj.CanBeDropped = true
			end
		end
	end
	if speaker and speaker:FindFirstChildOfClass("Backpack") then
		for _,obj in pairs(speaker:FindFirstChildOfClass("Backpack"):GetChildren()) do
			if obj:IsA("Tool") then
				Prote.SpoofProperty(obj, "CanBeDropped")
				obj.CanBeDropped = true
			end
		end
	end
end)

newCmd("copyusername", {"copyname"}, "copyusername / copyname", "Copies a player's full username to your clipboard", function(args, speaker)
	local players = getPlayer(args[1], speaker)
	for i,v in pairs(players) do
		local name = tostring(Players[v].Name)
		toClipboard(name)
		notify("Copied", "Name - " .. name)
	end
end)

newCmd("copyuserid", {"copyid"}, "copyuserid / copyid", "Copies a player's user ID to your clipboard", function(args, speaker)
	local players = getPlayer(args[1], speaker)
	for i,v in pairs(players) do
		local id = tostring(Players[v].UserId)
		toClipboard(id)
		notify("Copied", "ID - " .. id)
	end
end)

newCmd("resetuserid", {}, "resetuserid", "Set your User ID back to normal", function(args, speaker)
	speaker.UserId = origsettings.Player.Id
	notify("Set ID", "Set UserId to original")
end)

newCmd("setcreatorid", {}, "setcreatorid", "Set your User ID to the Creator's User ID", function(args, speaker)
	if game.CreatorType == Enum.CreatorType.User then
		speaker.UserId = game.CreatorId
		notify("Set ID", "Set UserId to " .. game.CreatorId)
	elseif game.CreatorType == Enum.CreatorType.Group then
		local OwnerID = game:GetService("GroupService"):GetGroupInfoAsync(game.CreatorId).Owner.Id
		speaker.UserId = OwnerID
		notify("Set ID", "Set UserId to " .. OwnerID)
	end
end)

newCmd("printposition", {"printpos"}, "printposition / printpos", "Print Current Position", function(args, speaker)
	local curpos = speaker.Character and (getRoot(speaker.Character) or speaker.Character:FindFirstChildWhichIsA("BasePart"))
	curpos = curpos and curpos.Position
	if not curpos then return notify("Position", "Missing Character") end
	curpos = (math.round(curpos.X) .. ", " .. math.round(curpos.Y) .. ", " .. math.round(curpos.Z))
	print("Current Position: " .. curpos)
end)

newCmd("notifyposition", {"notifypos"}, "notifyposition / notifypos", "Notify Current Position", function(args, speaker)
	local curpos = speaker.Character and (getRoot(speaker.Character) or speaker.Character:FindFirstChildWhichIsA("BasePart"))
	curpos = curpos and curpos.Position
	if not curpos then return notify("Position", "Missing Character") end
	curpos = (math.round(curpos.X) .. ", " .. math.round(curpos.Y) .. ", " .. math.round(curpos.Z))
	notify("Current Position", curpos)
end)

newCmd("copyposition", {"copypos"}, "copyposition / copypos", "Copy Current Position to Clipboard", function(args, speaker)
	local curpos = speaker.Character and (getRoot(speaker.Character) or speaker.Character:FindFirstChildWhichIsA("BasePart"))
	curpos = curpos and curpos.Position
	if not curpos then return notify("Position", "Missing Character") end
	curpos = (math.round(curpos.X) .. ", " .. math.round(curpos.Y) .. ", " .. math.round(curpos.Z))
	if toClipboard then toClipboard(curpos) end
end)

newCmd("swim", {}, "swim", "Become fish", function(args, speaker)
	Prote.SpoofProperty(workspace, "Gravity")
	workspace.Gravity = 0
	local swimDied = function()
		workspace.Gravity = 198.2
		swimming = false
	end
	local Human = gethum(speaker.Character)
	Prote.SpoofInstance(Human)
	gravReset = Human.Died:Connect(swimDied)
	Human:SetStateEnabled(Enum.HumanoidStateType.Climbing, false)
	Human:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
	Human:SetStateEnabled(Enum.HumanoidStateType.Flying, false)
	Human:SetStateEnabled(Enum.HumanoidStateType.Freefall, false)
	Human:SetStateEnabled(Enum.HumanoidStateType.GettingUp, false)
	Human:SetStateEnabled(Enum.HumanoidStateType.Jumping, false)
	Human:SetStateEnabled(Enum.HumanoidStateType.Landed, false)
	Human:SetStateEnabled(Enum.HumanoidStateType.Physics, false)
	Human:SetStateEnabled(Enum.HumanoidStateType.PlatformStanding, false)
	Human:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
	Human:SetStateEnabled(Enum.HumanoidStateType.Running, false)
	Human:SetStateEnabled(Enum.HumanoidStateType.RunningNoPhysics, false)
	Human:SetStateEnabled(Enum.HumanoidStateType.Seated, false)
	Human:SetStateEnabled(Enum.HumanoidStateType.StrafingNoPhysics, false)
	Human:SetStateEnabled(Enum.HumanoidStateType.Swimming, false)
	Human:ChangeState(Enum.HumanoidStateType.Swimming)
	swimming = true
end)

newCmd("unswim", {}, "unswim", "Reject fish become human", function(args, speaker)
	Prote.SpoofProperty(workspace, "Gravity")
	workspace.Gravity = 198.2
	swimming = false
	if gravReset then
		gravReset:Disconnect()
	end
	local Human = gethum(speaker.Character)
	Prote.SpoofInstance(Human)
	Human:SetStateEnabled(Enum.HumanoidStateType.Climbing, true)
	Human:SetStateEnabled(Enum.HumanoidStateType.FallingDown, true)
	Human:SetStateEnabled(Enum.HumanoidStateType.Flying, true)
	Human:SetStateEnabled(Enum.HumanoidStateType.Freefall, true)
	Human:SetStateEnabled(Enum.HumanoidStateType.GettingUp, true)
	Human:SetStateEnabled(Enum.HumanoidStateType.Jumping, true)
	Human:SetStateEnabled(Enum.HumanoidStateType.Landed, true)
	Human:SetStateEnabled(Enum.HumanoidStateType.Physics, true)
	Human:SetStateEnabled(Enum.HumanoidStateType.PlatformStanding, true)
	Human:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, true)
	Human:SetStateEnabled(Enum.HumanoidStateType.Running, true)
	Human:SetStateEnabled(Enum.HumanoidStateType.RunningNoPhysics, true)
	Human:SetStateEnabled(Enum.HumanoidStateType.Seated, true)
	Human:SetStateEnabled(Enum.HumanoidStateType.StrafingNoPhysics, true)
	Human:SetStateEnabled(Enum.HumanoidStateType.Swimming, true)
	Human:ChangeState(Enum.HumanoidStateType.RunningNoPhysics)
end)

newCmd("unlockws", {}, "unlockws", "Unlock Workspace", function(args, speaker)
	for i,v in pairs(workspace:GetDescendants()) do
		if v:IsA("BasePart") then
			Prote.SpoofProperty(v, "Locked")
			v.Locked = false
		end
	end
end)

newCmd("saveplace", {}, "saveplace", "Save the Game", function(args, speaker)
	if saveinstance then
		notify("Downloading", "This will take a while")
		if getsynasset then
			saveinstance()
		else
			saveinstance(game)
		end
		notify("Game Saved", "Check Workspace Folder")
	else
		notify("Incompatible Exploit", "Missing saveinstance")
	end
end)

newCmd("nilchar", {}, "nilchar", "Makes your Character's parent Nil", function(args, speaker)
	if speaker and speaker.Character ~= nil then
		Prote.SpoofProperty(speaker.Character, "Parent")
		speaker.Character.Parent = nil
	end
end)

newCmd("unnilchar", {}, "unnilchar", "Makes your Character's parent Workspace", function(args, speaker)
	if speaker and speaker.Character ~= nil then
		Prote.SpoofProperty(speaker.Character, "Parent")
		speaker.Character.Parent = workspace
	end
end)

newCmd("breakvelocity", {}, "breakvelocity", "Break your Velocity", function(args, speaker)
	local BeenASecond, V3 = false, Vector3.new(0, 0, 0)
	delay(1, function()
		BeenASecond = true
	end)
	while not BeenASecond do
		for _, v in ipairs(speaker.Character:GetDescendants()) do
			if v.IsA(v, "BasePart") then
				Prote.SpoofProperty(v, "Velocity")
				Prote.SpoofProperty(v, "RotVelocity")
				v.Velocity, v.RotVelocity = V3, V3
			end
		end
		wait()
	end
end)

newCmd("flashback", {}, "flashback", "Go back to where you last died", function(args, speaker)
	if LastDeathPos ~= nil then
		if findhum(speaker.Character) and gethum(speaker.Character).SeatPart then
			local Human = gethum(speaker.Character)
			Prote.SpoofProperty(Human, "Sit")
			Human.Sit = false
			wait(.1)
		end
		getRoot(speaker.Character).CFrame = LastDeathPos
	end
end)

newCmd("dupetools", {}, "dupetools [number]", "Duplicate Tools in your Inventory", function(args, speaker)
	local LOOP_NUM = tonumber(args[1]) or 1
	local OrigPos = speaker.Character.HumanoidRootPart.Position
	local Tools, TempPos = {}, Vector3.new(math.random(-2e5, 2e5), 2e5, math.random(-2e5, 2e5))
	for i = 1, LOOP_NUM do
		local Human = gethum()
		wait(.1, Human.Parent:MoveTo(TempPos))
		Prote.SpoofProperty(Human.RootPart, "Anchored")
		Human.RootPart.Anchored = speaker:ClearCharacterAppearance(wait(.1)) or true
		local t = GetHandleTools(speaker)
		while #t > 0 do
			for _, v in ipairs(t) do
				coroutine.wrap(function()
					for _ = 1, 25 do
						Prote.SpoofProperty(v, "Parent")
						v.Parent = speaker.Character
						v.Handle.Anchored = true
					end
					for _ = 1, 5 do
						Prote.SpoofProperty(v, "Parent")
						v.Parent = workspace
					end
					table.insert(Tools, v.Handle)
				end)()
			end
			t = GetHandleTools(speaker)
		end
		wait(.1)
		speaker.Character = speaker.Character:Destroy()
		speaker.CharacterAdded:Wait():WaitForChild("Humanoid").Parent:MoveTo(LOOP_NUM == i and OrigPos or TempPos, wait(.1))
		if i == LOOP_NUM or i % 5 == 0 then
			local HRP = speaker.Character.HumanoidRootPart
			if type(firetouchinterest) == "function" then
				for _, v in ipairs(Tools) do
					v.Anchored = not firetouchinterest(v, HRP, 1, firetouchinterest(v, HRP, 0)) and false or false
				end
			else
				for _, v in ipairs(Tools) do
					coroutine.wrap(function()
						local x = v.CanCollide
						Prote.SpoofProperty(v, "CanCollide")
						Prote.SpoofProperty(v, "Anchored")
						v.CanCollide = false
						v.Anchored = false
						for _ = 1, 10 do
							v.CFrame = HRP.CFrame
							wait()
						end
						v.CanCollide = x
					end)()
				end
			end
			wait(.1)
			Tools = {}
		end
		TempPos = TempPos + Vector3.new(10, math.random(-5, 5), 0)
	end
end)

newCmd("commandcount", {}, "commandcount", "Notify the Amount of Commands", function(args, speaker)
	notify("Command Count", #cmds)
end)

newCmd("noclip", {}, "noclip", "Go Through Objects", function(args, speaker)
	CmdClip = false
	wait(0.1)
	local NoclipLoop = function()
		if CmdClip == false and speaker.Character ~= nil then
			for _, child in pairs(speaker.Character:GetDescendants()) do
				if child:IsA("BasePart") and child.CanCollide == true and child.Name ~= floatName then
					Prote.SpoofProperty(child, "CanCollide")
					child.CanCollide = false
				end
			end
		end
	end
	CmdNoclipping = game:GetService("RunService").Stepped:Connect(NoclipLoop)
	if args[1] and args[1] == "nonotify" then return end
	notify("Noclip", "Noclip Enabled")
end)

newCmd("clip", {}, "clip", "Disables Noclip", function(args, speaker)
	if CmdNoclipping then
		CmdNoclipping:Disconnect()
	end
	CmdClip = true
	if args[1] and args[1] == "nonotify" then return end
	notify("Noclip", "Noclip Disabled")
end)

newCmd("lag", {}, "lag", "Make yourself look like you are lagging", function(args, speaker)
	notify("Fake Lag", "Enabled")
	FakeLagging = true
	Prote.SpoofProperty(getRoot(speaker.Character), "Anchored")
	repeat wait()
		getRoot(speaker.Character).Anchored = false
		wait(0.1)
		getRoot(speaker.Character).Anchored = true
		wait(0.1)
	until FakeLagging == false
end)

newCmd("unlag", {}, "unlag", "Stop the fake lag", function(args, speaker)
	FakeLagging = false
	notify("Fake Lag", "Disabled")
	wait(0.3)
	Prote.SpoofProperty(getRoot(speaker.Character), "Anchored")
	getRoot(speaker.Character).Anchored = false
end)

newCmd("spin", {}, "spin [number]", "Spins your character", function(args, speaker)
	local spinSpeed = 20
	if args[1] and isNumber(args[1]) then
		spinSpeed = args[1]
	end
	for i,v in pairs(getRoot(speaker.Character):GetChildren()) do
		if v.Name == spinName then
			v:Destroy()
		end
	end
	local Spin = Instance.new("BodyAngularVelocity")
	Prote.ProtectInstance(Spin)
	Spin.Parent = getRoot(Players.LocalPlayer.Character)
	Spin.Name = spinName
	Spin.MaxTorque = Vector3.new(0, math.huge, 0)
	Spin.AngularVelocity = Vector3.new(0, spinSpeed, 0)
end)

newCmd("unspin", {}, "unspin", "Disables Spin", function(args, speaker)
	for i,v in pairs(getRoot(speaker.Character):GetChildren()) do
		if v.Name == spinName then
			v:Destroy()
		end
	end
end)

newCmd("fling", {}, "fling", "Fling Anyone You Touch", function(args, speaker)
	for _, child in pairs(speaker.Character:GetDescendants()) do
		if child:IsA("BasePart") then
			Prote.SpoofProperty(child, "CustomPhysicalProperties")
			child.CustomPhysicalProperties = PhysicalProperties.new(2, 0.3, 0.5)
		end
	end
	execCmd("noclip nonotify")
	wait(0.1)
	Prote.SpoofProperty(getRoot(speaker.Character), "Velocity")
	Prote.SpoofProperty(getRoot(speaker.Character), "Anchored")
	local bambam = Instance.new("BodyAngularVelocity")
	Prote.ProtectInstance(bambam)
	bambam.Parent = getRoot(speaker.Character)
	bambam.Name = randomString()
	bambam.AngularVelocity = Vector3.new(0, 311111, 0)
	bambam.MaxTorque = Vector3.new(0, 311111, 0)
	bambam.P = math.huge
	local PauseFling = function()
		if findhum() then
			if gethum().FloorMaterial == Enum.Material.Air then
				bambam.AngularVelocity = Vector3.new(0, 0, 0)
			else
				bambam.AngularVelocity = Vector3.new(0, 311111, 0)
			end
		end
	end
	if TouchingFloor then
		TouchingFloor:Disconnect()
	end
	if TouchingFloorReset then
		TouchingFloorReset:Disconnect()
	end
	TouchingFloor = gethum():GetPropertyChangedSignal("FloorMaterial"):Connect(PauseFling)
	cmdflinging = true
	local flingDied = function()
		execCmd("unfling")
	end
	TouchingFloorReset = gethum().Died:Connect(flingDied)
end)

newCmd("unfling", {}, "unfling", "Disables the Fling Command", function(args, speaker)
	execCmd("clip nonotify")
	if TouchingFloor then
		TouchingFloor:Disconnect()
	end
	if TouchingFloorReset then
		TouchingFloorReset:Disconnect()
	end
	cmdflinging = false
	wait(0.1)
	local speakerChar = speaker.Character
	if not speakerChar or not getRoot(speakerChar) then return end
	for i,v in pairs(getRoot(speakerChar):GetChildren()) do
		if v.ClassName == "BodyAngularVelocity" then
			v:Destroy()
		end
	end
	for _, child in pairs(speakerChar:GetDescendants()) do
		if child.ClassName == "Part" or child.ClassName == "MeshPart" then
			Prote.SpoofProperty(child, "CustomPhysicalProperties")
			child.CustomPhysicalProperties = PhysicalProperties.new(0.7, 0.3, 0.5)
		end
	end
end)

newCmd("invisfling", {}, "invisfling", "Enables Invisible Fling", function(args, speaker)
	local ch = speaker.Character
	local prt=Instance.new("Model")
	Prote.ProtectInstance(prt)
	prt.Parent = speaker.Character
	local z1 = Instance.new("Part")
	Prote.ProtectInstance(z1)
	z1.Name="Torso"
	z1.CanCollide = false
	z1.Anchored = true
	local z2 = Instance.new("Part")
	Prote.ProtectInstance(z2)
	z2.Name="Head"
	z2.Parent = prt
	z2.Anchored = true
	z2.CanCollide = false
	local z3 =Instance.new("Humanoid")
	Prote.ProtectInstance(z3)
	z3.Name="Humanoid"
	z3.Parent = prt
	z1.Position = Vector3.new(0,9999,0)
	speaker.Character=prt
	wait(3)
	speaker.Character=ch
	wait(3)
	local Hum = Instance.new("Humanoid")
	Prote.ProtectInstance(Hum)
	z2:Clone()
	Hum.Parent = speaker.Character
	local root =  getRoot(speaker.Character)
	for i,v in pairs(speaker.Character:GetChildren()) do
		if v ~= root and  v.Name ~= "Humanoid" then
			v:Destroy()
		end
	end
	Prote.SpoofProperty(root, "Transparency")
	Prote.SpoofProperty(root, "Color")
	root.Transparency = 0
	root.Color = Color3.new(1, 1, 1)
	local invisflingStepped
	invisflingStepped = game:GetService("RunService").Stepped:Connect(function()
		if speaker.Character and getRoot(speaker.Character) then
			Prote.SpoofProperty(getRoot(speaker.Character), "CanCollide")
			getRoot(speaker.Character).CanCollide = false
		else
			invisflingStepped:Disconnect()
		end
	end)
	sFLY()
	Prote.SpoofProperty(workspace.CurrentCamera, "CameraSubject")
	workspace.CurrentCamera.CameraSubject = root
	local bambam = Instance.new("BodyThrust")
	Prote.ProtectInstance(bambam)
	bambam.Parent = getRoot(speaker.Character)
	bambam.Force = Vector3.new(99999, 99999 * 10, 99999)
	bambam.Location = getRoot(speaker.Character).Position
end)

newCmd("infinitejump", {"infjump"}, "infinitejump / infjump", "Be Able to Keep Jumping", function(args, speaker)
	notify("Infinite Jump", "Enabled")
	cmdinfjump = true
	game:GetService("UserInputService").JumpRequest:Connect(function()
		if cmdinfjump == true then
			if findhum() then
				local Human = gethum()
				Prote.SpoofInstance(Human)
				Human:ChangeState("Jumping")
			end
		end
	end)
end)

newCmd("uninfinitejump", {"uninfjump"}, "uninfinitejump / uninfjump", "Disable Infinite Jump", function(args, speaker)
	notify("Infinite Jump", "Disabled")
	cmdinfjump = false
end)

newCmd("serverhop", {"shop"}, "serverhop / shop", "Teleports you to a different server", function(args, speaker)
	local Cache = HopTbl.Mem:HasItem("JobId_CACHE_DA") and HopTbl.Http:JSONDecode(HopTbl.Mem:GetItem("JobId_CACHE_DA")) or {}
	if not table.find(Cache, game.JobId) then
		Cache[#Cache + 1] = game.JobId
	end
	HopTbl.Mem:RemoveItem("JobId_CACHE_DA")
	HopTbl.Mem:SetItem("JobId_CACHE_DA", HopTbl.Http:JSONEncode(Cache))
	local Servers = {}
	for _, v in ipairs(HopTbl.GetPublicServers(game.PlaceId)) do
		if type(v) == "table" and v.maxPlayers > v.playing and not table.find(Cache, v.id) then
			Servers[#Servers + 1] = v
		end
	end
	table.sort(Servers, function(a, b)
		return a.ping < b.ping
	end)
	if #Servers > 0 then
		notify("Serverhop", "Teleporting to a new server")
		HopTbl.TP:TeleportToPlaceInstance(game.PlaceId, Servers[1].id, speaker)
	else
		HopTbl.Mem:RemoveItem("JobId_CACHE_DA")
		notify("Server Hop", "Failed to find a new server. Try again.")
	end
end)

newCmd("hipheight", {"hh"}, "hipheight / hh [number]", "Adjusts Hip Height", function(args, speaker)
	local height = nil
	if r15(speaker) then
		height = args[1] or 2.1
	else
		height = args[1] or 0
	end
	if findhum() then
		local Human = gethum()
		Prote.SpoofProperty(Human, "HipHeight")
		Human.HipHeight = height
	end
end)

local bringT = {}
newCmd("loopbring", {}, "loopbring [plr] [distance] [delay] (Client)", "Loop brings a player to you (useful for killing)", function(args, speaker)
	local players = getPlayer(args[1], speaker)
	for i,v in pairs(players)do
		spawn(function()
			if Players[v].Name ~= speaker.Name and not FindInTable(bringT, Players[v].Name) then
				table.insert(bringT, Players[v].Name)
				local plrName = Players[v].Name
				local pchar=Players[v].Character
				local distance = 3
				if args[2] and isNumber(args[2]) then
					distance = args[2]
				end
				local lDelay = 0
				if args[3] and isNumber(args[3]) then
					lDelay = args[3]
				end
				repeat
					for i,c in pairs(players) do
						if Players:FindFirstChild(v) then
							pchar = Players[v].Character
							if pchar~= nil and Players[v].Character ~= nil and getRoot(pchar) and speaker.Character ~= nil and getRoot(speaker.Character) then
								getRoot(pchar).CFrame = getRoot(speaker.Character).CFrame + Vector3.new(distance, 1, 0)
							end
							wait(lDelay)
						else 
							for a,b in pairs(bringT) do if b == plrName then table.remove(bringT, a) end end
						end
					end
				until not FindInTable(bringT, plrName)
			end
		end)
	end
end)

newCmd("unloopbring", {}, "unloopbring [plr]", "Undoes Loopbring", function(args, speaker)
	local players = getPlayer(args[1], speaker)
	for i,v in pairs(players)do
		spawn(function()
			for a,b in pairs(bringT) do if b == Players[v].Name then table.remove(bringT, a) end end
		end)
	end
end)

newCmd("freeze", {"fr"}, "freeze / fr [plr] (Client)", "Freezes a Player", function(args, speaker)
	local players = getPlayer(args[1], speaker)
	if players ~= nil then
		for i,v in pairs(players) do
			spawn(function()
				for i, x in next, Players[v].Character:GetDescendants() do
					if x:IsA("BasePart") and not x.Anchored then
						Prote.SpoofProperty(x, "Anchored")
						x.Anchored = true
					end
				end
			end)
		end
	end
end)

newCmd("thaw", {"unfr"}, "thaw / unfr [plr] (Client)", "Unfreezes a Player", function(args, speaker)
	local players = getPlayer(args[1], speaker)
	if players ~= nil then
		for i,v in pairs(players) do
			spawn(function()
				for i, x in next, Players[v].Character:GetDescendants() do
					if x:IsA("BasePart") and x.Anchored then
						Prote.SpoofProperty(x, "Anchored")
						x.Anchored = false
					end
				end
			end)
		end
	end
end)

newCmd("spawnpoint", {}, "spawnpoint [delay]", "Sets a position where you will spawn", function(args, speaker)
	local curpos = math.round(getRoot(speaker.Character).Position.X) .. ", " .. math.round(getRoot(speaker.Character).Position.Y) .. ", " .. math.round(getRoot(speaker.Character).Position.Z)
	spawnpos = getRoot(speaker.Character).CFrame
	spawnpoint = true
	spDelay = tonumber(args[1]) or 0.1
	notify("Spawn Point", "Created at " .. curpos)
end)

newCmd("unspawnpoint", {}, "unspawnpoint", "Removes your custom spawnpoint", function(args, speaker)
	spawnpoint = false
	notify("Spawn Point", "Removed Spawn Point")
end)

newCmd("removeclothes", {"naked"}, "removeclothes / naked", "Removes your Clothing", function(args, speaker)
	for i,v in pairs(speaker.Character:GetDescendants()) do
		if v:IsA("Clothing") then
			v:Destroy()
		end
		if v:IsA("ShirtGraphic") then
			v:Destroy()
		end
	end
end)

newCmd("noface", {}, "noface", "Removes your Face", function(args, speaker)
	for i,v in pairs(speaker.Character:GetDescendants()) do
		if v:IsA("Decal") then
			if string.lower(v.Name) == "face" then
				v:Destroy()
			end
		end
	end
end)

newCmd("headless", {}, "headless", "Removes your Head (Uses Simulation Radius)", function(args, speaker)
	if sethidden then
		local lplr = Players.LocalPlayer
		local char = lplr.Character
		local rig = tostring(char.Humanoid.RigType) == "Enum.HumanoidRigType.R6" and 1 or tostring(char.Humanoid.RigType) == "Enum.HumanoidRigType.R15" and 2

		local speaker = Players.LocalPlayer

		sethidden(speaker, "SimulationRadius", math.huge)

		local test = Instance.new("Model")
		Prote.ProtectInstance(test)
		local hum  = Instance.new("Humanoid")
		Prote.ProtectInstance(hum)
		local animation = Instance.new("Model")
		Prote.ProtectInstance(animation)
		local humanoidanimation = Instance.new("Humanoid")
		Prote.ProtectInstance(humanoidanimation)
		test.Parent = workspace
		hum.Parent = test
		animation.Parent = workspace
		humanoidanimation.Parent = animation

		lplr.Character = test
		wait(2)
		char.Humanoid.Animator.Parent = humanoidanimation
		char.Humanoid:Destroy()

		char.Head:Destroy()
		wait(5)
		Players.LocalPlayer.Character = char

		local hum2 = Instance.new("Humanoid")
		Prote.ProtectInstance(hum2)
		hum2.Parent = char
		char:FindFirstChildOfClass("Humanoid").Jump = true

		humanoidanimation.Animator.Parent = hum2
		SetLocalAnimate(char, true)
		wait()
		SetLocalAnimate(char, false)
		wait()

		if rig == 1 then
			hum2.HipHeight = 0
		elseif rig == 2 then
			hum2.HipHeight = 2.19
		end
	else
		notify("Incompatible Exploit", "Missing sethiddenproperty")
	end
end)

newCmd("autorejoin", {"autorj"}, "autorejoin / autorj", "Automatically rejoins the server if you get kicked/disconnected", function(args, speaker)
	Settings.cmdautorj = true
	updatesaves()
	notify("Auto Rejoin", "Enabled")
end)

newCmd("unautorejoin", {"unautorj"}, "unautorejoin / unautorj", "Disable Auto Rejoin", function(args, speaker)
	Settings.cmdautorj = false
	updatesaves()
	notify("Auto Rejoin", "Disabled")
end)

newCmd("teleport", {"tp"}, "teleport / tp [plr] [plr] (Tool)", "Teleports a player to another player (Tool Required)", function(args, speaker)
	local players1 = getPlayer(args[1], speaker)
	local players2 = getPlayer(args[2], speaker)
	for i,v in pairs(players1) do
		if getRoot(Players[v].Character) and getRoot(Players[players2[1]].Character) then
			if speaker.Character:FindFirstChildOfClass("Humanoid") and speaker.Character:FindFirstChildOfClass("Humanoid").SeatPart then
				speaker.Character:FindFirstChildOfClass("Humanoid").Sit = false
				wait(.1)
			end
			teleport(speaker, Players[v], Players[players2[1]])
		end
	end
end)

newCmd("fastteleport", {"fasttp"}, "fastteleport / fasttp [plr] [plr] (Tool)", "Teleports a player to another player faster (Tool Required)", function(args, speaker)
	local players1 = getPlayer(args[1], speaker)
	local players2 = getPlayer(args[2], speaker)
	for i,v in pairs(players1) do
		if getRoot(Players[v].Character) and getRoot(Players[players2[1]].Character) then
			if speaker.Character:FindFirstChildOfClass("Humanoid") and speaker.Character:FindFirstChildOfClass("Humanoid").SeatPart then
				speaker.Character:FindFirstChildOfClass("Humanoid").Sit = false
				wait(.1)
			end
			teleport(speaker, Players[v], Players[players2[1]], true)
		end
	end
end)

newCmd("fullbright", {"fb"}, "fullbright / fb (Client)", "Makes the map brighter / more visible", function(args, speaker)
	local Lighting = game:GetService("Lighting")
	Prote.SpoofProperty(Lighting, "Brightness")
	Prote.SpoofProperty(Lighting, "ClockTime")
	Prote.SpoofProperty(Lighting, "FogEnd")
	Prote.SpoofProperty(Lighting, "OutdoorAmbient")
	Prote.SpoofProperty(Lighting, "GlobalShadows")
	Lighting.Brightness = 2
	Lighting.ClockTime = 14
	Lighting.FogEnd = 100000
	Lighting.OutdoorAmbient = Color3.fromRGB(128, 128, 128)
	Lighting.GlobalShadows = false
end)

newCmd("loopfullbright", {"loopfb"}, "loopfullbright / loopfb", "Makes the map brighter / more visible but looped", function(args, speaker)
	if brightLoop then
		brightLoop:Disconnect()
	end
	local Lighting = game:GetService("Lighting")
	Prote.SpoofProperty(Lighting, "Brightness")
	Prote.SpoofProperty(Lighting, "ClockTime")
	Prote.SpoofProperty(Lighting, "FogEnd")
	Prote.SpoofProperty(Lighting, "GlobalShadows")
	Prote.SpoofProperty(Lighting, "OutdoorAmbient")
	local brightFunc = function()
		Lighting.Brightness = 2
		Lighting.ClockTime = 14
		Lighting.FogEnd = 100000
		Lighting.GlobalShadows = false
		Lighting.OutdoorAmbient = Color3.fromRGB(128, 128, 128)
	end
	brightLoop = game:GetService("RunService").RenderStepped:Connect(brightFunc)
end)

newCmd("unloopfullbright", {"unfb"}, "unloopfullbright / unloopfb", "Disable Loop Full Bright", function(args, speaker)
	if brightLoop then
		brightLoop:Disconnect()
	end
end)

newCmd("day", {}, "day (Client)", "Changes the time to day for the client", function(args, speaker)
	local Lighting = game:GetService("Lighting")
	Prote.SpoofProperty(Lighting, "ClockTime")
	Lighting.ClockTime = 14
end)

newCmd("night", {}, "night (Client)", "Changes the time to night for the client", function(args, speaker)
	local Lighting = game:GetService("Lighting")
	Prote.SpoofProperty(Lighting, "ClockTime")
	Lighting.ClockTime = 0
end)

newCmd("nofog", {}, "nofog (Client)", "Removes Fog", function(args, speaker)
	local Lighting = game:GetService("Lighting")
	Prote.SpoofProperty(Lighting, "FogEnd")
	Lighting.FogEnd = 100000
end)

newCmd("brightness", {}, "brightness [num] (Client)", "Changes the Brightness Lighting Property", function(args, speaker)
	local Lighting = game:GetService("Lighting")
	if args[1] then
		Prote.SpoofProperty(Lighting, "Brightness")
		Lighting.Brightness = args[1]
	else
		Prote.SpoofProperty(Lighting, "ClockTime")
		Lighting.Brightness = origsettings.Lighting.brt
	end
end)

newCmd("globalshadows", {"gshadows"}, "globalshadows / gshadows", "Enables Global Shadows", function(args, speaker)
	local Lighting = game:GetService("Lighting")
	Prote.SpoofProperty(Lighting, "GlobalShadows")
	game:GetService("Lighting").GlobalShadows = true
end)

newCmd("noglobalshadows", {"nogshadows"}, "noglobalshadows / nogshadows", "Disables Global Shadows", function(args, speaker)
	local Lighting = game:GetService("Lighting")
	Prote.SpoofProperty(Lighting, "GlobalShadows")
	game:GetService("Lighting").GlobalShadows = false
end)

newCmd("light", {}, "light [radius] [brightness] (Client)", "Gives your Player Dynamic Light", function(args, speaker)
	if speaker and speaker.Character and getRoot(speaker.Character) then
		local light = Instance.new("PointLight")
		Prote.SpoofInstance(light)
		light.Parent = getRoot(speaker.Character)
		light.Name = pointLightName
		light.Range = 30
		if args[1] then
			light.Brightness = args[2]
			light.Range = args[1]
		else
			light.Brightness = 5
		end
	end
end)

newCmd("unlight", {}, "unlight", "Removes Dynamic Light from your Player", function(args, speaker)
	if speaker and speaker.Character then
		for i,v in pairs(speaker.Character:GetDescendants()) do
			if v.ClassName == "PointLight" then
				if v.Name == pointLightName then
					v:Destroy()
				end
			end
		end
	end
end)

newCmd("restorelighting", {"rlighting"}, "restorelighting / rlighting", "Restores Lighting Properties", function(args, speaker)
	local Lighting = game:GetService("Lighting")
	Prote.SpoofProperty(Lighting, "Ambient")
	Prote.SpoofProperty(Lighting, "OutdoorAmbient")
	Prote.SpoofProperty(Lighting, "Brightness")
	Prote.SpoofProperty(Lighting, "ClockTime")
	Prote.SpoofProperty(Lighting, "FogEnd")
	Prote.SpoofProperty(Lighting, "FogStart")
	Prote.SpoofProperty(Lighting, "GlobalShadows")
	Lighting.Ambient = origsettings.Lighting.abt
	Lighting.OutdoorAmbient = origsettings.Lighting.oabt
	Lighting.Brightness = origsettings.Lighting.brt
	Lighting.ClockTime = origsettings.Lighting.time
	Lighting.FogEnd = origsettings.Lighting.fe
	Lighting.FogStart = origsettings.Lighting.fs
	Lighting.GlobalShadows = origsettings.Lighting.gs
end)

newCmd("hitbox", {}, "hitbox [plr] [size]", "Expands the hitbox for player heads (default is 1)", function(args, speaker)
	local players = getPlayer(args[1], speaker)
	for i,v in pairs(players) do
		if Players[v] ~= speaker and Players[v].Character:FindFirstChild("Head") then
			local sizeArg = tonumber(args[2])
			local Size = Vector3.new(sizeArg, sizeArg, sizeArg)
			local Head = Players[v].Character:FindFirstChild("Head")
			if Head:IsA("BasePart") then
				if not args[2] or sizeArg == 1 then
					Prote.ProtectInstance(Head)
					Head.Size = Vector3.new(2, 1, 1)
				else
					Prote.ProtectInstance(Head)
					Head.Size = Size
				end
			end
		end
	end
end)

newCmd("god", {}, "god", "Makes your character difficult to kill in most games", function(args, speaker)
	local Cam = workspace.CurrentCamera
	local Pos, Char = Cam.CFrame, speaker.Character
	local Human = Char and Char.FindFirstChildWhichIsA(Char, "Humanoid")
	local nHuman = Human.Clone(Human)
	nHuman.Parent, speaker.Character = Char, nil
	nHuman.SetStateEnabled(nHuman, 15, false)
	nHuman.SetStateEnabled(nHuman, 1, false)
	nHuman.SetStateEnabled(nHuman, 0, false)
	nHuman.BreakJointsOnDeath, Human = true, Human.Destroy(Human)
	speaker.Character, Cam.CameraSubject, Cam.CFrame = Char, nHuman, wait() and Pos
	nHuman.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
	local Script = Char.FindFirstChild(Char, "Animate")
	if Script then
		SetLocalAnimate(Char, true)
		wait()
		SetLocalAnimate(Char, false)
	end
	nHuman.Health = nHuman.MaxHealth
end)

newCmd("noroot", {}, "noroot", "Removes your characters HumanoidRootPart", function(args, speaker)
	if speaker.Character ~= nil then
		local char = Players.LocalPlayer.Character
		char.Parent = nil
		char.HumanoidRootPart:Destroy()
		char.Parent = workspace
	end
end)

newCmd("boostfps", {}, "boostfps", "Lowers Game Quality to Boost FPS", function(args, speaker)
	local Lighting = game:GetService("Lighting")
	local Terrain = workspace:FindFirstChildOfClass("Terrain")
	Prote.SpoofProperty(Terrain, "WaterWaveSize")
	Prote.SpoofProperty(Terrain, "WaterWaveSpeed")
	Prote.SpoofProperty(Terrain, "WaterReflectance")
	Prote.SpoofProperty(Terrain, "WaterTransparency")
	Prote.SpoofProperty(Lighting, "GlobalShadows")
	Prote.SpoofProperty(Lighting, "FogEnd")
	Terrain.WaterWaveSize = 0
	Terrain.WaterWaveSpeed = 0
	Terrain.WaterReflectance = 0
	Terrain.WaterTransparency = 0
	Lighting.GlobalShadows = false
	Lighting.FogEnd = 9e9
	settings().Rendering.QualityLevel = 1
	for i,v in pairs(game:GetDescendants()) do
		if v:IsA("Part") or v:IsA("UnionOperation") or v:IsA("MeshPart") or v:IsA("CornerWedgePart") or v:IsA("TrussPart") then
			Prote.SpoofProperty(v, "Material")
			Prote.SpoofProperty(v, "Reflectance")
			v.Material = "Plastic"
			v.Reflectance = 0
		elseif v:IsA("Decal") then
			Prote.SpoofProperty(v, "Transparency")
			v.Transparency = 1
		elseif v:IsA("ParticleEmitter") or v:IsA("Trail") then
			Prote.SpoofProperty(v, "Lifetime")
			v.Lifetime = NumberRange.new(0)
		elseif v:IsA("Explosion") then
			Prote.SpoofProperty(v, "BlastPressure")
			Prote.SpoofProperty(v, "BlastRadius")
			v.BlastPressure = 1
			v.BlastRadius = 1
		end
	end
	for i,v in pairs(Lighting:GetDescendants()) do
		if v:IsA("BlurEffect") or v:IsA("SunRaysEffect") or v:IsA("ColorCorrectionEffect") or v:IsA("BloomEffect") or v:IsA("DepthOfFieldEffect") then
			Prote.SpoofProperty(v, "Enabled")
			v.Enabled = false
		end
	end
end)

newCmd("setfpscap", {}, "setfpscap [number]", "Set your FPS Cap", function(args, speaker)
	if setfpscap and type(setfpscap) == "function" then
		local num = args[1] or 1e6
		if num == "none" then
			return setfpscap(1e6)
		elseif num > 0 then
			return setfpscap(num)
		else
			return notify("Invalid Argument", "Please provide a number above 0 or " .. '"none"' .. ".")
		end
	else
		return notify("Incompatible Exploit", "Missing setfpscap")
	end
end)

newCmd("tpposition", {"tppos"}, "tpposition / tppos [X] [Y] [Z]", "Teleports you to certain coordinates", function(args, speaker)
	if #args < 3 then return notify("Arguments Required", #args .. " / 3") end
	local Pos = {
		X = tonumber(args[1]),
		Y = tonumber(args[2]),
		Z = tonumber(args[3]),
	}
	local char = speaker.Character
	if char and getRoot(char) then
		getRoot(char).CFrame = CFrame.new(Pos.X, Pos.Y, Pos.Z)
	end
end)

newCmd("tweentpposition", {"ttppos"}, "tweentpposition / ttppos [X] [Y] [Z]", "Tween to coordinates (bypasses some anti cheats)", function(args, speaker)
	if #args < 3 then return notify("Arguments Required", #args .. " / 3") end
	local Pos = {
		X = tonumber(args[1]),
		Y = tonumber(args[2]),
		Z = tonumber(args[3]),
	}
	local char = speaker.Character
	if char and getRoot(char) then
		game:GetService("TweenService"):Create(getRoot(speaker.Character), TweenInfo.new(tweenSpeed, Enum.EasingStyle.Linear), {CFrame = CFrame.new(Pos.X, Pos.Y, Pos.Z)}):Play()
	end
end)

newCmd("chat", {"say"}, "chat / say [text]", "Makes you chat a string (possible mute bypass)", function(args, speaker)
	local cString = getstring(1)
	game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer(cString, "All")
end)

newCmd("silentchat", {"schat"}, "silentchat / schat [text]", "Makes you chat a string that won't show in chat", function(args, speaker)
	local cString = getstring(1)
	Players.Chat(Players, cString)
end)

newCmd("whisper", {"pm"}, "whisper / pm [plr] [text]", "Makes you whisper a string to someone (possible mute bypass)", function(args, speaker)
	local players = getPlayer(args[1], speaker)
	for i,v in pairs(players) do
		spawn(function()
			local plrName = Players[v].Name
			local pmstring = getstring(2)
			game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer("/w " .. plrName .. " " .. pmstring, "All")
		end)
	end
end)

newCmd("noclipcam", {"nccam"}, "noclipcam / nccam", "Allows your Camera to go Through Objects like Walls", function(args, speaker)
	local sc = (debug and debug.setconstant) or setconstant
	local gc = (debug and debug.getconstants) or getconstants
	if not sc or not getgc or not gc then
		return notify("Incompatible Exploit", "Missing setconstant or getconstants or getgc")
	end
	local pop = speaker.PlayerScripts.PlayerModule.CameraModule.ZoomController.Popper
	for _, v in pairs(getgc()) do
		if type(v) == "function" and getfenv(v).script == pop then
			for i, v1 in pairs(gc(v)) do
				if tonumber(v1) == 0.25 then
					sc(v, i, 0)
				elseif tonumber(v1) == 0 then
					sc(v, i, 0.25)
				end
			end
		end
	end
end)

newCmd("maxzoom", {}, "maxzoom [number]", "Maximum Camera Zoom", function(args, speaker)
	Prote.SpoofProperty(speaker, "CameraMaxZoomDistance")
	speaker.CameraMaxZoomDistance = args[1]
end)

newCmd("minzoom", {}, "minzoom [number]", "Minimum Camera Zoom", function(args, speaker)
	Prote.SpoofProperty(speaker, "CameraMinZoomDistance")
	speaker.CameraMinZoomDistance = args[1]
end)

newCmd("tpunanchored", {"tpua"}, "tpunanchored / tpua [plr]", "Teleports Unanchored Parts to a Player", function(args, speaker)
	if sethidden then
		local players = getPlayer(args[1], speaker)
		for i,v in pairs(players) do
			local Forces = {}
			for _, part in pairs(workspace:GetDescendants()) do
				if Players[v].Character:FindFirstChild("Head") and part:IsA("BasePart" or "UnionOperation" or "Model") and part.Anchored == false and not part:IsDescendantOf(speaker.Character) and part.Name == "Torso" == false and part.Name == "Head" == false and part.Name == "Right Arm" == false and part.Name == "Left Arm" == false and part.Name == "Right Leg" == false and part.Name == "Left Leg" == false and part.Name == "HumanoidRootPart" == false then
					for i,c in pairs(part:GetChildren()) do
						if c:IsA("BodyPosition") or c:IsA("BodyGyro") then
							c:Destroy()
						end
					end
					local ForceInstance = Instance.new("BodyPosition")
					Prote.ProtectInstance(ForceInstance)
					ForceInstance.Parent = part
					ForceInstance.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
					table.insert(Forces, ForceInstance)
					if not table.find(frozenParts, part) then
						table.insert(frozenParts, part)
					end
				end
			end
			SetSimulationRadius()
			for i,c in pairs(Forces) do
				c.Position = Players[v].Character.Head.Position
			end
		end
	else
		notify("Incompatible Exploit", "Missing sethiddenproperty")
	end
end)

newCmd("freezeunanchored", {"freezeua"}, "freezeunanchored / freezeua", "Freezes Unanchored Parts", function(args, speaker)
	if sethidden then
		local badnames = {
			"Head",
			"UpperTorso",
			"LowerTorso",
			"RightUpperArm",
			"LeftUpperArm",
			"RightLowerArm",
			"LeftLowerArm",
			"RightHand",
			"LeftHand",
			"RightUpperLeg",
			"LeftUpperLeg",
			"RightLowerLeg",
			"LeftLowerLeg",
			"RightFoot",
			"LeftFoot",
			"Torso",
			"Right Arm",
			"Left Arm",
			"Right Leg",
			"Left Leg",
			"HumanoidRootPart"
		}
		local FREEZENOOB = function(v)
			if v:IsA("BasePart" or "UnionOperation") and v.Anchored == false then
				local BADD = false
				for i = 1,#badnames do
					if v.Name == badnames[i] then
						BADD = true
					end
				end
				if speaker.Character and v:IsDescendantOf(speaker.Character) then
					BADD = true
				end
				if BADD == false then
					for i,c in pairs(v:GetChildren()) do
						if c:IsA("BodyPosition") or c:IsA("BodyGyro") then
							c:Destroy()
						end
					end
					SetSimulationRadius()
					local bodypos = Instance.new("BodyPosition")
					Prote.ProtectInstance(bodypos)
					bodypos.Parent = v
					bodypos.Position = v.Position
					bodypos.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
					local bodygyro = Instance.new("BodyGyro")
					Prote.ProtectInstance(bodygyro)
					bodygyro.Parent = v
					bodygyro.CFrame = v.CFrame
					bodygyro.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
					if not table.find(frozenParts, v) then
						table.insert(frozenParts, v)
					end
				end
			end
		end
		for i,v in pairs(workspace:GetDescendants()) do
			FREEZENOOB(v)
		end
		freezingua = workspace.DescendantAdded:Connect(FREEZENOOB)
	else
		notify("Incompatible Exploit", "Missing sethiddenproperty")
	end
end)

newCmd("thawunanchored", {"thawua", "unfreezeua"}, "thawunanchored / thawua / unfreezeua", "Thaws Unanchored Parts", function(args, speaker)
	if sethidden then
		if freezingua then
			freezingua:Disconnect()
		end
		SetSimulationRadius()
		for i,v in pairs(frozenParts) do
			for i,c in pairs(v:GetChildren()) do
				if c:IsA("BodyPosition") or c:IsA("BodyGyro") then
					c:Destroy()
				end
			end
		end
		frozenParts = {}
	else
		notify("Incompatible Exploit", "Missing sethiddenproperty")
	end
end)

newCmd("flashlight", {}, "flashlight (Client)", "Give yourself a Flashlight", function(args, speaker)
	loadstring(game:HttpGetAsync(("https://pastebin.com/raw/8K2cTfka")))();
end)

newCmd("metahook", {}, "metahook [name] [value]", "Hook an Argument with a Value", function(args, speaker)
	if args[1] and args[2] then
		local getrawmt = (debug and debug.getmetatable) or getrawmetatable
		local setReadOnly = setreadonly or (make_writeable and function(table, readonly) if readonly then make_readonly(table) else make_writeable(table) end end)
		local GameMt = getrawmt(game)
		local OldIndex = GameMt.__index
		
		setReadOnly(GameMt, false)
		
		GameMt.__index = newcclosure(function(Self, Key)
			if string.lower(tostring(Key)) == string.lower(tostring(args[1])) then
				return getstring(2)
			end
			return OldIndex(Self, Key)
		end)
		
		setReadOnly(GameMt, true)
	else
		notify("Meta Hook", "Missing a Argument")
	end
end)

newCmd("cancelteleport", {"canceltp"}, "cancelteleport / canceltp", "Cancels Teleports in Progress", function(args, speaker)
	game:GetService("TeleportService"):TeleportCancel()
end)

newCmd("copyemote", {}, "copyemote [plr]", "Copies a Player's Animation", function(args, speaker)
	local players = getPlayer(args[1], speaker)
	for _,v in ipairs(players)do
		local char = Players[v].Character
		for _, v1 in pairs(speaker.Character:FindFirstChildOfClass("Humanoid"):GetPlayingAnimationTracks()) do
			v1:Stop()
		end
		for _, v1 in pairs(Players[v].Character:FindFirstChildOfClass("Humanoid"):GetPlayingAnimationTracks()) do
			if not string.find(v1.Animation.AnimationId, "507768375") then
				local PlayerAnimation = speaker.Character:FindFirstChildOfClass("Humanoid"):LoadAnimation(v1.Animation)
				PlayerAnimation:Play(.1, 1, v1.Speed)
				PlayerAnimation.TimePosition = v1.TimePosition
				spawn(function()
					v1.Stopped:Wait()
					PlayerAnimation:Stop()
					PlayerAnimation:Destroy()
				end)
			end
		end
	end
end)

newCmd("clickteleport", {"teleporttool", "clicktp", "tptool"}, "clickteleport / clicktp / teleporttool / tptool", "Gives You a Teleport Tool", function(args, speaker)
	if findbp() then
		local Backpack = getbp()
		local TpTool = Instance.new("Tool")
		Prote.ProtectInstance(TpTool)
		TpTool.Name = "Teleport Tool"
		TpTool.RequiresHandle = false
		TpTool.Parent = Backpack
		TpTool.Activated:Connect(function()
			local Char = speaker.Character or workspace:FindFirstChild(speaker.Name)
			local Root = Char and Char:FindFirstChild("HumanoidRootPart")
			if not Char or not Root then
				return notify("Error", "Failed to Find HumanoidRootPart")
			end
			local Hit = DAMouse.Hit
			Root.CFrame = Hit * CFrame.new(0, 3, 0)
		end)
		local TpToolTween = Instance.new("Tool")
		Prote.ProtectInstance(TpToolTween)
		TpToolTween.Name = "Teleport Tool (Tween)"
		TpToolTween.RequiresHandle = false
		TpToolTween.Parent = Backpack
		TpToolTween.Activated:Connect(function()
			local Char = speaker.Character or workspace:FindFirstChild(speaker.Name)
			local Root = Char and Char:FindFirstChild("HumanoidRootPart")
			if not Char or not Root then
				return notify("Error", "Failed to Find HumanoidRootPart")
			end
			local Hit = DAMouse.Hit
			local TweenService = game:GetService("TweenService")
			local TweeningInfo = TweenInfo.new(0.5, Enum.EasingStyle["Sine"], Enum.EasingDirection["Out"])
			local TweenFunc = TweenService.Create(TweenService, Root, TweeningInfo, {CFrame = Hit * CFrame.new(0, 3, 0)})
			TweenFunc.Play(TweenFunc)
		end)
	else
		notify("Command Error", "Missing Backpack")
	end
end)

newCmd("walltp", {}, "walltp", "Teleports You Above/Over Any Wall You Run Into", function(args, speaker)
	local Torso = nil
	if r15(speaker) then
		Torso = speaker.Character.UpperTorso
	else
		Torso = speaker.Character.Torso
	end
	local TouchedFunc = function(hit)
		local Root = getRoot(speaker.Character)
		if hit:IsA("BasePart") and hit.Position.Y > Root.Position.Y - speaker.Character:FindFirstChildOfClass("Humanoid").HipHeight then
			local HitP = getRoot(hit.Parent)
			if HitP ~= nil then
				Root.CFrame = hit.CFrame * CFrame.new(Root.CFrame.lookVector.X,HitP.Size.Z/2 + speaker.Character:FindFirstChildOfClass("Humanoid").HipHeight,Root.CFrame.lookVector.Z)
			elseif HitP == nil then
				Root.CFrame = hit.CFrame * CFrame.new(Root.CFrame.lookVector.X,hit.Size.Y/2 + speaker.Character:FindFirstChildOfClass("Humanoid").HipHeight,Root.CFrame.lookVector.Z)
			end
		end
	end
	WallTpTouch = Torso.Touched:Connect(TouchedFunc)
end)

newCmd("unwalltp", {}, "unwalltp", "Disables Walltp", function(args, speaker)
	if WallTpTouch then
		WallTpTouch:Disconnect()
	end
end)

newCmd("bang", {}, "bang [plr] [speed]", "I don't want to explain this", function(args, speaker)
	if not r15(speaker) then
		execCmd("unbang")
		wait()
		local players = getPlayer(args[1], speaker)
		for i,v in pairs(players) do
			bangAnim = Instance.new("Animation")
			Prote.ProtectInstance(bangAnim)
			bangAnim.AnimationId = "rbxassetid://148840371"
			local selfhum = speaker.Character:FindFirstChildWhichIsA("Humanoid")
			bang = selfhum:LoadAnimation(bangAnim)
			bang:Play(0.1, 1, 1)
			if args[2] then
				bang:AdjustSpeed(args[2])
			else
				bang:AdjustSpeed(3)
			end
			local bangplr = Players[v].Name
			bangDied = selfhum.Died:Connect(function()
				bangLoop = bangLoop:Disconnect()
				bang:Stop()
				bangAnim:Destroy()
				bangDied:Disconnect()
			end)
			local bangOffet = CFrame.new(0, 0, 1.1)
			bangLoop = game:GetService("RunService").Stepped:Connect(function()
				pcall(function()
					local otherRoot = getTorso(Players[bangplr].Character)
					getRoot(Players.LocalPlayer.Character).CFrame = otherRoot.CFrame * bangOffet
				end)
			end)
		end
	else
		notify("R6 Required", "Requires R6 Rig Type")
	end
end)

newCmd("unbang", {}, "unbang", "Humanity Restored", function(args, speaker)
	if bangLoop then
		bangLoop:Disconnect()
		bangDied:Disconnect()
		bang:Stop()
		bangAnim:Destroy()
	end
end)

newCmd("carpet", {}, "carpet [plr]", "Become a Player's Carpet", function(args, speaker)
	if not r15(speaker) then
		execCmd("uncarpet")
		wait()
		local players = getPlayer(args[1], speaker)
		for i,v in pairs(players) do
			carpetAnim = Instance.new("Animation")
			Prote.ProtectInstance(carpetAnim)
			carpetAnim.AnimationId = "rbxassetid://282574440"
			carpet = speaker.Character.Humanoid:LoadAnimation(carpetAnim)
			carpet:Play(.1, 1, 1)
			local carpetplr = Players[v].Name
			carpetDied = speaker.Character:FindFirstChildWhichIsA("Humanoid").Died:Connect(function()
				carpetLoop:Disconnect()
				carpet:Stop()
				carpetAnim:Destroy()
				carpetDied:Disconnect()
			end)
			carpetLoop = game:GetService("RunService").Heartbeat:Connect(function()
				pcall(function()
					getRoot(Players.LocalPlayer.Character).CFrame = getRoot(Players[carpetplr].Character).CFrame
				end)
			end)
		end
	else
		notify("R6 Required", "Requires R6 Rig Type")
	end
end)

newCmd("uncarpet", {}, "uncarpet", "Undoes Carpet", function(args, speaker)
	if carpetLoop then
		carpetLoop:Disconnect()
		carpetDied:Disconnect()
		carpet:Stop()
		carpetAnim:Destroy()
	end
end)

newCmd("walkto", {"follow"}, "walkto / follow [plr]", "Follow a Player", function(args, speaker)
	local players = getPlayer(args[1], speaker)
	for i,v in pairs(players) do
		if Players[v].Character ~= nil then
			if speaker.Character:FindFirstChildOfClass("Humanoid") and speaker.Character:FindFirstChildOfClass("Humanoid").SeatPart then
				speaker.Character:FindFirstChildOfClass("Humanoid").Sit = false
				wait(.1)
			end
			walkto = true
			repeat wait()
				speaker.Character:FindFirstChildOfClass("Humanoid"):MoveTo(getRoot(Players[v].Character).Position)
			until Players[v].Character == nil or not getRoot(Players[v].Character) or walkto == false
		end
	end
end)

newCmd("pathfindwalkto", {"pathfindfollow"}, "pathfindwalkto / pathfindfollow [plr]", "Follow a Player Using Pathfinding", function(args, speaker)
	walkto = false
	wait()
	local players = getPlayer(args[1], speaker)
	local PathService = game:GetService("PathfindingService")
	local hum = Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
	local path = PathService:CreatePath()
	for i,v in pairs(players) do
		if Players[v].Character ~= nil then
			if speaker.Character:FindFirstChildOfClass("Humanoid") and speaker.Character:FindFirstChildOfClass("Humanoid").SeatPart then
				speaker.Character:FindFirstChildOfClass("Humanoid").Sit = false
				wait(.1)
			end
			walkto = true
			repeat wait()
				local success, response = pcall(function()
					path:ComputeAsync(getRoot(speaker.Character).Position, getRoot(Players[v].Character).Position)
					local waypoints = path:GetWaypoints()
					local distance 
					for waypointIndex, waypoint in pairs(waypoints) do
						local waypointPosition = waypoint.Position
						hum:MoveTo(waypointPosition)
						repeat 
							distance = (waypointPosition - hum.Parent.PrimaryPart.Position).magnitude
							wait()
						until
						distance <= 5
					end	 
				end)
				if not success then
					speaker.Character:FindFirstChildOfClass("Humanoid"):MoveTo(getRoot(Players[v].Character).Position)
				end
			until Players[v].Character == nil or not getRoot(Players[v].Character) or walkto == false
		end
	end
end)

newCmd("unwalkto", {"unfollow"}, "unwalkto / unfollow", "Follow a Player Using Pathfinding", function(args, speaker)
	walkto = false
end)

newCmd("stare", {}, "stare [plr]", "Stare at a Player", function(args, speaker)
	local players = getPlayer(args[1], speaker)
	for i,v in pairs(players) do
		if StareLoop then
			StareLoop:Disconnect()
		end
		if not Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and Players[v].Character:FindFirstChild("HumanoidRootPart") then return end
		local StareFunc = function()
			if Players.LocalPlayer.Character.PrimaryPart and Players:FindFirstChild(v) and Players[v].Character ~= nil and Players[v].Character:FindFirstChild("HumanoidRootPart") then
				local chrPos = Players.LocalPlayer.Character.PrimaryPart.Position
				local tPos = Players[v].Character:FindFirstChild("HumanoidRootPart").Position
				local modTPos = Vector3.new(tPos.X, chrPos.Y, tPos.Z)
				local newCF = CFrame.new(chrPos, modTPos)
				Players.LocalPlayer.Character:SetPrimaryPartCFrame(newCF)
			elseif not Players:FindFirstChild(v) then
				StareLoop:Disconnect()
			end
		end
		StareLoop = game:GetService("RunService").RenderStepped:Connect(StareFunc)
	end
end)

newCmd("unstare", {}, "unstare [plr]", "Disables Stare", function(args, speaker)
	if StareLoop then
		StareLoop:Disconnect()
	end
end)

newCmd("replicationlag", {"backtrack"}, "replicationlag / backtrack [num]", "Set IncomingReplicationLag", function(args, speaker)
	if args[1] then
		local IRL = tonumber(args[1])
		settings():GetService("NetworkSettings").IncomingReplicationLag = IRL
	else
		notify("Replication Lag", "Missing Argument")
	end
end)

newCmd("nameprotect", {}, "nameprotect", "Protect your Name Locally by Setting it to \"User\"", function(args, speaker)
	Import("nameprot.lua")
	notify("", "Name Protected")
end)

newCmd("ping", {}, "ping", "Notify yourself your Ping", function(args, speaker)
	local Current_Ping = game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValueString():split(" ")[1] .. "ms"
	notify("Ping", Current_Ping)
end)

newCmd("fps", {"frames"}, "fps / frames", "Notify yourself your Framerate", function(args, speaker)
	local x = 0	
	local a = tick()
	local fpsget = function()
		x = (1 / (tick() - a))
		a = tick()
		return ("%.3f"):format(x)
	end
	local fps = nil
	local v = game:GetService("RunService").Stepped:Connect(function()
		fps = fpsget()
	end)
	wait(0.2)
	v:Disconnect()
	notify("FPS", "Current FPS is " .. fps)
end)

newCmd("clearhats", {}, "clearhats", "Clears Hats in the Workspace", function(args, speaker)
	if firetouchinterest then
		local Player = Players.LocalPlayer
		local Character = Player.Character
		local Old = Character:FindFirstChild("HumanoidRootPart").CFrame
		local Hats = {}
		for _, x in next, workspace:GetChildren() do
			if x:IsA("Accessory") then
				table.insert(Hats, x)
			end
		end
		for _, getacc in next, Character:FindFirstChildWhichIsA("Humanoid"):GetAccessories() do
			getacc:Destroy()
		end
		for i = 1,#Hats do
			repeat game:GetService("RunService").Heartbeat:Wait() until Hats[i]
			firetouchinterest(Hats[i].Handle, Character:FindFirstChild("HumanoidRootPart"), 0)
			repeat game:GetService("RunService").Heartbeat:Wait() until Character:FindFirstChildOfClass("Accessory")
			Character:FindFirstChildOfClass("Accessory"):Destroy()
			repeat game:GetService("RunService").Heartbeat:Wait() until not Character:FindFirstChildOfClass("Accessory")
		end
		Character:BreakJoints()
		Player.CharacterAdded:wait()
		for i = 1,20 do game:GetService("RunService").Heartbeat:Wait()
			if Player.Character:FindFirstChild("HumanoidRootPart") then
				Player.Character:FindFirstChild("HumanoidRootPart").CFrame = Old
			end
		end
	else
		notify("Incompatible Exploit", "Missing firetouchinterest")
	end
end)

newCmd("hatspin", {}, "hatspin", "Spins your Character's Accessories", function(args, speaker)
	execCmd("unhatspin")
	wait(.5)
	for _,v in pairs(speaker.Character:FindFirstChildOfClass("Humanoid"):GetAccessories()) do
		local keep = Instance.new("BodyPosition")
		Prote.ProtectInstance(keep)
		keep.Parent = v.Handle
		keep.Name = randomString()
		local spin = Instance.new("BodyAngularVelocity")
		Prote.ProtectInstance(spin)
		spin.Parent = v.Handle
		spin.Name = randomString()
		spin.Parent = v.Handle
		v.Handle:FindFirstChildOfClass("Weld"):Destroy()
		if args[1] then
			spin.AngularVelocity = Vector3.new(0, args[1], 0)
			spin.MaxTorque = Vector3.new(0, args[1] * 2, 0)
		else
			spin.AngularVelocity = Vector3.new(0, 100, 0)
			spin.MaxTorque = Vector3.new(0, 200, 0)
		end
		keep.P = 30000
		keep.D = 50
		spinhats = game:GetService("RunService").Stepped:Connect(function()
			pcall(function()
				keep.Position = Players.LocalPlayer.Character.Head.Position
			end)
		end)
	end
end)

newCmd("unhatspin", {}, "unhatspin", "Disables Hatspin", function(args, speaker)
	if spinhats and spinhats ~= nil then
		spinhats:Disconnect()
	end
	for _, v in pairs(speaker.Character:FindFirstChildWhichIsA("Humanoid"):GetAccessories()) do
		v.Parent = workspace
		for i,c in pairs(v.Handle) do
			if c:IsA("BodyPosition") or c:IsA("BodyAngularVelocity") then
				c:Destroy()
			end
		end
		wait()
		v.Parent = speaker.Character
	end
end)

newCmd("fixgyros", {}, "fixgyros", "Fix Body Gyros", function(args, speaker)
	if setscriptable then
		local prep = function(plr)
			if plr and plr.Character then
				for _, char in pairs(plr.Character:GetChildren()) do
					game:GetService("RunService").RenderStepped:Connect(function()
						pcall(function()
							if char:IsA("Part") or char:IsA("BasePart") then
								Prote.SpoofProperty(char, "Velocity")
								char.Velocity = Vector3.new(30, 0, 4)
							end
						end)
					end)
				end
			end
		end
		game:GetService("RunService").Heartbeat:Connect(function()
			pcall(function()
				setscriptable(Players.LocalPlayer, "SimulationRadius", true)
			end)
			if Players.LocalPlayer and Players.LocalPlayer.Character then
				for _, char in pairs(Players.LocalPlayer.Character:GetChildren()) do
					game:GetService("RunService").RenderStepped:Connect(function()
						pcall(function()
							if char:IsA("Part") or char:IsA("BasePart") then
								Prote.SpoofProperty(char, "Velocity")
								char.Velocity = Vector3.new(30, 4, 0)
							end
						end)
					end)
				end
			end
		end)
		for i,v in pairs(Players:GetPlayers()) do
			if v ~= Players.LocalPlayer then
				prep(v)
			end
		end
		notify("Gyros", "Fixed")
	else
		for i,v in next, Players.LocalPlayer.Character:GetDescendants() do
			if v:IsA("BasePart") and v.Name ~= "HumanoidRootPart" then 
				game:GetService("RunService").Heartbeat:connect(function()
					v.Velocity = Vector3.new(0, 35, 0)
					wait(0.5)
				end)
			end
		end
		notify("Gyros", "Fixed")
	end
end)

newCmd("enable", {}, "enable [inventory/playerlist/chat/all]", "Toggles Visibility of CoreGui Items", function(args, speaker)
	if args[1] then
		local opt = string.lower(tostring(args[1]))
		if opt == "inventory" or opt == "backpack" then
			game:GetService("StarterGui"):SetCoreGuiEnabled("Backpack", true)
		elseif opt == "playerlist" then
			game:GetService("StarterGui"):SetCoreGuiEnabled("PlayerList", true)
		elseif opt == "chat" then
			game:GetService("StarterGui"):SetCoreGuiEnabled("Chat", true)
		elseif opt == "all" then
			game:GetService("StarterGui"):SetCoreGuiEnabled(Enum.CoreGuiType.All, true)
		end
	else
		notify("", "Missing Argument")
	end
end)

newCmd("disable", {}, "disable [inventory/playerlist/chat/all]", "Toggles Visibility of CoreGui Items", function(args, speaker)
	if args[1] then
		local opt = string.lower(tostring(args[1]))
		if opt == "inventory" or opt == "backpack" then
			game:GetService("StarterGui"):SetCoreGuiEnabled("Backpack", false)
		elseif opt == "playerlist" then
			game:GetService("StarterGui"):SetCoreGuiEnabled("PlayerList", false)
		elseif opt == "chat" then
			game:GetService("StarterGui"):SetCoreGuiEnabled("Chat", false)
		elseif opt == "all" then
			game:GetService("StarterGui"):SetCoreGuiEnabled(Enum.CoreGuiType.All, false)
		end
	else
		notify("", "Missing Argument")
	end
end)

newCmd("fixbubblechat", {}, "fixbubblechat", "Fix the Bubblechat Being Cut Off", function(args, speaker)
	if BubbleChatFix ~= nil then
		return notify("Bubble Chat", "Already Fixed")
	end
	if Players.LocalPlayer["PlayerGui"] and Players.LocalPlayer["PlayerGui"]:FindFirstChild("BubbleChat") then
		BubbleChatFix = Players.LocalPlayer.PlayerGui.BubbleChat.DescendantAdded:Connect(function(message)
			if message:IsA("TextLabel") and message.Name == "BubbleText" then
				message.TextSize = 21
			end
		end)
	end
	notify("Bubble Chat", "Fixed")
end)

newCmd("unfixbubblechat", {}, "unfixbubblechat", "Disable Fixbubblechat", function(args, speaker)
	if BubbleChatFix == nil then
		return notify("Bubble Chat", "Wasn't Fixed")
	end
	BubbleChatFix:Disconnect()
	BubbleChatFix = nil
	notify("Bubble Chat", "Reverted Fix")
end)

newCmd("reanimate", {"reanim"}, "reanimate / reanim", "Reanimate your Character to make some Net Scripts Netless", function(args, speaker)
	notify("Selexity", "Hold on a sec")
	wait(0.2)
	Import("anim.lua")
end)

newCmd("classicchat", {"clchat"}, "classicchat / clchat", "Enable Roblox's Classic Chat", function(args, speaker)
	local PlayerGui = speaker:WaitForChild("PlayerGui")
	PlayerGui:WaitForChild("Chat")
	if PlayerGui.Chat.Frame.ChatChannelParentFrame.Visible ~= true then
		PlayerGui.Chat.Frame.ChatBarParentFrame.Position = PlayerGui.Chat.Frame.ChatChannelParentFrame.Position + UDim2.new(UDim.new(0,0), PlayerGui.Chat.Frame.ChatChannelParentFrame.Size.Y)
		PlayerGui.Chat.Frame.ChatChannelParentFrame.Visible = true
		PlayerGui.Chat.Frame.ChatChannelParentFrame.Size = UDim2.new(1, 0, 1, -46)	
	end
end)

newCmd("clientsidebypass", {"clbypass"}, "clientsidebypass / clbypass", "Bypass Certain Anticheats", function(args, speaker)
	ClientByp = Players.LocalPlayer.CharacterAdded:Connect(function()
		repeat wait() until Players.LocalPlayer and Players.LocalPlayer.Character and findhum()
		wait(0.4)
		Prote.SpoofInstance(gethum())
		if r15(Players.LocalPlayer) then
			Prote.SpoofInstance(getRoot(Players.LocalPlayer.Character), Players.LocalPlayer.Character.UpperTorso)
		else
			Prote.SpoofInstance(getRoot(Players.LocalPlayer.Character), Players.LocalPlayer.Character.Torso)
		end
		Prote.ProtectInstance(getRoot(Players.LocalPlayer.Character))
		Prote.ProtectInstance(gethum())
	end)
	clientsidebypass = true
	Players.LocalPlayer.Character:BreakJoints()
	notify("Client Bypass", "Enabled")
end)

newCmd("unclientsidebypass", {"unclbypass"}, "unclientsidebypass / unclbypass", "Disable the Client-Sided Bypass", function(args, speaker)
	ClientByp:Disconnect()
	wait()
	ClientByp = nil
	clientsidebypass = false
	Players.LocalPlayer.Character:BreakJoints()
	notify("Client Bypass", "Disabled")
end)

newCmd("joinplayer", {"jplr"}, "joinplayer / jplr [user / id] [place id]", "Join a Specific Player's Server", function(args, speaker)
	if args[1] == nil then return notify("Join Player", "Missing Argument") end
	local retries = 0
	JoinServer = function(User, PlaceId)
		if args[2] == nil then PlaceId = game.PlaceId end
		if not pcall(function()
				local FoundUser, UserId = pcall(function()
					if tonumber(User) then
						return tonumber(User)
					end

					return Players:GetUserIdFromNameAsync(User)
				end)
				if not FoundUser then
					notify("Join Error", "Username / UserID does not exist")
				else
					notify("Join Player", "Loading servers. Hold on a second.")
					local URL2 = ("https://games.roblox.com/v1/games/" .. PlaceId .. "/servers/Public?sortOrder=Asc&limit=100")
					local Http = HttpService:JSONDecode(game:HttpGet(URL2))
					local GUID

					tablelength = function(T)
						local count = 0
						for _ in pairs(T) do count = count + 1 end
						return count
					end

					for i = 1, tonumber(tablelength(Http.data)) do
						for j,k in pairs(Http.data[i].playerIds) do
							if k == UserId then
								GUID = Http.data[i].id
							end
						end
					end

					if GUID ~= nil then
						notify("Join Player", "Joining " .. User)
						TeleportService:TeleportToPlaceInstance(PlaceId, GUID, Players.LocalPlayer)
					else
						notify("Join Error", "Unable to join user.")
					end
				end
			end)
		then
			if retries < 3 then
				retries = retries + 1
				notify("Join Error", "Error while trying to join. Retrying " .. retries .. "/3")
				JoinServer(User, PlaceId)
			else
				notify("Join Error", "Error While Joining")
			end
		end
	end
	JoinServer(args[1], args[2])
end)

newCmd("changeteam", {"team"}, "changeteam / team [name]", "Change your Team (Game must have a Touchable SpawnLocation for Team)", function(args, speaker)
	local TeamString = tostring(args[1])
	local Team = game:GetService("Teams"):FindFirstChild(TeamString)
	if not Team then return notify("Team Error", "Team " .. '"' .. TeamString .. '"' .. " does not Exist") end
	local TouchedPart = {}
	local firetouch = firetouchinterest or function(part1, part2, toggle)
		if part1 and part2 then
			if toggle == 0 then
				TouchedPart[1] = part1.CFrame
				part1.CFrame = part2.CFrame
			else
				part1.CFrame = TouchedPart[1]
				TouchedPart[1] = nil
			end
		end
	end
    for i,v in next, workspace:GetDescendants() do
    	if (v:IsA("SpawnLocation")) and (v.BrickColor == Team.TeamColor) then
    		local RootPart = getRoot(Players.LocalPlayer.Character)
    		if RootPart then
    			firetouch(v, RootPart, 0)
    			firetouch(v, RootPart, 1)
    			break
    		end
    	end
    end
    wait(0.1)
    if Players.LocalPlayer.Team == Team then
    	notify("Team Changed", "Changed Team to " .. tostring(Team.Name))
    else
    	notify("Team Error", "Couldn't Change Team to " .. tostring(Team.Name))
    end
end)

newCmd("hidename", {"hidebill"}, "hidename / hidebill", "Hide Billboard Nametag", function(args, speaker)
	local character = Players.LocalPlayer.Character
	local bill = character:FindFirstChildWhichIsA("BillboardGui", true)
	if not bill then return notify("Hide Name", "No Player Tag Found") end
	for i,v in next, game:GetDescendants(character) do
		if v:IsA("BillboardGui") then
			v:Destroy()
		end
	end
	notify("Hide Name", "Player Tag Hidden")
end)

newCmd("keybind", {"bind"}, "keybind / bind [key] [cmd]", "Bind a Command to a Key", function(args, speaker)
	if #args < 2 then return notify("Keybinds", "Missing Argument") end
	local command = getstring(2)
	local key = string.lower(tostring(args[1]))
	if #key < 2 then
		local id = #DA_Binds + 1
		DA_Binds[id] = {
			CMD = command,
			KEY = key,
		}
	notify("Keybinds", "Successfully Added Keybind")
	elseif #key > 2 then return notify("Keybinds", "Key cannot be longer than 2 characters.") end
end)

newCmd("unkeybind", {"unbind"}, "unkeybind / unbind [key]", "Remove a Bind for a Command", function(args, speaker)
	if #args < 1 then return notify("Keybinds", "Missing Argument") end
	local key = string.lower(tostring(args[1]))
	for i = 1, #DA_Binds do
		if DA_Binds[i].KEY == key then
			table.remove(DA_Binds, i)
			notify("Keybinds", "Removed Keybind")
		end
	end
end)

newCmd("clearkeybinds", {"clearbinds", "ckeybinds", "cbinds"}, "clearkeybinds / clearbinds / ckeybinds / cbinds", "Remove all Current Binds", function(args, speaker)
	for key in pairs(DA_Binds) do
		DA_Binds[key] = nil
	end
	notify("Keybinds", "Removed all Keybinds")
end)

newCmd("laydown", {"lay"}, "laydown / lay", "Makes your character lay down", function(args, speaker)
	local Human = speaker.Character and speaker.Character:FindFirstChildWhichIsA("Humanoid")
	if not Human then
		return
	end
	Prote.SpoofProperty(Human, "Sit")
	Human.Sit = true
	wait(0.1)
	Human.RootPart.CFrame = Human.RootPart.CFrame * CFrame.Angles(math.pi * 0.5, 0, 0)
	for _, v in ipairs(Human:GetPlayingAnimationTracks()) do
		v:Stop()
	end
end)

newCmd("execute", {"exec", "run"}, "execute / exec / run [file name]", "Execute a .txt or .lua file from the Scripts folder in the DA folder", function(args, speaker)
	if not args[1] then return notify("Script Error", "No Arguments Found") end
	local fileName = tostring(getstring(1))
	local newFile
	local newFileName
	if fileName:sub(-4) == ".txt" then
		pcall(function() newFile = readfile("Dark Admin/Scripts/" .. fileName) end)
		newFileName = fileName
	else
		pcall(function() newFile = readfile("Dark Admin/Scripts/".. fileName .. ".txt") end)
		newFileName = fileName .. ".txt"
	end
	if newFile then
		notify("Script Executed", newFileName)
		loadfile("Dark Admin/Scripts/" .. newFileName)()
	else
		if fileName:sub(-4) == ".lua" then
			pcall(function() newFile = readfile("Dark Admin/Scripts/" .. fileName) end)
			newFileName = fileName
		else
			pcall(function() newFile = readfile("Dark Admin/Scripts/".. fileName .. ".lua") end)
			newFileName = fileName .. ".lua"
		end
		if newFile then
			notify("Script Executed", newFileName)
			loadfile("Dark Admin/Scripts/" .. newFileName)()
		else
			notify("Script Error", "No File Found")
		end
	end
end)

newCmd("void", {}, "void [plr]", "Void a Player", function(args, speaker)
	if not tools(speaker) then return end
	local DestroySelfHumanoid = function()
		local Humanoid = Players.LocalPlayer.Character:FindFirstChildWhichIsA("Humanoid")
		if Humanoid then
			Humanoid:Remove()
			Instance.new("Humanoid", Players.LocalPlayer.Character)
		end
	end
	local users = getPlayer(args[1], speaker)
	for inde,vsup in pairs(users) do
		if Players[vsup].Character ~= nil then
			Players.LocalPlayer.Character.HumanoidRootPart.CFrame = Players.LocalPlayer.Character.HumanoidRootPart.CFrame + Vector3.new(99999999, 9999999, 9999999)
			local LPos2 = Players.LocalPlayer.Character.HumanoidRootPart.CFrame
			wait(0.015)
			DestroySelfHumanoid()
			wait(0.01)
			Players.LocalPlayer.Character.Humanoid:EquipTool(Players.LocalPlayer.Backpack:FindFirstChildOfClass("Tool"))
			wait(0.01)
			for _, v in pairs(workspace:GetDescendants()) do
				if v:IsA("Humanoid") and v ~= Players.LocalPlayer and v then
					Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v.RootPart.CFrame
					wait(0.03)
					Players.LocalPlayer.Character.HumanoidRootPart.CFrame = LPos2
				end
			end
		end
	end
end)

newCmd("car", {}, "car [speed]", "Become a literal car (Speed argument is optional, Default is 70)", function(args, speaker)
	if not speaker then return notify("Car", "Missing LocalPlayer") end
	if not speaker.Character then return notify("Car", "Missing Character") end
	if not speaker.Character:FindFirstChildWhichIsA("Humanoid") then return notify("Car", "Missing Humanoid") end
	if not speaker.Character:FindFirstChild("Animate") then return notify("Car", "Missing LocalAnimate") end
	local Human = speaker.Character:FindFirstChildWhichIsA("Humanoid")
	local carSpeed = tonumber(args[1]) or 70
	if Human.RigType == Enum.HumanoidRigType.R6 then
		Prote.SpoofProperty(Human, "WalkSpeed")
		Prote.SpoofProperty(Human, "JumpPower")
		Human.WalkSpeed = carSpeed
		Human.JumpPower = 0.0001
		Players.LocalPlayer.Character.Animate.walk.WalkAnim.AnimationId = "rbxassetid://129342287"
		Players.LocalPlayer.Character.Animate.run.RunAnim.AnimationId = "rbxassetid://129342287"
		Players.LocalPlayer.Character.Animate.fall.FallAnim.AnimationId = "rbxassetid://129342287"
		Players.LocalPlayer.Character.Animate.idle.Animation1.AnimationId = "rbxassetid://129342287"
		Players.LocalPlayer.Character.Animate.idle.Animation2.AnimationId = "rbxassetid://129342287"
		Players.LocalPlayer.Character.Animate.jump.JumpAnim.AnimationId = "rbxassetid://129342287"
		for i, thing in pairs(Players.LocalPlayer.Character:GetDescendants()) do
			if thing.ClassName == "Part" then
				Prote.SpoofProperty(thing, "CustomPhysicalProperties")
				thing.CustomPhysicalProperties = PhysicalProperties.new(0.04, 0, 0)
			end
		end
		Human.HipHeight = "-1.03"
	end
	if Human.RigType == Enum.HumanoidRigType.R15 then
		Prote.SpoofProperty(Human, "WalkSpeed")
		Prote.SpoofProperty(Human, "JumpPower")
		Human.WalkSpeed = carSpeed
		Human.JumpPower = 0.0001
		Players.LocalPlayer.Character.Animate.walk.WalkAnim.AnimationId = "rbxassetid://3360694441"
		Players.LocalPlayer.Character.Animate.run.RunAnim.AnimationId = "rbxassetid://3360694441"
		Players.LocalPlayer.Character.Animate.fall.FallAnim.AnimationId = "rbxassetid://3360694441"
		Players.LocalPlayer.Character.Animate.idle.Animation1.AnimationId = "rbxassetid://3360694441"
		Players.LocalPlayer.Character.Animate.idle.Animation2.AnimationId = "rbxassetid://3360694441"
		Players.LocalPlayer.Character.Animate.jump.JumpAnim.AnimationId = "rbxassetid://3360694441"
		for i, thing in pairs(Players.LocalPlayer.Character:GetDescendants()) do
			if thing.ClassName == "MeshPart" then
				Prote.SpoofProperty(thing, "CustomPhysicalProperties")
				thing.CustomPhysicalProperties = PhysicalProperties.new(0.04, 0, 0)
			end
		end
		Human.HipHeight = "0.56"
	end
end)

newCmd("autoclick", {}, "autoclick [click delay] [release delay]", "Automatically clicks your mouse with a set delay", function(args, speaker)
	if mouse1press and mouse1release then
		execCmd("unautoclick")
		wait()
		local clickDelay = 0.1
		local releaseDelay = 0.1
		if args[1] and isNumber(args[1]) then clickDelay = args[1] end
		if args[2] and isNumber(args[2]) then releaseDelay = args[2] end
		isAutoClicking = true
		AutoclickerInput = game:GetService("UserInputService").InputBegan:Connect(function(input, gameProcessedEvent)
			if not gameProcessedEvent then
				if (input.KeyCode == Enum.KeyCode.Backspace and game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.Equals)) or (input.KeyCode == Enum.KeyCode.Equals and game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.Backspace)) then
					isAutoClicking = false
					AutoclickerInput:Disconnect()
				end
			end
		end)
		notify("Auto Clicker", "Press [backspace] and [=] at the same time to stop")
		repeat wait(clickDelay)
			mouse1press()
			wait(releaseDelay)
			mouse1release()
		until isAutoClicking == false
	else
		notify("Incompatible Exploit", "Missing mouse1press and mouse1release")
	end
end)

newCmd("unautoclick", {}, "unautoclick", "Turns off autoclick", function(args, speaker)
	isAutoClicking = false
	if AutoclickerInput ~= nil then
		AutoclickerInput:Disconnect()
		AutoclickerInput = nil
	end
end)

newCmd("mousesensitivity", {"mousesens"}, "mousesensitivity / mousesens [0 - 10]", "Sets your Mouse Sensitivity to [num] (affects first person and right click drag) (Default is 1)", function(args, speaker)
	game:GetService("UserInputService").MouseDeltaSensitivity = tonumber(args[1]) or 1
end)

newCmd("autokeypress", {}, "autokeypress [key] [down delay] [up delay]", "Automatically presses a key with a set delay", function(args, speaker)
	if keypress and keyrelease and args[1] then
		local code = KeyCodeMap[tostring(args[1]):lower()]
		if not code then return notify("Auto Key Press", "Invalid Key") end
		execCmd("unautokeypress")
		wait()
		local clickDelay = 0.1
		local releaseDelay = 0.1
		if args[2] and isNumber(args[2]) then clickDelay = args[2] end
		if args[3] and isNumber(args[3]) then releaseDelay = args[3] end
		AutomaticKeyPressing = true
		AutoKeyPressInput = game:GetService("UserInputService").InputBegan:Connect(function(input, gameProcessedEvent)
			if not gameProcessedEvent then
				if (input.KeyCode == Enum.KeyCode.Backspace and game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.Equals)) or (input.KeyCode == Enum.KeyCode.Equals and game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.Backspace)) then
					AutomaticKeyPressing = false
					AutoKeyPressInput:Disconnect()
				end
			end
		end)
		notify("Auto Key Press", "Press [backspace] and [=] at the same time to stop")
		repeat wait(clickDelay)
			keypress(code)
			wait(releaseDelay)
			keyrelease(code)
		until AutomaticKeyPressing == false
		if AutoKeyPressInput then AutoKeyPressInput:Disconnect() keyrelease(code) end
	else
		notify("Incompatible Exploit", "Missing keypress and keyrelease")
	end
end)

newCmd("unautokeypress", {}, "unautokeypress", "Stops autokeypress", function(args, speaker)
	AutomaticKeyPressing = false
	if AutoKeyPressInput then
		AutoKeyPressInput:Disconnect()
		AutoKeyPressInput = nil
	end
end)

newCmd("clearcharappearance", {"clearchar", "clrchar"}, "clearcharappearance / clearchar / clrchar", "Removes all Accessories, Shirts, Pants, CharacterMesh, and BodyColors", function(args, speaker)
	speaker:ClearCharacterAppearance()
end)



VirtualEnvironment()
-- if Settings.AutoNet then SetSimulationRadius() end
spawn(function()
	if Settings.PluginsTable ~= nil or Settings.PluginsTable ~= {} then
		FindPlugins(Settings.PluginsTable)
	end
end)
wait(0.1)
notify("Loaded", ("Loaded in %.3f Seconds"):format((tick() or os.clock()) - StarterTick))
notify(Loaded_Title, "Prefix is " .. Settings.Prefix)
