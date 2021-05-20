local KnifeAccessory = "Waiting"
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local sethidden = sethiddenproperty or set_hidden_property or set_hidden_prop

if LocalPlayer.Character:FindFirstChild("YandereKnife") and LocalPlayer.Character["YandereKnife"].ClassName == "Accessory" then
    KnifeAccessory = LocalPlayer.Character["YandereKnife"]
else
    KnifeAccessory = LocalPlayer.Character:FindFirstChildOfClass("Accessory")
end

if (KnifeAccessory == "Waiting") then return end

RunService.Heartbeat:Connect(function()
    pcall(function() LocalPlayer.MaximumSimulationRadius = (math.pow(math.huge, math.huge) * math.huge) end)
    pcall(function() sethidden(LocalPlayer, "SimulationRadius", math.pow(math.huge, math.huge) * math.huge) end)
    for i, v in pairs(Players:GetPlayers()) do
        if v ~= LocalPlayer then
            pcall(function() LocalPlayer.MaximumSimulationRadius = (math.pow(math.huge, math.huge) * math.huge) end)
            pcall(function() settings().Physics.AllowSleep = (false) end)
            pcall(function() sethidden(LocalPlayer, "SimulationRadius", math.pow(math.huge, math.huge) * math.huge) end)
            pcall(function() LocalPlayer.ReplicationFocus = (workspace) end)
        end
    end
end)

local LeftArm = LocalPlayer.Character["Left Arm"]:Clone()
LeftArm.Parent = LocalPlayer.Character
LeftArm.Name = "LeftArm"
LeftArm.Transparency = 1
LeftArm:ClearAllChildren()

local RightArm = LocalPlayer.Character["Right Arm"]:Clone()
RightArm.Parent = LocalPlayer.Character
RightArm.Name = "RightArm"
RightArm.Transparency = 1
RightArm:ClearAllChildren()

local Stuff = {
    Events = {}, 
    Debounces = {Button1DownDebounce = false}, 
    PlrHeld = nil, 
    Mode = 1 -- 1 = kill, 2 = throw, 3 = let go, 4 = suicide
}

if LocalPlayer.Character:FindFirstChild("-GrabKnife") then
    LocalPlayer.Character:FindFirstChild("-GrabKnife"):Destroy()
end
if LocalPlayer.Character:FindFirstChild("GrabKnifeLA") then
    LocalPlayer.Character:FindFirstChild("GrabKnifeLA"):Destroy()
end
if LocalPlayer.Character:FindFirstChild("GrabKnifeRA") then
    LocalPlayer.Character:FindFirstChild("GrabKnifeRA"):Destroy()
end

local LA
local RA

local RS = LocalPlayer.Character.Torso["Right Shoulder"]:Clone()
LocalPlayer.Character.Torso["Right Shoulder"]:Destroy()

RS.Parent = LocalPlayer.Character.Torso
RS.Part0 = RS.Parent
RS.Part1 = RightArm

local Attach0 = Instance.new("Attachment")
Attach0.Parent = LocalPlayer.Character["Right Arm"]
local Attach1 = Instance.new("Attachment")
Attach1.Parent = RightArm

local Pos = Instance.new("AlignPosition")
Pos.Parent = LocalPlayer.Character.Torso
Pos.RigidityEnabled = true
Pos.Attachment0, Pos.Attachment1 = Attach0, Attach1

local Rot = Instance.new("AlignOrientation")
Rot.Parent = LocalPlayer.Character.Torso
Rot.RigidityEnabled = true
Rot.Attachment0, Rot.Attachment1 = Attach0, Attach1

local LS = LocalPlayer.Character.Torso["Left Shoulder"]:Clone()
LocalPlayer.Character.Torso["Left Shoulder"]:Destroy()

LS.Parent = LocalPlayer.Character.Torso
LS.Part0 = LS.Parent
LS.Part1 = LeftArm

local Attach0 = Instance.new("Attachment")
Attach0.Parent = LocalPlayer.Character["Left Arm"]
local Attach1 = Instance.new("Attachment")
Attach1.Parent = LeftArm

local Pos = Instance.new("AlignPosition")
Pos.Parent = LocalPlayer.Character.Torso
Pos.RigidityEnabled = true
Pos.Attachment0, Pos.Attachment1 = Attach0, Attach1

local Rot = Instance.new("AlignOrientation")
Rot.Parent = LocalPlayer.Character.Torso
Rot.RigidityEnabled = true
Rot.Attachment0, Rot.Attachment1 = Attach0, Attach1

