while not game:IsLoaded() or not game:GetService("CoreGui") or not game:GetService("Players").LocalPlayer or not game:GetService("Players").LocalPlayer.PlayerGui do wait() end

if DA_ISLOADED then
	warn("[da]: Already Running!")
	return
end

pcall(function() getgenv().DA_ISLOADED = true end)

if isfolder and makefolder and isfile and writefile then
	if not isfolder("Dark Admin Plugins") then
		makefolder("Dark Admin Plugins")
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

local GUI = Import("interface.lua")
local Main = GUI.Main
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
	KeepDA = false
}

local Cmdbar = Main.Box
local cmds = {}
local customAlias = {}
local Network_Loop = nil
local Old_Net_Method = true
local DEBUG = false
local Original_User_Id = Players.LocalPlayer.UserId
local PromptOverlay = CoreGui:FindFirstChild("RobloxPromptGui"):FindFirstChild("promptOverlay")
local origsettings = {abt = game:GetService("Lighting").Ambient, oabt = game:GetService("Lighting").OutdoorAmbient, brt = game:GetService("Lighting").Brightness, time = game:GetService("Lighting").ClockTime, fe = game:GetService("Lighting").FogEnd, fs = game:GetService("Lighting").FogStart, gs = game:GetService("Lighting").GlobalShadows}

function randomString()
	local length = math.random(10,20)
	local array = {}
	for i = 1, length do
		array[i] = string.char(math.random(32, 126))
	end
	return table.concat(array)
end

--// Command Variables

local currentToolSize = ""
local currentGripPos = ""
local cmdinfjump = false
local spawnpoint = false
local spDelay = 0.1
local cmdautorj = false
FLYING = false
viewing = nil
fcRunning = false
ESPenabled = false
Floating = false
swimming = false
floatName = randomString()
QEfly = true
invisRunning = false
LastDeathPos = nil

--// End of Command Variables

local SU_SomeCheckPlace = {
	Attachment = "HairAttachment";
}
local SU_Check1 = Players.LocalPlayer.Character:FindFirstChild("Head")
if SU_Check1 then
	local SU_Check2 = SU_Check1:FindFirstChild(SU_SomeCheckPlace.Attachment)
	if SU_Check2 then
		SU_Check2:Destroy()
	end
end
Players.LocalPlayer.CharacterAdded:Connect(function()
	wait(1)
	local SU_Check3 = Players.LocalPlayer.Character:FindFirstChild("Head")
	if SU_Check3 then
		local SU_Check4 = SU_Check1:FindFirstChild(SU_SomeCheckPlace.Attachment)
		if SU_Check4 then
			SU_Check4:Destroy()
		end
	end
end)

local function onDiedLastDeath()
	spawn(function()
		if pcall(function() Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid") end) and Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
			Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid").Died:Connect(function()
				if getRoot(Players.LocalPlayer.Character) then
					LastDeathPos = getRoot(Players.LocalPlayer.Character).CFrame
				end
			end)
		else
			wait(2)
			onDiedLastDeath()
		end
	end)
end

