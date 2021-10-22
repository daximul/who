local _GetPlayers = game:GetService("Players")
local _GetMarket = game:GetService("MarketplaceService")
local Interface = game:GetObjects("rbxassetid://7655239104")[1]
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
	local _GetRandomMessage = loadstring(game:HttpGetAsync(("https://raw.githubusercontent.com/daximul/randompost/main/random_phrase.lua")))();
	if _GetRandomMessage:len() >= 70 then Interface.MainDragFrame.Main.Pages.Menu.Message.Title.TextScaled = true end
	Interface.MainDragFrame.Main.Pages.Menu.Message.Title.Text = _GetRandomMessage
	while wait(1) do
		Interface.MainDragFrame.Main.Pages.Server.Players.PlayersFrame.Players.Text = ('<font color="rgb(140, 144, 150)">' .. tostring(#_GetPlayers:GetPlayers()) .. '</font>/<font color="rgb(140, 144, 150)">' .. tostring(_GetPlayers.MaxPlayers) .. '</font>')
		Interface.MainDragFrame.Main.Pages.Server.ClientAge.ClientAgeFrame.ClientAge.Text = ('<font color="rgb(140, 144, 150)">' .. tostring(math.floor(workspace.DistributedGameTime / 60 / 60)) .. '</font> hr, <font color="rgb(140, 144, 150)">' .. tostring(math.floor(workspace.DistributedGameTime / 60)) .. '</font> m')
	end
end)
return Interface
