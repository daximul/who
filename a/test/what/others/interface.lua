local Interface = game:GetObjects("rbxassetid://6748093164")[1]
Interface.Main.Position = UDim2.new(0.5, -100, 1, 5)
Interface.NotificationTemplate.Position = UDim2.new(-1, -75, 1.029, -105)
Interface.CMDS.Position = UDim2.new(0.694, -75, 10, -105)
Interface.PluginBrowser.Position = UDim2.new(0.42, -75, 2, -105)
Interface.DaUi.Position = UDim2.new(0.42, -75, 2, -105)
Interface.Assets.CmdFrame:Clone().Parent = Interface.DaUi.CmdFrames
Interface.Assets.CommandTemplate.Label.TextScaled = true
Interface.Tooltip.Title.TextScaled = true
Interface.Tooltip.Border.Frame.Description.TextScaled = true
Interface.Main.Box.Text = ""
Interface.Main.cmdsu.Text = ""
return Interface