local Knife = Instance.new("Part")
Knife.Name = "-GrabKnife"
Knife.Parent = LocalPlayer.Character
Knife.Size = Vector3.new(0.25, 2, 0.25)
Knife.Transparency = 1
Knife.CanCollide = false

local KnifeWeld = Instance.new("Weld")
KnifeWeld.Parent = Knife
KnifeWeld.Part0 = LeftArm
KnifeWeld.Part1 = Knife
KnifeWeld.C0 = CFrame.new(Vector3.new(0.2, -0.85, 0)) * CFrame.Angles(math.rad(0), math.rad(00), math.rad(0))
KnifeWeld.C1 = CFrame.new(Vector3.new(0, 0.75, -0.125)) * CFrame.Angles(math.rad(0), math.rad(0), math.rad(0))

KnifeAccessory.Handle.AccessoryWeld:Destroy()
local Attach0 = Instance.new("Attachment")
Attach0.Parent = KnifeAccessory.Handle
Attach0.CFrame = CFrame.new(Vector3.new(-0.5, 0, -0.5)) * CFrame.Angles(math.rad(0), math.rad(-90), math.rad(-90))
local Attach1 = Instance.new("Attachment")
Attach1.Parent = Knife

local Pos = Instance.new("AlignPosition")
Pos.Parent = Knife
Pos.RigidityEnabled = true
Pos.Attachment0, Pos.Attachment1 = Attach0, Attach1

local Rot = Instance.new("AlignOrientation")
Rot.Parent = Knife
Rot.RigidityEnabled = true
Rot.Attachment0, Rot.Attachment1 = Attach0, Attach1

Stuff.Events.ModeChangeEvent = game:GetService("UserInputService").InputBegan:Connect(function(Key)
    if Key.KeyCode == Enum.KeyCode.Q then
        Stuff.Mode = 1
    elseif Key.KeyCode == Enum.KeyCode.E then
        Stuff.Mode = 2
    elseif Key.KeyCode == Enum.KeyCode.R then
        Stuff.Mode = 3
    elseif Key.KeyCode == Enum.KeyCode.T then
        Stuff.Mode = 4
    end
end)

