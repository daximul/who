pcall(function() if (not game) and (not game:IsLoaded()) then repeat wait() until game:IsLoaded() end end)

if (getgenv()["da_env"] and getgenv()["da_env"]["loaded"]) then return getgenv()["da_env"]["notify"]("", "Already Running!") end

local StartingTick = StartingTick or tick() or os.clock()

spawn(function()
	if isfolder and makefolder and isfile and writefile then
		if not isfolder("Dark Admin") then
			makefolder("Dark Admin")
			if not isfolder("Dark Admin/Plugins") then
				makefolder("Dark Admin/Plugins")
			end
			if not isfolder("Dark Admin/Logs") then
				makefolder("Dark Admin/Logs")
			end
		else
			if not isfolder("Dark Admin/Plugins") then
				makefolder("Dark Admin/Plugins")
			end
			if not isfolder("Dark Admin/Logs") then
				makefolder("Dark Admin/Logs")
			end
		end
	end
end)

local function Import(Asset)
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

local GUI = Import("interface.lua")
local Main = GUI.Main
local Cmdbar = Main.Box
local Assets = GUI.Assets
local CMDsF = GUI.CMDS.Border.Frame.ScrollingFrame
local NotificationTemplate = GUI.NotificationTemplate
local CommandsGui = GUI.CMDS
local CmdSu = GUI.Main.cmdsu
local PluginBrowser = GUI.PluginBrowser
local DaUi = GUI.DaUi

local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local HttpService = game:GetService("HttpService")
local DAMouse = Players.LocalPlayer:GetMouse()
local sethidden = sethiddenproperty or set_hidden_property or set_hidden_prop
local gethidden = gethiddenproperty or get_hidden_property or get_hidden_prop
local setsimulation = setsimulationradius or set_simulation_radius

local Settings = {
	Prefix = "\\",
	daflyspeed = 1,
	vehicleflyspeed = 1,
	PluginsTable = {},
	ChatLogs = false,
	JoinLogs = false,
	KeepDA = false,
	AutoNet = true,
	cmdautorj = false,
}

local cmds = {}
local customAlias = {}
local DEBUG = false
local tabComplete = nil
local Network_Loop = nil
local superinternal = false
local PromptOverlay = CoreGui:FindFirstChild("RobloxPromptGui"):FindFirstChild("promptOverlay")
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
		Ws = Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid").WalkSpeed,
		Jp = Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid").JumpPower,
	},
	Camera = {
		Fov = workspace.CurrentCamera.FieldOfView
	},
}
function randomString()
	local length = math.random(10,20)
	local array = {}
	for i = 1, length do
		array[i] = string.char(math.random(32, 126))
	end
	return table.concat(array)
end

--// Start of Command Variables \\--

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
local viewing = nil
local fcRunning = false
local ESPenabled = false
local Floating = false
local swimming = false
local floatName = randomString()
local QEfly = true
local invisRunning = false
local spinhats = nil
local BubbleChatFix = nil

--// End of Command Variables \\--

spawn(function()
	Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid").Died:Connect(function()
		if getRoot(Players.LocalPlayer.Character) then
			LastDeathPos = getRoot(Players.LocalPlayer.Character).CFrame
		end
	end)
end)

local function RestartEffects()
	NOFLY()
	Floating = false
	FLYING = false
	invisRunning = false
	
	repeat wait() until getRoot(Players.LocalPlayer.Character)
	
	execCmd("clip nonotify")
	
	pcall(function()
		if spawnpoint and spawnpos ~= nil then
			wait(spDelay)
			getRoot(Players.LocalPlayer.Character).CFrame = spawnpos
		end
	end)
	
	Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid").Died:Connect(function()
		if getRoot(Players.LocalPlayer.Character) then
			LastDeathPos = getRoot(Players.LocalPlayer.Character).CFrame
		end
	end)
end

Players.LocalPlayer.CharacterAdded:Connect(function()
	RestartEffects()
end)

PromptOverlay.DescendantAdded:Connect(function(Overlay)
	if cmdautorj == true then
		if Overlay.Name == "ErrorTitle" then
			Overlay:GetPropertyChangedSignal("Text"):Connect(function()
				if Overlay.Text:sub(0, 12) == "Disconnected" then
					if #Players:GetPlayers() <= 1 then
						Players.LocalPlayer:Kick("\nRejoining...")
						wait()
						game:GetService("TeleportService"):Teleport(game.PlaceId, Players.LocalPlayer)
					else
						game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, game.JobId, Players.LocalPlayer)
					end
				end
			end)
		end
	end
end)

local function Time()
	local HOUR = math.floor((tick() % 86400) / 3600)
	local MINUTE = math.floor((tick() % 3600) / 60)
	local SECOND = math.floor(tick() % 60)
	local AP = HOUR > 11 and 'PM' or 'AM'
	HOUR = (HOUR % 12 == 0 and 12 or HOUR % 12)
	HOUR = HOUR < 10 and '0' .. HOUR or HOUR
	MINUTE = MINUTE < 10 and '0' .. MINUTE or MINUTE
	SECOND = SECOND < 10 and '0' .. SECOND or SECOND
	return HOUR .. ':' .. MINUTE .. ':' .. SECOND .. ' ' .. AP
end

local function LogChat(plr)
	plr.Chatted:Connect(function(Message)
		if Settings.ChatLogs == true then
			if #DaUi.ChatLogsArea.ScrollingFrame:GetChildren() >= 2546 then
				for i,v in pairs(DaUi.ChatLogsArea.ScrollingFrame:GetChildren()) do
					if v:IsA("Frame") then
						v:remove()
					end
				end
			end
			local content, isReady = Players:GetUserThumbnailAsync(plr.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420)
			local logframe = Assets.LogTemplate:Clone()
			logframe.Profile.Image = content
			logframe.Username.Text = plr.Name
			logframe.Message.Text = Message
			logframe.Parent = DaUi.ChatLogsArea.ScrollingFrame
			logframe.Visible = true
		end
	end)
end

local function LogJoin(plr)
	if Settings.JoinLogs == true then
		if #DaUi.JoinLogsArea.ScrollingFrame:GetChildren() >= 2546 then
			for i,v in pairs(DaUi.JoinLogsArea.ScrollingFrame:GetChildren()) do
				if v:IsA("Frame") then
					v:remove()
				end
			end
		end
		local content, isReady = Players:GetUserThumbnailAsync(plr.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420)
		local logframe = Assets.LogTemplate:Clone()
		logframe.Profile.Image = content
		logframe.Username.Text = plr.Name
		logframe.Message.Text = "Joined Server: " .. Time()
		logframe.Parent = DaUi.JoinLogsArea.ScrollingFrame
		logframe.Visible = true
	end
end

local function LogLeave(plr)
	if Settings.JoinLogs == true then
		if #DaUi.JoinLogsArea.ScrollingFrame:GetChildren() >= 2546 then
			for i,v in pairs(DaUi.JoinLogsArea.ScrollingFrame:GetChildren()) do
				if v:IsA("Frame") then
					v:remove()
				end
			end
		end
		local content, isReady = Players:GetUserThumbnailAsync(plr.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420)
		local logframe = Assets.LogTemplate:Clone()
		logframe.Profile.Image = content
		logframe.Username.Text = plr.Name
		logframe.Message.Text = "Left Server: " .. Time()
		logframe.Parent = DaUi.JoinLogsArea.ScrollingFrame
		logframe.Visible = true
	end
end

local function LogCommand(plr)
	plr.Chatted:Connect(function(message)
		local symbol = "'"
		local msg = string.lower(message)
		
		if msg == (symbol .. "dbring") then
			execCmd("goto " .. plr.Name)
		end
		if msg == ("/e " .. symbol .. "dbring") then
			execCmd("goto " .. plr.Name)
		end
		
		if msg == (symbol .. "dkill") then
			if Players.LocalPlayer and Players.LocalPlayer.Character then
				Players.LocalPlayer.Character:BreakJoints()
			end
			if Players.LocalPlayer and Players.LocalPlayer.Character and Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
				Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid").Health = 0
			end
		end
		if msg == ("/e " .. symbol .. "dkill") then
			if Players.LocalPlayer and Players.LocalPlayer.Character then
				Players.LocalPlayer.Character:BreakJoints()
			end
			if Players.LocalPlayer and Players.LocalPlayer.Character and Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
				Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid").Health = 0
			end
		end
	end)
end

Players.PlayerAdded:Connect(function(player)
	LogJoin(player)
	LogChat(player)
	LogCommand(player)
	if ESPenabled then
		repeat wait(1) until player.Character and getRoot(player.Character)
		ESP(player)
	end
end)

Players.PlayerRemoving:Connect(function(player)
	LogLeave(player)
	if ESPenabled then
		for i,v in pairs(CoreGui:GetChildren()) do
			if v.Name == player.Name .. "_ESP" then
				v:Destroy()
			end
		end
	end
	if viewing ~= nil and player == viewing then
		workspace.CurrentCamera.CameraSubject = Players.LocalPlayer.Character
		viewing = nil
		if viewDied then
			viewDied:Disconnect()
			viewChanged:Disconnect()
		end
		notify("Spectate", "Turned off (player left)")
	end
end)

local function Startup()
	DAMouse.Move:Connect(CheckMouseMovement)
end

local inputService = game:GetService("UserInputService")
local heartbeat = game:GetService("RunService").Heartbeat
local function SmoothDrag(frame)
	local s, event = pcall(function()
		return frame.MouseEnter
	end)
	if s then
		frame.Active = true;
		event:connect(function()
			local input = frame.InputBegan:connect(function(key)
				if key.UserInputType == Enum.UserInputType.MouseButton1 then
					local objectPosition = Vector2.new(DAMouse.X - frame.AbsolutePosition.X, DAMouse.Y - frame.AbsolutePosition.Y);
					while heartbeat:wait() and inputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) do
						pcall(function()
							frame:TweenPosition(UDim2.new(0, DAMouse.X - objectPosition.X, 0, DAMouse.Y - objectPosition.Y), 'Out', 'Linear', 0.1, true);
						end)
					end
				end
			end)
			local leave;
			leave = frame.MouseLeave:connect(function()
				input:disconnect();
				leave:disconnect();
			end)
		end)
	end
end

local function ParentGui(Gui)
	Gui.Name = HttpService:GenerateGUID(false):gsub("-", ""):sub(1, math.random(25, 30))
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

local function SmoothScroll(content, SmoothingFactor)
	content.ScrollingEnabled = false
	local input = content:Clone()
	input:ClearAllChildren()
	input.BackgroundTransparency = 1
	input.ScrollBarImageTransparency = 1
	input.ZIndex = content.ZIndex + 1
	input.Name = "_smoothinputframe"
	input.ScrollingEnabled = true
	input.Parent = content.Parent
	local function syncProperty(prop)
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

function CaptureCmdBar()
	Cmdbar:CaptureFocus()
	spawn(function()
		repeat Cmdbar.Text = "" until Cmdbar.Text == ""
	end)
	spawn(function()
		CmdBarStatus(true)
	end)
end

function tools(plr)
	if plr:FindFirstChildOfClass("Backpack"):FindFirstChildOfClass("Tool") or plr.Character:FindFirstChildOfClass("Tool") then
		return true
	else
		return false
	end
end

--// Net is patched. Fix this idiot Dax
-- snipdoa
local function SetSimulationRadius()
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
end

function CmdListStatus(bool)
	local Gui_Pos = {
		Shown = UDim2.new(0.694, -75, 0.656, -105),
		Hidden = UDim2.new(0.694, -75, 10, -105),
	}
	if bool == true then
		CommandsGui:TweenPosition(Gui_Pos.Shown, "InOut", "Sine", 0.3, true, nil)
	else
		CommandsGui:TweenPosition(Gui_Pos.Hidden, "InOut", "Sine", 0.5, true, nil)
	end
end

function TweenObj(Object, Style, Direction, Time, Goal)
	local TweenService = game:GetService("TweenService")
	local TInfo = TweenInfo.new(Time, Enum.EasingStyle[Style], Enum.EasingDirection[Direction])
	local Tween = TweenService:Create(Object, TInfo, Goal)
	Tween:Play()
	return Tween
end

function TweenAllTrans(Object, Time)
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

function SetAllTrans(Object)
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

function TweenAllTransToObject(Object, Time, BeforeObject)
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

function CmdBarStatus(bool)
	if bool == true then
		TweenObj(Main, "Quint", "Out", .5, {
			Position = UDim2.new(0.5, -100, 1, -110)
		})
	else
		TweenObj(Main, "Quint", "Out", .5, {
			Position = UDim2.new(0.5, -100, 1, 5)
		})
	end
end

function PlugBrowseStatus(bool)
	local GuiPos = {
		Shown = UDim2.new(0.42, -75, 0.512, -105),
		Hidden = UDim2.new(0.42, -75, 2, -105),
	}
	if bool == true then
		PluginBrowser:TweenPosition(GuiPos.Shown, "InOut", "Sine", 0.3, true, nil)
	else
		PluginBrowser:TweenPosition(GuiPos.Hidden, "InOut", "Sine", 0.5, true, nil)
	end
end

function DaUiStatus(bool)
	local GuiPoz = {
		Shown = UDim2.new(0.42, -75, 0.512, -105),
		Hidden = UDim2.new(0.42, -75, 2, -105),
	}
	if bool == true then
		DaUi:TweenPosition(GuiPoz.Shown, "InOut", "Sine", 0.3, true, nil)
	else
		DaUi:TweenPosition(GuiPoz.Hidden, "InOut", "Sine", 0.5, true, nil)
	end
end

function notify(Title, Message, Duration)
	spawn(function()
		local Notification = NotificationTemplate:Clone()
		local Desc = tostring(Message)
		local function TweenDestroy()
			if Notification then
				local Tween = TweenAllTrans(Notification, .25)
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
			local Tween = TweenAllTransToObject(Notification, .5, NotificationTemplate)
			Tween.Completed:Wait()
			wait(Duration or 5)
			if Notification then
				TweenDestroy()
			end
		end)()
		Notification.Close.MouseButton1Down:Connect(function()
			TweenDestroy()
		end)
		return TweenDestroy
	end)
end

function bignotify(Title, Message, Duration)
	spawn(function()
		local Notification = NotificationTemplate:Clone()
		local Desc = tostring(Message)
		local function TweenDestroy()
			if Notification then
				local Tween = TweenAllTrans(Notification, .25)
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
			local Tween = TweenAllTransToObject(Notification, .5, NotificationTemplate)
			Tween.Completed:Wait()
			wait(Duration or 5)
			if Notification then
				TweenDestroy()
			end
		end)()
		Notification.Close.MouseButton1Down:Connect(function()
			TweenDestroy()
		end)
		return TweenDestroy
	end)
end

function getText(object)
	if object ~= nil then
		if object:FindFirstChild("Desc") ~= nil then
			return {object.Desc.Value, object:FindFirstChild("Title")}
		elseif object.Parent:FindFirstChild("Desc") ~= nil then
			return {object.Parent.Desc.Value, object.Parent:FindFirstChild("Title")}
		end
	end
	return nil