Players.LocalPlayer.CharacterAdded:Connect(function()
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
	
	onDiedLastDeath()
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

Players.PlayerAdded:Connect(function(player)
	LogJoin(player)
	LogChat(player)
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

function Startup()
	Main.Position = UDim2.new(0.5, -75, 1.5, -105)
	NotificationTemplate.Position = UDim2.new(-1, -75, 1.029, -105)
	CommandsGui.Position = UDim2.new(0.694, -75, 10, -105)
	PluginBrowser.Position = UDim2.new(0.42, -75, 2, -105)
	DaUi.Position = UDim2.new(0.42, -75, 2, -105)
	Cmdbar.Text = ""
	DAMouse.Move:Connect(checkTT)
end

local inputService = game:GetService("UserInputService")
local heartbeat = game:GetService("RunService").Heartbeat
function SmoothDrag(frame)
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

local function OldParentGui(Gui)
	Gui.Name = HttpService:GenerateGUID(false):gsub("-", ""):sub(1, math.random(25, 30))
	if CoreGui:FindFirstChild("RobloxGui") then
		Gui.Parent = CoreGui["RobloxGui"]
	else
		Gui.Parent = CoreGui
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

function CaptureCmdBar()
	Cmdbar:CaptureFocus()
	spawn(function()
		repeat Cmdbar.Text = "" until Cmdbar.Text == ""
	end)
	spawn(function()
		CmdBarStatus(true)
	end)
end

local function tools(plr)
	if plr:FindFirstChildOfClass("Backpack"):FindFirstChildOfClass("Tool") or plr.Character:FindFirstChildOfClass("Tool") then
		return true
	else
		return false
	end
end

-- net is patched, both methods dont work now. fix this idiot : snipdoa
local function SetSimulationRadius()
	if Old_Net_Method == true then
		Network_Loop = game:GetService("RunService").RenderStepped:Connect(function()
			workspace.FallenPartsDestroyHeight = 0/1/0
			settings().Physics.ThrottleAdjustTime = math.huge-math.huge
			settings().Physics.AllowSleep = false
			setsimulationradius(math.huge*math.huge,math.huge*math.huge,1/0*1/0*1/0*1/0*1/0)
			Players.LocalPlayer.SimulationRadius = math.huge
		end)
	else
		Import("cl_net.lua")
	end
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

function CmdBarStatus(bool)
	local GuiPositions = {
		Shown = UDim2.new(0.5, -75, 0.997, -105),
		Hidden = UDim2.new(0.5, -75, 1.5, -105),
	}
	if bool == true then
		Main:TweenPosition(GuiPositions.Shown, "InOut", "Sine", 0.4, true, nil)
	else
		Main:TweenPosition(GuiPositions.Hidden, "InOut", "Sine", 0.4, true, nil)
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

MaxNotifications = 5
NotificationName = nil
NotificationDuration = nil
function notify(NotifName, NotifDesc, NotifDuration)
	spawn(function()
		if NotifDuration ~= nil then
			NotificationDuration = NotifDuration
		else
			NotificationDuration = 5
		end
		if NotifName ~= "" then
			NotificationName = NotifName
		else
			NotificationName = "Notification"
		end
		local Notifications = GUI.Notifications:GetChildren()
		if #Notifications >= MaxNotifications then
			Notifications[1]:TweenPosition(UDim2.new(-1, -75, Notifications[1].Position.Y.Scale, -105),"InOut","Linear",0.2,true);wait(0.2)
			Notifications[1]:Destroy()
			for i,v in pairs(Notifications) do if v ~= nil then
					v:TweenPosition(UDim2.new(0.079, -75, v.Position.Y.Scale - 0.12, -105),"InOut","Linear",0.2,true)
				end
			end
			local NewNotification = NotificationTemplate:Clone()
			NewNotification.Name = tostring(#Notifications+1)
			NewNotification.Parent = GUI.Notifications
			NewNotification.Title.Text = NotificationName
			NewNotification.Border.Frame.Description.Text = NotifDesc
			NewNotification:TweenPosition(UDim2.new(0.079, -75, 1.029, -105),"InOut","Linear",0.2,true)
		else
			for i,v in pairs(Notifications) do
				v:TweenPosition(UDim2.new(0.079, -75, v.Position.Y.Scale - 0.12, -105),"InOut","Linear",0.2,true)
			end
			local NewNotification = NotificationTemplate:Clone()
			NewNotification.Name = tostring(#Notifications+1)
			NewNotification.Parent = GUI.Notifications
			NewNotification.Title.Text = NotificationName
			NewNotification.Border.Frame.Description.Text = NotifDesc
			NewNotification:TweenPosition(UDim2.new(0.079, -75, 1.029, -105),"InOut","Linear",0.2,true)
			delay(NotificationDuration,function()
				NewNotification:TweenPosition(UDim2.new(-1, -75, NewNotification.Position.Y.Scale, -105),"InOut","Linear",0.2,true);wait(0.2)
				NewNotification:Destroy()
			end)
		end
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

function checkTT()
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
				-- used to be x - 1
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

local function toClipboard(String) local clipBoard = setclipboard or toclipboard or set_clipboard or (Clipboard and Clipboard.set); if clipBoard then clipBoard(String); notify("", "Copied to clipboard"); else notify("", "Can't use clipboard, printed instead"); print("[Dark Admin]: " .. String) end end

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
		if v.NAME:lower()==cmd_name:lower() or FindInTable(v.ALIAS,cmd_name:lower()) then
			return v
		end
	end
	return customAlias[cmd_name:lower()]
end

function splitString(str,delim)
	local broken = {}
	if delim == nil then delim = "," end
	for w in string.gmatch(str,"[^"..delim.."]+") do
		table.insert(broken,w)
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
		cmdStr = string.gsub(cmdStr,"\\\\","%%BackSlash%%")
		local commandsToRun = splitString(cmdStr,"\\")
		for i,v in pairs(commandsToRun) do
			v = string.gsub(v,"%%BackSlash%%","\\")
			local x,y,num = v:find("^(%d+)%^")
			local cmdDelay = 0
			local infTimes = false
			if num then
				v = v:sub(y+1)
				local x,y,del = v:find("^([%d%.]+)%^")
				if del then
					v = v:sub(y+1)
					cmdDelay = tonumber(del) or 0
				end
			else
				local x,y = v:find("^inf%^")
				if x then
					infTimes = true
					v = v:sub(y+1)
					local x,y,del = v:find("^([%d%.]+)%^")
					if del then
						v = v:sub(y+1)
						del = tonumber(del) or 1
						cmdDelay = (del > 0 and del or 1)
					else
						cmdDelay = 1
					end
				end
			end
			num = tonumber(num or 1)

			if v:sub(1,1) == "!" then
				local chunks = splitString(v:sub(2),split)
				if chunks[1] and lastCmds[chunks[1]] then v = lastCmds[chunks[1]] end
			end

			local args = splitString(v,split)
			local cmdName = args[1]
			local cmd = findCmd(cmdName)
			if cmd then
				table.remove(args,1)
				cargs = args
				if not speaker then speaker = Players.LocalPlayer end
				if store then
					if speaker == Players.LocalPlayer then
						if cmdHistory[1] ~= rawCmdStr and rawCmdStr:sub(1,11) ~= "lastcommand" and rawCmdStr:sub(1,7) ~= "lastcmd" then
							table.insert(cmdHistory,1,rawCmdStr)
						end
					end
					if #cmdHistory > 30 then table.remove(cmdHistory) end

					lastCmds[cmdName] = v
				end
				local cmdStartTime = tick()
				if infTimes then
					while lastBreakTime < cmdStartTime do
						local success,err = pcall(cmd.FUNC,args, speaker)
						if not success and DEBUG then
							warn("Command Error:", cmdName, err)
						end
						wait(cmdDelay)
					end
				else
					for rep = 1,num do
						if lastBreakTime > cmdStartTime then break end
						local success,err = pcall(function()
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
	local start = begin-1
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

function addcmd(name,alias,func,plgn)
	cmds[#cmds+1]=
		{
			NAME=name;
			ALIAS=alias or {};
			FUNC=func;
			PLUGIN=plgn;
		}
end

function removecmd2(cmd)
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
		removecmd2(cmd)
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

local SpecialPlayerCases = {
	["all"] = function(speaker)return game.Players:GetPlayers() end,
	["others"] = function(speaker)
		local plrs = {}
		for i,v in pairs(game.Players:GetPlayers()) do
			if v ~= speaker then
				table.insert(plrs,v)
			end
		end
		return plrs
	end,
	["me"] = function(speaker)return {speaker} end,
	["#(%d+)"] = function(speaker,args,currentList)
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
	["random"] = function(speaker,args,currentList)
		local players = currentList
		return {players[math.random(1,#players)]}
	end,
	["%%(.+)"] = function(speaker,args)
		local returns = {}
		local team = args[1]
		for _,plr in pairs(game.Players:GetPlayers()) do
			if plr.Team and string.sub(string.lower(plr.Team.Name),1,#team) == string.lower(team) then
				table.insert(returns,plr)
			end
		end
		return returns
	end,
	["allies"] = function(speaker)
		local returns = {}
		local team = speaker.Team
		for _,plr in pairs(game.Players:GetPlayers()) do
			if plr.Team == team then
				table.insert(returns,plr)
			end
		end
		return returns
	end,
	["enemies"] = function(speaker)
		local returns = {}
		local team = speaker.Team
		for _,plr in pairs(game.Players:GetPlayers()) do
			if plr.Team ~= team then
				table.insert(returns,plr)
			end
		end
		return returns
	end,
	["team"] = function(speaker)
		local returns = {}
		local team = speaker.Team
		for _,plr in pairs(game.Players:GetPlayers()) do
			if plr.Team == team then
				table.insert(returns,plr)
			end
		end
		return returns
	end,
	["nonteam"] = function(speaker)
		local returns = {}
		local team = speaker.Team
		for _,plr in pairs(game.Players:GetPlayers()) do
			if plr.Team ~= team then
				table.insert(returns,plr)
			end
		end
		return returns
	end,
	["friends"] = function(speaker,args)
		local returns = {}
		for _,plr in pairs(game.Players:GetPlayers()) do
			if plr:IsFriendsWith(speaker.UserId) and plr ~= speaker then
				table.insert(returns,plr)
			end
		end
		return returns
	end,
	["nonfriends"] = function(speaker,args)
		local returns = {}
		for _,plr in pairs(game.Players:GetPlayers()) do
			if not plr:IsFriendsWith(speaker.UserId) and plr ~= speaker then
				table.insert(returns,plr)
			end
		end
		return returns
	end,
	["guests"] = function(speaker,args)
		local returns = {}
		for _,plr in pairs(game.Players:GetPlayers()) do
			if plr.Guest then
				table.insert(returns,plr)
			end
		end
		return returns
	end,
	["bacons"] = function(speaker,args)
		local returns = {}
		for _,plr in pairs(game.Players:GetPlayers()) do
			if plr.Character:FindFirstChild("Pal Hair") or plr.Character:FindFirstChild("Kate Hair") then
				table.insert(returns,plr)
			end
		end
		return returns
	end,
	["age(%d+)"] = function(speaker,args)
		local returns = {}
		local age = tonumber(args[1])
		if not age == nil then return end
		for _,plr in pairs(game.Players:GetPlayers()) do
			if plr.AccountAge <= age then
				table.insert(returns,plr)
			end
		end
		return returns
	end,
	["nearest"] = function(speaker,args,currentList)
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
	["farthest"] = function(speaker,args,currentList)
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
	["group(%d+)"] = function(speaker,args)
		local returns = {}
		local groupID = tonumber(args[1])
		for _,plr in pairs(game.Players:GetPlayers()) do
			if plr:IsInGroup(groupID) then  
				table.insert(returns,plr)
			end
		end
		return returns
	end,
	["alive"] = function(speaker,args)
		local returns = {}
		for _,plr in pairs(game.Players:GetPlayers()) do
			if plr.Character and plr.Character:FindFirstChildOfClass("Humanoid") and plr.Character:FindFirstChildOfClass("Humanoid").Health > 0 then
				table.insert(returns,plr)
			end
		end
		return returns
	end,
	["dead"] = function(speaker,args)
		local returns = {}
		for _,plr in pairs(game.Players:GetPlayers()) do
			if (not plr.Character or not plr.Character:FindFirstChildOfClass("Humanoid")) or plr.Character:FindFirstChildOfClass("Humanoid").Health <= 0 then
				table.insert(returns,plr)
			end
		end
		return returns
	end,
	["rad(%d+)"] = function(speaker,args)
		local returns = {}
		local radius = tonumber(args[1])
		local speakerChar = speaker.Character
		if not speakerChar or not getRoot(speakerChar) then return end
		for _,plr in pairs(game.Players:GetPlayers()) do
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
	for i,v in pairs(game.Players:GetChildren()) do
		if string.sub(string.lower(v.Name),1,#name) == string.lower(name) then
			table.insert(found,v)
		end
	end
	return found
end

function getPlayer(list,speaker)
	if list == nil then return {speaker.Name} end
	local nameList = splitString(list,",")

	local foundList = {}

	for _,name in pairs(nameList) do
		if string.sub(name,1,1) ~= "+" and string.sub(name,1,1) ~= "-" then name = "+"..name end
		local tokens = toTokens(name)
		local initialPlayers = game.Players:GetPlayers()

		for i,v in pairs(tokens) do
			if v.Operator == "+" then
				local tokenContent = v.Name
				local foundCase = false
				for regex,case in pairs(SpecialPlayerCases) do
					local matches = {string.match(tokenContent,"^"..regex.."$")}
					if #matches > 0 then
						foundCase = true
						initialPlayers = onlyIncludeInTable(initialPlayers,case(speaker,matches,initialPlayers))
					end
				end
				if not foundCase then
					initialPlayers = onlyIncludeInTable(initialPlayers,getPlayersByName(tokenContent))
				end
			else
				local tokenContent = v.Name
				local foundCase = false
				for regex,case in pairs(SpecialPlayerCases) do
					local matches = {string.match(tokenContent,"^"..regex.."$")}
					if #matches > 0 then
						foundCase = true
						initialPlayers = removeTableMatches(initialPlayers,case(speaker,matches,initialPlayers))
					end
				end
				if not foundCase then
					initialPlayers = removeTableMatches(initialPlayers,getPlayersByName(tokenContent))
				end
			end
		end

		for i,v in pairs(initialPlayers) do table.insert(foundList,v) end
	end

	local foundNames = {}
	for i,v in pairs(foundList) do table.insert(foundNames,v.Name) end

	return foundNames
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

local function updateCmdsu(str,curText)
	wait(0.02)
	if str == nil then
		-- do nothing
	else
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
			wait(0.02)
		end
		if curText:sub(subPos+1,subPos+1) == "!" then subPos = subPos + 1 end
		CmdSu.Text = curText:sub(1,subPos) .. str:sub(1, stop - 1)..' '
		wait()
		CmdSu.Text = CmdSu.Text:gsub( '\t', '' )
	end
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
IndexContents('')

getprfx=function(strn)
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

local tabComplete = nil
Cmdbar.FocusLost:Connect(function(enterPressed)
	CmdSu.Text = ""
	if tabComplete then tabComplete:Disconnect() end
	wait()
	if not Cmdbar:IsFocused() then
		IndexContents('')
	end
end)

Cmdbar:GetPropertyChangedSignal("Text"):Connect(function()
	if Cmdbar:IsFocused() then
		IndexContents(Cmdbar.Text)
		updateCmdsu(topCommand)
	end
end)

Cmdbar.Focused:Connect(function()
	local userinpser = game:GetService("UserInputService")
	tabComplete = userinpser.InputBegan:Connect(function(input, gameProcessed)
		if Cmdbar:IsFocused() then
			if input.KeyCode == Enum.KeyCode.Tab and topCommand ~= nil then
				autoComplete(topCommand)
			end
		else
			tabComplete:Disconnect()
		end
	end)
end)

local function Search()
	local InputText = Cmdbar.Text
	for _,button in pairs(CMDsF:GetChildren())do
		if button:IsA("TextButton") then
			local chunks = {}
			if InputText:sub(#InputText,#InputText) == "\\" then InputText = "" end
			for w in string.gmatch(InputText, "[^\\]+") do
				table.insert(chunks, w)
			end
			if #chunks > 0 then InputText = chunks[#chunks] end
			if Match(button.Label.Text, InputText) then
				button.Visible = true
			else
				button.Visible = false
			end
		end
	end
end
local function Search2()
	local InputText = DaUi.CmdSearch.Box.Text
	for _,button in pairs(DaUi.CmdArea.ScrollingFrame:GetChildren())do
		if button:IsA("TextButton") then
			local chunks = {}
			if InputText:sub(#InputText,#InputText) == "\\" then InputText = "" end
			for w in string.gmatch(InputText, "[^\\]+") do
				table.insert(chunks, w)
			end
			if #chunks > 0 then InputText = chunks[#chunks] end
			if Match(button.Label.Text, InputText) then
				button.Visible = true
			else
				button.Visible = false
			end
		end
	end
end
Cmdbar.Changed:Connect(Search)
DaUi.CmdSearch.Box:GetPropertyChangedSignal("Text"):Connect(function()
	Search2()
end)
CMDsF.CanvasSize = UDim2.new(0, 0, 0, CMDsF.UIListLayout.AbsoluteContentSize.Y)
CMDsF.UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
	CMDsF.CanvasSize = UDim2.new(0, 0, 0, CMDsF.UIListLayout.AbsoluteContentSize.Y)
end)
PluginBrowser.Area.ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, PluginBrowser.Area.ScrollingFrame.UIListLayout.AbsoluteContentSize.Y)
PluginBrowser.Area.ScrollingFrame.UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
	PluginBrowser.Area.ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, PluginBrowser.Area.ScrollingFrame.UIListLayout.AbsoluteContentSize.Y)
end)
DaUi.ChatLogsArea.ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, DaUi.ChatLogsArea.ScrollingFrame.UIListLayout.AbsoluteContentSize.Y)
DaUi.ChatLogsArea.ScrollingFrame.UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
	DaUi.ChatLogsArea.ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, DaUi.ChatLogsArea.ScrollingFrame.UIListLayout.AbsoluteContentSize.Y)
end)
DaUi.JoinLogsArea.ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, DaUi.JoinLogsArea.ScrollingFrame.UIListLayout.AbsoluteContentSize.Y)
DaUi.JoinLogsArea.ScrollingFrame.UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
	DaUi.JoinLogsArea.ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, DaUi.JoinLogsArea.ScrollingFrame.UIListLayout.AbsoluteContentSize.Y)
end)
DaUi.CmdArea.ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, DaUi.CmdArea.ScrollingFrame.UIListLayout.AbsoluteContentSize.Y)
DaUi.CmdArea.ScrollingFrame.UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
	DaUi.CmdArea.ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, DaUi.CmdArea.ScrollingFrame.UIListLayout.AbsoluteContentSize.Y)
end)

function addcmdareatext(name,cmdname,alias,desc,plug)
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
		CommandFrame.Alias.Text = ("Aliases: " .. table.concat(alias, ", "))
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
end

function addcmdtext(text,name,desc,plug)
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

local Settings_FileName = ("DA_FE.da");
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
	end
end

saves()

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
		}
		writefileCooldown(Settings_FileName, game:GetService("HttpService"):JSONEncode(update))
	end
end

function addPlugin(name)
	if name:lower() == 'plugin file name' or name:lower() == 'da_fe.da' or name == 'da' then
		notify('Plugin Error','Please enter a valid plugin')
	else
		local file
		local fileName
		if name:sub(-3) == '.da' then
			pcall(function() file = readfile("Dark Admin Plugins/" .. name) end)
			fileName = name
		else
			pcall(function() file = readfile("Dark Admin Plugins/".. name .. ".da") end)
			fileName = name..'.da'
		end
		if file then
			if not FindInTable(Settings.PluginsTable, fileName) then
				table.insert(Settings.PluginsTable, fileName)
				LoadPlugin(fileName)
			else
				notify('Plugin Error','This plugin is already added')
			end
		else
			notify('Plugin Error','Cannot locate file "'..fileName..'".')
		end
	end
end

function deletePlugin(name)
	local pName = name..'.da'
	if name:sub(-3) == '.da' then
		pName = name
	end
	for i = #cmds,1,-1 do
		if cmds[i].PLUGIN == pName then
			table.remove(cmds, i)
		end
	end
	for i,v in pairs(CMDsF:GetChildren()) do
		if v.Name == 'PLUGIN_'..pName then
			v:Destroy()
		end
	end
	for i,v in pairs(DaUi.CmdArea.ScrollingFrame:GetChildren()) do
		if v.Name == 'PLUGIN_'..name then
			v:Destroy()
		end
		if v.Name == 'PLUGIN_'..pName then
			v:Destroy()
		end
	end
	for i,v in pairs(Settings.PluginsTable) do
		if v == pName then
			table.remove(Settings.PluginsTable, i)
			notify('Removed Plugin',pName..' was removed')
		end
	end
	IndexContents('')
end

local PluginCache
function LoadPlugin(val,startup)
	local plugin

	function CatchedPluginLoad()
		plugin = loadfile("Dark Admin Plugins/" .. val)()
	end

	function handlePluginError(plerror)
		notify('Plugin Error', val)
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
				notify('Loaded Plugin',"Name: " .. plugin["PluginName"])
			end)
		end
		for i,v in pairs(plugin["Commands"]) do 
			local cmdExt = ''
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
				addcmdtext(newName,val,v["Description"],true)
				addcmdareatext(cmdName, newName, v["Aliases"], v["Description"], true)
			else
				addcmdtext(cmdName,val,v["Description"],true)
				addcmdareatext(cmdName, cmdName, v["Aliases"], v["Description"], true)
			end
		end
		IndexContents('')
	elseif plugin == nil then
		plugin = nil
	end
