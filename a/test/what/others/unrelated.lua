-- i needed somewhere to save a file and i was already on github
-- pls dont read


































local function ParentGui(Gui)
	local HttpService = game:GetService("HttpService")
	local CoreGui = game:GetService("CoreGui")
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

local function SmoothDrag(frame)
	local inputService = game:GetService("UserInputService")
	local heartbeat = game:GetService("RunService").Heartbeat
	local Player_Mouse = game:GetService("Players").LocalPlayer:GetMouse()
	local s, event = pcall(function()
		return frame.MouseEnter
	end)
	if s then
		frame.Active = true;
		event:connect(function()
			local input = frame.InputBegan:connect(function(key)
				if key.UserInputType == Enum.UserInputType.MouseButton1 then
					local objectPosition = Vector2.new(Player_Mouse.X - frame.AbsolutePosition.X, Player_Mouse.Y - frame.AbsolutePosition.Y);
					while heartbeat:wait() and inputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) do
						pcall(function()
							frame:TweenPosition(UDim2.new(0, Player_Mouse.X - objectPosition.X, 0, Player_Mouse.Y - objectPosition.Y), 'Out', 'Linear', 0.1, true);
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

local function loadr(i)
	loadstring(game:HttpGetAsync(tostring(i)))();
end

local function CreateGui()
	local Internal = Instance.new("ScreenGui")
	local Main = Instance.new("Frame")
	local ClearBtn = Instance.new("TextButton")
	local UICorner = Instance.new("UICorner")
	local HideCodeBtn = Instance.new("TextButton")
	local UICorner_2 = Instance.new("UICorner")
	local ExecuteBtn = Instance.new("TextButton")
	local UICorner_3 = Instance.new("UICorner")
	local ScriptHub = Instance.new("ScrollingFrame")
	local UIListLayout = Instance.new("UIListLayout")
	local Source = Instance.new("TextBox")
	local TextLabel = Instance.new("TextLabel")
	local SH_BTN = Instance.new("TextButton")
	local UICorner_4 = Instance.new("UICorner")
	local UICorner_5 = Instance.new("UICorner")
	ParentGui(Internal)
	Internal.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	Internal.DisplayOrder = 32767
	Internal.ResetOnSpawn = false
	Main.Name = "Main"
	Main.Parent = Internal
	Main.BackgroundColor3 = Color3.fromRGB(51, 51, 51)
	Main.BorderColor3 = Color3.fromRGB(51, 51, 51)
	Main.Position = UDim2.new(0.00554428995, 0, 0.738579035, 0)
	Main.Size = UDim2.new(0, 428, 0, 162)
	ClearBtn.Name = "ClearBtn"
	ClearBtn.Parent = Main
	ClearBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
	ClearBtn.BorderColor3 = Color3.fromRGB(60, 60, 60)
	ClearBtn.Position = UDim2.new(0.2463108, 0, 0.727700055, 0)
	ClearBtn.Size = UDim2.new(0, 89, 0, 31)
	ClearBtn.Font = Enum.Font.SourceSans
	ClearBtn.Text = "Clear"
	ClearBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
	ClearBtn.TextSize = 20.000
	UICorner.Parent = ClearBtn
	HideCodeBtn.Name = "HideCodeBtn"
	HideCodeBtn.Parent = Main
	HideCodeBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
	HideCodeBtn.BorderColor3 = Color3.fromRGB(60, 60, 60)
	HideCodeBtn.Position = UDim2.new(0.470807642, 0, 0.727699935, 0)
	HideCodeBtn.Size = UDim2.new(0, 82, 0, 31)
	HideCodeBtn.Font = Enum.Font.SourceSans
	HideCodeBtn.Text = "Hide Code"
	HideCodeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
	HideCodeBtn.TextSize = 20.000
	UICorner_2.Parent = HideCodeBtn
	ExecuteBtn.Name = "ExecuteBtn"
	ExecuteBtn.Parent = Main
	ExecuteBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
	ExecuteBtn.BorderColor3 = Color3.fromRGB(60, 60, 60)
	ExecuteBtn.Position = UDim2.new(0.0175579488, 0, 0.724405408, 0)
	ExecuteBtn.Size = UDim2.new(0, 89, 0, 31)
	ExecuteBtn.Font = Enum.Font.SourceSans
	ExecuteBtn.Text = "Execute"
	ExecuteBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
	ExecuteBtn.TextSize = 20.000
	UICorner_3.Parent = ExecuteBtn
	ScriptHub.Name = "ScriptHub"
	ScriptHub.Parent = Main
	ScriptHub.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
	ScriptHub.BorderColor3 = Color3.fromRGB(60, 60, 60)
	ScriptHub.Position = UDim2.new(0.689796925, 0, 0.165811226, 0)
	ScriptHub.Selectable = false
	ScriptHub.Size = UDim2.new(0, 122, 0, 122)
	ScriptHub.ScrollBarThickness = 5
	UIListLayout.Parent = ScriptHub
	UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
	UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
	UIListLayout.Padding = UDim.new(0, 3)
	Source.Name = "Source"
	Source.Parent = Main
	Source.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
	Source.BorderColor3 = Color3.fromRGB(60, 60, 60)
	Source.ClipsDescendants = true
	Source.Position = UDim2.new(0, 7, 0, 27)
	Source.Size = UDim2.new(0.647008598, 0, 0.493827164, 0)
	Source.ZIndex = 3
	Source.ClearTextOnFocus = false
	Source.Font = Enum.Font.Code
	Source.MultiLine = true
	Source.PlaceholderColor3 = Color3.fromRGB(204, 204, 204)
	Source.Text = "print(\"Quick Internal\")"
	Source.TextColor3 = Color3.fromRGB(204, 204, 204)
	Source.TextSize = 15.000
	Source.TextWrapped = true
	Source.TextXAlignment = Enum.TextXAlignment.Left
	Source.TextYAlignment = Enum.TextYAlignment.Top
	TextLabel.Parent = Main
	TextLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	TextLabel.BackgroundTransparency = 1.000
	TextLabel.Position = UDim2.new(0.017557947, 0, 0.0370370373, 0)
	TextLabel.Size = UDim2.new(0, 420, 0, 13)
	TextLabel.Font = Enum.Font.SourceSansBold
	TextLabel.Text = "Quick Internal"
	TextLabel.TextColor3 = Color3.fromRGB(137, 137, 137)
	TextLabel.TextSize = 14.000
	SH_BTN.Name = "SH_BTN"
	SH_BTN.Parent = Main
	SH_BTN.BackgroundColor3 = Color3.fromRGB(71, 71, 71)
	SH_BTN.Position = UDim2.new(0.0901639313, 0, 0, 0)
	SH_BTN.Size = UDim2.new(0, 97, 0, 38)
	SH_BTN.Visible = false
	SH_BTN.Font = Enum.Font.SourceSans
	SH_BTN.Text = "Example"
	SH_BTN.TextColor3 = Color3.fromRGB(239, 239, 239)
	SH_BTN.TextSize = 14.000
	SH_BTN.TextStrokeTransparency = 0.800
	SH_BTN.TextWrapped = true
	UICorner_4.Parent = SH_BTN
	UICorner_5.Parent = Main
	return Internal
end

local Internal = CreateGui()
local Gui = Internal.Main

SmoothDrag(Gui)
Gui.ScriptHub.CanvasSize = UDim2.new(0, 0, 0, Gui.ScriptHub.UIListLayout.AbsoluteContentSize.Y)
Gui.ScriptHub.UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
	Gui.ScriptHub.CanvasSize = UDim2.new(0, 0, 0, Gui.ScriptHub.UIListLayout.AbsoluteContentSize.Y)
end)

local function sh(name, func)
	name = name or "Script"
	local button = Gui.SH_BTN:Clone()
	button.Parent = Gui.ScriptHub
	button.Visible = true
	button.Text = name
	button.MouseButton1Down:Connect(function()
		if (type(func) == "function") then
			pcall(func)
	end)
end

local TextHidden = false

Gui.ExecuteBtn.MouseButton1Down:Connect(function()
	loadstring(Gui.Source.Text)()
end)

Gui.ClearBtn.MouseButton1Down:Connect(function()
	Gui.Source.Text = ""
end)

Gui.HideCodeBtn.MouseButton1Down:Connect(function()
	if TextHidden then
		Gui.Source.TextTransparency = 0.9
		wait()
		Gui.Source.TextTransparency = 0.8
		wait()
		Gui.Source.TextTransparency = 0.7
		wait()
		Gui.Source.TextTransparency = 0.6
		wait()
		Gui.Source.TextTransparency = 0.5
		wait()
		Gui.Source.TextTransparency = 0.4
		wait()
		Gui.Source.TextTransparency = 0.3
		wait()
		Gui.Source.TextTransparency = 0.2
		wait()
		Gui.Source.TextTransparency = 0.1
		wait()
		Gui.Source.TextTransparency = 0
		wait()
		TextHidden = false
		Gui.HideCodeBtn.Text = "Hide Code"
	else
		Gui.Source.TextTransparency = 0.1
		wait()
		Gui.Source.TextTransparency = 0.2
		wait()
		Gui.Source.TextTransparency = 0.3
		wait()
		Gui.Source.TextTransparency = 0.4
		wait()
		Gui.Source.TextTransparency = 0.5
		wait()
		Gui.Source.TextTransparency = 0.6
		wait()
		Gui.Source.TextTransparency = 0.7
		wait()
		Gui.Source.TextTransparency = 0.8
		wait()
		Gui.Source.TextTransparency = 0.9
		wait()
		Gui.Source.TextTransparency = 1
		wait()
		TextHidden = true
		Gui.HideCodeBtn.Text = "Show Code"
	end
end)

game:GetService("UserInputService").InputBegan:Connect(function(Key,IsChat)
	if IsChat then return end
	if Key.KeyCode == Enum.KeyCode.Minus then
		Internal.Enabled = (not Internal.Enabled)
	end
end)







sh("Dark Admin", function()
	loadr("https://raw.githubusercontent.com/daximul/who/main/a/test/what/script.lua");
end)

sh("Owl Hub", function()
	if (not is_sirhurt_closure) and syn then
		loadstring(game:HttpGet("https://raw.githubusercontent.com/ZinityDrops/OwlHubLink/master/OwlHubBack.lua"))();
	else
		loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/Patch-Shack/newLoad/master/owlhub.lua"))();
	end
end)

sh("Dex", function()
	if (not is_sirhurt_closure) and syn then
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
	else
		loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/Patch-Shack/newLoad/master/dexv2.lua"))();
	end
end)

sh("Anti AFK", function()
	local GC = getconnections or get_signal_cons
	if GC then
		for i,v in pairs(GC(game:GetService("Players").LocalPlayer.Idled)) do
			if v["Disable"] then
				v["Disable"](v)
			elseif v["Disconnect"] then
				v["Disconnect"](v)
			end
		end
	end
end)

sh("Btools", function()
	Instance.new("HopperBin", game:GetService("Players").LocalPlayer:FindFirstChildOfClass("Backpack")).BinType = 1
	Instance.new("HopperBin", game:GetService("Players").LocalPlayer:FindFirstChildOfClass("Backpack")).BinType = 2
	Instance.new("HopperBin", game:GetService("Players").LocalPlayer:FindFirstChildOfClass("Backpack")).BinType = 3
	Instance.new("HopperBin", game:GetService("Players").LocalPlayer:FindFirstChildOfClass("Backpack")).BinType = 4
end)

sh("F3X", function()
	loadstring(game:GetObjects("rbxassetid://4698064966")[1].Source)()
end)

sh("Toon ESP", function()
	loadr("https://raw.githubusercontent.com/Patch-Shack/ToonESP/main/main.lua");
end)