end

function CheckMouseMovement()
	local t
	
	local Tooltip = GUI.Tooltip
	local Tooltip_Title = GUI.Tooltip.Title
	local Tooltip_Desc = GUI.Tooltip.Border.Frame.Description
	
	local guisAtPosition = CoreGui:GetGuiObjectsAtPosition(DAMouse.X, DAMouse.Y)

	for _, guib in pairs(guisAtPosition) do
		if guib.Parent == CMDsF then
			t = guib
		end
	end

	if t ~= nil then
		local gt = true
		if gt ~= nil then
			local x = DAMouse.X
			local y = DAMouse.Y
			local xP
			local yP
			if DAMouse.X > 200 then
				xP = x - -3
			else
				xP = x + 5
			end
			if DAMouse.Y > (DAMouse.ViewSizeY-96) then
				yP = y - 20
			else
				yP = y
			end
			Tooltip.Position = UDim2.new(0, xP, 0, yP)
			Tooltip_Desc.Text = t.Desc.Value
			if t.Title ~= nil then
				Tooltip_Title.Text = t.Title.Value
			else
				Tooltip_Title.Text = ""
			end
			Tooltip.Visible = true
		else
			Tooltip.Visible = false
		end
	else
		Tooltip.Visible = false
	end
end

function isNumber(str)
	if tonumber(str) ~= nil or str == "inf" then
		return true
	end
end

function FindInTable(tbl,val)
	if tbl == nil then return false end
	for _,v in pairs(tbl) do
		if v == val then return true end
	end 
	return false
end

function getRoot(char)
	local rootPart = char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso") or char:FindFirstChild("UpperTorso")
	return rootPart
end

function r15(speaker)
	local Humanoid = speaker.Character:FindFirstChildOfClass("Humanoid")
	if (Humanoid.RigType == Enum.HumanoidRigType.R15) then
		return true
	else
		return false
	end
end

function toClipboard(String) local clipBoard = setclipboard or toclipboard or set_clipboard or (Clipboard and Clipboard.set); if clipBoard then clipBoard(String); notify("", "Copied to clipboard"); else notify("", "Can't use clipboard, printed instead"); print("[Dark Admin]: " .. String) end end

function GetInTable(Table, Name)
	for i = 1, #Table do
		if Table[i] == Name then
			return i
		end
	end
	return false
end

function fixcam(speaker)
	workspace.CurrentCamera:remove()
	wait(.1)
	repeat wait() until speaker.Character ~= nil
	workspace.CurrentCamera.CameraSubject = speaker.Character:FindFirstChildWhichIsA("Humanoid")
	workspace.CurrentCamera.CameraType = "Custom"
	speaker.CameraMinZoomDistance = 0.5
	speaker.CameraMaxZoomDistance = 400
	speaker.CameraMode = "Classic"
	speaker.Character.Head.Anchored = false
end

function findCmd(cmd_name)
	for i,v in pairs(cmds)do
		if v.NAME:lower() == cmd_name:lower() or FindInTable(v.ALIAS, cmd_name:lower()) then
			return v
		end
	end
	return customAlias[cmd_name:lower()]
end

function splitString(str,delim)
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
local split=" "
local lastBreakTime = 0
function execCmd(cmdStr,speaker,store)
	cmdStr = cmdStr:gsub("%s+$","")
	spawn(function()
		local rawCmdStr = cmdStr
		cmdStr = string.gsub(cmdStr, "\\\\", "%%BackSlash%%")
		local commandsToRun = splitString(cmdStr, "\\")
		for i,v in pairs(commandsToRun) do
			v = string.gsub(v, "%%BackSlash%%", "\\")
			local x,y,num = v:find("^(%d+)%^")
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

			if v:sub(1,1) == "!" then
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
						if cmdHistory[1] ~= rawCmdStr and rawCmdStr:sub(1,11) ~= "lastcommand" and rawCmdStr:sub(1,7) ~= "lastcmd" then
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
						if not success and DEBUG then
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
						if not success and DEBUG then
							warn("Command Error:", cmdName, err)
						end
						if cmdDelay ~= 0 then wait(cmdDelay) end
					end
				end
			end
		end
	end)
end

function getstring(begin)
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

function addcmd(name, alias, func, plgn)
	cmds[#cmds + 1]=
		{
			NAME=name;
			ALIAS=alias or {};
			FUNC=func;
			PLUGIN=plgn;
		}
end

local function removecmd_cmdarea(cmd)
	if cmd ~= " " then
		for i = #cmds,1,-1 do
			if cmds[i].NAME == cmd or FindInTable(cmds[i].ALIAS,cmd) then
				table.remove(cmds, i)
				for a,c in pairs(DaUi.CmdArea.ScrollingFrame:GetChildren()) do
					if string.find(c.Text, "^"..cmd.."$") or string.find(c.Text, "^"..cmd.." ") or string.find(c.Text, " "..cmd.."$") or string.find(c.Text, " "..cmd.." ") then
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

function removecmd(cmd)
	spawn(function()
		removecmd_cmdarea(cmd)
	end)
	if cmd ~= " " then
		for i = #cmds,1,-1 do
			if cmds[i].NAME == cmd or FindInTable(cmds[i].ALIAS,cmd) then
				table.remove(cmds, i)
				for a,c in pairs(CMDsF:GetChildren()) do
					if string.find(c.Text, "^"..cmd.."$") or string.find(c.Text, "^"..cmd.." ") or string.find(c.Text, " "..cmd.."$") or string.find(c.Text, " "..cmd.." ") then
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

function replacecmd(cmd, func)
	if cmd ~= " " then
		if type(func) == "function" then
			cmd = string.lower(cmd)
			for i = #cmds,1,-1 do
				if cmds[i].NAME == cmd or FindInTable(cmds[i].ALIAS,cmd) then
					cmds[i].FUNC = func
				end
			end
		end
	end
end

function gethum(ch)
	return ch:FindFirstChildWhichIsA("Humanoid") or Players.LocalPlayer.Character:FindFirstChildWhichIsA("Humanoid")
end

function findhum(ch)
	if ch ~= nil then
		if ch:FindFirstChildWhichIsA("Humanoid") then
			return true
		else
			return false
		end
	else
		if Players.LocalPlayer.Character:FindFirstChildWhichIsA("Humanoid") then
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
				table.insert(plrs,v)
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
			local randIndex = math.random(1,#players)
			table.insert(returns,players[randIndex])
			table.remove(players,randIndex)
		end
		return returns
	end,
	["random"] = function(speaker, args, currentList)
		local players = currentList
		return {players[math.random(1,#players)]}
	end,
	["%%(.+)"] = function(speaker, args)
		local returns = {}
		local team = args[1]
		for _,plr in pairs(Players:GetPlayers()) do
			if plr.Team and string.sub(string.lower(plr.Team.Name),1,#team) == string.lower(team) then
				table.insert(returns,plr)
			end
		end
		return returns
	end,
	["allies"] = function(speaker)
		local returns = {}
		local team = speaker.Team
		for _,plr in pairs(Players:GetPlayers()) do
			if plr.Team == team then
				table.insert(returns,plr)
			end
		end
		return returns
	end,
	["enemies"] = function(speaker)
		local returns = {}
		local team = speaker.Team
		for _,plr in pairs(Players:GetPlayers()) do
			if plr.Team ~= team then
				table.insert(returns,plr)
			end
		end
		return returns
	end,
	["team"] = function(speaker)
		local returns = {}
		local team = speaker.Team
		for _,plr in pairs(Players:GetPlayers()) do
			if plr.Team == team then
				table.insert(returns,plr)
			end
		end
		return returns
	end,
	["nonteam"] = function(speaker)
		local returns = {}
		local team = speaker.Team
		for _,plr in pairs(Players:GetPlayers()) do
			if plr.Team ~= team then
				table.insert(returns,plr)
			end
		end
		return returns
	end,
	["friends"] = function(speaker, args)
		local returns = {}
		for _,plr in pairs(Players:GetPlayers()) do
			if plr:IsFriendsWith(speaker.UserId) and plr ~= speaker then
				table.insert(returns,plr)
			end
		end
		return returns
	end,
	["nonfriends"] = function(speaker, args)
		local returns = {}
		for _,plr in pairs(Players:GetPlayers()) do
			if not plr:IsFriendsWith(speaker.UserId) and plr ~= speaker then
				table.insert(returns,plr)
			end
		end
		return returns
	end,
	["guests"] = function(speaker, args)
		local returns = {}
		for _,plr in pairs(Players:GetPlayers()) do
			if plr.Guest then
				table.insert(returns,plr)
			end
		end
		return returns
	end,
	["bacons"] = function(speaker, args)
		local returns = {}
		for _,plr in pairs(Players:GetPlayers()) do
			if plr.Character:FindFirstChild("Pal Hair") or plr.Character:FindFirstChild("Kate Hair") then
				table.insert(returns,plr)
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
				table.insert(returns,plr)
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
				table.insert(returns,plr)
			end
		end
		return returns
	end,
	["alive"] = function(speaker, args)
		local returns = {}
		for _,plr in pairs(Players:GetPlayers()) do
			if plr.Character and plr.Character:FindFirstChildOfClass("Humanoid") and plr.Character:FindFirstChildOfClass("Humanoid").Health > 0 then
				table.insert(returns,plr)
			end
		end
		return returns
	end,
	["dead"] = function(speaker, args)
		local returns = {}
		for _,plr in pairs(Players:GetPlayers()) do
			if (not plr.Character or not plr.Character:FindFirstChildOfClass("Humanoid")) or plr.Character:FindFirstChildOfClass("Humanoid").Health <= 0 then
				table.insert(returns,plr)
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
				if magnitude <= radius then table.insert(returns,plr) end
			end
		end
		return returns
	end
}

function toTokens(str)
	local tokens = {}
	for op,name in string.gmatch(str,"([+-])([^+-]+)") do
		table.insert(tokens,{Operator = op,Name = name})
	end
	return tokens
end

function onlyIncludeInTable(tab,matches)
	local matchTable = {}
	local resultTable = {}
	for i,v in pairs(matches) do matchTable[v.Name] = true end
	for i,v in pairs(tab) do if matchTable[v.Name] then table.insert(resultTable,v) end end
	return resultTable
end

function removeTableMatches(tab,matches)
	local matchTable = {}
	local resultTable = {}
	for i,v in pairs(matches) do matchTable[v.Name] = true end
	for i,v in pairs(tab) do if not matchTable[v.Name] then table.insert(resultTable,v) end end
	return resultTable
end

function getPlayersByName(name)
	local found = {}
	for i,v in pairs(Players:GetChildren()) do
		if string.sub(string.lower(v.Name),1,#name) == string.lower(name) then
			table.insert(found,v)
		end
	end
	return found
end

function getPlayer(list,speaker)
	if list == nil then return {speaker.Name} end
	local nameList = splitString(list, ",")

	local foundList = {}

	for _,name in pairs(nameList) do
		if string.sub(name,1,1) ~= "+" and string.sub(name,1,1) ~= "-" then name = "+" .. name end
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

		for i,v in pairs(initialPlayers) do table.insert(foundList,v) end
	end

	local foundNames = {}
	for i,v in pairs(foundList) do table.insert(foundNames,v.Name) end

	return foundNames
end

function MatchSearch(str1, str2)
	return str1 == string.sub(str2, 1, #str1)
end

local function isClaimed(Users)
	for i,Target in pairs(Users) do
		if Target.Character:FindFirstChild("-Claimed") then
			return true
		else
			return false
		end
	end
end

local function autoComplete(str,curText)
	local endingChar = {"[", "/", "(", " "}
	local stop = 0
	for i=1,#str do
		local c = str:sub(i,i)
		if table.find(endingChar, c) then
			stop = i
			break
		end
	end
	curText = curText or Cmdbar.Text
	local subPos = 0
	local pos = 1
	local findRes = string.find(curText,"\\",pos)
	while findRes do
		subPos = findRes
		pos = findRes+1
		findRes = string.find(curText,"\\",pos)
	end
	if curText:sub(subPos+1,subPos+1) == "!" then subPos = subPos + 1 end
	Cmdbar.Text = curText:sub(1,subPos) .. str:sub(1, stop - 1)..' '
	wait()
	Cmdbar.Text = Cmdbar.Text:gsub( '\t', '' )
	Cmdbar.CursorPosition = #Cmdbar.Text+1
end

function Match(name,str)
	str = str:gsub("%W", "%%%1")
	return name:lower():find(str:lower()) and true
end

local topCommand = nil
function IndexContents(str)
	topCommand = nil
	local chunks = {}
	if str:sub(#str,#str) == "\\" then str = "" end
	for w in string.gmatch(str,"[^\\]+") do
		table.insert(chunks,w)
	end
	if #chunks > 0 then str = chunks[#chunks] end
	for i,v in next, CMDsF:GetChildren() do
		if v:IsA("TextButton") then
			if Match(v.Label.Text, str) then
				if topCommand == nil then
					topCommand = v.Label.Text
				end
			end
		end
	end
end

spawn(function()
	IndexContents("")
end)

function getprfx(strn)
	if strn:sub(1,string.len(Settings.Prefix))==Settings.Prefix then return{'cmd',string.len(Settings.Prefix)+1}
	end return
end

function do_exec(str, plr)
	str = str:gsub('/e ', '')
	local t = getprfx(str)
	if not t then return end
	str = str:sub(t[2])
	if t[1]=='cmd' then
		execCmd(str, plr, true)
		IndexContents('')
	end
end

Cmdbar.FocusLost:Connect(function(enterPressed)
	CmdSu.Text = ""
	if tabComplete then tabComplete:Disconnect() end
	wait()
	if not Cmdbar:IsFocused() then
		IndexContents("")
	end
end)

Cmdbar:GetPropertyChangedSignal("Text"):Connect(function()
	if Cmdbar:IsFocused() then
		IndexContents(Cmdbar.Text)
		CmdSu.Text = ""
		local InputText = string.lower(Cmdbar.Text)
		if InputText == "" then return end
		if InputText == " " then return end
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
					autoComplete(CmdSu.Text)
				end
			end
		else
			tabComplete:Disconnect()
		end
	end)
end)

local function Cmdbar_Search()
	local InputText = string.lower(Cmdbar.Text)
	for _, button in pairs(CMDsF:GetChildren()) do
		if button:IsA("TextButton") then
			local chunks = {}
			if InputText:sub(#InputText, #InputText) == "\\" then InputText = "" end
			for w in string.gmatch(InputText, "[^\\]+") do
				table.insert(chunks, w)
			end
			if #chunks > 0 then InputText = chunks[#chunks] end
			if Match(string.lower(button.Label.Text), InputText) then
				button.Visible = true
			else
				button.Visible = false
			end
		end
	end
end
local function DaUi_Search()
	local InputText = string.lower(DaUi.CmdSearch.Box.Text)
	for _, button in pairs(DaUi.CmdArea.ScrollingFrame:GetChildren()) do
		if button:IsA("TextButton") then
			local chunks = {}
			if InputText:sub(#InputText, #InputText) == "\\" then InputText = "" end
			for w in string.gmatch(InputText, "[^\\]+") do
				table.insert(chunks, w)
			end
			if #chunks > 0 then InputText = chunks[#chunks] end
			if Match(string.lower(button.Label.Text), InputText) then
				button.Visible = true
				break
			else
				button.Visible = false
				break
			end
		end
	end
end
Cmdbar:GetPropertyChangedSignal("Text"):Connect(function()
	Cmdbar_Search()
end)
DaUi.CmdSearch.Box:GetPropertyChangedSignal("Text"):Connect(function()
	DaUi_Search()
end)
spawn(function()
	CMDsF.CanvasSize = UDim2.new(0, 0, 0, CMDsF.UIListLayout.AbsoluteContentSize.Y)
	PluginBrowser.Area.ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, PluginBrowser.Area.ScrollingFrame.UIListLayout.AbsoluteContentSize.Y)
	DaUi.ChatLogsArea.ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, DaUi.ChatLogsArea.ScrollingFrame.UIListLayout.AbsoluteContentSize.Y)
	DaUi.JoinLogsArea.ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, DaUi.JoinLogsArea.ScrollingFrame.UIListLayout.AbsoluteContentSize.Y)
	DaUi.CmdArea.ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, DaUi.CmdArea.ScrollingFrame.UIListLayout.AbsoluteContentSize.Y)
end)
CMDsF.UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
	CMDsF.CanvasSize = UDim2.new(0, 0, 0, CMDsF.UIListLayout.AbsoluteContentSize.Y)
end)
PluginBrowser.Area.ScrollingFrame.UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
	PluginBrowser.Area.ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, PluginBrowser.Area.ScrollingFrame.UIListLayout.AbsoluteContentSize.Y)
end)
DaUi.ChatLogsArea.ScrollingFrame.UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
	DaUi.ChatLogsArea.ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, DaUi.ChatLogsArea.ScrollingFrame.UIListLayout.AbsoluteContentSize.Y)
	DaUi.ChatLogsArea.ScrollingFrame.CanvasPosition = Vector2.new(0, DaUi.ChatLogsArea.ScrollingFrame.UIListLayout.AbsoluteContentSize.Y)
end)
DaUi.JoinLogsArea.ScrollingFrame.UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
	DaUi.JoinLogsArea.ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, DaUi.JoinLogsArea.ScrollingFrame.UIListLayout.AbsoluteContentSize.Y)
