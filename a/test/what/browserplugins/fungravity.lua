local Players = game:GetService("Players")
local sethidden = sethiddenproperty or set_hidden_property or set_hidden_prop

local function SetSimulationRadius()
	settings().Physics.AllowSleep = false
	if sethidden then
		settings().Physics.AllowSleep = false
		sethidden(Players.LocalPlayer, "SimulationRadius", math.huge)
		sethidden(Players.LocalPlayer, "MaxSimulationRadius", math.huge)
		Players.LocalPlayer.MaximumSimulationRadius = math.huge
		Players.LocalPlayer.ReplicationFocus = workspace
	end
end

local CollideOn = true
local SelectedParts = {}
local OnlySelectedParts = false
local BlackHoleDestroyParts = true

local function SelectedPartsCheck()
	if OnlySelectedParts == false then
		return false
	else
		return true
	end
end

local Plugin = {
	["PluginName"] = "Fun with Gravity",
	["PluginDescription"] = "",
	["Commands"] = {
		["nogravparts"] = {
			["ListName"] = "nogravparts" ,
			["Description"] = "FE No gravity",
			["Aliases"] = {},
			["Function"] = function(args,speaker)

				SetSimulationRadius()
			   
				if SelectedPartsCheck() == false then

					local function zeroGrav(part)
						if part:FindFirstChild("BodyForce") then return end
						local temp = Instance.new("BodyForce")
						temp.Force = part:GetMass() * Vector3.new(0,workspace.Gravity,0)
						temp.Parent = part
					end

				for i,v in ipairs(workspace:GetDescendants()) do
					if v:IsA("BasePart") and v.Anchored == false then
						if not (v:IsDescendantOf(game.Players.LocalPlayer.Character)) then
							zeroGrav(v)
						end
					end
				end
			else

				local function zeroGrav(part)
					if part:FindFirstChild("BodyForce") then return end
					local temp = Instance.new("BodyForce")
					temp.Force = part:GetMass() * Vector3.new(0,workspace.Gravity,0)
					temp.Parent = part
				end

				for i,v in ipairs(SelectedParts) do
					if v:IsA("BasePart") and v.Anchored == false then
						if not (v:IsDescendantOf(game.Players.LocalPlayer.Character)) then
							zeroGrav(v)
						end
					end
				end
			end
			end,
		},
		["gravparts"] = {
			["ListName"] = "gravparts" ,
			["Description"] = "Will put back the gravs",
			["Aliases"] = {},
			["Function"] = function(args,speaker)

				for i,v in ipairs(workspace:GetDescendants()) do
					if v:IsA("Part") and v.Anchored == false then
						v.CanCollide = true
						if not (v:IsDescendantOf(game.Players.LocalPlayer.Character)) then
						v:FindFirstChild("BodyForce"):Destroy()
				end
			end
		end
	end
	},
	["supergravparts"] = {
		["ListName"] = "supergravparts" ,
		["Description"] = "More Gravity on the parts",
		["Aliases"] = {},
		["Function"] = function(args,speaker)
			execCmd("gravparts")
			wait(0.3)
			
			SetSimulationRadius()
			
			if SelectedPartsCheck() == false then

			local function SuperGrav(part)
				if part:FindFirstChild("BodyForce") then return end
				local temp2 = Instance.new("BodyForce")
				temp2.Force = part:GetMass() * Vector3.new(0,-5500,0)
				temp2.Parent = part
			end	

			for i,v in ipairs(workspace:GetDescendants()) do
				if v:IsA("BasePart") and v.Anchored == false then
					if not (v:IsDescendantOf(game.Players.LocalPlayer.Character)) then
						SuperGrav(v)
					end
				end
			end
		else

			local function SuperGrav(part)
				if part:FindFirstChild("BodyForce") then return end
				local temp2 = Instance.new("BodyForce")
				temp2.Force = part:GetMass() * Vector3.new(0,-5500,0)
				temp2.Parent = part
			end	

			for i,v in ipairs(SelectedParts) do
				if v:IsA("BasePart") and v.Anchored == false then
					if not (v:IsDescendantOf(game.Players.LocalPlayer.Character)) then
						SuperGrav(v)
					end
				end
			end
		end
		end,
	},
	["invertgravparts"] = {
		["ListName"] = "invertgravparts" ,
		["Description"] = "Now the parts will fall in the sky ?",
		["Aliases"] = {},
		["Function"] = function(args,speaker)
			execCmd("gravparts")

			SetSimulationRadius()

			if SelectedPartsCheck() == false then

				local function InvertGrav(part)
					if part:FindFirstChild("BodyForce") then return end
					local temp2 = Instance.new("BodyForce")
					temp2.Force = part:GetMass() * Vector3.new(0,5500,0)
					temp2.Parent = part
				end	

			for i,v in ipairs(workspace:GetDescendants()) do
				if v:IsA("BasePart") and v.Anchored == false then
					if not (v:IsDescendantOf(game.Players.LocalPlayer.Character)) then
						InvertGrav(v)
					end
				end
			end
		else

			local function InvertGrav(part)
				if part:FindFirstChild("BodyForce") then return end
				local temp2 = Instance.new("BodyForce")
				temp2.Force = part:GetMass() * Vector3.new(0,5500,0)
				temp2.Parent = part
			end	

			for i,v in ipairs(SelectedParts) do
				if v:IsA("BasePart") and v.Anchored == false then
					if not (v:IsDescendantOf(game.Players.LocalPlayer.Character)) then
						InvertGrav(v)
					end
				end
			end
		end
		end,
	},
	["pushparts"] = {
		["ListName"] = "pushparts" ,
		["Description"] = "Push unanchored parts in the sky",
		["Aliases"] = {},
		["Function"] = function(args,speaker)
			
			SetSimulationRadius()

			if SelectedPartsCheck() == false then

				local function InvertGrav2(part)
					if part:FindFirstChild("BodyForce") then return end
					local temp2 = Instance.new("BodyForce")
					temp2.Force = part:GetMass() * Vector3.new(0,1000,0)
					temp2.Parent = part
				end
			
			for i,v in ipairs(workspace:GetDescendants()) do
				if v:IsA("BasePart") and v.Anchored == false then
					if not (v:IsDescendantOf(game.Players.LocalPlayer.Character)) then
						InvertGrav2(v)
					end
				end
			end
			wait(0.45)
			execCmd("gravparts")
		else

			local function InvertGrav2(part)
				if part:FindFirstChild("BodyForce") then return end
				local temp2 = Instance.new("BodyForce")
				temp2.Force = part:GetMass() * Vector3.new(0,1000,0)
				temp2.Parent = part
			end

			for i,v in ipairs(SelectedParts) do
				if v:IsA("BasePart") and v.Anchored == false then
					if not (v:IsDescendantOf(game.Players.LocalPlayer.Character)) then
						InvertGrav2(v)
					end
				end
			end
			wait(0.45)
			execCmd("gravparts")
		end
		end
	},
	["bombparts"] = {
		["ListName"] = "bombparts" ,
		["Description"] = "Push unanchored parts in the sky and fall very fast so create a kind of explosion",
		["Aliases"] = {},
		["Function"] = function(args,speaker)
			
			SetSimulationRadius()

			local function InvertGrav3(part)
				if part:FindFirstChild("BodyForce") then return end
				local temp2 = Instance.new("BodyForce")
				temp2.Force = part:GetMass() * Vector3.new(0,1250,0)
				temp2.Parent = part
			end	
			for i,v in ipairs(workspace:GetDescendants()) do
				if v:IsA("Part") and v.Anchored == false then
					if not (v:IsDescendantOf(game.Players.LocalPlayer.Character)) then
						InvertGrav3(v)
					end
				end
			end
			wait(0.7)
			execCmd("gravparts")
			wait(0.3)
			
			SetSimulationRadius()

			local function SuperGrav22(part)
				if part:FindFirstChild("BodyForce") then return end
				local temp2 = Instance.new("BodyForce")
				temp2.Force = part:GetMass() * Vector3.new(0,-3500,0)
				temp2.Parent = part
			end	
			for i,v in ipairs(workspace:GetDescendants()) do
				if v:IsA("Part") and v.Anchored == false then
					if not (v:IsDescendantOf(game.Players.LocalPlayer.Character)) then
						SuperGrav22(v)
					end
				end
			end
			wait(0.7)
			execCmd("gravparts")
			wait(0.1)
			
			SetSimulationRadius()

			local function zeroGrav2(part)
				if part:FindFirstChild("BodyForce") then return end
				local temp = Instance.new("BodyForce")
				temp.Force = part:GetMass() * Vector3.new(0,workspace.Gravity,0)
				temp.Parent = part
			end
			
			for i,v in ipairs(workspace:GetDescendants()) do
				if v:IsA("Part") and v.Anchored == false then
					if not (v:IsDescendantOf(game.Players.LocalPlayer.Character)) then
						zeroGrav2(v)
					end
				end
			end
			wait(3)
			execCmd("gravparts")
		end
	},
	["deleteunanchored"] = {
		["ListName"] = "deleteunanchored / deleteua / cleanua",
		["Description"] = "Move all unanchoredparts to the void position ( so it destroy it )",
		["Aliases"] = {"deleteua", "cleanua"},
		["Function"] = function(args,speaker)

			SetSimulationRadius()

	local LocalPlayer = game:GetService("Players").LocalPlayer

	local unanchoredparts7 = {}

	local movers = {}

	if SelectedPartsCheck() == false then
			
			for index, part in pairs(workspace:GetDescendants()) do
				if part:IsA("BasePart") and part.Anchored == false and part:IsDescendantOf(LocalPlayer.Character) == false then
					part.CanCollide = false
			table.insert(unanchoredparts7, part)
			if part:FindFirstChildOfClass("BodyPosition") ~= nil then
				part:FindFirstChildOfClass("BodyPosition"):Destroy()
			end
		end
	end
	 wait(0.2)
	
	for index, part in pairs(unanchoredparts7) do
		local mover = Instance.new("BodyPosition", part)
		table.insert(movers, mover)
		mover.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
			end
		
		for index, mover in pairs(movers) do
			mover.Position = Vector3.new(0,workspace.FallenPartsDestroyHeight + 1,0)
		end
		wait(2)
		for index, mover in pairs(movers) do
			mover:Destroy()
	end
else
	for index, part in pairs(SelectedParts) do
		if part:IsA("BasePart") and part.Anchored == false and part:IsDescendantOf(LocalPlayer.Character) == false then
			part.CanCollide = false
	if part:FindFirstChildOfClass("BodyPosition") ~= nil then
		part:FindFirstChildOfClass("BodyPosition"):Destroy()
	end
end
end
wait(0.2)

for index, part in pairs(SelectedParts) do
local mover = Instance.new("BodyPosition", part)
table.insert(movers, mover)
mover.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
	end

for index, mover in pairs(movers) do
	mover.Position = Vector3.new(0,workspace.FallenPartsDestroyHeight + 1,0)
end
wait(2)
for index, mover in pairs(movers) do
	mover:Destroy()
end
end
end
},
	  ["moveparts"] = {
	  ["ListName"] = "moveparts [plr]",
	  ["Description"] = "Move the unanchored parts to the target",
	  ["Aliases"] = {},
	  ["Function"] = function(args,speaker)
		
		SetSimulationRadius()

		local players = getPlayer(args[1], speaker) 
		local LocalPlayer = game:GetService("Players").LocalPlayer
		local unanchoredparts = {}
		local movers = {}
 

		if SelectedPartsCheck() == false then

				for index, part in pairs(workspace:GetDescendants()) do
					if part:IsA("Part" or "MeshPart" or "Model") and part.Anchored == false and part:IsDescendantOf(LocalPlayer.Character) == false then
				table.insert(unanchoredparts, part)
				if part:FindFirstChildOfClass("BodyPosition") ~= nil then
					part:FindFirstChildOfClass("BodyPosition"):Destroy()
				end
			end
		end

		for index, part in pairs(unanchoredparts) do
			local mover = Instance.new("BodyPosition", part)
			table.insert(movers, mover)
			mover.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
				end
				moving = true
		repeat
			for i,plr in pairs(players)do
			for index, mover in pairs(movers) do
				mover.Position = game:GetService("Players")[plr].Character.HumanoidRootPart.CFrame:PointToWorldSpace()
			end
			end
			wait()
		until moving == false
	else
		for index, part in pairs(SelectedParts) do
			if part:IsA("BasePart") and part.Anchored == false and part:IsDescendantOf(LocalPlayer.Character) == false then
		if part:FindFirstChildOfClass("BodyPosition") ~= nil then
			part:FindFirstChildOfClass("BodyPosition"):Destroy()
		end
	end
end

for index, part in pairs(SelectedParts) do
	local mover = Instance.new("BodyPosition", part)
	table.insert(movers, mover)
	mover.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
		end
		moving = true
repeat
	for i,plr in pairs(players)do
	for index, mover in pairs(movers) do
		mover.Position = game:GetService("Players")[plr].Character.HumanoidRootPart.CFrame:PointToWorldSpace()
	end
	end
	wait()
until moving == false
	end
end
	},
		["movepartsmouse"] = {
		["ListName"] = "movepartsmouse",
		["Description"] = "Move the unanchored parts to the mouse",
		["Aliases"] = {},
		["Function"] = function(args,speaker)
		
			SetSimulationRadius()

		  local LocalPlayer = game:GetService("Players").LocalPlayer
          local mouse = LocalPlayer:GetMouse()
		  local unanchoredparts2 = {}
		  local movers2 = {}
   

		  if SelectedPartsCheck() == false then

				  for index, part in pairs(workspace:GetDescendants())  do
					  if part:IsA("BasePart") and part.Anchored == false and part:IsDescendantOf(LocalPlayer.Character) == false then
				  table.insert(unanchoredparts2, part)
				  if part:FindFirstChildOfClass("BodyPosition") ~= nil then
					  part:FindFirstChildOfClass("BodyPosition"):Destroy()
				  end
			  end
		  end
  
		  for index, part in pairs(unanchoredparts2) do
			  local mover2 = Instance.new("BodyPosition", part)
			  table.insert(movers2, mover2)
			  mover2.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
				  end
				  moving2 = true
		  repeat
			  for index, mover3 in pairs(movers2) do
				  mover3.Position = mouse.Hit:PointToWorldSpace()
			  end
			  game:GetService("RunService").Stepped:wait()
		  until moving2 == false
		else
			for index, part in pairs(SelectedParts)  do
				if part:IsA("BasePart") and part.Anchored == false and part:IsDescendantOf(LocalPlayer.Character) == false then
			if part:FindFirstChildOfClass("BodyPosition") ~= nil then
				part:FindFirstChildOfClass("BodyPosition"):Destroy()
			end
		end
	end

	for index, part in pairs(SelectedParts) do
		local mover2 = Instance.new("BodyPosition", part)
		table.insert(movers2, mover2)
		mover2.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
			end
			moving2 = true
	repeat
		for index, mover3 in pairs(movers2) do
			mover3.Position = mouse.Hit:PointToWorldSpace()
		end
		game:GetService("RunService").Stepped:wait()
	until moving2 == false
	  end
	end
	},
["unmoveparts"] = {
	["ListName"] = "unmoveparts",
	["Description"] = "Stop moving the parts to the target",
	["Aliases"] = {},
	["Function"] = function(args,speaker)
		moving = false
		moving2 = false
		for i,mov in pairs(workspace:GetDescendants())do
		if mov:IsA("BodyPosition") then
			mov:Destroy()
			end
		end
		end
	},
	["setblackhole"] = {
		["ListName"] = "setblackhole",
		["Description"] = "Set the blackhole position",
		["Aliases"] = {},
		["Function"] = function(args,speaker)
			local ball = Instance.new("Part", workspace)
			ball.Anchored = true
			ball.CanCollide = false
			ball.Material = "Glass"
			ball.Shape = "Ball"
			ball.Color = Color3.fromRGB(56, 0, 85)
			ball.Size = Vector3.new(4,4,4)
			ball.Name = "BlackHoleCenter"
			ball.Position = game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.Position
			end
		},
["blackhole"] = {
["ListName"] = "blackhole",
["Description"] = "Move unanchoredparts to your character once, so its look like a black hole",
["Aliases"] = {},
["Function"] = function(args,speaker)
  
	SetSimulationRadius()

  local players = getPlayer(args[1], speaker) 
  local LocalPlayer = game:GetService("Players").LocalPlayer
  local unanchoredparts = {}
  local movers = {}


  if SelectedPartsCheck() == false then

		  for index, part in pairs(workspace:GetDescendants()) do
			  if part:IsA("BasePart") and part.Anchored == false and part:IsDescendantOf(LocalPlayer.Character) == false and part.Name == "BlackHoleCenter" == false then
		  table.insert(unanchoredparts, part)
		  if part:FindFirstChildOfClass("BodyPosition") ~= nil then
			  part:FindFirstChildOfClass("BodyPosition"):Destroy()
		  end
	  end
  end

  for index, part in pairs(unanchoredparts) do
	  local mover = Instance.new("BodyPosition", part)
	  table.insert(movers, mover)
	  mover.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
		  end

		  cowboy = true

	if BlackHoleDestroyParts == true then


		bhe = workspace:FindFirstChild("BlackHoleCenter").Touched:Connect(function(part)
			if part.Anchored == true and part.BodyPosition == nil then
                return
			elseif part.Anchored == false and part.BodyPosition ~= nil then
		  part.CanCollide = false
		  part.BodyPosition.Position = Vector3.new(0,workspace.FallenPartsDestroyHeight + 1,0)
		  wait(0.05)
		  part.BodyPosition:Destroy()
	  end
	  end)

		  repeat
	  for index, mover in pairs(movers) do
		  mover.Position = workspace:FindFirstChild("BlackHoleCenter").CFrame:PointToWorldSpace()	  
		end
		wait(0.8)
	  game:GetService("RunService").Stepped:wait()
	until cowboy == false
else
	repeat
		for index, mover in pairs(movers) do
			mover.Position = workspace:FindFirstChild("BlackHoleCenter").CFrame:PointToWorldSpace()
			game:GetService("RunService").Stepped:wait()
		end
	until cowboy == false
end
else
	for index, part in pairs(SelectedParts) do
		if part:IsA("BasePart") and part.Anchored == false and part:IsDescendantOf(LocalPlayer.Character) == false and part.Name == "BlackHoleCenter" == false then
	if part:FindFirstChildOfClass("BodyPosition") ~= nil then
		part:FindFirstChildOfClass("BodyPosition"):Destroy()
	end
end
end

for index, part in pairs(SelectedParts) do
local mover = Instance.new("BodyPosition", part)
table.insert(movers, mover)
mover.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
	end

	cowboy = true

	if BlackHoleDestroyParts == true then

		bhe = workspace:FindFirstChild("BlackHoleCenter").Touched:Connect(function(part)
			if part.Anchored == true and part.BodyPosition == nil then
                return
			elseif part.Anchored == false and part.BodyPosition ~= nil then
		  part.CanCollide = false
		  part.BodyPosition.Position = Vector3.new(0,workspace.FallenPartsDestroyHeight + 1,0)
		  wait(0.05)
		  part.BodyPosition:Destroy()
	  end
	  end)

		repeat
	for index, mover in pairs(movers) do
		mover.Position = workspace:FindFirstChild("BlackHoleCenter").CFrame:PointToWorldSpace()
  end
	  wait(1)
	game:GetService("RunService").Stepped:wait()
  until cowboy == false
else
  repeat
	  for index, mover in pairs(movers) do
		  mover.Position = workspace:FindFirstChild("BlackHoleCenter").CFrame:PointToWorldSpace()
		  game:GetService("RunService").Stepped:wait()
	  end
  until cowboy == false
end

	repeat
for index, mover in pairs(movers) do
	mover.Position = workspace:FindFirstChild("BlackHoleCenter").CFrame:PointToWorldSpace()
end
game:GetService("RunService").Stepped:wait()
until cowboy == false
end
end
},
["removeblackhole"] = {
	["ListName"] = "removeblackhole",
	["Description"] = "Remove the blackhole",
	["Aliases"] = {},
	["Function"] = function(args,speaker)
		for i,blackhole in pairs(workspace:GetChildren())do
			if blackhole:IsA("Part") and blackhole.Name == "BlackHoleCenter" then
				blackhole:Destroy()
				execCmd("stopblackhole")
			end
		end
		end
	},
	["stopblackhole"] = {
		["ListName"] = "stopblackhole",
		["Description"] = "Stop the blackhole",
		["Aliases"] = {},
		["Function"] = function(args,speaker)
			for i,mov in pairs(workspace:GetDescendants())do
				if mov:IsA("BodyPosition") then
					mov:Destroy()
					end
				end
			cowbow = false
			bhe:Disconnect()
			end
		},
		["controlblackhole"] = {
			["ListName"] = "controlblackhole",
			["Description"] = "Control the black hole",
			["Aliases"] = {},
			["Function"] = function(args,speaker)

				local LocalPlayer = game:GetService("Players").LocalPlayer
				FLYING = false
workspace.Camera.CameraSubject = workspace:FindFirstChild("BlackHoleCenter")
workspace:FindFirstChild("BlackHoleCenter").Anchored = false

local iyflyspeed = 3
local mouse = LocalPlayer:GetMouse()
local LP = LocalPlayer
local function goup()
	repeat wait() until LP and LP.Character and LP.Character:FindFirstChild('HumanoidRootPart') and LP.Character:FindFirstChild('Humanoid')
	repeat wait() until mouse
	
	local T = workspace:FindFirstChild("BlackHoleCenter")
	local CONTROL = {F = 0, B = 0, L = 0, R = 0}
	local lCONTROL = {F = 0, B = 0, L = 0, R = 0}
	local SPEED = 0
	
	local function FLY()
		FLYING = true
		local BG = Instance.new('BodyGyro', T)
		local BV = Instance.new('BodyVelocity', T)
		BG.P = 9e4
		BG.maxTorque = Vector3.new(9e9, 9e9, 9e9)
		BG.cframe = T.CFrame
		BV.velocity = Vector3.new(0, 0.1, 0)
		BV.maxForce = Vector3.new(9e9, 9e9, 9e9)
		spawn(function()
		repeat wait()
		if CONTROL.L + CONTROL.R ~= 0 or CONTROL.F + CONTROL.B ~= 0 then
		SPEED = 50
		elseif not (CONTROL.L + CONTROL.R ~= 0 or CONTROL.F + CONTROL.B ~= 0) and SPEED ~= 0 then
		SPEED = 0
		end
if (CONTROL.L + CONTROL.R) ~= 0 or (CONTROL.F + CONTROL.B) ~= 0 then
BV.velocity = ((workspace.CurrentCamera.CoordinateFrame.lookVector * (CONTROL.F + CONTROL.B)) + ((workspace.CurrentCamera.CoordinateFrame * CFrame.new(CONTROL.L + CONTROL.R, (CONTROL.F + CONTROL.B) * 0.2, 0).p) - workspace.CurrentCamera.CoordinateFrame.p)) * SPEED
lCONTROL = {F = CONTROL.F, B = CONTROL.B, L = CONTROL.L, R = CONTROL.R}
elseif (CONTROL.L + CONTROL.R) == 0 and (CONTROL.F + CONTROL.B) == 0 and SPEED ~= 0 then
BV.velocity = ((workspace.CurrentCamera.CoordinateFrame.lookVector * (lCONTROL.F + lCONTROL.B)) + ((workspace.CurrentCamera.CoordinateFrame * CFrame.new(lCONTROL.L + lCONTROL.R, (lCONTROL.F + lCONTROL.B) * 0.2, 0).p) - workspace.CurrentCamera.CoordinateFrame.p)) * SPEED
else
BV.velocity = Vector3.new(0, 0.1, 0)
end
	BG.cframe = workspace.CurrentCamera.CoordinateFrame * CFrame.Angles(math.rad(-90), 0, 0)
			until not FLYING
			CONTROL = {F = 0, B = 0, L = 0, R = 0}
			lCONTROL = {F = 0, B = 0, L = 0, R = 0}
			SPEED = 0
			BG:destroy()
			BV:destroy()
		end)
	end
	mouse.KeyDown:connect(function(KEY)
		if KEY:lower() == 'w' then
			CONTROL.F = iyflyspeed
		elseif KEY:lower() == 's' then
			CONTROL.B = -iyflyspeed
		elseif KEY:lower() == 'a' then
			CONTROL.L = -iyflyspeed 
		elseif KEY:lower() == 'd' then 
			CONTROL.R = iyflyspeed
		end
	end)
	mouse.KeyUp:connect(function(KEY)
		if KEY:lower() == 'w' then
			CONTROL.F = 0
		elseif KEY:lower() == 's' then
			CONTROL.B = 0
		elseif KEY:lower() == 'a' then
			CONTROL.L = 0
		elseif KEY:lower() == 'd' then
			CONTROL.R = 0
		end
	end)
	FLY()
end
goup()

for i,v in pairs(LocalPlayer.Character:GetChildren()) do
	if v:IsA("BasePart" or "MeshPart") then
		v.Anchored = true
	end
end

			end
			},
			["uncontrolblackhole"] = {
				["ListName"] = "uncontrolblackhole",
				["Description"] = "UnControl the black hole",
				["Aliases"] = {},
			    ["Function"] = function(args,speaker)
				local LocalPlayer = game:GetService("Players").LocalPlayer
					 FLYING = false
					 workspace.Camera.CameraSubject = LocalPlayer.Character.Humanoid
					 workspace:FindFirstChild("BlackHoleCenter").Anchored = true

					 for i,v in pairs(LocalPlayer.Character:GetDescendants()) do
						if v:IsA("BasePart" or "MeshPart") then
							v.Anchored = false
						end
					end
				end
			},
			["bringblackhole"] = {
				["ListName"] = "BringBlackHole",
				["Description"] = "UnControl the black hole",
				["Aliases"] = {},
				["Function"] = function(args,speaker)
					workspace:FindFirstChild("BlackHoleCenter").Anchored = true
					workspace:FindFirstChild("BlackHoleCenter").CFrame = game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.CFrame
				end
				},
				["blackholeplayer"] = {
					["ListName"] = "BlackholePlayer [plr]",
					["Description"] = "Loop the blackhole position to the player",
					["Aliases"] = {},
					["Function"] = function(args,speaker)
						execCmd("uncontrolblackhole")
						  thelooplmao = true
						  repeat
							for i,plr in pairs(getPlayer(args[1]))do
							workspace:FindFirstChild("BlackHoleCenter").CFrame = game:GetService("Players")[plr].Character.HumanoidRootPart.CFrame
							end
							wait()
						until thelooplmao == false
					end
					},
					["unblackholeplayer"] = {
						["ListName"] = "UnBlackholePlayer",
						["Description"] = "Stop looping the blackhole position to the player",
						["Aliases"] = {},
						["Function"] = function(args,speaker)
							thelooplmao = false
						end
					},
				["loopsim"] = {
					["ListName"] = "LoopSim",
					["Description"] = "Loop your simulation radius to math.huge, if (somehow) the game put it back to 1000",
					["Aliases"] = {},
					["Function"] = function(args,speaker)
						if sethidden then
						spawn(function()
							while true do
								SetSimulationRadius()
							game:GetService("RunService").Stepped:wait()
							end
						end)
					else
						notify('Incompatible Exploit','Your exploit does not support this command (missing sethiddenproperty)')
					end
					end
				},
				["flingparts"] = {
					["ListName"] = "flingparts [plr]",
					["Description"] = "Spin all unanchoredparts and bring them on the players/fling",
					["Aliases"] = {},
					["Function"] = function(args,speaker)
						SetSimulationRadius()
						
					  local player = getPlayer(args[1], speaker)
				
						local Vel = Vector3.new(5000,5000,5000)
						local MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
						local Pow = 9999999999
						-- Gyro setting
						local Gyro = false -- Do you want the parts to be aligned? (doesnt truly matter)
						local Dampening = 500
						local Power = 3000
				
						local LocalPlayer = game:GetService("Players").LocalPlayer -- Your local player
				
						local unanchoredparts10 = {} -- Get the anchored parts in the table
				
						local moverss = {} -- Put the body position in the table
						

						if SelectedPartsCheck() == false then
				
								-- add the unanchored parts in the table and clear them
								for index, part in pairs(workspace:GetDescendants()) do
									if part:IsA("Part" or "MeshPart" or "Model" or "BasePart") and part.Anchored == false and part:IsDescendantOf(LocalPlayer.Character) == false then
										part.CanCollide = CollideOn
								table.insert(unanchoredparts10, part)
								if part:FindFirstChildOfClass("BodyPosition") ~= nil then
									part:FindFirstChildOfClass("BodyPosition"):Destroy()
								end
							end
						end
				
						 -- Setting for the thing work
						for index, part in pairs(unanchoredparts10) do
							local mov = Instance.new("BodyPosition", part)
							table.insert(moverss, mov)
							mov.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
								end
				
								for index,part in pairs(unanchoredparts10)do
								local ang = Instance.new("BodyAngularVelocity", part)
								ang.AngularVelocity = Vel
								ang.MaxTorque = MaxTorque
								ang.P = Pow
								end
				
								if Gyro == true then
								for i,v in pairs(unanchoredparts10)do
									local gyros = Instance.new("BodyGyro", v)
									gyros.P = Power
									gyros.D = Dampening
								end
								end
						repeat
							local flingon5 = true
							for i,plr in pairs(player)do
							for index, mover in pairs(moverss) do
									mover.Position = Players[plr].Character.HumanoidRootPart.CFrame:PointToWorldSpace(Vector3.new(-0.1,-1,-3.1)) -- Best positon for fling
								end
								end
							game:GetService("RunService").Stepped:wait()
						until flingon5 == false
					else
						-- add the unanchored parts in the table and clear them
						for index, part in pairs(SelectedParts) do
							if part:IsA("Part" or "MeshPart" or "Model" or "BasePart") and part.Anchored == false and part:IsDescendantOf(LocalPlayer.Character) == false then
								part.CanCollide = CollideOn
						if part:FindFirstChildOfClass("BodyPosition") ~= nil then
							part:FindFirstChildOfClass("BodyPosition"):Destroy()
						end
					end
				end
		
				 -- Setting for the thing work
				for index, part in pairs(SelectedParts) do
					local mov = Instance.new("BodyPosition", part)
					table.insert(moverss, mov)
					mov.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
						end
		
						for index,part in pairs(SelectedParts)do
						local ang = Instance.new("BodyAngularVelocity", part)
						ang.AngularVelocity = Vel
						ang.MaxTorque = MaxTorque
						ang.P = Pow
						end
		
						if Gyro == true then
						for i,v in pairs(SelectedParts)do
							local gyros = Instance.new("BodyGyro", v)
							gyros.P = Power
							gyros.D = Dampening
						end
						end
				repeat
					local flingon5 = true
					for i,plr in pairs(player)do
					for index, mover in pairs(moverss) do
							mover.Position = Players[plr].Character.HumanoidRootPart.CFrame:PointToWorldSpace(Vector3.new(-0.1,-1,-3.1)) -- Best positon for fling
						end
						end
					game:GetService("RunService").Stepped:wait()
				until flingon5 == false
					end
				end
				},
				
				["flinghats"] = {
					["ListName"] = "flinghats [plr]",
					["Description"] = "take your hats and fling them",
					["Aliases"] = {},
					["Function"] = function(args,speaker)
					-- Network
					SetSimulationRadius()
				
				  local player = getPlayer(args[1], speaker) -- Target name
		 
		
		
				  hats = {} -- hats table
				
					-- Spin setting
					local Vel = Vector3.new(5000,5000,5000)
					local MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
					local Pow = 9999999999
				
					local LocalPlayer = game:GetService("Players").LocalPlayer -- Your local player
				
					local unanchoredparts101 = {} -- Get the anchored parts in the table
				
					local moversss = {} -- Put the body position in the table
					
					for i,v in pairs(game.Players.LocalPlayer.Character.Humanoid:GetAccessories())do
							for i,handle in pairs(v:GetDescendants())do
							if handle:IsA("BasePart") then
							table.insert(hats,handle)
							v.Parent = workspace
							end
						end
						end
				
							-- add the unanchored parts in the table and clear them
							for index, part in pairs(hats) do
									part.CanCollide = false
							table.insert(unanchoredparts101, part)
							if part:FindFirstChildOfClass("BodyPosition") ~= nil then
								part:FindFirstChildOfClass("BodyPosition"):Destroy()
							end
						end
				
					 -- Setting for the thing work
					for index, part in pairs(unanchoredparts101) do
						local mov = Instance.new("BodyPosition", part)
						table.insert(moversss, mov)
						mov.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
							end
				
							for index,part in pairs(unanchoredparts101)do
							local ang = Instance.new("BodyAngularVelocity", part)
							ang.AngularVelocity = Vel
							ang.MaxTorque = MaxTorque
							ang.P = Pow
							end
				
					repeat
						local flingon5 = true
						for i,plr in pairs(player)do
						for index, mover in pairs(moversss) do
								mover.Position = Players[plr].Character.HumanoidRootPart.CFrame:PointToWorldSpace(Vector3.new(-0.1,-1,-3.29)) -- Best positon for fling
							end
							end
						game:GetService("RunService").Stepped:wait()
					until flingon5 == false
				end
				},
					["unflingparts"] = {
						["ListName"] = "unflingparts / unspinparts",
						["Description"] = "Stop bring the parts and fling to the player",
						["Aliases"] = {'unspinparts'},
						["Function"] = function(args,speaker)
							wait(0.1)
							for i,v in pairs(game.Workspace:GetDescendants()) do
								if v:IsA("BodyPosition") or v:IsA("BodyGyro") or v:IsA("BodyAngularVelocity") then
									v:Destroy()
									flingon5 = false
							end
						end
					end
					},
					["spinparts"] = {
						["ListName"] = "spinparts [plr]",
						["Description"] = "Spin the parts to the player",
						["Aliases"] = {},
						["Function"] = function(args,speaker)
							 -- Network
							 SetSimulationRadius()

					  local player = getPlayer(args[1], speaker) -- Target name
				
						-- Spin setting
						local Vel = Vector3.new(0,90,0)
						local MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
						local Pow = 5000
						-- Gyro setting
						local Gyro = false -- Do you want the parts to be aligned? (doesnt truly matter)
						local Dampening = 500
						local Power = 3000
				
						local LocalPlayer = game:GetService("Players").LocalPlayer -- Your local player
				
						local unanchoredparts10 = {} -- Get the anchored parts in the table
				
						local moverss = {} -- Put the body position in the table

						
						if SelectedPartsCheck() == false then				

								-- add the unanchored parts in the table and clear them
								for index, part in pairs(workspace:GetDescendants()) do
									if part:IsA("Part" or "MeshPart" or "Model" or "BasePart") and part.Anchored == false and part:IsDescendantOf(LocalPlayer.Character) == false then
										part.CanCollide = CollideOn
								table.insert(unanchoredparts10, part)
								if part:FindFirstChildOfClass("BodyPosition") ~= nil then
									part:FindFirstChildOfClass("BodyPosition"):Destroy()
								end
							end
						end
				
						 -- Setting for the thing work
						for index, part in pairs(unanchoredparts10) do
							local mov = Instance.new("BodyPosition", part)
							table.insert(moverss, mov)
							mov.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
								end
				
								for index,part in pairs(unanchoredparts10)do
								local ang = Instance.new("BodyAngularVelocity", part)
								ang.AngularVelocity = Vel
								ang.MaxTorque = MaxTorque
								ang.P = Pow
								end
				
								if Gyro == true then
								for i,v in pairs(unanchoredparts10)do
									local gyros = Instance.new("BodyGyro", v)
									gyros.P = Power
									gyros.D = Dampening
								end
								end
						repeat
							local flingon5 = true
							for i,plr in pairs(player)do
							for index, mover in pairs(moverss) do
									mover.Position = Players[plr].Character.HumanoidRootPart.CFrame:PointToWorldSpace()
								end
								end
							game:GetService("RunService").Stepped:wait()
						until flingon5 == false
					else
						-- add the unanchored parts in the table and clear them
						for index, part in pairs(SelectedParts) do
							if part:IsA("Part" or "MeshPart" or "Model" or "BasePart") and part.Anchored == false and part:IsDescendantOf(LocalPlayer.Character) == false then
								part.CanCollide = CollideOn
						if part:FindFirstChildOfClass("BodyPosition") ~= nil then
							part:FindFirstChildOfClass("BodyPosition"):Destroy()
						end
					end
				end
		
				 -- Setting for the thing work
				for index, part in pairs(SelectedParts) do
					local mov = Instance.new("BodyPosition", part)
					table.insert(moverss, mov)
					mov.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
						end
		
						for index,part in pairs(SelectedParts)do
						local ang = Instance.new("BodyAngularVelocity", part)
						ang.AngularVelocity = Vel
						ang.MaxTorque = MaxTorque
						ang.P = Pow
						end
		
						if Gyro == true then
						for i,v in pairs(SelectedParts)do
							local gyros = Instance.new("BodyGyro", v)
							gyros.P = Power
							gyros.D = Dampening
						end
						end
				repeat
					local flingon5 = true
					for i,plr in pairs(player)do
					for index, mover in pairs(moverss) do
							mover.Position = Players[plr].Character.HumanoidRootPart.CFrame:PointToWorldSpace()
						end
						end
					game:GetService("RunService").Stepped:wait()
				until flingon5 == false
					end
				end
				},
				["selectparts"] = {
					["ListName"] = "SelectParts",
					["Description"] = "Select part that you want to use instead of all",
					["Aliases"] = {},
					["Function"] = function(args,speaker)
						SetSimulationRadius()

						 local selectTool = Instance.new("Tool")
						 selectTool.Name = "Select Parts Tool"
						 selectTool.Parent = speaker.Backpack
						 selectTool.RequiresHandle = false


			selectTool.Equipped:Connect(function()
-- The code is from Roblox dev website itself
local player = speaker
local mouse = player:GetMouse() --Getting the player's mouse
 
local selection = Instance.new("SelectionBox")
selection.Color3 = Color3.fromRGB(0, 100, 255)
selection.Parent = player.PlayerGui
 
mouse.Move:Connect(function() --When the mouse moves
	local target = mouse.Target
 
	if not target then
		-- nothing selected
		selection.Adornee = nil
	else
		if target:IsA("BasePart") and not target:IsDescendantOf(speaker.Character) then
			selection.Adornee = target
		else
			selection.Adornee = nil
		end
	end
end)
end)

selectTool.Activated:Connect(function()
local Player = game.Players.LocalPlayer
local Mouse = Player:GetMouse() --Getting the player's mouse
local target = Mouse.Target 
if target:IsA("BasePart") and target.Anchored == false and not target:IsDescendantOf(speaker.Character) then
	table.insert(SelectedParts, target)
	notify("FunGrav", target:GetFullName().." Added to the list !")
elseif target:IsA("BasePart") and target.Anchored == true then
	notify("FunGrav", "This part is Anchored, I won't add it to your selected parts list!")
end
end)

selectTool.Unequipped:Connect(function()
speaker.PlayerGui.SelectionBox:Destroy()
end)
					end
				},
				["resetselectedpartslist"] = {
					["ListName"] = "ResetSelectedPartsList / RSPL",
					["Description"] = "Reset your parts list",
					["Aliases"] = {'rspl'},
					["Function"] = function(args,speaker)
						    SelectedParts = {}
							notify("FunGrav", "List Reseted !")
						end
				},
				["uselist"] = {
					["ListName"] = "UseList (TOGGLE)",
					["Description"] = "Use the parts list you made with ;selectparts.",
					["Aliases"] = {},
					["Function"] = function(args,speaker)
						 if OnlySelectedParts == false then
							OnlySelectedParts = true
							notify("FunGrav", "FunGrav will only use your parts list.")
						 else
							OnlySelectedParts = false
							notify("FunGrav", "FunGrav will use every parts.")
						 end
					end
				},
				["spinpartsmouse"] = {
					["ListName"] = "spinpartsmouse",
					["Description"] = "Spin the parts to your mouse position",
					["Aliases"] = {},
					["Function"] = function(args,speaker)

                                 SetSimulationRadius()

				
								 -- Spin setting
								 local Vel = Vector3.new(0,90,0)
								 local MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
								 local Pow = 5000
								 -- Gyro setting
								 local Gyro = false -- Do you want the parts to be aligned? (doesnt truly matter)
								 local Dampening = 500
								 local Power = 3000
						 
								 local LocalPlayer = game:GetService("Players").LocalPlayer -- Your local player

								 local mouse = LocalPlayer:GetMouse()
						 
								 local unanchoredparts10 = {} -- Get the anchored parts in the table
						 
								 local moverss = {} -- Put the body position in the table
		 
								 
								 if SelectedPartsCheck() == false then				
		 
										 -- add the unanchored parts in the table and clear them
										 for index, part in pairs(workspace:GetDescendants()) do
											 if part:IsA("Part" or "MeshPart" or "Model" or "BasePart") and part.Anchored == false and part:IsDescendantOf(LocalPlayer.Character) == false then
												 part.CanCollide = CollideOn
										 table.insert(unanchoredparts10, part)
										 if part:FindFirstChildOfClass("BodyPosition") ~= nil then
											 part:FindFirstChildOfClass("BodyPosition"):Destroy()
										 end
									 end
								 end
						 
								  -- Setting for the thing work
								 for index, part in pairs(unanchoredparts10) do
									 local mov = Instance.new("BodyPosition", part)
									 table.insert(moverss, mov)
									 mov.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
										 end
						 
										 for index,part in pairs(unanchoredparts10)do
										 local ang = Instance.new("BodyAngularVelocity", part)
										 ang.AngularVelocity = Vel
										 ang.MaxTorque = MaxTorque
										 ang.P = Pow
										 end
						 
										 if Gyro == true then
										 for i,v in pairs(unanchoredparts10)do
											 local gyros = Instance.new("BodyGyro", v)
											 gyros.P = Power
											 gyros.D = Dampening
										 end
										 end
								 repeat
									 local flingon5 = true
									 for index, mover in pairs(moverss) do
											 mover.Position = mouse.Hit:PointToWorldSpace()
										 end
									 game:GetService("RunService").Stepped:wait()
								 until flingon5 == false
							 else
								 -- add the unanchored parts in the table and clear them
								 for index, part in pairs(SelectedParts) do
									 if part:IsA("Part" or "MeshPart" or "Model" or "BasePart") and part.Anchored == false and part:IsDescendantOf(LocalPlayer.Character) == false then
										 part.CanCollide = CollideOn
								 if part:FindFirstChildOfClass("BodyPosition") ~= nil then
									 part:FindFirstChildOfClass("BodyPosition"):Destroy()
								 end
							 end
						 end
				 
						  -- Setting for the thing work
						 for index, part in pairs(SelectedParts) do
							 local mov = Instance.new("BodyPosition", part)
							 table.insert(moverss, mov)
							 mov.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
								 end
				 
								 for index,part in pairs(SelectedParts)do
								 local ang = Instance.new("BodyAngularVelocity", part)
								 ang.AngularVelocity = Vel
								 ang.MaxTorque = MaxTorque
								 ang.P = Pow
								 end
				 
								 if Gyro == true then
								 for i,v in pairs(SelectedParts)do
									 local gyros = Instance.new("BodyGyro", v)
									 gyros.P = Power
									 gyros.D = Dampening
								 end
								 end
						 repeat
							 local flingon5 = true
							 for i,plr in pairs(player)do
							 for index, mover in pairs(moverss) do
									 mover.Position = mouse.Hit:PointToWorldSpace()
								 end
								 end
							 game:GetService("RunService").Stepped:wait()
						 until flingon5 == false
							 end
						 end
				},
				["flingpartsmouse"] = {
					["ListName"] = "flingpartsmouse",
					["Description"] = "fling the parts to your mouse position",
					["Aliases"] = {},
					["Function"] = function(args,speaker)

                                 SetSimulationRadius()

				
								 -- Spin setting
						        local Vel = Vector3.new(5000,5000,5000)
						        local MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
						        local Pow = 9999999999
								 
								 -- Gyro setting
								 local Gyro = false -- Do you want the parts to be aligned? (doesnt truly matter)
								 local Dampening = 500
								 local Power = 3000
						 
								 local LocalPlayer = game:GetService("Players").LocalPlayer -- Your local player

								 local mouse = LocalPlayer:GetMouse()
						 
								 local unanchoredparts10 = {} -- Get the anchored parts in the table
						 
								 local moverss = {} -- Put the body position in the table
		 
								 
								 if SelectedPartsCheck() == false then				
		 
										 -- add the unanchored parts in the table and clear them
										 for index, part in pairs(workspace:GetDescendants()) do
											 if part:IsA("Part" or "MeshPart" or "Model" or "BasePart") and part.Anchored == false and part:IsDescendantOf(LocalPlayer.Character) == false then
												 part.CanCollide = CollideOn
										 table.insert(unanchoredparts10, part)
										 if part:FindFirstChildOfClass("BodyPosition") ~= nil then
											 part:FindFirstChildOfClass("BodyPosition"):Destroy()
										 end
									 end
								 end
						 
								  -- Setting for the thing work
								 for index, part in pairs(unanchoredparts10) do
									 local mov = Instance.new("BodyPosition", part)
									 table.insert(moverss, mov)
									 mov.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
										 end
						 
										 for index,part in pairs(unanchoredparts10)do
										 local ang = Instance.new("BodyAngularVelocity", part)
										 ang.AngularVelocity = Vel
										 ang.MaxTorque = MaxTorque
										 ang.P = Pow
										 end
						 
										 if Gyro == true then
										 for i,v in pairs(unanchoredparts10)do
											 local gyros = Instance.new("BodyGyro", v)
											 gyros.P = Power
											 gyros.D = Dampening
										 end
										 end
								 repeat
									 local flingon5 = true
									 for index, mover in pairs(moverss) do
											 mover.Position = mouse.Hit:PointToWorldSpace()
										 end
									 game:GetService("RunService").Stepped:wait()
								 until flingon5 == false
							 else
								 -- add the unanchored parts in the table and clear them
								 for index, part in pairs(SelectedParts) do
									 if part:IsA("Part" or "MeshPart" or "Model" or "BasePart") and part.Anchored == false and part:IsDescendantOf(LocalPlayer.Character) == false then
										 part.CanCollide = CollideOn
								 if part:FindFirstChildOfClass("BodyPosition") ~= nil then
									 part:FindFirstChildOfClass("BodyPosition"):Destroy()
								 end
							 end
						 end
				 
						  -- Setting for the thing work
						 for index, part in pairs(SelectedParts) do
							 local mov = Instance.new("BodyPosition", part)
							 table.insert(moverss, mov)
							 mov.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
								 end
				 
								 for index,part in pairs(SelectedParts)do
								 local ang = Instance.new("BodyAngularVelocity", part)
								 ang.AngularVelocity = Vel
								 ang.MaxTorque = MaxTorque
								 ang.P = Pow
								 end
				 
								 if Gyro == true then
								 for i,v in pairs(SelectedParts)do
									 local gyros = Instance.new("BodyGyro", v)
									 gyros.P = Power
									 gyros.D = Dampening
								 end
								 end
						 repeat
							 local flingon5 = true
							 for i,plr in pairs(player)do
							 for index, mover in pairs(moverss) do
									 mover.Position = mouse.Hit:PointToWorldSpace()
								 end
								 end
							 game:GetService("RunService").Stepped:wait()
						 until flingon5 == false
							 end
						 end
				},
				["partscollide"] = {
					["ListName"] = "partscollide (TOGGLE)",
					["Description"] = "Toggle if you want fling and spin commands make the parts collide or not",
					["Aliases"] = {},
					["Function"] = function(args,speaker)
						if CollideOn == true then
							CollideOn = false
							notify("FunGrav", "Parts will not collide")
						else
							CollideOn = true
							notify("FunGrav", "Parts will collide")
						end

					end
				},
				["blackholedestroyparts"] = {
					["ListName"] = "BlackHoleDestroyParts / bhdp (TOGGLE)",
					["Description"] = "Do you want the blackhole command destroy the parts that touch it ?",
					["Aliases"] = {"bhdp"},
					["Function"] = function(args,speaker)
						if BlackHoleDestroyParts == true then
							BlackHoleDestroyParts = false
							notify("FunGrav", "The blackhole won't destroy the parts that touch it")
						else
							BlackHoleDestroyParts = true
							notify("FunGrav", "The blackhole will destroy the parts that touch it")
						end
					end
				},
				["earthquake"] = {
					["ListName"] = "earthquake",
					["Description"] = "Use unanchored parts and shake it, so it's like a earthquake",
					["Aliases"] = {},
					["Function"] = function(args,speaker)

local partsz = {}
local velos = {}


for i,parts in pairs(workspace:GetDescendants())do
	if parts:IsA("BasePart") and parts.Anchored == false and not parts:IsDescendantOf(speaker.Character) then
        table.insert(partsz, parts)
    end
end


for i,v in pairs(partsz)do
local velo = Instance.new("BodyVelocity", v)
table.insert(velos, velo)
velo.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
velo.P = 10000000
end

bruh = true

repeat
    for i,veloss in pairs(velos)do
    veloss.Velocity = Vector3.new(math.random(-9,9),math.random(-5,3),math.random(-9,9))
    end
wait()
until bruh == false
					end
				},
				["unearthquake"] = {
					["ListName"] = "unearthquake",
					["Description"] = "Stop the earthquake",
					["Aliases"] = {},
					["Function"] = function(args,speaker)
						for i,v in pairs(workspace:GetDescendants()) do
							if v:IsA("BodyVelocity") then
								v:Destroy()
							end
						end
							bruh = false
					end
				},
	}
}

return Plugin