end

function FindPlugins()
	if Settings.PluginsTable ~= nil and type(Settings.PluginsTable) == "table" then
		for i,v in pairs(Settings.PluginsTable) do
			LoadPlugin(v,true)
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
		local BG = Instance.new('BodyGyro')
		local BV = Instance.new('BodyVelocity')
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
	local ExtensionFile = ("Dark Admin Plugins/" .. NewFileName .. ".da")
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
	wait()
	message = message:lower()
	do_exec(message, Players.LocalPlayer)
end)

DAMouse.KeyDown:Connect(function(key)
	if (key == Settings.Prefix) then
		CaptureCmdBar()
	end
end)

Cmdbar.FocusLost:Connect(function(enterPressed)
	if enterPressed then
		pcall(function()
			CmdBarStatus(false)
		end)
		local cmdbarText = Cmdbar.Text:gsub("^"..'%'..Settings.Prefix,"")
		execCmd(cmdbarText,Players.LocalPlayer,true)
	end
	wait()
	if not Cmdbar:IsFocused() then
		Cmdbar.Text = ""
		IndexContents('')
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

--// Setup Admin & Ui & Plugin Browser
pcall(function()
	Startup()
	OldParentGui(GUI)
	SmoothDrag(CommandsGui)
	SmoothDrag(PluginBrowser)
	SmoothDrag(DaUi)
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
					pcall(function() file = readfile(placeName..' Chat Logs ('..fileext..').txt') end)
					if file then
						fileext = fileext+1
						nameFile()
					else
						writefileCooldown(placeName..' Chat Logs ('..fileext..').txt', writelogsFile)
					end
				end
				nameFile()
				notify("Chat Logs", "Check the Workspace Folder of your Exploit")
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
					pcall(function() file = readfile(placeName..' Join Logs ('..fileext..').txt') end)
					if file then
						fileext = fileext+1
						nameFile()
					else
						writefileCooldown(placeName..' Join Logs ('..fileext..').txt', writelogsFile)
					end
				end
				nameFile()
				notify("Join Logs", "Check the Workspace Folder of your Exploit")
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
		if Settings.KeepDA and syn.queue_on_teleport then
			syn.queue_on_teleport('loadstring(game:HttpGetAsync(("https://raw.githubusercontent.com/daximul/who/main/a/test/what/script.lua")))();')
		end
	end)
end)
spawn(function()
	BrowserBtn("Owl Hub", "Owl Hub", "Load Owl Hub", "return loadstring(game:HttpGet('https://raw.githubusercontent.com/daximul/who/main/a/test/what/browserplugins/owlhub.lua'))();")
	BrowserBtn("Telekinesis", "Telekinesis", "Control Unanchored Parts\nControls\nE = Push Part Away\nQ = Push Part Closer\n+ = Increase Telekinesis Strength(too much will make the part spaz out)\n- = Decrease Telekinesis Strength\nT = Instant Bring Part\nY = Instant Repulsion(Opposite of Bring)\nR = Makes Part Stiff (Cannot Rotate/Spin)", "return loadstring(game:HttpGet('https://raw.githubusercontent.com/daximul/who/main/a/test/what/browserplugins/telekinesis.lua'))();")
	BrowserBtn("Freecam", "Freecam", "Control your Camera in a Smooth way", "return loadstring(game:HttpGet('https://raw.githubusercontent.com/daximul/who/main/a/test/what/browserplugins/freecam.lua'))();")
	BrowserBtn("Shader Mod", "Shader Mod", "Toggle Shaders in your Roblox game (best with max graphics)", "return loadstring(game:HttpGet('https://raw.githubusercontent.com/daximul/who/main/a/test/what/browserplugins/shadermod.lua'))();")
	BrowserBtn("Chat Spy", "Chat Spy", "Spy on Messages in Chat", "return loadstring(game:HttpGet('https://raw.githubusercontent.com/daximul/who/main/a/test/what/browserplugins/chatspy.lua'))();")
	BrowserBtn("System Chat", "System Chat", "Fake your Chat as System\n\n{System} Your mom has joined the game", "return loadstring(game:HttpGet('https://raw.githubusercontent.com/daximul/who/main/a/test/what/browserplugins/systemchat.lua'))();")
	BrowserBtn("Lag Server", "Lag Server", "Lag the Server. You will lag for 6 seconds before it works.", "return loadstring(game:HttpGet('https://raw.githubusercontent.com/daximul/who/main/a/test/what/browserplugins/lagserver.lua'))();")
	BrowserBtn("Chat Translator", "Chat Translator", "Translate Chat and Reply\n\nhttps://en.wikipedia.org/wiki/List_of_ISO_639-1_codes\n\nYou have to look the 639-1 column to get a language", "return loadstring(game:HttpGet('https://raw.githubusercontent.com/daximul/who/main/a/test/what/browserplugins/chattranslator.lua'))();")
end)
--// End of Setup




