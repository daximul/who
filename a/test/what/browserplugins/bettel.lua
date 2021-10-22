local function sandbox(var,func)
	local env = getfenv(func)
	local newenv = setmetatable({},{
		__index = function(self,k)
			if k=="script" then
				return var
			else
				return env[k]
			end
		end,
	})
	setfenv(func,newenv)
	return func
end

local cors = {}

local mas = Instance.new("Model", game:GetService("Lighting"))

Tool0 = Instance.new("Tool")
Part1 = Instance.new("Part")
Script2 = Instance.new("Script")
LocalScript3 = Instance.new("LocalScript")

Tool0.Name = "Telekinesis"
Tool0.Parent = mas
Tool0.RequiresHandle = false
Tool0.CanBeDropped = false

Part1.Name = "Handle"
Part1.Parent = Tool0
Part1.CFrame = CFrame.new(-17.2635937, 15.4915619, 46, 0, 1, 0, 1, 0, 0, 0, 0, -1)
Part1.Orientation = Vector3.new(0, 180, 90)
Part1.Position = Vector3.new(-17.2635937, 15.4915619, 46)
Part1.Rotation = Vector3.new(-180, 0, -90)
Part1.Color = Color3.new(0.0666667, 0.0666667, 0.0666667)
Part1.Transparency = 1
Part1.Size = Vector3.new(1, 1.20000005, 1)
Part1.BottomSurface = Enum.SurfaceType.Weld
Part1.BrickColor = BrickColor.new("Really black")
Part1.Material = Enum.Material.Metal
Part1.TopSurface = Enum.SurfaceType.Smooth
Part1.brickColor = BrickColor.new("Really black")

Script2.Name = "LineConnect"
Script2.Parent = Tool0
table.insert(cors,sandbox(Script2,function()

wait()

local check = script.Part2
local part1 = script.Part1.Value
local part2 = script.Part2.Value
local parent = script.Par.Value
local color = script.Color
local line = Instance.new("Part")

line.TopSurface = 0
line.BottomSurface = 0
line.Reflectance = .5
line.Name = "Laser"
line.Locked = true
line.CanCollide = false
line.Anchored = true
line.formFactor = 0
line.Size = Vector3.new(1,1,1)

local mesh = Instance.new("BlockMesh")
mesh.Parent = line

while true do
	if (check.Value==nil) then break end
	if (part1==nil or part2==nil or parent==nil) then break end
	if (part1.Parent==nil or part2.Parent==nil) then break end
	if (parent.Parent==nil) then break end

	local lv = CFrame.new(part1.Position,part2.Position)
	local dist = (part1.Position-part2.Position).magnitude

	line.Parent = parent
	line.BrickColor = color.Value.BrickColor
	line.Reflectance = color.Value.Reflectance
	line.Transparency = color.Value.Transparency
	line.CFrame = CFrame.new(part1.Position+lv.lookVector*dist/2)
	line.CFrame = CFrame.new(line.Position,part2.Position)

	mesh.Scale = Vector3.new(.25,.25,dist)

	wait()
end

line:remove()
script:remove()

end))

