local _GetPlayers = game:GetService("Players")
local _GetMarket = game:GetService("MarketplaceService")
local Interface = game:GetObjects("rbxassetid://7841745482")[1]
Interface.CommandBar.Position = UDim2.new(0.5, -100, 1, 5)
Interface.CMDS.Position = UDim2.new(0.694, -75, 10, -105)
Interface.PluginBrowser.Position = UDim2.new(0.42, -75, 2, -105)
Interface.MainDragFrame.Position = UDim2.new(0.5, -200, 1.8, -125)
spawn(function()
	Interface.MainDragFrame.Main.Pages.Menu.Profile.Image = ("https://www.roblox.com/headshot-thumbnail/image?userId=" .. tostring(_GetPlayers.LocalPlayer.UserId) .. "&width=420&height=420&format=png")
	Interface.MainDragFrame.Main.Pages.Server.Game.Id.Text = tostring(game.PlaceId)
	Interface.MainDragFrame.Main.Pages.Server.Game.By.Text = ("By " .. '<font color="rgb(140, 144, 150)"><b>' .. tostring(_GetPlayers:GetNameFromUserIdAsync(game.CreatorId)) .. "</b></font>")
	Interface.MainDragFrame.Main.Pages.Server.Game.Title.Text = tostring(_GetMarket:GetProductInfo(game.PlaceId).Name)
	Interface.MainDragFrame.Main.Pages.Server.Game.Description.DescriptionFrame.Description.Text = tostring(_GetMarket:GetProductInfo(game.PlaceId).Description)
	Interface.MainDragFrame.Main.Pages.Server.Game.Thumbnail.Image = ("https://www.roblox.com/asset-thumbnail/image?assetId=" .. tostring(game.PlaceId) .. "&width=768&height=432&format=png")
	local _GetRandomMessage = loadstring(game:HttpGetAsync(("https://raw.githubusercontent.com/daximul/u9yh45/main/m/p.lua")))();
	if _GetRandomMessage:len() >= 70 then Interface.MainDragFrame.Main.Pages.Menu.Message.Title.TextScaled = true end
	Interface.MainDragFrame.Main.Pages.Menu.Message.Title.Text = _GetRandomMessage
	while wait(1) do
		Interface.MainDragFrame.Main.Pages.Server.Players.PlayersFrame.Players.Text = ('<font color="rgb(140, 144, 150)">' .. tostring(#_GetPlayers:GetPlayers()) .. '</font>/<font color="rgb(140, 144, 150)">' .. tostring(_GetPlayers.MaxPlayers) .. '</font>')
		Interface.MainDragFrame.Main.Pages.Server.ClientAge.ClientAgeFrame.ClientAge.Text = ('<font color="rgb(140, 144, 150)">' .. tostring(math.floor(workspace.DistributedGameTime / 60 / 60)) .. '</font> hr, <font color="rgb(140, 144, 150)">' .. tostring(math.floor(workspace.DistributedGameTime / 60)) .. '</font> m')
	end
end)
spawn(function()
	local tweenService = game:GetService("TweenService")
	local InterfaceTweeningDebounce = false
	local tweenColor = function(instance, rgb, t1me)
		local tweenGoals = {TextColor3 = rgb}
		local tweenInfo = TweenInfo.new(t1me, Enum.EasingStyle.Linear, Enum.EasingDirection.In)
		local tween = tweenService:Create(instance, tweenInfo, tweenGoals)
		tween:Play()
	end
	local tweenImageColor = function(instance, rgb, t1me)
		local tweenGoals = {ImageColor3 = rgb}
		local tweenInfo = TweenInfo.new(t1me, Enum.EasingStyle.Linear, Enum.EasingDirection.In)
		local tween = tweenService:Create(instance, tweenInfo, tweenGoals)
		tween:Play()
	end
	for i,v in pairs(Interface.MainDragFrame.Main.Menu:GetChildren()) do
		if v:IsA("TextButton") then
			v.MouseButton1Down:Connect(function()
				if InterfaceTweeningDebounce == true then return end
				InterfaceTweeningDebounce = true
				tweenColor(v.PageName, Color3.fromRGB(255, 255, 255), 0.2)
				tweenImageColor(v.Image, Color3.fromRGB(255, 255, 255), 0.2)
				for i2,v2 in pairs(Interface.MainDragFrame.Main.Menu:GetChildren()) do
					if (v2:IsA("TextButton")) and (v2 ~= v) then
						tweenColor(v2.PageName, Color3.fromRGB(208, 205, 201), 0.2)
						tweenImageColor(v2.Image, Color3.fromRGB(208, 205, 201), 0.2)
					end
				end
				InterfaceTweeningDebounce = false
			end)
		end
	end
end)
return Interface
