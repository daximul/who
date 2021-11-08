local Plugin = {}

Plugin.PluginName = "Head Pet"
Plugin.PluginDescription = ""
Plugin.Commands = {}

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local HeadFollowLoop = nil
local CollisionsSpoofed = {}

Plugin.Commands["headfollow"] = {
	["ListName"] = ("headfollow / headpet [plr]"),
	["Description"] = ("Make your head follow a player"),
	["Aliases"] = {"headpet"},
	["Function"] = function(args, speaker)
		if not args[1] then return end
		local users = getPlayer(args[1], speaker)
		if #users == 1 then
			for i4,v4 in pairs(users) do
				if (Players[v4] ~= Players.LocalPlayer) and (Players[v4].Character ~= nil) then
					local Target = Players[v4]
					local plrs = Players
					local lp = plrs.LocalPlayer
					local c = lp.Character
					local rs = game:GetService("RunService")
					local sg = game:GetService("StarterGui")
					local uis = game:GetService("UserInputService")
					local uc = function(p)
						spawn(function()
							CollisionsSpoofed[randomString()] = rs.RenderStepped:Connect(function()
								if p and p.Parent then
									Prote.SpoofProperty(p, "CanCollide")
									p.CanCollide = false
								end
							end)
						end)
					end
					if c and c.Parent then
						local ch = c:FindFirstChildWhichIsA("Humanoid")
						if ch and (ch.Health ~= 0) then
							local fc = Instance.new("Model")
							Prote.ProtectInstance(fc)
							fc.Parent = workspace
							local hed = Instance.new("Part")
							Prote.ProtectInstance(hed)
							hed.Parent = fc
							hed.Transparency = 1
							hed.Name = "Head"
							uc(hed)
							local tor = Instance.new("Part")
							Prote.ProtectInstance(tor)
							tor.Parent = fc
							tor.Transparency = 1
							tor.Name = "Torso"
							uc(tor)
							local nh = Instance.new("Humanoid")
							Prote.ProtectInstance(nh)
							nh.Parent = fc
							lp.Character = fc
							local gh = nh:Clone()
							Prote.ProtectInstance(gh)
							gh.Parent = fc
							nh:Destroy()
							gh.Health = 0 
							lp.Character = c
							fc:Destroy()
							wait(6)
							if c and c.Parent and ch and ch.Parent and (ch.Health ~= 0) then
								local hed = c:FindFirstChild("Head")
								if hed and (hed:IsA("Part") or hed:IsA("MeshPart")) then
									uc(hed)
									for i, v in pairs(c:GetChildren()) do
										if not ((v == hed) or v:IsA("Humanoid")) then
											v:Destroy()
										end
									end

									local bg = Instance.new("BodyGyro")
									Prote.ProtectInstance(bg)
									bg.Parent = hed
									bg.D = 50
									bg.P = 200
									bg.MaxTorque = Vector3.new(9e9, 9e9, 9e9)

									local bp = Instance.new("BodyPosition")
									Prote.ProtectInstance(bp)
									bp.Parent = hed
									bp.D = 50
									bp.P = 200
									bp.MaxForce = Vector3.new(9e9, 9e9, 9e9)

									HeadFollowLoop = rs.RenderStepped:Connect(function()
										if ch and ch.Parent and hed and hed.Parent and bp and bp.Parent and bg and bg.Parent then
											local c1 = Target
											if c1 then
												c1 = c1.Character
												if c1 and c1.Parent then
													c1 = c1:FindFirstChild("Head")
													if c1 and (c1:IsA("Part") or c1:IsA("MeshPart")) then
														bp.Position = (c1.CFrame * CFrame.new(2, 2, 2)).Position
														bg.CFrame = c1.CFrame
													end
												end
											end
										end
									end)
								end
							end
						end
					end
				end
			end
		end
	end
}

Plugin.Commands["unheadfollow"] = {
	["ListName"] = ("unheadfollow / unheadpet"),
	["Description"] = ("Stop making your head follow a player"),
	["Aliases"] = {"unheadpet"},
	["Function"] = function(args, speaker)
		if HeadFollowLoop ~= nil then
			HeadFollowLoop:Disconnect()
			HeadFollowLoop = nil
			for i,v in pairs(CollisionsSpoofed) do
				v:Disconnect()
				v = nil
			end
			wait(0.5)
			execCmd("respawn")
		end
	end
}

return Plugin