--// Commands

newCmd("commands", {"cmds"}, "commands / cmds", "List of Commands", function(args, speaker)
	CmdListStatus(true)
end)

newCmd("ui", {}, "ui", "Open Dark Admin UI", function(args, speaker)
	DaUiStatus(true)
end)

newCmd("browser", {}, "browser", "Plugin Browser", function(args, speaker)
	PlugBrowseStatus(true)
end)

newCmd("prefix", {}, "prefix [string]", "Change the prefix", function(args, speaker)
	local pref = args[1]
	if typeof(pref) == "string" and #pref <= 2 then
		Settings.Prefix = pref
		updatesaves()
		notify("", "Prefix was succesfully changed to: " .. pref)
    elseif #prefix > 2 then
        notify("", "Prefix cannot be longer than 2 characters.")
    end
end)

newCmd("currentprefix", {}, "currentprefix", "Notify current prefix", function(args, speaker)
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
	Network_Loop:Disconnect()
	wait()
	Network_Loop = nil
	if setsimulation then
		setsimulation(139, 139)
	else
		sethidden(speaker, "MaximumSimulationRadius", 139)
		sethidden(speaker, "SimulationRadius", 139)
	end
	notify("", "Simradius set to 139")
end)

newCmd("synnet", {}, "synnet [Unstable]", "Unstable But Good Net", function(args, speaker)
	notify("", "Simradius set to Syn")
	Import("cl_net.lua")
end)

