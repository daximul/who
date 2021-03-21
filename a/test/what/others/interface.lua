local Interface = game:GetObjects("rbxassetid://6550967663")[1]
Interface.Assets.CmdFrame:Clone().Parent = Interface.DaUi.CmdFrames
Interface.Assets.CommandTemplate.Label.TextScaled = true
Interface.Tooltip.Title.TextScaled = true
Interface.Tooltip.Border.Frame.Description.TextScaled = true
return Interface