Stuff.Events.Button1DownEvent = LocalPlayer:GetMouse().Button1Down:Connect(function()
    if Stuff.Debounces.Button1DownDebounce == false and Stuff.PlrHeld == nil and Stuff.Mode ~= 4 then
    
        Stuff.Debounces.Button1DownDebounce = true
        
        LA = Instance.new("Weld")
        LA.Name = "GrabKnifeLA"
        LA.Parent = LocalPlayer.Character
        LA.Part0 = LocalPlayer.Character.Torso
        LA.Part1 = LeftArm
        LA.C0 = CFrame.new(Vector3.new(-1, 1, 0)) * CFrame.Angles(math.rad(10), math.rad(10), math.rad(-10))
        LA.C1 = CFrame.new(Vector3.new(0.5, 1, 0)) * CFrame.Angles(math.rad(0), math.rad(0), math.rad(0))
        
        RA = Instance.new("Weld")
        RA.Name = "GrabKnifeRA"
        RA.Parent = LocalPlayer.Character
        RA.Part0 = LocalPlayer.Character.Torso
        RA.Part1 = RightArm
        RA.C0 = CFrame.new(Vector3.new(1, 1, 0)) * CFrame.Angles(math.rad(10), math.rad(-10), math.rad(10))
        RA.C1 = CFrame.new(Vector3.new(-0.5, 1, 0)) * CFrame.Angles(math.rad(0), math.rad(0), math.rad(0))
        
        wait(0.1)
        game:GetService("TweenService"):Create(LA, TweenInfo.new(0.25, Enum.EasingStyle.Circular, Enum.EasingDirection.Out), { C0 = CFrame.new(Vector3.new(-1, 0.75, 0)) * CFrame.Angles(math.rad(80), math.rad(-90), math.rad(-10)) }):Play()
        game:GetService("TweenService"):Create(RA, TweenInfo.new(0.25, Enum.EasingStyle.Circular, Enum.EasingDirection.Out), { C0 = CFrame.new(Vector3.new(1, 0.75, 0)) * CFrame.Angles(math.rad(70), math.rad(40), math.rad(10)) }):Play()
        
        local PossiblePlr
        for i = 1, 20 do
            if Stuff.PlrHeld == nil then
                PossiblePlr = game.Workspace:FindPartOnRay(Ray.new(LocalPlayer.Character.HumanoidRootPart.Position, LocalPlayer.Character.HumanoidRootPart.CFrame.LookVector * 2))
                if PossiblePlr ~= nil and game.Players:GetPlayerFromCharacter(PossiblePlr.Parent) and game.Players:GetPlayerFromCharacter(PossiblePlr.Parent).Character then
                    Stuff.PlrHeld = game.Players:GetPlayerFromCharacter(PossiblePlr.Parent)
                    break
                end
                wait(0.0375)
            end
        end
        LA:Destroy()
        RA:Destroy()
        LA = nil
        RA = nil
        Stuff.Debounces.Button1DownDebounce = false
        
    elseif Stuff.Mode ~= 4 and Stuff.PlrHeld ~= nil and Stuff.PlrHeld.ClassName == "Player" and Stuff.PlrHeld.Character and Stuff.PlrHeld.Character.PrimaryPart and Stuff.PlrHeld.Character:FindFirstChildOfClass("Humanoid") and Stuff.PlrHeld.Character:FindFirstChildOfClass("Humanoid").Health > 0 then
        
        if Stuff.Mode == 1 then -- kill
            game:GetService("TweenService"):Create(LA, TweenInfo.new(0.25, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut), { C0 = CFrame.new(Vector3.new(-1, 0.75, 0)) * CFrame.Angles(math.rad(90), math.rad(-100), math.rad(-10)) }):Play()
            wait(0.35)
            game:GetService("TweenService"):Create(LA, TweenInfo.new(0.175, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut), { C0 = CFrame.new(Vector3.new(-1, 0.75, 0)) * CFrame.Angles(math.rad(50), math.rad(-60), math.rad(-20)) }):Play()
            wait(0.175)
            Stuff.PlrHeld.Character:FindFirstChildOfClass("Humanoid").Health = 0
            wait(0.25)
            Stuff.PlrHeld = nil
            if LA then
            LA:Destroy()
            LA = nil
            end
            if RA then
            RA:Destroy()
            RA = nil
            end
        elseif Stuff.Mode == 2 then -- throw
            game:GetService("TweenService"):Create(LA, TweenInfo.new(0.15, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), { C0 = CFrame.new(Vector3.new(-1, 0.75, 0)) * CFrame.Angles(math.rad(0), math.rad(10), math.rad(-10)) }):Play()
            game:GetService("TweenService"):Create(RA, TweenInfo.new(0.15, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), { C0 = CFrame.new(Vector3.new(1, 0.75, 1)) * CFrame.Angles(math.rad(70), math.rad(60), math.rad(10)) }):Play()
            wait(0.075)
            Stuff.PlrHeld.Character:FindFirstChildOfClass("Humanoid").PlatformStand = true
            local BF = Instance.new("BodyForce")
            BF.Parent = Stuff.PlrHeld.Character.PrimaryPart
            BF.Force = Vector3.new(0, 20, 0) + LocalPlayer.Character.HumanoidRootPart.CFrame.LookVector * 20
            wait(0.25)
            BF:Destroy()
            wait(0.25)
            Stuff.PlrHeld.Character:FindFirstChildOfClass("Humanoid").PlatformStand = false
            if Stuff.PlrHeld.Character.PrimaryPart:FindFirstChild("CFrameFix") then
                Stuff.PlrHeld.Character.PrimaryPart:FindFirstChild("CFrameFix"):Destroy()
            end
            Stuff.PlrHeld = nil
            if LA then
            LA:Destroy()
            LA = nil
            end
            if RA then
            RA:Destroy()
            RA = nil
            end
        elseif Stuff.Mode == 3 then -- let go
            if Stuff.PlrHeld.Character.PrimaryPart:FindFirstChild("CFrameFix") then
                Stuff.PlrHeld.Character.PrimaryPart:FindFirstChild("CFrameFix"):Destroy()
            end
            Stuff.PlrHeld.Character:FindFirstChildOfClass("Humanoid").PlatformStand = false
            Stuff.PlrHeld = nil
            if LA then
            LA:Destroy()
            LA = nil
            end
            if RA then
            RA:Destroy()
            RA = nil
            end
        end

    elseif Stuff.Mode == 4 then -- suicide

        if LA then
            LA:Destroy()
            LA = nil
        end
        if RA then
            RA:Destroy()
            RA = nil
        end

        LA = Instance.new("Weld")
        LA.Name = "GrabKnifeLA"
        LA.Parent = LocalPlayer.Character
        LA.Part0 = LocalPlayer.Character.Torso
        LA.Part1 = LeftArm
        LA.C0 = CFrame.new(Vector3.new(-1, 0.75, 0)) * CFrame.Angles(math.rad(10), math.rad(10), math.rad(-10))
        LA.C1 = CFrame.new(Vector3.new(0.5, 1, 0)) * CFrame.Angles(math.rad(0), math.rad(0), math.rad(0))
        wait(0.5)
        
        game:GetService("TweenService"):Create(LA, TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), { C0 = CFrame.new(Vector3.new(-1.5, 0.75, 0)) * CFrame.Angles(math.rad(80), math.rad(-100), math.rad(-10)) }):Play()
        wait(1.5)

        game:GetService("TweenService"):Create(LA, TweenInfo.new(0.075, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), { C0 = CFrame.new(Vector3.new(-1.5, 0.75, 1)) * CFrame.Angles(math.rad(30), math.rad(-130), math.rad(-10)) }):Play()
        wait(0.1)
        if LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
            LocalPlayer.Character:FindFirstChildOfClass("Humanoid").Health = 0
        end

    end
