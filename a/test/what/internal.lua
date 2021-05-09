if (not getgenv()["da_env"]) then loadstring(game:HttpGetAsync(("https://raw.githubusercontent.com/daximul/who/main/a/test/what/script.lua")))(); end

pcall(function() if (not getgenv()["da_env"]) and (not getgenv()["da_env"]["loaded"]) then repeat wait() until getgenv()["da_env"]["loaded"] end end)

local virtual = getgenv()["da_env"]
virtual.disablecmdbar()
virtual.internal(true)

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
			if not isfolder("Dark Admin/Internal") then
				makefolder("Dark Admin/Internal")
				if not isfolder("Dark Admin/Internal/Execution") then
					makefolder("Dark Admin/Internal/Execution")
					if not isfile("Dark Admin/Internal/Execution/Script.lua") then
						writefile("Dark Admin/Internal/Execution/Script.lua", "")
					end
				end
			end
		end
	end
end)

spawn(function()
	if isfolder and makefolder and isfile and writefile then
		if isfolder("Dark Admin") then
			if not isfolder("Dark Admin/Internal") then
				makefolder("Dark Admin/Internal")
				if not isfolder("Dark Admin/Internal/Execution") then
					makefolder("Dark Admin/Internal/Execution")
					if not isfile("Dark Admin/Internal/Execution/Script.lua") then
						writefile("Dark Admin/Internal/Execution/Script.lua", "")
					end
				end
			end
		end
	end
end)

local function loadstri(source)
	local Code = nil
	local function CatchedLoad()
		writefile("Dark Admin/Internal/Execution/Script.lua", source)
		wait()
		Code = loadfile("Dark Admin/Internal/Execution/Script.lua")()
	end
	local function HandleError(err)
		print("Original Error: " .. tostring(err))
		print("Error, Stack Traceback: " .. tostring(debug.traceback()))
		Code = nil
		return false
	end
	xpcall(CatchedLoad, HandleError)
end

local function loadr(i)
	loadstring(game:HttpGetAsync(tostring(i)))();
end

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

local GUI = Import(6786452051)
GUI.Main.Visible = false
GUI.Main.CommandBar.Box.Text = ""
GUI.Main.CommandBar.cmdsu.Text = ""
ParentGui(GUI)
local Source = GUI.Main.Source.Input
local ScriptHub = GUI.Main.Hub.Scripts
local CommandInput = GUI.Main.CommandBar
local Cmdbar = CommandInput.Box
local iTab = nil
local TextHidden = false

spawn(function()
	ScriptHub.CanvasSize = UDim2.new(0, 0, 0, ScriptHub.UIListLayout.AbsoluteContentSize.Y)
	ScriptHub.UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
		ScriptHub.CanvasSize = UDim2.new(0, 0, 0, ScriptHub.UIListLayout.AbsoluteContentSize.Y)
	end)
	SmoothScroll(ScriptHub, .14)
	SmoothDrag(GUI.Main)
end)

local function addsh(name, func)
	name = name or "Script"
	local button = GUI.ExampleBtn:Clone()
	button.Parent = ScriptHub
	button.Visible = true
	button.Label.Text = name
	button.MouseButton1Down:Connect(function()
		if (type(func) == "function") then
			pcall(func)
		end
	end)
end

GUI.Main.ExecuteBtn.MouseButton1Down:Connect(function()
	loadstri(Source.Text)
end)

GUI.Main.ClearBtn.MouseButton1Down:Connect(function()
	Source.Text = ""
end)

