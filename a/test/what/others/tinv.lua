local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Char  = LocalPlayer.Character
local touched = false
local tpdback = false
LocalPlayer.CharacterAdded:connect(function(char)
    if script.Disabled ~= true then
        wait(0.25)
        loc = Char.HumanoidRootPart.Position
        Char:MoveTo(box.Position + Vector3.new(0, 0.5, 0))
    end
end)
box = Instance.new("Part", workspace)
box.Anchored = true
box.CanCollide = true
box.Size = Vector3.new(10, 1, 10)
box.Position = Vector3.new(0, 10000, 0)
box.Touched:connect(function(part)
    if (part.Parent.Name == Local.Name) then
        if touched == false then
            touched = true
            function apply()
                if script.Disabled ~= true then
                    no = Char.HumanoidRootPart:Clone()
                    wait(0.25)
                    Char.HumanoidRootPart:Destroy()
                    no.Parent = Char
                    Char:MoveTo(loc)
                    touched = false
                end end
            if Char then
                apply()
            end
        end
    end
end)
repeat wait() until Char
loc = Char.HumanoidRootPart.Position
Char:MoveTo(box.Position + Vector3.new(0, 0.5, 0))