newCmd("netcheck", {}, "netcheck", "Notify who is using Network Ownership", function(args, speaker)
	local whoisnet = {}
	for i,v in pairs(Players:GetPlayers()) do
		if gethiddenproperty then	
			if gethiddenproperty(v, "SimulationRadius") > 1000 then
				table.insert(whoisnet, v.Name)
			elseif set_hidden_property then
				if get_hidden_property(v, "SimulationRadius") > 1000 then
					table.insert(whoisnet, v.Name)
				end
			end
		end
	end
	notify("Net Check", table.concat(whoisnet, ", "))
end)

newCmd("walkspeed", {"ws"}, "walkspeed / ws [number]", "speed gamer", function(args, speaker)
	local wspeed = args[1]
	if wspeed and isNumber(wspeed) then
		speaker.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = wspeed
	end
end)

newCmd("jumppower", {"jp"}, "jumppower / jp [number]", "jump power gamer", function(args, speaker)
	local jpower = args[1]
	if jpower and isNumber(jpower) then
		speaker.Character:FindFirstChildOfClass("Humanoid").JumpPower = jpower
	end
end)

newCmd("goto", {"to"}, "goto / to [plr]", "tp to player", function(args, speaker)
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

newCmd("clip", {"unnoclip"}, "clip / unnoclip", "Stop noclipping", function(args, speaker)
	if Noclipping then
		Noclipping:Disconnect()
	end
	Clip = true
	if args[1] and args[1] == "nonotify" then return end
	notify("Noclip", "Noclip Disabled")
end)

newCmd("fly", {}, "fly [number]", "bird simulator", function(args, speaker)
	NOFLY()
	wait()
	sFLY()
	if args[1] and isNumber(args[1]) then
		Settings.daflyspeed = args[1]
		updatesaves()
	end
end)

newCmd("vfly", {"vehiclefly"}, "vfly / vehiclefly [number]", "Fly vehicles", function(args, speaker)
	NOFLY()
	wait()
	sFLY(true)
	if args[1] and isNumber(args[1]) then
		Settings.vehicleflyspeed = args[1]
		updatesaves()
	end
end)

newCmd("flyspeed", {"flysp"}, "flyspeed / flysp", "Change your flyspeed", function(args, speaker)
	local speed = args[1] or 1
	if isNumber(speed) then
		Settings.daflyspeed = speed
		updatesaves()
	end
end)

newCmd("vflyspeed", {"vflysp"}, "vflyspeed / vflysp", "Change your vehicle flyspeed", function(args, speaker)
	local speed = args[1] or 1
	if isNumber(speed) then
		Settings.vehicleflyspeed = speed
		updatesaves()
	end
end)

newCmd("unfly", {"unvfly"}, "unfly / unvfly", "Stop flying", function(args, speaker)
	NOFLY()
end)

newCmd("anchor", {}, "anchor", "Makes your player unmovable", function(args, speaker)
	speaker.Character.HumanoidRootPart.Anchored = true
end)

newCmd("unanchor", {}, "unanchor", "Makes your player movable again", function(args, speaker)
	speaker.Character.HumanoidRootPart.Anchored = false
end)

newCmd("reset", {}, "reset", "die ig", function(args, speaker)
	speaker.Character:BreakJoints()
end)

newCmd("notify", {}, "notify [title] [desc] [time]", "notification LOL", function(args, speaker)
	if args[3] ~= nil then
		notify(args[1], args[2], args[3])
	else
		notify(args[1], args[2])
	end
end)

newCmd("checkclaim", {}, "checkclaim [plr]", "Check if a player is claimed", function(args, speaker)
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

newCmd("claimkill", {"ckill"}, "claimkill / ckill [plr]", "Kill a claimed user", function(args, speaker)
	local users = getPlayer(args[1], speaker)
	for i,Target in pairs(users) do
		if Target and Target.Character then
			Target.Character:FindFirstChildOfClass("Humanoid").Health = 0
		end
	end
end)

newCmd("kill", {}, "kill [plr]", "Try to kill a user", function(args, speaker)
	local users = getPlayer(args[1], speaker)
	for i,Target in pairs(users) do
		if Target and Target.Character then
			kill(speaker, Target)
		end
	end
end)

newCmd("fastkill", {}, "fastkill [plr]", "Try to kill a user fast", function(args, speaker)
	local users = getPlayer(args[1], speaker)
	for i,Target in pairs(users) do
		if Target and Target.Character then
			kill(speaker, Target, true)
		end
	end
end)

newCmd("bring", {}, "bring [plr]", "Try to bring a user", function(args, speaker)
	local users = getPlayer(args[1], speaker)
	for i,Target in pairs(users) do
		if Target and Target.Character then
			bring(speaker, Target)
		end
	end
end)

newCmd("fastbring", {}, "fastbring [plr]", "Try to bring a user fast", function(args, speaker)
	local users = getPlayer(args[1], speaker)
	for i,Target in pairs(users) do
		if Target and Target.Character then
			bring(speaker, Target, true)
		end
	end
end)

newCmd("clientbring", {"cbring"}, "clientbring / cbring [plr]", "Bring a user on your client", function(args, speaker)
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

newCmd("respawn", {}, "respawn", "Respawn your character", function(args, speaker)
	respawn(speaker)
end)

newCmd("refresh", {"re"}, "refresh / re", "Respawn in the same spot", function(args, speaker)
	refresh(speaker)
end)

newCmd("split", {}, "split", "Become cut in half", function(args, speaker)
	if r15(speaker) then
		speaker.Character.UpperTorso.Waist:Destroy()
	else
		notify("R15 Required", "Requires R15 Rig Type")
	end
end)

newCmd("float", {}, "float", "Walk on an invisible part", function(args, speaker)
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

newCmd("unfloat", {}, "unfloat", "Stop floating", function(args, speaker)
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

newCmd("sit", {}, "sit", "omega bruh", function(args, speaker)
	if speaker and speaker.Character and speaker.Character:FindFirstChildOfClass("Humanoid") then
		speaker.Character:FindFirstChildOfClass("Humanoid").Sit = true
	end
end)

newCmd("stun", {}, "stun", "Enable Platform Stand", function(args, speaker)
	speaker.Character:FindFirstChildOfClass('Humanoid').PlatformStand = true
end)

newCmd("unstun", {}, "unstun", "Disable Platform Stand", function(args, speaker)
	speaker.Character:FindFirstChildOfClass('Humanoid').PlatformStand = false
end)

newCmd("jump", {}, "jump", "r u serious", function(args, speaker)
	if speaker and speaker.Character and speaker.Character:FindFirstChildOfClass("Humanoid") then
		speaker.Character:FindFirstChildOfClass("Humanoid").Jump = true
	end
end)

newCmd("screenshot", {}, "screenshot", "Take picture ez", function(args, speaker)
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

newCmd("grabknife", {"knife"}, "grabknife / knife", "Use on claimed users", function(args, speaker)
	notify("", "Loaded Grab Knife", 2)
	Import("knif.lua")
end)

newCmd("control", {"control"}, "control [plr]", "Control someone lol", function(args, speaker)
    local users = getPlayer(args[1], speaker)
    for i,Target in pairs(users) do
        if Target and Target.Character and Target.Character:FindFirstChild("-Claimed") then
            Target.Character.HumanoidRootPart.Parent = game.Players.LocalPlayer.Character
            game.Players.LocalPlayer.Character.HumanoidRootPart.Anchored = true
		else
			notify("", "Couldn't Control Player")
        end
    end
end)

newCmd("antiafk", {"antiidle"}, "antiafk / antiidle", "Don't get kicked for being AFK", function(args, speaker)
	local GC = getconnections or get_signal_cons
	if GC then
		for i,v in pairs(GC(Players.LocalPlayer.Idled)) do
			if v["Disable"] then
				v["Disable"](v)
			elseif v["Disconnect"] then
				v["Disconnect"](v)
			end
		end
		notify("Anti Idle"," Anti idle is enabled")
	else
		notify("Incompatible Exploit", "Missing getconnections")
	end
end)

newCmd("btools", {}, "btools", "cringe command", function(args, speaker)
	Instance.new("HopperBin", speaker:FindFirstChildOfClass("Backpack")).BinType = 1
	Instance.new("HopperBin", speaker:FindFirstChildOfClass("Backpack")).BinType = 2
	Instance.new("HopperBin", speaker:FindFirstChildOfClass("Backpack")).BinType = 3
	Instance.new("HopperBin", speaker:FindFirstChildOfClass("Backpack")).BinType = 4
end)

newCmd("f3x", {"fex"}, "f3x / fex", "Building Tools", function(args, speaker)
	loadstring(game:GetObjects("rbxassetid://4698064966")[1].Source)()
end)

newCmd("explorer", {"dex"}, "explorer / dex", "Game Explorer", function(args, speaker)
	notify("Loading", "Hold on a sec")
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
end)

newCmd("remotespy", {"rspy"}, "remotespy / rspy", "Remote Spy", function(args, speaker)
	notify("Loading", "Hold on a sec", 2)
	loadstring(game:HttpGet("https://github.com/exxtremestuffs/SimpleSpySource/raw/master/SimpleSpy.lua"))()
end)

newCmd("audiologger", {}, "audiologger", "Audio Logger by Edge", function(args, speaker)
	notify("Loading", "Hold on a sec", 2)
	loadstring(game:HttpGet(('https://pastebin.com/raw/GmbrsEjM'),true))()
end)

newCmd("vr", {}, "vr", "CLOVR by Abacaxl", function(args, speaker)
	notify("", "Loading CLOVR . . .", 2)
	loadstring(game:HttpGet('https://ghostbin.co/paste/yb288/raw'))()
end)

newCmd("jobid", {}, "jobid", "Copy server's jobid", function(args, speaker)
	local jobId = ('Roblox.GameLauncher.joinGameInstance(' .. game.PlaceId .. ', "' .. game.JobId ..'")')
	toClipboard(jobId)
end)

newCmd("safechat", {}, "safechat", "Become under 13", function(args, speaker)
	speaker.SetSuperSafeChat(true)
end)

newCmd("nosafechat", {}, "nosafechat", "Welcome to the 13 gang", function(args, speaker)
	speaker.SetSuperSafeChat(false)
end)

newCmd("creeper", {}, "creeper", "Aw man", function(args, speaker)
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

newCmd("reach", {}, "reach [number]", "Give tool reach", function(args, speaker)
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
				v.Handle.Size = Vector3.new(0.5,0.5,args[1])
				v.GripPos = Vector3.new(0,0,0)
				speaker.Character:FindFirstChildOfClass("Humanoid"):UnequipTools()
			else
				currentToolSize = v.Handle.Size
				currentGripPos = v.GripPos
				local a = Instance.new("SelectionBox")
				a.Name = "SelectionBoxCreated"
				a.Parent = v.Handle
				a.Adornee = v.Handle
				v.Handle.Massless = true
				v.Handle.Size = Vector3.new(0.5,0.5,60)
				v.GripPos = Vector3.new(0,0,0)
				speaker.Character:FindFirstChildOfClass("Humanoid"):UnequipTools()
			end
		end
	end
end)

newCmd("unreach", {"noreach"}, "unreach / noreach", "Disable reach", function(args, speaker)
	for i,v in pairs(speaker.Character:GetDescendants()) do
		if v:IsA("Tool") then
			v.Handle.Size = currentToolSize
			v.GripPos = currentGripPos
			v.Handle.SelectionBoxCreated:Destroy()
		end
	end
end)

newCmd("fov", {}, "fov", "Change your Field of View", function(args, speaker)
	local fov = args[1] or 70
	if isNumber(fov) then
		workspace.CurrentCamera.FieldOfView = fov
	end
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

newCmd("tinvisible", {"tinvis"}, "tinvisible / tinvis", "Invisibility but no godmode but tools work", function(args, speaker)
	Import("tinv.lua")
	notify("T Invis", "You are now invisible")
end)

newCmd("visible", {"vis"}, "visible / vis", "Become visible once again", function(args, speaker)
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
		notify('Spectate','Turned off')
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
	wait(.1)
	repeat wait() until speaker.Character ~= nil
	workspace.CurrentCamera.CameraSubject = speaker.Character:FindFirstChildWhichIsA("Humanoid")
	workspace.CurrentCamera.CameraType = "Custom"
	speaker.CameraMinZoomDistance = 0.5
	speaker.CameraMaxZoomDistance = 400
	speaker.CameraMode = "Classic"
	speaker.Character.Head.Anchored = false
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
		if string.sub(c.Name, -4) == '_ESP' then
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

newCmd("unlocate", {}, "unlocate [plr]", "Removes locate", function(args, speaker)
	local players = getPlayer(args[1], speaker)
	if args[1] then
		for i,v in pairs(players) do
			for i,c in pairs(CoreGui:GetChildren()) do
				if c.Name == Players[v].Name..'_LC' then
					c:Destroy()
				end
			end
		end
	else
		for i,c in pairs(CoreGui:GetChildren()) do
			if string.sub(c.Name, -3) == '_LC' then
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
	notify("Shiftlock", "Shift lock is now available")
end)

newCmd("firstp", {}, "firstp", "First Person", function(args, speaker)
	speaker.CameraMode = "LockFirstPerson"
end)

newCmd("thirdp", {}, "thirdp", "Third Person", function(args, speaker)
	speaker.CameraMode = "Classic"
end)

newCmd("noprompts", {}, "noprompts", "Stop receiving purchase prompts", function(args, speaker)
	CoreGui.PurchasePromptApp.PurchasePromptUI.Visible = false
	CoreGui.PurchasePromptApp.PremiumPromptUI.Visible = false
end)

newCmd("showprompts", {}, "showpromots", "Receive purchase prompts again", function(args, speaker)
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
	if speaker and speaker.Character then
		for _,obj in pairs(speaker.Character:GetChildren()) do
			if obj:IsA("Tool") then
				obj.Parent = workspace
			end
		end
	end
	if speaker and speaker:FindFirstChildOfClass("Backpack") then
		for _,obj in pairs(speaker:FindFirstChildOfClass("Backpack"):GetChildren()) do
			if obj:IsA("Tool") then
				obj.Parent = workspace
			end
		end
	end
end)

newCmd("droppabletools", {}, "droppabletools", "Make undroppable tools droppable", function(args, speaker)
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
		local OwnerID = game:GetService('GroupService'):GetGroupInfoAsync(game.CreatorId).Owner.Id
		speaker.UserId = OwnerID
		notify("Set ID", "Set UserId to " .. OwnerID)
	end
end)

newCmd("resetuserid", {}, "resetuserid", "Set your User ID back to normal", function(args, speaker)
	speaker.UserId = Original_User_Id
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

newCmd("scriptusers", {}, "scriptusers", "See who else is using DA", function(args, speaker)
	for i,v in pairs(Players:GetPlayers()) do
		local su_che1 = v.Character:FindFirstChild("Head")
		if su_che1 then
			local su_che2 = su_che1:FindFirstChild(SU_SomeCheckPlace.Attachment)
			if not su_che2 then
				local FoundUsersList = {}
				table.insert(FoundUsersList, v.Name)
				local CommasList = table.concat(FoundUsersList, ", ")
				notify("Users Using DA", CommasList)
			end
		end
	end
end)

newCmd("flashback", {}, "flashback", "Go back to where you last died", function(args, speaker)
	spawn(function()
		if LastDeathPos ~= nil then
			speaker.Character:FindFirstChildOfClass("Humanoid").Sit = false
			wait(0.01)
			getRoot(speaker.Character).CFrame = LastDeathPos
		end
	end)
end)

newCmd("dupetools", {}, "dupetools [number]", "Duplicate tools in your inventory", function(args, speaker)
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

newCmd("numofcmds", {}, "numofcmds", "Notify the number of commands", function(args, speaker)
	notify("", #cmds)
end)

local CmdNoclipping = nil
newCmd("noclip", {}, "noclip", "Go through objects", function(args, speaker)
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

newCmd("clip", {}, "clip", "Disables noclip", function(args, speaker)
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

newCmd("unspin", {}, "unspin", "Disables spin", function(args, speaker)
	for i,v in pairs(getRoot(speaker.Character):GetChildren()) do
		if v.Name == "Spinning" then
			v:Destroy()
		end
	end
end)

cmdflinging = false
newCmd("fling", {}, "fling", "Flings anyone you touch", function(args, speaker)
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

newCmd("unfling", {}, "unfling", "Disables the fling command", function(args, speaker)
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

newCmd("invisfling", {}, "invisfling", "Enables invisible fling", function(args, speaker)
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
		game.Players.LocalPlayer.Character = char

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
	cmdautorj = true
	notify("Auto Rejoin", "Enabled")
end)

newCmd("unautorejoin", {"unautorj"}, "unautorejoin / unautorj", "Disable Auto Rejoin", function(args, speaker)
	cmdautorj = false
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

newCmd("fullbright", {"fb"}, "fullbright / fb", "Makes the map brighter / more visible", function(args, speaker)
	game:GetService("Lighting").Brightness = 2
	game:GetService("Lighting").ClockTime = 14
	game:GetService("Lighting").FogEnd = 100000
	game:GetService("Lighting").GlobalShadows = false
	game:GetService("Lighting").OutdoorAmbient = Color3.fromRGB(128, 128, 128)
end)

newCmd("restorelighting", {"rlighting"}, "restorelighting / rlighting", "Restores Lighting properties", function(args, speaker)
	game:GetService("Lighting").Ambient = origsettings.abt
	game:GetService("Lighting").OutdoorAmbient = origsettings.oabt
	game:GetService("Lighting").Brightness = origsettings.brt
	game:GetService("Lighting").ClockTime = origsettings.time
	game:GetService("Lighting").FogEnd = origsettings.fe
	game:GetService("Lighting").FogStart = origsettings.fs
	game:GetService("Lighting").GlobalShadows = origsettings.gs
end)

newCmd("hitbox", {}, "hitbox [plr] [size]", "Expands the hitbox for players heads (default is 1)", function(args, speaker)
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






if Settings.PluginsTable ~= nil or Settings.PluginsTable ~= {} then
	FindPlugins(Settings.PluginsTable)
end
wait()
SetSimulationRadius()
notify("Dark Admin", "Prefix is " .. Settings.Prefix)
--// Dark Admin;