GUI.Main.CodeVisibleBtn.MouseButton1Down:Connect(function()
	if TextHidden then
		Source.TextTransparency = 0.9
		wait()
		Source.TextTransparency = 0.8
		wait()
		Source.TextTransparency = 0.7
		wait()
		Source.TextTransparency = 0.6
		wait()
		Source.TextTransparency = 0.5
		wait()
		Source.TextTransparency = 0.4
		wait()
		Source.TextTransparency = 0.3
		wait()
		Source.TextTransparency = 0.2
		wait()
		Source.TextTransparency = 0.1
		wait()
		Source.TextTransparency = 0
		wait()
		TextHidden = false
		GUI.Main.CodeVisibleBtn.Label.Text = "Hide Code"
	else
		Source.TextTransparency = 0.1
		wait()
		Source.TextTransparency = 0.2
		wait()
		Source.TextTransparency = 0.3
		wait()
		Source.TextTransparency = 0.4
		wait()
		Source.TextTransparency = 0.5
		wait()
		Source.TextTransparency = 0.6
		wait()
		Source.TextTransparency = 0.7
		wait()
		Source.TextTransparency = 0.8
		wait()
		Source.TextTransparency = 0.9
		wait()
		Source.TextTransparency = 1
		wait()
		TextHidden = true
		GUI.Main.CodeVisibleBtn.Label.Text = "Show Code"
	end
end)

GUI.Main.Exit.MouseButton1Down:Connect(function()
	GUI.Main.Visible = false
end)

game:GetService("UserInputService").InputBegan:Connect(function(Key, IsChat)
	if IsChat then return end
	if Key.KeyCode == Enum.KeyCode.Insert then
		GUI.Main.Visible = (not GUI.Main.Visible)
	end
	if (Key.KeyCode == Enum.KeyCode.BackSlash) and (GUI.Main.Visible == true) then
		Cmdbar:CaptureFocus()
		spawn(function()
			repeat Cmdbar.Text = "" until Cmdbar.Text == ""
		end)
	end
end)

Cmdbar:GetPropertyChangedSignal("Text"):Connect(function()
	if Cmdbar:IsFocused() then
		CommandInput.cmdsu.Text = ""
		local InputText = string.lower(Cmdbar.Text)
		if InputText == "" then return end
		if InputText == " " then return end
		for _, v in next, virtual.getcmds() do
			local Name = v.NAME
			local Aliases = v.ALIAS
			local FoundAlias = false
			if virtual.matchsearch(InputText, Name) then
				CommandInput.cmdsu.Text = Name
				break
			end
			for _, v2 in next, Aliases do
				if virtual.matchsearch(InputText, v2) then
					FoundAlias = true
					CommandInput.cmdsu.Text = v2
					break
				end
				if FoundAlias then break end
			end
		end
	end
end)

local function autoComplete(str, curText)
	local endingChar = {"[", "/", "(", " "}
	local stop = 0
	for i=1,#str do
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
	Cmdbar.Text = curText:sub(1,subPos) .. str:sub(1, stop - 1) .. " "
	wait()
	Cmdbar.Text = Cmdbar.Text:gsub( "\t", "" )
	Cmdbar.CursorPosition = #Cmdbar.Text + 1
end

Cmdbar.Focused:Connect(function()
	local userinp = game:GetService("UserInputService")
	iTab = userinp.InputBegan:Connect(function(input, gameProcessed)
		if Cmdbar:IsFocused() then
			if input.KeyCode == Enum.KeyCode.Tab then
				if CommandInput.cmdsu.Text == "" then
					autoComplete("commands")
				elseif CommandInput.cmdsu.Text == " " then
					autoComplete("commands")
				else
					autoComplete(CommandInput.cmdsu.Text)
				end
			end
		else
			iTab:Disconnect()
		end
	end)
end)

Cmdbar.FocusLost:Connect(function(enterPressed)
	if enterPressed then
		spawn(function()
			local cmdbarText = Cmdbar.Text:gsub("^" .. "%" .. "\\", "")
			virtual.execCmd(cmdbarText, game:GetService("Players").LocalPlayer, true)
		end)
	end
	wait()
	if not Cmdbar:IsFocused() then
		Cmdbar.Text = ""
		CommandInput.cmdsu.Text = ""
	end
end)














spawn(function()

addsh("Owl Hub", function()
	if (not is_sirhurt_closure) and syn then
		loadstring(game:HttpGet("https://raw.githubusercontent.com/ZinityDrops/OwlHubLink/master/OwlHubBack.lua"))();
	else
		loadr("https://raw.githubusercontent.com/Patch-Shack/newLoad/master/owlhub.lua");
	end
end)

end)