Script2.Disabled = true
LocalScript3.Name = "MainScript"
LocalScript3.Parent = Tool0
table.insert(cors,sandbox(LocalScript3,function()

wait() 
tool = script.Parent
lineconnect = tool.LineConnect
object = nil
mousedown = false
found = false

BP = Instance.new("BodyPosition")
BP.maxForce = Vector3.new(math.huge*math.huge,math.huge*math.huge,math.huge*math.huge)
BP.P = BP.P*1.1
dist = nil

point = Instance.new("Part")
point.Locked = true
point.Anchored = true
point.formFactor = 0
point.Shape = 0
point.BrickColor = BrickColor.Black() 
point.Size = Vector3.new(1,1,1)
point.CanCollide = false

local mesh = Instance.new("SpecialMesh")
mesh.MeshType = "Sphere"
mesh.Scale = Vector3.new(.7,.7,.7)
mesh.Parent = point

handle = tool.Handle
front = tool.Handle
color = tool.Handle
objval = nil
local hooked = false 
local hookBP = BP:clone() 

hookBP.maxForce = Vector3.new(30000,30000,30000) 

function LineConnect(part1,part2,parent)
	local p1 = Instance.new("ObjectValue")
	p1.Value = part1
	p1.Name = "Part1"
	local p2 = Instance.new("ObjectValue")
	p2.Value = part2
	p2.Name = "Part2"
	local par = Instance.new("ObjectValue")
	par.Value = parent
	par.Name = "Par"
	local col = Instance.new("ObjectValue")
	col.Value = color
	col.Name = "Color"
	local s = lineconnect:clone()
	s.Disabled = false
	p1.Parent = s
	p2.Parent = s
	par.Parent = s
	col.Parent = s
	s.Parent = workspace
	if (part2==object) then
		objval = p2
	end
end

function onButton1Down(mouse)
	if (mousedown==true) then return end

	mousedown = true

	coroutine.resume(coroutine.create(function()
		local p = point:clone()
		p.Parent = tool
		LineConnect(front,p,workspace)
		while (mousedown==true) do
			p.Parent = tool
			if (object==nil) then
				if (mouse.Target==nil) then
					local lv = CFrame.new(front.Position,mouse.Hit.p)
					p.CFrame = CFrame.new(front.Position+(lv.lookVector*1000))
				else
					p.CFrame = CFrame.new(mouse.Hit.p)
				end
			else
				LineConnect(front,object,workspace)
				break
			end
			wait()
		end
		p:remove()
	end))

	while (mousedown==true) do
		if (mouse.Target~=nil) then
			local t = mouse.Target
			if (t.Anchored==false) then
				object = t
				dist = (object.Position-front.Position).magnitude
				break
			end
		end
		wait()
	end

	while (mousedown==true) do
		if (object.Parent==nil) then break end
		local lv = CFrame.new(front.Position,mouse.Hit.p)
		BP.Parent = object
		BP.position = front.Position+lv.lookVector*dist
		wait()
	end

	BP:remove()
	object = nil
	objval.Value = nil
end

function onKeyDown(key,mouse) 
	local key = key:lower() 
	local yesh = false 

	if (key=="q") then 
		if (dist>=5) then 
			dist = dist-10 
		end 
	end 

	if key == "r" then 
	if (object==nil) then return end 
	for _,v in pairs(object:children()) do 
	if v.className == "BodyGyro" then 
	return nil 
	end 
	end 
	BG = Instance.new("BodyGyro") 
	BG.maxTorque = Vector3.new(math.huge,math.huge,math.huge) 
	BG.cframe = CFrame.new(object.CFrame.p) 
	BG.Parent = object 
	repeat wait() until(object.CFrame == CFrame.new(object.CFrame.p)) 
	BG.Parent = nil 
	if (object==nil) then return end 
	for _,v in pairs(object:children()) do 
	if v.className == "BodyGyro" then 
	v.Parent = nil 
	end 
	end 
	object.Velocity = Vector3.new(0,0,0) 
	object.RotVelocity = Vector3.new(0,0,0)	
	object.Orientation = Vector3.new(0,0,0)	
	end 

	if (key=="e") then
		dist = dist+10
	end

	if (key=="t") then 
		if dist ~= 10 then 
			dist = 10 
		end 
	end

	if (key=="y") then 
		if dist ~= 200 then 
			dist = 200 
		end 
	end

	if (key=="=") then
		BP.P = BP.P*1.5
	end

	if (key=="-") then
		BP.P = BP.P*0.5
	end

end

function onEquipped(mouse)
	keymouse = mouse
	local char = tool.Parent
	human = char.Humanoid

	human.Changed:connect(function() if (human.Health==0) then mousedown = false BP:remove() point:remove() tool:remove() end end)

	mouse.Button1Down:connect(function() onButton1Down(mouse) end)
	mouse.Button1Up:connect(function() mousedown = false end)
	mouse.KeyDown:connect(function(key) onKeyDown(key,mouse) end)
	mouse.Icon = "rbxasset://textures\\GunCursor.png"
end

tool.Equipped:connect(onEquipped)
end))

for i,v in pairs(mas:GetChildren()) do
	v.Parent = game:GetService("Players").LocalPlayer.Backpack
	pcall(function() v:MakeJoints() end)
end

mas:Destroy()

for i,v in pairs(cors) do
	spawn(function()
		pcall(v)
	end)
end
