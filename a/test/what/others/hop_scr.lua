local BHOP = {}

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local ScriptEnabled = false
local RolvePatch = false

local BhopInfo = {
	CurrentVel = 0,
	VelCap = 3,
	JumpBoostAmt = 0.1
}

if game.CreatorType == Enum.CreatorType.Group then
	local Group = game:GetService("GroupService"):GetGroupInfoAsync(game.CreatorId)
	if Group.Name == "ROLVe Community" then
		RolvePatch = true
	end
end

local function CheckOnGround(char)
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

UserInputService.JumpRequest:Connect(function()
	if ScriptEnabled == true then
		if (UserInputService:IsKeyDown(Enum.KeyCode.W) == false) and (UserInputService:IsKeyDown(Enum.KeyCode.A) or UserInputService:IsKeyDown(Enum.KeyCode.D)) == true and BhopInfo.CurrentVel < BhopInfo.VelCap then
			BhopInfo.CurrentVel = BhopInfo.CurrentVel + BhopInfo.JumpBoostAmt
		end
	end
end)

Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid").StateChanged:Connect(function(oldstate, newstate)
	if ScriptEnabled == true then
		if newstate == Enum.HumanoidStateType.Landed then
			Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):SetStateEnabled(Enum.HumanoidStateType.Jumping, true)
		end
	end
end)

spawn(function()
	while true do
		if ScriptEnabled == true then
			if CheckOnGround(Players.LocalPlayer.Character) == false and BhopInfo.CurrentVel ~= 0 then
				Players.LocalPlayer.Character.HumanoidRootPart.CFrame = Players.LocalPlayer.Character.HumanoidRootPart.CFrame + (Players.LocalPlayer.Character.HumanoidRootPart.CFrame.LookVector * BhopInfo.CurrentVel/6)
			end
			
			if UserInputService:IsKeyDown(Enum.KeyCode.Space) == false then
				BhopInfo.CurrentVel = 0
			elseif UserInputService:IsKeyDown(Enum.KeyCode.Space) == true and UserInputService:IsKeyDown(Enum.KeyCode.W) then
				BhopInfo.CurrentVel = math.clamp(BhopInfo.CurrentVel - 0.01,0,BhopInfo.VelCap)
			elseif UserInputService:IsKeyDown(Enum.KeyCode.Space) == true then
				if RolvePatch == true then Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid").Jump = true end
			end
		end
		game:GetService("RunService").Stepped:Wait()
	end
end)

function BHOP:Start()
	ScriptEnabled = true
end

function BHOP:Stop()
	ScriptEnabled = false
end

return BHOP
