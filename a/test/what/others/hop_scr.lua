local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")

local BhopInfo = {
    CurrentVel = 0,
    VelCap = 3,
    JumpBoostAmt = 0.1
}

local RolvePatch = false
local RolvePlaces = {286090429, 301549746, 328028363, 4572253581, 746820961, 4292776423, 2182391396, 2609550642}

if table.find(RolvePlaces, game.PlaceId) then
  RolvePatch = true
else
  RolvePatch = false
end

local helper = {
    getChar = function()
        return Players.LocalPlayer.Character
    end
}

local function checkOnGround(char)
    local ray = Ray.new(char.HumanoidRootPart.Position,-(char.HumanoidRootPart.CFrame.UpVector * 100))
    local part, pos = workspace:FindPartOnRay(ray,char)
    
    if part then
        if pos then
            local farness = math.ceil((char.HumanoidRootPart.Position - pos).Magnitude)
            if farness > 3 then
                return false
            elseif farness <= 3 then
                return true
            end
        end
    end
end



UIS.JumpRequest:Connect(function()

    if (UIS:IsKeyDown(Enum.KeyCode.W) == false) and (UIS:IsKeyDown(Enum.KeyCode.A) or UIS:IsKeyDown(Enum.KeyCode.D)) == true and BhopInfo.CurrentVel < BhopInfo.VelCap then
        BhopInfo.CurrentVel = BhopInfo.CurrentVel + BhopInfo.JumpBoostAmt
    end
end)

local char = helper.getChar()

char.Humanoid.StateChanged:Connect(function(oldstate,newstate)
    if newstate == Enum.HumanoidStateType.Landed then
        char.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Jumping,true)
    end
end)

spawn(function()
    while true do
        local char = helper.getChar()
    
        if checkOnGround(char) == false and BhopInfo.CurrentVel ~= 0 then
            char.HumanoidRootPart.CFrame = char.HumanoidRootPart.CFrame + (char.HumanoidRootPart.CFrame.LookVector * BhopInfo.CurrentVel/6)
        end

        if UIS:IsKeyDown(Enum.KeyCode.Space) == false then
            BhopInfo.CurrentVel = 0
        elseif UIS:IsKeyDown(Enum.KeyCode.Space) == true and UIS:IsKeyDown(Enum.KeyCode.W) then
            BhopInfo.CurrentVel = math.clamp(BhopInfo.CurrentVel - 0.01, 0, BhopInfo.VelCap)
        elseif UIS:IsKeyDown(Enum.KeyCode.Space) == true then
            if RolvePatch == true then char.Humanoid.Jump = true end
        end

        game:GetService("RunService").Stepped:Wait()
    end
end)