end)

repeat
    if Stuff.PlrHeld ~= nil and Stuff.PlrHeld.ClassName == "Player" and Stuff.PlrHeld.Character and Stuff.PlrHeld.Character.PrimaryPart and Stuff.PlrHeld.Character:FindFirstChildOfClass("Humanoid") and Stuff.PlrHeld.Character:FindFirstChildOfClass("Humanoid").Health > 0 then
        if LA == nil then
            LA = Instance.new("Weld")
            LA.Name = "GrabKnifeLA"
            LA.Parent = LocalPlayer.Character
            LA.Part0 = LocalPlayer.Character.Torso
            LA.Part1 = LeftArm
            LA.C0 = CFrame.new(Vector3.new(-1, 0.75, 0)) * CFrame.Angles(math.rad(80), math.rad(-90), math.rad(-10))
            LA.C1 = CFrame.new(Vector3.new(0.5, 1, 0)) * CFrame.Angles(math.rad(0), math.rad(0), math.rad(0))
        end
        if RA == nil then
            RA = Instance.new("Weld")
            RA.Name = "GrabKnifeRA"
            RA.Parent = LocalPlayer.Character
            RA.Part0 = LocalPlayer.Character.Torso
            RA.Part1 = RightArm
            RA.C0 = CFrame.new(Vector3.new(1, 0.75, 0)) * CFrame.Angles(math.rad(70), math.rad(40), math.rad(10))
            RA.C1 = CFrame.new(Vector3.new(-0.5, 1, 0)) * CFrame.Angles(math.rad(0), math.rad(0), math.rad(0))
        end
        for i, v in pairs(Stuff.PlrHeld.Character:GetDescendants()) do
            if v:IsA("BasePart") then
                v.CanCollide = false 
            end
        end
        Stuff.PlrHeld.Character:FindFirstChildOfClass("Humanoid").PlatformStand = true
        if not Stuff.PlrHeld.Character.PrimaryPart:FindFirstChild("CFrameFix") then
            local bv = Instance.new("BodyVelocity")
            bv.Name = "CFrameFix"
            bv.Parent = Stuff.PlrHeld.Character.PrimaryPart
            bv.Velocity = Vector3.new(0, 0, 0)
        end
        Stuff.PlrHeld.Character:SetPrimaryPartCFrame(LocalPlayer.Character.PrimaryPart.CFrame + LocalPlayer.Character.PrimaryPart.CFrame.LookVector * LocalPlayer.Character.PrimaryPart.Size.Z)
    end
    game:GetService("RunService").Stepped:Wait()
until not (LocalPlayer and LocalPlayer.Character and Knife and Knife.Parent == LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") and LocalPlayer.Character:FindFirstChildOfClass("Humanoid").Health > 0)

if LA ~= nil then
    LA:Destroy()
    LA = nil
end

if RA ~= nil then
    RA:Destroy() 
    RA = nil
end

for i, v in pairs(Stuff.Events) do
    v:Disconnect() 
end

if LocalPlayer and LocalPlayer.Character and LocalPlayer.Character:FindFirstChildWhichIsA("Humanoid") then
    LocalPlayer.Character:FindFirstChildWhichIsA("Humanoid").Health = 0
end