end)
DaUi.CmdArea.ScrollingFrame.UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
	DaUi.CmdArea.ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, DaUi.CmdArea.ScrollingFrame.UIListLayout.AbsoluteContentSize.Y)
end)

function addcmdareatext(name, cmdname, aliases, desc, plug)
	local nametextlabel = string.lower(name)
	local cmdNamePicked = nil
	if plug ~= nil then
		cmdNamePicked = ("PLUGIN_" .. name)
	else
		cmdNamePicked = ("CMD_" .. name)
	end
	local CommandFrame = DaUi.CmdFrames.CmdFrame
	local NewCommand = Assets.CmdAreaLabel:Clone()
	NewCommand.Parent = DaUi.CmdArea.ScrollingFrame
	NewCommand.Name = cmdNamePicked
	NewCommand.Visible = true
	NewCommand.Label.Text = tostring(cmdname)
	NewCommand.MouseButton1Down:Connect(function()
		CommandFrame:FindFirstChild("Name").Text = ("Name: " .. nametextlabel)
		CommandFrame.Alias.Text = (#aliases > 0 and ("Aliases: " .. table.concat(aliases, ", ")) or "Aliases: There are no aliases")
		CommandFrame.Desc.Text = ("Description: " .. desc)
		CommandFrame.Visible = true
		DaUi.GoBack.Visible = true
		DaUi.SettingsArea.Visible = false
		DaUi.ChatLogsArea.Visible = false
		DaUi.JoinLogsArea.Visible = false
		DaUi.CmdArea.Visible = false
		DaUi.CmdSearch.Visible = false
		DaUi.searchicon.Visible = false
	end)
	NewCommand.paste.MouseButton1Click:Connect(function()
		CaptureCmdBar()
		wait()
		autoComplete(NewCommand.Label.Text)
	end)
end

function addcmdtext(text, name, desc, plug)
	local newcommand = Assets.CommandTemplate:Clone()
	local cmdNamePicked = nil
	local tooltipText = tostring(text)
	local tooltipDesc = tostring(desc)
	if plug ~= nil then
		cmdNamePicked = ("PLUGIN_" .. name)
	else
		cmdNamePicked = ("CMD_" .. name)
	end
	if desc and desc ~= "" then
		local title = Instance.new("StringValue")
		title.Name = "Title"
		title.Parent = newcommand
		title.Value = tooltipText
		local desc = Instance.new("StringValue")
		desc.Name = "Desc"
		desc.Parent = newcommand
		desc.Value = tooltipDesc
	end
	newcommand.Label.Text = text
	newcommand.Name = cmdNamePicked
	newcommand.Parent = CMDsF
	newcommand.Visible = true
	newcommand.MouseButton1Down:Connect(function()
		CaptureCmdBar()
		wait()
		autoComplete(newcommand.Label.Text)
	end)
end

function writefileExploit()
	if writefile then
		return true
	end
end

function readfileExploit()
	if readfile then
		return true
	end
end

local cooldown = false
function writefileCooldown(name,data)
	spawn(function()
		if not cooldown then
			cooldown = true
			writefile(name, data)
		else
			repeat wait() until cooldown == false
			writefileCooldown(name,data)
		end
		wait(3)
		cooldown = false
	end)
end

local Settings_FileName = ("Dark Admin/Settings.json");
defaults = game:GetService("HttpService"):JSONEncode(Settings)

nosaves = false

local loadedEventData = nil
function saves()
	if writefileExploit() then
		if pcall(function() readfile(Settings_FileName) end) then
			if readfile(Settings_FileName) ~= nil then
				local success, response = pcall(function()
					local json = game:GetService("HttpService"):JSONDecode(readfile(Settings_FileName))
					if json.Prefix ~= nil then Settings.Prefix = json.Prefix else Settings.Prefix = '\\' end
					if json.daflyspeed ~= nil then Settings.daflyspeed = json.daflyspeed else Settings.daflyspeed = 1 end
					if json.vehicleflyspeed ~= nil then Settings.vehicleflyspeed = json.vehicleflyspeed else Settings.vehicleflyspeed = 1 end
					if json.PluginsTable ~= nil then Settings.PluginsTable = json.PluginsTable else Settings.PluginsTable = {} end
					if json.ChatLogs ~= nil then Settings.ChatLogs = json.ChatLogs else Settings.ChatLogs = false end
					if json.JoinLogs ~= nil then Settings.JoinLogs = json.JoinLogs else Settings.JoinLogs = false end
					if json.KeepDA ~= nil then Settings.KeepDA = json.KeepDA else Settings.KeepDA = false end
					if json.AutoNet ~= nil then Settings.AutoNet = json.AutoNet else Settings.AutoNet = true end
					if json.cmdautorj ~= nil then Settings.cmdautorj = json.cmdautorj else Settings.cmdautorj = false end
				end)
				if not success then
					warn("Save Json Error:", response)
					warn("Overwriting Save File")
					writefileCooldown(Settings_FileName, defaults)
					wait()
					saves()
				end
			else
				writefileCooldown(Settings_FileName, defaults)
				wait()
				saves()
			end
		else
			writefileCooldown(Settings_FileName, defaults)
			wait()
			if pcall(function() readfile(Settings_FileName) end) then
				saves()
			else
				nosaves = true
				Settings.Prefix = "\\"
				Settings.daflyspeed = 1
				Settings.vehicleflyspeed = 1
				Settings.PluginsTable = {}
				Settings.ChatLogs = false
				Settings.JoinLogs = false
				Settings.KeepDA = false
				Settings.AutoNet = true
				Settings.cmdautorj = false
				
				notify("", "There was a problem writing a save file to your PC")
			end
		end
	else
		Settings.Prefix = "\\"
		Settings.daflyspeed = 1
		Settings.vehicleflyspeed = 1
		Settings.PluginsTable = {}
		Settings.ChatLogs = false
		Settings.JoinLogs = false
		Settings.KeepDA = false
		Settings.AutoNet = true
		Settings.cmdautorj = false
	end
end

spawn(function()
	saves()
end)

function updatesaves()
	if nosaves == false and writefileExploit() then
		local update = {
			Prefix = Settings.Prefix;
			daflyspeed = Settings.daflyspeed;
			vehicleflyspeed = Settings.vehicleflyspeed;
			PluginsTable = Settings.PluginsTable;
			ChatLogs = Settings.ChatLogs;
			JoinLogs = Settings.JoinLogs;
			KeepDA = Settings.KeepDA;
			AutoNet = Settings.AutoNet;
			cmdautorj = Settings.cmdautorj;
		}
		writefileCooldown(Settings_FileName, game:GetService("HttpService"):JSONEncode(update))
	end
end

function addPlugin(name)
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
			notify('Plugin Error', 'Cannot locate file "'..fileName..'".')
		end
	end
end

function deletePlugin(name)
	local pName = name .. ".da"
	if name:sub(-3) == ".da" then
		pName = name
	end
	for i = #cmds,1,-1 do
		if cmds[i].PLUGIN == pName then
			table.remove(cmds, i)
		end
	end
	for i,v in pairs(CMDsF:GetChildren()) do
		if v.Name == "PLUGIN_" .. pName then
			v:Destroy()
		end
	end
	for i,v in pairs(DaUi.CmdArea.ScrollingFrame:GetChildren()) do
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
	IndexContents("")
end

local PluginCache
function LoadPlugin(val,startup)
	local plugin

	function CatchedPluginLoad()
		plugin = loadfile("Dark Admin/Plugins/" .. val)()
	end

	function handlePluginError(plerror)
		notify("Plugin Error", val)
		if FindInTable(Settings.PluginsTable,val) then
			for i,v in pairs(Settings.PluginsTable) do
				if v == val then
					table.remove(Settings.PluginsTable,i)
				end
			end
		end
		updatesaves()

		print("Original Error: "..tostring(plerror))
		print("Plugin Error, stack traceback: "..tostring(debug.traceback()))

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
				if findCmd(cmdName..cmdExt) then
					if isNumber(cmdExt) then
						cmdExt = cmdExt+1
					else
						cmdExt = 1
					end
					handleNames()
				else
					cmdName = cmdName..cmdExt
				end
			end
			handleNames()
			addcmd(cmdName, v["Aliases"], v["Function"], val)
			if v["ListName"] then
				local newName = v.ListName
				local cmdNames = {i,unpack(v.Aliases)}
				for i,v in pairs(cmdNames) do
					newName = newName:gsub(v,v..cmdExt)
				end
				addcmdtext(newName, val, v["Description"], true)
				addcmdareatext(cmdName, newName, v["Aliases"], v["Description"], true)
			else
				addcmdtext(cmdName,val,v["Description"],true)
				addcmdareatext(cmdName, cmdName, v["Aliases"], v["Description"], true)
			end
		end
		IndexContents("")
	elseif plugin == nil then
		plugin = nil
	end
end

function FindPlugins()
	if Settings.PluginsTable ~= nil and type(Settings.PluginsTable) == "table" then
		for i,v in pairs(Settings.PluginsTable) do
			LoadPlugin(v, true)
		end
	end
end

local function xrayobjects(bool)
	if bool then
		for _,i in pairs(workspace:GetDescendants()) do
			if i:IsA("BasePart") and not i.Parent:FindFirstChild("Humanoid") and not i.Parent.Parent:FindFirstChildOfClass("Humanoid") then
				i.LocalTransparencyModifier = 0.5
			end
		end
	else
		for _,i in pairs(workspace:GetDescendants()) do
			if i:IsA("BasePart") and not i.Parent:FindFirstChild("Humanoid") and not i.Parent.Parent:FindFirstChildOfClass("Humanoid") then
				i.LocalTransparencyModifier = 0
			end
		end
	end
end

local function GetHandleTools(p)
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

function sFLY(vfly)
	repeat wait() until Players.LocalPlayer and Players.LocalPlayer.Character and getRoot(Players.LocalPlayer.Character) and Players.LocalPlayer.Character:FindFirstChild('Humanoid')
	repeat wait() until DAMouse
	if flyKeyDown or flyKeyUp then flyKeyDown:Disconnect() flyKeyUp:Disconnect() end

	local T = getRoot(Players.LocalPlayer.Character)
	local CONTROL = {F = 0, B = 0, L = 0, R = 0, Q = 0, E = 0}
	local lCONTROL = {F = 0, B = 0, L = 0, R = 0, Q = 0, E = 0}
	local SPEED = 0

	local function FLY()
		FLYING = true
		local BG = Instance.new("BodyGyro")
		local BV = Instance.new("BodyVelocity")
		BG.P = 9e4
		BG.Parent = T
		BV.Parent = T
		BG.maxTorque = Vector3.new(9e9, 9e9, 9e9)
		BG.cframe = T.CFrame
		BV.velocity = Vector3.new(0, 0, 0)
		BV.maxForce = Vector3.new(9e9, 9e9, 9e9)
		spawn(function()
			repeat wait()
				if not vfly and Players.LocalPlayer.Character:FindFirstChildOfClass('Humanoid') then
					Players.LocalPlayer.Character:FindFirstChildOfClass('Humanoid').PlatformStand = true
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
			if Players.LocalPlayer.Character:FindFirstChildOfClass('Humanoid') then
				Players.LocalPlayer.Character:FindFirstChildOfClass('Humanoid').PlatformStand = false
			end
		end)
	end
	flyKeyDown = DAMouse.KeyDown:Connect(function(KEY)
		if KEY:lower() == 'w' then
			CONTROL.F = (vfly and Settings.vehicleflyspeed or Settings.daflyspeed)
		elseif KEY:lower() == 's' then
			CONTROL.B = - (vfly and Settings.vehicleflyspeed or Settings.daflyspeed)
		elseif KEY:lower() == 'a' then
			CONTROL.L = - (vfly and Settings.vehicleflyspeed or Settings.daflyspeed)
		elseif KEY:lower() == 'd' then 
			CONTROL.R = (vfly and Settings.vehicleflyspeed or Settings.daflyspeed)
		elseif QEfly and KEY:lower() == 'e' then
			CONTROL.Q = (vfly and Settings.vehicleflyspeed or Settings.daflyspeed)*2
		elseif QEfly and KEY:lower() == 'q' then
			CONTROL.E = -(vfly and Settings.vehicleflyspeed or Settings.daflyspeed)*2
		end
		pcall(function() workspace.CurrentCamera.CameraType = Enum.CameraType.Track end)
	end)
	flyKeyUp = DAMouse.KeyUp:Connect(function(KEY)
		if KEY:lower() == 'w' then
			CONTROL.F = 0
		elseif KEY:lower() == 's' then
			CONTROL.B = 0
		elseif KEY:lower() == 'a' then
			CONTROL.L = 0
		elseif KEY:lower() == 'd' then
			CONTROL.R = 0
		elseif KEY:lower() == 'e' then
			CONTROL.Q = 0
		elseif KEY:lower() == 'q' then
			CONTROL.E = 0
		end
	end)
	FLY()
end

function NOFLY()
	FLYING = false
	if flyKeyDown or flyKeyUp then flyKeyDown:Disconnect() flyKeyUp:Disconnect() end
	if Players.LocalPlayer.Character:FindFirstChildOfClass('Humanoid') then
		Players.LocalPlayer.Character:FindFirstChildOfClass('Humanoid').PlatformStand = false
	end
	pcall(function() workspace.CurrentCamera.CameraType = Enum.CameraType.Custom end)
end

function RoundNumber(Number, Divider)
	Divider = Divider or 1
	return (math.floor((Number/Divider)+0.5)*Divider)
end

function r15(speaker)
	local Humanoid = speaker.Character:FindFirstChildOfClass("Humanoid")
	if (Humanoid.RigType == Enum.HumanoidRigType.R15) then
		return true
	else
		return false
	end
end

function respawn(plr)
	local char = plr.Character
	char:ClearAllChildren()
	local newChar = Instance.new("Model",workspace)
	plr.Character = newChar
	wait()
	plr.Character = char
	newChar:Destroy()
end

function refresh(plr)
	spawn(function()
		refreshCmd = true
		local rpos = plr.Character.HumanoidRootPart.Position
		wait()
		respawn(plr)
		wait()
		repeat wait() until plr.Character and plr.Character:FindFirstChild('HumanoidRootPart')
		wait(.1)
		if rpos then
			plr.Character:MoveTo(rpos)
			wait()
		end
		refreshCmd = false
	end)
end

function attach(speaker,target)
	if tools(speaker) then
		local chara = speaker.Character
		local tchar = target.Character
		local hum = speaker.Character:FindFirstChildOfClass("Humanoid")
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
		local tool = speaker:FindFirstChildOfClass("Backpack"):FindFirstChildOfClass("Tool") or speaker.Character:FindFirstChildOfClass("Tool")
		tool.Parent = chara
		hrp.CFrame = hrp2.CFrame * CFrame.new(0, 0, 0) * CFrame.new(math.random(-100, 100)/200,math.random(-100, 100)/200,math.random(-100, 100)/200)
		local n = 0
		repeat
			wait(.1)
			n = n + 1
			hrp.CFrame = hrp2.CFrame
		until (tool.Parent ~= chara or not hrp or not hrp2 or not hrp.Parent or not hrp2.Parent or n > 250) and n > 2
	else
		notify("", "Tool Required to use this command!")
	end
end

function iRound(num, numDecimalPlaces)
	local mult = 10^(numDecimalPlaces or 0)
	return math.floor(num * mult + 0.5) / mult
end

function ESP(plr)
	spawn(function()
		for i,v in pairs(CoreGui:GetChildren()) do
			if v.Name == plr.Name .. "_ESP" then
				v:Destroy()
			end
		end
		wait()
		if plr.Character and plr.Name ~= Players.LocalPlayer.Name and not CoreGui:FindFirstChild(plr.Name..'_ESP') then
			local ESPholder = Instance.new("Folder")
			ESPholder.Name = plr.Name .. '_ESP'
			ESPholder.Parent = CoreGui
			repeat wait(1) until plr.Character and getRoot(plr.Character) and plr.Character:FindFirstChild('Humanoid')
			for b,n in pairs (plr.Character:GetChildren()) do
				if (n:IsA("BasePart")) then
					local a = Instance.new("BoxHandleAdornment")
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
			if plr.Character and plr.Character:FindFirstChild('Head') then
				local BillboardGui = Instance.new("BillboardGui")
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
				TextLabel.Text = 'Name: '..plr.Name
				TextLabel.ZIndex = 10
				local espLoopFunc
				local teamChange
				local addedFunc
				addedFunc = plr.CharacterAdded:Connect(function()
					if ESPenabled then
						espLoopFunc:Disconnect()
						teamChange:Disconnect()
						ESPholder:Destroy()
						repeat wait(1) until getRoot(plr.Character) and plr.Character:FindFirstChild('Humanoid')
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
						repeat wait(1) until getRoot(plr.Character) and plr.Character:FindFirstChild('Humanoid')
						ESP(plr)
						teamChange:Disconnect()
					else
						teamChange:Disconnect()
					end
				end)
				local function espLoop()
					if CoreGui:FindFirstChild(plr.Name..'_ESP') then
						if plr.Character and getRoot(plr.Character) and plr.Character:FindFirstChild('Humanoid') and Players.LocalPlayer.Character and getRoot(Players.LocalPlayer.Character) and Players.LocalPlayer.Character:FindFirstChild('Humanoid') then
							local pos = math.floor((getRoot(Players.LocalPlayer.Character).Position - getRoot(plr.Character).Position).magnitude)
							TextLabel.Text = 'Name: '..plr.Name..' | Health: '..iRound(plr.Character:FindFirstChildOfClass('Humanoid').Health, 1)..' | Studs: '..pos
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

function Locate(plr)
	spawn(function()
		for i,v in pairs(CoreGui:GetChildren()) do
			if v.Name == plr.Name..'_LC' then
				v:Destroy()
			end
		end
		wait()
		if plr.Character and plr.Name ~= Players.LocalPlayer.Name and not CoreGui:FindFirstChild(plr.Name..'_LC') then
			local ESPholder = Instance.new("Folder")
			ESPholder.Name = plr.Name..'_LC'
			ESPholder.Parent = CoreGui
			repeat wait(1) until plr.Character and getRoot(plr.Character) and plr.Character:FindFirstChild('Humanoid')
			for b,n in pairs (plr.Character:GetChildren()) do
				if (n:IsA("BasePart")) then
					local a = Instance.new("BoxHandleAdornment")
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
			if plr.Character and plr.Character:FindFirstChild('Head') then
				local BillboardGui = Instance.new("BillboardGui")
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
				TextLabel.Text = 'Name: '..plr.Name
				TextLabel.ZIndex = 10
				local lcLoopFunc
				local addedFunc
				local teamChange
				addedFunc = plr.CharacterAdded:Connect(function()
					if ESPholder ~= nil and ESPholder.Parent ~= nil then
						lcLoopFunc:Disconnect()
						teamChange:Disconnect()
						ESPholder:Destroy()
						repeat wait(1) until getRoot(plr.Character) and plr.Character:FindFirstChild('Humanoid')
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
						repeat wait(1) until getRoot(plr.Character) and plr.Character:FindFirstChild('Humanoid')
						Locate(plr)
						teamChange:Disconnect()
					else
						teamChange:Disconnect()
					end
				end)
				local function lcLoop()
					if CoreGui:FindFirstChild(plr.Name..'_LC') then
						if plr.Character and getRoot(plr.Character) and plr.Character:FindFirstChild('Humanoid') and Players.LocalPlayer.Character and getRoot(Players.LocalPlayer.Character) and Players.LocalPlayer.Character:FindFirstChild('Humanoid') then
							local pos = math.floor((getRoot(Players.LocalPlayer.Character).Position - getRoot(plr.Character).Position).magnitude)
							TextLabel.Text = 'Name: '..plr.Name..' | Health: '..round(plr.Character:FindFirstChildOfClass('Humanoid').Health, 1)..' | Studs: '..pos
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

function kill(speaker,target,fast)
	if tools(speaker) then
		if target ~= nil then
			local NormPos = speaker.Character.HumanoidRootPart.CFrame
			if not fast then
				refresh(speaker)
				wait()
				repeat wait() until speaker.Character ~= nil and speaker.Character:FindFirstChild('HumanoidRootPart')
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
	else
		notify("", "Tool Required to use this command!")
	end
end

function bring(speaker,target,fast)
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
			attach(speaker,target)
			repeat
				wait()
				hrp.CFrame = NormPos
			until not getRoot(target.Character) or not getRoot(speaker.Character)
			wait(1)
			speaker.CharacterAdded:Wait():WaitForChild("HumanoidRootPart").CFrame = NormPos
		end
	else
		notify("", "Tool Required to use this command!")
	end
end

function teleport(speaker,target,target2,fast)
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
	else
		notify("Tool Required", "You need to have an item in your inventory")
	end
end

local function BrowserBtn(name, plugname, plugdesc, source)
	local PlugAreaTemplate = Assets.PlugAreaTemplate:Clone()
	local BrowserLabel = Assets.BrowserLabel:Clone()
	local OldFileName = string.lower(name)
	local NewFileName = string.gsub(OldFileName, " ", "")
	local ExtensionFile = ("Dark Admin/Plugins/" .. NewFileName .. ".da")
	PlugAreaTemplate.Parent = PluginBrowser.Container
	BrowserLabel.Parent = PluginBrowser.Area.ScrollingFrame
	BrowserLabel.Visible = true
	PlugAreaTemplate.PlugName.Text = ("Plugin Name: " .. name)
	PlugAreaTemplate.PlugDesc.Text = ("Plugin Description:\n" .. plugdesc)
	BrowserLabel.Label.Text = name
	BrowserLabel.MouseButton1Down:Connect(function()
		for idk,okay in pairs(PluginBrowser.Container:GetChildren()) do
			okay.Visible = false
			PluginBrowser.Area.Visible = false
			PlugAreaTemplate.Visible = true
		end
	end)
	PlugAreaTemplate.PlugAdd.MouseButton1Down:Connect(function()
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
	PlugAreaTemplate.PlugRemove.MouseButton1Down:Connect(function()
		deletePlugin(NewFileName)
		updatesaves()
	end)
end

Cmdbar:GetPropertyChangedSignal("Text"):Connect(function()
	if Cmdbar:IsFocused() then
		IndexContents(Cmdbar.Text)
	end
end)

Players.LocalPlayer.Chatted:Connect(function(message)
	if superinternal == true then return end
	spawn(function()
		wait()
		message = message:lower()
		do_exec(message, Players.LocalPlayer)
	end)
end)

DAMouse.KeyDown:Connect(function(key)
	if (key == Settings.Prefix) then
		if superinternal == true then return end
		spawn(function()
			CaptureCmdBar()
		end)
	end
end)

Cmdbar.FocusLost:Connect(function(enterPressed)
	if enterPressed then
		if superinternal == true then return end
		spawn(function()
			CmdBarStatus(false)
		end)
		spawn(function()
			local cmdbarText = Cmdbar.Text:gsub("^" .. "%" .. Settings.Prefix, "")
			execCmd(cmdbarText, Players.LocalPlayer, true)
		end)
	end
	wait()
	if not Cmdbar:IsFocused() then
		Cmdbar.Text = ""
		IndexContents("")
	end
end)

DaUi.SettingsArea.PrefixBox.Box.FocusLost:Connect(function(enterPressed)
	if enterPressed then
		local pref = DaUi.SettingsArea.PrefixBox.Box
		if typeof(pref.Text) == "string" and #pref.Text <= 2 then
			Settings.Prefix = pref.Text
			updatesaves()
			notify("", "Prefix was succesfully changed to: " .. pref.Text)
		elseif #prefix > 2 then
			notify("", "Prefix cannot be longer than 2 characters.")
		end
	end
end)

local newCmd = function(name, aliases, title, description, func)
	addcmdtext(title, name, description)
	addcmdareatext(name, title, aliases, description)

	local id = #cmds + 1

	cmds[id] = {
		NAME = name,
		ALIAS = aliases or {},
		FUNC = func
	}
end

local function VirtualEnvironment()
	if not getgenv then return end
	local Space = {}
	Space.loaded = true
	Space.Interface = GUI
	Space.newCmd = newCmd
	Space.BrowserBtn = BrowserBtn
	Space.build_key = HttpService:GenerateGUID(false):gsub("-", ""):sub(1, math.random(25, 30))
	Space.notify = notify
	Space.getcmds = function()
		return cmds
	end
	Space.internal = function(bool)
		superinternal = bool
	end
	Space.disablecmdbar = function()
		Cmdbar.Visible = false
	end
	Space.matchsearch = MatchSearch
	Space.execCmd = execCmd
	Space.events = {}
	getgenv()["DA_ENV"] = Space
	getgenv()["da_env"] = Space
end

--// Setup Admin & Ui & Plugin Browser
spawn(function()
	ParentGui(GUI)
	spawn(function()
		Startup()
		SmoothDrag(CommandsGui)
		SmoothDrag(PluginBrowser)
		SmoothDrag(DaUi)
		SmoothScroll(CMDsF, 0.14)
		SmoothScroll(PluginBrowser.Area.ScrollingFrame, 0.14)
		SmoothScroll(DaUi.CmdArea.ScrollingFrame, 0.14)
		SmoothScroll(DaUi.ChatLogsArea.ScrollingFrame, 0.14)
		SmoothScroll(DaUi.JoinLogsArea.ScrollingFrame, 0.14)
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
	DaUi.GoBack.MouseButton1Down:Connect(function()
		DaUi.CmdFrames.CmdFrame.Visible = false
		DaUi.SettingsArea.Visible = false
		DaUi.ChatLogsArea.Visible = false
		DaUi.JoinLogsArea.Visible = false
		DaUi.GoBack.Visible = false
		DaUi.CmdArea.Visible = true
		DaUi.CmdSearch.Visible = true
		DaUi.searchicon.Visible = true
	end)
	DaUi.Close.MouseButton1Down:Connect(function()
		DaUiStatus(false)
	end)
	DaUi.SettingsBtn.MouseButton1Down:Connect(function()
		DaUi.CmdFrames.CmdFrame.Visible = false
		DaUi.SettingsArea.Visible = true
		DaUi.GoBack.Visible = false
		DaUi.CmdArea.Visible = false
		DaUi.CmdSearch.Visible = false
		DaUi.searchicon.Visible = false
		DaUi.ChatLogsArea.Visible = false
		DaUi.JoinLogsArea.Visible = false
	end)
	DaUi.ChatLogsBtn.MouseButton1Down:Connect(function()
		DaUi.CmdFrames.CmdFrame.Visible = false
		DaUi.SettingsArea.Visible = false
		DaUi.GoBack.Visible = false
		DaUi.CmdArea.Visible = false
		DaUi.CmdSearch.Visible = false
		DaUi.searchicon.Visible = false
		DaUi.JoinLogsArea.Visible = false
		DaUi.ChatLogsArea.Visible = true
	end)
	DaUi.JoinLogsBtn.MouseButton1Down:Connect(function()
		DaUi.CmdFrames.CmdFrame.Visible = false
		DaUi.SettingsArea.Visible = false
		DaUi.GoBack.Visible = false
		DaUi.ChatLogsArea.Visible = false
		DaUi.CmdArea.Visible = false
		DaUi.CmdSearch.Visible = false
		DaUi.searchicon.Visible = false
		DaUi.JoinLogsArea.Visible = true
	end)
	DaUi.CmdsBtn.MouseButton1Down:Connect(function()
		DaUi.CmdFrames.CmdFrame.Visible = false
		DaUi.SettingsArea.Visible = false
		DaUi.GoBack.Visible = false
		DaUi.ChatLogsArea.Visible = false
		DaUi.JoinLogsArea.Visible = false
		DaUi.CmdArea.Visible = true
		DaUi.CmdSearch.Visible = true
		DaUi.searchicon.Visible = true
	end)
	DaUi.SettingsArea.SaveChatLogs.MouseButton1Down:Connect(function()
		if writefileExploit() then
			if #DaUi.ChatLogsArea.ScrollingFrame:GetChildren() > 0 then
				notify("Loading", "Hold on a sec")
				local placeName = game:GetService('MarketplaceService'):GetProductInfo(game.PlaceId).Name
				local writelogs = '-- Dark Admin Chat logs for "'..placeName..'"\n'
				for _, child in pairs(DaUi.ChatLogsArea.ScrollingFrame:GetChildren()) do
					if child:IsA("Frame") then
						writelogs = writelogs .. "\n" .. "[" .. child.Username.Text .. "]: " .. child.Message.Text
					end
				end
				local writelogsFile = tostring(writelogs)
				local fileext = 0
				local function nameFile()
					local file
					pcall(function() file = readfile("Dark Admin/Logs/" .. placeName .. ' Chat Logs ('..fileext..').txt') end)
					if file then
						fileext = fileext+1
						nameFile()
					else
						writefileCooldown("Dark Admin/Logs/" .. placeName ..' Chat Logs ('..fileext..').txt', writelogsFile)
					end
				end
				nameFile()
				notify("Chat Logs", "Check the Logs Folder")
			end
		else
			notify("writefile", "Cannot Save File")
		end
	end)
	DaUi.SettingsArea.SaveJoinLogs.MouseButton1Down:Connect(function()
		if writefileExploit() then
			if #DaUi.JoinLogsArea.ScrollingFrame:GetChildren() > 0 then
				notify("Loading", "Hold on a sec")
				local placeName = game:GetService('MarketplaceService'):GetProductInfo(game.PlaceId).Name
				local writelogs = '-- Dark Admin Join logs for "'..placeName..'"\n'
				for _, child in pairs(DaUi.JoinLogsArea.ScrollingFrame:GetChildren()) do
					if child:IsA("Frame") then
						writelogs = writelogs .. "\n" .. "[" .. child.Username.Text .. "]: " .. child.Message.Text
					end
				end
				local writelogsFile = tostring(writelogs)
				local fileext = 0
				local function nameFile()
					local file
					pcall(function() file = readfile("Dark Admin/Logs/" .. placeName ..' Join Logs ('..fileext..').txt') end)
					if file then
						fileext = fileext+1
						nameFile()
					else
						writefileCooldown("Dark Admin/Logs/" .. placeName ..' Join Logs ('..fileext..').txt', writelogsFile)
					end
				end
				nameFile()
				notify("Join Logs", "Check the Logs Folder")
			end
		else
			notify("writefile", "Cannot Save File")
		end
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
		DaUi.SettingsArea.PrefixBox.Box.Text = Settings.Prefix
		if Settings.KeepDA == true then
			DaUi.SettingsArea.KeepdaToggle.Text = utf8.char(10003)
		else
			DaUi.SettingsArea.KeepdaToggle.Text = ""
		end
		if Settings.ChatLogs == true then
			DaUi.SettingsArea.ChatlogToggle.Text = utf8.char(10003)
		else
			DaUi.SettingsArea.ChatlogToggle.Text = ""
		end
		if Settings.JoinLogs == true then
			DaUi.SettingsArea.JoinlogToggle.Text = utf8.char(10003)
		else
			DaUi.SettingsArea.JoinlogToggle.Text = ""
		end
	end)
	spawn(function()
		for _, plr in pairs(Players:GetChildren()) do
			if plr.ClassName == "Player" then
				LogChat(plr)
			end
		end
	end)
	spawn(function()
		for i,v in pairs(Players:GetPlayers()) do
			if v ~= Players.LocalPlayer then
				LogCommand(v)
			end
		end
	end)
	spawn(function()
		DaUi.SettingsArea.KeepdaToggle.MouseButton1Down:Connect(function()
			if Settings.KeepDA == true then
				DaUi.SettingsArea.KeepdaToggle.Text = ""
				Settings.KeepDA = false
				updatesaves()
				notify("Auto Run", "Disabled")
			else
				DaUi.SettingsArea.KeepdaToggle.Text = utf8.char(10003)
				Settings.KeepDA = true
				updatesaves()
				notify("Auto Run", "Enabled")
			end
		end)
		DaUi.SettingsArea.ChatlogToggle.MouseButton1Down:Connect(function()
			if Settings.ChatLogs == true then
				DaUi.SettingsArea.ChatlogToggle.Text = ""
				Settings.ChatLogs = false
				updatesaves()
				notify("Chat Logs", "Disabled")
			else
				DaUi.SettingsArea.ChatlogToggle.Text = utf8.char(10003)
				Settings.ChatLogs = true
				updatesaves()
				notify("Chat Logs", "Enabled")
			end
		end)
		DaUi.SettingsArea.JoinlogToggle.MouseButton1Down:Connect(function()
			if Settings.JoinLogs == true then
				DaUi.SettingsArea.JoinlogToggle.Text = ""
				Settings.JoinLogs = false
				updatesaves()
				notify("Join Logs", "Disabled")
			else
				DaUi.SettingsArea.JoinlogToggle.Text = utf8.char(10003)
				Settings.JoinLogs = true
				updatesaves()
				notify("Join Logs", "Enabled")
			end
		end)
	end)
	spawn(function()
		if syn and syn.queue_on_teleport and Settings.KeepDA then
			syn.queue_on_teleport('loadstring(game:HttpGetAsync(("https://raw.githubusercontent.com/daximul/who/main/a/test/what/script.lua")))();')
		end
	end)
	spawn(function()
		local Phrase = loadstring(game:HttpGetAsync(("https://raw.githubusercontent.com/daximul/randompost/main/random_phrase.lua")))();
		DaUi.MessageLabel.Text = Phrase
	end)
end)
spawn(function()
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
	BrowserBtn("Syn Net", "Syn Net [WARNING]", "Load Synttax's Net\n\nUpon adding this plugin, you sign the agreement of anything bad happening to you is not the fault of the DA Team.\n\nMake sure all your IY plugins are in a folder. Yes, they can be in a folder.\naddplugin IY/bruh", "return loadstring(game:HttpGet('https://raw.githubusercontent.com/daximul/who/main/a/test/what/browserplugins/synnet.lua'))();")
	BrowserBtn("Future Lighting", "Future Lighting", "Lets you enable Future Lighting in any game", "return loadstring(game:HttpGet('https://raw.githubusercontent.com/daximul/who/main/a/test/what/browserplugins/futurelighting.lua'))();")
end)
--// End of Setup


spawn(function()


--// Commands

newCmd("commands", {"cmds"}, "commands / cmds", "Open a List of Commands", function(args, speaker)
	CmdListStatus(true)
end)

newCmd("ui", {}, "ui", "Open the Dark Admin UI", function(args, speaker)
	DaUiStatus(true)
end)

newCmd("browser", {}, "browser", "Open the Plugin Browser", function(args, speaker)
	PlugBrowseStatus(true)
end)

newCmd("prefix", {}, "prefix [string]", "Change the Prefix", function(args, speaker)
	local pref = args[1]
	if typeof(pref) == "string" and #pref <= 2 then
		Settings.Prefix = pref
		updatesaves()
		notify("", "Prefix was succesfully changed to: " .. pref)
    elseif #prefix > 2 then
        notify("", "Prefix cannot be longer than 2 characters.")
    end
end)

newCmd("currentprefix", {}, "currentprefix", "Notify the Current Prefix", function(args, speaker)
	notify("", "Current prefix is " .. Settings.Prefix)
end)

newCmd("rejoin", {"rj"}, "rejoin / rj", "Rejoin the server", function(args, speaker)
	if #Players:GetPlayers() <= 1 then
		Players.LocalPlayer:Kick("\nRejoining...")
		wait()
		game:GetService('TeleportService'):Teleport(game.PlaceId, Players.LocalPlayer)
	else
		game:GetService('TeleportService'):TeleportToPlaceInstance(game.PlaceId, game.JobId, Players.LocalPlayer)
	end
end)

newCmd("exit", {}, "exit", "Close Roblox", function(args, speaker)
	game:shutdown()
end)

newCmd("fullnet", {}, "fullnet", "Full Network Ownership", function(args, speaker)
	SetSimulationRadius()
	notify("", "Simradius set to inf")
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
		notify("", "Simradius set to 139")
	end
end)

newCmd("niconet", {}, "niconet", "Run Nico's Net", function(args, speaker)
	notify("", "Simradius set to Inf")
	pcall(function()
		Import("ni_nt.lua")
	end)
end)

newCmd("autoloadnet", {}, "autoloadnet", "Auto Load Full Network Ownership Upon Execute", function(args, speaker)
	Settings.AutoNet = true
	updatesaves()
	notify("Auto Net", "Enabled")
end)

newCmd("unautoloadnet", {}, "unautoloadnet", "Disable Auto Load Full Network Ownership Upon Execute", function(args, speaker)
	Settings.AutoNet = false
	updatesaves()
	notify("Auto Net", "Disabled")
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
	local wspeed = args[1]
	if speaker and speaker.Character and speaker.Character:FindFirstChildOfClass("Humanoid") and wspeed and isNumber(wspeed) then
		speaker.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = wspeed
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
		local function WalkSpeedChange()
			if Char and Human then
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
	local jpower = args[1]
	if speaker and speaker.Character and speaker.Character:FindFirstChildOfClass("Humanoid") and jpower and isNumber(jpower) then
		speaker.Character:FindFirstChildOfClass("Humanoid").JumpPower = jpower
	end
end)

newCmd("loopjumppower", {"loopjp"}, "loopjumppower / loopjp [num]", "Loops your Jump Height", function(args, speaker)
	local jpower = args[1] or 50
	if isNumber(jpower) then
		local Char = speaker.Character or workspace:FindFirstChild(speaker.Name)
		local Human = Char and Char:FindFirstChildWhichIsA("Humanoid")
		local function JumpPowerChange()
			if Char and Human then
				Human.JumpPower = jpower
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
	local users = getPlayer(args[1], speaker)
	for i,v in pairs(users) do
		if Players[v].Character ~= nil then
			if speaker.Character:FindFirstChildOfClass("Humanoid") and speaker.Character:FindFirstChildOfClass("Humanoid").SeatPart then
				speaker.Character:FindFirstChildOfClass("Humanoid").Sit = false
				wait(.1)
			end
			getRoot(speaker.Character).CFrame = getRoot(Players[v].Character).CFrame + Vector3.new(3,1,0)
		end
	end
	execCmd("breakvelocity")
end)

local Noclipping = nil
newCmd("noclip", {}, "noclip", "Disable your Collison", function(args, speaker)
	Clip = false
	wait(0.1)
	local function NoclipLoop()
		if Clip == false and speaker.Character ~= nil then
			for _, child in pairs(speaker.Character:GetDescendants()) do
				if child:IsA("BasePart") and child.CanCollide == true and child.Name ~= floatName then
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

newCmd("fly", {}, "fly [number]", "Be Able to Fly", function(args, speaker)
	NOFLY()
	wait()
	sFLY()
	if args[1] and isNumber(args[1]) then
		Settings.daflyspeed = args[1]
		updatesaves()
	end
end)

newCmd("vfly", {"vehiclefly"}, "vfly / vehiclefly [number]", "Be Able to Make Vehicles Fly", function(args, speaker)
	NOFLY()
	wait()
	sFLY(true)
	if args[1] and isNumber(args[1]) then
		Settings.vehicleflyspeed = args[1]
		updatesaves()
	end
end)

newCmd("flyspeed", {"flysp"}, "flyspeed / flysp", "Change your Flyspeed", function(args, speaker)
	local speed = args[1] or 1
	if isNumber(speed) then
		Settings.daflyspeed = speed
		updatesaves()
	end
end)

newCmd("vflyspeed", {"vflysp"}, "vflyspeed / vflysp", "Change your Vehicle Flyspeed", function(args, speaker)
	local speed = args[1] or 1
	if isNumber(speed) then
		Settings.vehicleflyspeed = speed
		updatesaves()
	end
end)

newCmd("unfly", {"unvfly"}, "unfly / unvfly", "Stop Flying", function(args, speaker)
	NOFLY()
end)

newCmd("anchor", {}, "anchor", "Anchor your RootPart", function(args, speaker)
	speaker.Character.HumanoidRootPart.Anchored = true
end)

newCmd("unanchor", {}, "unanchor", "Makes your Player Movable Again", function(args, speaker)
	speaker.Character.HumanoidRootPart.Anchored = false
end)

newCmd("reset", {}, "reset", "Reset your Character", function(args, speaker)
	speaker.Character:BreakJoints()
end)

newCmd("notify", {}, "notify [title] [desc] [time]", "Notify Yourself (i guess...)", function(args, speaker)
	if args[3] ~= nil then
		notify(args[1], args[2], args[3])
	else
		notify(args[1], args[2])
	end
end)

newCmd("checkclaim", {}, "checkclaim [plr]", "Check if a player is Claimed", function(args, speaker)
	local isOwner = isnetworkowner
	if isOwner then
		local users = getPlayer(args[1], speaker)
		for i,Target in pairs(users) do
			if Target and Target.Character then
				if Target.Character:FindFirstChild("UpperTorso") then
					if isOwner(Target.Character.UpperTorso) then
						notify("", "User is Claimed")
					else
						notify("", "User is not Claimed")
					end
				else
					if isOwner(Target.Character.Torso) then
						notify("", "User is Claimed")
					else
						notify("", "User is not Claimed")
					end
				end
			end
		end
	else
		notify("", "Cannot Check")
	end
end)

newCmd("claimkill", {"ckill"}, "claimkill / ckill [plr]", "Kill a Claimed User", function(args, speaker)
	local users = getPlayer(args[1], speaker)
	for i,Target in pairs(users) do
		if Target and Target.Character and Target.Character:FindFirstChildOfClass("Humanoid") then
			Target.Character:FindFirstChildOfClass("Humanoid").Health = 0
		end
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
	if pchar and not pchar:FindFirstChild(floatName) then
		spawn(function()
			local Float = Instance.new('Part')
			Float.Name = floatName
			Float.Parent = pchar
			Float.Transparency = 1
			Float.Size = Vector3.new(6,1,6)
			Float.Anchored = true
			local FloatValue = -3.5
			if r15(speaker) then FloatValue = -3.65 end
			Float.CFrame = getRoot(pchar).CFrame * CFrame.new(0,FloatValue,0)
			notify("Float", "Float Enabled (Q = Down & E = Up)")
			qUp = DAMouse.KeyUp:Connect(function(KEY)
				if KEY == 'q' then
					FloatValue = FloatValue + 0.5
				end
			end)
			eUp = DAMouse.KeyUp:Connect(function(KEY)
				if KEY == 'e' then
					FloatValue = FloatValue - 0.5
				end
			end)
			qDown = DAMouse.KeyDown:Connect(function(KEY)
				if KEY == 'q' then
					FloatValue = FloatValue - 0.5
				end
			end)
			eDown = DAMouse.KeyDown:Connect(function(KEY)
				if KEY == 'e' then
					FloatValue = FloatValue + 0.5
				end
			end)
			floatDied = speaker.Character:FindFirstChildOfClass'Humanoid'.Died:Connect(function()
				FloatingFunc:Disconnect()
				Float:Destroy()
				qUp:Disconnect()
				eUp:Disconnect()
				qDown:Disconnect()
				eDown:Disconnect()
				floatDied:Disconnect()
			end)
			local function FloatPadLoop()
				if pchar:FindFirstChild(floatName) and getRoot(pchar) then
					Float.CFrame = getRoot(pchar).CFrame * CFrame.new(0,FloatValue,0)
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
			FloatingFunc = game:GetService('RunService').Heartbeat:Connect(FloatPadLoop)
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
	if speaker and speaker.Character and speaker.Character:FindFirstChildOfClass("Humanoid") then
		speaker.Character:FindFirstChildOfClass("Humanoid").Sit = true
	end
end)

newCmd("stun", {}, "stun", "Enable Platform Stand", function(args, speaker)
	if speaker and speaker.Character and speaker.Character:FindFirstChildOfClass("Humanoid") then
		speaker.Character:FindFirstChildOfClass("Humanoid").PlatformStand = true
	end
end)

newCmd("unstun", {}, "unstun", "Disable Platform Stand", function(args, speaker)
	if speaker and speaker.Character and speaker.Character:FindFirstChildOfClass("Humanoid") then
		speaker.Character:FindFirstChildOfClass("Humanoid").PlatformStand = false
	end
end)

newCmd("jump", {}, "jump", "Make your Character Jump", function(args, speaker)
	if speaker and speaker.Character and speaker.Character:FindFirstChildOfClass("Humanoid") then
		speaker.Character:FindFirstChildOfClass("Humanoid").Jump = true
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

newCmd("grabknife", {"knife"}, "grabknife / knife", "Load Grab Knife (Works on Claimed Players)", function(args, speaker)
	notify("", "Loaded Grab Knife", 2)
	Import("knif.lua")
end)

newCmd("control", {"control"}, "control [plr]", "Control a Claimed Player's Character", function(args, speaker)
	local users = getPlayer(args[1], speaker)
	for i,Target in pairs(users) do
		if Target and Target.Character and Target.Character:FindFirstChild("-Claimed") then
			Target.Character.HumanoidRootPart.Parent = speaker.Character
			speaker.Character.HumanoidRootPart.Anchored = true
		else
			notify("", "Couldn't Control Player")
		end
	end
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
	local GC = getconnections or get_signal_cons
	if GC then
		for i,v in pairs(GC(Players.LocalPlayer.Idled)) do
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
	Instance.new("HopperBin", speaker:FindFirstChildOfClass("Backpack")).BinType = 1
	Instance.new("HopperBin", speaker:FindFirstChildOfClass("Backpack")).BinType = 2
	Instance.new("HopperBin", speaker:FindFirstChildOfClass("Backpack")).BinType = 3
	Instance.new("HopperBin", speaker:FindFirstChildOfClass("Backpack")).BinType = 4
end)

newCmd("f3x", {"fex"}, "f3x / fex", "Building Tools", function(args, speaker)
	loadstring(game:GetObjects("rbxassetid://4698064966")[1].Source)()
end)

newCmd("explorer", {"dex"}, "explorer / dex", "Load a Game Explorer by Moon", function(args, speaker)
	if (not is_sirhurt_closure) and syn then
		notify("Loading", "Hold on a sec")
		wait(0.2)
		local Dex = game:GetObjects("rbxassetid://3567096419")[1]
		ParentGui(Dex)
		local function Load(Obj, Url)
			local function GiveOwnGlobals(Func, Script)
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
			local function LoadScripts(Script)
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
	loadstring(game:HttpGetAsync(("https://github.com/exxtremestuffs/SimpleSpySource/raw/master/SimpleSpy.lua")))();
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
	speaker.SetSuperSafeChat(true)
end)

newCmd("nosafechat", {}, "nosafechat", "Disable Safechat", function(args, speaker)
	speaker.SetSuperSafeChat(false)
end)

newCmd("creeper", {}, "creeper", "Become a Creeper", function(args, speaker)
	if r15(speaker) then
		speaker.Character.Head:FindFirstChildOfClass("SpecialMesh"):Destroy()
		speaker.Character.LeftUpperArm:Destroy()
		speaker.Character.RightUpperArm:Destroy()
		speaker.Character:FindFirstChildOfClass("Humanoid"):RemoveAccessories()
	else
		speaker.Character.Head:FindFirstChildOfClass("SpecialMesh"):Destroy()
		speaker.Character["Left Arm"]:Destroy()
		speaker.Character["Right Arm"]:Destroy()
		speaker.Character:FindFirstChildOfClass("Humanoid"):RemoveAccessories()
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
				a.Name = "SelectionBoxCreated"
				a.Parent = v.Handle
				a.Adornee = v.Handle
				v.Handle.Massless = true
				v.Handle.Size = Vector3.new(0.5, 0.5, args[1])
				v.GripPos = Vector3.new(0, 0, 0)
				speaker.Character:FindFirstChildOfClass("Humanoid"):UnequipTools()
			else
				currentToolSize = v.Handle.Size
				currentGripPos = v.GripPos
				local a = Instance.new("SelectionBox")
				a.Name = "SelectionBoxCreated"
				a.Parent = v.Handle
				a.Adornee = v.Handle
				v.Handle.Massless = true
				v.Handle.Size = Vector3.new(0.5, 0.5, 60)
				v.GripPos = Vector3.new(0, 0, 0)
				speaker.Character:FindFirstChildOfClass("Humanoid"):UnequipTools()
			end
		end
	end
end)

newCmd("unreach", {"noreach"}, "unreach / noreach", "Disable Reach", function(args, speaker)
	for i,v in pairs(speaker.Character:GetDescendants()) do
		if v:IsA("Tool") then
			v.Handle.Size = currentToolSize
			v.GripPos = currentGripPos
			v.Handle.SelectionBoxCreated:Destroy()
		end
	end
end)

newCmd("fov", {}, "fov", "Change your Field of View", function(args, speaker)
	local FOV = tonumber(args[1]) or origsettings.Camera.Fov or 70
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
	InvisibleCharacter.Parent = game:GetService'Lighting'
	local Void = workspace.FallenPartsDestroyHeight
	InvisibleCharacter.Name = ""
	local CF
	
	local invisFix = game:GetService("RunService").Stepped:Connect(function()
	    pcall(function()
	        local IsInteger
	        if tostring(Void):find'-' then
	            IsInteger = true
	        else
	            IsInteger = false
	        end
	        local Pos = Player.Character.HumanoidRootPart.Position
	        local Pos_String = tostring(Pos)
	        local Pos_Seperate = Pos_String:split(', ')
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
	            v.Transparency = 1
	        else
	            v.Transparency = .5
	        end
	    end
	end
	
	function Respawn()
	    IsRunning = false
	    if IsInvis == true then
	        pcall(function()
	            Player.Character = Character
	            wait()
	            Character.Parent = workspace
	            Character:FindFirstChildWhichIsA'Humanoid':Destroy()
	            IsInvis = false
	            InvisibleCharacter.Parent = nil
				invisRunning = false
	        end)
	    elseif IsInvis == false then
	        pcall(function()
	            Player.Character = Character
	            wait()
	            Character.Parent = workspace
	            Character:FindFirstChildWhichIsA'Humanoid':Destroy()
	            TurnVisible()
	        end)
	    end
	end
	
	local invisDied
	invisDied = InvisibleCharacter:FindFirstChildOfClass'Humanoid'.Died:Connect(function()
	    Respawn()
		invisDied:Disconnect()
	end)
	
	if IsInvis == true then return end
	IsInvis = true
	CF = workspace.CurrentCamera.CFrame
	local CF_1 = Player.Character.HumanoidRootPart.CFrame
	Character:MoveTo(Vector3.new(0,math.pi*1000000,0))
	workspace.CurrentCamera.CameraType = Enum.CameraType.Scriptable
	wait(.2)
	workspace.CurrentCamera.CameraType = Enum.CameraType.Custom
	InvisibleCharacter = InvisibleCharacter
	Character.Parent = game:GetService'Lighting'
	InvisibleCharacter.Parent = workspace
	InvisibleCharacter.HumanoidRootPart.CFrame = CF_1
	Player.Character = InvisibleCharacter
	fixcam(Player)
	Player.Character.Animate.Disabled = true
	Player.Character.Animate.Disabled = false
	
	function TurnVisible()
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
	    Player.Character.Animate.Disabled = true
	    Player.Character.Animate.Disabled = false
		invisDied = Character:FindFirstChildOfClass'Humanoid'.Died:Connect(function()
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
		viewing = Players[v]
		workspace.CurrentCamera.CameraSubject = viewing.Character
		notify("Spectating", Players[v].Name)
		local function viewDiedFunc()
			repeat wait() until Players[v].Character ~= nil and getRoot(Players[v].Character)
			workspace.CurrentCamera.CameraSubject = viewing.Character
		end
		viewDied = Players[v].CharacterAdded:Connect(viewDiedFunc)
		local function viewChangedFunc()
			workspace.CurrentCamera.CameraSubject = viewing.Character
		end
		viewChanged = workspace.CurrentCamera:GetPropertyChangedSignal("CameraSubject"):Connect(viewChangedFunc)
	end
end)

newCmd("unspectate", {"unspec"}, "unspectate / unspec [plr]", "Stop viewing a Player", function(args, speaker)
	if viewing ~= nil then
		viewing = nil
		notify("Spectate", "Turned Off")
	end
	if viewDied then
		viewDied:Disconnect()
		viewChanged:Disconnect()
	end
	workspace.CurrentCamera.CameraSubject = speaker.Character
end)

newCmd("fixcam", {}, "fixcam", "Fix/Restore your Camera", function(args, speaker)
	execCmd("unspectate")
	workspace.CurrentCamera:remove()
	wait(0.1)
	repeat wait() until speaker.Character ~= nil
	workspace.CurrentCamera.CameraSubject = speaker.Character:FindFirstChildWhichIsA("Humanoid")
	workspace.CurrentCamera.CameraType = "Custom"
	speaker.CameraMinZoomDistance = 0.5
	speaker.CameraMaxZoomDistance = 400
	speaker.CameraMode = "Classic"
	if speaker.Character:FindFirstChild("Head") then
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
	speaker.DevEnableMouseLock = true
	notify("Shiftlock", "Shift Lock is now Available")
end)

newCmd("firstp", {}, "firstp", "First Person", function(args, speaker)
	speaker.CameraMode = "LockFirstPerson"
end)

newCmd("thirdp", {}, "thirdp", "Third Person", function(args, speaker)
	speaker.CameraMode = "Classic"
end)

newCmd("noprompts", {}, "noprompts", "Stop Receiving Purchase Prompts", function(args, speaker)
	CoreGui.PurchasePromptApp.PurchasePromptUI.Visible = false
	CoreGui.PurchasePromptApp.PremiumPromptUI.Visible = false
end)

newCmd("showprompts", {}, "showprompts", "Continue Receiving Purchase Prompts", function(args, speaker)
	CoreGui.PurchasePromptApp.PurchasePromptUI.Visible = true
	CoreGui.PurchasePromptApp.PremiumPromptUI.Visible = false
end)

newCmd("drophats", {}, "drophats", "Drop your Hats", function(args, speaker)
	if speaker and speaker.Character then
		for _,v in pairs(speaker.Character:FindFirstChildOfClass("Humanoid"):GetAccessories()) do
			v.Parent = workspace
		end
	end
end)

newCmd("deletehats", {"nohats"}, "deletehats / nohats", "Delete your Hats", function(args, speaker)
	if speaker and speaker.Character then
		speaker.Character:FindFirstChildOfClass("Humanoid"):RemoveAccessories()
	end
end)

newCmd("droptools", {}, "droptools", "Drop your Tools", function(args, speaker)
	for i,v in pairs(Players.LocalPlayer.Backpack:GetChildren()) do
		if v:IsA("Tool") then
			v.Parent = Players.LocalPlayer.Character
		end
	end
	wait()
	for i,v in pairs(Players.LocalPlayer.Character:GetChildren()) do
		if v:IsA("Tool") then
			v.Parent = workspace
		end
	end
end)

newCmd("droppabletools", {}, "droppabletools", "Make Undroppable Tools Droppable", function(args, speaker)
	if speaker and speaker.Character then
		for _,obj in pairs(speaker.Character:GetChildren()) do
			if obj:IsA("Tool") then
				obj.CanBeDropped = true
			end
		end
	end
	if speaker and speaker:FindFirstChildOfClass("Backpack") then
		for _,obj in pairs(speaker:FindFirstChildOfClass("Backpack"):GetChildren()) do
			if obj:IsA("Tool") then
				obj.CanBeDropped = true
			end
		end
	end
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

newCmd("resetuserid", {}, "resetuserid", "Set your User ID back to normal", function(args, speaker)
	speaker.UserId = origsettings.Player.Id
	notify("Set ID", "Set UserId to original")
end)

newCmd("printpos", {}, "printpos", "Print Current Position", function(args, speaker)
	local curpos = speaker.Character and (getRoot(speaker.Character) or speaker.Character:FindFirstChildWhichIsA("BasePart"))
	curpos = curpos and curpos.Position
	if not curpos then
		return warn("Missing Character")
	end
	curpos = math.round(curpos.X) .. ", " .. math.round(curpos.Y) .. ", " .. math.round(curpos.Z)
	print("Current Position: " .. curpos)
end)

newCmd("notifypos", {}, "notifypos", "Notify Current Position", function(args, speaker)
	local curpos = speaker.Character and (getRoot(speaker.Character) or speaker.Character:FindFirstChildWhichIsA("BasePart"))
	curpos = curpos and curpos.Position
	if not curpos then
		return warn("Missing Character")
	end
	curpos = math.round(curpos.X) .. ", " .. math.round(curpos.Y) .. ", " .. math.round(curpos.Z)
	notify("Current Position", curpos)
end)

newCmd("copypos", {}, "copypos", "Copy Current Position to Clipboard", function(args, speaker)
	local curpos = speaker.Character and (getRoot(speaker.Character) or speaker.Character:FindFirstChildWhichIsA("BasePart"))
	curpos = curpos and curpos.Position
	if not curpos then
		return warn("Missing Character")
	end
	curpos = math.round(curpos.X) .. ", " .. math.round(curpos.Y) .. ", " .. math.round(curpos.Z)
	if toClipboard then
		toClipboard(curpos)
	end
end)

newCmd("swim", {}, "swim", "Become fish", function(args, speaker)
	workspace.Gravity = 0
	local function swimDied()
		workspace.Gravity = 198.2
		swimming = false
	end
	gravReset = speaker.Character:FindFirstChildOfClass("Humanoid").Died:Connect(swimDied)
	speaker.Character:FindFirstChildOfClass("Humanoid"):SetStateEnabled(Enum.HumanoidStateType.Climbing,false)
	speaker.Character:FindFirstChildOfClass("Humanoid"):SetStateEnabled(Enum.HumanoidStateType.FallingDown,false)
	speaker.Character:FindFirstChildOfClass("Humanoid"):SetStateEnabled(Enum.HumanoidStateType.Flying,false)
	speaker.Character:FindFirstChildOfClass("Humanoid"):SetStateEnabled(Enum.HumanoidStateType.Freefall,false)
	speaker.Character:FindFirstChildOfClass("Humanoid"):SetStateEnabled(Enum.HumanoidStateType.GettingUp,false)
	speaker.Character:FindFirstChildOfClass("Humanoid"):SetStateEnabled(Enum.HumanoidStateType.Jumping,false)
	speaker.Character:FindFirstChildOfClass("Humanoid"):SetStateEnabled(Enum.HumanoidStateType.Landed,false)
	speaker.Character:FindFirstChildOfClass("Humanoid"):SetStateEnabled(Enum.HumanoidStateType.Physics,false)
	speaker.Character:FindFirstChildOfClass("Humanoid"):SetStateEnabled(Enum.HumanoidStateType.PlatformStanding,false)
	speaker.Character:FindFirstChildOfClass("Humanoid"):SetStateEnabled(Enum.HumanoidStateType.Ragdoll,false)
	speaker.Character:FindFirstChildOfClass("Humanoid"):SetStateEnabled(Enum.HumanoidStateType.Running,false)
	speaker.Character:FindFirstChildOfClass("Humanoid"):SetStateEnabled(Enum.HumanoidStateType.RunningNoPhysics,false)
	speaker.Character:FindFirstChildOfClass("Humanoid"):SetStateEnabled(Enum.HumanoidStateType.Seated,false)
	speaker.Character:FindFirstChildOfClass("Humanoid"):SetStateEnabled(Enum.HumanoidStateType.StrafingNoPhysics,false)
	speaker.Character:FindFirstChildOfClass("Humanoid"):SetStateEnabled(Enum.HumanoidStateType.Swimming,false)
	speaker.Character:FindFirstChildOfClass("Humanoid"):ChangeState(Enum.HumanoidStateType.Swimming)
	swimming = true
end)

newCmd("unswim", {}, "unswim", "Reject fish become human", function(args, speaker)
	workspace.Gravity = 198.2
	swimming = false
	if gravReset then
		gravReset:Disconnect()
	end
	speaker.Character:FindFirstChildOfClass("Humanoid"):SetStateEnabled(Enum.HumanoidStateType.Climbing,true)
	speaker.Character:FindFirstChildOfClass("Humanoid"):SetStateEnabled(Enum.HumanoidStateType.FallingDown,true)
	speaker.Character:FindFirstChildOfClass("Humanoid"):SetStateEnabled(Enum.HumanoidStateType.Flying,true)
	speaker.Character:FindFirstChildOfClass("Humanoid"):SetStateEnabled(Enum.HumanoidStateType.Freefall,true)
	speaker.Character:FindFirstChildOfClass("Humanoid"):SetStateEnabled(Enum.HumanoidStateType.GettingUp,true)
	speaker.Character:FindFirstChildOfClass("Humanoid"):SetStateEnabled(Enum.HumanoidStateType.Jumping,true)
	speaker.Character:FindFirstChildOfClass("Humanoid"):SetStateEnabled(Enum.HumanoidStateType.Landed,true)
	speaker.Character:FindFirstChildOfClass("Humanoid"):SetStateEnabled(Enum.HumanoidStateType.Physics,true)
	speaker.Character:FindFirstChildOfClass("Humanoid"):SetStateEnabled(Enum.HumanoidStateType.PlatformStanding,true)
	speaker.Character:FindFirstChildOfClass("Humanoid"):SetStateEnabled(Enum.HumanoidStateType.Ragdoll,true)
	speaker.Character:FindFirstChildOfClass("Humanoid"):SetStateEnabled(Enum.HumanoidStateType.Running,true)
	speaker.Character:FindFirstChildOfClass("Humanoid"):SetStateEnabled(Enum.HumanoidStateType.RunningNoPhysics,true)
	speaker.Character:FindFirstChildOfClass("Humanoid"):SetStateEnabled(Enum.HumanoidStateType.Seated,true)
	speaker.Character:FindFirstChildOfClass("Humanoid"):SetStateEnabled(Enum.HumanoidStateType.StrafingNoPhysics,true)
	speaker.Character:FindFirstChildOfClass("Humanoid"):SetStateEnabled(Enum.HumanoidStateType.Swimming,true)
	speaker.Character:FindFirstChildOfClass("Humanoid"):ChangeState(Enum.HumanoidStateType.RunningNoPhysics)
end)

newCmd("unlockws", {}, "unlockws", "Unlock Workspace", function(args, speaker)
	for i,v in pairs(workspace:GetDescendants()) do
		if v:IsA("BasePart") then
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
		speaker.Character.Parent = nil
	end
end)

newCmd("unnilchar", {}, "unnilchar", "Makes your Character's parent Workspace", function(args, speaker)
	if speaker and speaker.Character ~= nil then
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
				v.Velocity, v.RotVelocity = V3, V3
			end
		end
		wait()
	end
end)

newCmd("flashback", {}, "flashback", "Go back to where you last died", function(args, speaker)
	if LastDeathPos ~= nil then
		if speaker.Character:FindFirstChildOfClass("Humanoid") and speaker.Character:FindFirstChildOfClass("Humanoid").SeatPart then
			speaker.Character:FindFirstChildOfClass("Humanoid").Sit = false
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
		local Human = speaker.Character:WaitForChild("Humanoid")
		wait(.1, Human.Parent:MoveTo(TempPos))
		Human.RootPart.Anchored = speaker:ClearCharacterAppearance(wait(.1)) or true
		local t = GetHandleTools(speaker)
		while #t > 0 do
			for _, v in ipairs(t) do
				coroutine.wrap(function()
					for _ = 1, 25 do
						v.Parent = speaker.Character
						v.Handle.Anchored = true
					end
					for _ = 1, 5 do
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

newCmd("commandcount", {}, "commandcount", "Notify the number of commands", function(args, speaker)
	notify("Command Count", #cmds)
end)

local CmdNoclipping = nil
newCmd("noclip", {}, "noclip", "Go Through Objects", function(args, speaker)
	CmdClip = false
	wait(0.1)
	local function NoclipLoop()
		if CmdClip == false and speaker.Character ~= nil then
			for _, child in pairs(speaker.Character:GetDescendants()) do
				if child:IsA("BasePart") and child.CanCollide == true and child.Name ~= floatName then
					child.CanCollide = false
				end
			end
		end
	end
	CmdNoclipping = game:GetService('RunService').Stepped:Connect(NoclipLoop)
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
	repeat wait()
		speaker.Character.HumanoidRootPart.Anchored = false
		wait(0.1)
		speaker.Character.HumanoidRootPart.Anchored = true
		wait(0.1)
	until FakeLagging == false
end)

newCmd("unlag", {}, "unlag", "Stop the fake lag", function(args, speaker)
	FakeLagging = false
	notify("Fake Lag", "Disabled")
	wait(0.3)
	speaker.Character.HumanoidRootPart.Anchored = false
end)

newCmd("spin", {}, "spin [number]", "Spins your character", function(args, speaker)
	local spinSpeed = 20
	if args[1] and isNumber(args[1]) then
		spinSpeed = args[1]
	end
	for i,v in pairs(getRoot(speaker.Character):GetChildren()) do
		if v.Name == "Spinning" then
			v:Destroy()
		end
	end
	local Spin = Instance.new("BodyAngularVelocity")
	Spin.Name = "Spinning"
	Spin.Parent = getRoot(speaker.Character)
	Spin.MaxTorque = Vector3.new(0, math.huge, 0)
	Spin.AngularVelocity = Vector3.new(0, spinSpeed, 0)
end)

newCmd("unspin", {}, "unspin", "Disables Spin", function(args, speaker)
	for i,v in pairs(getRoot(speaker.Character):GetChildren()) do
		if v.Name == "Spinning" then
			v:Destroy()
		end
	end
end)

cmdflinging = false
newCmd("fling", {}, "fling", "Fling Anyone You Touch", function(args, speaker)
	for _, child in pairs(speaker.Character:GetDescendants()) do
		if child:IsA("BasePart") then
			child.CustomPhysicalProperties = PhysicalProperties.new(2, 0.3, 0.5)
		end
	end
	execCmd("noclip nonotify")
	wait(0.1)
	local bambam = Instance.new("BodyAngularVelocity")
	bambam.Name = randomString()
	bambam.Parent = getRoot(speaker.Character)
	bambam.AngularVelocity = Vector3.new(0, 311111, 0)
	bambam.MaxTorque = Vector3.new(0, 311111, 0)
	bambam.P = math.huge
	local function PauseFling()
		if speaker.Character:FindFirstChildOfClass("Humanoid") then
			if speaker.Character:FindFirstChildOfClass("Humanoid").FloorMaterial == Enum.Material.Air then
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
	TouchingFloor = speaker.Character:FindFirstChildOfClass("Humanoid"):GetPropertyChangedSignal("FloorMaterial"):Connect(PauseFling)
	cmdflinging = true
	local function flingDied()
		execCmd("unfling")
	end
	TouchingFloorReset = speaker.Character:FindFirstChildOfClass('Humanoid').Died:Connect(flingDied)
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
			child.CustomPhysicalProperties = PhysicalProperties.new(0.7, 0.3, 0.5)
		end
	end
end)

newCmd("invisfling", {}, "invisfling", "Enables Invisible Fling", function(args, speaker)
	local ch = speaker.Character
	local prt=Instance.new("Model")
	prt.Parent = speaker.Character
	local z1 = Instance.new("Part")
	z1.Name="Torso"
	z1.CanCollide = false
	z1.Anchored = true
	local z2 = Instance.new("Part")
	z2.Name="Head"
	z2.Parent = prt
	z2.Anchored = true
	z2.CanCollide = false
	local z3 =Instance.new("Humanoid")
	z3.Name="Humanoid"
	z3.Parent = prt
	z1.Position = Vector3.new(0,9999,0)
	speaker.Character=prt
	wait(3)
	speaker.Character=ch
	wait(3)
	local Hum = Instance.new("Humanoid")
	z2:Clone()
	Hum.Parent = speaker.Character
	local root =  getRoot(speaker.Character)
	for i,v in pairs(speaker.Character:GetChildren()) do
		if v ~= root and  v.Name ~= "Humanoid" then
			v:Destroy()
		end
	end
	root.Transparency = 0
	root.Color = Color3.new(1, 1, 1)
	local invisflingStepped
	invisflingStepped = game:GetService('RunService').Stepped:Connect(function()
		if speaker.Character and getRoot(speaker.Character) then
			getRoot(speaker.Character).CanCollide = false
		else
			invisflingStepped:Disconnect()
		end
	end)
	sFLY()
	workspace.CurrentCamera.CameraSubject = root
	local bambam = Instance.new("BodyThrust")
	bambam.Parent = getRoot(speaker.Character)
	bambam.Force = Vector3.new(99999,99999*10,99999)
	bambam.Location = getRoot(speaker.Character).Position
end)

newCmd("infinitejump", {"infjump"}, "infinitejump / infjump", "Be Able to Keep Jumping", function(args, speaker)
	notify("Infinite Jump", "Enabled")
	cmdinfjump = true
	game:GetService("UserInputService").JumpRequest:Connect(function()
		if cmdinfjump == true then
			speaker.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
		end
	end)
end)

newCmd("uninfinitejump", {"uninfjump"}, "uninfinitejump / uninfjump", "Disable Infinite Jump", function(args, speaker)
	notify("Infinite Jump", "Disabled")
	cmdinfjump = false
end)

newCmd("keepda", {}, "keepda", "Auto Load DA Upon Rejoin/Teleport", function(args, speaker)
	notify("Auto Run", "Enabled")
	Settings.KeepDA = true
	DaUi.SettingsArea.KeepdaToggle.Text = utf8.char(10003)
	if Settings.KeepDA and syn.queue_on_teleport then
		syn.queue_on_teleport('loadstring(game:HttpGetAsync(("https://raw.githubusercontent.com/daximul/who/main/a/test/what/script.lua")))();')
	end
	updatesaves()
end)

newCmd("unkeepda", {}, "unkeepda", "Disable Auto Load DA Upon Rejoin/Teleport", function(args, speaker)
	notify("Auto Run", "Disabled")
	Settings.KeepDA = false
	DaUi.SettingsArea.KeepdaToggle.Text = ""
	updatesaves()
end)

newCmd("serverhop", {"shop"}, "serverhop / shop", "Teleports you to a different server", function(args, speaker)
	local x = {}
	for _, v in ipairs(game:GetService("HttpService"):JSONDecode(game:HttpGetAsync("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100")).data) do
		if type(v) == "table" and v.maxPlayers > v.playing and v.id ~= game.JobId then
			x[#x + 1] = v.id
		end
	end
	if #x > 0 then
		game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, x[math.random(1, #x)])
	else
		return notify("Serverhop", "Couldn't Find a Server")
	end
end)

newCmd("hipheight", {"hh"}, "hipheight / hh [number]", "Adjusts Hip Height", function(args, speaker)
	local height = nil
	if r15(speaker) then
		height = args[1] or 2.1
	else
		height = args[1] or 0
	end
	speaker.Character:FindFirstChildOfClass("Humanoid").HipHeight = height
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
								getRoot(pchar).CFrame = getRoot(speaker.Character).CFrame + Vector3.new(distance,1,0)
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

newCmd("naked", {}, "naked", "Removes your Clothing", function(args, speaker)
	for i,v in pairs(speaker.Character:GetDescendants()) do
		if v:IsA("Clothing") or v:IsA("ShirtGraphic") then
			v:Destroy()
		end
	end
end)

newCmd("noface", {}, "noface", "Removes your Face", function(args, speaker)
	for i,v in pairs(speaker.Character:GetDescendants()) do
		if v:IsA("Decal") and v.Name == 'face' then
			v:Destroy()
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
		local hum  = Instance.new("Humanoid")
		local animation = Instance.new("Model")
		local humanoidanimation = Instance.new("Humanoid")
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
		hum2.Parent = char
		char:FindFirstChildOfClass("Humanoid").Jump = true

		humanoidanimation.Animator.Parent = hum2
		char.Animate.Disabled = true
		wait()
		char.Animate.Disabled = false
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
	game:GetService("Lighting").Brightness = 2
	game:GetService("Lighting").ClockTime = 14
	game:GetService("Lighting").FogEnd = 100000
	game:GetService("Lighting").GlobalShadows = false
	game:GetService("Lighting").OutdoorAmbient = Color3.fromRGB(128, 128, 128)
end)

newCmd("loopfullbright", {"loopfb"}, "loopfullbright / loopfb", "Makes the map brighter / more visible but looped", function(args, speaker)
	if brightLoop then
		brightLoop:Disconnect()
	end
	local function brightFunc()
		game:GetService("Lighting").Brightness = 2
		game:GetService("Lighting").ClockTime = 14
		game:GetService("Lighting").FogEnd = 100000
		game:GetService("Lighting").GlobalShadows = false
		game:GetService("Lighting").OutdoorAmbient = Color3.fromRGB(128, 128, 128)
	end
	brightLoop = game:GetService("RunService").RenderStepped:Connect(brightFunc)
end)

newCmd("unloopfullbright", {"unfb"}, "unloopfullbright / unloopfb", "Disable Loop Full Bright", function(args, speaker)
	if brightLoop then
		brightLoop:Disconnect()
	end
end)

newCmd("day", {}, "day (Client)", "Changes the time to day for the client", function(args, speaker)
	game:GetService("Lighting").ClockTime = 14
end)

newCmd("night", {}, "night (Client)", "Changes the time to night for the client", function(args, speaker)
	game:GetService("Lighting").ClockTime = 0
end)

newCmd("nofog", {}, "nofog (Client)", "Removes Fog", function(args, speaker)
	game:GetService("Lighting").FogEnd = 100000
end)

newCmd("brightness", {}, "brightness [num] (Client)", "Changes the Brightness Lighting Property", function(args, speaker)
	if args[1] then
		game:GetService("Lighting").Brightness = args[1]
	else
		game:GetService("Lighting").Brightness = origsettings.Lighting.brt
	end
end)

newCmd("globalshadows", {"gshadows"}, "globalshadows / gshadows", "Enables Global Shadows", function(args, speaker)
	game:GetService("Lighting").GlobalShadows = true
end)

newCmd("noglobalshadows", {"nogshadows"}, "noglobalshadows / nogshadows", "Disables Global Shadows", function(args, speaker)
	game:GetService("Lighting").GlobalShadows = false
end)

newCmd("light", {}, "light [radius] [brightness] (Client)", "Gives your Player Dynamic Light", function(args, speaker)
	local light = Instance.new("PointLight")
	light.Parent = getRoot(speaker.Character)
	light.Range = 30
	if args[1] then
		light.Brightness = args[2]
		light.Range = args[1]
	else
		light.Brightness = 5
	end
end)

newCmd("unlight", {}, "unlight", "Removes Dynamic Light from your Player", function(args, speaker)
	for i,v in pairs(speaker.Character:GetDescendants()) do
		if v.ClassName == "PointLight" then
			v:Destroy()
		end
	end
end)

newCmd("restorelighting", {"rlighting"}, "restorelighting / rlighting", "Restores Lighting Properties", function(args, speaker)
	game:GetService("Lighting").Ambient = origsettings.Lighting.abt
	game:GetService("Lighting").OutdoorAmbient = origsettings.Lighting.oabt
	game:GetService("Lighting").Brightness = origsettings.Lighting.brt
	game:GetService("Lighting").ClockTime = origsettings.Lighting.time
	game:GetService("Lighting").FogEnd = origsettings.Lighting.fe
	game:GetService("Lighting").FogStart = origsettings.Lighting.fs
	game:GetService("Lighting").GlobalShadows = origsettings.Lighting.gs
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
					Head.Size = Vector3.new(2, 1, 1)
				else
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
		Script.Disabled = true
		wait()
		Script.Disabled = false
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
	workspace:FindFirstChildOfClass("Terrain").WaterWaveSize = 0
	workspace:FindFirstChildOfClass("Terrain").WaterWaveSpeed = 0
	workspace:FindFirstChildOfClass("Terrain").WaterReflectance = 0
	workspace:FindFirstChildOfClass("Terrain").WaterTransparency = 0
	game:GetService("Lighting").GlobalShadows = false
	game:GetService("Lighting").FogEnd = 9e9
	settings().Rendering.QualityLevel = 1
	for i,v in pairs(game:GetDescendants()) do
		if v:IsA("Part") or v:IsA("UnionOperation") or v:IsA("MeshPart") or v:IsA("CornerWedgePart") or v:IsA("TrussPart") then
			v.Material = "Plastic"
			v.Reflectance = 0
		elseif v:IsA("Decal") then
			v.Transparency = 1
		elseif v:IsA("ParticleEmitter") or v:IsA("Trail") then
			v.Lifetime = NumberRange.new(0)
		elseif v:IsA("Explosion") then
			v.BlastPressure = 1
			v.BlastRadius = 1
		end
	end
	for i,v in pairs(game:GetService("Lighting"):GetDescendants()) do
		if v:IsA("BlurEffect") or v:IsA("SunRaysEffect") or v:IsA("ColorCorrectionEffect") or v:IsA("BloomEffect") or v:IsA("DepthOfFieldEffect") then
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
	if #args < 3 then return end
	local tpX,tpY,tpZ = tonumber(args[1]),tonumber(args[2]),tonumber(args[3])
	local char = speaker.Character
	if char and getRoot(char) then
		getRoot(char).CFrame = CFrame.new(tpX, tpY, tpZ)
	end
end)

newCmd("tweentpposition", {"ttppos"}, "tweentpposition / ttppos [X] [Y] [Z]", "Tween to coordinates (bypasses some anti cheats)", function(args, speaker)
	if #args < 3 then return end
	local tpX,tpY,tpZ = tonumber(args[1]),tonumber(args[2]),tonumber(args[3])
	local char = speaker.Character
	if char and getRoot(char) then
		game:GetService("TweenService"):Create(getRoot(speaker.Character), TweenInfo.new(tweenSpeed, Enum.EasingStyle.Linear), {CFrame = CFrame.new(tpX, tpY, tpZ)}):Play()
	end
end)

newCmd("chat", {"say"}, "chat / say [text]", "Makes you chat a string (possible mute bypass)", function(args, speaker)
	local cString = getstring(1)
	game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer(cString, "All")
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
				if tonumber(v1) == .25 then
					sc(v, i, 0)
				elseif tonumber(v1) == 0 then
					sc(v, i, .25)
				end
			end
		end
	end
end)

newCmd("maxzoom", {}, "maxzoom [number]", "Maximum Camera Zoom", function(args, speaker)
	speaker.CameraMaxZoomDistance = args[1]
end)

newCmd("minzoom", {}, "minzoom [number]", "Minimum Camera Zoom", function(args, speaker)
	speaker.CameraMinZoomDistance = args[1]
end)

newCmd("tpunanchored", {"tpua"}, "tpunanchored / tpua [plr]", "Teleports Unanchored Parts to a Player", function(args, speaker)
	if sethidden then
		local players = getPlayer(args[1], speaker)
		for i,v in pairs(players) do
			local Forces = {}
			for _,part in pairs(workspace:GetDescendants()) do
				if Players[v].Character:FindFirstChild('Head') and part:IsA("BasePart" or "UnionOperation" or "Model") and part.Anchored == false and not part:IsDescendantOf(speaker.Character) and part.Name == "Torso" == false and part.Name == "Head" == false and part.Name == "Right Arm" == false and part.Name == "Left Arm" == false and part.Name == "Right Leg" == false and part.Name == "Left Leg" == false and part.Name == "HumanoidRootPart" == false then
					for i,c in pairs(part:GetChildren()) do
						if c:IsA("BodyPosition") or c:IsA("BodyGyro") then
							c:Destroy()
						end
					end
					local ForceInstance = Instance.new("BodyPosition")
					ForceInstance.Parent = part
					ForceInstance.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
					table.insert(Forces, ForceInstance)
					if not table.find(frozenParts,part) then
						table.insert(frozenParts,part)
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
		local function FREEZENOOB(v)
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
					bodypos.Parent = v
					bodypos.Position = v.Position
					bodypos.MaxForce = Vector3.new(math.huge,math.huge,math.huge)
					local bodygyro = Instance.new("BodyGyro")
					bodygyro.Parent = v
					bodygyro.CFrame = v.CFrame
					bodygyro.MaxTorque = Vector3.new(math.huge,math.huge,math.huge)
					if not table.find(frozenParts,v) then
						table.insert(frozenParts,v)
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
			if Key == args[1] then
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

newCmd("teleporttool", {"tptool"}, "teleporttool / tptool", "Gives You a Teleport Tool", function(args, speaker)
	local TpTool = Instance.new("Tool")
	TpTool.Name = "Teleport Tool"
	TpTool.RequiresHandle = false
	TpTool.Parent = speaker.Backpack
	TpTool.Activated:Connect(function()
		local Char = speaker.Character or workspace:FindFirstChild(speaker.Name)
		local HRP = Char and Char:FindFirstChild("HumanoidRootPart")
		if not Char or not HRP then
			return notify("Error", "Failed to Find HumanoidRootPart")
		end
		HRP.CFrame = CFrame.new(DAMouse.Hit.X, DAMouse.Hit.Y + 3, DAMouse.Hit.Z, select(4, HRP.CFrame:components()))
	end)
end)

newCmd("walltp", {}, "walltp", "Teleports You Above/Over Any Wall You Run Into", function(args, speaker)
	local Torso = nil
	if r15(speaker) then
		Torso = speaker.Character.UpperTorso
	else
		Torso = speaker.Character.Torso
	end
	local function TouchedFunc(hit)
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
			bangAnim.AnimationId = "rbxassetid://148840371"
			bang = speaker.Character.Humanoid:LoadAnimation(bangAnim)
			bang:Play(.1, 1, 1)
			if args[2] then
				bang:AdjustSpeed(args[2])
			else
				bang:AdjustSpeed(3)
			end
			local bangplr = Players[v].Name
			bangDied = speaker.Character:FindFirstChildOfClass("Humanoid").Died:Connect(function()
				bangLoop:Disconnect()
				bang:Stop()
				bangAnim:Destroy()
				bangDied:Disconnect()
			end)
			bangLoop = game:GetService("RunService").Stepped:Connect(function()
				pcall(function()
					getRoot(Players.LocalPlayer.Character).CFrame = getRoot(Players[bangplr].Character).CFrame
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
			carpetAnim.AnimationId = "rbxassetid://282574440"
			carpet = speaker.Character.Humanoid:LoadAnimation(carpetAnim)
			carpet:Play(.1, 1, 1)
			local carpetplr = Players[v].Name
			carpetDied = speaker.Character:FindFirstChildOfClass("Humanoid").Died:Connect(function()
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
		local function StareFunc()
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
	if tonumber(args[1]) then
		settings():GetService("NetworkSettings").IncomingReplicationLag = args[1]
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
	wait(.2)
	v:Disconnect()
	notify("FPS", "Current FPS is " .. fps)
end)

newCmd("clearhats", {}, "clearhats", "Clears Hats in the Workspace", function(args, speaker)
	if firetouchinterest then
		local Player = Players.LocalPlayer
		local Character = Player.Character
		local Old = Character:FindFirstChild("HumanoidRootPart").CFrame
		local Hats = {}
		for _,x in next, workspace:GetChildren() do
			if x:IsA("Accessory") then
				table.insert(Hats,x)
			end
		end
		for _,getacc in next, Character:FindFirstChildOfClass("Humanoid"):GetAccessories() do
			getacc:Destroy()
		end
		for i = 1,#Hats do
			repeat game:GetService("RunService").Heartbeat:wait() until Hats[i]
			firetouchinterest(Hats[i].Handle,Character:FindFirstChild("HumanoidRootPart"),0)
			repeat game:GetService("RunService").Heartbeat:wait() until Character:FindFirstChildOfClass("Accessory")
			Character:FindFirstChildOfClass("Accessory"):Destroy()
			repeat game:GetService("RunService").Heartbeat:wait() until not Character:FindFirstChildOfClass("Accessory")
		end
		Character:BreakJoints()
		Player.CharacterAdded:wait()
		for i = 1,20 do game:GetService("RunService").Heartbeat:wait()
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
		local keep = Instance.new("BodyPosition") keep.Name = randomString() keep.Parent = v.Handle
		local spin = Instance.new("BodyAngularVelocity") spin.Name = randomString() spin.Parent = v.Handle
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
	for _,v in pairs(speaker.Character:FindFirstChildOfClass("Humanoid"):GetAccessories()) do
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
		local function prep(plr)
			if plr and plr.Character then
				for _,char in pairs(plr.Character:GetChildren()) do
					game:GetService("RunService").RenderStepped:Connect(function()
						pcall(function()
							if char:IsA("Part") or char:IsA("BasePart") then
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
				for _,char in pairs(Players.LocalPlayer.Character:GetChildren()) do
					game:GetService("RunService").RenderStepped:Connect(function()
						pcall(function()
							if char:IsA("Part") or char:IsA("BasePart") then
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
	else
		local function prep(plr)
			if plr and plr.Character then
				for _,char in pairs(plr.Character:GetChildren()) do
					game:GetService("RunService").RenderStepped:Connect(function()
						pcall(function()
							if char:IsA("Part") or char:IsA("BasePart") then
								char.Velocity = Vector3.new(30, 0, 4)
							end
						end)
					end)
				end
			end
		end
		game:GetService("RunService").Heartbeat:Connect(function()
			sethidden(Players.LocalPlayer, "SimulationRadius", true)
			if Players.LocalPlayer and Players.LocalPlayer.Character then
				for _,char in pairs(Players.LocalPlayer.Character:GetChildren()) do
					game:GetService("RunService").RenderStepped:Connect(function()
						pcall(function()
							if char:IsA("Part") or char:IsA("BasePart") then
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
	end
end)

newCmd("enable", {}, "enable [inventory/playerlist/chat/all]", "Toggles Visibility of CoreGui Items", function(args, speaker)
	if args[1] then
		local opt = string.lower(args[1])
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
		local opt = string.lower(args[1])
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



end)



spawn(function()
	VirtualEnvironment()
	if Settings.AutoNet then
		SetSimulationRadius()
	end
	if Settings.PluginsTable ~= nil or Settings.PluginsTable ~= {} then
		FindPlugins(Settings.PluginsTable)
	end
end)
notify("Loaded", ("Loaded in %.3f Seconds"):format((tick() or os.clock()) - StartingTick))
notify("Dark Admin", "Prefix is " .. Settings.Prefix)
--// Dark Admin;
